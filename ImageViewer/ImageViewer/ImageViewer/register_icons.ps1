# PowerShell script to register ImageViewer for image files and fix icon display

$ExePath = "e:\IT\GitHup\QML\ImageViewer\ImageViewer\ImageViewer\build\Desktop_Qt_6_9_1_MinGW_64_bit-Release\appImageViewer.exe"

if (-not (Test-Path $ExePath)) {
    Write-Error "Could not find the executable at $ExePath. Please check the path."
    return
}

$ProgID = "ImageViewer.Assoc"
$Extensions = @(".png", ".jpg", ".jpeg", ".bmp", ".gif")

Write-Host "Registering $ProgID..." -ForegroundColor Cyan

# 1. Create ProgID
$ProgIDPath = "Registry::HKEY_CURRENT_USER\Software\Classes\$ProgID"
if (-not (Test-Path $ProgIDPath)) {
    New-Item -Path $ProgIDPath -Force | Out-Null
}
Set-ItemProperty -Path $ProgIDPath -Name "(Default)" -Value "ImageViewer Image File"

# 2. Set DefaultIcon (using index 0 of the exe)
$IconPath = "Registry::HKEY_CURRENT_USER\Software\Classes\$ProgID\DefaultIcon"
if (-not (Test-Path $IconPath)) {
    New-Item -Path $IconPath -Force | Out-Null
}
Set-ItemProperty -Path $IconPath -Name "(Default)" -Value "$ExePath,0"

# 3. Set Open Command
$CommandPath = "Registry::HKEY_CURRENT_USER\Software\Classes\$ProgID\shell\open\command"
if (-not (Test-Path $CommandPath)) {
    New-Item -Path $CommandPath -Force | Out-Null
}
Set-ItemProperty -Path $CommandPath -Name "(Default)" -Value "`"$ExePath`" `"%1`""

# 4. Associate Extensions
foreach ($Ext in $Extensions) {
    Write-Host "Associating $Ext with $ProgID..."
    $ExtPath = "Registry::HKEY_CURRENT_USER\Software\Classes\$Ext"
    if (-not (Test-Path $ExtPath)) {
        New-Item -Path $ExtPath -Force | Out-Null
    }
    Set-ItemProperty -Path $ExtPath -Name "(Default)" -Value $ProgID
}

Write-Host "`nRegistration complete! If icons don't update, please restart Explorer or clear icon cache." -ForegroundColor Green
