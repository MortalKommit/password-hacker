Function Get-DirectoryFilesStack{
param([Parameter(Mandatory = $true, Position = 0)][string]$path,
[Parameter(Position = 1)][string][System.Management.Automation.SwitchParameter]$recurse)
$pending = New-Object -Type System.Collections.Stack
$rootpath = [System.IO.DirectoryInfo]$path
$pending.Push($rootpath)
if(-not $recurse.IsPresent){
    $current = [System.IO.DirectoryInfo]$pending.Pop()
    try{
        foreach($file in $current.EnumerateFiles()){
            if(($file.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                $file
            }
        }
        foreach($dir in $current.EnumerateDirectories()){
            if((($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System) -and 
            #Avoid iterating over reparse points
                ($dir.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne [System.IO.FileAttributes]::ReparsePoint){
                $dir
            }
        }
    }
    catch [System.UnauthorizedAccessException]{
        $error
    }
}
else{
    while($pending.Count -gt 0){
        $current = [System.IO.DirectoryInfo]$pending.Pop()
        foreach($file in $current.EnumerateFiles('*.*')){
            try{
                if(($file.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                    $file
                }
            }
            catch [System.UnauthorizedAccessException]{
                 $error
            }
        }
        foreach($dir in $current.EnumerateDirectories()){
            try{
                if(($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System -and
                    ($dir.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne [System.IO.FileAttributes]::ReparsePoint){
                    $pending.Push($dir)
                }
            }
            catch [System.UnauthorizedAccessException]{
                 $error
            }
        }
    }
}
}