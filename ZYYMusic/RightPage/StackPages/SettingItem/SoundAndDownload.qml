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
    height: 300;

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

        Label
        {

        }
    }
}
