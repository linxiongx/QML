import QtQuick
import QtQuick.Controls
import "../../../Basic"

Column {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: 20
    spacing: 20

    // 关于标题
    Label {
        text: "关于网易云音乐"
        font.pixelSize: 24
        font.bold: true
        font.family: BasicConfig.commFont
        color: "white"
        anchors.left: parent.left
    }

    // 应用信息
    Column {
        spacing: 10
        Label {
            text: "ZYYMusic v1.0.0"
            font.pixelSize: 18
            color: "white"
            anchors.left: parent.left
        }
        Label {
            text: "一款基于网易云音乐的 Qt Quick 桌面播放器"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
        Label {
            text: "开发者: ZYY Team"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
    }

    // 版权
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#212127"
    }

    Column {
        spacing: 10
        Label {
            text: "版权信息"
            font.pixelSize: 18
            color: "white"
            anchors.left: parent.left
            font.bold: true
        }
        Label {
            text: "© 2024 网易云音乐 All Rights Reserved"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
        Label {
            text: "本应用使用网易云音乐 API，受其服务条款约束"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
    }

    // 联系与支持
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#212127"
    }

    Column {
        spacing: 10
        Label {
            text: "支持与联系"
            font.pixelSize: 18
            color: "white"
            anchors.left: parent.left
            font.bold: true
        }
        Row {
            spacing: 10
            Button {
                text: "隐私政策"
                width: 100
                onClicked: {
                    console.log("打开隐私政策")
                    // Qt.openUrlExternal("https://music.163.com/policy")
                }
            }
            Button {
                text: "用户协议"
                width: 100
                onClicked: {
                    console.log("打开用户协议")
                }
            }
        }
        Label {
            text: "反馈邮箱: support@zyymusic.com"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
    }

    // 更新日志简述
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#212127"
    }

    Column {
        spacing: 10
        Label {
            text: "最近更新"
            font.pixelSize: 18
            color: "white"
            anchors.left: parent.left
            font.bold: true
        }
        Label {
            text: "v1.0.0 - 2024/09: 初始发布，支持云音乐、播放控制、设置页面。"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
        Label {
            text: "v0.9.0 - 2024/08: 添加桌面歌词、工具功能。"
            font.pixelSize: 16
            color: "#b9b9ba"
            anchors.left: parent.left
        }
    }

    // 预留空间
    Item { height: 100 }
}
