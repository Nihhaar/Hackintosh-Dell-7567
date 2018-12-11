# Personal Hackintosh Guide/Instructions for Dell 7567

### Screenshot
![macOS Mojave - 10.14.1](https://raw.githubusercontent.com/Nihhaar/Hackintosh-Dell-7567/master/Assets/Screenshot.png)

### Notice
This repo is archived as of Dec 11 (macOS version 10.14.2). The files here can still be used for future releases of macOS with just little tweaking and common sense. Be happy to fork it and develop, or I may unarchive it sometime in the future if I used macOS on this laptop again.

### Download Required Files
Check [releases](https://github.com/Nihhaar/Hackintosh-Dell7567/releases)
```
Clover USB Files:
 - drivers64UEFI: HFSPlus.efi (for HFS+ fs), apfs.efi (for apfs fs)

 - kexts/Other: 
   - ApplePS2SmartTouchpad: For initial trackpad & keyboard support
   - FakeSMC: SMC emulator
   - RealtekRT8111: Kext for ethernet support
   - SATA-100-series-unsupported: 
   - USBInjectAll: Injecting USB ports (even for recognizing the bootable USB)

 - config.plist: Initial SMBIOS, USBInjectAll dsdt patches, port limit patches (for usb 3.0)

----------------------------------

Clover Post-Install Files:
 - drivers64UEFI: HFSPlus.efi (for HFS+ fs), apfs.efi (for apfs fs)

 - /L/E Kexts:
   - ACPIBatteryManager: Kext for battery status
   - AppleBacklightFixup: Kext for backlight control
   - CodecCommander: Kext for solving 'no audio' after sleep
   - VoodooPS2Controller: Kext for keyboard

 - kexts/Other:
   - AppleALC: Kext for audio
   - AppleBacklightFixup: Kext for backlight control even in recovery 
   - FakeSMC: SMC emulator
   - Lilu: Generic kext patches
   - RealtekRT8111: Kext for ethernet support
   - SATA-100-series-unsupported: 
   - USBInjectAll: Injecting USB ports
   - VoodooI2C*: Kext for precision trackpad
   - VoodooPS2Controller: Kext for keyboard
   - WhateverGreen: Lilu plugin for various iGPU patches

 - config.plist:
   - DSDT Fixes: FixHPET, FixHeaders, FixIPIC, FixRTC, FixTMR
   - DSDT Patches: IGPU, IMEI, HDEF, OSI, PRW, VoodooI2C, brightness control patches
   - WhateverGreen properties: Disable unused ports, increase VRAM from 1536->2048 MB
   - Kernel and Kext Patches: DellSMBIOS, AppleRTC, KernelLapic, KernelPm
   - Kernel To Patch: MSR 0xE2, Panic kext logging
   - Kexts to Patch: I2C, SSD Trim, AppleALC patches
   - SMBIOS

 - patched:
   - SSDT-ALS0: Fake ambient light sensor
   - SSDT-BRT6: Brightness control via keyboard
   - SSDT-Disable_DGPU: Disable discrete GPU (Nvidia)
   - SSDT-I2C: VoodooI2C GPIO pinning & disabling VoodooPS2 kext for trackpads and mouses
   - SSDT-PNLF: Backlight ssdt
   - SSDT-PRW: SSDT for usb instant wake
   - SSDT-UIAC: Injecting right usb ports (coniguration for usbinjectall kext)
   - SSDT-XCPM: Injecting plugin-type for power management
   - SSDT-XOSI: Faking OS for the ACPI
   - SSDT_ALC256: CodecCommander config for ALC256 (removes headphone noise)

```

### Notes
 - Working hackintosh for 10.14 (Mojave) and 10.13.x (High Sierra)
 - No support for 4k *(I don't have a 4k variant)*. But I think it's just `my files` + `CoreDisplayFixup.kext` + `DVMT patch`
 - HDMI doesn't work on this hack because it is connected to nvidia card and we disabled it
 - Any other issues? Just open an issue in this repo!

### Known Bugs
 - Stock wifi doesn't work (needs to be replaced with a compatible one)
 - SDCard reader (probably fixed by some kext)
 - 2.1 audio (2.0 works)
 - Audio via headphones after sleep (This actually worked on previous releases, so may be need to downgrade AppleALC to tested version like 1.2.8)
 - Built-in mic for headphones may not work

### Specs
 - Intel i7-7700HQ CPU
 - Intel HD Graphics 630 / nVidia GTX 1050 Ti
 - 16GB 2400MHz DDR4 RAM
 - 15.6” 1080p IPS Display
 - 128GB SanDisk M.2 SSD (SATA)
 - 1TB 5400RPM Western Digital HDD

## Creating macOS USB

```bash
# Figure out identifier for of your usb (/dev/diskX, for example)
diskutil list

# Partition your usb in GPT
diskutil partitionDisk /dev/diskX 1 GPT HFS+J "install_osx" R

# Copy installer image (for highsierra)
sudo "/Applications/Install macOS High Sierra.app/Contents/Resources/createinstallmedia" --volume /Volumes/install_osx --nointeraction

# Copy installer imge (for mojave)
sudo "/Applications/Install macOS Mojave.app/Contents/Resources/createinstallmedia" --volume /Volumes/install_osx --applicationpath "/Applications/Install macOS Mojave.app" --nointeraction

# Rename (for highsierra)
sudo diskutil rename "Install macOS High Sierra" install_osx

# Rename (for mojave)
sudo diskutil rename "Install macOS Mojave" install_osx
```

**Download and install clover on usb**
  - Download [clover](https://bitbucket.org/RehabMan/clover/downloads/)
  - Run the installer
  - Select the target of the install to *"install_osx"* using *"Change Install Location"*
  - Select *Customize*
  - Check *"Install for UEFI booting only"*, *"Install Clover in the ESP"* will automatically select
  - check *"Metal"* from Themes
  - Check *"OsxAptioFix3Drv-64"* from Drivers64UEFI
  - Install Clover
  - Place the files from given zip file (from this repo) into your *EFI/Clover* folder in usb accordingly.


## Booting USB and Installing macOS

  - Press F12 repeatedly for one-time boot-menu and select your usb
  - Choose *install_osx* in clover (preferably boot with -v option)
  - Open *diskutility* and format the partition into HFS+J or apfs and label the partition (eg. macOS)
  - Using HFS+J instead of apfs on your SSD for **10.13.x**:
      - Target volume must already be formatted with HFS+J
      - Open *Terminal* from the *Utilities* menu in the macOS installer and type:
        <pre>"/Volumes/Image Volume/Install macOS High Sierra.app/Contents/Resources/startosinstall" --volume <b>the_target_volume</b> --converttoapfs NO --agreetolicense
        </pre>
      - Choose *the_target_volume* depending on how you named your partition (eg. /Volumes/macOS)
  - Using HFS+J on 10.14 is somewhat buggy right now, better to use APFS
  - System now automatically reboots, boot again into clover, but now select 'Install macOS High Sierra' (or 'Install macOS Mojave') instead of 'install_osx'
  

## Post Installation

**Download and Install clover bootloader**
  - Download [clover](https://bitbucket.org/RehabMan/clover/downloads/)
  - Run the installer
  - Select the target of the install to *"Target Volume"* using *"Change Install Location"*
  - Select *Customize*
  - Check *"Install for UEFI booting only"*, *"Install Clover in the ESP"* will automatically select
  - check *"Metal"* from Themes
  - Check *"OsxAptioFix3Drv-64"* from Drivers64UEFI
  - Check *"EmuVariableUefi-64.efi"* from Drivers64UEFI
  - Select *"Install RC scripts on target volume"*


**Configure Clover and your System**
  - Replace the existing config.plist with the config.plist from *“Clover Post-Install Files”*
  - Add the two EFI drivers from *“Clover Post-Install Files”/drivers64UEFI* to `<EFI Partition>/EFI/CLOVER/drivers64UEFI`, and remove VBoxHfs-64.efi from /EFI/CLOVER/drivers64UEFI
  - Add the included SSDTs in *patched* folder into your `<EFI Partition>/EFI/CLOVER/ACPI/patched` folder
  - Copy all of the kexts that are located in *Clover Post-Install Files/"Clover/Other Kexts"* folder to `<EFI Partition>/EFI/Clover/Other` on your system.
  - Copy all of the kexts that are located in *Clover Post-Install Files/"/L/E Kexts"* folder to `/Library/Extensions` on your system.
  - Run *Scripts/fixPermissions.sh* from given release as root to fix kext permissions
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
 - Make sure Lilu is installed & AppleALC is loaded after Lilu: If you use /L/E for kexts, make sure you have LiluFriend.kext and correctly configured
 - If you have FakePCIID kexts, remove them. These patches are already included in AppleALC(atleast in 1.2.8) and are not needed
 - Make sure kexts are loading properly. Sometimes kexts fail to load due to improper permissions. Use `Scripts/fixPersmissions.sh`
 - If none of the above worked, try posting in forums like tonymacx86.com  

**3) Fonts look blurry in mojave**
 - Apple nuked subpixel antialiasing in mojave, making non-retina screens blurry
 - This effect is noticable in 1080p but doesnt affect 4k or retina displays
 - The following makes things somewhat better:
```bash
# Type these commands in terminal and re-login to see the changes

defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
defaults -currentHost write -globalDomain AppleFontSmoothing -int 2
```
 - If you want to revert back to original settings:
```bash
# Type these commands in terminal and re-login to see the changes

defaults -currentHost delete -globalDomain AppleFontSmoothing
defaults write -g CGFontRenderingFontSmoothingDisabled -bool YES
```

**4) Scrolling is choppy with third party mice**
 - Use this tool: https://mos.caldis.me/, works well
 - Scroll direction can also be set via this tool

**5) Clover USB is not booting**
 - Probably needs port limit patch in config.plist for the OS version you are using (just google it)
 - Preferably, use USB 2.0 for avoiding port limit errors

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
 - https://www.reddit.com/r/apple/comments/8wpk18/macos_mojave_nukes_subpixel_antialiasing_making/
