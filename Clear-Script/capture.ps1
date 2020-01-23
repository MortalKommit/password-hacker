$capturedatepath ="$env:TEMP\ffmpeg\Captures_" +'{0:yyyy-MM-dd}' -f (Get-Date)
if (-not(Test-Path $capturedatepath)){
    New-Item -ItemType Directory -Path $capturedatepath -Force | Out-Null
}

$capturetime ="Capture_"+'{0:yyyy-MM-ddTHH.mm.ss}' -f (Get-Date)

#$FFMPEGDIR = "C:\Users\Kedar\Downloads\installers\ffmpeg64\bin\"
& "C:\Users\Kedar\Downloads\installers\ffmpeg64\bin\ffmpeg.exe" -f gdigrab -framerate 30 -ss 00:00:00 -i desktop -t 60 $capturedatepath\$($env:computername)_$capturetime.mp4

