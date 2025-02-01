# generate-tree.ps1

function Write-TreeNode {
    param (
        [string]$Path,
        [string]$Indent = "",
        [string]$LastIndent = ""
    )

    $items = Get-ChildItem -Path $Path
    $count = $items.Count
    $current = 0

    foreach ($item in $items) {
        $current++
        $isLast = ($current -eq $count)

        # Skip .git directory and other hidden files
        if ($item.Name -like ".*") {
            continue
        }

        # Determine prefix symbols
        $nodeSymbol = if ($isLast) { "`--" } else { "|--" }
        $newIndent = if ($isLast) { "    " } else { "|   " }

        # Write the current node
        "$LastIndent$nodeSymbol$($item.Name)" | Out-File -FilePath "tree.txt" -Append -Encoding utf8

        # Recurse for directories
        if ($item.PSIsContainer) {
            Write-TreeNode -Path $item.FullName -Indent "$Indent$newIndent" -LastIndent "$LastIndent$newIndent"
        }
    }
}

# Clear or create the tree.txt file
"solutions-architecture/" | Out-File -FilePath "tree.txt" -Encoding utf8

# Generate the tree structure
Write-TreeNode -Path "." -LastIndent ""

Write-Output "Tree structure has been generated in tree.txt"

# Read and display the content
Get-Content -Path "tree.txt"
