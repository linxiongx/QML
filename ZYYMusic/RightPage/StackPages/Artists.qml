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
        Text {
            anchors.centerIn: parent
            text: qsTr("歌手内容 - 待实现")
            color: "white"
            font.pixelSize: 20
            font.family: BasicConfig.commFont
        }
    }
}