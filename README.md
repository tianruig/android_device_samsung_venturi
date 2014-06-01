# Beanstalk 4.4+ for the YP-G70 (venturi)

### Kernel
This device tree is intended to be used with the Nutella Kernel
See: https://github.com/Meticulus/nutella_kernel_samsung_venturi
### Vendor
This device tree is intented to be used with this vendor repo
https://github.com/Meticulus/android_vendor_samsung_venturi
### Hardware
This device tree is intented to be used with this hardware repo
https://github.com/Meticulus/android_hardware_samsung

### Camera
The camera HAL is modified from the CyanogenMod P1 cameral HAL. There is no opensource implementation of our camera HAL.
The rear camera photo snap does not fuction that way it was designed. We are capturing images of the preview just like the
the front camera does. To date no proper fix exists for the rear camera.
### Partitions
-We introduced Logical Volume Management(LVM) in KitKat so that we could get more space on the system partition and maintain compatiblity with older ROMS.
--This changes the installation precedure a bit. User must flash twice to confirm that it is OK for the system and data
partitions to be wiped.

--This makes reverting to a pre - KitKat ROM a little tricky. First, because recovery is in the zImage of the kernel, the pre-KitKat ROM's kernel must be flashed. It will have the old fstab structure Then a full wipe in recovery to git ride of the logical volume data. At this point you are ready to flash the pre-KitKat ROM.

For More Info See: https://github.com/Meticulus/beanstalk_device_samsung_venturi/commit/2a40715552a807ad522ebf5b3d787d83a1fa234e


### Background

The files in this folder are the product of the aries-common folder from https://github.com/CyanogenMod/android_device_samsung_aries-common
and the vibrantmtd folder from https://github.com/CyanogenMod/android_device_samsung_vibrantmtd merged into one, and modified to run on the
Samsung Galaxy Player 5.0 aka venturi.

# How To Build

### Step 1 Setting up the Build Environment.

You'll need Linux to be able to build Beanstalk. You have three choices here; you can: 
1. Install Linux natively on your computer.
2. Dual boot Linux and Windows.
3. Use virtual machine software ( virtual box, vmware ) to run linux.

NOTE: I recommend you use Ubuntu 12.04 LTS to build. That's what I use.

Now read this: http://source.android.com/source/initializing.html

NOTE: When I say "read", I mean read and comprehend.

### Step 2 Downloading the Source.

NOTE: Some say that it is better to download the ROM source and put in your local manifest later. I don't know if that's best but that's what we are going to do.

Execute the following command in a linux terminal:

1. mkdir /home/$USER/BS
2. cd /home/$USER/BS
3. repo init -u git://github.com/scotthartbti/android.git -b kk44
4. repo sync

NOTE: Steps 3 and 4 are from Scott's repo here: https://github.com/scotthartbti/android/tree/kk44


