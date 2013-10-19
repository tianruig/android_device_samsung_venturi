#!/bin/sh

echo Patching each individual repo...
cd $HOME/cm10.2/system/core
git reset --hard && git clean -f -d
patch -p1 < $HOME/cm10.2/device/samsung/venturi/patches/system-core-pac.patch
cd $HOME/cm10.2/frameworks/opt/telephony
git reset --hard && git clean -f -d
patch -p1 < $HOME/cm10.2/device/samsung/venturi/patches/frameworks-opt-telephony.patch
cd $HOME/cm10.2
