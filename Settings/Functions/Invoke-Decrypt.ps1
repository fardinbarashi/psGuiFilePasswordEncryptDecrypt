function Invoke-Decrypt {
    <#
        Reads a file written by Invoke-Encrypt and shows the original password.
        Only works when run as the same user on the same machine that encrypted
        it
    #>
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title  = 'Select an encrypted password file'
    $dlg.Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'

    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        Set-Status 'Decrypt cancelled.'
        return
    }

    try {
        Set-Status "Decrypting $($dlg.FileName)..."

        $cipher = Get-Content -Path $dlg.FileName -Raw
        if ([string]::IsNullOrWhiteSpace($cipher)) {
            throw 'The file is empty.'
        }

        $secure = $cipher.Trim() | ConvertTo-SecureString   # throws if wrong user/machine
        $bstr   = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
        try {
            $plain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        }
        finally {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }

        $ResultText.Text = "Decrypted password:`n$plain"
        Set-Status "Decrypted $($dlg.FileName)"
    }
    catch {
        $ResultText.Text = 'Could not decrypt. This file was encrypted by a different user or on a different machine.'
        Set-Status 'Decryption failed.'
        Show-Message -Message "Could not decrypt this file.`n`n$($_.Exception.Message)`n`nDPAPI files can only be read by the same Windows account on the same computer that created them." -Title 'Decrypt failed' -Icon 'Warning'
    }
}
