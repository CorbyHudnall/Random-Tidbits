$originDirectory = "C:\some\origin\folder\"
$backupTargetDir = "C:\duplicates\"

Get-ChildItem $originDirectory -File -Attributes !S+!H -Recurse | 
    # Sort by LastWriteTime
    Sort-Object LastWriteTime | 
    # Group by Name, Length
    Group-Object Name, Length | 
    # Only Duplicate groups
    Where-Object { $_.Count -gt 1 } |
    # Select the duplicates
    Foreach-Object { $_.Group[1..1000] } | 
    # Move the file to the new consolidated location
    ForEach-Object {
        # Create new path
        $targetFullPath = $_.FullName.Replace($originDirectory, $backupTargetDir);
        $targetDir = $targetFullPath.TrimEnd($_.Name)

        if (-not([System.IO.Directory]::Exists($targetDir))) {
            [System.IO.Directory]::CreateDirectory($targetDir)
        }

        # Move the original file to the new location
        $_.MoveTo($targetFullPath)
        #$targetFullPath
}
