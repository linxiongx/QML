import QtQuick

Item {
    id: scaleIndicator

    // 外部属性
    property real imageScale: 1.0
    property bool isVisible: false

    // 信号
    signal visibilityChanged(bool visible)

    anchors.centerIn: parent
    visible: isVisible

    Rectangle {
        id: idScaleRect
        width: 240
        height: 60
        anchors.centerIn: parent
        radius: 5
        color: "black"
        opacity: 0.7
    }

    Text {
        id: idScanInfoText
        text: Math.round(imageScale * 100) + "%"
        anchors.centerIn: idScaleRect
        font.pointSize: 18
        color: "white"
        opacity: 1
    }

    Timer {
        id: idScanInfoTimer
        interval: 1000
        repeat: false
        onTriggered: {
            scaleIndicator.isVisible = false
            visibilityChanged(false)
        }
    }

    // 公共方法
    function show() {
        scaleIndicator.isVisible = true
        visibilityChanged(true)
        idScanInfoTimer.restart()
    }

    function hide() {
        scaleIndicator.isVisible = false
        visibilityChanged(false)
        idScanInfoTimer.stop()
    }
}