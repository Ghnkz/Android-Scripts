# Drop Pevious Keys
rm -rf vendor/custom-priv/keys

# Clone New Keys
git clone https://github.com/VannTakashi/vann_keys -b pos-16 vendor/custom-priv/keys

# Set up build environment
echo "====== Starting Envsetup ======="
source build/envsetup.sh || { echo "Envsetup failed"; exit 1; }
echo "====== Envsetup Done ======="

# Lunch
echo "====== Brunch.... ========"
breakfast gale || { echo "Lunch command failed"; exit 1; }
echo "===== Lunching done ========"


# Build ROM
echo "===================================="
echo "        Build PixelOS..."
m pixelos
echo "===================================="
 || { echo "Build failed"; }
