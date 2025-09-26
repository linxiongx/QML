# 代码风格和约定

## QML 风格
- **命名**：组件 ID 使用驼峰式 (e.g., idLoginPopup, idLeftRect)，属性和函数 camelCase。文件名为 PascalCase (e.g., ZYYWindow.qml)。
- **导入**：标准 QtQuick, QtQuick.Controls, Qt5Compat.GraphicalEffects 等。
- **布局**：使用 anchors (e.g., anchors.centerIn, anchors.left) 和 Column/Row/Layouts。自定义组件前缀 ZYY* (e.g., ZYYCheckBox)。
- **交互**：MouseArea 处理点击/悬停，ColorOverlay 用于图标着色。无显式类型提示，依赖 QML 类型系统。
- **颜色/字体**：通过 BasicConfig 单例管理 (e.g., property color fieldTextColor: "#d9d9da")，支持渐变 (gradient: Gradient)。
- **注释**：少量英文/中文注释，描述 UI 元素 (e.g., "关闭" for close button)。

## C++ 风格
- **最小化**：main.cpp 仅设置 QGuiApplication, 注册单例，加载 QML。无自定义类/函数，标准 Qt 使用。
- **约定**：C++ 文件简短，无头文件包含除 Qt 核心外。

## 通用约定
- 无 docstrings 或类型提示 (QML/JS 中无强制)。
- UI 响应式，使用 hoverEnabled, cursorShape = Qt.PointingHandCursor。
- 响应语言：CLAUDE.md 指定中文 UI 文本 (e.g., text: "未登录")。