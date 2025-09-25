import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../Basic"

Item {
    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: idTagsFlow.implicitHeight + secondText.implicitHeight + idImagesFlow.implicitHeight + 120
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

        Flow {
            id: idTagsFlow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 15
            width: flickable.width - 48
            
            property var fixedTags: ["推荐", "官方", "华语", "摇滚", "民谣", "电子", "轻音乐"]
            property var extraTags: ["流行", "嘻哈", "古典", "说唱", "国风", "嘻哈", "古典", "说唱", "国风", "嘻哈", "古典", "说唱", "国风", "嘻哈", "古典", "说唱", "国风"]
            property bool expanded: false
            property string selectedTag: "推荐"
            property ListModel tagModel: ListModel {}

            Component.onCompleted: {
                for (var i = 0; i < fixedTags.length; ++i) {
                    tagModel.append({ "text": fixedTags[i] })
                }
                tagModel.append({ "text": "V" })
            }

            function expand() {
                tagModel.remove(tagModel.count - 1) // 移除 "更多分类"
                for (var j = 0; j < extraTags.length; ++j) {
                    tagModel.append({ "text": extraTags[j] })
                }
                tagModel.append({ "text": "^" })
                expanded = true
            }

            function collapse() {
                var startIndex = fixedTags.length
                tagModel.remove(startIndex, tagModel.count - startIndex) // 移除额外 + 折叠
                tagModel.append({ "text": "V" })
                expanded = false
                // 如果选中的是额外标签，重置到 "推荐"
                if (extraTags.includes(selectedTag)) {
                    selectedTag = "推荐"
                }
            }

            Repeater {
                id: tagsRepeater
                model: idTagsFlow.tagModel

                Rectangle {
                    id: tagRect
                    implicitWidth: tagText.implicitWidth + 20
                    implicitHeight: 35
                    radius: 8
                    border.color: "white"
                    border.width: 1
                    color: (model.text === idTagsFlow.selectedTag && model.text !== "V" && model.text !== "^") ? "#ffcccc" : "transparent"

                    Text {
                        id: tagText
                        anchors.centerIn: parent
                        text: model.text
                        color: (model.text === idTagsFlow.selectedTag && model.text !== "V" && model.text !== "^") ? "red" : "#ffffff"
                        font.pixelSize: 14
                        font.family: "黑体"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: tagMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            if (model.text === "V") {
                                idTagsFlow.expand()
                            } else if (model.text === "^") {
                                idTagsFlow.collapse()
                            } else {
                                idTagsFlow.selectedTag = model.text
                            }
                        }
                    }
                }
            }
        }

        Text {
            id: secondText
            anchors.top: idTagsFlow.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 24
            text: "你是否也喜欢"
            color: "#ffffff"
            font.pixelSize: 18
            font.family: "黑体"
            font.bold: true
        }

        Flow {
            id: idImagesFlow
            anchors.top: secondText.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 15
            width: flickable.width - 48

            property ListModel imageModel: ListModel {
                ListElement { imageSource: "qrc:/Image/Res/PlayMusic/Image/11.png"; albumName: "专辑1: 流行经典"; description: "这是一张经典流行音乐专辑，收录了多首热门歌曲。"; playCount: 1234; bottomColor: "#1E3A8A" }  // 深蓝
                ListElement { imageSource: "qrc:/Image/Res/PlayMusic/Image/8.png"; albumName: "专辑2: 摇滚之夜"; description: "摇滚音乐的激情夜晚，感受节奏的冲击。"; playCount: 23000; bottomColor: "#6B46C1" }  // 紫
                ListElement { imageSource: "qrc:/Image/Res/PlayMusic/Image/9.png"; albumName: "专辑3: 民谣情歌"; description: "温柔的民谣，诉说心事与情感。"; playCount: 4567; bottomColor: "#E53E3E" }  // 红粉
                ListElement { imageSource: "qrc:/Image/Res/PlayMusic/Image/10.png"; albumName: "专辑4: 电子舞曲"; description: "电子音乐的舞动，释放你的能量。"; playCount: 789000; bottomColor: "#2F855A" }  // 绿
                ListElement { imageSource: "qrc:/Image/Res/PlayMusic/Image/11.png"; albumName: "专辑5: 轻音乐"; description: "轻松的旋律，适合放松心情。"; playCount: 123; bottomColor: "#DD6B20" }  // 橙
                ListElement { imageSource: "qrc:/Image/Res/PlayMusic/Image/8.png"; albumName: "专辑6: 古典回响"; description: "古典音乐的永恒魅力，穿越时光。"; playCount: 5678; bottomColor: "#4C51BF" }  // 靛
            }
            property var imageList: []  // 保留原属性但不使用

            Repeater {
                model: idImagesFlow.imageModel
                Item {
                    width: 200
                    height: 300
                    property int albumIndex: index
                    property var albumData: idImagesFlow.imageModel.get(index)

                    Image {
                        id: albumImage
                        anchors.fill: parent
                        source: albumData.imageSource
                        fillMode: Image.PreserveAspectCrop
                        clip: true
                    }

                    // 覆盖层
                    Rectangle {
                        id: overlayRect
                        anchors.fill: parent
                        visible: false
                        opacity: 0
                        color: "transparent"

                        // 左上角图标
                        Image {
                            width: 24; height: 24
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 8
                            source: "qrc:/Image/Res/PlayMusic/Image/wangyiyun.png"
                            fillMode: Image.PreserveAspectFit
                        }

                        // 右上角播放统计
                        Row {
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 8
                            spacing: 4
                            visible: overlayRect.visible

                            Rectangle {
                                width: 14; height: 14
                                color: "transparent"
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    anchors.centerIn: parent
                                    text: "▶"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                            }
                            Text {
                                text: formatPlayCount(albumData.playCount)
                                color: "white"
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        // 专辑名称（在渐变上方）
                        Text {
                            id: albumNameText
                            anchors.bottom: bottomGradient.top
                            anchors.bottomMargin: 8
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 12; anchors.rightMargin: 12
                            text: albumData.albumName
                            color: (albumIndex % 2 === 0) ? "#FFD700" : "#FFFFFF"
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            font.bold: true;
                            elide: Text.ElideRight
                            visible: overlayRect.visible
                        }

                        // 底部渐变区域（仅描述）
                        Rectangle {
                            id: bottomGradient
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: Math.max(60, descText.implicitHeight + 26)
                            visible: overlayRect.visible

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "transparent" }
                                GradientStop { position: 1.0; color: albumData.bottomColor }  // 底部渐变色，alpha 0.5 (80 hex)
                            }

                            // 专辑描述
                            Text {
                                id: descText
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 8
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.leftMargin: 12; anchors.rightMargin: 12
                                text: albumData.description
                                color: Qt.rgba(1, 1, 1, 0.8)
                                font.pixelSize: 14
                                font.weight: Font.Normal
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }
                    }

                    MouseArea {
                        id: imageMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: {
                            overlayRect.visible = true
                            overlayEnterAnim.start()
                        }
                        onExited: {
                            overlayExitAnim.start()
                            overlayRect.visible = false  // 动画后隐藏
                        }
                    }

                    // 进入动画
                    NumberAnimation {
                        id: overlayEnterAnim
                        target: overlayRect
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }

                    // 离开动画
                    NumberAnimation {
                        id: overlayExitAnim
                        target: overlayRect
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }

                    function formatPlayCount(count) {
                        if (count >= 1000000) {
                            return (count / 1000000).toFixed(1) + "M"
                        } else if (count >= 1000) {
                            return (count / 1000).toFixed(1) + "K"
                        } else {
                            return count.toString().replace(/(\d)(?=(\d{3})+$)/g, '$1,')
                        }
                    }
                }
            }
        }
    }

}
