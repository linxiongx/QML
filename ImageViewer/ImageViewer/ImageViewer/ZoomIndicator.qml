import QtQuick
import QtQuick.Controls

/**
 * ZoomIndicator 组件 - 缩放比例指示器
 * 职责：显示当前图片缩放百分比，自动隐藏
 *
 * 属性：
 *   - zoomValue: 缩放比例（0.0-10.0）
 *
 * 方法：
 *   - show(): 显示指示器
 */

Item {
    id: zoomIndicator

    anchors.centerIn: parent
    visible: false
    width: 240
    height: 60

    // 外部属性接口
    property real zoomValue: 1.0

    // 内部显示时长
    property int displayDuration: 1000

    // 背景矩形
    Rectangle {
        id: scaleRect
        width: 240
        height: 60
        anchors.centerIn: parent
        radius: 5
        color: "black"
        opacity: 0.7
    }

    // 文本显示
    Text {
        id: zoomText
        text: Math.round(zoomValue * 100) + "%"
        anchors.centerIn: scaleRect
        font.pointSize: 18
        color: "white"
        opacity: 1
    }

    // 自动隐藏计时器
    Timer {
        id: hideTimer
        interval: displayDuration
        repeat: false
        onTriggered: zoomIndicator.visible = false
    }

    // 显示方法
    function show() {
        visible = true
        hideTimer.restart()
    }
}
