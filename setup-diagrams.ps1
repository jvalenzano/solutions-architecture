# setup-diagrams.ps1

# 1. Create Directory Structure
$diagramDirs = @(
    "use-cases/fs-chatbot/diagrams/c4-models/source",
    "use-cases/fs-chatbot/diagrams/c4-models/rendered/png",
    "use-cases/fs-chatbot/diagrams/c4-models/rendered/svg",
    "use-cases/fs-chatbot/diagrams/sequence/source",
    "use-cases/fs-chatbot/diagrams/sequence/rendered/png",
    "use-cases/fs-chatbot/diagrams/sequence/rendered/svg"
)

Write-Output "Creating directory structure..."
foreach ($dir in $diagramDirs) {
    New-Item -ItemType Directory -Force -Path $dir
    Write-Output "Created: $dir"
}

# 2. Create Documentation Templates
$diagramTypes = @{
    "system-context"   = @{
        level       = "L1"
        description = "System Context diagram showing the chatbot system in relation to its users and external systems"
        category    = "c4-models"
    }
    "container"        = @{
        level       = "L2"
        description = "Container diagram showing the high-level technical components of the system"
        category    = "c4-models"
    }
    "data-integration" = @{
        level       = "L3"
        description = "Component diagram focusing on the data integration container"
        category    = "c4-models"
    }
    "trail-status"     = @{
        level       = "sequence"
        description = "Sequence diagram showing the trail status inquiry flow"
        category    = "sequence"
    }
    "deployment"       = @{
        level       = "L4"
        description = "Deployment diagram mapping software components to infrastructure"
        category    = "c4-models"
    }
}

Write-Output "Creating documentation templates..."
foreach ($diagram in $diagramTypes.Keys) {
    $info = $diagramTypes[$diagram]
    $docPath = "use-cases/fs-chatbot/diagrams/$($info.category)/source/$diagram.md"

    @"
# $($diagram.ToUpper()) Diagram

## Level: $($info.level)
## Category: $($info.category)

## Description
$($info.description)

## Key Elements
- [List key elements shown in the diagram]

## Relationships
- [Describe important relationships]

## Notes
- [Additional implementation notes]

## Change History
| Date | Author | Description |
|------|--------|-------------|
| $(Get-Date -Format "yyyy-MM-dd") | [Your Name] | Initial version |
"@ | Out-File -FilePath $docPath -Encoding utf8
    Write-Output "Created template: $docPath"
}

# 3. Create README
@"
# Architecture Diagrams

## Overview
This directory contains the architectural diagrams for the Forest Service Chatbot system.

## Directory Structure
- \`c4-models/\`: C4 model diagrams (Context, Container, Component)
  - \`source/\`: PlantUML source files
  - \`rendered/png/\`: PNG format diagrams
  - \`rendered/svg/\`: SVG format diagrams
- \`sequence/\`: Sequence diagrams
  - \`source/\`: PlantUML source files
  - \`rendered/png/\`: PNG format diagrams
  - \`rendered/svg/\`: SVG format diagrams

## Diagram Types
$(foreach ($diagram in $diagramTypes.Keys) {
    $info = $diagramTypes[$diagram]
    "### $($diagram.ToUpper()) ($($info.level))
- Category: $($info.category)
- Purpose: $($info.description)
- Source: \`$($info.category)/source/$diagram.puml\`
- Rendered: \`$($info.category)/rendered/[png|svg]/$diagram.[png|svg]\`
"
})

## Updating Diagrams
1. Modify the source .puml file in the appropriate source directory
2. Run the update-diagrams.ps1 script to regenerate renders
3. Commit both source and rendered versions

## Tools
- PlantUML is required for diagram generation
- VS Code with PlantUML extension recommended for editing
"@ | Out-File -FilePath "use-cases/fs-chatbot/diagrams/README.md" -Encoding utf8

# 4. Create Update Script
@"
# update-diagrams.ps1

# Check for PlantUML
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Error "Java is required for PlantUML but was not found"
    exit 1
}

# Update function
function Update-Diagram {
    param (
        [string]$SourceFile,
        [string]$Category
    )

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
    $pngPath = "../rendered/png/$baseName.png"
    $svgPath = "../rendered/svg/$baseName.svg"

    Write-Output "Updating $baseName..."

    # Add commands to generate PNG and SVG using PlantUML
    # Note: Replace with actual PlantUML command for your environment
    # plantuml -tpng $SourceFile -o $pngPath
    # plantuml -tsvg $SourceFile -o $svgPath
}

# Process all diagram source files
Get-ChildItem -Path "c4-models/source","sequence/source" -Filter "*.puml" -Recurse |
    ForEach-Object {
        Update-Diagram -SourceFile $_.FullName -Category $_.Directory.Name
    }

Write-Output "Diagram update complete!"
"@ | Out-File -FilePath "use-cases/fs-chatbot/diagrams/update-diagrams.ps1" -Encoding utf8

Write-Output "Setup complete! Next steps:"
Write-Output "1. Copy your existing PNG/SVG files to the appropriate rendered directories"
Write-Output "2. Copy your PlantUML source files to the source directories"
Write-Output "3. Update the documentation templates with specific information"
Write-Output "4. Run update-diagrams.ps1 to verify the workflow"
