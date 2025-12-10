# ImageViewer - 基于 Qt QML 的现代化图片浏览器

一个功能完整的图片浏览器应用程序，使用 Qt 6 QML 开发，提供丰富的图片查看和管理功能。

## ✨ 功能特性

### 📷 图片查看功能
- **拖拽打开**：支持拖拽 JPG/PNG/GIF 文件到窗口直接打开
- **滚轮缩放**：鼠标滚轮缩放图片（0.1-10倍范围）
- **拖拽平移**：鼠标拖拽移动图片位置
- **双击重置**：双击图片或容器重置缩放和位置
- **智能切换**：双击时根据当前状态智能切换（适应窗口大小 ↔ 实际尺寸）

### 🎬 幻灯片播放
- **播放模式**：顺序、随机、伪随机三种模式
- **切换效果**：无效果、翻转效果、淡入淡出效果
- **时间间隔**：1秒、3秒、10秒、30秒可选
- **播放控制**：开始/停止、循环播放

### 🛠️ 工具栏功能
- **旋转功能**：支持90度旋转图片
- **幻灯片控制**：集成完整的幻灯片播放控制
- **桌面背景设置**：支持将当前图片设置为Windows桌面背景，支持4种平铺模式（拉伸、平铺、居中、适应）

### 🎞️ 胶片栏功能
- **悬停展开**：鼠标悬停在窗口左边缘20像素内自动展开
- **自动收回**：鼠标移出后延迟500ms自动收回
- **缩略图显示**：使用ListView实现虚拟滚动，支持懒加载
- **点击联动**：点击缩略图切换主图显示

### ⌨️ 键盘快捷键
| 快捷键 | 功能 |
|--------|------|
| ← / A | 切换到上一张图片 |
| → / D | 切换到下一张图片 |
| ↑ / W | 放大图片 |
| ↓ / S | 缩小图片 |
| 空格键 | 开始/暂停幻灯片播放 |
| Delete | 删除当前图片 |
| Ctrl+Z | 撤销最后一次删除 |

### ✂️ 图片操作
- **图片裁剪**：基于当前显示区域进行图片裁剪，支持右键拖拽选区
- **撤销删除**：删除图片后可通过UndoManager恢复，最多支持10步撤销
- **图片信息**：通过ImageInfo插件读取图片元数据（EXIF信息）

### 🪟 窗口管理
- **无边框窗口**：自定义标题栏设计
- **窗口拖拽**：通过标题栏拖拽移动窗口
- **窗口调整大小**：支持通过边框和角部调整窗口大小
- **任务栏集成**：正确处理任务栏图标点击和窗口状态管理

### 🎨 换肤功能
- **主题切换**：支持深色和浅色主题切换
- **同步更新**：切换主题时同步更新所有UI元素颜色

## 🖼️ 应用截图

![主界面](https://github.com/linxiongx/QML/blob/main/ImageViewer/ImageViewer/ReleaseImage/420787754-a4f358a6-a136-4f1c-b616-525fc001b6cd.png)

![幻灯片播放](https://github.com/linxiongx/QML/blob/main/ImageViewer/ImageViewer/ReleaseImage/423757959-08fcca63-efbd-4e9f-a388-c9bac8d80526.png)

![快捷键说明](https://github.com/linxiongx/QML/blob/main/ImageViewer/ImageViewer/ImageViewer/res/shortcut.png)

## 🏗️ 技术架构

### 项目结构
```
ImageViewer/
├── ImageViewer/          # 主应用程序
│   ├── Main.qml         # 主窗口（自定义标题栏、窗口管理）
│   ├── ImageViewer.qml  # 图片查看组件容器
│   ├── Viewer.qml       # 图片显示和交互核心组件
│   ├── FilmStrip.qml    # 左侧胶片栏组件
│   ├── MyToolBar.qml    # 工具栏组件
│   ├── cslide.h/cpp     # 幻灯片管理类
│   ├── undomanager.h/cpp # 撤销管理器
│   └── main.cpp         # 应用入口
├── ImageInfo/           # QML插件项目
│   └── ImageInfoControls.qml # 图片信息控件
└── res/                 # 资源文件
    ├── favicon.ico      # 应用程序图标
    └── shortcut.png     # 快捷键说明图片
```

### 核心技术
- **Qt 6.5+**：使用 Qt Quick 和 QuickControls 模块
- **QML/C++集成**：通过 `qmlRegisterType` 将 C++ 类暴露为 QML 类型
- **模块化设计**：组件高度模块化，职责单一
- **动画系统**：使用 Qt Quick 动画框架，支持多种切换效果
- **虚拟滚动**：胶片栏使用 ListView 虚拟滚动优化性能

## 🚀 构建和运行

### 环境要求
- Qt 6.5 或更高版本
- CMake 3.16 或更高版本
- C++17 兼容编译器

### 构建命令
```bash
# 从 ImageViewer/ImageViewer 目录构建主应用程序
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

### 运行应用程序
```bash
# Windows
./build/appImageViewer.exe
```

### 快速构建
```bash
# 使用 Ninja 快速构建
cd build && ninja
```

### 构建 ImageInfo 插件
```bash
# 从 ImageInfo 目录构建插件
cd ImageInfo
mkdir -p build && cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .
```

## 📦 插件系统

项目包含一个独立的 QML 插件项目 `ImageInfo`，用于读取图片元数据（如 EXIF 信息）。

**插件模块 URI**: `org.example.myplugins`

**使用方法**：
```qml
import org.example.myplugins 1.0

ImageInfoControls {
    // 显示图片信息
}
```

## 🔧 开发指南

### 项目配置
- **主项目 QML 模块 URI**: `ImageViewer` v1.0
- **C++ 类型注册**: `org.example.cslide` v1.0
- **插件模块 URI**: `org.example.myplugins` v1.0

### 代码风格
- 使用 Qt 官方推荐的 QML 编码规范
- 组件命名采用驼峰命名法
- 信号命名以 `Changed` 结尾
- 属性使用 `Q_PROPERTY` 声明

### 扩展开发
1. **添加新功能**：创建独立的 QML 组件
2. **集成 C++ 逻辑**：通过 `qmlRegisterType` 注册新类型
3. **添加动画效果**：使用 Qt Quick 动画框架
4. **优化性能**：使用虚拟滚动和懒加载

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢 Qt 框架提供的强大功能和优秀的开发体验。

---

**项目状态**：✅ 功能完整，稳定可用

**最后更新**：2025年12月