# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Qt 6 QML 的图片浏览器应用程序，使用 CMake 构建。主项目为 ImageViewer，提供核心查看功能；辅助项目 ImageInfo 为 QML 插件，支持图片信息读取（如 EXIF）。整体支持图片缩放、平移、拖拽打开、幻灯片播放及工具集成。当前实现包括工具栏、图像交互和基本插件集成；需求文档（需求文档.txt）描述了额外功能如左侧胶片栏（未实现）。

## 架构

这是一个多项目代码库：
- **ImageViewer** (主项目)：包含 QML UI 和 C++ 后端核心逻辑。
- **ImageInfo** (插件项目)：QML 插件，用于图片元数据读取，通过 import org.example.myplugins 加载。

主要组件：
- **前端**：QML 驱动的 UI，Main.qml 作为入口，集成自定义工具按钮 (MyToolButton, SlideToolButton 等) 和图像显示区域 (ScrollView + Image + DropArea + WheelHandler/MouseArea)。
- **后端**：C++ 类如 CSlide 处理幻灯片逻辑 (目录扫描、顺序/随机切换)。
- **集成**：通过 qmlRegisterType 将 CSlide 暴露为 QML 类型 "org.example.cslide"；Q_INVOKABLE 方法和属性绑定实现通信。
- **资源**：res/ 目录存放图标；构建使用 Qt Quick 和 QuickControls 模块。

关键文件：
- `Main.qml`：主窗口布局、工具栏、图像交互 (缩放 0.1-10x、拖拽平移、双击重置、翻转动画)。
- `cslide.h/cpp`：幻灯片管理 (QDir 扫描 JPG/PNG/GIF，getImageFile 返回下一张)。
- `ImageInfo/`：插件源代码 (ImageInfoControls.qml 等)。
- `CMakeLists.txt`：主项目配置，qt_add_executable(appImageViewer) 和 qt_add_qml_module。
- `main.cpp`：应用入口，注册 CSlide 并加载 QML 模块。

## 开发命令

### 构建命令
```bash
# 从 ImageViewer/ImageViewer 目录构建主应用程序
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .

# 构建 ImageInfo 插件 (从 ImageViewer/ImageInfo 目录)
cd ../../ImageInfo
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 运行应用程序
```bash
# 运行主可执行文件 (Windows)
./build/appImageViewer.exe
```

### 清理构建
```bash
# 清理主应用程序构建
rm -rf build/

# 清理 ImageInfo 插件构建
cd ../../ImageInfo && rm -rf build/
```

### 快速构建
```bash
# 使用 Ninja 快速构建
cd build && ninja
```

无内置 lint 或测试命令；推荐使用 Qt Creator 或 clang-tidy 检查代码。无单元测试；可添加 QTest 框架。

## Qt/QML 开发

- 要求 Qt 6.5+，核心模块：Quick, QuickControls。
- QML 模块 URI: "ImageViewer" (v1.0)。
- 交互：WheelHandler 滚轮缩放 (步长 0.1，保持中心)；MouseArea 拖拽 (ClosedHandCursor) 和双击重置；DropArea 处理拖入 (过滤 JPG/PNG/GIF，第一张加载)。
- 动画：SequentialAnimation/ParallelAnimation 用于幻灯片翻转 (180° Rotation + Opacity) 和淡入；Timer 显示缩放比例 (1s)。
- 插件集成：MyImageInfo 通过 import org.example.myplugins 加载，支持 EXIF 显示 (toggle 可见)。

## 图片支持

- 格式：JPG, PNG, GIF (文件扩展过滤)。
- 功能：拖拽打开单/多文件 (加载第一张)；滚轮缩放 (min 0.1, max 10.0, 中心保持)；拖拽平移；双击重置规模/位置；临时 overlay 显示缩放 %；目录扫描支持幻灯片。

## C++/QML 集成

- CSlide 类：Q_PROPERTY SlideType slideType (SEQUENCES/RANDOMIZATION, NOTIFY slideTypeChanged)；Q_INVOKABLE imageSourceChanged (扫描目录，填充 QStringList m_lstImagePath)；getImageFile (顺序 index++ 或随机避免重复)。
- 文件系统：QDir entryList 过滤图片，QFileInfo absolutePath；单文件随机模式返回自身。
- 信号：slideTypeChanged 用于 QML 更新；Connections 绑定 SlideToolButton 到图像切换。

## 语言规范

- 所有对话和文档使用中文。
- 文档采用 Markdown 格式，代码示例用 bash/Qt 块。

## 关键功能模块

### 图片查看
- 拖拽：DropArea onDropped 加载第一支持格式文件到 Image.source。
- 缩放/平移：WheelHandler 更新 imageScale 并调整 imageContainer.x/y 保持鼠标点；MouseArea drag.target=imageContainer。
- 重置：双击 MouseArea 或容器设 imageScale=1.0，居中。
- 显示：idScanInfoLayout (Rectangle + Text) 可见 1s 显示 %。

### 幻灯片播放
- 模式：顺序 (循环 index % size) 或随机 (QRandomGenerator bounded, 避免当前，除单文件)。
- 触发：SlideToolButton onImageFileSourceChanged via Connections；支持 "flip" 效果 (SequentialAnimation Rotation 0-180 + Opacity 1-0, 后切换)。
- 间隔：QML Timer (未指定默认，需求中 3s/10s/30s 可加)。

### 工具栏
- 布局：顶部 Rectangle (darkgray)，左侧 MyToolButton (EXIF, toggle MyImageInfo)；右侧 RowLayout (RtL)：Locker, Copy, Edit, Bookmarks, Slide, Scan ToolButtons。
- 集成：SlideToolButton imageSource = idImage.source，暴露信号给 CSlide；其他按钮功能待实现 (Copy/Edit 等)。

### 胶片栏功能
- 左侧胶片栏：FilmStrip.qml 组件，支持鼠标悬停展开/收回动画
- 热区检测：窗口左边缘20像素范围内悬停触发
- 自动收回：鼠标移出后延迟500ms自动收回
- 缩略图显示：垂直PathView显示当前目录图片缩略图
- 点击联动：点击缩略图切换主图显示

### 键盘快捷键
- 左方向键：切换到上一张图片
- 右方向键：切换到下一张图片
- 空格键：开始/暂停幻灯片播放
- Delete键：删除当前图片

### 图片操作
- 拖拽打开：支持拖拽JPG/PNG/GIF文件到窗口
- 滚轮缩放：支持鼠标滚轮缩放图片（0.1-10倍）
- 拖拽平移：支持鼠标拖拽移动图片位置
- 双击重置：双击图片或容器重置缩放和位置
- 旋转功能：支持90度旋转图片

此版本基于代码分析改进：精确交互/动画细节、路径调整、添加功能说明，提升开发指导性。