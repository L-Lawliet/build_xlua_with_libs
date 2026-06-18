#!/bin/bash
set -e

# ===== 1. 真机 arm64 =====
mkdir -p build_ios_device && cd build_ios_device
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=OS64 -GXcode ../
cd ..
cmake --build build_ios_device --config Release --parallel

# ===== 2. 模拟器 (CI 机器原生架构) =====
mkdir -p build_ios_sim && cd build_ios_sim
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=SIMULATOR64 -GXcode ../
cd ..
cmake --build build_ios_sim --config Release --parallel

# ===== 3. 合并 (同架构去重) =====
mkdir -p plugin_lua53_simulator/Plugins/iOS/

DEVICE_LIB=build_ios_device/Release-iphoneos/libxlua.a
SIM_LIB=build_ios_sim/Release-iphonesimulator/libxlua.a
OUTPUT=plugin_lua53_simulator/Plugins/iOS/libxlua.a

DEVICE_ARCH=$(lipo -info "$DEVICE_LIB" | sed 's/.*: //' | xargs)
SIM_ARCH=$(lipo -info "$SIM_LIB" | sed 's/.*: //' | xargs)

echo "设备架构: $DEVICE_ARCH"
echo "模拟器架构: $SIM_ARCH"

if [ "$DEVICE_ARCH" = "$SIM_ARCH" ]; then
    echo "架构相同，直接复制..."
    cp "$DEVICE_LIB" "$OUTPUT"
else
    echo "架构不同，lipo 合并..."
    lipo -create "$DEVICE_LIB" "$SIM_LIB" -output "$OUTPUT"
fi

echo ""
echo "========== 合并完成 =========="
lipo -info "$OUTPUT"
