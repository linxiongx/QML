import QtQuick
import QtQuick.Controls
import "../../Basic"

Item {
    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: 1000
        clip: true
        ScrollBar.vertical: ScrollBar {
            anchors.right: parent.right
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

                // 多张图片轮播 ListView
                ListView {
                    id: imageListView
                    anchors.fill: parent
                    orientation: ListView.Horizontal
                    model: carouselContainer.imageList
                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    interactive: false  // 禁用手动拖拽，只用箭头和timer
                    clip: true
                    spacing: 10  // 图片间距

                    property real itemWidth: (carouselContainer.width - (carouselContainer.totalImages - 1) * 10) / carouselContainer.totalImages
                    property real spacing: 10

                    delegate: Item {
                        width: imageListView.itemWidth
                        height: imageListView.height
                        Image {
                            anchors.fill: parent
                            anchors.rightMargin: imageListView.spacing  // 右边间距
                            source: modelData
                            fillMode: Image.PreserveAspectCrop
                            clip: true
                        }
                    }

                    // 手动设置contentWidth以确保总宽度正确
                    onWidthChanged: {
                        contentWidth = carouselContainer.totalImages * itemWidth + (carouselContainer.totalImages - 1) * spacing
                    }
                    Component.onCompleted: {
                        contentWidth = carouselContainer.totalImages * itemWidth + (carouselContainer.totalImages - 1) * spacing
                    }

                    onContentXChanged: {
                        carouselContainer.currentIndex = Math.round((contentX + itemWidth / 2) / (itemWidth + spacing))
                    }

                    // 初始位置
                    Component.onCompleted: {
                        contentX = carouselContainer.currentIndex * (itemWidth + spacing)
                    }
                }

                // 左箭头
                MouseArea {
                    id: leftArrow
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    z: 2

                    Rectangle {
                        anchors.fill: parent
                        color: "gray"
                        radius: 20
                        Text {
                            anchors.centerIn: parent
                            text: "<"
                            color: "white"
                            font.pixelSize: 20
                            font.bold: true
                        }
                    }

                    onClicked: {
                        var nextIndex = (carouselContainer.currentIndex - 1 + carouselContainer.totalImages) % carouselContainer.totalImages;
                        carouselContainer.currentIndex = nextIndex;
                        imageListView.contentX = nextIndex * (imageListView.itemWidth + imageListView.spacing);
                    }
                }

                // 右箭头
                MouseArea {
                    id: rightArrow
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 40
                    height: 40
                    z: 2

                    Rectangle {
                        anchors.fill: parent
                        color: "white"
                        radius: 20
                        Text {
                            anchors.centerIn: parent
                            text: ">"
                            color: "white"
                            font.pixelSize: 20
                            font.bold: true
                        }
                    }

                    onClicked: {
                        var nextIndex = (carouselContainer.currentIndex + 1) % carouselContainer.totalImages;
                        carouselContainer.currentIndex = nextIndex;
                        imageListView.contentX = nextIndex * (imageListView.itemWidth + imageListView.spacing);
                    }
                }

                // 底部指示器
                Row {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10  // 避免重叠
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
                        var nextIndex = (carouselContainer.currentIndex + 1) % carouselContainer.totalImages;
                        carouselContainer.currentIndex = nextIndex;
                        imageListView.contentX = nextIndex * (imageListView.itemWidth + imageListView.spacing);
                    }
                }

                // 鼠标悬停暂停自动轮播
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: autoTimer.stop()
                    onExited: autoTimer.start()
                }
            }

        }
    }
}
