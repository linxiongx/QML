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
    // 使用组合标志来改善任务栏集成
    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowMinimizeButtonHint

    minimumWidth: 500

    // 设置窗口背景颜色
    color: "#1e1e1e"

    // 窗口状态管理属性
    property bool wasMinimized: false
    property bool wasMaximized: false
    property int lastVisibility: Window.Windowed

    // 监听窗口可见性变化
    onVisibilityChanged: {
        console.log("窗口可见性变化:", visibility)

        // 记录窗口状态
        if (visibility === Window.Minimized) {
            wasMinimized = true
        } else if (visibility === Window.Maximized) {
            wasMaximized = true
            wasMinimized = false
        } else if (visibility === Window.Windowed) {
            wasMaximized = false
            wasMinimized = false
        }
        lastVisibility = visibility
    }

    // 监听窗口激活状态变化
    onActiveChanged: {
        console.log("窗口激活状态变化:", active)
        if (active && wasMinimized) {
            // 如果窗口之前被最小化，现在被激活了，说明用户点击了任务栏图标
            handleTaskbarClick()
        }
    }

    // 处理任务栏图标点击
    function handleTaskbarClick() {
        console.log("处理任务栏点击，当前可见性:", visibility, "是否激活:", active)

        if (visibility === Window.Minimized) {
            // 如果窗口被最小化，则恢复窗口
            restoreWindow()
        } else if (visibility === Window.Hidden) {
            // 如果窗口被隐藏，则显示窗口
            show()
            raise()
            requestActivate()
        } else if (!active && visibility === Window.Windowed) {
            // 如果窗口可见但未激活，激活窗口
            raise()
            requestActivate()
        }

        wasMinimized = false
    }

    // 切换最大化/还原状态
    function toggleMaximize() {
        console.log("切换窗口最大化状态，当前状态:", window.visibility)

        if (window.visibility === Window.Maximized) {
            // 如果当前是最大化状态，则还原到正常状态
            window.showNormal()
            wasMaximized = false
        } else {
            // 如果当前是正常状态，则最大化
            window.showMaximized()
            wasMaximized = true
        }

        // 记录状态变化
        console.log("切换后状态:", window.visibility)
    }

    // 恢复窗口到之前的状态
    function restoreWindow() {
        console.log("恢复窗口，之前是否最大化:", wasMaximized)

        if (wasMaximized) {
            showMaximized()
        } else {
            showNormal()
        }

        // 确保窗口被提升到前台并激活
        raise()
        requestActivate()

        // 强制刷新窗口状态
        Qt.callLater(function() {
            if (visibility === Window.Minimized) {
                console.log("窗口仍然最小化，再次尝试恢复")
                if (wasMaximized) {
                    showMaximized()
                } else {
                    showNormal()
                }
                raise()
                requestActivate()
            }
        })
    }

    // 监听应用程序状态变化
    Connections {
        target: Qt.application
        function onStateChanged() {
            console.log("应用程序状态变化:", Qt.application.state)
            if (Qt.application.state === Qt.ApplicationActive) {
                // 应用程序被激活
                if (wasMinimized && visibility === Window.Minimized) {
                    handleTaskbarClick()
                }
            }
        }
    }

    // 添加定时器来处理某些边界情况
    Timer {
        id: activationTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (wasMinimized && visibility === Window.Minimized) {
                console.log("定时器触发窗口恢复")
                restoreWindow()
            }
        }
    }

    // 检测连续任务栏点击的定时器
    Timer {
        id: clickDetectionTimer
        interval: 200
        repeat: false
        property bool clickDetected: false

        onTriggered: {
            clickDetected = false
        }
    }

    // 窗口事件过滤器 - 处理系统级别的窗口消息
    Component.onCompleted: {
        console.log("窗口初始化完成，设置任务栏点击监听")

        // 确保窗口标志正确设置
        if (Qt.platform.os === "windows") {
            console.log("Windows平台，启用任务栏集成")
        }
    }

    // 当窗口获得焦点时的额外处理
    onActiveFocusItemChanged: {
        if (activeFocusItem && wasMinimized) {
            console.log("窗口获得焦点，检查是否需要恢复")
            activationTimer.start()
        }
    }

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
            property bool isPressed: false
            property bool isDragging: false

            // 排除窗口控制按钮区域，避免与按钮交互冲突
            anchors.rightMargin: windowControls.width

            onPressed: function(mouse) {
                clickPos = Qt.point(mouse.x, mouse.y)
                isPressed = true
                isDragging = false

                // 如果窗口是最大化状态，先还原到正常状态
                if (window.visibility === Window.Maximized) {
                    window.showNormal()
                    wasMaximized = false

                    // 计算鼠标在屏幕上的位置，并调整窗口位置
                    var screenPos = window.mapToGlobal(Qt.point(mouse.x, mouse.y))
                    var newX = screenPos.x - window.width / 2
                    var newY = screenPos.y - 10 // 稍微向上偏移，让鼠标在标题栏顶部

                    // 确保窗口不会超出屏幕
                    newX = Math.max(0, Math.min(newX, window.screen.virtualX + window.screen.width - window.width))
                    newY = Math.max(0, Math.min(newY, window.screen.virtualY + window.screen.height - 100))

                    window.x = newX
                    window.y = newY

                    // 更新点击位置，因为窗口位置改变了
                    clickPos = Qt.point(mouse.x, mouse.y)
                }
            }

            onPositionChanged: function(mouse) {
                // 只有在鼠标按下时才允许拖拽
                if (isPressed) {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    var distance = Math.sqrt(delta.x * delta.x + delta.y * delta.y)

                    // 如果移动距离超过阈值，开始拖拽
                    if (distance > 3) {
                        isDragging = true
                        window.x += delta.x
                        window.y += delta.y
                    }
                }
            }

            onDoubleClicked: function(mouse) {
                // 双击标题栏切换最大化/还原状态
                console.log("标题栏双击，切换最大化状态")
                toggleMaximize()
            }

            onReleased: function(mouse) {
                isPressed = false
                isDragging = false
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
                        // 记录当前是否为最大化状态
                        if (window.visibility === Window.Maximized) {
                            wasMaximized = true
                        }
                        window.showMinimized()
                        wasMinimized = true
                        console.log("手动最小化窗口")
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
                        // 使用统一的切换函数
                        toggleMaximize()
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
