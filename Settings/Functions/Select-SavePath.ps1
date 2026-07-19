function Select-SavePath {
    $dlg = New-Object System.Windows.Forms.SaveFileDialog
    $dlg.Title    = 'Save encrypted password as'
    $dlg.Filter   = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    $dlg.FileName = 'Password.txt'

    if (-not [string]::IsNullOrWhiteSpace($TxtSavePath.Text)) {
        $existingDir = Split-Path $TxtSavePath.Text -Parent
        if ($existingDir -and (Test-Path $existingDir)) { $dlg.InitialDirectory = $existingDir }
    }

    if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $TxtSavePath.Text = $dlg.FileName
    }
}
