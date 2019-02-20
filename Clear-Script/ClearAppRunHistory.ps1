Function Clear-Directory($pathv){
    if(($pathv  | gci) -ne $null){
        ls $pathv | Remove-Item -Recurse -ErrorAction SilentlyContinue
    }
 }
Function Clear-Recent([string]$option=""){
    #Clear Jump Lists and Recent Places
    $recentpathautodest = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\"
    $recentpath = "$env:APPDATA\Microsoft\Windows\Recent\"
    $excludedfolders = "AutomaticDestinations","CustomDestinations"
    # For reference ls, gci = alias for Get-ChildItem 
    switch($option.ToLower().Trim()){
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
Function Clear-Media([string]$option=""){
    <#Clear VLC recent files list
    Note that the replacement pattern either needs to be in single quotes ('') or have the
    $ signs of the replacement group specifiers escaped ("`$2 `$1").
    Further `n only works with double quotes(")
    #>
    switch($option.ToLower().Trim()){
        "vlc"{
            #Get vlc path, clear lines if size < 20kb, otherwise delete file
            $vlcsettingspath = "$env:APPDATA\vlc\vlc-qt-interface.ini"
            if((Get-Item $vlcsettingspath).Length/1KB -le 20){
                $content =  (Get-Content $vlcsettingspath) -join [Environment]::NewLine
                $content = $content -replace "(\[RecentsMRL\]\r\nlist=).*(\r\ntimes=).*\r\n", "`$1@Invalid()`$2@Invalid()`r`n"
                $content | Out-file $vlcsettingspath 
            }
            else{
                Remove-Item $vlcsettingspath
                }
        
        }
        "windows"{
            #Clear Windows Media Player file list
            $mediaplayerpath = "$env:localappdata\Microsoft\Media Player"
            Clear-Directory $mediaplayerpath
        }
        default{
            $vlcsettingspath = "$env:APPDATA\vlc\vlc-qt-interface.ini"
            if((Get-Item $vlcsettingspath).Length/1KB -le 20){
                $content =  (Get-Content $vlcsettingspath) -join [Environment]::NewLine
                $content = $content -replace "(\[RecentsMRL\]\r\nlist=).*(\r\ntimes=).*\r\n", "`$1@Invalid()`$2@Invalid()`r`n"
                $content | Out-file $vlcsettingspath 
            }
            else{
                Remove-Item $vlcsettingspath
                }
        
            #Clear Windows Media Player file list
            $mediaplayerpath = "$env:localappdata\Microsoft\Media Player"
            Clear-Directory $mediaplayerpath
        }
        }
}
Function Clear-SearchPaths($option=""){
    switch($option.ToLower().Trim()){
        "search"{
            #Clear Explorer Search Pane List
            REG Delete HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery /VA /F | Out-Null
        }
        "paths"{
            #Clear Explorer Search Pane List
            $Key = gi -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths\ 
            $Key | Clear-Item
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
Function Clear-Run($option=$false){
#Clear Run Command History
    if($option){
        $RunKey = gi -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU
        $RunKey | Clear-Item
    }
}
Function Clear-Temp([string]$option){
    #Clear %Temp%, $RECYCLE.BIN folders
    switch($option.ToLower().Trim()){
        "temp"{
            Clear-Directory $env:temp
        }
        "bin"{
             Clear-RecycleBin -Confirm:$false    
        }
        default{
            Clear-Directory $env:temp
            Clear-RecycleBin -Confirm:$false
        }
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
    param([AllowNull()][string]$command ="",
          [AllowNull()][string]$options = "cd")
    switch($command.ToLower().Trim()){
        "browser"{
          Clear-IE
        }
        "os"{
            Clear-Recent
            Clear-SearchPaths 
            Clear-Run $true
            Clear-Temp $true
        }
        "media"{
            Clear-Media 
        }
        ""{
            Clear-Recent 
            Clear-Media 
            Clear-SearchPaths 
            Clear-Run $true
            Clear-Temp $true
            Clear-IE 
        }
        {@("?","h","help") -contains $_}{
            Write-Host "Usage: Clear-RunHistory <command> [options]"
            Write-Host "`n`n`nCommands: `n`n"
            Write-Host "browser `t Clears history, filled forms, cookies and cache of browsers (IE/Firefox/Chrome)`n"
            Write-Host "os      `t Clears OS history, jump lists, typed paths and searches`n"
            Write-Host "media   `t Clears media player history, playlists and recent files"
        }
        default{
            Write-Host "Invalid Usage, use (Clear-RunHistory|crh) <?|h|help> for syntax help"
        }
    }
    
}

Set-Alias -Name crh -Value Clear-RunHistory
crh 
