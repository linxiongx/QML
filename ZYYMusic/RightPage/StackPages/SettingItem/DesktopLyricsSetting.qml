import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../Basic"
import "../../CommonUI"

Item {
    id: root

    implicitHeight: 800

    Label {
        id: idDestopLyricsLabel
        anchors.left: root.left
        anchors.top: root.top
        verticalAlignment: Text.AlignVCenter
        text: "桌面歌词"
        font.pixelSize: 22
        font.family: "黑体"
        font.bold: true
        color: "white"
    }

    Column {
        anchors.left: idDestopLyricsLabel.right
        anchors.leftMargin: 70
        anchors.right: root.right
        anchors.top: idDestopLyricsLabel.top
        spacing: 30

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10

            ZYYCheckBox {
                text: "启用桌面歌词"
                checked: true
            }
            ZYYCheckBox {
                text: "启用歌词总在最前"
                checked: true
            }
            ZYYCheckBox {
                text: "外文歌曲显示翻译"
                checked: true
            }
            ZYYCheckBox {
                text: "外文歌词显示音译"
            }
        }

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 70

            Repeater {
                model: ListModel {
                    id: idListModel
                    ListElement { name: "字体" }
                    ListElement { name: "字号" }
                    ListElement { name: "字粗" }
                    ListElement { name: "描边" }
                }

                delegate: Item {
                    width: 100
                    height: idLabel.implicitHeight + 25 + 10

                    Label {
                        id: idLabel
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.top: parent.top
                        text: name
                        font.family: "黑体"
                        font.pixelSize: 18
                        color: "white"
                    }

                    ZYYComboBox {
                        anchors.left: parent.left
                        anchors.top: idLabel.bottom
                        anchors.topMargin: 10
                        height: 25
                        width: 120

                        Component.onCompleted: {
                            if (index === 0) {
                                model = ["默认", "仿宋", "华文中宋", "华文范松", "华文新魏", "华文楷体"];
                                defaultText = "默认";
                            } else if (index === 1) {
                                var varModel = [];
                                for (let i = 20; i < 97; ++i)
                                    varModel.push(i);
                                model = varModel;
                                defaultText = 20;
                            } else if (index === 2) {
                                model = ["标准", "加粗"]
                                defaultText = "标准";
                            } else if (index === 3) {
                                model = ["有描边", "无描边"];
                                defaultText = "有描边";
                            }
                        }
                    }
                }
            }
        }

        Item {
            height: 50
            width: parent.width

            Label {
                id: idAdjustFormat
                text: "调整样式"
                font.family: "黑体"
                font.pixelSize: 18
                color: "white"
            }

            Row {
                anchors.left: parent.left
                anchors.top: idAdjustFormat.bottom
                anchors.topMargin: 10
                spacing: 50

                Repeater {
                    model: [["单行显示", "多行显示"], ["横排显示", "竖排显示"], ["左对齐", "右对齐"]]

                    ZYYComboBox {
                        height: 25
                        width: 120
                        model: modelData
                        defaultText: modelData[0]
                    }
                }
            }
        }

        Item {
            height: 50
            width: parent.width

            Label {
                id: idChangeColorLabel
                text: "更改配色方案"
                font.family: "黑体"
                font.pixelSize: 18
                color: "#ddd"
            }

            Row {
                anchors.left: parent.left
                anchors.top: idChangeColorLabel.bottom
                anchors.topMargin: 10
                spacing: 50

                ZYYComboBox {
                    model: ["自定义", "周易红", "落日晖", "可爱粉", "清新绿", "活力紫", "温柔黄", "低调灰"]
                    defaultText: "周易红"
                }

                Repeater {
                    model: ["已播放", "未播放"]
                    delegate: Rectangle {
                        radius: 15
                        width: 150
                        height: 30
                        border.width: 1
                        border.color: "#28282e"
                        color: "#1a1a20"

                        Rectangle {
                            id: idColorRect
                            width: parent.height / 2
                            height: width
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            gradient: Gradient {
                                GradientStop { position: 0; color: modelData === "已播放" ? BasicConfig.finishedLyricsUpColor : BasicConfig.unFinishedLyricsUpColor }
                                GradientStop { position: 1; color: modelData === "已播放" ? BasicConfig.finishedLyricsDownColor : BasicConfig.unFinishedLyricsDownColor }
                            }
                        }

                        Text {
                            id: idColorSelecText
                            color: "#ddd"
                            text: modelData
                            font.pixelSize: 20
                            anchors.left: idColorRect.right
                            anchors.leftMargin: 10
                            font.family: BasicConfig.commFont
                            anchors.verticalCenter: idColorRect.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: cursorShape = Qt.PointingHandCursor
                            onExited: cursorShape = Qt.ArrowCursor
                            onClicked: {
                                if (modelData === "已播放") {
                                    finishedColorDialog.selectedColor = BasicConfig.finishedLyricsUpColor
                                    finishedColorDialog.open()
                                } else {
                                    unfinishedColorDialog.selectedColor = BasicConfig.unFinishedLyricsUpColor
                                    unfinishedColorDialog.open()
                                }
                            }
                        }
                    }
                }
            }
        }

        // 已播放颜色对话框
        ColorDialog {
            id: finishedColorDialog
            title: "选择已播放颜色"
            selectedColor: BasicConfig.finishedLyricsUpColor
            onAccepted: {
                console.log("已播放颜色接受: " + selectedColor.toString())
                var scheme = BasicConfig.colorScheme || {}
                scheme.finishedUp = selectedColor
                BasicConfig.updateScheme(scheme)
            }
            onRejected: {
                console.log("已播放颜色取消")
            }
        }

        // 未播放颜色对话框
        ColorDialog {
            id: unfinishedColorDialog
            title: "选择未播放颜色"
            selectedColor: BasicConfig.unFinishedLyricsUpColor
            onAccepted: {
                console.log("未播放颜色接受: " + selectedColor.toString())
                var scheme = BasicConfig.colorScheme || {}
                scheme.unFinishedUp = selectedColor
                BasicConfig.updateScheme(scheme)
            }
            onRejected: {
                console.log("未播放颜色取消")
            }
        }
    }
}