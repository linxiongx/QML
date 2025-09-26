import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../Basic"

Item {
    property var detailModel: null

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height + 20
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar { anchors.right: parent.right; anchors.rightMargin: 5; width: 10 }

        Column {
            id: column
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            spacing: 15
            width: parent.width - 40

            // 榜单标题
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: detailModel ? detailModel.name : "排行榜详情"
                color: "#d9d9da"
                font.bold: true
                font.pixelSize: 24
                wrapMode: Text.WordWrap
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: detailModel ? detailModel.desc : ""
                color: "gray"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
            }

            // 图片
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200; height: 200
                source: detailModel ? detailModel.image : ""
                fillMode: Image.PreserveAspectFit
            }

            // 歌曲列表
            Repeater {
                model: detailModel ? detailModel.songs : []
                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: "lightgray"
                    radius: 5
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (modelData.song) console.log("播放歌曲: " + modelData.song + " - " + modelData.artist)
                        }
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Text {
                            text: modelData ? (modelData.rank ? "#" + modelData.rank : "") : ""
                            font.bold: true
                            color: (modelData && modelData.rank && modelData.rank <= 3) ? "red" : "blue"
                            width: 30
                        }

                        Text {
                            text: modelData ? (modelData.song + " - " + modelData.artist) : ""
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            width: parent.width - 100
                        }

                        Text {
                            text: modelData ? modelData.duration : ""
                            font.pixelSize: 12
                            color: "gray"
                        }
                    }
                }
            }
        }
    }

    // 返回按钮
    Button {
        text: "返回"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 10
        anchors.leftMargin: 10
        onClicked: {
            // 假设 StackView id 为 idMainStackView
            parent.pop()
        }
    }
}