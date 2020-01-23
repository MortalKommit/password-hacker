Function Clear-Directory($pathv){
    if(($pathv  | Get-ChildItem) -ne $null){
        Get-ChildItem $pathv | Remove-Item -Recurse -ErrorAction SilentlyContinue
    }
 }
Function Clear-Recent([string]$option=""){
    #Clear Jump Lists and Recent Places
    $recentpathautodest = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\"
    $recentpath = "$env:APPDATA\Microsoft\Windows\Recent\"
    $excludedfolders = "AutomaticDestinations","CustomDestinations"
    switch($option.ToLower().Trim()){
        "recent"{
                Get-ChildItem $recentpath -Exclude $excludedfolders | Remove-Item
                $7zcopyhistorykey = Get-Item -Path "HKCU:\Software\7-Zip\FM" 
                $7zpathhistorykey = Get-Item -Path "HKCU:\Software\7-Zip\Extraction"
                if($7zcopyhistorykey.GetValue("CopyHistory") -ne $null){
                    Remove-ItemProperty -Path "HKCU:\Software\7-Zip\FM" -Name "CopyHistory"
                }
                if($7zcopyhistorykey.GetValue("FolderHistory") -ne $null){
                    Remove-ItemProperty -Path "HKCU:\Software\7-Zip\FM" -Name "FolderHistory"
                }
                if($7zpathhistorykey.GetValue("PathHistory") -ne $null){
                    Remove-ItemProperty -Path "HKCU:\Software\7-Zip\Extraction" -Name "PathHistory"
                }
        }
        "list"{
                Get-ChildItem $recentpathautodest -Exclude $excludedfolders | Remove-Item
        }
        default{
                Get-ChildItem $recentpath -Exclude $excludedfolders | Remove-Item
                if(Test-Path $recentpathautodest){
                    Clear-Directory $recentpathautodest 
                }
                #Remove 7-zip recent copy path, browsed folder path and extract folder paths if present 
                $7zcopyhistorykey = Get-Item -Path "HKCU:\Software\7-Zip\FM" 
                $7zpathhistorykey = Get-Item -Path "HKCU:\Software\7-Zip\Extraction" 
                if($7zcopyhistorykey.GetValue("CopyHistory") -ne $null){
                    Remove-ItemProperty -Path "HKCU:\Software\7-Zip\FM" -Name "CopyHistory"
                }
                if($7zcopyhistorykey.GetValue("FolderHistory") -ne $null){
                    Remove-ItemProperty -Path "HKCU:\Software\7-Zip\FM" -Name "FolderHistory"
                }
                if($7zpathhistorykey.GetValue("PathHistory") -ne $null){
                    Remove-ItemProperty -Path "HKCU:\Software\7-Zip\Extraction" -Name "PathHistory"
                }
        }
    } 
}
Function Clear-Media([string]$option="", 
                     [System.Management.Automation.SwitchParameter]$vlc,
                     [System.Management.Automation.SwitchParameter]$windows
){
    <#Clear VLC recent files list
    Note that the replacement pattern either needs to be in single quotes ('') or have the
    $ signs of the replacement group specifiers escaped ("`$2 `$1").
    Further `n only works with double quotes(")
    #>

    if($vlc.IsPresent){
        #Get vlc path, clear lines if size < 20kb, otherwise delete file
        $vlcsettingspath = "$env:APPDATA\vlc\vlc-qt-interface.ini"
        if(Test-Path $vlcsettingspath){
            if((Get-Item $vlcsettingspath).Length/1KB -le 20){
                $content =  (Get-Content $vlcsettingspath) -join [Environment]::NewLine
                $content = $content -replace "(\[RecentsMRL\]\r\nlist=).*(\r\ntimes=).*\r\n", "`$1@Invalid()`$2@Invalid()`r`n"
                $content | Out-file $vlcsettingspath 
            }
            else{
                Remove-Item $vlcsettingspath
            }
        }    
    }
    if($windows.IsPresent){
        #Clear Windows Media Player file list
        $mediaplayerpath = "$env:localappdata\Microsoft\Media Player"
        Clear-Directory $mediaplayerpath
    }      
}
Function Clear-SearchPaths($option="",
[SystemSystem.Management.Automation.SwitchParameter]$search,
[SystemSystem.Management.Automation.SwitchParameter]$paths){
        if($search.IsPresent){
            #Clear Explorer Search Pane List
            Clear-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery
        }
        if($paths.IsPresent){
            #Clear Explorer Search Pane List
            Clear-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths\ 
        }
}
Function Clear-Run($option=$false){
#Clear Run Command History
    if($option){
        Clear-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU
    }
}
Function Clear-Temp([string]$option, 
                    [System.Management.Automation.SwitchParameter]$temp, 
                    [System.Management.Automation.SwitchParameter]$bin)
{
        #Clear %Temp%, $RECYCLE.BIN folders
        if($temp.IsPresent){
            Clear-Directory $env:temp
        }
        #Clear Recycle Bin - Requires Powershell 5.1
        if($bin.IsPresent){
             Clear-RecycleBin -Confirm:$false    
        }
}
Function Clear-IE($option=""){
    switch($option.ToLower().Trim()){
    
        default{
            #Delete Temporary Internet Files
            RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

            #Delete Cookies:
            RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2

            #Delete History:
            RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1

            #Delete Form Data:
            RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16

            #Delete Passwords:
            RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 32
        }
    }
}
Function Clear-Browser($option=""){

    switch($option.ToLower().Trim()){
        "firefox"{
          }
        "chrome"{
        }
        default{
        #Both firefox and chrome
        }
    }
}
Function Clear-RunHistory{
    param([System.Management.Automation.SwitchParameter]$browser,
    [System.Management.Automation.SwitchParameter]$media,
    [System.Management.Automation.SwitchParameter]$recent,
    [System.Boolean]$all = $true,
    [AllowNull()][string]$options = "cd")
$all = ($browser -or $media -or $recent) -xor $all    
if($browser.IsPresent){
    Clear-IE
}
if($media.IsPresent){
    Clear-Media -vlc -windows
}
if($recent.IsPresent){
    Clear-Recent
    Clear-SearchPaths -search -paths
    Clear-Run $true
    Clear-Temp -temp -bin
}
if($all){
    Clear-IE
    Clear-Media -vlc -windows
    Clear-Recent
    Clear-SearchPaths -search -paths
    Clear-Run
    Clear-Temp -temp -bin
}
}
