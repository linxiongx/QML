# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Qt 6 QML 的图片浏览器应用程序，使用 CMake 构建。主项目为 ImageViewer，提供核心查看功能；辅助项目 ImageInfo 为 QML 插件，支持图片信息读取。整体支持图片缩放、平移、拖拽打开、幻灯片播放及工具集成。

## 架构

这是一个多项目代码库：
- **ImageViewer** (主项目)：包含 QML UI 和 C++ 后端核心逻辑。
- **ImageInfo** (插件项目)：QML 插件，用于 EXIF 等图片元数据读取。

主要组件：
- **前端**：QML 驱动的 UI，包含 Main.qml 作为入口，集成自定义工具按钮 (MyToolButton, SlideToolButton 等) 和图像显示区域 (ScrollView + Image + DropArea)。
- **后端**：C++ 类如 CSlide 处理幻灯片逻辑 (顺序/随机切换、文件扫描)。
- **集成**：通过 qmlRegisterType 将 CSlide 暴露为 QML 类型 "org.example.cslide"；支持 Q_INVOKABLE 方法和属性绑定。
- **资源**：res/ 目录存放图标和资源；构建使用 Qt Quick 模块。

关键文件：
- `ImageViewer/ImageViewer/Main.qml`：主窗口布局、图像交互 (缩放、拖拽、动画)。
- `ImageViewer/ImageViewer/cslide.h/cpp`：幻灯片管理 (目录扫描、下一张图片获取)。
- `ImageViewer/ImageInfo/`：插件源代码和构建配置。
- `ImageViewer/ImageViewer/CMakeLists.txt`：主项目 CMake，定义 executable 和 QML 模块。
- `main.cpp`：应用入口，注册 C++ 类型并加载 QML。

## 开发命令

### 构建命令
```bash
# 构建主应用程序 (ImageViewer)
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
# 确保插件路径正确配置后运行
./ImageViewer/ImageViewer/build/appImageViewer.exe
```

### 清理构建
```bash
rm -rf ImageViewer/ImageViewer/build/
rm -rf ImageViewer/ImageInfo/build/
```

无内置 lint 或测试命令；使用 Qt Creator 或外部工具如 clang-tidy 进行代码检查。无单元测试框架集成；若需测试，可添加 QTest。

## Qt/QML 开发

- 要求 Qt 6.5+，核心模块：Quick, QuickControls。
- QML 模块 URI: "ImageViewer" (v1.0)。
- 交互：WheelHandler 用于滚轮缩放；MouseArea 用于拖拽和平移；DropArea 处理文件拖入 (JPG/PNG/GIF)。
- 动画：SequentialAnimation/ParallelAnimation 用于翻转效果和淡入。
- 插件集成：ImageInfo 通过 import org.example.myplugins 加载。

## 图片支持

- 格式：JPG, PNG, GIF (通过文件扩展检查)。
- 功能：拖拽打开、滚轮缩放 (0.1-10x，步长 0.1，中心点保持)、拖拽平移、双击重置、缩放比例显示 (1s 临时 overlay)、目录扫描幻灯片。

## C++/QML 集成

- CSlide 类：Q_PROPERTY for slideType (SEQUENCES/RANDOMIZATION)，Q_INVOKABLE for imageSourceChanged (扫描目录) 和 getImageFile (下一张)。
- 文件系统：QDir 扫描当前目录图片，QFileInfo 处理路径。
- 信号：slideTypeChanged 用于 QML 绑定。

## 语言规范

- 所有对话和文档使用中文。
- 文档采用 Markdown 格式，代码示例用 bash/Qt 块。

## 关键功能模块

### 图片查看
- 拖拽打开：DropArea 过滤支持格式，第一张加载到 Image.source。
- 缩放/平移：WheelHandler 计算 newScale 并调整位置保持鼠标点；MouseArea 拖拽 (ClosedHandCursor)。
- 重置：双击 MouseArea 设 scale=1.0，居中位置。
- 显示：临时 Text overlay 显示缩放百分比。

### 幻灯片播放
- 模式：顺序 (index++) 或随机 (QRandomGenerator，避免重复除单文件)。
- 触发：SlideToolButton 连接，via Connections 更新 Image.source，支持翻转动画 (RotationAnimation 180° + opacity)。
- 间隔：QML Timer (3s/10s/30s，未在 C++ 实现)。

### 工具栏
- 左侧：MyToolButton (EXIF，toggle MyImageInfo 可见)。
- 右侧：RowLayout (RtL) - LockerToolButton, Copy/Edit/Bookmarks/Slide/Scan ToolButtons。
- 集成：SlideToolButton 暴露 imageSourceChanged 信号给 CSlide。

此更新增强了架构深度 (多项目)、命令精确性 (双构建)、功能细节 (从 Main.qml/cslide)，并移除冗余，避免泛化开发实践。