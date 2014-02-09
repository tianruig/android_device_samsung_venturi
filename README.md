Device files for the Samsung Galaxy Player 5.0

## Building ROMs

The files in this folder are the product of the aries-common folder from https://github.com/CyanogenMod/android_device_samsung_aries-common
and the vibrantmtd folder from https://github.com/CyanogenMod/android_device_samsung_vibrantmtd merged into one, and modified to run on the
Samsung Galaxy Player 5.0 aka venturi.

In order to build CM-11.0 for this device, sync the entire CyanogenMod repo (instructions here: http://wiki.cyanogenmod.org/w/Build_for_vibrantmtd) but do up to where you run "repo sync" and it downloads the source. After the source is all downloaded, run:

```bash
mkdir .repo/local_manifests
curl https://raw.github.com/iurnait/android_device_samsung_venturi/cm-11.0/roomservice.xml > .repo/local_manifests/roomservice.xml
```

Then, run "repo sync" one more time. After it gets the device, vendor, kernel, and Samsung hardware files you will be able to build.

The after syncing the entire CyanogenMod source tree and the Venturi files, type:

```bash
. build/envsetup.sh
```

and then the build command is:
```bash
brunch venturi
```

Modification and improving the aforementioned source tree is strongly encouraged! Happy building!

## Building just the kernel and boot.img

A tip: If you're just making a kernel, you don't have to make an entire .zip file. Instead, type:

```bash
. build/envsetup.sh
```

Then, type:

```bash
lunch cm_venturi-userdebug
```

And to direct your build environment to make just a bootimage, type:

```bash
mka bootimage
```

This will build the kernel and ramdisk and recovery and package it into a nice boot.img that you can install (should be around 5.6MB)
