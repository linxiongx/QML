# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Qt 6 QML 的图片浏览器应用程序，使用 CMake 构建。应用程序提供图片查看功能，包括缩放、平移、幻灯片播放和各种工具按钮。

## 架构

这是一个多项目代码库，包含两个主要组件：

- **ImageViewer**: 主应用程序，包含用户界面和核心功能
- **ImageInfo**: QML 插件，提供图片信息读取功能

### 主要组件

- **前端**: 基于 QML 的用户界面，包含自定义组件
- **后端**: C++ 类用于图片处理和幻灯片功能
- **构建系统**: 使用 CMake 和 Qt 6 集成

关键文件：
- `ImageViewer/ImageViewer/Main.qml`: 主应用程序窗口和 UI 布局
- `ImageViewer/ImageViewer/cslide.h/cpp`: 处理图片幻灯片功能
- `ImageViewer/ImageInfo/`: QML 插件项目，提供图片信息功能
- 各种自定义 QML 组件：工具按钮（MyToolButton、SlideToolButton 等）

## 开发命令

### 构建命令

```bash
# 构建主应用程序
cd ImageViewer/ImageViewer
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .

# 构建 ImageInfo 插件
cd ../../ImageInfo
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 运行应用程序

```bash
# 构建后运行可执行文件
./ImageViewer/ImageViewer/build/appImageViewer.exe
```

### 清理构建

```bash
rm -rf ImageViewer/ImageViewer/build/
rm -rf ImageViewer/ImageInfo/build/
```

## Qt/QML 开发

- 使用 Qt 6.5+ 和 Quick 模块
- QML 模块通过 `qmlRegisterType` 注册
- 自定义属性和信号用于 QML-C++ 集成
- 支持拖拽操作的图片处理

## 图片支持

支持的格式：JPG、PNG、GIF
功能：缩放、平移、幻灯片播放（顺序/随机）、图片信息显示

## C++/QML 集成

- `CSlide` 类注册为 QML 类型 "org.example.cslide"
- Q_INVOKABLE 方法用于 QML-C++ 通信
- 带有 NOTIFY 信号的属性用于数据绑定
- 包含文件系统操作的图片路径处理

## 语言规范

- 所有对话和文档都使用中文
- 文档使用 markdown 格式