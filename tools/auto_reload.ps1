# Auto Hot Reload Script for Flutter
# This watches for file changes and sends 'r' to the Flutter process

$flutterProcess = $null
$watcher = $null

try {
    # Start Flutter
    $flutterProcess = Start-Process -FilePath "flutter" -ArgumentList "run -d windows" -WorkingDirectory "C:\delivipapp\delivip_app" -NoNewWindow -PassThru

    Write-Host "Starting Flutter app..." -ForegroundColor Green
    Start-Sleep -Seconds 15

    # Create file watcher
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\delivipapp\delivip_app\lib"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    $watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite

    Write-Host "Auto Reload ACTIVE! Save your files and changes will appear automatically." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to stop." -ForegroundColor Yellow

    $action = {
        $path = $Event.SourceEventArgs.FullPath
        if ($path -match '\.(dart|yaml|json|xml)$') {
            Start-Sleep -Milliseconds 500
            # Send 'r' keystroke to the flutter console
            $wshell = New-Object -ComObject wscript.shell
            $wshell.AppActivate("delivip_app.exe")
            Start-Sleep -Milliseconds 200
            $wshell.SendKeys('r')
        }
    }

    Register-ObjectEvent $watcher "Changed" -Action $action > $null

    # Keep script running
    Wait-Event

} finally {
    if ($watcher) { $watcher.EnableRaisingEvents = $false; $watcher.Dispose() }
    if ($flutterProcess -and !$flutterProcess.HasExited) { $flutterProcess.Kill() }
}
