# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# BoardConfigCommon.mk
#
# Product-specific compile-time definitions.
#

# Set this up here so that BoardVendorConfig.mk can override it
BOARD_USES_LIBSECRIL_STUB := true

-include vendor/samsung/venturi/BoardConfigVendor.mk

TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := scorpion

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

TARGET_BOARD_PLATFORM := s5pc110
TARGET_BOARD_PLATFORM_GPU := POWERVR_SGX540_120
TARGET_BOOTLOADER_BOARD_NAME := s5pc110

# Kernel
TARGET_KERNEL_SOURCE := kernel/samsung/venturi
BOARD_KERNEL_BASE := 0x30008000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_CMDLINE := console=ttyFIQ0,115200 init=/init no_console_suspend

# External apps on SD
TARGET_EXTERNAL_APPS = sdcard1

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/samsung/venturi

# Camera
BOARD_CAMERA_LIBRARIES := libcamera
BOARD_CAMERA_HAVE_ISO := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/venturi/bluetooth
BOARD_BLUEDROID_VENDOR_CONF := device/samsung/venturi/bluetooth/libbt_vndcfg.txt

# Dalvik lower memory footprint
TARGET_ARCH_LOWMEM := true

# Framework sync
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

# FM Radio
BOARD_HAVE_FM_RADIO := true
BOARD_GLOBAL_CFLAGS += -DHAVE_FM_RADIO
BOARD_FM_DEVICE := si4709

# Video Devices
BOARD_V4L2_DEVICE := /dev/video1
BOARD_CAMERA_DEVICE := /dev/video0
BOARD_SECOND_CAMERA_DEVICE := /dev/video2

# Partitions
BOARD_NAND_PAGE_SIZE := 4096
BOARD_NAND_SPARE_SIZE := 128
BOARD_BOOTIMAGE_PARTITION_SIZE := 7864320
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 419430400
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2017460224
BOARD_FLASH_BLOCK_SIZE := 4096

# Connectivity - Wi-Fi
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE                := bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_BAND                        := 802_11_ABG
WIFI_DRIVER_FW_PATH_STA          := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP           := "/vendor/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_PARAM        := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_MODULE_NAME          := bcmdhd
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/bcmdhd.ko"
WPA_SUPPLICANT_VERSION           := VER_0_8_X

# Vold
BOARD_VOLD_MAX_PARTITIONS    := 17
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/s3c-usbgadget/gadget/lun%d/file"

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_CUSTOM_GRAPHICS := ../../../device/samsung/venturi/recovery/graphics.c
BOARD_CUSTOM_BOOTIMG_MK := device/samsung/venturi/shbootimg.mk
TARGET_RECOVERY_FSTAB := device/samsung/venturi/fstab.venturi
RECOVERY_FSTAB_VERSION := 2

#TWRP
PRODUCT_COPY_FILES += device/samsung/venturi/etc/twrp.fstab:recovery/root/etc/twrp.fstab
DEVICE_RESOLUTION := 480x800
TW_BRIGHTNESS_PATH := /sys/class/backlight/s5p_bl/brightness
TW_NO_SCREEN_BLANK := true
TWHAVE_SELINUX := true

#PhilZ
BRIGHTNESS_SYS_FILE := /sys/class/backlight/s5p_bl/brightness
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../../device/samsung/venturi/recovery/recovery_keys.c

#LVM
#LVM to ramdisks
PRODUCT_COPY_FILES += device/samsung/venturi/lvm/etc/lvm.conf:root/lvm/etc/lvm.conf
PRODUCT_COPY_FILES += device/samsung/venturi/lvm/sbin/lvm:root/lvm/sbin/lvm
#LVM to updatezip
PRODUCT_COPY_FILES += device/samsung/venturi/lvm/etc/lvm.conf:lvm/etc/lvm.conf
PRODUCT_COPY_FILES += device/samsung/venturi/lvm/sbin/lvm:lvm/sbin/lvm
#LVM Conversion...
PRODUCT_COPY_FILES += device/samsung/venturi/etc/twrp.fstab:twrp.fstab
PRODUCT_COPY_FILES += device/samsung/venturi/fstab:fstab

# Boot Animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true
TARGET_BOOTANIMATION_USE_RGB565 := true

BOARD_USE_LEGACY_TOUCHSCREEN := true

# TARGET_DISABLE_TRIPLE_BUFFERING can be used to disable triple buffering
# on per target basis. On crespo it is possible to do so in theory
# to save memory, however, there are currently some limitations in the
# OpenGL ES driver that in conjunction with disable triple-buffering
# would hurt performance significantly (see b/6016711)
TARGET_DISABLE_TRIPLE_BUFFERING := false

BOARD_ALLOW_EGL_HIBERNATION := false

# Our devices uses old GPU blobs
BOARD_EGL_WORKAROUND_BUG_10194508 := true

# hwcomposer: custom vsync ioctl
BOARD_CUSTOM_VSYNC_IOCTL := true

# Charging mode
BOARD_CHARGING_MODE_BOOTING_LPM := /sys/class/power_supply/battery/charging_mode_booting
BOARD_CHARGER_ENABLE_SUSPEND := false
BOARD_CHARGER_DISABLE_INIT_BLANK := false
BOARD_CHARGER_CUSTOM_BACKLIGHT_PATH := /sys/class/backlight/s5p_bl/brightness

# Include venturi specific stuff
-include device/samsung/venturi/Android.mk

# SELinux
BOARD_SEPOLICY_DIRS += \
	device/samsung/venturi/sepolicy

BOARD_SEPOLICY_UNION += \
        device.te \
	domain.te \
	file_contexts \
	file.te \
	geomagneticd.te \
	init.te \
	mediaserver.te \
	orientationd.te \
	pvrsrvinit.te \
	system.te \
	wpa_supplicant.te
