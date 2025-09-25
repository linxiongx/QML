import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: officialPlaylistRoot

    width: parent.width
    height: idOfficialPlaylistText.implicitHeight + idImageRouLayout.height + 10

    // 官方歌单文本
    Text {
        id: idOfficialPlaylistText
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        text: "官方歌单>"
        font.pixelSize: 18
        font.bold: true
        color: "white"
    }

    // 四张并排图片
    RowLayout {
        id: idImageRouLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: idOfficialPlaylistText.bottom
        anchors.topMargin: 10
        height: 360
        spacing: 10
        clip: true
        Repeater {
            model: officialPlaylistRoot.imageSources
            delegate: Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                property var playlist: officialPlaylistRoot.playlistData[index]
                property color bottomColor: playlist.bottomColor || "#1E3A8A"  // 默认色
                property real overlayOpacity: 0

                Image {
                    id: img
                    anchors.fill: parent
                    source: modelData
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                }

                // 歌单名称（在渐变上方）
                Text {
                    id: playlistNameText
                    anchors.bottom: overlay.bottom
                    anchors.bottomMargin: 128
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    text: playlist.name
                    color: "#FFFFFF"
                    font.pixelSize: 18
                    font.weight: Font.Medium
                    font.bold: true;
                    elide: Text.ElideRight
                    visible: overlayOpacity > 0
                    z:11
                }

                // 底部渐变覆盖层
                Rectangle {
                    id: overlay
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height * 0.5
                    clip: true

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 1.0; color: bottomColor}  // 底部唯一渐变色，全不透明，更明显背景
                    }
                    opacity: overlayOpacity

                    // 歌单描述
                    Text {
                        id: idSongDesc;
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.bottom: idOverlayArea.top
                        anchors.bottomMargin: 10
                        text: playlist.desc
                        color: "white"
                        font.pixelSize: 14
                        font.weight: Font.Normal
                        width: parent.width - 20
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        style: Text.Outline
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                    }

                    MouseArea {
                        id: idOverlayArea
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        width: 40
                        height: 40

                        Rectangle {
                            anchors.fill: parent
                            color: "black"
                            radius: 20
                            opacity: 1
                            Text {
                                anchors.centerIn: parent
                                text: "▶"
                                color: "white"
                                font.pixelSize: 20
                                font.bold: true
                            }
                        }

                        onClicked: {
                            console.log("播放 " + playlist.name)
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: overlayOpacity = 0.8
                    onExited: overlayOpacity = 0
                }
            }
        }
    }
}
