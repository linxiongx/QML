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

    minimumWidth: 500

    // 设置窗口背景颜色
    color: "#1e1e1e"

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


            //换肤
            Rectangle
            {
                id: skinButton
                width: 46
                height: 30
                color: skinMouseArea.containsMouse ? "#404040" : "transparent"

                property int index: 0

                Image
                {
                    id: skinImage
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Qt.resolvedUrl("res/skin.png");
                    height: 15;
                    width: height;
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: skinMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        skinButton.index = (skinButton.index + 1) % 2;
                        if(skinButton.index === 0)
                        {
                            window.color = "#1e1e1e"
                            titleBar.color  = "#1e1e1e"
                            minimizeButtonText.color  = "white"
                            maximizeButtonText.color  = "white"
                            closeButtonText.color  = "white"
                            titleText.color  = "white"
                            skinImage.source = Qt.resolvedUrl("res/skin.png");
                            // 改变工具栏背景颜色为深色
                            if (imageViewer) {
                                //imageViewer.setToolbarColor("#2C2F33")
                               imageViewer.setToolbarColor("#3A3A3A")
                                // imageViewer.setToolbarColor("#5C5C5C")
                            }
                        }
                        else if(skinButton.index === 1)
                        {
                            window.color = "white"
                            titleBar.color  = "white"
                            minimizeButtonText.color  = "#1e1e1e"
                            maximizeButtonText.color  = "#1e1e1e"
                            closeButtonText.color  = "#1e1e1e"
                            titleText.color  = "#1e1e1e"
                            skinImage.source = Qt.resolvedUrl("res/skin_black.png");
                            // 改变工具栏背景颜色为浅色
                            if (imageViewer) {
                                imageViewer.setToolbarColor("lightgray")
                            }
                        }
                        else if(skinButton.index === 2)
                        {

                        }
                    }
                }
            }

            // 最小化按钮
            Rectangle {
                id: minimizeButton
                width: 46
                height: 30
                color: minimizeMouseArea.containsMouse ? "#404040" : "transparent"

                Text {
                    id: minimizeButtonText
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
                    id: maximizeButtonText
                    text: window.visibility === Window.Maximized ? "❐" : "口"
                    color: "white"
                    font.pixelSize: 14
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
                    id: closeButtonText
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
        id: imageViewer
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
