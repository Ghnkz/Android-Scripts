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
echo "        Build Cartesian..."
echo "===================================="
 || { echo "Build failed"; }
