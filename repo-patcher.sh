#!/bin/sh

echo Patching each individual repo for regular building...

cd build
git reset --hard && git clean -f -d
patch -p1 < $HOME/cm11.0/device/htc/pyramid/patches/build.patch
cd ../frameworks/opt/telephony
git reset --hard && git clean -f -d
patch -p1 < ../../../device/htc/pyramid/patches/frameworks-opt-telephony.patch
cd ../../..
