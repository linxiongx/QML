import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../Basic"

Item
{
    id: root

    Item
    {
        anchors.fill: parent;
        anchors.topMargin: 20;
        anchors.leftMargin: 24;

        Flow
        {
            id: idMusicTabsFlow;
            anchors.left:  parent.left;
            anchors.top: parent.top;
            anchors.topMargin: 15;
            height: 25;
            spacing: 20;
            Repeater
            {
                id: idTabRep;
                anchors.fill: parent
                model: ["精选", "歌单广场", "排行榜", "歌手"];
                property int selectedIndex: 0;
                Item
                {
                    height: 40;
                    width: idTabLabel.implicitWidth
                    property bool isHovered: false
                    Label
                    {
                        id: idTabLabel;
                        text: modelData;
                        font.pixelSize: 20;
                        font.bold: true;
                        font.family: "黑体";

                        color:
                        {
                            if (idTabRep.selectedIndex === index)
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
                        visible: idTabRep.selectedIndex === index;
                        anchors.left: idTabLabel.left;
                        anchors.right: idTabLabel.right;
                        anchors.top: idTabLabel.bottom;
                        anchors.leftMargin: idTabLabel.implicitWidth / idTabLabel.font.pixelSize * 2;
                        anchors.rightMargin: idTabLabel.implicitWidth / idTabLabel.font.pixelSize * 2;
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
                            idTabRep.selectedIndex = index;
                            view.currentIndex = index;
                        }
                    }
                }
            }
        }

        //分割线
        Rectangle
        {
            id: idCutLine;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: idMusicTabsFlow.bottom;
            anchors.topMargin: 20;
            height: 1;
            color: "#212127"
        }

        StackLayout
        {
            id: view
            currentIndex: idTabRep.selectedIndex
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.top: idCutLine.bottom;
            anchors.topMargin: 0;
            anchors.bottom: parent.bottom;

            // 精选 tab
            Loader
            {
                source: "Featured.qml"
            }

            // 歌单广场 tab
            Loader
            {
                source: "PlaylistSquare.qml"
            }

            // 排行榜 tab
            Loader
            {
                source: "Rankings.qml"
            }

            // 歌手 tab
            Loader
            {
                source: "Artists.qml"
            }
        }
    }
}
