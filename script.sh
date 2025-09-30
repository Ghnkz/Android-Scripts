#!/bin/bash
# crave run --no-patch -- "curl https://raw.githubusercontent.com/Ghnkz/Android-Scripts/refs/heads/main/script.sh | bash"

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
if ! repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs; then
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

git clone https://github.com/xiaomi-sm6150/android_device_xiaomi_sweet -b lineage-20 device/xiaomi/sweet || { echo "Failed to clone device tree"; }

git clone https://github.com/xiaomi-sm6150/proprietary_vendor_xiaomi_sweet -b lineage-20 vendor/xiaomi/sweet || { echo "Failed to clone vendor tree"; }

git clone https://github.com/xiaomi-sm6150/android_kernel_xiaomi_sm6150 -b lineage-23.0 kernel/xiaomi/sm6150 || { echo "Failed to clone kernel tree"; }

git clone https://github.com/LineageOS/android_hardware_xiaomi -b lineage-20 hardware/xiaomi || { echo "Failed to clone xiaomi stuffs"; }

git clone https://github.com/xiaomi-sm6150/android_device_xiaomi_sm6150-common -b lineage-20 device/xiaomi/sm6150-common || { echo "Failed to clone device common"; }

git clone https://github.com/xiaomi-sm6150/proprietary_vendor_xiaomi_sm6150-common -b lineage-20 vendor/xiaomi/sm6150-common || { echo "Failed to clone vendor common"; }

git clone https://github.com/xiaomi-sm6150/proprietary_vendor_xiaomi_miuicamera-sweet vendor/xiaomi/miuicamera-sweet || { echo "Failed to clone vendor/miuicamera"; }

git clone https://github.com/xiaomi-sm6150/android_device_xiaomi_miuicamera-sweet device/xiaomi/miuicamera-sweet || { echo "Failed to clone device/miuicamera"; }

/opt/crave/resync.sh

# Export Environment Variables
echo "======= Exporting........ ======"
export BUILD_USERNAME=Madsprjkt
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
brunch sweet
