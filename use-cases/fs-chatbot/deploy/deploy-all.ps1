# deploy/deploy-all.ps1

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment,

    [Parameter(Mandatory = $true)]
    [string]$ProjectId,

    [Parameter(Mandatory = $true)]
    [string]$Region
)

# Configuration Variables
$CONFIG_DIR = "../configurations"
$TERRAFORM_DIR = "$CONFIG_DIR/terraform"
$TIMESTAMP = Get-Date -Format "yyyyMMdd-HHmmss"
$LOG_FILE = "deployment-$Environment-$TIMESTAMP.log"

# Logging function
function Write-Log {
    param($Message)
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $Message"
    Write-Host $logMessage
    Add-Content -Path $LOG_FILE -Value $logMessage
}

# Error handling function
function Handle-Error {
    param($ErrorMessage)
    Write-Log "ERROR: $ErrorMessage"
    throw $ErrorMessage
}

# Validate GCP authentication
function Validate-GCPAuth {
    try {
        Write-Log "Validating GCP authentication..."
        $auth = gcloud auth list --format="value(account)" 2>&1
        if (-not $auth) {
            Handle-Error "Not authenticated with GCP. Please run 'gcloud auth login' first."
        }
        Write-Log "Authenticated as: $auth"
    }
    catch {
        Handle-Error "GCP authentication validation failed: $_"
    }
}

# Initialize Terraform
function Initialize-Terraform {
    try {
        Write-Log "Initializing Terraform..."
        Push-Location $TERRAFORM_DIR
        terraform init -backend-config="bucket=$ProjectId-terraform-state" `
            -backend-config="prefix=$Environment"
        if ($LASTEXITCODE -ne 0) {
            Handle-Error "Terraform initialization failed"
        }
        Pop-Location
    }
    catch {
        Pop-Location
        Handle-Error "Terraform initialization failed: $_"
    }
}

# Deploy Infrastructure with Terraform
function Deploy-Infrastructure {
    try {
        Write-Log "Deploying infrastructure with Terraform..."
        Push-Location $TERRAFORM_DIR

        # Create terraform.tfvars
        @"
project_id = "$ProjectId"
environment = "$Environment"
region = "$Region"
"@ | Out-File -FilePath "terraform.tfvars" -Encoding UTF8

        # Plan
        Write-Log "Creating Terraform plan..."
        terraform plan -out=tfplan
        if ($LASTEXITCODE -ne 0) {
            Handle-Error "Terraform plan failed"
        }

        # Apply
        Write-Log "Applying Terraform plan..."
        terraform apply tfplan
        if ($LASTEXITCODE -ne 0) {
            Handle-Error "Terraform apply failed"
        }

        Pop-Location
    }
    catch {
        Pop-Location
        Handle-Error "Infrastructure deployment failed: $_"
    }
}

# Deploy DialogFlow CX Configuration
function Deploy-DialogFlow {
    try {
        Write-Log "Deploying DialogFlow CX configuration..."
        $config = Get-Content "$CONFIG_DIR/dialogflow/dialogflow-cx-config.yaml" -Raw
        $config = $config.Replace('${PROJECT_ID}', $ProjectId)

        # Create or update agent
        gcloud dialogflow cx agents create `
            --display-name="Forest-Service-Chatbot-$Environment" `
            --location=$Region `
            --config="$CONFIG_DIR/dialogflow/dialogflow-cx-config.yaml"
    }
    catch {
        Handle-Error "DialogFlow deployment failed: $_"
    }
}

# Deploy Cloud Functions
function Deploy-CloudFunctions {
    try {
        Write-Log "Deploying Cloud Functions..."
        gcloud functions deploy data-integration `
            --runtime=python39 `
            --trigger-http `
            --region=$Region `
            --project=$ProjectId `
            --env-vars-file="$CONFIG_DIR/functions/function-config.yaml"
    }
    catch {
        Handle-Error "Cloud Functions deployment failed: $_"
    }
}

# Setup Monitoring
function Setup-Monitoring {
    try {
        Write-Log "Setting up monitoring..."

        # Create dashboard
        gcloud monitoring dashboards create `
            --config-from-file="$CONFIG_DIR/monitoring/monitoring-config.yaml"

        # Create alert policies
        gcloud alpha monitoring policies create `
            --policy-from-file="$CONFIG_DIR/monitoring/monitoring-config.yaml"
    }
    catch {
        Handle-Error "Monitoring setup failed: $_"
    }
}

# Main deployment workflow
try {
    Write-Log "Starting deployment for environment: $Environment"

    # Validate prerequisites
    Validate-GCPAuth

    # Set GCP project
    Write-Log "Setting GCP project to: $ProjectId"
    gcloud config set project $ProjectId

    # Deploy in sequence
    Initialize-Terraform
    Deploy-Infrastructure
    Deploy-DialogFlow
    Deploy-CloudFunctions
    Setup-Monitoring

    Write-Log "Deployment completed successfully!"
}
catch {
    Write-Log "Deployment failed: $_"
    exit 1
}

# deploy/destroy-all.ps1 (for cleanup)
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment,

    [Parameter(Mandatory = $true)]
    [string]$ProjectId
)

try {
    Write-Log "Starting cleanup for environment: $Environment"

    # Destroy Terraform resources
    Push-Location $TERRAFORM_DIR
    terraform destroy -auto-approve
    Pop-Location

    # Clean up DialogFlow
    gcloud dialogflow cx agents delete "Forest-Service-Chatbot-$Environment" `
        --location=$Region `
        --quiet

    # Clean up Cloud Functions
    gcloud functions delete data-integration --region=$Region --quiet

    Write-Log "Cleanup completed successfully!"
}
catch {
    Write-Log "Cleanup failed: $_"
    exit 1
}
