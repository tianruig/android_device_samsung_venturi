#!/bin/sh

echo Patching each individual repo for regular building...

cd build
git reset --hard && git clean -f -d
patch -p1 < ../device/samsung/venturi/patches/build.patch
cd ../frameworks/opt/telephony
git reset --hard && git clean -f -d
patch -p1 < ../../../device/samsung/venturi/patches/frameworks-opt-telephony.patch
cd ../../..
