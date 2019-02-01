Function Get-DirectoryFiles{
param([Parameter(Mandatory=$true,Position = 0)][string]$path)
$folder = [System.IO.DirectoryInfo]$path
$filecount = 0
$size = [long]0
    try{
    
        foreach($file in $folder.EnumerateFiles("*.*")){

            try{
                $file
            }
            catch [System.UnauthorizedAccessException]{
                Write-Host $error
            }
        }
    
        foreach($subfolder in $folder.EnumerateDirectories()){
            try{
                foreach($file in $subfolder.EnumerateFiles("*.*", [System.IO.SearchOption]"AllDirectories")){
                    try{
                        $file
                    }
                    catch [System.UnauthorizedAccessException]{
                        Write-Host $error
                    }
                }
            }
            catch [System.UnauthorizedAccessException]{
                    Write-Host $error
            }
        }
    }
    catch [System.UnauthorizedAccessException]{
        Write-Host $error
    }
}

    