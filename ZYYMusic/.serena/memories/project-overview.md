# ZYYMusic 项目概述

## 项目目的
ZYYMusic 是一个基于 Qt Quick 的桌面音乐播放器应用，主要使用 QML 进行声明式 UI 开发，C++ 仅作为最小化后端支持。目的是创建一个类似网易云音乐的客户端，支持音乐搜索、播放、云端集成（如歌单、排行榜、歌手页面）、登录功能和设置配置。当前实现重点在 UI 框架和基本交互上，云端 API 集成尚未完成（无网络请求代码）。应用强调桌面歌词、播放控制和自定义 UI 组件。

## 技术栈
- **语言**：主要 C++ (最小后端) 和 QML/JS (UI 逻辑)。
- **框架**：Qt 6 (Quick 模块，版本要求 6.8+)。
- **构建工具**：CMake 3.16+，自动 RCC (资源编译)，qt_add_qml_module 用于 QML 模块注册。
- **平台**：Windows (使用 MinGW 64-bit，WIN32_EXECUTABLE)。
- **其他**：无外部依赖库显式列出，资源通过 qrc 文件打包 (res.qrc)。UI 使用 QtQuick.Controls、GraphicalEffects 等标准组件，自定义组件在 CommonUI 目录。

## 代码库结构
- **根目录**：CMakeLists.txt (构建配置)，main.cpp (应用入口)，Main.qml (主 UI 窗口)。
- **Basic/**：BasicConfig.qml (全局配置单例，包含颜色方案、信号如 openLoginPopup)。
- **CommonUI/**：自定义 UI 组件，如 ZYYWindow (自定义窗口)、ZYYSearchBox、ZYYComboBox、ZYYCheckBox、ZYYRadioButton 等。
- **LeftPage/**：LeftPage.qml (左侧导航)。
- **mainPopups/**：登录相关弹窗 (LoginPopup.qml, LoginByOtherMainsPopup.qml)。
- **PlayMusic/**：PlayMusic.qml (底部播放器)。
- **RightPage/**：主内容区域，包含 StackPages 子目录：
  - TitlePage.qml, MinMax.qml (标题和窗口控制)。
  - StackPages/：动态页面，如 CloudMusic.qml (云音乐标签页)、Setting.qml (设置子页面：Play, SystemConfig 等)、Featured.qml (精选，包含 Carousel, OfficialPlaylist, LatestMusic)、PlaylistSquare.qml、Rankings.qml、Artists.qml。
- **Res/**：图像资源 (qrc:/Image/Res/)，包括登录、播放、标题等图标。
- **build/**：编译生成文件 (忽略)。
- 未跟踪文件：如 RankDetail.qml (排行榜详情)。

## 构建和运行命令
- 构建：mkdir build && cd build && cmake .. && cmake --build .
- 运行 (Debug)：build/Desktop_Qt_6_9_1_MinGW_64_bit-Debug/appZYYMusic.exe
- 无测试/格式化命令 (CMake 中无单元测试配置)。

## 开发注意事项
无特定设计模式，UI 逻辑在 QML 中实现 (anchors, MouseArea 等)。文件名使用驼峰式 (e.g., ZYYWindow)，中文 UI 文本常见。无文档字符串或类型提示，代码风格简单声明式。