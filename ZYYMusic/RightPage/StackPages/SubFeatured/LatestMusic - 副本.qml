import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: latestMusicRoot
    property var songData: [
        { name: "夏天的风", artist: "歌手A", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
        { name: "永恒的记忆", artist: "歌手B", image: "qrc:/Image/Res/PlayMusic/Image/9.png" },
        { name: "午后咖啡", artist: "歌手C", image: "qrc:/Image/Res/PlayMusic/Image/10.png" },
        { name: "夜色电音", artist: "歌手D", image: "qrc:/Image/Res/PlayMusic/Image/11.png" },
        { name: "摇滚之夜", artist: "歌手E", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
        { name: "独立之声", artist: "歌手F", image: "qrc:/Image/Res/PlayMusic/Image/9.png" }
    ]
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
            model: latestMusicRoot.songData
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
                        anchors.verticalCenter: parent.verticalCenter
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