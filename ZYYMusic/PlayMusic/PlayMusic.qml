import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    height: 100
    color: "#1e1e1e"  // 深色背景，更适合音乐播放器

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        anchors.leftMargin: 30;
        spacing: 30

        // 左侧圆形头像（专辑封面）
        Item {
            id: albumContainer
            width: 80
            height: 80
            Layout.alignment: Qt.AlignVCenter

            // 最外层黑色圆背景
            Rectangle {
                id: blackRing
                anchors.fill: parent
                radius: width / 2
                color: "black"
                opacity: 0.8  // 半透明黑色圆，确保不完全覆盖
            }

            // 图片容器（进一步缩小）
            Item {
                id: imageContainer
                width: 60  // 缩小到60x60
                height: 60
                anchors.centerIn: parent

                Image {
                    id: albumImage
                    width: imageContainer.width
                    height: imageContainer.height
                    anchors.centerIn: imageContainer
                    source: "qrc:/Image/Res/PlayMusic/Image/9.png"
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    asynchronous: true
                    visible: false

                    // 加载中指示
                    Rectangle {
                        anchors.fill: parent
                        color: "#42424b"
                        radius: parent.width / 2
                        visible: albumImage.status !== Image.Ready

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
                    source: albumImage
                    maskSource: mask
                }
            }
        }

        // 右侧内容：歌名和控制图标
        ColumnLayout {
            Layout.fillWidth: false
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 10

            // 上部分：歌名和歌手文本
            Text {
                id: songTitleText
                text: "记忆中神圣的你(神圣)"  // 可动态绑定
                color: "white"
                font.pixelSize: 16
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                Layout.fillWidth: false
                Layout.topMargin: 5
            }

            Text {
                id: artistText
                text: "Takuau"  // 歌手名称，可动态绑定
                color: "#aaaaaa"
                font.pixelSize: 12
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                Layout.fillWidth: false
            }

            // 下部分：四个横向图标
            RowLayout {
                Layout.alignment: Qt.AlignBottom
                spacing: 20

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/Print.png"  // 占位：上一首
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/play.png"  // 占位：播放/暂停
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/Download.png"  // 占位：下一首
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/Share.png"  // 占位：菜单/更多
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }
            }
        }

        // 中间部分：进度条
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 5

            // 上方5个图标，横向排列，居中
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 15

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/shoucang.png"
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/back.png"
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/play.png"
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/back.png"
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                    rotation: 180;
                }

                Image {
                    source: "qrc:/Image/Res/PlayMusic/Image/chexiao.png"
                    sourceSize: Qt.size(16,16)
                    width: 16
                    height: 16
                    fillMode: Image.Stretch
                    smooth: false
                }
            }

            // 进度条和时间
            RowLayout {
                id: idSliderRouLayout;
                Layout.preferredWidth: 550
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Text {
                    id: currentTime
                    text: "0:00"
                    color: "white"
                    font.pixelSize: 12
                    Layout.preferredWidth: 40
                }

                Slider {
                    id: progressSlider
                    Layout.preferredWidth: 450
                    from: 0
                    to: 100
                    value: 0
                    orientation: Qt.Horizontal
                }

                Text {
                    id: totalTime
                    text: "3:30"
                    color: "white"
                    font.pixelSize: 12
                    Layout.preferredWidth: 40
                    horizontalAlignment: Text.AlignRight
                }

            }

          }

        // 右侧内容：6个小部件（2文本 + 4图标）
        RowLayout {
            Layout.preferredWidth: 160
            Layout.alignment: Qt.AlignVCenter
            spacing: 5

            Text {
                id: qualityText
                text: "极高"
                color: "white"
                font.pixelSize: 14
                font.family: "Arial"
                horizontalAlignment: Text.AlignRight
            }

            Text {
                id: lyricsText
                text: "词"
                color: "#aaaaaa"
                font.pixelSize: 12
                font.family: "Arial"
                horizontalAlignment: Text.AlignRight
            }

            Image {
                source: "qrc:/Image/Res/PlayMusic/Image/menu.png"
                sourceSize: Qt.size(16,16)
                width: 16
                height: 16
                fillMode: Image.Stretch
                smooth: false
            }

            Image {
                source: "qrc:/Image/Res/PlayMusic/Image/woniu.png"
                sourceSize: Qt.size(16,16)
                width: 16
                height: 16
                fillMode: Image.Stretch
                smooth: false
            }

            Image {
                source: "qrc:/Image/Res/PlayMusic/Image/voice.png"
                sourceSize: Qt.size(16,16)
                width: 16
                height: 16
                fillMode: Image.Stretch
                smooth: false
            }

            Image {
                source: "qrc:/Image/Res/PlayMusic/Image/qun.png"
                sourceSize: Qt.size(16,16)
                width: 16
                height: 16
                fillMode: Image.Stretch
                smooth: false
            }

        }


    }


}
