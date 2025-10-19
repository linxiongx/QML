# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个基于 Qt 6 QML 的图片浏览器应用程序，使用 CMake 构建。主项目为 ImageViewer，提供核心查看功能；辅助项目 ImageInfo 为 QML 插件，支持图片信息读取（如 EXIF）。整体支持图片缩放、平移、拖拽打开、幻灯片播放及工具集成。当前实现包括工具栏、图像交互、左侧胶片栏和基本插件集成。

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
- `FilmStrip.qml`：左侧胶片栏组件，支持悬停展开/收回动画和缩略图显示。

## 开发命令

### 构建命令
```bash
# 从 ImageViewer/ImageViewer 目录构建主应用程序
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 运行应用程序
```bash
# 运行主可执行文件 (Windows)
./build/appImageViewer.exe
```

### 快速构建
```bash
# 使用 Ninja 快速构建
cd build && ninja
```

### 调试构建
```bash
# 调试版本构建
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Debug
cmake --build .
```

### 构建 ImageInfo 插件
```bash
# 从 ImageInfo 目录构建插件
cd ImageInfo
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 开发工具和环境设置

- **推荐 IDE**：Qt Creator (最佳 Qt/QML 开发体验)
- **代码检查**：clang-tidy 或 Qt Creator 内置代码分析
- **调试构建**：调试版本可用于断点调试和性能分析
- **代码格式化**：项目暂无强制格式化规范，建议保持现有代码风格
- **单元测试**：暂无单元测试框架，建议添加 QTest 相关测试
- **依赖管理**：项目使用 CMake 管理依赖，确保 Qt 6.5+ 版本

## 重要配置文件

### CMakeLists.txt
主项目配置，定义应用程序和 QML 模块。使用 `qt_add_executable` 和 `qt_add_qml_module` 注册 QML 模块 URI "ImageViewer" v1.0。

### ImageInfo/CMakeLists.txt
插件项目配置，定义 QML 插件模块 URI "org.example.myplugins" v1.0。

### CMakeLists.txt.user
Qt Creator 项目配置文件，包含构建套件和调试配置。

### main.cpp
应用入口，注册 C++ 类型并加载 QML 模块。注册 CSlide 类型为 "org.example.cslide"。

## Qt/QML 开发

- 要求 Qt 6.5+，核心模块：Quick, QuickControls。
- QML 模块 URI: "ImageViewer" (v1.0)。
- 交互：WheelHandler 滚轮缩放 (步长 0.1，保持中心)；MouseArea 拖拽 (ClosedHandCursor) 和双击重置；DropArea 处理拖入 (过滤 JPG/PNG/GIF，第一张加载)。
- 动画：SequentialAnimation/ParallelAnimation 用于幻灯片翻转 (180° Rotation + Opacity) 和淡入；Timer 显示缩放比例 (1s)。

## 图片支持

- 格式：JPG, PNG, GIF (文件扩展过滤)。
- 功能：拖拽打开单/多文件 (加载第一张)；滚轮缩放 (min 0.1, max 10.0, 中心保持)；拖拽平移；双击重置规模/位置；临时 overlay 显示缩放 %；目录扫描支持幻灯片。

## C++/QML 集成

- CSlide 类：Q_PROPERTY SlideType slideType (SEQUENCES/RANDOMIZATION/PSEUDO_RANDOM, NOTIFY slideTypeChanged)；Q_INVOKABLE imageSourceChanged (扫描目录，填充 QStringList m_lstImagePath)；getImageFile (顺序 index++ 或随机避免重复)。
- UndoManager 类：处理撤销操作，支持删除图片的撤销功能，最大撤销步数为10。
- 文件系统：QDir entryList 过滤图片，QFileInfo absolutePath；单文件随机模式返回自身。
- 信号：slideTypeChanged 用于 QML 更新；Connections 绑定 SlideToolButton 到图像切换。
- 类型注册：CSlide 注册为 "org.example.cslide" QML 类型。

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
- 布局：顶部 Rectangle (darkgray)，左侧 MyToolButton (EXIF, toggle MyImageInfo)；右侧 RowLayout (RtL)：Rotate, Slide ToolButtons。
- 集成：SlideToolButton imageSource = idImage.source，暴露信号给 CSlide；RotateToolButton 支持90度旋转图片。

### 胶片栏功能
- 左侧胶片栏：FilmStrip.qml 组件，支持鼠标悬停展开/收回动画
- 热区检测：窗口左边缘20像素范围内悬停触发
- 自动收回：鼠标移出后延迟500ms自动收回
- 缩略图显示：ListView实现虚拟滚动，支持懒加载和缓存
- 点击联动：点击缩略图切换主图显示

### 键盘快捷键
- 左方向键/A键：切换到上一张图片
- 右方向键/D键：切换到下一张图片
- 空格键：开始/暂停幻灯片播放
- Delete键：删除当前图片
- 上方向键/W键：放大图片
- 下方向键/S键：缩小图片
- Ctrl+Z：撤销最后一次删除

### 图片操作
- 拖拽打开：支持拖拽JPG/PNG/GIF文件到窗口
- 滚轮缩放：支持鼠标滚轮缩放图片（0.1-10倍）
- 拖拽平移：支持鼠标拖拽移动图片位置
- 双击重置：双击图片或容器重置缩放和位置
- 旋转功能：支持90度旋转图片
- 图片裁剪：基于当前显示区域进行图片裁剪
- 撤销删除：删除图片后可通过 UndoManager 恢复

### 资源文件结构
- **res/**：资源目录，包含应用图标
- **res/favicon.ico**：应用程序图标

### 常见开发注意事项
1. **QML 模块导入**：主应用使用 `import ImageViewer 1.0`，C++ 类型使用 `import org.example.cslide 1.0`，插件使用 `import org.example.myplugins 1.0`
2. **文件路径**：使用 `QFileInfo` 处理跨平台路径，注意 Windows 路径格式
3. **内存管理**：注意图片加载时的内存管理，避免泄漏
4. **动画性能**：使用 `ListView` 的虚拟滚动优化胶片栏性能
5. **错误处理**：添加适当的错误处理和边界检查
6. **撤销管理**：UndoManager 支持最多10步撤销操作
7. **图片裁剪**：基于当前显示区域进行裁剪，支持右键拖拽选区
8. **插件开发**：ImageInfo 插件需要单独构建，确保插件路径正确配置