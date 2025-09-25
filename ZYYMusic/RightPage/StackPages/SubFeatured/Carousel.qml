import QtQuick
import QtQuick.Controls

Item {
    id: carouselRoot
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
    property int currentIndex: 0
    width: parent.width
    height: 300

    // 多张图片轮播 ListView
    ListView {
        id: imageListView
        anchors.fill: parent
        anchors.bottomMargin: 25
        orientation: ListView.Horizontal
        model: carouselRoot.totalImages * 3
        snapMode: ListView.SnapToItem
        highlightRangeMode: ListView.NoHighlightRange
        interactive: false
        clip: true
        spacing: 0

        contentWidth: carouselRoot.totalImages * 3 * (width / 2)

        delegate: Item {
            width: imageListView.width / 2
            height: imageListView.height
            Image {
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.fill: parent
                source: carouselRoot.imageList[index % carouselRoot.totalImages]
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
            var step = width / 2
            var offsetIndex = Math.round((contentX - (carouselRoot.totalImages * step)) / step)
            var newIndex = Math.abs(offsetIndex) % carouselRoot.totalImages
            if (newIndex !== carouselRoot.currentIndex) {
                carouselRoot.currentIndex = newIndex
            }
        }

        // 初始位置
        Component.onCompleted: {
            contentX = carouselRoot.totalImages * (width / 2)
        }
    }

    // 左箭头
    MouseArea {
        id: leftArrow
        visible: false
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
            var nextIndex = (carouselRoot.currentIndex - 1 + carouselRoot.totalImages) % carouselRoot.totalImages
            carouselRoot.currentIndex = nextIndex
            imageListView.contentX = (carouselRoot.totalImages * (imageListView.width / 2)) + nextIndex * (imageListView.width / 2)
            console.log("Left clicked, nextIndex:", nextIndex)
        }
    }

    // 右箭头
    MouseArea {
        id: rightArrow
        visible: false
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
            var nextIndex = (carouselRoot.currentIndex + 1) % carouselRoot.totalImages
            carouselRoot.currentIndex = nextIndex
            imageListView.contentX = (carouselRoot.totalImages * (imageListView.width / 2)) + nextIndex * (imageListView.width / 2)
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
            model: carouselRoot.totalImages
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: index === carouselRoot.currentIndex ? "#eb4d44" : "#a1a1a3"
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
            var nextIndex = (carouselRoot.currentIndex + 1) % carouselRoot.totalImages
            carouselRoot.currentIndex = nextIndex
            imageListView.contentX = (carouselRoot.totalImages * (imageListView.width / 2)) + nextIndex * (imageListView.width / 2)
            console.log("Timer triggered, nextIndex:", nextIndex)
        }
    }

    // 鼠标悬停暂停自动轮播
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            leftArrow.visible = true
            rightArrow.visible = true
            autoTimer.stop()
        }
        onExited: {
            leftArrow.visible = false
            rightArrow.visible = false
            autoTimer.start()
        }
    }
}