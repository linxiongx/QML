import QtQuick
import QtQuick.Controls
import "../Basic"
import "../CommonUI"

ComboBox
{
    id: idFontSelectorCbx;
    width: 150;
    height: 30;

    //property var defaultText: count > 0 ? model[0] : "";
    property string defaultText: "默认";
    property int maxVisibleItem: 7;

    //背景
    background: Rectangle
    {
        anchors.fill: parent;
        radius: parent.height;
        border.width: 1;
        border.color: "#28282e";
        color: "#1a1a20";
        MouseArea
        {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: cursorShape = Qt.PointingHandCursor;
            onExited: cursorShape = Qt.ArrowCursor;
        }

    }

    //指示器
    indicator: Label
    {
        text: ">"
        //rotation: 90;
        rotation: idFontSelectCbxListView.visible ? -90 : 90;
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        anchors.right: parent.right;
        color: "#e9e9e9";
        anchors.rightMargin: 10;
        anchors.verticalCenter: parent.verticalCenter;
    }

    //内容
    contentItem: Text
    {
        id: idFontSelectorCbxText;
        text: defaultText;
        color: "white";
        font.pixelSize: 16;
        font.family: BasicConfig.commFont;
        verticalAlignment: Text.AlignVCenter;
        leftPadding: 18;
        elide: Text.ElideRight;
    }

    model: {}

    //下拉框
    popup: Popup
    {
        id: idFontSelectCbxPopup;
        y: parent.height + 5;
        width: parent.width;
        // 动态计算高度
        height:
        {
            var itemCount = idFontSelectorCbx.model.length;
            var maxVisible = maxVisibleItem;
            var itemHeight = 40;
            var visibleCount = Math.min(itemCount, maxVisible);
            return visibleCount * itemHeight;
        }

        background: Rectangle
        {
            anchors.fill: parent;
            radius: 10;
            color: "#2d2d37";
            clip: true;
            ListView
            {
                id: idFontSelectCbxListView;
                anchors.fill: parent;
                model: idFontSelectorCbx.model;

                ScrollBar.vertical: ScrollBar
                {
                    policy: ScrollBar.AlwaysOn
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 8
                    contentItem: Rectangle
                    {
                        implicitWidth: 8
                        radius: 4
                        color: "#555"
                    }
                }

                delegate: Rectangle
                {
                    width: idFontSelectorCbx.width - 10;
                    anchors.topMargin: (height -  idComboxText.implicitHeight - 10);
                    height: 40;
                    radius: 10;
                    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined;
                    color: idListViewMouseArea.containsMouse ? "#3e3e48" : "transparent";
                    Text
                    {
                        id: idComboxText;
                        color: "#d6d6d8";
                        text: modelData;
                        font.pixelSize: 16;
                        anchors.left: parent.left;
                        anchors.leftMargin: 10;
                        anchors.verticalCenter: parent.verticalCenter;
                        font.family: BasicConfig.commFont;
                    }
                    MouseArea
                    {
                        id: idListViewMouseArea;
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: cursorShape = Qt.PointingHandCursor;
                        onExited: cursorShape = Qt.ArrowCursor;
                        onClicked:
                        {
                            idFontSelectorCbxText.text = modelData;
                            idFontSelectCbxPopup.close();
                        }
                    }
                }
            }
        }
    }

}
