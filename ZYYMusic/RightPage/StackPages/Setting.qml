import QtQuick
import QtQuick.Controls
import "../../Basic"
import "../../CommonUI"
import "./SettingItem"
import QtQuick.Dialogs

//这个Item是等于 StackView窗口
Item
{
    //因此需要再加这个 Item
    Item
    {
        anchors.fill: parent;
        anchors.topMargin: 24;
        anchors.leftMargin: 24;

        Label
        {
            id: idSettingMainTitle;
            color: "white";
            font.bold: true;
            text: "设置";
            font.pixelSize: 32;
            font.family: BasicConfig.commFont;
            anchors.left: parent.left;
            anchors.top: parent.top;
        }

        Flow
        {
            id: idSettingsTitleFlow;
            anchors.left: idSettingMainTitle.left;
            anchors.top: idSettingMainTitle.bottom;
            anchors.topMargin: 25;
            height: 25;
            spacing: 20;
            Repeater
            {
                id: idSelectorRep;
                anchors.fill: parent
                model: ["账号", "常规", "系统", "播放", "消息与隐私", "快捷键", "音质与下载", "桌面歌词", "工具", "关于网易云音乐"];
                property int selectedIndex: 0;
                Item
                {
                    height: 40;
                    width: idSelectorLabel.implicitWidth
                    property bool isHovered: false
                    Label
                    {
                        id: idSelectorLabel;
                        text: modelData;
                        font.pixelSize: 20;
                        font.bold: true;
                        font.family: "黑体";

                        color:
                        {
                            if (idSelectorRep.selectedIndex === index)
                            {
                                return "white";
                            }
                            else if (parent.isHovered)
                            {
                                return "#b9b9ba";
                            }
                            else
                            {
                                return "#a1a1a3";
                            }
                        }
                        anchors.centerIn: parent;
                    }
                    Rectangle
                    {
                        visible: idSelectorRep.selectedIndex === index;
                        anchors.left: idSelectorLabel.left;
                        anchors.right: idSelectorLabel.right;
                        anchors.top: idSelectorLabel.bottom;
                        anchors.leftMargin: idSelectorLabel.implicitWidth / idSelectorLabel.font.pixelSize * 2;
                        anchors.rightMargin: idSelectorLabel.implicitWidth / idSelectorLabel.font.pixelSize * 2;
                        anchors.topMargin: 3;
                        height: 3;
                        color: "#eb4d44"
                    }

                    MouseArea
                    {
                        anchors.fill: parent;
                        hoverEnabled: true;

                        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor;
                        onEntered:
                        {
                            parent.isHovered = true;
                        }
                        onExited:
                        {
                            parent.isHovered = false;
                        }
                        onClicked:
                        {
                            idSelectorRep.selectedIndex = index;
                        }
                    }
                }
            }
        }

        //分割线
        Rectangle
        {
            id: idCutLine01;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: idSettingsTitleFlow.bottom;
            anchors.topMargin: 20;
           // anchors.rightMargin: window.width:
            height: 1;
            color: "#212127"
        }

        Flickable
        {
            id: idFlick;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: idCutLine01.bottom;
            anchors.topMargin: 10;
            anchors.bottom: parent.bottom;
            contentHeight: 4800;
            clip: true;
            ScrollBar.vertical: ScrollBar
            {
                anchors.right: parent.right;
                anchors.rightMargin: 5;
                width: 10;
                contentItem: Rectangle
                {
                    visible: parent.active;
                    implicitWidth: 10;
                    radius: 4;
                    color: "#42424b"
                }
            }

            Column
            {
                anchors.fill: parent;
                anchors.topMargin: 30;
                spacing: 30;
                //账号
                Counter
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }

                //常规
                Standard
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }

                //系统
                SystemConfig
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }

                //播放
                Play
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }

                //消息与隐私
                MessagingPrivacy
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }

                //快捷键
                ShortCut
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }


                //音质与下载
                SoundAndDownload
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                }

                //分割线
                Rectangle
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127"
                }

                //桌面歌词
                DesktopLyrics
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 800;
                }

              }
        }
    }
}


