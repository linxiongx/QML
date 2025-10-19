import QtQuick
import QtQuick.Controls

/**
 * KeyboardShortcuts 组件 - 统一管理所有键盘快捷键
 * 职责：处理导航、缩放、删除、撤销等所有键盘事件
 *
 * 信号：
 *   - nextImageRequested(): 下一张图片
 *   - prevImageRequested(): 上一张图片
 *   - zoomInRequested(): 放大
 *   - zoomOutRequested(): 缩小
 *   - toggleSlideShowRequested(): 切换幻灯片
 *   - deleteImageRequested(): 删除图片
 *   - undoDeleteRequested(): 撤销删除
 *
 * 外部属性：
 *   - slideEngine: CSlide 对象引用
 *   - slideButton: 幻灯片按钮引用
 *   - imageContainer: 图片容器
 */

Item {
    id: keyboardShortcuts

    // 信号定义
    signal nextImageRequested()
    signal prevImageRequested()
    signal zoomInRequested()
    signal zoomOutRequested()
    signal toggleSlideShowRequested()
    signal deleteImageRequested()
    signal undoDeleteRequested()

    // 外部属性接口
    property var slideEngine: null
    property var slideButton: null
    property var imageContainer: null

    // 左方向键 / A键 - 上一张图片
    Shortcut {
        sequence: "Left"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.prevImageRequested()
    }

    Shortcut {
        sequence: "A"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.prevImageRequested()
    }

    // 右方向键 / D键 - 下一张图片
    Shortcut {
        sequence: "Right"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.nextImageRequested()
    }

    Shortcut {
        sequence: "D"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.nextImageRequested()
    }

    // 空格键 - 切换幻灯片播放
    Shortcut {
        sequence: "Space"
        context: Qt.ApplicationShortcut
        onActivated: {
            if (slideButton && slideEngine) {
                if (slideButton.isPlaying) {
                    slideButton.stopSlideShow()
                } else {
                    if (slideButton.slideInterval > 0) {
                        slideButton.startSlideShow()
                    } else {
                        slideButton.setSlideInterval(3000)
                        slideButton.startSlideShow()
                    }
                }
            }
            keyboardShortcuts.toggleSlideShowRequested()
        }
    }

    // Delete键 - 删除当前图片
    Shortcut {
        sequence: "Delete"
        context: Qt.ApplicationShortcut
        onActivated: {
            if (slideButton && !slideButton.isPlaying) {
                keyboardShortcuts.deleteImageRequested()
            }
        }
    }

    // 上方向键 / W键 - 放大图片
    Shortcut {
        sequence: "Up"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.zoomInRequested()
    }

    Shortcut {
        sequence: "W"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.zoomInRequested()
    }

    // 下方向键 / S键 - 缩小图片
    Shortcut {
        sequence: "Down"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.zoomOutRequested()
    }

    Shortcut {
        sequence: "S"
        context: Qt.ApplicationShortcut
        onActivated: keyboardShortcuts.zoomOutRequested()
    }

    // Ctrl+Z - 撤销最后一次删除
    Shortcut {
        sequence: "Ctrl+Z"
        context: Qt.ApplicationShortcut
        onActivated: {
            keyboardShortcuts.undoDeleteRequested()
        }
    }
}
