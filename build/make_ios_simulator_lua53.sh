#!/bin/bash
set -e

# ===== 1. 模拟器 arm64 =====
mkdir -p build_ios_sim && cd build_ios_sim
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=SIMULATORARM64 -GXcode ../
cd ..
cmake --build build_ios_sim --config Release --parallel

# ===== 2. 复制为单个库文件 =====
mkdir -p plugin_lua53_simulator/Plugins/iOS/
cp build_ios_sim/Release-iphonesimulator/libxlua.a plugin_lua53_simulator/Plugins/iOS/libxlua.a

echo ""
echo "========== 构建完成 =========="
echo "模拟器库:"
lipo -info plugin_lua53_simulator/Plugins/iOS/libxlua.a
echo ""
echo "Unity 中设置:"
echo "  将 plugin_lua53_simulator/Plugins/iOS/libxlua.a 覆盖到 Assets/Plugins/iOS/ 下（仅用于 iOS 模拟器）"
