mkdir build32 & pushd build32
IF "%1" == "16" (
    cmake -G "Visual Studio 16 2019" -A x64 ..
) ELSE (
    cmake -G "Visual Studio 15 2017" ..
)
popd
cmake --build build32 --config Release
md plugin_lua53\Plugins\x86
copy /Y build32\Release\xlua.dll plugin_lua53\Plugins\x86\xlua.dll
pause