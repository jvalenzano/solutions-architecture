# update-diagrams.ps1

# Check for PlantUML
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Write-Error "Java is required for PlantUML but was not found"
    exit 1
}

# Update function
function Update-Diagram {
    param (
        [string],
        [string]
    )

     = [System.IO.Path]::GetFileNameWithoutExtension()
     = "../rendered/png/.png"
     = "../rendered/svg/.svg"

    Write-Output "Updating ..."

    # Add commands to generate PNG and SVG using PlantUML
    # Note: Replace with actual PlantUML command for your environment
    # plantuml -tpng  -o 
    # plantuml -tsvg  -o 
}

# Process all diagram source files
Get-ChildItem -Path "c4-models/source","sequence/source" -Filter "*.puml" -Recurse |
    ForEach-Object {
        Update-Diagram -SourceFile .FullName -Category .Directory.Name
    }

Write-Output "Diagram update complete!"
