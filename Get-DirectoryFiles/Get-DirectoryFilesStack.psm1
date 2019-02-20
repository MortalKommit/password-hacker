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
    }
    catch [System.UnauthorizedAccessException]{
        $error
    }
}
else{
    while($pending.Count -gt 0){
        $current = [System.IO.DirectoryInfo]$pending.Pop()
        foreach($dir in $current.EnumerateDirectories()){
            try{
                if(($dir.Attributes -band [System.IO.FileAttributes]::System) -ne [System.IO.FileAttributes]::System){
                    $pending.Push($dir)
                }
            }
            catch [System.UnauthorizedAccessException]{
                 $error
            }
        }
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
    }
}
}