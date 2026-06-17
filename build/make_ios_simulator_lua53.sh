#!/bin/bash
set -e

# ===== 1. 真机 arm64 =====
mkdir -p build_ios_device && cd build_ios_device
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=OS64 -GXcode ../
cd ..
cmake --build build_ios_device --config Release --parallel

# ===== 2. Intel 模拟器 x86_64 =====
mkdir -p build_ios_sim_x86 && cd build_ios_sim_x86
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=SIMULATOR64 -GXcode ../
cd ..
cmake --build build_ios_sim_x86 --config Release --parallel

# ===== 3. Apple Silicon 模拟器 arm64 =====
mkdir -p build_ios_sim_arm64 && cd build_ios_sim_arm64
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=SIMULATORARM64 -GXcode ../
cd ..
cmake --build build_ios_sim_arm64 --config Release --parallel

# ===== 4. 合并三架构 =====
mkdir -p plugin_lua53_simulator/Plugins/iOS/
lipo -create \
    build_ios_device/Release-iphoneos/libxlua.a \
    build_ios_sim_x86/Release-iphonesimulator/libxlua.a \
    build_ios_sim_arm64/Release-iphonesimulator/libxlua.a \
    -output plugin_lua53_simulator/Plugins/iOS/libxlua.a

echo ""
echo "========== 合并完成 =========="
echo "包含的架构:"
lipo -info plugin_lua53_simulator/Plugins/iOS/libxlua.a
