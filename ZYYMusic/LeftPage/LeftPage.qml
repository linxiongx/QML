import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: leftPage
    property int selectedIndex: 0
    property int selectedIndex2: -1

    width: 255
    height: parent.height
    Row {
        anchors.top: parent.top
        anchors.topMargin: 20;
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8
        Item {
            width: 32
            height: 32

            Image {
                id: logoImage
                anchors.fill: parent
                source: "qrc:/Image/Res/MainLogin/ZyyMusic.png"
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            Rectangle {
                id: mask
                anchors.fill: parent
                radius: width / 2
                visible: false
            }

            OpacityMask {
                anchors.fill: parent
                source: logoImage
                maskSource: mask
            }
        }
        Text {
            text: "网易云音乐"
            font.pixelSize: 20
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Column {
        width: parent.width - 40
        anchors.top: parent.top
        anchors.topMargin: 100
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        spacing: 20  // 增加spacing避免重叠

        Repeater {
            model: [
                {text: "云音乐精选", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"},
                {text: "播客", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"},
                {text: "社区", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"}
            ]

            delegate: Rectangle {
                width: parent.width
                height: 40
                radius: 5

                property bool isSelected: index === leftPage.selectedIndex && leftPage.selectedIndex !== -1
                property bool hovered: false

                color: isSelected ? "#ff4455" : (hovered ? Qt.lighter("#42424b", 1.1) : "transparent")

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    Image {
                        width: 24
                        height: 24
                        source: modelData.icon
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: modelData.text
                        font.pixelSize: 16
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: hovered = true
                    onExited: hovered = false
                    onClicked: {
                        leftPage.selectedIndex = index
                        leftPage.selectedIndex2 = -1
                    }
                    cursorShape: Qt.PointingHandCursor
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#666666"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
        }

        Repeater {
            model: [
                {text: "我喜欢的音乐", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"},
                {text: "最近播放", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"},
                {text: "下载管理", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"},
                {text: "本地音乐", icon: "qrc:/Image/Res/PlayMusic/Image/qun.png"}
            ]

            delegate: Rectangle {
                width: parent.width
                height: 40
                radius: 5

                property bool isSelected: index === leftPage.selectedIndex2 && leftPage.selectedIndex2 !== -1
                property bool hovered: false

                color: isSelected ? "#ff4455" : (hovered ? Qt.lighter("#42424b", 1.1) : "transparent")

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    spacing: 10

                    Image {
                        width: 24
                        height: 24
                        source: modelData.icon
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: modelData.text
                        font.pixelSize: 16
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: hovered = true
                    onExited: hovered = false
                    onClicked: {
                        leftPage.selectedIndex2 = index
                        leftPage.selectedIndex = -1
                    }
                    cursorShape: Qt.PointingHandCursor
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#666666"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            height: 30
            spacing: 10

            Text {
                text: "创建的歌单(0)"
                font.pixelSize: 16
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 56  // 填充宽度，留空间给图标和spacing
                elide: Text.ElideRight
            }

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: 16
                height: 16

                Image {
                    anchors.fill: parent
                    source: "qrc:/Image/Res/PlayMusic/Image/add.png"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "#666666"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
        }
    }
}

