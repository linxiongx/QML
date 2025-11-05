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
    color: "#3A3A3A"

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

        // 设置桌面背景按钮
        SetWallpaperToolButton {
            id: wallpaperButton
            slideEngine: toolBar.slideEngine
            onWallpaperRequested: function(clickCount) {
                if (toolBar.slideEngine && toolBar.imageSource !== "") {
                    var imagePath = toolBar.imageSource.toString().replace("file:///", "")
                    console.log("尝试设置桌面背景，图片路径:", imagePath)
                    var success = toolBar.slideEngine.setAsWallpaper(imagePath, clickCount)
                    if (success) {
                        console.log("桌面背景设置成功:", imagePath)
                    } else {
                        console.log("桌面背景设置失败:", imagePath)
                    }
                } else {
                    console.log("无有效图片或幻灯片引擎，无法设置桌面背景")
                }
            }
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

    // 更新桌面背景按钮状态的函数
    function updateWallpaperButton() {
        if (wallpaperButton) {
            wallpaperButton.updateImagePath(toolBar.imageSource)
        }
    }

    // 监听图片源变化，更新桌面背景按钮状态
    onImageSourceChanged: {
        updateWallpaperButton()
    }
}
