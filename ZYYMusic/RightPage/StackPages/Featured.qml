import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../Basic"
import "./SubFeatured"

Item {
    id: root


    Flickable {        id: flickable
        anchors.fill: parent
        contentHeight: 1500  // 增加以容纳新布局
        clip: true
        ScrollBar.vertical: ScrollBar {
            // anchors.right: parent.right
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
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // 轮播图部分
            Carousel {
                width: parent.width
                height: 300
            }

            // 官方歌单部分
            OfficialPlaylist {
                width: parent.width
                property var playlistData: [
                    { name: "流行热曲精选", desc: "当下最火的流行单曲集合，让你随时跟上潮流节奏。不论是热门榜单上的新歌，还是社交平台刷屏的旋律，这里都有，让你每一次播放都充满青春活力与动感节拍。" },
                    { name: "经典老歌回忆", desc: "跨越岁月的经典旋律，每一首都是回忆的味道。从怀旧的老歌到永不过时的经典旋律，每一次聆听都像翻开时光的相册，唤醒心底温暖的记忆。" },
                    { name: "轻松午后", desc: "轻音乐与柔和旋律，陪伴你的慵懒午后时光。无论是办公间隙还是周末休憩，这些舒缓的旋律都能带来片刻宁静，让你在忙碌中找到轻松与舒适。" },
                    { name: "夜晚电音派对", desc: "电音节拍轰炸，让夜晚充满能量与激情。无论是在舞池中释放自我，还是在耳机里尽情享受动感节奏，这里都是让夜晚不眠的音乐盛宴，点燃你的每一个夜晚。" }
                ]
                property var imageSources: [
                    "qrc:/Image/Res/PlayMusic/Image/8.png",
                    "qrc:/Image/Res/PlayMusic/Image/9.png",
                    "qrc:/Image/Res/PlayMusic/Image/10.png",
                    "qrc:/Image/Res/PlayMusic/Image/11.png"
                ]
            }

            // 最新音乐部分
            LatestMusic {
                width: parent.width
                strTitle: "最新音乐>"
                property var songData: [
                    { name: "夏天的风", artist: "歌手A", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
                    { name: "永恒的记忆", artist: "歌手B", image: "qrc:/Image/Res/PlayMusic/Image/9.png" },
                    { name: "午后咖啡", artist: "歌手C", image: "qrc:/Image/Res/PlayMusic/Image/10.png" },
                    { name: "夜色电音", artist: "歌手D", image: "qrc:/Image/Res/PlayMusic/Image/11.png" },
                    { name: "摇滚之夜", artist: "歌手E", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
                    { name: "独立之声", artist: "歌手F", image: "qrc:/Image/Res/PlayMusic/Image/9.png" }
                ]
            }

            // 热门博客
            LatestMusic {
                width: parent.width
                strTitle: "热门播客>"
                property var songData: [
                    { name: "夏日旅行记", artist: "播客作者A", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
                    { name: "永恒的回忆录", artist: "播客作者B", image: "qrc:/Image/Res/PlayMusic/Image/9.png" },
                    { name: "午后咖啡时光", artist: "播客作者C", image: "qrc:/Image/Res/PlayMusic/Image/10.png" },
                    { name: "夜色下的思考", artist: "播客作者D", image: "qrc:/Image/Res/PlayMusic/Image/11.png" },
                    { name: "摇滚与生活", artist: "播客作者E", image: "qrc:/Image/Res/PlayMusic/Image/8.png" },
                    { name: "独立思考笔记", artist: "播客作者F", image: "qrc:/Image/Res/PlayMusic/Image/9.png" }
                ]
            }

        }
    }
}
