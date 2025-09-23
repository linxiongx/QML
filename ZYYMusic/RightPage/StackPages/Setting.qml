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
                            // 滚动到对应 section
                            var targetY = 0;
                            switch(index) {
                                case 0: targetY = accountSection.y - 30; break;
                                case 1: targetY = generalSection.y - 30; break;
                                case 2: targetY = systemSection.y - 30; break;
                                case 3: targetY = playSection.y - 30; break;
                                case 4: targetY = messagingSection.y - 30; break;
                                case 5: targetY = shortcutSection.y - 30; break;
                                case 6: targetY = soundSection.y - 30; break;
                                case 7: targetY = desktopSection.y - 30; break;
                                case 8: targetY = toolSection.y - 30; break;
                                case 9: targetY = aboutSection.y - 30; break;
                            }
                            idFlick.contentY = Math.max(0, targetY);
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
            property real threshold0: accountSection.y + accountSection.height + 31; // 进入常规，+spacing+divider
            property real threshold1: generalSection.y + generalSection.height + 31; // 进入系统
            property real threshold2: systemSection.y + systemSection.height + 31; // 进入播放
            property real threshold3: playSection.y + playSection.height + 31; // 进入消息
            property real threshold4: messagingSection.y + messagingSection.height + 31; // 进入快捷键
            property real threshold5: shortcutSection.y + shortcutSection.height + 31; // 进入音质
            property real threshold6: soundSection.y + soundSection.height + 31; // 进入桌面
            property real threshold7: desktopSection.y + desktopSection.height + 31; // 进入工具
            property real threshold8: toolSection.y + toolSection.height + 31; // 进入关于
            property real threshold9: aboutSection.y + aboutSection.height + 1000; // 末尾，确保关于高亮

            onContentYChanged: {
                if (contentY < threshold0) {
                    idSelectorRep.selectedIndex = 0;
                } else if (contentY < threshold1) {
                    idSelectorRep.selectedIndex = 1;
                } else if (contentY < threshold2) {
                    idSelectorRep.selectedIndex = 2;
                } else if (contentY < threshold3) {
                    idSelectorRep.selectedIndex = 3;
                } else if (contentY < threshold4) {
                    idSelectorRep.selectedIndex = 4;
                } else if (contentY < threshold5) {
                    idSelectorRep.selectedIndex = 5;
                } else if (contentY < threshold6) {
                    idSelectorRep.selectedIndex = 6;
                } else if (contentY < threshold7) {
                    idSelectorRep.selectedIndex = 7;
                } else if (contentY < threshold8) {
                    idSelectorRep.selectedIndex = 8;
                } else if (contentY < threshold9) {
                    idSelectorRep.selectedIndex = 9;
                } else {
                    idSelectorRep.selectedIndex = 9;
                }
            }
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: idCutLine01.bottom;
            anchors.topMargin: 10;
            anchors.bottom: parent.bottom;
            contentHeight: 6000;
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
                Counter {
                    id: accountSection
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
                Standard {
                    id: generalSection
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
                SystemConfig {
                    id: systemSection
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
                Play {
                    id: playSection
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
                MessagingPrivacy {
                    id: messagingSection
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
                ShortCut {
                    id: shortcutSection
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
                SoundAndDownload {
                    id: soundSection
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
                DesktopLyrics {
                    id: desktopSection
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 800;
                }

                // 工具占位
                Item {
                    id: toolSection
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 400;
                    Rectangle {
                        anchors.fill: parent;
                        color: "transparent";
                        Text {
                            anchors.centerIn: parent;
                            text: "工具设置（待实现）";
                            color: "white";
                            font.pixelSize: 20;
                        }
                    }
                }

                // 分割线
                Rectangle {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 1;
                    color: "#212127";
                }

                // 关于网易云音乐占位
                Item {
                    id: aboutSection
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 400;
                    Rectangle {
                        anchors.fill: parent;
                        color: "transparent";
                        Text {
                            anchors.centerIn: parent;
                            text: "关于网易云音乐（待实现）";
                            color: "white";
                            font.pixelSize: 20;
                        }
                    }
                }

              }
        }
    }
}


