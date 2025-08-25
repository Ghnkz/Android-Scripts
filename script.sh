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
if ! repo init --depth=1 --no-repo-verify -u https://github.com/VannTakashi/android_manifest.git -b LTS -g default,-mips,-darwin,-notdefault; then
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

rm -rf hardware/mediatek

rm -rf device/mediatek/sepolicy_vndr

git clone https://github.com/VannTakashi/device_xiaomi_gale.git -b afterlife-T device/xiaomi/gale || { echo "Failed to clone device tree"; }

git clone https://github.com/VannTakashi/vann_keys -b afl vendor/afterlife-priv/keys

. build/envsetup.sh

cd kernel/xiaomi/gale

git revert a217da7a6d8ced1cd9c96804b534ebc1ecc34c36 --no-edit

/opt/crave/resync.sh

# Export Environment Variables
echo "======= Exporting........ ======"
export BUILD_USERNAME=VannNieauverrau.
export BUILD_HOSTNAME=vann
export TZ=Asia/Jakarta
export ALLOW_MISSING_DEPENDENCIES=true
echo "======= Export Done ======"

# Set up build environment
echo "====== Starting Envsetup ======="
. build/envsetup.sh || { echo "Envsetup failed"; exit 1; }
echo "====== Envsetup Done ======="


# Build ROM
echo "===================================="
echo "  LETS AFTERIFY ! , STARTING BUILD.."
echo "===================================="
. build/envsetup.sh
lunch afterlife_gale-userdebug
m afterlife -j$(nproc --all)
