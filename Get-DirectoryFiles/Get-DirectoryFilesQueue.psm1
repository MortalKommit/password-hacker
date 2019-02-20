Function Get-DirectoryFilesQueue{
param([Parameter(Mandatory = $true, Position = 0)][string]$path,
[Parameter(Position = 1)][System.Management.Automation.SwitchParameter]$recurse)
$testqueue = New-Object -Type System.Collections.Queue
$rootpath = [System.IO.DirectoryInfo]$path
$filecount = 0
$testqueue.Enqueue($rootpath)
if(-not $recurse.IsPresent){
    try{
        foreach($file in ($testqueue.Dequeue()).EnumerateFiles()){
            if(($file.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                $file
            }
        }    
    }
    catch [System.UnauthorizedAccessException]{
        $error
    }
}
else{
    while($testqueue.Count -gt 0){
        $current = $testqueue.Dequeue()
        try{
            foreach($file in $current.EnumerateFiles()){
               if(($file.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                    $file
                }
            }
        }
        catch [System.UnauthorizedAccessException]{
            $error
        }
        try{
            foreach($dir in $current.EnumerateDirectories()){
            if(($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                $testqueue.Enqueue($dir)
            }
            }
        }
        catch [System.UnauthorizedAccessException]{
            $error
        }
    }
}
}
