import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * ToolBar 组件 - 应用顶部工具栏
 * 职责：显示旋转和幻灯片控制按钮
 *
 * 属性：
 *   - marginValue: 工具栏外边距
 *   - slideEngine: CSlide 引擎实例
 *   - imageSource: 当前图片源路径
 *
 * 信号：
 *   - rotateClicked(): 旋转按钮被点击时发出
 *   - rotateDegreeChanged(int angle): 旋转角度变化
 */

Rectangle {
    id: toolBar

    width: parent.width
    height: 30
    color: "darkgray"

    // 外部属性接口
    property int marginValue: 5
    property var slideEngine: null
    property url imageSource: ""

    // 信号定义
    signal rotateClicked()
    signal rotateDegreeChanged(real angle)

    // 内部属性
    property int currentRotationAngle: 0

    RowLayout {
        anchors.right: parent.right
        anchors.rightMargin: 20
        layoutDirection: Qt.RightToLeft
        anchors.verticalCenter: parent.verticalCenter
        spacing: 15

        // 旋转按钮
        RotateToolButton {
            id: rotateButton
            onClicked: {
                // 旋转90度
                currentRotationAngle = (currentRotationAngle + 90) % 360
                rotateDegreeChanged(currentRotationAngle)
                rotateClicked()
            }
        }

        // 幻灯片播放按钮
        SlideToolButton {
            id: slideButton
            marginValue: toolBar.marginValue + 2
            imageSource: toolBar.imageSource
            slideEngine: toolBar.slideEngine
        }
    }

    // 重置旋转角度的函数
    function resetRotation() {
        currentRotationAngle = 0
        rotateDegreeChanged(0)
    }

    // 获取幻灯片按钮引用的函数
    function findSlideButton() {
        return slideButton
    }
}
