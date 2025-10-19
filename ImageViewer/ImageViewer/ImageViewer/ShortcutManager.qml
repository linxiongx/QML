import QtQuick
import QtQuick.Controls
import org.example.cslide 1.0

Item {
    id: shortcutManager

    // 外部属性
    property CSlide slideEngine
    property string currentImageSource: ""
    property real imageScale: 1.0
    property real minScale: 0.1
    property real maxScale: 10.0
    property real scaleStep: 0.1
    property bool isSlidePlaying: false

    // 信号
    signal imageChanged(string imagePath)
    signal shortcutScaleChanged(real scale)
    signal imageDeleted(string imagePath)
    signal undoRequested()
    signal slideToggled(bool playing)

    // 缩放函数
    function zoomImage(delta, centerX, centerY) {
        var newScale = imageScale + delta * scaleStep

        // 限制缩放范围
        if (newScale >= minScale && newScale <= maxScale) {
            shortcutScaleChanged(newScale)
        }
    }

    // 删除当前图片函数
    function deleteCurrentImage(imagePath) {
        // 幻灯片模式下禁止删除
        if (isSlidePlaying) {
            console.log("幻灯片播放中，禁止删除")
            return
        }

        console.log("即时删除图片:" + imagePath)
        imageDeleted(imagePath)
    }

    // 键盘事件处理

    // 左方向键 - 上一张图片
    Shortcut {
        sequence: "Left"
        onActivated: {
            var prevImage = slideEngine.getPrevImageFile()
            if (prevImage !== "") {
                imageChanged(prevImage)
            }
        }
    }

    // 右方向键 - 下一张图片
    Shortcut {
        sequence: "Right"
        onActivated: {
            var nextImage = slideEngine.getImageFile()
            if (nextImage !== "") {
                imageChanged(nextImage)
            }
        }
    }

    // 空白键控制幻灯片开始/暂停
    Shortcut {
        sequence: "Space"
        context: Qt.ApplicationShortcut
        onActivated: {
            slideToggled(!isSlidePlaying)
        }
    }

    // Delete键删除当前图片
    Shortcut {
        sequence: "Delete"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 幻灯片模式下禁止删除
            if (isSlidePlaying) {
                console.log("幻灯片播放中，禁止删除")
                return
            }

            console.log("Delete key pressed")
            // 获取当前图片路径
            var currentImagePath = currentImageSource.toString().replace("file:///", "")
            if (currentImagePath && currentImagePath !== "") {
                // 调用删除函数
                deleteCurrentImage(currentImagePath)
            }
        }
    }

    // 上方向键放大图片
    Shortcut {
        sequence: "Up"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行放大
            zoomImage(1, 0, 0)
        }
    }

    // 下方向键缩小图片
    Shortcut {
        sequence: "Down"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行缩小
            zoomImage(-1, 0, 0)
        }
    }

    // WASD键控制 - 复用方向键功能

    // W键 - 上方向键（放大）
    Shortcut {
        sequence: "W"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行放大
            zoomImage(1, 0, 0)
        }
    }

    // A键 - 左方向键（上一张图片）
    Shortcut {
        sequence: "A"
        context: Qt.ApplicationShortcut
        onActivated: {
            var prevImage = slideEngine.getPrevImageFile()
            if (prevImage !== "") {
                imageChanged(prevImage)
            }
        }
    }

    // S键 - 下方向键（缩小）
    Shortcut {
        sequence: "S"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行缩小
            zoomImage(-1, 0, 0)
        }
    }

    // D键 - 右方向键（下一张图片）
    Shortcut {
        sequence: "D"
        context: Qt.ApplicationShortcut
        onActivated: {
            var nextImage = slideEngine.getImageFile()
            if (nextImage !== "") {
                imageChanged(nextImage)
            }
        }
    }

    // Ctrl+Z 撤销最后一次删除
    Shortcut {
        sequence: "Ctrl+Z"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Ctrl+Z pressed - 撤销最后一次删除")
            undoRequested()
        }
    }
}
