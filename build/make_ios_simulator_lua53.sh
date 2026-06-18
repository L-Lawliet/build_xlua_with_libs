#!/bin/bash
set -e

mkdir -p build_ios_sim && cd build_ios_sim
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/ios.toolchain.cmake -DPLATFORM=SIMULATORARM64 -GXcode ../
cd ..
cmake --build build_ios_sim --config Release --parallel

mkdir -p plugin_lua53_simulator/Plugins/iOS/
cp build_ios_sim/Release-iphonesimulator/libxlua.a plugin_lua53_simulator/Plugins/iOS/libxlua.a

echo ""
echo "========== 构建完成 =========="
echo "包含的架构:"
lipo -info plugin_lua53_simulator/Plugins/iOS/libxlua.a
