function Sync-PasswordVisibility {
    <#
        Toggles between the masked PasswordBox and a plain TextBox.
    #>
    if ($ChkShow.IsChecked -eq $true) {
        $PwdPlain.Text        = $PwdField.Password
        $PwdPlain.Visibility  = 'Visible'
        $PwdField.Visibility  = 'Collapsed'
    }
    else {
        $PwdField.Password    = $PwdPlain.Text
        $PwdField.Visibility  = 'Visible'
        $PwdPlain.Visibility  = 'Collapsed'
    }
}
