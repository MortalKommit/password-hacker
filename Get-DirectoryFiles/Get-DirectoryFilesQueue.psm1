Set-Alias -Name gdfq -Value Get-DirectoryFilesQueue
Function Get-DirectoryFilesQueue{
param([Parameter(Mandatory = $true, Position = 0)][string]$path,
[System.Management.Automation.SwitchParameter]$recurse,
[System.Management.Automation.SwitchParameter]$files,
[System.Management.Automation.SwitchParameter]$directory)
$processingqueue = New-Object -Type System.Collections.Queue
$rootpath = [System.IO.DirectoryInfo]$path
$filecount = 0
$processingqueue.Enqueue($rootpath)
if(-not $recurse.IsPresent){
    try{
        if(-not $directory.IsPresent){
            foreach($file in ($processingqueue.Dequeue()).EnumerateFiles()){
                if(($file.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                    $file
                }
            }
        }
        else{
            foreach($dir in ($processingqueue.Dequeue()).EnumerateDirectories()){
                #Avoid iterating over system files
                if((($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System) -and 
                #Avoid iterating over reparse points
                    ($dir.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne [System.IO.FileAttributes]::ReparsePoint){
                    $dir
                }
            }
        }    
    }
    catch [System.UnauthorizedAccessException]{
        $error
    }
}
else{
    while($processingqueue.Count -gt 0){
        $current = $processingqueue.Dequeue()
        if(-not $directory.IsPresent){
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
                    if(($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System -and
                       ($dir.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne [System.IO.FileAttributes]::ReparsePoint){
                        $processingqueue.Enqueue($dir)
                    }
                }
            }
            catch [System.UnauthorizedAccessException]{
                $error
            }
        }
        else{
            $current = $processingqueue.Dequeue()
            $current    
             try{
                foreach($dir in $current.EnumerateDirectories()){
                   if(($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System -and
                       ($dir.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne [System.IO.FileAttributes]::ReparsePoint){
                        $processingqueue.Enqueue($dir)
                    }
                }
            }
            catch [System.UnauthorizedAccessException]{
                $error
            }   
        }
    }
}
}