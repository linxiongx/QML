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
                // 展开时定位到当前图片
                positionToCurrentImage()
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
                hideTimer.stop()
            }

            onExited: {
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
                        source: model.imagePath
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        cache: true

                        // 图片加载状态
                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.log("缩略图加载失败:", source);
                                // 暂移除XMLHttpRequest检测，因为在本地文件上被禁用
                                // 可以考虑使用其他方法检查文件存在性
                            } else if (status === Image.Ready) {
                                console.log("缩略图加载成功:", source);
                            }
                        }
                    }
                }

                // 点击选择图片
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        filmStripRoot.imageSelected(model.imagePath)
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

    property ListModel filmstripModel: ListModel {}

    function updateFilmstripList() {
        var list = slideEngine.getImageList();
        console.log("updateFilmstripList 获取到的列表长度:", list.length);

        // 清空现有模型
        filmstripModel.clear();
        console.log("updateFilmstripList - 清空模型后，模型数量:", filmstripModel.count);

        for (var i = 0; i < list.length; i++) {
            // C++端返回本地路径，统一转换为file:///格式用于QML Image组件
            var imagePath = list[i];

            // 确保路径有正确的file:///前缀，用于QML Image组件
            if (!imagePath.startsWith("file:///")) {
                // 如果路径是标准本地路径格式（带盘符），转换为FileUrl格式
                if (imagePath.length >= 2 && imagePath[1] === ':') {
                    imagePath = "file:///" + imagePath;
                } else {
                    // 对于其他格式路径，直接添加file:///前缀
                    imagePath = "file:///" + imagePath;
                }
            }

            console.log("updateFilmstripList - 添加图片路径:", imagePath);
            filmstripModel.append({"imagePath": imagePath});
        }

        console.log("updateFilmstripList - 更新后模型数量:", filmstripModel.count);

        // 设置当前项为当前图像
        positionToCurrentImage();
    }

    function positionToCurrentImage() {
        if (filmstripModel.count === 0) return;

        var currentImageSourceStr = currentImageSource.toString();
        var list = slideEngine.getImageList();

        console.log("positionToCurrentImage - currentImageSource:", currentImageSourceStr);
        console.log("positionToCurrentImage - list长度:", list.length);

        var currentIndex = -1;

        // 简化路径比较：直接比较路径内容，不考虑格式差异
        for (var i = 0; i < list.length; i++) {
            var listImagePath = list[i];

            // 移除listImagePath中可能的file:///前缀（如果存在）
            if (listImagePath.startsWith("file:///")) {
                listImagePath = listImagePath.substring(8); // 移除"file:///"前缀
            }

            // 移除currentImageSourceStr中的file:///前缀（如果存在）
            var currentPath = currentImageSourceStr;
            if (currentPath.startsWith("file:///")) {
                currentPath = currentPath.substring(8);
            }

            console.log("positionToCurrentImage - 比较:", currentPath, "vs", listImagePath);

            // 直接比较路径字符串
            if (currentPath === listImagePath) {
                currentIndex = i;
                break;
            }
        }

        console.log("positionToCurrentImage - 找到的索引:", currentIndex);

        if (currentIndex > -1) {
            filmstripListView.currentIndex = currentIndex;
            // 滚动到当前项
            filmstripListView.positionViewAtIndex(currentIndex, ListView.Center);
        } else {
            console.log("positionToCurrentImage - 未找到匹配的当前图片");
            console.log("positionToCurrentImage - 当前图片路径:", currentImageSourceStr);
            console.log("positionToCurrentImage - 可用图片路径:", list);
        }
    }

    onCurrentImageSourceChanged: {
        if (currentImageSource !== "") {
            // 将file://格式路径转换为本地路径传给C++
            var localPath = currentImageSource.toString();
            if (localPath.startsWith("file:///")) {
                localPath = localPath.substring(8); // 移除"file:///"前缀
            }
            slideEngine.imageSourceChanged(localPath);
            updateFilmstripList();
            // 图片切换时也定位到当前图片
            positionToCurrentImage();
        }
    }

    Connections {
        target: slideEngine
        function onImageListChanged() {
            console.log("收到图片列表改变信号，更新胶片栏");
            updateFilmstripList();
        }
    }

    Component.onCompleted: {
        updateFilmstripList();
    }
}
