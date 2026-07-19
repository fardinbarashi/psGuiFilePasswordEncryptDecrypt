function Invoke-Encrypt {
    <#
        Encrypts the typed password with DPAPI via ConvertFrom-SecureString and
        writes the cipher text to a file. DPAPI ties the blob to the current
        Windows user on the current machine: no one else - and no other account -
        can convert it back, even with the file in hand.
    #>
    $plain = Get-PasswordText

    if ([string]::IsNullOrWhiteSpace($plain)) {
        Show-Message -Message 'Type a password to encrypt first.' -Title 'No password' -Icon 'Warning'
        return
    }

    $savePath = $TxtSavePath.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($savePath)) {
        Show-Message -Message 'Choose where to save the file first.' -Title 'No path' -Icon 'Warning'
        return
    }

    try {
        Set-Status 'Encrypting... 0%'

        $secure    = ConvertTo-SecureString -String $plain -AsPlainText -Force
        $encrypted = $secure | ConvertFrom-SecureString   # DPAPI, current user + machine

        $dir = Split-Path $savePath -Parent
        if ($dir -and -not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }

        $encrypted | Out-File -FilePath $savePath -Encoding UTF8 -Force

        Set-Status "Encrypted and saved to $savePath"
        $ResultText.Text = "Saved to:`n$savePath`n`nOnly $env:USERNAME on $env:COMPUTERNAME can decrypt this file."
    }
    catch {
        Set-Status 'Encryption failed.'
        Show-Message -Message "Encryption failed: $($_.Exception.Message)" -Title 'Error' -Icon 'Error'
    }
}
