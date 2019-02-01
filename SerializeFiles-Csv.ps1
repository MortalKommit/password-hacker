using assembly System.Web.Extensions;
Import-Module "$PSScriptRoot\Get-DirectoryFiles\Get-DirectoryFilesQueue.psm1" -Force

$path = "C:\"
$rootfolder = [System.IO.DirectoryInfo]$path
$filedisk = "$env:userprofile\Downloads\data.csv"


class FileInfoSerializable{
[string]$Name;
[string] $FullName;
[long] $Length;
[Datetime] $LastWriteTime;
FileInfoSerializable(){}
FileInfoSerializable([System.IO.FileInfo]$parameterfileinfo){
    
    $this.Name = $parameterfileinfo.Name
    $this.FullName = $parameterfileinfo.FullName
    $this.Length = $parameterfileinfo.Length
    $this.LastWriteTime = $parameterfileinfo.LastWriteTime
}
}

if(Test-Path($filedisk)){
    #$filestream = [System.IO.File]::Open($filedisk,[System.IO.FileMode]::OpenOrCreate)
    $filestream = [System.IO.FileStream]::new($filedisk, [System.IO.FileMode]::Truncate, [System.IO.FileAccess]::Write)
}
else
{
    $filestream = [System.IO.File]::Create($filedisk)
    #[System.IO.FileStream]::new($filedisk, [System.IO.FileMode]::Truncate, [System.IO.FileAccess]::Write)
}
try{
    $writer =  [System.IO.StreamWriter]::new($filestream,[System.Text.Encoding]::UTF8,1024)
    foreach($file in Get-DirectoryFilesQueue -path $path){
        $file_metadata = [FileInfoSerializable]::new($file)
        $line = "`"{0}`",`"{1}`",{2},{3}" -f $file_metadata.Name,$file_metadata.FullName,$file_metadata.Length,$file_metadata.LastWriteTime
        $writer.WriteLine($line)
    }
    $writer.Flush()
    $filestream.Close()
}
catch{
    Write-Host "Exception:$error"
}
finally{
    if($filestream -ne $null){
        $filestream.Dispose()
    }
}
