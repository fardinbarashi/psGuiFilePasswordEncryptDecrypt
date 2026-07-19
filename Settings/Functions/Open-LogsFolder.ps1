function Open-LogsFolder {
    if (Test-Path $Script:LogDir) {
        Start-Process explorer.exe $Script:LogDir
    }
}
