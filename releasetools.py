# Copyright (C) 2012 The Android Open Source Project
# Copyright (C) 2012 The CyanogenMod Project
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

"""Custom OTA commands for venturi"""

import common
import os

LOCAL_DIR = os.path.dirname(os.path.abspath(__file__))
TARGET_DIR = os.getenv('OUT')
UTILITIES_DIR = os.path.join(TARGET_DIR, 'utilities')

def FullOTA_Assertions(info):
  info.output_zip.write(os.path.join(TARGET_DIR, "updater.sh"), "updater.sh")
  info.output_zip.write(os.path.join(TARGET_DIR, "restorecon.sh"), "restorecon.sh")
  info.output_zip.write(os.path.join(TARGET_DIR, "lvm/sbin/lvm"), "lvm/sbin/lvm")
  info.output_zip.write(os.path.join(TARGET_DIR, "lvm/etc/lvm.conf"), "lvm/etc/lvm.conf")
  info.output_zip.write(os.path.join(TARGET_DIR, "twrp.fstab"), "twrp.fstab")
  info.output_zip.write(os.path.join(TARGET_DIR, "fstab"), "fstab")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "make_ext4fs"), "make_ext4fs")
  info.output_zip.write(os.path.join(UTILITIES_DIR, "busybox"), "busybox")

  info.script.AppendExtra(
        ('package_extract_file("updater.sh", "/tmp/updater.sh");\n'
         'set_perm(0, 0, 0777, "/tmp/updater.sh");'))
  info.script.AppendExtra(
        ('package_extract_file("restorecon.sh", "/tmp/restorecon.sh");\n'
         'set_perm(0, 0, 0777, "/tmp/restorecon.sh");'))
  info.script.AppendExtra(
       ('package_extract_file("make_ext4fs", "/tmp/make_ext4fs");\n'
        'set_perm(0, 0, 0777, "/tmp/make_ext4fs");'))
  info.script.AppendExtra(
        ('package_extract_file("busybox", "/tmp/busybox");\n'
         'set_perm(0, 0, 0777, "/tmp/busybox");'))
  #Copy temporary replacement fstab's to temp
  info.script.AppendExtra(
        ('package_extract_file("twrp.fstab", "/tmp/twrp.fstab");\n'
         'set_perm(0, 0, 0777, "/tmp/twrp.fstab");'))
  info.script.AppendExtra(
        ('package_extract_file("fstab", "/tmp/fstab");\n'
         'set_perm(0, 0, 0777, "/tmp/fstab");'))
  #Create directories for LVM
  info.script.AppendExtra(
        ('run_program("/tmp/busybox","mkdir","lvm");')) 
  info.script.AppendExtra(
        ('run_program("/tmp/busybox", "mkdir", "lvm/sbin");')) 
  info.script.AppendExtra(
        ('run_program("/tmp/busybox", "mkdir", "lvm/etc");'))
  #Extract LVM files
  info.script.AppendExtra(
        ('package_extract_file("lvm/sbin/lvm", "/lvm/sbin/lvm");\n'
         'set_perm(0, 0, 0777, "/lvm/sbin/lvm");'))
  info.script.AppendExtra(
        ('package_extract_file("lvm/etc/lvm.conf", "/lvm/etc/lvm.conf");\n'
         'set_perm(0, 0, 0777, "lvm/etc/lvm.conf");'))
  
  info.script.AppendExtra('ui_print("");')
  info.script.AppendExtra('ui_print("");')
  info.script.AppendExtra('ui_print("===================================");')
  info.script.AppendExtra('ui_print("IF this ROMs partition layout is   |");')
  info.script.AppendExtra('ui_print("incompatible, This installer will  |");')
  info.script.AppendExtra('ui_print("error the first time you flash...  |");')
  info.script.AppendExtra('ui_print("IN THAT CASE:                      |");')
  info.script.AppendExtra('ui_print("Flash AGAIN and /system and /data  |");')
  info.script.AppendExtra('ui_print("will be ERASED and installation    |");')
  info.script.AppendExtra('ui_print("will continue as normal.           |");')
  info.script.AppendExtra('ui_print("===================================");')
  info.script.AppendExtra('ui_print("");')
  info.script.AppendExtra('ui_print("");')

  info.script.AppendExtra('package_extract_file("boot.img", "/tmp/boot.img");')
  info.script.AppendExtra('assert(run_program("/tmp/updater.sh") == 0);')

  # switch to new LVM fstab now that lvpools have been created.
  # /system: old (/dev/block/mmcblk0p13) new: (/dev/lvpool/system)
  # /data: old (/dev/block/mmcblk0p16) new: (/dev/lvpool/data)
  info.script.AppendExtra('run_program("/tmp/busybox", "rm", "/etc/recovery.fstab");')
  info.script.AppendExtra('run_program("/tmp/busybox", "rm", "/etc/fstab");')
  info.script.AppendExtra('symlink("/tmp/twrp.fstab", "/etc/recovery.fstab");')
  info.script.AppendExtra('symlink("/tmp/fstab", "/etc/fstab");')

# Force clean install! Bypass all that persistence crap!
  info.script.AppendExtra('ui_print("Enforcing clean install...");')
  info.script.AppendExtra('assert(run_program("/sbin/busybox", "umount","/system") == 0);')
  info.script.AppendExtra('assert(run_program("/tmp/make_ext4fs", "-b", "4096", "-g", "32768", "-i", "8192", "-I", "256", "-a","/system", "/dev/lvpool/system") == 0);')

def FullOTA_InstallEnd(info):
  info.script.AppendExtra('assert(run_program("/tmp/restorecon.sh") == 0);')

# GApps must be reinstalled every flash now!
  info.script.AppendExtra('ui_print("Remember to install/re-install GApps on every ROM flash! -Meticulus");')

