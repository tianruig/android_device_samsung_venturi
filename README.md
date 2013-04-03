Device files for the Samsung Galaxy Player 5.0 USA

The files in this folder are the product of the aries-common folder from https://github.com/CyanogenMod/android_device_samsung_aries-common
and the vibrantmtd folder from https://github.com/CyanogenMod/android_device_samsung_vibrantmtd merged into one, and modified to run on the
US Samsung Galaxy Player 5.0 aka venturi_usa.

In order to build CM-10.1 for this device, one must clone:

1. the android_hardware_samsung repository from https://github.com/CyanogenMod/android_hardware_samsung and place it under (sourceroot)/hardware/samsung

2. the device folder source (this repository) and place it under (sourceroot)/device/samsung/venturi_usa

3. the vendor folder source from https://github.com/JackpotClavin/android_vendor_samsung_venturi_usa and place it under (sourceroot)/vendor/samsung/venturi_usa

4. and lastly, the kernel source tree https://github.com/JackpotClavin/android_kernel_samsung_venturi and place it under (sourceroot)/kernel/samsung/kernel/venturi

The after syncing the entire CyanogenMod source tree, type ". build/envsetup.sh" and then the build command is "brunch venturi_usa"

Modification and improving the aforementioned source tree is strongly encouraged! Happy building!
