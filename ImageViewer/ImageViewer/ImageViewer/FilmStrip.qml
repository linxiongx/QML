import QtQuick
import QtQuick.Controls
import org.example.cslide 1.0

Item {
    id: filmStripRoot

    property CSlide slideEngine
    property string currentImageSource: ""

    signal imageSelected(string imageSource)

    // 热区 MouseArea - 窗口左边缘检测
    MouseArea {
        id: filmstripHotZone
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 20
        hoverEnabled: true
        z: 1000
        acceptedButtons: Qt.AllButtons

        onEntered: {
            console.log("鼠标进入热区");
            if (filmstripArea.width === 0) {
                filmstripArea.width = 200
                hideTimer.stop()
            }
        }

        onExited: {
            console.log("鼠标离开热区");
            if (!filmstripArea.containsMouse && filmstripArea.width > 0) {
                hideTimer.restart()
            }
        }
    }

    // 左侧胶片栏
    Rectangle {
        id: filmstripArea
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: root.marginValue;
        anchors.bottomMargin: root.marginValue;
        width: 0
        color: "#333333"
        clip: true
        z: 50

        border.color: "#555555"
        border.width: 1

        // 鼠标区域用于检测鼠标是否在胶片栏内
        MouseArea {
            id: filmstripMouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            acceptedButtons: Qt.AllButtons

            onEntered: {
                console.log("鼠标进入胶片栏");
                hideTimer.stop()
            }

            onExited: {
                console.log("鼠标离开胶片栏");
                if (!filmstripHotZone.containsMouse && filmstripArea.width > 0) {
                    hideTimer.restart()
                }
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        Timer {
            id: hideTimer
            interval: 500
            onTriggered: {
                if (!filmstripHotZone.containsMouse && !filmstripMouseArea.containsMouse && filmstripArea.width > 0) {
                    filmstripArea.width = 0
                }
            }
        }

        // 使用 ListView 实现虚拟滚动
        ListView {
            id: filmstripListView
            anchors.fill: parent
            anchors.margins: 5
            interactive: true
            spacing: 10
            cacheBuffer: 300  // 缓存区域高度

            model: filmstripModel
            delegate: Rectangle {
                id: thumbnailDelegate
                width: 100
                height: 100
                radius: 5
                color: "#444444"

                // 高亮当前项
                border.color: ListView.isCurrentItem ? "white" : "transparent"
                border.width: 2
                scale: ListView.isCurrentItem ? 1.1 : 1.0

                Behavior on scale { NumberAnimation { duration: 200 } }

                // 占位符 - 在图片加载前显示
                Rectangle {
                    id: placeholder
                    anchors.fill: parent
                    anchors.margins: 2
                    color: "#666666"
                    visible: !imageLoader.active

                    Text {
                        anchors.centerIn: parent
                        text: "加载中..."
                        color: "white"
                        font.pointSize: 8
                    }
                }

                // 图片加载器 - 懒加载
                Loader {
                    id: imageLoader
                    anchors.fill: parent
                    anchors.margins: 2
                    active: thumbnailDelegate.ListView.view.isItemInView(thumbnailDelegate)

                    sourceComponent: Image {
                        id: thumbnailImage
                        anchors.fill: parent
                        source: modelData
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        cache: true

                        // 图片加载状态
                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.log("缩略图加载失败:", source);
                            }
                        }
                    }
                }

                // 点击选择图片
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        filmStripRoot.imageSelected(modelData)
                        filmstripListView.currentIndex = index
                    }
                }
            }

            // 判断项是否在可见区域
            function isItemInView(delegate) {
                var delegateY = delegate.y
                var viewY = contentY
                var viewHeight = height
                return delegateY >= viewY - 50 && delegateY <= viewY + viewHeight + 50
            }

            // 滚动时更新可见项
            onContentYChanged: {
                // 通过索引范围来检查可见项
                var firstVisibleIndex = indexAt(0, contentY)
                var lastVisibleIndex = indexAt(width, contentY + height)

                if (firstVisibleIndex >= 0 && lastVisibleIndex >= 0) {
                    // 重新激活可见项的图片加载器
                    for (var i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
                        var item = itemAtIndex(i)
                        if (item && item.imageLoader) {
                            item.imageLoader.active = isItemInView(item)
                        }
                    }
                }
            }
        }
    }

    property var filmstripModel: []

    function updateFilmstripList() {
        var list = slideEngine.getImageList();
        console.log("updateFilmstripList 获取到的列表长度:", list.length);
        var newModel = [];

        for (var i = 0; i < list.length; i++) {
            // 解码URL编码的路径
            var decodedPath = decodeURIComponent(list[i]);
            var imagePath = "file:///" + decodedPath;
            newModel.push(imagePath);
        }

        // 设置当前项为当前图像
        var currentPath = currentImageSource.toString().replace("file:///","");
        var currentIndex = list.indexOf(currentPath);
        if (currentIndex > -1) {
            filmstripListView.currentIndex = currentIndex;
        }

        // 重新赋值触发更新
        filmstripModel = newModel;
    }

    onCurrentImageSourceChanged: {
        if (currentImageSource !== "") {
            slideEngine.imageSourceChanged(currentImageSource.toString().replace("file:///",""));
            updateFilmstripList();
        }
    }

    Component.onCompleted: {
        updateFilmstripList();
    }
}
