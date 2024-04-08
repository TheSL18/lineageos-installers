$ROM_NAME = "lineage"
$ROM_VERSION = "20.0"
$DEVICE_CODENAME = "sweet"
$GAPPS = "MindTheGapps-13.0.0-arm64-20231025_200931"
$IH8PI = "ih8pi-aarch64"
$DOWNLOAD_DIR = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "lineageos_downloads")

$latest_thursday = (Get-Date).AddDays(-1)  
while ($latest_thursday.DayOfWeek -ne 'Thursday') {
    $latest_thursday = $latest_thursday.AddDays(-1)
}
$latest_thursday = $latest_thursday.ToString("yyyyMMdd")

$rom_url = "https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}-signed.zip"

New-Item -ItemType Directory -Force -Path $DOWNLOAD_DIR | Out-Null
Set-Location -Path $DOWNLOAD_DIR

Invoke-WebRequest -Uri $rom_url -OutFile "${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}.zip"
Invoke-WebRequest -Uri "https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/recovery.img" -OutFile "recovery.img"
Invoke-WebRequest -Uri "https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/boot.img" -OutFile "boot.img"
Invoke-WebRequest -Uri "https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/dtbo.img" -OutFile "dtbo.img"
Invoke-WebRequest -Uri "https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/vbmeta.img" -OutFile "vbmeta.img"
Invoke-WebRequest -Uri "https://github.com/MindTheGapps/13.0.0-arm64/releases/download/${GAPPS}/${GAPPS}.zip" -OutFile "${GAPPS}.zip"
Invoke-WebRequest -Uri "https://github.com/basamaryan/ih8pi/releases/download/latest/${IH8PI}.zip" -OutFile "${IH8PI}.zip"

Write-Host "Connect your device in FASTBOOT mode to install the recommended files before installation (boot, dtbo, vbmeta, and recovery)."

.\fastboot.exe flash boot boot.img
.\fastboot.exe flash dtbo dtbo.img
.\fastboot.exe flash vbmeta vbmeta.img
.\fastboot.exe flash recovery recovery.img

.\fastboot.exe reboot recovery

Read-Host -Prompt "Connect your device in ADB Sideload mode. Press Enter to continue with the lineage installation..."

Write-Host "Installing ROM ${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}"

.\adb.exe sideload "${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}.zip"

Read-Host -Prompt "Connect your device in ADB Sideload mode. Press Enter to continue with the installation of the GAPPS..."

.\adb.exe sideload "${GAPPS}.zip"

Read-Host -Prompt "Connect your device in ADB Sideload mode. Press Enter to continue with the installation of ih8pi (I h8 Play Integrity)..."

.\adb.exe sideload "${IH8PI}.zip"

