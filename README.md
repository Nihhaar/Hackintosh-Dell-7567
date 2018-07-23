# Personal Hackintosh Guide/Instructions for Dell 7567

### Screenshot
![macOS High Sierra - 10.13.6](https://raw.githubusercontent.com/Nihhaar/Hackintosh-Dell-7567/master/Assets/Screenshot.png)

### Download Required Files
[Download](https://github.com/Nihhaar/Hackintosh-Dell7567/raw/master/Archive/Hackintosh-Dell7567-Nihhaar.zip)

### Notes
 - Working hackintosh for 10.13.x (including 10.13.6)
 - No support for mojave currently
 - No support for 4k *(I don't have a 4k variant)*. But I think it's just `my files` + `CoreDisplayFixup.kext` + `DVMT patch`
 - HDMI doesn't work on this hack because it is connected to nvidia card and we disabled it
 - Any other issues? Just open an issue in this repo!

### Known Bugs
 - Stock wifi doesn't work (needs to be replaced with a compatible one)
 - SDCard reader
 - 2.1 audio (2.0 works)
 - Headphone's internal microphone

### Specs
 - Intel i7-7700HQ CPU
 - Intel HD Graphics 630 / nVidia GTX 1050 Ti
 - 16GB 2400MHz DDR4 RAM
 - 15.6” 1080p IPS Display
 - 128GB SanDisk M.2 SSD (SATA)
 - 1TB 5400RPM Western Digital HDD

## Creating macOS HighSierra USB

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
  - Install Clover
  - Place the files from given zip file (from this repo) into your *EFI/Clover* folder in usb accordingly.


## Booting USB and Installing macOS

  - Press F12 repeatedly for one-time boot-menu and select your usb
  - Choose *install_osx* in clover (preferably boot with -v option)
  - Open *diskutility* and format the partition into HFS+J or apfs and label the partition (eg. macOS)
  - Using HFS+J instead of apfs on your SSD:
      - Target volume must already be formatted with HFS+J
      - Open *Terminal* from the *Utilities* menu in the macOS installer and type:
        <pre>"/Volumes/Image Volume/Install macOS High Sierra.app/Contents/Resources/startosinstall" --volume <b>the_target_volume</b> --converttoapfs NO --agreetolicense
        </pre>
      - Choose *the_target_volume* depending on how you named your partition (eg. /Volumes/macOS)
  - System now automatically reboots, boot again into clover, but now select 'Install macOS High Sierra' instead of 'install_osx'
  

## Post Installation

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
  - Run `Scripts/fixPermissions.sh` as root to fix kext permissions
  - Reboot the laptop and boot with '-f' command line option (press space at clover)
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

## Troubleshooting
**1) Backlight level is not persisting across reboot**
 - Boot into macOS
 - Mount EFI folder and delete nvram.plist in the folder
 - Clear nvram variables from terminal using `sudo nvram -c`
 - Reboot into Clover
 - Open Clover UEFI Shell and type following commands:
   ```bash
   FS0: 
   cd EFI 
   dmpstore -all -s dmpvars.txt
   ```
 - Find the GUID of the `backlight-level` variable (same for all macOS nvram variables) and type the following command in the same shell:
   ```bash
   dmpstore -d -guid <GUID of macOS variables> 
   exit
   ```
 - Reboot  

**2) Sound is not working**
 - Some higher versions of AppleALC doesn't seem to work properly. So install a tested version like 1.2.8
 - Make sure Lilu is installed & AppleALC is loaded after Lilu: If you use /L/E for kexts, make sure you have LiluFriend.kext
 - If you have FakePCIID kexts, remove them. These patches are already included in AppleALC(atleast in 1.2.8) and are not needed
 - Make sure kexts are loading properly. Sometimes kexts fail to load due to improper permissions. Use `Scripts/fixPersmissions.sh`
 - If none of the above worked, try posting in forums like tonymacx86.com  

## Credits
 - [Rehabman](https://www.tonymacx86.com/members/rehabman.429483/)
 - [AGuyWhoIsBored](https://www.tonymacx86.com/members/aguywhoisbored.1105835/)
 - [Me](https://www.github.com/Nihhaar/) *(For putting this together & adding many required patches(see commits))*

## References
 - https://www.tonymacx86.com/threads/guide-dell-inspiron-15-7567-and-similar-near-full-functionality.234988/
 - https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/
 - https://www.tonymacx86.com/threads/guide-avoid-apfs-conversion-on-high-sierra-update-or-fresh-install.232855/
 - https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/
 - https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/
 - https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/
 - https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/
 - https://www.tonymacx86.com/threads/solved-backlight-turns-to-full-brightness-after-sleep-or-restart.192065/page-4
