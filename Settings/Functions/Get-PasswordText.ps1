function Get-PasswordText {
    if ($ChkShow.IsChecked -eq $true) { return $PwdPlain.Text}
    return $PwdField.Password
}
