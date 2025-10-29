## v2.1.16_1    2025/10/29

### 修改：
- 针对Android 16k pagesize，同步了`xlua`和`build_xlua_with_libs`的一些修改：
  - CMakeList.txt的相关配置
  - build.yml和publish.yml的相关配置
- NDK升级到28c，以支持Android 16k pagesize
- 支持m1芯片osx的构建
- 修复lua5.4.6，构建iOS平台时出现报错（'system' is unavailable: not available on iOS） (#1133)
- 修复5.4.6报错 memory_leak_checker.c(153,4)  (#1085)
- 调整window的构建、发布逻辑，适应新的window系统

### 备注：
- NDK没有使用xlua官方的21b，而是使用28c（Android推荐NDK版本）。21b发布的debug模式不支持16k，xlua官方发布的是release。
- 相关jit构建没用同步，因为没有使用到。
- 鸿蒙和uwp的相关构建没有同步到，因为没有使用到。