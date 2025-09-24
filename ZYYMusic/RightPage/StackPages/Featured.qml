import QtQuick
import QtQuick.Controls
 import QtQuick.Layouts
import "../../Basic"

Item {
    id: root
    property var playlistData: [
        { name: "流行热曲精选", desc: "当下最火的流行单曲集合，让你随时跟上潮流节奏。不论是热门榜单上的新歌，还是社交平台刷屏的旋律，这里都有，让你每一次播放都充满青春活力与动感节拍。" },
        { name: "经典老歌回忆", desc: "跨越岁月的经典旋律，每一首都是回忆的味道。从怀旧的老歌到永不过时的经典旋律，每一次聆听都像翻开时光的相册，唤醒心底温暖的记忆。" },
        { name: "轻松午后", desc: "轻音乐与柔和旋律，陪伴你的慵懒午后时光。无论是办公间隙还是周末休憩，这些舒缓的旋律都能带来片刻宁静，让你在忙碌中找到轻松与舒适。" },
        { name: "夜晚电音派对", desc: "电音节拍轰炸，让夜晚充满能量与激情。无论是在舞池中释放自我，还是在耳机里尽情享受动感节奏，这里都是让夜晚不眠的音乐盛宴，点燃你的每一个夜晚。" }
    ]
    property var imageSources: [
        "qrc:/Image/Res/PlayMusic/Image/8.png",
        "qrc:/Image/Res/PlayMusic/Image/9.png",
        "qrc:/Image/Res/PlayMusic/Image/10.png",
        "qrc:/Image/Res/PlayMusic/Image/11.png"
    ]
    property var songData: [
        { name: "夏天的风", artist: "歌手A", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
        { name: "永恒的记忆", artist: "歌手B", image: "qrc:/Image/Res/PlayMusic/Image/9.png" },
        { name: "午后咖啡", artist: "歌手C", image: "qrc:/Image/Res/PlayMusic/Image/10.png" },
        { name: "夜色电音", artist: "歌手D", image: "qrc:/Image/Res/PlayMusic/Image/11.png" },
        { name: "摇滚之夜", artist: "歌手E", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
        { name: "独立之声", artist: "歌手F", image: "qrc:/Image/Res/PlayMusic/Image/9.png" }
    ]
    Flickable {        id: flickable
        anchors.fill: parent
        contentHeight: 1500  // 增加以容纳新布局
        clip: true
        ScrollBar.vertical: ScrollBar {
            // anchors.right: parent.right
            anchors.rightMargin: 5
            width: 10
            contentItem: Rectangle {
                visible: parent.active
                implicitWidth: 10
                radius: 4
                color: "#42424b"
            }
        }
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // 轮播图部分
            Rectangle {
                id: carouselContainer
                width: parent.width
                height: 300
                color: "transparent"

                property int currentIndex: 0
                property var imageList: [
                    "qrc:/Image/Res/PlayMusic/Image/1.jpg",
                    "qrc:/Image/Res/PlayMusic/Image/2.jpg",
                    "qrc:/Image/Res/PlayMusic/Image/3.jpg",
                    "qrc:/Image/Res/PlayMusic/Image/4.jpg",
                    "qrc:/Image/Res/PlayMusic/Image/5.jpg",
                    "qrc:/Image/Res/PlayMusic/Image/6.jpg",
                    "qrc:/Image/Res/PlayMusic/Image/7.jpg"
                ]
                property int totalImages: imageList.length
                property int spacing: 0  // 无间隙无缝轮播
                property real halfWidth: width / 2  // 每张图片宽度，一次显示两张
                property real itemWidth: halfWidth  // 兼容旧引用
                property int infiniteCopies: totalImages * 3
                property real baseOffset: totalImages * (halfWidth + spacing)

                // 多张图片轮播 ListView
                ListView {
                    id: imageListView
                    anchors.fill: parent
                    anchors.bottomMargin: 25;
                    orientation: ListView.Horizontal
                    model: carouselContainer.infiniteCopies
                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.NoHighlightRange  // 移除范围限制
                    interactive: false  // 禁用手动拖拽，只用箭头和timer
                    clip: true
                    spacing: carouselContainer.spacing

                    // 手动 contentWidth，确保全宽支持7张
                    contentWidth: carouselContainer.infiniteCopies * carouselContainer.halfWidth + (carouselContainer.infiniteCopies - 1) * carouselContainer.spacing

                    delegate: Item {
                        width: carouselContainer.itemWidth  // 使用容器属性，避免 ListView 内部 property 延迟
                        height: imageListView.height
                        Image {
                            anchors.leftMargin: 8;
                            anchors.rightMargin: 8;
                            anchors.fill: parent
                            source: carouselContainer.imageList[index % carouselContainer.totalImages]
                            fillMode: Image.PreserveAspectCrop
                            clip: true
                        }
                    }

                    // 平滑动画
                    Behavior on contentX {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.Linear
                        }
                    }

                    onContentXChanged: {
                        var step = carouselContainer.halfWidth + carouselContainer.spacing
                        var offsetIndex = Math.round((contentX - carouselContainer.baseOffset) / step)
                        var newIndex = Math.abs(offsetIndex) % carouselContainer.totalImages
                        if (newIndex !== carouselContainer.currentIndex) {
                            carouselContainer.currentIndex = newIndex
                        }
                    }

                    // 初始位置
                    Component.onCompleted: {
                        contentX = carouselContainer.baseOffset  // 显示0和1
                    }
                }

                // 左箭头
                MouseArea {
                    id: leftArrow
                    visible:false;
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    z: 2

                    Rectangle {
                        anchors.fill: parent
                        color: "gray"
                        radius: 20
                        opacity: 0.7
                        Text {
                            anchors.centerIn: parent
                            text: "<"
                            color: "white"
                            font.pixelSize: 20
                            font.bold: true
                        }
                    }

                    onClicked: {
                        var nextIndex = (carouselContainer.currentIndex - 1 + carouselContainer.totalImages) %
                                carouselContainer.totalImages
                        carouselContainer.currentIndex = nextIndex
                        imageListView.contentX = carouselContainer.baseOffset + nextIndex * (carouselContainer.halfWidth + carouselContainer.spacing)
                        console.log("Left clicked, nextIndex:", nextIndex)
                    }
                }

                // 右箭头
                MouseArea {
                    id: rightArrow
                    visible:false;
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    z: 2

                    Rectangle {
                        anchors.fill: parent
                        color: "gray"
                        radius: 20
                        opacity: 0.7
                        Text {
                            anchors.centerIn: parent
                            text: ">"
                            color: "white"
                            font.pixelSize: 20
                            font.bold: true
                        }
                    }

                    onClicked: {
                        var nextIndex = (carouselContainer.currentIndex + 1) % carouselContainer.totalImages
                        carouselContainer.currentIndex = nextIndex
                        imageListView.contentX = carouselContainer.baseOffset + nextIndex * (carouselContainer.halfWidth + carouselContainer.spacing)
                        console.log("Right clicked, nextIndex:", nextIndex)
                    }
                }

                // 底部指示器
                Row {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 8
                    z: 3

                    Repeater {
                        model: carouselContainer.totalImages
                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: index === carouselContainer.currentIndex ? "#eb4d44" : "#a1a1a3"
                        }
                    }
                }

                // 自动轮播 Timer
                Timer {
                    id: autoTimer
                    interval: 3000
                    running: true
                    repeat: true
                    onTriggered: {
                        var nextIndex = (carouselContainer.currentIndex + 1) % carouselContainer.totalImages
                        carouselContainer.currentIndex = nextIndex
                        imageListView.contentX = carouselContainer.baseOffset + nextIndex * (carouselContainer.halfWidth + carouselContainer.spacing)
                        console.log("Timer triggered, nextIndex:", nextIndex)
                    }
                }

                // 鼠标悬停暂停自动轮播
                MouseArea {
                    anchors.fill: carouselContainer
                    hoverEnabled: true
                    onEntered:
                    {
                        leftArrow.visible = true;
                        rightArrow.visible = true;
                        autoTimer.stop()
                    }
                    onExited:
                    {
                        leftArrow.visible = false;
                        rightArrow.visible = false;
                        autoTimer.start()
                    }
                }
            }

             // 官方歌单
            Item
            {
                width: parent.width;
                height: idOfficialPlaylistText.implicitHeight + idImageRouLayout.height + 10; // 间距

                // 官方歌单文本
                Text {
                    id: idOfficialPlaylistText
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    text: "官方歌单>"
                    font.pixelSize: 18
                    font.bold: true
                    color: "white"
                }

                // 四张并排图片
                RowLayout {
                    id: idImageRouLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: idOfficialPlaylistText.bottom
                    anchors.topMargin: 10
                    height: 120 * 3
                    spacing: 10
                    clip: true
                    Repeater {
                        model: root.imageSources
                        delegate: Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            property var playlist: root.playlistData[index]
                            property real overlayOpacity: 0

                            Image {
                                id: img
                                anchors.fill: parent
                                source: modelData
                                fillMode: Image.PreserveAspectCrop
                                clip: true
                            }

                            Rectangle {
                                id: overlay
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: parent.height * 0.5
                                color: "black"
                                opacity: overlayOpacity
                                clip: true

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.bottom: idOverlayArea.top
                                    anchors.bottomMargin: 10
                                    text: playlist.name + "\n" + playlist.desc
                                    color: "white"
                                    font.pixelSize: 16
                                    width: parent.width - 20
                                    wrapMode: Text.WordWrap
                                    style: Text.Outline
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignBottom
                                }

                                MouseArea {
                                    id: idOverlayArea
                                    anchors.right: parent.right
                                    anchors.rightMargin: 10
                                    anchors.bottom: parent.bottom
                                    anchors.bottomMargin: 10
                                    width: 40
                                    height: 40

                                    Rectangle {
                                        anchors.fill: parent
                                        color: "black"
                                        radius: 20
                                        opacity: 1// 与覆盖层同步
                                        Text {
                                            anchors.centerIn: parent
                                            text: "▶"
                                            color: "white"
                                            font.pixelSize: 20
                                            font.bold: true
                                        }
                                    }

                                    onClicked: {
                                        console.log("播放 " + playlist.name)
                                    }
                                }

                                Behavior on opacity {
                                    NumberAnimation { duration: 300 }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: overlayOpacity = 0.4
                                onExited: overlayOpacity = 0
                            }
                        }
                    }
                }

            }


            // 最新音乐部分的修复版本
            Item {
                width: parent.width
                height: idLastestMusicText.implicitHeight + idMusicGrid.height + 10

                // 最新音乐文本
                Text {
                    id: idLastestMusicText
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    text: "最新音乐>"
                    font.pixelSize: 18
                    font.bold: true
                    color: "white"
                }

                // 6个最新音乐元素 (3x2 Grid)
                GridLayout {
                    id: idMusicGrid
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: idLastestMusicText.bottom
                    anchors.topMargin: 10
                    columns: 2
                    rows: 3
                    rowSpacing: 15
                    columnSpacing: 20

                    Repeater {
                        model: root.songData
                        delegate: Item {
                            id: songItem
                            Layout.fillWidth: true
                            Layout.preferredHeight: 100
                            Layout.minimumHeight: 100

                            // 悬停状态管理
                            property bool isHovered: false

                            // 背景选中状态
                            Rectangle {
                                id: backgroundRect
                                anchors.fill: parent
                                anchors.margins: 5
                                color: songItem.isHovered ? "#80000000" : "transparent"
                                radius: 8
                                border.color: "#eb4d44"
                                border.width: songItem.isHovered ? 2 : 0

                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }
                                Behavior on border.width {
                                    NumberAnimation { duration: 200 }
                                }
                            }

                            Row {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15

                                // 左侧图片和播放按钮
                                Item {
                                    width: 80
                                    height: 80
                                    anchors.verticalCenter: parent.verticalCenter

                                    Image {
                                        id: albumImage
                                        anchors.fill: parent
                                        source: modelData.image
                                        fillMode: Image.PreserveAspectCrop
                                        clip: true
                                    }

                                    // 播放按钮叠加层
                                    Rectangle {
                                        id: playButton
                                        anchors.centerIn: parent
                                        width: 30
                                        height: 30
                                        radius: 15
                                        color: "#80000000"
                                        opacity: songItem.isHovered ? 0.9 : 0
                                        visible: opacity > 0

                                        Text {
                                            anchors.centerIn: parent
                                            text: "▶"
                                            color: "white"
                                            font.pixelSize: 14
                                            font.bold: true
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                console.log("播放: " + modelData.name)
                                            }
                                        }

                                        Behavior on opacity {
                                            NumberAnimation { duration: 200 }
                                        }
                                    }
                                }

                                // 右侧文本和图标
                                Column {
                                    width: parent.width - 95 - 150  // 减去图片宽度和间距
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 8

                                    // 歌曲名称
                                    Text {
                                        text: modelData.name
                                        color: "white"
                                        font.pixelSize: 16
                                        font.bold: true
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }

                                    // 歌手名字
                                    Text {
                                        text: modelData.artist
                                        color: "#cccccc"
                                        font.pixelSize: 14
                                        width: parent.width
                                        elide: Text.ElideRight
                                    }

                              }

                                // 图标行
                                Row {
                                    id: iconRow
                                    spacing: 20
                                    //anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter;
                                    opacity: songItem.isHovered ? 1 : 0
                                    visible: opacity > 0

                                    // 下载图标
                                    MouseArea {
                                        width: 20
                                        height: 20
                                        onClicked: {
                                            console.log("下载: " + modelData.name)
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: "⬇"
                                            color: "#cccccc"
                                            font.pixelSize: 14
                                        }
                                    }

                                    // 收藏图标
                                    MouseArea {
                                        width: 20
                                        height: 20
                                        onClicked: {
                                            console.log("收藏: " + modelData.name)
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: "♥"
                                            color: "#cccccc"
                                            font.pixelSize: 16
                                        }
                                    }

                                    // 更多图标
                                    MouseArea {
                                        width: 20
                                        height: 20
                                        onClicked: {
                                            console.log("更多: " + modelData.name)
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: "⋯"
                                            color: "#cccccc"
                                            font.pixelSize: 16
                                            font.bold: true
                                        }
                                    }

                                    Behavior on opacity {
                                        NumberAnimation { duration: 200 }
                                    }
                                }

                            }

                            // 主悬停区域 - 放在最上层
                            MouseArea {
                                id: hoverArea
                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    songItem.isHovered = true
                                }

                                onExited: {
                                    songItem.isHovered = false
                                }

                                onClicked: {
                                    console.log("点击歌曲: " + modelData.name)
                                }
                            }
                        }
                    }
                }
            }


        }
    }
}
