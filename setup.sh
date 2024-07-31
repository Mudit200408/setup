#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {pixelstar|tpp}"
    exit 1
fi

if [ "$1" == "pixelstar" ]; then
    # Clone repositories for pixelstar
    git clone https://github.com/Mudit200408/device_xiaomi_munch device/xiaomi/munch 
    git clone https://github.com/Mudit200408/device_xiaomi_sm8250-common device/xiaomi/sm8250-common
elif [ "$1" == "tpp" ]; then
    # Clone repositories for tpp
    git clone https://github.com/Mudit200408/device_xiaomi_munch -b 14-tpp device/xiaomi/munch 
    git clone https://github.com/Mudit200408/device_xiaomi_sm8250-common -b 14-tpp device/xiaomi/sm8250-common
else
    echo "Invalid argument: $1. Use 'pixelstar' or 'tpp'."
    exit 1
fi

# Clone common repositories
git clone https://github.com/Mudit200408/hardware_xiaomi hardware/xiaomi
git clone https://gitea.com/hdzungx/android_vendor_xiaomi_miuicamera vendor/xiaomi/miuicamera
git clone https://github.com/TheParasiteProject/packages_apps_KProfiles packages/apps/KProfiles 
git clone https://gitlab.com/Mudit200408/vendor_xiaomi_munch vendor/xiaomi/munch
git clone https://gitlab.com/Mudit200408/vendor_xiaomi_sm8250-common vendor/xiaomi/sm8250-common
git clone https://github.com/Mudit200408/android_hardware_dolby hardware/dolby

# Remove and replace directory
rm -rf hardware/qcom-caf/sm8250/display
git clone https://github.com/Project-PixelStar/hardware_qcom-caf_sm8250_display hardware/qcom-caf/sm8250/display

# Clone and setup kernel
git clone https://github.com/kvsnr113/xiaomi_sm8250_kernel kernel/xiaomi/sm8250
cd kernel/xiaomi/sm8250
git submodule init && git submodule update 
rm -rf KernelSU/userspace/su

# Go back to the original directory
cd ../../..

# Setup Clang toolchain
cd prebuilts/clang/host/linux-x86
mkdir clang-neutron
cd clang-neutron
curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
chmod +x antman
./antman -S=05012024

# Go back to the original directory again
cd ../../../../..

# Modify the AndroidManifest.xml
sed -i 's/android:minSdkVersion="19"/android:minSdkVersion="21"/' prebuilts/sdk/current/androidx/m2repository/androidx/preference/preference/1.3.0-alpha01/manifest/AndroidManifest.xml
