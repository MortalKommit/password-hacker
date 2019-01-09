Function Get-DirectoryFiles{
param([Parameter(Mandatory=$true,Position = 0)][string]$path)
$folder = [System.IO.DirectoryInfo]$path
$filecount = 0
$size = [long]0
    try{
    
        foreach($file in $folder.EnumerateFiles("*.*")){

            try{
                Write-Host $file.FullName
                $filecount += 1
                $size += $file.Length
            }
            catch [System.UnauthorizedAccessException]{
                Write-Host "Exception"
            }
        }
    
        foreach($subfolder in $folder.EnumerateDirectories()){
            try{
                foreach($file in $subfolder.EnumerateFiles("*.*", [System.IO.SearchOption]"AllDirectories")){
                    try{
                        Write-Host $file.FullName
                        $filecount += 1
                        $size += $file.Length
                    }
                    catch [System.UnauthorizedAccessException]{
                        Write-Host "Exception"
                    }
                }
            }
            catch [System.UnauthorizedAccessException]{
                    Write-Host "Exception"
            }
        }
    }
    catch [System.UnauthorizedAccessException]{
        Write-Host "Exception"
    }
Write-Host "Files: $filecount Total size: $($size/1GB)"
}


Get-DirectoryFiles -path "C:\"
    