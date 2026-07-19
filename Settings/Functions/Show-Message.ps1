function Show-Message {
    param(
        [string]$Message,
        [string]$Title = 'Password Encrypter',
        [string]$Icon = 'Information'
    )
    [System.Windows.MessageBox]::Show($Window, $Message, $Title,
        [System.Windows.MessageBoxButton]::OK,
        [System.Windows.MessageBoxImage]::$Icon) | Out-Null
}
