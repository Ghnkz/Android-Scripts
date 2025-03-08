#!/bin/bash
# crave run --no-patch -- "curl https://raw.githubusercontent.com/tillua467/Android-Scripts/refs/heads/main/script.sh | bash"

# Remove Unnecessary Files
echo "===================================="
echo "     Removing Unnecessary Files"
echo "===================================="

dirs_to_remove=(
  "vendor/xiaomi"
  "kernel/xiaomi"
  "device/xiaomi"
  "device/xiaomi/sm6150-common"
  "vendor/xiaomi/sm6150-common"
  "hardware/xiaomi"
  "out/target/product/*/*zip"
  "out/target/product/*/*txt"
  "out/target/product/*/boot.img"
  "out/target/product/*/recovery.img"
  "out/target/product/*/super*img"
)

for dir in "${dirs_to_remove[@]}"; do
  [ -e "$dir" ] && rm -rf "$dir"
done

echo "===================================="
echo "  Removing Unnecessary Files Done"
echo "===================================="

# Initialize repo
echo "=============================================="
echo "         Cloning Manifest..........."
echo "=============================================="
if ! repo init -u https://github.com/HorizonDroidLab/manifest.git -b fifteen --git-lfs; then
  echo "Repo initialization failed. Exiting."
  exit 1
fi
echo "=============================================="
echo "       Manifest Cloned successfully"
echo "=============================================="
# Sync
if ! /opt/crave/resync.sh || ! repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all); then
  echo "Repo sync failed. Exiting."
  exit 1
fi
echo "============="
echo " Sync success"
echo "============="

# Clone device trees and other dependencies
echo "=============================================="
echo "       Cloning Trees..........."
echo "=============================================="
git clone https://github.com/VannTakashi/device_xiaomi_gale.git -b horizon device/xiaomi/gale || { echo "Failed to clone device tree"; exit 1; }

git clone https://github.com/VannTakashi/vendor_xiaomi_gale.git -b lineage-22.1 vendor/xiaomi/gale || { echo "Failed to clone common device tree"; exit 1; }

git clone https://github.com/VannTakashi/kernel_xiaomi_gale.git kernel/xiaomi/gale || { echo "Failed to clone kernel"; exit 1; }

rm -rf hardware/xiaomi

rm -rf hardware/mediatek

rm -rf device/mediatek/sepolicy_vndr

git clone https://github.com/VannTakashi/android_hardware_xiaomi.git hardware/xiaomi || { echo "Failed to clone vendor phoenix"; exit 1; }

git clone https://github.com/LineageOS/android_hardware_mediatek.git hardware/mediatek || { echo "Failed to clone common vendor phoenix"; exit 1; }

git clone https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git device/mediatek/sepolicy_vndr || { echo "Failed to clone hardware"; exit 1; }

/opt/crave/resync.sh

# Export Environment Variables
echo "======= Exporting........ ======"
export BUILD_USERNAME=takashiiprjkt
export BUILD_HOSTNAME=crave
export TZ=Asia/Jakarta
export ALLOW_MISSING_DEPENDENCIES=true
echo "======= Export Done ======"

# Set up build environment
echo "====== Starting Envsetup ======="
source build/envsetup.sh || { echo "Envsetup failed"; exit 1; }
echo "====== Envsetup Done ======="


# Build ROM
echo "===================================="
echo "        Build Horizon.."
echo "===================================="
. build/envsetup.sh
lunch horizon_gale-ap4a-userdebug
m horizon
