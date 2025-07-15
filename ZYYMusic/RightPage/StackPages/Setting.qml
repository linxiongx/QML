import QtQuick
import QtQuick.Controls
import "../../Basic"
import "../../CommonUI"
import "./SettingItem"

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
                Item
                {
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    height: 800;

                    Label
                    {
                        id: idDestopLyricsLabel;
                        anchors.left: parent.left;
                        anchors.top: parent.top;
                        verticalAlignment: Text.AlignVCenter
                        text: "桌面歌词";
                        font.pixelSize:  22;
                        font.family: "黑体";
                        font.bold: true;
                        color: "white";
                    }

                    Column
                    {
                        anchors.left: idDestopLyricsLabel.right;
                        anchors.leftMargin: 70;
                        anchors.right: parent.right;
                        anchors.top: idDestopLyricsLabel.top;
                        spacing: 30;

                        Row
                        {
                            anchors.left: parent.left;
                            anchors.right: parent.right;
                            spacing: 10;

                            ZYYCheckBox
                            {
                                text: "启用桌面歌词"
                                checked: true;
                            }
                            ZYYCheckBox
                            {
                                text: "启用歌词总在最前"
                                checked: true;
                            }
                            ZYYCheckBox
                            {
                                text: "外文歌曲显示翻译"
                                checked: true;
                            }
                            ZYYCheckBox
                            {
                                text: "外文歌词显示音译"
                            }
                        }

                        Row
                        {

                            anchors.left: parent.left;
                            anchors.right: parent.right;
                            spacing: 70;

                            Repeater
                            {

                                model: ListModel
                                {
                                    id: idListModel;
                                    ListElement{name: "字体";}
                                    ListElement{name: "字号";}
                                    ListElement{name: "字粗";}
                                    ListElement{name: "描边";}
                                }

                                delegate: Item
                                {
                                    width: 100;
                                    height: idLabel.implicitHeight + 25 + 10
                                    Label
                                    {
                                        anchors.left: parent.left;
                                        anchors.leftMargin: 10;
                                        anchors.top: parent.top;
                                        id: idLabel;
                                        text: name;
                                        font.family: "黑体"
                                        font.pixelSize: 18;
                                        color: "white";
                                    }
                                    ZYYComboBox
                                    {
                                        anchors.left: parent.left;
                                        anchors.top: idLabel.bottom;
                                        anchors.topMargin: 10;

                                        height: 25;
                                        width: 120;

                                        Component.onCompleted:
                                        {
                                            if(index === 0)
                                            {
                                                model = ["默认", "仿宋", "华文中宋", "华文范松", "华文新魏", "华文楷体"];
                                                defaultText ="默认";
                                            }
                                            else if(index === 1)
                                            {
                                                var varModel = [];
                                                for(let i = 20; i < 97; ++i)
                                                    varModel.push(i);
                                                model = varModel;
                                                defaultText = 20;
                                            }
                                            else if(index === 2)
                                            {
                                                model = ["标准", "加粗"]
                                                defaultText = "标准";
                                            }
                                            else if(index === 3)
                                            {
                                                model = ["有描边", "无描边"];
                                                defaultText = "有描边";
                                            }

                                        }
                                    }
                                }
                            }
                        }

                        Item
                        {
                            height: 50;
                            width: parent.width;

                            Label
                            {
                                id: idAdjustFormat;
                                text: "调整样式";
                                font.family: "黑体"
                                font.pixelSize: 18;
                                color: "white";
                            }
                            Row
                            {
                                anchors.left: parent.left;
                                anchors.top: idAdjustFormat.bottom;
                                anchors.topMargin: 10;
                                spacing: 50;

                                Repeater
                                {
                                    model: [["单行显示", "多行显示"],["横排显示", "竖排显示"],["左对齐", "右对齐"]]
                                    ZYYComboBox
                                    {
                                        height: 25;
                                        width: 120;
                                        model: modelData;
                                        defaultText: modelData[0];
                                    }
                                }
                            }
                        }

                        Item
                        {
                            height: 50;
                            width: parent.width;
                            Label
                            {
                                id: idChangeColorLabel;
                                text: "更改配色方案";
                                font.family: "黑体"
                                font.pixelSize: 18;
                                color: "#ddd";
                            }

                            Row
                            {
                                anchors.left: parent.left;
                                anchors.top: idChangeColorLabel.bottom;
                                anchors.topMargin: 10;
                                spacing: 50;

                                ZYYComboBox
                                {
                                    model: ["自定义", "周易红", "落日晖", "可爱粉", "清新绿", "活力紫", "温柔黄", "低调灰"]
                                    defaultText: "周易红";
                                }

                                Repeater
                                {
                                    model: ["已播放", "未播放"]
                                    delegate: Rectangle
                                    {
                                        radius: 15;
                                        width: 150;
                                        height: 30;
                                        border.width: 1;
                                        border.color: "#28282e";
                                        color: "#1a1a20"

                                        Rectangle
                                        {
                                            id: idColorRect;
                                            width: parent.height / 2;
                                            height: width;
                                            anchors.left: parent.left;
                                            anchors.leftMargin: 20;
                                            anchors.verticalCenter: parent.verticalCenter;
                                            gradient: Gradient
                                            {
                                                GradientStop { position: 0; color: idColorSelecText.text === "已播放" ? BasicConfig.finishedLyricsUpColor : BasicConfig.unFinishedLyricsUpColor}
                                                GradientStop { position: 1; color: idColorSelecText.text === "已播放" ? BasicConfig.finishedLyricsDownColor : BasicConfig.unFinishedLyricsDownColor}
                                            }
                                        }

                                        Text
                                        {
                                            id: idColorSelecText
                                            color: "#ddd";
                                            text: modelData;
                                            font.pixelSize: 20;
                                            anchors.left: idColorRect.right;
                                            anchors.leftMargin: 10;
                                            font.family: BasicConfig.commFont;
                                            anchors.verticalCenter:  idColorRect.verticalCenter;
                                        }

                                        MouseArea
                                        {
                                            anchors.fill: parent;
                                            hoverEnabled: true;
                                            onEntered: cursorShape = Qt.PointingHandCursor;
                                            onExited: cursorShape = Qt.ArrowCursor;
                                            onClicked: ;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
             }
        }
    }
}


