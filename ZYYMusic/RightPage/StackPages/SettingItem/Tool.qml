import QtQuick
import QtQuick.Controls
import "../../../Basic"

Column {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: 20
    spacing: 20

    // 工具标题
    Label {
        text: "工具设置"
        font.pixelSize: 24
        font.bold: true
        font.family: BasicConfig.commFont
        color: "white"
        anchors.left: parent.left
    }

    // 清理缓存
    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        Label {
            text: "清理缓存"
            font.pixelSize: 18
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            text: "清理"
            width: 80
            onClicked: {
                console.log("清理缓存完成") // 模拟，实际集成IO
            }
        }
    }

    // 导出歌单
    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        Label {
            text: "导出歌单"
            font.pixelSize: 18
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            text: "导出"
            width: 80
            onClicked: {
                console.log("歌单导出完成") // 实际保存JSON
            }
        }
    }

    // 自动备份设置
    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        CheckBox {
            id: backupCheckbox
            text: "自动备份设置"
            checked: false
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // 播放历史管理
    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        Label {
            text: "播放历史"
            font.pixelSize: 18
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        Button {
            text: "查看"
            width: 80
            onClicked: {
                console.log("查看播放历史")
            }
        }

        Button {
            text: "清空"
            width: 80
            onClicked: {
                console.log("清空播放历史")
            }
        }
    }

    // 预留扩展
    Item { height: 200 }
}
