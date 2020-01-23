Function Hide-Icons{
param([System.Management.Automation.SwitchParameter]$hide,
[System.Management.Automation.SwitchParameter]$restore)
$sh = New-Object -ComObject WScript.Shell


    if($restore.IsPresent){
        $shortcut = $sh.CreateShortcut("C:\Users\Kedar\Desktop\firefox alt.lnk")
        $shortcut.TargetPath = "C:\Web Browsers\Mozilla Firefox 52.9ESR\firefox.exe"
        $shortcut.WorkingDirectory = "C:\Web Browsers\Mozilla Firefox 52.9ESR\"
        $shortcut.Arguments = "-P `"Firefox 52.9ESR`" -no-remote"
        $shortcut.Save()
    }
    if($hide.IsPresent){
        gci "$env:USERPROFILE\Desktop\*.lnk" | ?{
            $sh.CreateShortcut($_.FullName).TargetPath -match "Firefox 52.9ESR"
        } |
            Remove-Item 
    <# Deprecated
    gci "$env:USERPROFILE\Desktop" | ?{$_.Name -in ("AA2Play.exe.lnk","AA2PlayJSF.exe.lnk","Mozilla Firefox.lnk")} | Move-Item -Destination "H:\restore"
    }
    #>
    }
}
