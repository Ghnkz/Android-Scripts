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
if ! repo init -u https://github.com/Mnzz-Prjkt/android_manifest.git -b sixteen-qpr1 --git-lfs; then
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

# Setting Up BPF Hacks!
echo "Dropping Original Connectivity and system_bpf"
rm -rf system/bpf
rm -rf packages/modules/Connectivity
echo "Done!"

# Reclone With Our connectivity and bpf"
git clone https://github.com/vannkyle/android_packages_modules_Connectivity.git packages/modules/Connectivity
git clone https://github.com/vannkyle/android_system_bpf.git system/bpf
echo " All Is Done! Ur Sources Its fully implemented with bpf hacks"

# Clone device trees and other dependencies
echo "=============================================="
echo "       Cloning Trees..........."
echo "=============================================="
rm -rf device/xiaomi

rm -rf vendor/xiaomi

rm -rf kernel/xiaomi

rm -rf hardware/xiaomi

rm -rf hardware/mediatek

rm -rf device/mediatek/sepolicy_vndr

git clone https://github.com/xaveroprjkt/device_xiaomi_gale.git -b pos-16.1 device/xiaomi/gale || { echo "Failed to clone device tree"; }

git clone https://github.com/Mayuri-Chan/proprietary_vendor_xiaomi_gale.git -b sixteen vendor/xiaomi/gale || { echo "Failed to clone vendor tree"; }

git clone https://github.com/Mayuri-Chan/android_kernel_xiaomi_gale.git -b cip kernel/xiaomi/gale || { echo "Failed to clone kernel tree"; }

git clone https://github.com/AbuRider/android_hardware_xiaomi.git -b lineage-23.1 hardware/xiaomi || { echo "Failed to clone xiaomi stuffs"; }

git clone https://github.com/LineageOS/android_hardware_mediatek.git -b lineage-23.1 hardware/mediatek || { echo "Failed to clone mediatek hardwares"; }

/opt/crave/resync.sh

# Export Environment Variables
echo "======= Exporting........ ======"
export BUILD_USERNAME=xaveroprjkt.
export BUILD_HOSTNAME=serenitycorp
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
breakfast gale
m pixelos
