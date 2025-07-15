import QtQuick
import QtQuick.Controls
import Qt.labs.platform
//import QtCore
import "../../../Basic"
import "../../../CommonUI"

Item
{
    anchors.left: parent.left;
    anchors.right: parent.right;
    height: 520;

    Label
    {
        id: idDownloadTitleLabel;
        anchors.left: parent.left;
        anchors.top: parent.top;
        text: "音质与下载";
        font.pixelSize:  22;
        font.family: "黑体";
        font.bold: true;
        color: "white";
    }

    Column
    {
        id: idMainColumn
        anchors.left: idDownloadTitleLabel.right;
        anchors.leftMargin: 75;
        anchors.top: idDownloadTitleLabel.top;
        width: 200;
        spacing: 20;

        Repeater
        {
            model: ListModel
            {
                ListElement{titleName: "音质播放设置"}
                ListElement{titleName: "音质下载设置"}
            }
            delegate: Item
            {
                id: idDownloadRepItem;
                width: 200;
                height: idDowloadGrip.implicitHeight;

                ButtonGroup
                {
                    id: idDownloadBtnGroup;
                }

                Label
                {
                    id: idDownloadLabel

                    text: titleName;
                    font.family: "黑体";
                    font.pixelSize: 22;
                    color: "white";
                }

                Grid
                {
                    id: idDowloadGrip
                    anchors.left: idDownloadLabel.right;
                    anchors.leftMargin: 20;
                    rows: 3;
                    columns: 3;
                    spacing: 10;

                    Repeater
                    {

                        model: ListModel
                        {
                            ListElement{name:"沉浸环绕声"; isSvp: true; isVip: false}
                            ListElement{name:"超声母带"; isSvp: true; isVip: false}
                            ListElement{name:"高清臻音"; isSvp: false; isVip: true}
                            ListElement{name:"高解析度无损"; isSvp: false; isVip: true}
                            ListElement{name:"无损"; isSvp: false; isVip: true}
                            ListElement{name:"极高"; isSvp: false; isVip: false}
                            ListElement{name:"标准"; isSvp: false; isVip: false}
                        }
                        delegate: Item
                        {
                            anchors.leftMargin: 10;
                            implicitWidth: 200;
                            height: 20;

                            ZYYRadioButton
                             {
                                 id: idRadiobutton1
                                 width: implicitWidth;
                                 height: parent.height;
                                 text: name
                                 ButtonGroup.group: idDownloadBtnGroup;
                             }

                             //Svp
                             Item
                             {
                                 id: idSvpItem;
                                 visible: isSvp;
                                 anchors.left: idRadiobutton1.right;
                                 anchors.top: idRadiobutton1.top;
                                 anchors.bottom: idRadiobutton1.bottom;
                                 width: 100;

                                 Rectangle
                                 {
                                     anchors.verticalCenter: parent.verticalCenter;
                                     anchors.left: parent.left;
                                     height: 16;
                                     width: idSvpRoundText.implicitWidth + 5;
                                     color: "#37363a"
                                     radius: height;
                                     Text
                                     {
                                         id: idSvpRoundText
                                         text: "SVP";
                                         verticalAlignment: Text.AlignVCenter;
                                         font.pixelSize: 12;
                                         leftPadding: 18;
                                         color: "#b3b3b3"
                                     }
                                 }

                                 Rectangle
                                 {
                                     anchors.verticalCenter: parent.verticalCenter;
                                     anchors.left: parent.left;
                                     height: 16;
                                     width: height;
                                     radius: height;
                                     color: "#eed18d";

                                     Rectangle
                                     {
                                         anchors.centerIn: parent;
                                         height: parent.height / 2;
                                         width: height;
                                         radius: height;
                                         color: "#c1a25e";
                                     }
                                 }
                             }

                             //Vip
                             Item
                             {
                                 id: idVipItem;
                                 visible: isVip;
                                 anchors.left: idRadiobutton1.right;
                                 anchors.top: idRadiobutton1.top;
                                 anchors.bottom: idRadiobutton1.bottom;
                                 width: 100;

                                 Rectangle
                                 {
                                     anchors.verticalCenter: parent.verticalCenter;
                                     anchors.left: parent.left;
                                     height: 16;
                                     width: idVipRoundText.implicitWidth + 5;
                                     color: "#242424"
                                     radius: height;
                                     Text
                                     {
                                         id: idVipRoundText
                                         text: "VIP";
                                         verticalAlignment: Text.AlignVCenter;
                                         font.pixelSize: 12;
                                         leftPadding: 18;
                                         color: "#b3b3b3"
                                     }
                                 }

                                 Rectangle
                                 {
                                     anchors.verticalCenter: parent.verticalCenter;
                                     anchors.left: parent.left;
                                     height: 16;
                                     width: height;
                                     radius: height;
                                     color: "#4B4B4B";

                                     Rectangle
                                     {
                                         anchors.centerIn: parent;
                                         height: parent.height / 2;
                                         width: height;
                                         radius: height;
                                         color: "#cd776c";
                                     }
                                 }
                             }
                        }
                    }
                }
            }
        }

        Label
        {
             anchors.left: parent.left;
             text: "了解音质>"
             font.pixelSize:  20;
             font.family: "黑体";
             color: "#647bb8"

             MouseArea
             {
                 anchors.fill: parent;
                 hoverEnabled: true;
                 onEntered:
                 {
                      cursorShape = Qt.PointingHandCursor;
                 }
                 onExited:
                 {
                     cursorShape = Qt.ArrowCursor;
                 }
                 onClicked:
                 {
                     Qt.openUrlExternally("https://www.baidu.com");
                 }
             }
        }

        ZYYDowloadFolderDialog
        {
            anchors.left: parent.left;
            width: parent.width;
            isDowload: true;
        }

        ZYYDowloadFolderDialog
        {
            anchors.left: parent.left;
            width: parent.width;
            isDowload: false;
        }

        Row
        {
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 20;
            Label
            {
                id: idMaxMemoryLabel;
                text: "缓存最大占用"
                font.pixelSize: 20;
                font.family: "黑体";
                color: "#ddd";
            }
            Slider
            {
                id: idMaxMemorySlider;
                value: 1;
                from: 1;
                to:10;
                width: 300;
                height: 14;
                anchors.verticalCenter: idMaxMemoryLabel.verticalCenter;
                background: Rectangle
                {
                    // 整个滑槽宽度
                    x: 0
                    y: parent.height / 2 - 2
                    width: parent.width
                    height: 4
                    radius: 2
                    color: "#2b2b30"  // 👉 滑槽背景颜色

                    Rectangle
                    {
                        width: parent.width * idMaxMemorySlider.position  // 根据滑块位置设置长度
                        height: parent.height
                        radius: 2;
                        color: "#eb4d44"   // 👉 已滑过部分颜色（填充）
                    }
                }
                handle: Rectangle
                {
                    x: 0 + parent.width * idMaxMemorySlider.position;
                    height: parent.height;
                    width: height;
                    radius: height;
                    color: "white";
                }
            }
            Text
            {
                text: parseInt(idMaxMemorySlider.value) + " G";
                font.pixelSize: 20;
                font.family: "黑体";
                color: "white";
            }
            Rectangle
            {
                id: idMaxMemoryRect;
                width: 100;
                height: 30;
                radius: 15;
                anchors.verticalCenter: idMaxMemoryLabel.verticalCenter;
                color: "transparent";
                border.width: 1;
                border.color: "#222";
                Label
                {
                    anchors.centerIn: parent;
                    text: "清除缓存";
                    font.pixelSize: 20;
                    font.family: "黑体";
                    color: "white";
                }
                MouseArea
                {
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onEntered:
                    {
                        cursorShape = Qt.PointingHandCursor;
                        idMaxMemoryRect.color = "#222";
                    }
                    onExited:
                    {
                        cursorShape = Qt.ArrowCursor;
                        idMaxMemoryRect.color = "transparent";
                    }
                }
            }
        }

        Column
        {
            anchors.left: parent.left;
            width: parent.width;
            spacing: 8;
            Repeater
            {
                model: ListModel
                {
                    ListElement{ name1:"音乐命名格式"; name2: "歌曲名"; name3: "歌曲-歌手名"; name4: "歌曲名-歌手"}
                    ListElement{ name1: "文件智能分类"; name2: "不分文件夹"; name3: "按歌手分文件夹"; name4: "按歌手/专辑分文件夹"}
                }
                delegate: Row
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    spacing: 10;

                    Label
                    {
                        anchors.verticalCenter: parent.verticalCenter;
                        text: name1;
                        color: "white";
                        font.family: "黑体";
                        font.pixelSize: 18;
                    }

                    ZYYRadioButton
                    {
                        text: name2;
                        width: 150;
                    }
                    ZYYRadioButton
                    {
                        text: name3;
                        width: 150;
                    }
                    ZYYRadioButton
                    {
                        text: name4;
                        width: 150;
                    }

                }
            }
        }
    }
}
