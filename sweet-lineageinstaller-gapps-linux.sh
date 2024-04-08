#!/bin/bash

ROM_NAME="lineage"
ROM_VERSION="20.0"
DEVICE_CODENAME="sweet"
GAPPS="MindTheGapps-13.0.0-arm64-20231025_200931"
IH8PI="ih8pi-aarch64"
DOWNLOAD_DIR="/tmp/lineageos_downloads"

latest_thursday=$(date -d "$(date +%Y%m%d) -$(date +%u) days +4 days" +%Y%m%d)

rom_url="https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}-signed.zip"

mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

wget -c "$rom_url"
wget -c https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/recovery.img
wget -c https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/boot.img
wget -c https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/dtbo.img
wget -c https://mirrorbits.lineageos.org/full/${DEVICE_CODENAME}/${latest_thursday}/vbmeta.img
wget -c https://github.com/MindTheGapps/13.0.0-arm64/releases/download/${GAPPS}/${GAPPS}.zip
wget -c https://github.com/basamaryan/ih8pi/releases/download/latest/${IH8PI}.zip

echo "Connect your device in FASTBOOT mode to install the recommended files before installation (boot, dtbo, vbmeta, and recovery)."

fastboot flash boot boot.img
fastboot flash dtbo dtbo.img
fastboot flash vbmeta vbmeta.img
fastboot flash recovery recovery.img

fastboot reboot recovery

read -n 1 -s -r -p "Connect your device in ADB Sideload mode. Press any key to continue with the lineage installation..."

echo "Installing ROM ${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}"

adb sideload "${ROM_NAME}-${ROM_VERSION}-${latest_thursday}-nightly-${DEVICE_CODENAME}.zip"

read -n 1 -s -r -p "Connect your device in ADB Sideload mode. Press any key to continue with the installation of the GAPPS..."

adb sideload "${GAPPS}.zip"

read -n 1 -s -r -p "Conecta tu dispositivo en modo ADB Sideload. Presiona cualquier tecla para continuar con la instalacion de las ih8pi (I h8 Play Integrity)..."

adb sideload "${IH8PI}.zip"
