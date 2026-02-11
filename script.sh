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
if ! repo init -u https://github.com/Superior13-NEXT/manifest.git -b QPR3 --git-lfs --depth=1; then
  echo "Repo initialization failed."
fi
echo "=============================================="
echo "       Manifest Cloned successfully"
echo "=============================================="
# Sync
if ! /opt/crave/resync.sh || ! repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all); then
  echo "Repo sync failed."
fi
echo "============="
echo " Sync success"
echo "============="

# Clone device trees and other dependencies
echo "=============================================="
echo "       Cloning Trees..........."
echo "=============================================="
rm -rf device/xiaomi

rm -rf vendor/xiaomi

rm -rf kernel/xiaomi

rm -rf hardware/xiaomi

git clone https://https://github.com/Ghnkz/device_sweet.git -b supri device/xiaomi/sweet || { echo "Failed to clone device tree"; }

git clone https://github.com/Ghnkz/vendor_sweet.git -b 13 vendor/xiaomi/sweet || { echo "Failed to clone vendor tree"; }

git clone https://github.com/Ghnkz/kernel_xiaomi_sm6150.git kernel/xiaomi/sm6150 || { echo "Failed to clone kernel tree"; }

git clone -b thirteen https://github.com/SuperiorOS/android_hardware_xiaomi hardware/xiaomi || { echo "Failed to clone hardware xiaomi"; }

git clone https://github.com/Ghnkz/vendor_xiaomi_sweet-miuicamera.git venodr/xiaomi/sweet-miuicamera || { echo "Failed to clone MiuiCamera"; }

/opt/crave/resync.sh

# Export Environment Variables
echo "======= Exporting........ ======"
export BUILD_USERNAME=Rhmd
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
echo "  BRINGING TO HORIZON , STARTING BUILD.."
echo "===================================="
. build/envsetup.sh
lunch superior_sweet-userdebug
m bacon
