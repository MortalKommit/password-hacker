﻿Function Clear-Directory($pathv){
    if(($pathv  | gci) -ne $null){
        ls $pathv | Remove-Item -Recurse -ErrorAction SilentlyContinue
    }
 }
Function Clear-Recent([string]$option){
    #Clear Jump Lists and Recent Places
    $recentpathautodest = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\"
    $recentpath = "$env:APPDATA\Microsoft\Windows\Recent\"
    $excludedfolders = "AutomaticDestinations","CustomDestinations"
    # For reference ls, gci = alias for Get-ChildItem 
    switch($option){
        "recent"{
                ls $recentpath -Exclude $excludedfolders | Remove-Item
                }
        "list"{
                ls $recentpathautodest -Exclude $excludedfolders | Remove-Item
              }
        default{
                ls $recentpath -Exclude $excludedfolders | Remove-Item
                Clear-Directory $recentpathautodest 
            }
    } 
}
Function Clear-Media([string]$option){
    <#Clear VLC recent files list
    Note that the replacement pattern either needs to be in single quotes ('') or have the
    $ signs of the replacement group specifiers escaped ("`$2 `$1").
    Further `n only works with double quotes(")
    #>
    switch($option){
        "vlc"{
        
            $vlcsettingspath = "$env:APPDATA\vlc\vlc-qt-interface.ini"
            $content =  (Get-Content $vlcsettingspath) -join [Environment]::NewLine
            $content = $content -replace "(\[RecentsMRL\]\r\nlist=).*(\r\ntimes=).*\r\n", "`$1@Invalid()`$2@Invalid()`r`n"
            $content | Out-file $vlcsettingspath 
        
        }
        "windows"{
            #Clear Windows Media Player file list
            $mediaplayerpath = "$env:localappdata\Microsoft\Media Player"
            Clear-Directory $mediaplayerpath
        }
        default{
            $vlcsettingspath = "$env:APPDATA\vlc\vlc-qt-interface.ini"
            $content =  (Get-Content $vlcsettingspath) -join [Environment]::NewLine
            $content = $content -replace "(\[RecentsMRL\]\r\nlist=).*(\r\ntimes=).*\r\n", "`$1@Invalid()`$2@Invalid()`r`n"
            $content | Out-file $vlcsettingspath 
        
            #Clear Windows Media Player file list
            $mediaplayerpath = "$env:localappdata\Microsoft\Media Player"
            Clear-Directory $mediaplayerpath
        }
        }
}

Function Clear-SearchPaths($option){
    switch($option){
        "search"{
            #Clear Explorer Search Pane List
            REG Delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery /VA /F | Out-Null
        }
        "paths"{
            #Clear Explorer Search Pane List
            REG Delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery /VA /F | Out-Null
        }
        default{
               #Clear Explorer Search Pane List
                REG Delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery /VA /F | Out-Null
                #Clear Explorer Typed Paths List - Requires restart of file explorer to reflect
                $Key = gi -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths\ 
                $key | Clear-Item
          }
    }
}
Function Clear-Run($option){
#Clear Run Command History
    if($option){
        $RunKey = gi -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU
        $RunKey | Clear-Item
    }
}
Function Clear-Temp($option){
    #Clear Temporary Files List
    if($option){
        $tempfilespath = "$env:temp\"
        Clear-Directory $tempfilespath
    }
}

Function Clear-IE($option){
    switch($option){
    
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
Function Format-Options{
    param([AllowNull()][string]$command ="",
          [AllowNull()][string]$options = "cd")
    switch($command){
        
        ""{
            Clear-Recent 
            Clear-Media 
            Clear-SearchPaths 
            Clear-Run $true
            Clear-Temp $true
            Clear-IE 
        }
    }
    
}

Format-Options
