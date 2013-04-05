Device files for the Samsung Galaxy Player 5.0 USA

The files in this folder are the product of the aries-common folder from https://github.com/CyanogenMod/android_device_samsung_aries-common
and the vibrantmtd folder from https://github.com/CyanogenMod/android_device_samsung_vibrantmtd merged into one, and modified to run on the
US Samsung Galaxy Player 5.0 aka venturi_usa.

In order to build CM-10.1 for this device, create a local_manifest.xml using the following below: 

```bash
<manifest>
  <project name="JackpotClavin/android_device_samsung_venturi_usa" path="device/samsung/venturi_usa" remote="github" />
  <project name="JackpotClavin/android_vendor_samsung_venturi_usa" path="vendor/samsung/venturi_usa" remote="github" />
  <project name="JackpotClavin/android_kernel_samsung_venturi" path="kernel/samsung/venturi" remote="github" />
  <project name="CyanogenMod/android_hardware_samsung" path="hardware/samsung" remote="github" />
</manifest>
```

The after syncing the entire CyanogenMod source tree, type ". build/envsetup.sh" and then the build command is "brunch venturi_usa"

Modification and improving the aforementioned source tree is strongly encouraged! Happy building!
