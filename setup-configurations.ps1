# setup-configurations.ps1

# Create base directory structure
$configDirs = @(
    "use-cases/fs-chatbot/configurations/terraform",
    "use-cases/fs-chatbot/configurations/cloudbuild",
    "use-cases/fs-chatbot/configurations/dialogflow",
    "use-cases/fs-chatbot/configurations/functions",
    "use-cases/fs-chatbot/configurations/monitoring"
)

# Create directories
foreach ($dir in $configDirs) {
    New-Item -ItemType Directory -Force -Path $dir
    Write-Output "Created directory: $dir"
}

# Create Terraform configuration files
$terraformFiles = @{
    "network.tf" = $networkConfig
    "gke.tf" = $gkeConfig
    "cloud-run.tf" = $cloudRunConfig
    "redis.tf" = $redisConfig
    "iam.tf" = $iamConfig
}

foreach ($file in $terraformFiles.Keys) {
    $path = "use-cases/fs-chatbot/configurations/terraform/$file"
    New-Item -ItemType File -Force -Path $path
    Write-Output "Created Terraform config: $path"
}

# Create other configuration files
$otherConfigs = @{
    "cloudbuild/cloudbuild.yaml" = $cloudbuildConfig
    "dialogflow/dialogflow-cx-config.yaml" = $dialogflowConfig
    "functions/function-config.yaml" = $functionConfig
    "monitoring/monitoring-config.yaml" = $monitoringConfig
}

foreach ($file in $otherConfigs.Keys) {
    $path = "use-cases/fs-chatbot/configurations/$file"
    New-Item -ItemType File -Force -Path $path
    Write-Output "Created config: $path"
}

# Create README for configurations directory
$readmeContent = @"
# Forest Service Chatbot Configurations

This directory contains all configuration files for the Forest Service Chatbot GCP infrastructure.

## Directory Structure

- `terraform/`: Infrastructure as Code configurations
- `cloudbuild/`: Cloud Build pipeline configurations
- `dialogflow/`: DialogFlow CX configurations
- `functions/`: Cloud Functions configurations
- `monitoring/`: Monitoring and alerting configurations

## Usage

1. Configure required variables in terraform.tfvars
2. Initialize Terraform: `terraform init`
3. Plan deployment: `terraform plan`
4. Apply configuration: `terraform apply`

## Configuration Management

- All changes should go through PR review
- Use terraform fmt to format files
- Run terraform validate before commits
- Update documentation when adding new resources
"@

$readmePath = "use-cases/fs-chatbot/configurations/README.md"
$readmeContent | Out-File -FilePath $readmePath -Encoding utf8
Write-Output "Created README: $readmePath"

Write-Output "`nDirectory structure and configuration files created successfully!"
