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
        }
    }
}
