# Fix Visual Studio 2022 Freeze/Hang Issues
Write-Host "=== Visual Studio 2022 Fix Script ===" -ForegroundColor Cyan
Write-Host ""

# 1. Clear VS Cache
Write-Host "[1/5] Clearing Visual Studio cache..." -ForegroundColor Yellow
$vsCachePaths = @(
    "$env:LOCALAPPDATA\Microsoft\VisualStudio\17.0*",
    "$env:LOCALAPPDATA\Microsoft\VSCommon\17.0*",
    "$env:APPDATA\Microsoft\VisualStudio\17.0*",
    "$env:TEMP\*.vs*"
)

foreach ($path in $vsCachePaths) {
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Cleared: $path" -ForegroundColor Green
    }
}

# 2. Clear Component Model Cache
Write-Host "[2/5] Clearing Component Model Cache..." -ForegroundColor Yellow
$componentCache = "$env:LOCALAPPDATA\Microsoft\VisualStudio\17.0*\ComponentModelCache"
if (Test-Path $componentCache) {
    Remove-Item -Path $componentCache -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  Component cache cleared" -ForegroundColor Green
}

# 3. Reset VS Settings
Write-Host "[3/5] Resetting Visual Studio settings..." -ForegroundColor Yellow
$vsPath = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
if (-not (Test-Path $vsPath)) {
    $vsPath = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
}
if (-not (Test-Path $vsPath)) {
    $vsPath = "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe"
}

if (Test-Path $vsPath) {
    Write-Host "  Found VS at: $vsPath" -ForegroundColor Green
    # Reset settings
    Start-Process -FilePath $vsPath -ArgumentList "/ResetSettings" -Wait -NoNewWindow -ErrorAction SilentlyContinue
    Write-Host "  Settings reset complete" -ForegroundColor Green
} else {
    Write-Host "  VS 2022 not found in standard locations" -ForegroundColor Red
}

# 4. Disable Hardware Acceleration
Write-Host "[4/5] Disabling hardware acceleration..." -ForegroundColor Yellow
$regPath = "HKCU:\Software\Microsoft\VisualStudio\17.0_Config"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "EnableHardwareAcceleration" -Value 0 -Type DWord -ErrorAction SilentlyContinue
Write-Host "  Hardware acceleration disabled" -ForegroundColor Green

# 5. Clear NuGet Cache
Write-Host "[5/5] Clearing NuGet cache..." -ForegroundColor Yellow
dotnet nuget locals all --clear
Write-Host "  NuGet cache cleared" -ForegroundColor Green

Write-Host ""
Write-Host "=== Fix Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Additional tips:" -ForegroundColor Cyan
Write-Host "1. Restart your computer" -ForegroundColor White
Write-Host "2. Run VS 2022 as Administrator" -ForegroundColor White
Write-Host "3. Disable extensions: Tools -> Extensions -> Disable all" -ForegroundColor White
Write-Host "4. Try Safe Mode: devenv.exe /SafeMode" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
