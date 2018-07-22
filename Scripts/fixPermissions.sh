echo "Fixing ownership and permissions..."
chmod -R 755 /System/Library/Extensions
chown -R root:wheel /System/Library/Extensions
sudo chmod -R 755 /Library/Extensions
sudo chown -R root:wheel /Library/Extensions
chown root:admin /
echo "Rebuilding kext cache..."
kextcache -system-prelinked-kernel
kextcache -system-caches
