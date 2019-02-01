Import-Module "$PSScriptRoot\Get-DirectoryFilesQueue.ps1"

$producer_job = { 
        Get-DirectoryFilesQueue "C:\"
}

#Start-Job $producer_job -InitializationScript { Import-Module "D:\Projects\Other\developerbase\Get-DirectoryFiles\Get-DirectoryFilesQueue.ps1"}


Get-Job -Id 7 | %{$_.Childjobs[0].IsAsync}
