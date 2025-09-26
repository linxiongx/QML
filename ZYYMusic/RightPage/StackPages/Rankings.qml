import QtQuick 2.15
import QtQuick.Controls 2.15
import "../../Basic"

Item {
    // 整体淡入动画
    opacity: 0
    NumberAnimation on opacity {
        from: 0; to: 1
        duration: 500
        easing.type: Easing.OutCubic
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: 1000  // 初始值，将根据内容调整
        clip: true
        boundsBehavior: Flickable.StopAtBounds

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

        // 静态榜单数据模型
        ListModel {
            id: rankingsModel
            ListElement { name: "新歌榜"; desc: "最新热门新歌"; image: "qrc:/Image/Res/PlayMusic/Image/8.png"; songs: [
                ListElement { rank: 1; song: "稻香"; artist: "周杰伦"; album: "魔杰座"; duration: "04:12" },
                ListElement { rank: 2; song: "青花瓷"; artist: "周杰伦"; album: "我很忙"; duration: "03:56" },
                ListElement { rank: 3; song: "夜空中最亮的星"; artist: "逃跑计划"; album: "时间的针"; duration: "05:02" },
                ListElement { rank: 4; song: "晴天"; artist: "周杰伦"; album: "叶惠美"; duration: "03:45" },
                ListElement { rank: 5; song: "简单爱"; artist: "周杰伦"; album: "范特西"; duration: "04:18" },
                ListElement { rank: 6; song: "开不了口"; artist: "周杰伦"; album: "范特西"; duration: "04:01" },
                ListElement { rank: 7; song: "七里香"; artist: "周杰伦"; album: "七月的肖邦"; duration: "05:19" },
                ListElement { rank: 8; song: "以父之名"; artist: "周杰伦"; album: "叶惠美"; duration: "04:35" },
                ListElement { rank: 9; song: "东风破"; artist: "周杰伦"; album: "叶惠美"; duration: "04:41" },
                ListElement { rank: 10; song: "牛仔很忙"; artist: "周杰伦"; album: "我很忙"; duration: "03:45" }
            ] }
            ListElement { name: "热歌榜"; desc: "实时热度歌曲"; image: "qrc:/Image/Res/PlayMusic/Image/9.png"; songs: [
                ListElement { rank: 1; song: "光辉岁月"; artist: "Beyond"; album: "乐与怒"; duration: "05:07" },
                ListElement { rank: 2; song: "海阔天空"; artist: "Beyond"; album: "乐与怒"; duration: "05:30" },
                ListElement { rank: 3; song: "朋友"; artist: "周华健"; album: "朋友"; duration: "04:31" },
                ListElement { rank: 4; song: "大约在冬季"; artist: "齐秦"; album: "Postmodern"; duration: "04:45" },
                ListElement { rank: 5; song: "外面的世界"; artist: "齐秦"; album: "外面的世界"; duration: "04:26" },
                ListElement { rank: 6; song: "涛声依旧"; artist: "齐秦"; album: "外面的世界"; duration: "04:38" },
                ListElement { rank: 7; song: "每一次的相遇"; artist: "齐秦"; album: "客家心"; duration: "04:20" },
                ListElement { rank: 8; song: "千千阙歌"; artist: "陈慧娴"; album: "千千阙歌"; duration: "04:08" },
                ListElement { rank: 9; song: "容易受伤的女人"; artist: "张艾嘉"; album: "容易受伤的女人"; duration: "04:17" },
                ListElement { rank: 10; song: "来生缘"; artist: "曾再庭"; album: "来生缘"; duration: "04:02" }
            ] }
            ListElement { name: "摇滚榜"; desc: "摇滚经典"; image: "qrc:/Image/Res/PlayMusic/Image/10.png"; songs: [
                ListElement { rank: 1; song: "一无所有"; artist: "崔健"; album: "新长征路上的摇滚"; duration: "04:25" },
                ListElement { rank: 2; song: "花房姑娘"; artist: "崔健"; album: "新长征路上的摇滚"; duration: "02:46" },
                ListElement { rank: 3; song: "假行僧"; artist: "崔健"; album: "新长征路上的摇滚"; duration: "05:26" },
                ListElement { rank: 4; song: "不肯睡觉"; artist: "何勇"; album: "垃圾场"; duration: "04:00" },
                ListElement { rank: 5; song: "风铃草"; artist: "唐朝乐队"; album: "梦回唐朝"; duration: "04:45" },
                ListElement { rank: 6; song: "玉米"; artist: "唐朝乐队"; album: "梦回唐朝"; duration: "05:30" },
                ListElement { rank: 7; song: "梦中的梦"; artist: "唐朝乐队"; album: "梦回唐朝"; duration: "05:15" },
                ListElement { rank: 8; song: "太阳底下无新事"; artist: "黑豹乐队"; album: "黑豹"; duration: "04:20" },
                ListElement { rank: 9; song: "无地自容"; artist: "黑豹乐队"; album: "黑豹"; duration: "04:10" },
                ListElement { rank: 10; song: "别样爱情"; artist: "黑豹乐队"; album: "黑豹"; duration: "04:35" }
            ] }
            ListElement { name: "流行榜"; desc: "流行金曲"; image: "qrc:/Image/Res/PlayMusic/Image/11.png"; songs: [
                ListElement { rank: 1; song: "月亮代表我的心"; artist: "邓丽君"; album: "淡淡幽情"; duration: "04:28" },
                ListElement { rank: 2; song: "甜蜜蜜"; artist: "邓丽君"; album: "甜蜜蜜"; duration: "03:29" },
                ListElement { rank: 3; song: "小城故事"; artist: "叶丽仪"; album: "爱在深秋"; duration: "03:48" },
                ListElement { rank: 4; song: "千言万语"; artist: "张国荣"; album: "风继续吹"; duration: "04:03" },
                ListElement { rank: 5; song: "风继续吹"; artist: "张国荣"; album: "风继续吹"; duration: "04:41" },
                ListElement { rank: 6; song: "Monica"; artist: "张国荣"; album: "风继续吹"; duration: "03:45" },
                ListElement { rank: 7; song: "当年情"; artist: "徐小凤"; album: "当年情"; duration: "03:15" },
                ListElement { rank: 8; song: "风的季节"; artist: "罗大佑"; album: "恋曲1980"; duration: "04:58" },
                ListElement { rank: 9; song: "恋曲1980"; artist: "罗大佑"; album: "恋曲1980"; duration: "03:30" },
                ListElement { rank: 10; song: "之乎者也"; artist: "罗大佑"; album: "恋曲1980"; duration: "04:12" }
            ] }
            ListElement { name: "云涨榜"; desc: "新兴音乐"; image: "qrc:/Image/Res/PlayMusic/Image/8.png"; songs: [
                ListElement { rank: 1; song: "华裳"; artist: "阿信"; album: "华裳"; duration: "03:45" },
                ListElement { rank: 2; song: "纸短情长"; artist: "烟圆"; album: "纸短情长"; duration: "04:20" },
                ListElement { rank: 3; song: "稻香"; artist: "周杰伦"; album: "魔杰座"; duration: "04:12" },
                ListElement { rank: 4; song: "突然的自我"; artist: "苏打绿"; album: "十年一刻"; duration: "04:30" },
                ListElement { rank: 5; song: "小情歌"; artist: "苏打绿"; album: "小情歌"; duration: "03:55" },
                ListElement { rank: 6; song: "再重逢"; artist: "孙燕姿"; album: "天黑黑"; duration: "03:28" },
                ListElement { rank: 7; song: "我要的幸福"; artist: "孙燕姿"; album: "我要的幸福"; duration: "03:40" },
                ListElement { rank: 8; song: "开始懂了"; artist: "孙燕姿"; album: "开始懂了"; duration: "03:50" },
                ListElement { rank: 9; song: "天黑黑"; artist: "孙燕姿"; album: "天黑黑"; duration: "04:15" },
                ListElement { rank: 10; song: "我要的幸福"; artist: "孙燕姿"; album: "我要的幸福"; duration: "03:40" }
            ] }
            ListElement { name: "自定义榜"; desc: "用户自定义"; image: "qrc:/Image/Res/PlayMusic/Image/9.png"; songs: [
                ListElement { rank: 1; song: "自定义1"; artist: "自定义歌手A"; album: "自定义专辑A"; duration: "04:00" },
                ListElement { rank: 2; song: "自定义2"; artist: "自定义歌手B"; album: "自定义专辑B"; duration: "03:30" },
                ListElement { rank: 3; song: "自定义3"; artist: "自定义歌手C"; album: "自定义专辑C"; duration: "04:10" },
                ListElement { rank: 4; song: "自定义4"; artist: "自定义歌手D"; album: "自定义专辑D"; duration: "03:50" },
                ListElement { rank: 5; song: "自定义5"; artist: "自定义歌手E"; album: "自定义专辑E"; duration: "04:20" },
                ListElement { rank: 6; song: "自定义6"; artist: "自定义歌手F"; album: "自定义专辑F"; duration: "03:40" },
                ListElement { rank: 7; song: "自定义7"; artist: "自定义歌手G"; album: "自定义专辑G"; duration: "04:05" },
                ListElement { rank: 8; song: "自定义8"; artist: "自定义歌手H"; album: "自定义专辑H"; duration: "03:55" },
                ListElement { rank: 9; song: "自定义9"; artist: "自定义歌手I"; album: "自定义专辑I"; duration: "04:15" },
                ListElement { rank: 10; song: "自定义10"; artist: "自定义歌手J"; album: "自定义专辑J"; duration: "03:45" }
            ] }
        }

        function updateHeight() {
            var maxY = 0;
            for (var i = 0; i < rankingsFlow.children.length; i++) {
                var item = rankingsFlow.children[i];
                if (item && item.height !== undefined) {
                    maxY = Math.max(maxY, item.y + item.height);
                }
            }
            flickable.contentHeight = maxY + 50;
        }

        // 榜单卡片布局 - 使用Flow实现水平并行排列
        Flow {
            id: rankingsFlow
            anchors.fill: parent
            anchors.margins: 10
            spacing: 20

            Repeater {
                model: rankingsModel
                delegate: Item {
                    id: cardItem
                    width: 220
                    height: 300
                    property int currentIndex: index
                    property bool hovered: false

                    // 动态调整contentHeight
                    onHeightChanged: {
                        Qt.callLater(flickable.updateHeight);
                    }

                    Rectangle {
                        id: card
                        anchors.fill: parent
                        color: BasicConfig.backgroundColor
                        radius: 10
                        border.color: "gray"
                        border.width: 1

                        // 封面图片
                        Image {
                            id: cardImage
                            anchors.top: parent.top
                            anchors.topMargin: 5
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 200
                            height: 200
                            source: model.image || ""
                            fillMode: Image.PreserveAspectCrop
                            opacity: 1.0

                            Behavior on opacity {
                                NumberAnimation { duration: 200 }
                            }
                        }

                        // 名称
                        Text {
                            id: nameText
                            anchors.top: cardImage.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 10
                            text: model.name || ""
                            color: "#d9d9da"
                            font.bold: true
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }

                        // 描述
                        Text {
                            id: descText
                            anchors.top: nameText.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 10
                            anchors.topMargin: 5
                            text: model.desc || ""
                            color: "gray"
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }

                        // 悬停遮罩层
                        Rectangle {
                            id: hoverOverlay
                            anchors.fill: parent
                            radius: 10
                            color: cardItem.hovered ? Qt.rgba(0, 0, 0, 0.3) : "transparent"

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }

                            // 播放按钮
                            Image {
                                anchors.centerIn: parent
                                width: 50
                                height: 50
                                source: "qrc:/Image/Res/PlayMusic/Image/play.png"
                                visible: cardItem.hovered
                                opacity: 0.9

                                Behavior on opacity {
                                    NumberAnimation { duration: 200 }
                                }
                            }

                            // Tooltip 前首歌，限制在封面内
                            Rectangle {
                                id: tooltip
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.topMargin: 25
                                width: 170
                                height: 170
                                visible: cardItem.hovered
                                color: "transparent"
                                radius: 8
                                clip: true

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 2

                                    Repeater {
                                        model: {
                                            if (rankingsModel && cardItem.currentIndex >= 0 && cardItem.currentIndex < rankingsModel.count) {
                                                var item = rankingsModel.get(cardItem.currentIndex);
                                                if (item && item.songs) {
                                                    var availableHeight = cardImage.height - 40;  // 减去边距
                                                    var songHeight = 18;  // 每首歌高度估算
                                                    var maxCount = Math.floor(availableHeight / songHeight);
                                                    maxCount = Math.min(maxCount, item.songs.count);
                                                    var topSongs = [];
                                                    for (var i = 0; i < maxCount; i++) {
                                                        topSongs.push(item.songs.get(i));
                                                    }
                                                    return topSongs;
                                                }
                                            }
                                            return [];
                                        }

                                        delegate: Text {
                                            width: parent.width
                                            text: modelData ? ("#" + modelData.rank + " " + modelData.song + " - " + modelData.artist) : ""
                                            color: "black"
                                            font.pixelSize: 13
                                            elide: Text.ElideRight
                                        }
                                    }
                                }

                                Behavior on opacity {
                                    NumberAnimation { duration: 200 }
                                }
                            }
                        }

                        // 鼠标控制
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                cardItem.hovered = true;
                                cardImage.opacity = 0.5;
                            }
                            onExited: {
                                cardItem.hovered = false;
                                cardImage.opacity = 1.0;
                            }

                            // 点击事件
                            onClicked: {
                                var stackView = cardItem.parent.parent.parent.idMainStackView;
                                if (stackView && rankingsModel && cardItem.currentIndex >= 0 && cardItem.currentIndex < rankingsModel.count) {
                                    var detail = rankingsModel.get(cardItem.currentIndex);
                                    stackView.push("qrc:/qt/qml/ZYYMusic/RightPage/StackPages/RankDetail.qml", {detailModel: detail});
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
