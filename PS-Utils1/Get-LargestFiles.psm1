Import-Module -Force "D:\Projects\Other\developerbase\Get-DirectoryFiles\Get-DirectoryFilesQueue.psm1"

Function Get-LargestFiles{
param([Parameter(Mandatory = $true, Position = 0)][string]$directory,
[string]$searchpattern = "*",
[System.Management.Automation.SwitchParameter]$recurse)
if(!(Test-Path $directory)){
    Write-Host "The path $directory is inaccessible"
}
else{
Get-DirectoryFilesQueue -path $directory -recurse | 
 Sort-Object -Property Length -Descending | 
 % {$_.FullName + "  " + [int64]($_.Length/1MB) + "MB " 
}
}
#gci -File H:\ -Recurse | Sort-Object -Property Length -Descending | % {$_.FullName + "  " + [int64]($_.Length/1MB) + "MB " + ($count += 1)} 
#$coun
#% {[int]($_.Length/1KB) + "  " + $_.FullName}
}
