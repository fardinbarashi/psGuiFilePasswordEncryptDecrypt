function Set-Status {
    param([string]$Text)
    $StatusText.Text = $Text
    $Window.Dispatcher.Invoke([action]{}, 'Render')
}
