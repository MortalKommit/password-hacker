using assembly System.Web.Extensions;
Import-Module "$PSScriptRoot\Get-DirectoryFiles\Get-DirectoryFilesQueue.psm1" -Force

$path = "H:\"
$rootfolder = [System.IO.DirectoryInfo]$path
$serializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new()
$filedisk = "H:\reverse_this\data.json"


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
    $writer.Write([char]"[")    
    foreach($file in Get-DirectoryFilesQueue -path $path){
    
        $file_metadata = [FileInfoSerializable]::new($file)
        $json_data = $serializer.Serialize($file_metadata)
        $writer.Write($json_data + [char]",")
    }
    $writer.Flush()
    
    $filestream.Seek(-1,[System.IO.SeekOrigin]::Current)
    $filestream.Write([char]"]",0,1) | Out-Null
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