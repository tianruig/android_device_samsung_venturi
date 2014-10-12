# Carbon ROM (KitKat) for the YP-G70 (venturi)

### Kernel
This device tree is intended to be used with the Nutella Kernel

See: https://github.com/Meticulus/nutella_kernel_samsung_venturi

branch: master
### Vendor
This device tree is intented to be used with this vendor repo

See: https://github.com/Meticulus/android_vendor_samsung_venturi

branch cm-11.0

### Camera
The camera HAL is modified from the CyanogenMod P1 cameral HAL. There is no opensource implementation of our camera HAL.
The rear camera photo snap does not fuction that way it was designed. We are capturing images of the preview just like the
the front camera does. To date no proper fix exists for the rear camera.
### Partitions
-We introduced Logical Volume Management(LVM) in KitKat so that we could get more space on the system partition and maintain compatiblity with older ROMS.
--This changes the installation precedure a bit. User must flash twice to confirm that it is OK for the system and data
partitions to be wiped.

--This makes reverting to a pre - KitKat ROM a little tricky. First, because recovery is in the zImage of the kernel, the pre-KitKat ROM's kernel must be flashed. It will have the old fstab structure Then a full wipe in recovery to git ride of the logical volume data. At this point you are ready to flash the pre-KitKat ROM.

For More Info See: https://github.com/Meticulus/android_device_samsung_venturi/commit/2a40715552a807ad522ebf5b3d787d83a1fa234e


### Background

The files in this folder are the product of the aries-common folder from https://github.com/CyanogenMod/android_device_samsung_aries-common
and the vibrantmtd folder from https://github.com/CyanogenMod/android_device_samsung_vibrantmtd merged into one, and modified to run on the
Samsung Galaxy Player 5.0 aka venturi.

# How To Build

### Step 1: Setting up the Build Environment.

You'll need Linux to be able to build Carbon ROM. You have three choices here; you can:

1. Install Linux natively on your computer.
2. Dual boot Linux and Windows.
3. Use virtual machine software ( virtual box, vmware ) to run linux.

NOTE: I recommend you use Ubuntu 12.04 LTS to build. That's what I use.

Now read this: http://source.android.com/source/initializing.html

NOTE: When I say "read", I mean read and comprehend.

NOTE: Read through the topics here as well: http://wiki.cyanogenmod.org/w/Development
### Step 2: Downloading the Source.

NOTE: Some say that it is better to download the ROM source and put in your local manifest later. I don't know if that's best but that's what we are going to do.

BEFORE YOU BEGIN: You are about to start downloading 5 - 15 Gigs of data. That could take a very long time, so plan accordingly. I like to start just before I go to sleep and let it go overnight! If you have to work, perhaps start it before work and let it go through out the day.

Execute the following commands in a linux terminal:
```bash
mkdir /home/$USER/carbon
cd /home/$USER/carbon
repo init -u https://github.com/CarbonDev/android.git -b kk
repo sync
```
WARNING: There may be times, towards the end when it seem like, the download is stuck and not making any progress because there are no updates on the screen. BE PATIENT!, open a program that will show how much bandwidth you are using to be sure!


### Step 3: Set up local manifest.

The local manifest is different for every device. It contains those repos that are device specific, where as the ROM code you just "repo sync'd" is code that is general to any device.

Execute the following commands in a linux terminal:
```bash
gedit /home/$USER/carbon/.repo/local_manifests/venturi.xml
```
Now copy the following into venturi.xml, save and close.
```bash
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="Meticulus/android_device_samsung_venturi" path="device/samsung/venturi" remote="github" revision="carbon"/>
  <project name="Meticulus/nutella_samsung_venturi" path="kernel/samsung/venturi" remote="github" revision="master"/>
  <project name="Meticulus/android_vendor_samsung_venturi" path="vendor/samsung/venturi" remote="github" revision="cm-11.0"/>
</manifest>
```
Execute the following commands in a linux terminal:
```bash
cd /home/$USER/carbon
repo sync
```

NOTE: Yes we are syncing again and No, it shouldn't take quite as long. Every time you repo sync just new data is downloaded. So we are downloading the 4 repo's we just put in and any updates that may have occured to the repo's we already have.

### Step 4: Building

NOTE: Now you have everything that you need to build Carbon ROM for your Galaxy Player 5. Build times depend on you PC performance specifications. In the following terminal command "-j8" represents the number of concurrent tasks to execute. For low specs machines (such as mine) lowering the value to "-j3" may help speed things up. For high spec'd machines raising the value may speed things up.

NOTE: It may take anywhere from 5 hours to 15 hours depending on system specs for a complete build.
Execute the following commands in a linux terminal:
```bash
cd /home/$USER/carbon
. build/envsetup.sh
lunch cm_venturi-userdebug
make -j8 otapackage
```
WARNING: There may be times, towards the end when it seem like, the build is stuck because of a lack of updates on the screen. BE PATIENT! libwebviewchromium.so is a beast and is usually the last file to be build. It takes awhile to complete. I ususally have 15 to 20 minutes of "no screen activity" before it finally finishes building that lib and then continues...
