# Personal Hackintosh Guide/Instructions for Dell 7567

### Credits
   - [Rehabman](https://www.tonymacx86.com/members/rehabman.429483/)
   - [AGuyWhoIsBored](https://www.tonymacx86.com/members/aguywhoisbored.1105835/)

### Specs
   - Intel i7-7700HQ CPU
   - Intel HD Graphics 630 / nVidia GTX 1050 Ti
   - 16GB 2400MHz DDR4 RAM
   - 15.6” 1080p IPS Display
   - 128GB SanDisk M.2 SSD (SATA)
   - 1TB 5400RPM Western Digital HDD

### Creating macOS HighSierra USB

I personally went ahead and used USB 3.0, but I had to use [port limit patch](https://raw.githubusercontent.com/RehabMan/OS-X-USB-Inject-All/master/config_patches.plist) to reach the installer which is included in my config.plist.

```bash
# Figure out identifier for of your usb (/dev/diskX, for example)
diskutil list

# Partition your usb in GPT
diskutil partitionDisk /dev/diskX 1 GPT HFS+J "install_osx" R

# Copy installer image
sudo "/Applications/Install macOS High Sierra.app/Contents/Resources/createinstallmedia" --volume /Volumes/install_osx --nointeraction

# Rename
sudo diskutil rename "Install macOS High Sierra" install_osx
```

**Download and install clover on usb**
  - Download [clover](https://bitbucket.org/RehabMan/clover/downloads/)
  - Run the installer
  - Select the target of the install to *"install_osx"* using *"Change Install Location"*
  - Select *Customize*
  - Check *"Install for UEFI booting only"*, *"Install Clover in the ESP"* will automatically select
  - check *"Metal"* from Themes
  - Check *"OsxAptioFixDrv2-64"* from Drivers64UEFI

**Configure clover**
  - Place the files from given zip file into your *EFI/Clover* folder in usb accordingly.

### Booting USB and Installing macOS

  - Press F12 repeatedly for one-time boot-menu and select your usb
  - Choose *install_osx* in clover (preferably boot with -v option)
  - Open *diskutility* and format the partition into HFS+J or apfs and label the partition (eg. macOS)
  - Using HFS+J instead of apfs on your SSD:
      - Target volume must already be formatted with HFS+J
      - Open *Terminal* from the *Utilities* menu in the macOS installer and type:
        <pre>"/Volumes/Image Volume/Install macOS High Sierra.app/Contents/Resources/startosinstall" --volume <b>the_target_volume</b> --converttoapfs NO --agreetolicense
        </pre>
      - Choose *the_target_volume* depending on how you named your partition (eg. /Volumes/macOS)
  - System automatically reboots, again boot into clover, but now select 'Install macOS' instead of 'install_osx'
  
### Post Installation

**Download and Install clover bootloader**
  - Download [clover](https://bitbucket.org/RehabMan/clover/downloads/)
  - Run the installer
  - Select the target of the install to *"Target Volume"* using *"Change Install Location"*
  - Select *Customize*
  - Check *"Install for UEFI booting only"*, *"Install Clover in the ESP"* will automatically select
  - check *"Metal"* from Themes
  - Check *"OsxAptioFixDrv2-64"* from Drivers64UEFI
  - Check *"EmuVariableUefi-64.efi"* from Drivers64UEFI
  - Select *"Install RC scripts on target volume"*

**Configure Clover and your System**
  - Replace the existing config.plist with the config.plist from *“Clover Post-Install Files”*
  - Add the two EFI drivers from *“Clover Post-Install Files”/drivers64UEFI* to /EFI/CLOVER/drivers64UEFI, and remove VBoxHfs-64.efi from /EFI/CLOVER/drivers64UEFI
  - Add the included SSDTs in *patched* folder into your *"/EFI/CLOVER/ACPI/patched"* folder
  - Install all of the kexts that are located in *Clover Post-Install Files/"Clover/Other kexts"* folder to /Library/Extensions using your favorite kext installer.
  - Copy files from given *"/Library/LaunchDaemons"* folder to /Library/LaunchDaemons and *"/usr/bin"* folder to /usr/bin
  - Reboot the laptop and boot with '-f'command line option (press space at clover)
  - Rebuild the cache using `sudo kextcache -i /`
  - Reboot
  
**Disable Hibernation**
```bash
sudo pmset -a hibernatemode 0
sudo rm /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
sudo pmset -a powernap 0
```

### Required Files

### Notes

### Troubleshooting

### References
 - https://www.tonymacx86.com/threads/guide-dell-inspiron-15-7567-and-similar-near-full-functionality.234988/
 - https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/
 - https://www.tonymacx86.com/threads/guide-avoid-apfs-conversion-on-high-sierra-update-or-fresh-install.232855/
 - https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/
 - https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/
 - https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/
 - https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/