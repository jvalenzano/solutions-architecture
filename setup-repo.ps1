# Check Git installation
Write-Output "Checking Git installation..."
$gitVersion = git --version
if (-not $?) {
    Write-Error "Git is not installed. Please install Git before running this script."
    exit 1
}

Write-Output "Git is installed: $gitVersion"

# Create base directories
$directories = @(
    "frameworks/templates",
    "frameworks/patterns",
    "frameworks/checklists",
    "use-cases/fs-chatbot/docs",
    "use-cases/fs-chatbot/diagrams",
    "use-cases/fs-chatbot/specifications",
    "standards/security",
    "standards/compliance",
    "standards/technologies",
    "tools/scripts",
    "tools/templates"
)

# Create directories
foreach ($dir in $directories) {
    Write-Output "Creating directory: $dir"
    New-Item -ItemType Directory -Force -Path $dir
}

# Initialize git
Write-Output "Initializing Git repository..."
git init

Write-Output "Setup complete!"