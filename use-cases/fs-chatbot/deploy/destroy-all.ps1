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
