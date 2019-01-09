Function Get-DirectoryFilesQueue{
param([Parameter(Mandatory = $true, Position = 0)][string]$path)
$testqueue = New-Object -Type System.Collections.Queue
$rootpath = [System.IO.DirectoryInfo]$path
$filecount = 0
$testqueue.Enqueue($rootpath)
while($testqueue.Count -gt 0){
    $current = $testqueue.Dequeue()
    try{
        foreach($file in $current.EnumerateFiles()){
            Write-Host $file.FullName
            $filecount +=1
        }
    }
    catch [System.UnauthorizedAccessException]{
    }
    try{
        foreach($dir in $current.EnumerateDirectories()){
    
            $testqueue.Enqueue($dir)
        }
    }
    catch [System.UnauthorizedAccessException]{
    
    }
}
Write-Host "Number of files:$filecount"
}

Get-DirectoryFilesQueue -path "C:\"