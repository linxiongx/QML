import QtQuick 2.15
import "../CommonUI"
import Qt5Compat.GraphicalEffects
 import QtQuick.Controls

Row
{

    id: idSearchRect;
    anchors.leftMargin: 40;
    spacing: 5;

    //后退
    Rectangle
    {
        id: idBackforwardRect;
        width: 20;
        height: parent.height /2;
        color: "transparent"
        border.color: "#2b2b31";
        border.width: 1;
        radius: 4;
        anchors.verticalCenter: parent.verticalCenter;
        Text
        {
            text: "<";
            anchors.centerIn: parent;
            color: "#b0b2b8";
            font.pointSize: 15;
        }
    }

    //搜索框
    ZYYSearchBox
    {
        id: idSearchTextField;
        width: 240;
        height:idBackforwardRect.height;
        anchors.verticalCenter: parent.verticalCenter;
    }

    ListModel
    {
        id: idSearchSingModel;
        ListElement{name: "千里之外";}
        ListElement{name: "光年之外";}
        ListElement{name: "光阴的故事";}
        ListElement{name: "入戏太深";}
        ListElement{name: "你说童话都是骗人的";}
        ListElement{name: "鱼仔";}
        ListElement{name: "好久不见";}
        ListElement{name: "知足常乐";}
        ListElement{name: "枫";}
    }

    ListModel
    {
        id: idhotSearchSingModel;
        ListElement{name: "千里之外";}
        ListElement{name: "光年之外";}
        ListElement{name: "光阴的故事";}
        ListElement{name: "入戏太深";}
        ListElement{name: "你说童话都是骗人的";}
        ListElement{name: "鱼仔";}
        ListElement{name: "好久不见";}
        ListElement{name: "知足常乐";}
        ListElement{name: "枫";}
        ListElement{name: "千里之外";}
        ListElement{name: "光年之外";}
        ListElement{name: "光阴的故事";}
        ListElement{name: "入戏太深";}
        ListElement{name: "你说童话都是骗人的";}
        ListElement{name: "鱼仔";}
        ListElement{name: "好久不见";}
        ListElement{name: "知足常乐";}
        ListElement{name: "枫";}
    }


    Popup
    {
        id: idSearchPopup;
        width: idSearchRect.width;
        height: 600;
        y: idSearchTextField.y + idSearchTextField.height + 10;
        closePolicy: Popup.CloseOnPressOutside;
        clip: true;

        background: Rectangle
        {
            anchors.fill: parent;
            radius: 10;
            color: "#2d2d37"

            Flickable
            {
                anchors.fill: parent;
                contentHeight: 900;
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

                Item
                {
                    anchors.fill: parent;
                    anchors.margins: 20;

                    Item
                    {
                        id: idHistoryItem;
                        width: parent.width;
                        height: idRemoveIconImg.height;
                        Text
                        {
                            anchors.left: parent.left;
                            verticalAlignment: Text.AlignVCenter;
                            horizontalAlignment: Text.AlignHCenter;
                            text: "搜索历史"
                            color: "#7f7f85"
                            font.family: "微软雅黑 Light";
                            font.pointSize: 16;
                        }
                        Image
                        {
                            id: idRemoveIconImg;
                            anchors.verticalCenter: parent.verticalCenter;
                            anchors.right: parent.right;
                            width: 24;
                            height: 24;
                            source: "qrc:/Image/Res/LoginState/delete.png"

                            ColorOverlay
                            {
                                source: idRemoveIconImg;
                                color: "darkred";
                                anchors.fill: parent;
                                visible: idRemoveIconImgMouseArea.containsMouse;
                            }
                            MouseArea
                            {
                                id: idRemoveIconImgMouseArea;
                                anchors.fill: parent;
                                hoverEnabled: true;
                            }
                        }
                    }

                    //搜索历史
                    Flow
                    {
                        id: idSongFlow;
                        anchors.top: idHistoryItem.bottom;
                        anchors.left: parent.left;
                        anchors.right: parent.right;
                        anchors.topMargin: 20;
                        spacing: 10;
                        property bool isExpanded: false

                        Repeater
                        {
                            anchors.fill: parent;
                            model: idSearchSingModel;
                            delegate: Rectangle
                            {
                                width: idDataLabel.implicitWidth + 20;
                                height: idDataLabel.implicitHeight + 10;
                                border.width: 1;
                                border.color:"#45454e";
                                color: "#2d2d37"
                                radius: 15;
                                visible: {
                                    if(idSongFlow.isExpanded == false && index > 4)
                                    {
                                        return false;
                                    }
                                    return true;
                                }

                                Label
                                {
                                    id: idDataLabel;
                                    text:
                                    {
                                        if(idSongFlow.isExpanded === false)
                                        {
                                            return index === 4 ? "v": name;
                                        }
                                        else
                                        {
                                            return index === 8 ? "^": name;
                                        }
                                    }
                                    font.pixelSize: 20;
                                    anchors.centerIn: parent;
                                    color: "#ddd";
                                    font.family: "微软雅黑 Light";
                                    height: 25;
                                }
                                MouseArea
                                {
                                    anchors.fill: parent;
                                    hoverEnabled: true;
                                    onEntered:
                                    {
                                        idDataLabel.color = "white";
                                        parent.color = "#393943";
                                        cursorShape = Qt.PointingHandCursor
                                    }

                                    onExited:
                                    {
                                        idDataLabel.color = "#ddd";
                                        parent.color = "#2d2d37";
                                        cursorShape = Qt.ArrowCursor;
                                    }
                                    onClicked:
                                    {
                                        if(idSongFlow.isExpanded && index === 8)
                                        {
                                            idSongFlow.isExpanded = !idSongFlow.isExpanded;
                                        }
                                        if(!idSongFlow.isExpanded && index === 4)
                                        {
                                            idSongFlow.isExpanded = !idSongFlow.isExpanded;
                                        }
                                        idSearchTextField.text = name;
                                    }
                                }
                            }
                        }
                    }

                    Label
                    {
                        id: idHotSearchLabel;
                        anchors.top: idSongFlow.bottom;
                        anchors.topMargin: 20;
                        color: "#7f7f85";
                        text: "热搜榜";
                        font.pixelSize: 18;
                        font.family: "微软雅黑 Light";
                    }

                    //热搜榜
                    Item
                    {
                        anchors.top: idHotSearchLabel.bottom;
                        anchors.topMargin: 15;
                        width: parent.width;
                        height: idSearchPopup.height - idHistoryItem.height - idSongFlow.height - idHotSearchLabel.height;

                        Column
                        {
                            anchors.fill: parent;
                            Repeater
                            {
                                anchors.fill: parent;
                                model: idhotSearchSingModel;
                                delegate: Item
                                {
                                    width: parent.width;
                                    height: 32;

                                    Label
                                    {
                                        id: idHotSearchNoLable
                                        anchors.left: parent.left;
                                        anchors.top: parent.top;
                                        height: parent.height;
                                        width: implicitWidth;
                                        verticalAlignment: Text.AlignVCenter;
                                        text: (index + 1);
                                        color: index < 3 ? "#eb4d44" : "#818187";
                                        //font.pixelSize: 18;
                                    }

                                    Label
                                    {
                                        anchors.left: idHotSearchNoLable.right;
                                        anchors.top: parent.top;
                                        height: parent.height;
                                        width: implicitWidth;
                                        anchors.leftMargin: 10;
                                        verticalAlignment: Text.AlignVCenter;
                                        text: name;
                                        font.pixelSize: 18;
                                        font.family: "微软雅黑 Light"
                                        color: "#ddd"
                                    }
                                }
                            }
                        }

                    }

                }
            }


        }
    }

    //麦克风
    Rectangle
    {
        id: idMicrophoneRect;
        anchors.verticalCenter: parent.verticalCenter;
        height: idBackforwardRect.height;
        width: height;
        color: "#241c26"
        border.color: "#36262f";
        border.width: 1;
        radius: 8;

        Image
        {
            id: idMicrophoneImage;
            anchors.centerIn: parent;
            source: "qrc:/Image/Res/LoginState/Microphone.png"
            width: 30;
            height: 30;

            ColorOverlay
            {
                anchors.fill: parent;
                source: idMicrophoneImage;
                color: "white";
                visible: idMicrophoneImageMouseArea.containsMouse;
            }

            MouseArea
            {
                id: idMicrophoneImageMouseArea;
                anchors.fill: parent;
                hoverEnabled: true;
            }
        }
    }

}
