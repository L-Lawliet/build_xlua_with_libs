#!/bin/bash
set -e

# ===== 1. 真机 arm64 =====
mkdir -p build_ios_device && cd build_ios_device
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=OS64 -GXcode ../
cd ..
cmake --build build_ios_device --config Release --parallel

# ===== 2. 模拟器 arm64 =====
mkdir -p build_ios_sim && cd build_ios_sim
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=SIMULATORARM64 -GXcode ../
cd ..
cmake --build build_ios_sim --config Release --parallel

# ===== 3. 打包 XCFramework =====
mkdir -p plugin_lua53_simulator/Plugins/iOS/
xcodebuild -create-xcframework \
    -library build_ios_device/Release-iphoneos/libxlua.a \
    -library build_ios_sim/Release-iphonesimulator/libxlua.a \
    -output plugin_lua53_simulator/Plugins/iOS/libxlua.xcframework

echo ""
echo "========== 打包完成 =========="
ls plugin_lua53_simulator/Plugins/iOS/libxlua.xcframework/
