import QtQuick
import QtQuick.Effects

Item {
    id: magnifier
    // 尺寸现在由父组件（Viewer）控制
    visible: active && sourceItem !== null

    property var sourceItem: null
    property point cursorPos: Qt.point(0, 0) // 鼠标在父容器（Viewer）中的位置
    property real magnification: 3.0
    property bool active: false

    // 放大镜本身的显示位置：中心对准鼠标
    x: cursorPos.x - width / 2
    y: cursorPos.y - height / 2

    // 圆形遮罩源
    Rectangle {
        id: maskItem
        x: -9999 // 移出屏幕但保持 visible: true 以确保纹理渲染
        y: -9999
        width: magnifier.width
        height: magnifier.height
        radius: width / 2
        color: "black"
        visible: true
        layer.enabled: true
    }

    // 装饰性的底层背景
    Rectangle {
        id: debugBackground
        z: -1
        anchors.fill: parent
        radius: width / 2
        color: "#AA000000" // 恢复为半透明黑
        visible: active
    }

    // 局部内容采样器 + 特效
    ShaderEffectSource {
        id: effectSource
        anchors.fill: parent
        sourceItem: magnifier.sourceItem
        recursive: true
        live: true
        format: ShaderEffectSource.RGBA
        smooth: true
        hideSource: false
        opacity: active ? 1 : 0
        visible: true // 始终保持 visible 以避免渲染暂停，通过 opacity 控制显示

        // 采样区域计算：双向边界限制 (Clamping)
        sourceRect: {
            if (!magnifier.sourceItem || !active) return Qt.rect(0, 0, 0, 0);
            
            var sw = magnifier.width / magnifier.magnification
            var sh = magnifier.height / magnifier.magnification
            
            // 计算鼠标映射后的坐标
            var mapped = magnifier.parent.mapToItem(magnifier.sourceItem, magnifier.cursorPos.x, magnifier.cursorPos.y)
            
            // 确保采样中心导致的起始点在合法范围内 [0, max - size]
            var sx = Math.max(0, Math.min(mapped.x - sw / 2, magnifier.sourceItem.width - sw))
            var sy = Math.max(0, Math.min(mapped.y - sh / 2, magnifier.sourceItem.height - sh))
            
            return Qt.rect(sx, sy, sw, sh)
        }

        // 使用 layer.effect 实现剪裁和阴影
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: maskItem
            
            shadowEnabled: true
            shadowBlur: 1.0
            shadowOpacity: 0.5
            shadowVerticalOffset: 4
            shadowColor: "black"
            
            autoPaddingEnabled: false // 禁用自动边距，防止“内切”错觉
        }
    }

    // 最顶层边框
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.color: "#99FFFFFF"
        border.width: 1.5
        z: 10
    }
}
