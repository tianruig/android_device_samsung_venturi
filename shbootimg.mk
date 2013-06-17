LOCAL_PATH := $(call my-dir)

# Gzip within gzip is unnecessary and slow
uncompressed_ramdisk := $(PRODUCT_OUT)/ramdisk.cpio
$(uncompressed_ramdisk): $(INSTALLED_RAMDISK_TARGET)
	zcat $< > $@

# Ramdisk and recovery are required to build kernel
TARGET_KERNEL_BINARIES : $(recovery_ramdisk) $(uncompressed_ramdisk) $(PRODUCT_OUT)/utilities/busybox $(PRODUCT_OUT)/utilities/make_ext4fs

$(INSTALLED_BOOTIMAGE_TARGET): $(INSTALLED_KERNEL_TARGET) | $(ACP)
	$(call pretty,"Boot image: $@")
	$(hide) $(ACP) $(INSTALLED_KERNEL_TARGET) $@

$(INSTALLED_RECOVERYIMAGE_TARGET): $(INSTALLED_BOOTIMAGE_TARGET)
	$(hide) $(ACP) $(INSTALLED_BOOTIMAGE_TARGET) $@
