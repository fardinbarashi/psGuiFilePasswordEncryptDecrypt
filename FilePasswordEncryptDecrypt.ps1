<#
System requirements
PSVersion 5.1 or later. PSEdition Desktop or Core.

About Script :
Author : Fardin Barashi
Title : PasswordEncrypter
Description : Encrypts a password to a file 
              The file can only be decrypted by the same Windows account on the
              same machine that created it - the current user's credentials are
              the key. No separate key or certificate is involved.

Structure :
    PasswordEncrypter.ps1                  This file. Loads UI, functions, wires events.
    Settings\UI\MainWindow.xaml            The window as XAML (converted from the old WinForms UI).
    Settings\Functions\*.ps1               One function per file, dot-sourced below.
    Settings\Config\app.config.json        App settings.
    Settings\Logs\                          Per-run transcripts.


Version : 2.0
Release day : 2026-07-18
Github Link : https://github.com/fardinbarashi


#>


$ErrorActionPreference = 'Stop'

#----------------------------------- Assemblies -----------------------------------
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms   # file dialogs

#----------------------------------- Paths -----------------------------------
$Script:AppName    = 'Password Encrypter'
$Script:Root       = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$Script:XamlPath   = Join-Path $Script:Root 'Settings\UI\MainWindow.xaml'
$Script:FuncDir    = Join-Path $Script:Root 'Settings\Functions'
$Script:ConfigDir  = Join-Path $Script:Root 'Settings\Config'
$Script:LogDir     = Join-Path $Script:Root 'Settings\Logs'
$Script:AppConfig  = Join-Path $Script:ConfigDir 'app.config.json'

if (-not (Test-Path $Script:LogDir)) { New-Item -ItemType Directory -Path $Script:LogDir -Force | Out-Null }

#----------------------------------- Transcript -----------------------------------
$ScriptName    = $MyInvocation.MyCommand.Name
if (-not $ScriptName) { $ScriptName = 'PasswordEncrypter.ps1' }
$LogStamp      = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$TranscriptLog = Join-Path $Script:LogDir "$ScriptName - $LogStamp.txt"
try { Start-Transcript -Path $TranscriptLog -Force | Out-Null } catch { }
Get-Date -Format 'yyyy/MM/dd HH:mm:ss'
Write-Host '.. Starting TranScript'

#----------------------------------- Config -----------------------------------
$Script:Config = $null
if (Test-Path $Script:AppConfig) {
    try   { $Script:Config = Get-Content -Raw -Encoding UTF8 $Script:AppConfig | ConvertFrom-Json }
    catch { Write-Warning "Could not read app.config.json: $($_.Exception.Message)" }
}

#----------------------------------- Load XAML -----------------------------------
if (-not (Test-Path $Script:XamlPath)) { throw "Cannot find the UI file: $Script:XamlPath" }

$XamlText = Get-Content -Raw -Encoding UTF8 $Script:XamlPath
[xml]$Xaml = $XamlText
$reader = New-Object System.Xml.XmlNodeReader $Xaml
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Bind every x:Name to a script-scope variable of the same name
foreach ($m in [regex]::Matches($XamlText, 'x:Name="([^"]+)"')) {
    $name = $m.Groups[1].Value
    Set-Variable -Name $name -Value ($Window.FindName($name)) -Scope Script
}

#----------------------------------- Load functions -----------------------------------
# After the controls exist, so functions can reach them by name.
if (-not (Test-Path $Script:FuncDir)) { throw "Function folder not found: $Script:FuncDir" }

$functionFiles = Get-ChildItem -Path $Script:FuncDir -Filter '*.ps1' -File
if (-not $functionFiles) { throw "No .ps1 files found in $Script:FuncDir" }

foreach ($file in $functionFiles) {
    try   { . $file.FullName }
    catch { throw "Failed to load function file '$($file.Name)': $($_.Exception.Message)" }
}

#----------------------------------- Default save path -----------------------------------
# From config if present, otherwise the user's Documents folder
$defaultFolder = if ($Script:Config -and $Script:Config.defaultSaveFolder) 
    { [Environment]::ExpandEnvironmentVariables($Script:Config.defaultSaveFolder)} 
    else { [Environment]::GetFolderPath('MyDocuments')}
$defaultName = if ($Script:Config -and $Script:Config.defaultFileName) { $Script:Config.defaultFileName } else { 'Password.txt' }
$TxtSavePath.Text = Join-Path $defaultFolder $defaultName

#----------------------------------- Event wiring -----------------------------------
$BtnEncrypt.Add_Click({ Invoke-Encrypt })
$BtnBrowse.Add_Click({ Select-SavePath })
$ChkShow.Add_Click({ Sync-PasswordVisibility })

$MenuDecryptFile.Add_Click({ Invoke-Decrypt })
$MenuOpenLogs.Add_Click({ Open-LogsFolder })
$MenuExit.Add_Click({ $Window.Close() })
$MenuAbout.Add_Click({ Show-Message -Message "Password Encrypter 2.0`n`nEncrypts a password with DPAPI, tied to the current Windows user and machine.`n`nhttps://github.com/fardinbarashi" -Title 'About'})

# Ctrl+Q closes
$Window.Add_KeyDown({ if (($_.Key -eq 'Q') -and ($_.KeyboardDevice.Modifiers -band [System.Windows.Input.ModifierKeys]::Control)) { $Window.Close()}})

#----------------------------------- Init -----------------------------------
Set-Status "Ready - signed in as $env:USERNAME on $env:COMPUTERNAME"

$Window.Add_Closed({ try { Stop-Transcript | Out-Null } catch { } })
$Window.ShowDialog() | Out-Null
