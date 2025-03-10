# removing previous tree
rm -rf device/xiaomi/gale

# Cloning a new tree
git clone https://github.com/VannTakashi/device_xiaomi_gale -b cartesian device/xiaomi/gale

# Set up build environment
echo "====== Starting Envsetup ======="
source build/envsetup.sh || { echo "Envsetup failed"; exit 1; }
echo "====== Envsetup Done ======="

# Lunch
echo "====== Brunch.... ========"
brunch gale || { echo "Lunch command failed"; exit 1; }
echo "===== Lunching done ========"


# Build ROM
echo "===================================="
echo "        Build Evo-X..."
echo "===================================="
m evolution || { echo "Build failed"; exit 1; }
