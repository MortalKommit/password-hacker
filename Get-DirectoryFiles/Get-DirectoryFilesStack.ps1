Function Get-DirectoryFilesStack{
param([Parameter(Mandatory = $true, Position = 0)][string]$path)
$pending = New-Object -Type System.Collections.Stack
$rootpath = [System.IO.DirectoryInfo]$path
$filecount = 0
$pending.Push($rootpath)
while($pending.Count -gt 0){
    $current = [System.IO.DirectoryInfo]$pending.Pop()
     $current=
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
                $file
                $filecount +=1
            }
            catch [System.UnauthorizedAccessException]{
                 $error
            }
        }
}
 #"Number of files: $filecount"
}

