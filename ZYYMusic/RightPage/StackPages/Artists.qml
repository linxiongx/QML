import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../Basic"

Item {
    property int selectedFirst: 0
    property int selectedSecond: 0
    property int selectedLetter: 0

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: mainColumn.height
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
            id: mainColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 20
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 10

            // 第一行标签 - 音乐类型
            Flow {
                id: firstRow
                spacing: 10
                width: parent.width

                Repeater {
                    model: ["全部", "华语", "欧美", "日本", "韩国", "其它"]
                    delegate: Rectangle {
                        id: categoryTag
                        width: Math.max(60, categoryText.implicitWidth + 20) // 动态宽度
                        height: 40
                        radius: 20

                        property bool isSelected: index === selectedFirst
                        property bool isHovered: false

                        color: isSelected ? (isHovered ? Qt.lighter("#ffcccc", 1.1) : "#ffcccc") : (isHovered ? Qt.lighter("#42424b", 1.1) : "#42424b")

                        // 添加悬停效果
                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Text {
                            id: categoryText
                            anchors.centerIn: parent
                            text: modelData
                            color: isSelected ? "red" : "white"
                            font.pixelSize: 14
                            font.family: BasicConfig.commFont
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: isHovered = true
                            onExited: isHovered = false
                            onClicked: {
                                selectedFirst = index
                                console.log("选中第一行:", modelData)
                            }
                        }
                    }
                }
            }

            // 第二行标签 - 歌手类型
            Flow {
                id: secondRow
                spacing: 10
                width: parent.width

                Repeater {
                    model: ["男歌手", "女歌手", "乐队组合"]
                    delegate: Rectangle {
                        id: typeTag
                        width: Math.max(80, typeText.implicitWidth + 20) // 动态宽度
                        height: 40
                        radius: 20

                        property bool isSelected: index === selectedSecond
                        property bool isHovered: false

                        color: isSelected ? (isHovered ? Qt.lighter("#ffcccc", 1.1) : "#ffcccc") : (isHovered ? Qt.lighter("#42424b", 1.1) : "#42424b")

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Text {
                            id: typeText
                            anchors.centerIn: parent
                            text: modelData
                            color: isSelected ? "red" : "white"
                            font.pixelSize: 14
                            font.family: BasicConfig.commFont
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: isHovered = true
                            onExited: isHovered = false
                            onClicked: {
                                selectedSecond = index
                                console.log("选中第二行:", modelData)
                            }
                        }
                    }
                }
            }

            // 热门和A-Z字母行
            Flow {
                id: letterRow
                width: parent.width
                spacing: 5

                property var letters: ["热门"].concat("ABCDEFGHIJKLMNOPQRSTUVWXYZ".split(""))

                Repeater {
                    model: letterRow.letters
                    delegate: Rectangle {
                        id: letterTag
                        width: index === 0 ? 50 : 30 // 热门按钮稍大
                        height: 30
                        radius: 5

                        property bool isSelected: index === selectedLetter
                        property bool isHovered: false

                        color: isSelected ? (isHovered ? Qt.lighter("#ffcccc", 1.1) : "#ffcccc") : (isHovered ? Qt.lighter("#42424b", 1.1) : "#42424b")

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: isSelected ? "red" : "white"
                            font.pixelSize: index === 0 ? 12 : 10
                            font.family: BasicConfig.commFont
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: isHovered = true
                            onExited: isHovered = false
                            onClicked: {
                                selectedLetter = index
                                console.log("选中字母:", modelData)
                            }
                        }
                    }
                }
            }

            // 歌手流式布局
            GridLayout {
                id: artistsGrid
                width: parent.width
                columns: Math.floor(width / 220) // 根据宽度自动计算列数
                columnSpacing: 15
                rowSpacing: 20

                Repeater {
                    model: [
                        {image: "qrc:/Image/Res/PlayMusic/Image/9.png", name: "周杰伦", songs: 500},
                        {image: "qrc:/Image/Res/PlayMusic/Image/10.png", name: "邓紫棋", songs: 300},
                        {image: "qrc:/Image/Res/PlayMusic/Image/11.png", name: "Taylor Swift", songs: 400},
                        {image: "qrc:/Image/Res/PlayMusic/Image/8.png", name: "BTS", songs: 250},
                        {image: "qrc:/Image/Res/PlayMusic/Image/8.png", name: "林俊杰", songs: 350},
                        {image: "qrc:/Image/Res/PlayMusic/Image/11.png", name: "张学友", songs: 200},
                        {image: "qrc:/Image/Res/PlayMusic/Image/9.png", name: "陈奕迅", songs: 280},
                        {image: "qrc:/Image/Res/PlayMusic/Image/10.png", name: "蔡依林", songs: 320}
                    ]

                    delegate: Item {
                        id: artistItem
                        width: 200
                        height: 220

                        // 添加悬停效果
                        property bool hovered: false

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            // 圆形歌手头像 - 可靠的圆形裁剪方案
                            Item {
                                id: avatarContainer
                                width: 120
                                height: 120
                                anchors.horizontalCenter: parent.horizontalCenter

                                Behavior on scale {
                                    NumberAnimation { duration: 200 }
                                }

                                scale: artistItem.hovered ? 1.05 : 1.0

                                // 第一层：背景
                                Rectangle {
                                    anchors.fill: parent
                                    radius: width / 2
                                    color: "#42424b"
                                }

                                // 第二层：图片容器 - 使用 OpacityMask 实现圆形图片
                                Item {
                                    id: imageContainer
                                    width: parent.width - 4
                                    height: parent.height - 4
                                    anchors.centerIn: parent

                                    Image {
                                        id: artistImage
                                        width: imageContainer.width
                                        height: imageContainer.height
                                        anchors.centerIn: imageContainer
                                        source: modelData.image
                                        fillMode: Image.PreserveAspectCrop
                                        smooth: true
                                        asynchronous: true
                                        visible: false  // 隐藏源图片

                                        // 添加图片加载状态指示
                                        Rectangle {
                                            anchors.fill: parent
                                            color: "#42424b"
                                            radius: parent.width / 2
                                            visible: artistImage.status !== Image.Ready

                                            Text {
                                                anchors.centerIn: parent
                                                text: "加载中..."
                                                color: "white"
                                                font.pixelSize: 12
                                            }
                                        }
                                    }

                                    Rectangle {
                                        id: mask
                                        width: imageContainer.width
                                        height: imageContainer.height
                                        radius: width / 2
                                        smooth: true
                                        visible: false
                                    }

                                    OpacityMask {
                                        anchors.fill: imageContainer
                                        source: artistImage
                                        maskSource: mask
                                    }
                                }

                                // 第三层：边框（确保在最上层）
                                Rectangle {
                                    anchors.fill: parent
                                    radius: width / 2
                                    color: "transparent"
                                    border.color: artistItem.hovered ? "#ffcccc" : "#666666"
                                    border.width: 2

                                    Behavior on border.color {
                                        ColorAnimation { duration: 200 }
                                    }
                                }

                                // 第四层：播放按钮叠加层
                                Rectangle {
                                    anchors.fill: parent
                                    radius: width / 2
                                    color: "black"
                                    opacity: artistItem.hovered ? 0.4 : 0
                                    visible: opacity > 0

                                    Behavior on opacity {
                                        NumberAnimation { duration: 200 }
                                    }

                                    // 播放按钮
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 50
                                        height: 50
                                        radius: 25
                                        color: "white"
                                        opacity: 0.9

                                        // 播放三角形 - 使用Text更简单
                                        Text {
                                            anchors.centerIn: parent
                                            text: "▶"
                                            color: "#333333"
                                            font.pixelSize: 20
                                            font.bold: true
                                        }
                                    }
                                }
                            }

                            // 歌手名字
                            Text {
                                text: modelData.name
                                color: "white"
                                font.pixelSize: 16
                                font.family: BasicConfig.commFont
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                                width: artistItem.width - 20
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            // 歌曲数量
                            Text {
                                text: "歌曲：" + modelData.songs
                                color: "#cccccc"
                                font.pixelSize: 12
                                font.family: BasicConfig.commFont
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: artistItem.hovered = true
                            onExited: artistItem.hovered = false
                            onClicked: {
                                console.log("选中歌手: " + modelData.name)
                                // 这里可以添加跳转到歌手详情页的逻辑
                            }
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
        }
    }
}
