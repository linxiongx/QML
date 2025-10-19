import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.example.cslide 1.0

ApplicationWindow
{
    id: window
    width: 1367
    height: 836
    visible: true
    title: qsTr("图片浏览器")

    // 设置为无边框窗口，但保留任务栏图标
    flags: Qt.FramelessWindowHint | Qt.Window

    onClosing: {
        console.log("程序关闭")
        // 不再需要清理待删除图片，已改为即时删除
    }

    minimumWidth: 500

    // 自定义标题栏
    Rectangle {
        id: titleBar
        height: 30
        color: "#2b2b2b"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        // 标题栏拖拽区域
        MouseArea {
            id: dragArea
            anchors.fill: parent
            property point clickPos: "0,0"

            onPressed: function(mouse) {
                clickPos = Qt.point(mouse.x, mouse.y)
            }

            onPositionChanged: function(mouse) {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                window.x += delta.x
                window.y += delta.y
            }
        }

        // 应用标题
        Text {
            id: titleText
            text: qsTr("图片浏览器")
            color: "white"
            font.pixelSize: 12
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }

        // 窗口控制按钮区域
        Row {
            id: windowControls
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 0

            // 最小化按钮
            Rectangle {
                id: minimizeButton
                width: 46
                height: 30
                color: minimizeMouseArea.containsMouse ? "#404040" : "transparent"

                Text {
                    text: "─"
                    color: "white"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: minimizeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        window.showMinimized()
                    }
                }
            }

            // 最大化/还原按钮
            Rectangle {
                id: maximizeButton
                width: 46
                height: 30
                color: maximizeMouseArea.containsMouse ? "#404040" : "transparent"

                Text {
                    text: window.visibility === Window.Maximized ? "❐" : "□"
                    color: "white"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: maximizeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (window.visibility === Window.Maximized) {
                            window.showNormal()
                        } else {
                            window.showMaximized()
                        }
                    }
                }
            }

            // 关闭按钮
            Rectangle {
                id: closeButton
                width: 46
                height: 30
                color: closeMouseArea.containsMouse ? "#e81123" : "transparent"

                Text {
                    text: "✕"
                    color: "white"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        window.close()
                    }
                }
            }
        }
    }

    // 主内容区域 - 使用原有的 ImageViewer 组件
    ImageViewer
    {
        anchors {
            top: titleBar.bottom
            //top:parent.top;
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    // 窗口边框调整大小区域 - 使用 Qt 原生方法
    // 左侧边框
    MouseArea {
        width: 5
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeHorCursor
        onPressed: function(mouse) { window.startSystemResize(Qt.LeftEdge) }
    }

    // 右侧边框
    MouseArea {
        width: 5
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeHorCursor
        onPressed: function(mouse) { window.startSystemResize(Qt.RightEdge) }
    }

    // 底部边框
    MouseArea {
        height: 5
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        cursorShape: Qt.SizeVerCursor
        onPressed: function(mouse) { window.startSystemResize(Qt.BottomEdge) }
    }

    // 角部调整大小区域
    // 左下角
    MouseArea {
        width: 10
        height: 10
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeBDiagCursor
        onPressed: function(mouse) { window.startSystemResize(Qt.LeftEdge | Qt.BottomEdge) }
    }

    // 右下角
    MouseArea {
        width: 10
        height: 10
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeFDiagCursor
        onPressed: function(mouse) { window.startSystemResize(Qt.RightEdge | Qt.BottomEdge) }
    }
}
