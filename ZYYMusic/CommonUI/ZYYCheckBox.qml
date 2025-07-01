import QtQuick
import QtQuick.Controls
import "../Basic"
import "../CommonUI"
Item
{
    id: idCheckBox
    property string text: "记住密码";
    property alias checked: idCheckBoxRect.selected;

    height: 25;
    width: idCheckBoxRect.width + idLabel.width;

    MouseArea
    {
        anchors.fill: parent;
        hoverEnabled: true;
        onEntered:
        {
            cursorShape = idCheckBox.enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor;
        }
        onExited:
        {
            cursorShape = Qt.ArrowCursor;
        }
        onClicked: function(mouse)
        {
            if (enabled)
            {
                    idCheckBoxRect.selected = !idCheckBoxRect.selected;
            } 
        }
    }

    Row
    {
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter;
        spacing: 10;
        Rectangle
        {
            id: idCheckBoxRect;
            anchors.verticalCenter: parent.verticalCenter;
            width: 20;
            height: width;
            radius: 2;
            border.width: 1;
            //border.color: selected ? "#7a7a7f" : "#2f2f34";
            //color: selected ? "#eb4d44" : "transparent";
            border.color: {
                if (!enabled && selected) return "#4a4a4f"      // 选中但禁用：#7a7a7f 变灰
                if (!enabled && !selected) return "#1f1f24"     // 未选中但禁用：#2f2f34 变灰
                return selected ? "#7a7a7f" : "#2f2f34"         // 正常启用状态
            }

            color: {
                if (!enabled && selected) return "#8b2d26"      // 选中但禁用：#eb4d44 变灰
                if (!enabled && !selected) return "transparent" // 未选中禁用：保持透明
                return selected ? "#eb4d44" : "transparent"     // 正常启用状态
            }

            property bool selected: false;

            Label
            {
                id: idSelectedLabel;
                visible: parent.selected;
                color: "#adadb0";
                font.bold: true;
                text: "√";
                font.pixelSize: 18;
                font.family: BasicConfig.commFont;
            }
        }
        Label
        {
            id: idLabel;
            font.bold: true;
            font.family: BasicConfig.commFont;
            font.pixelSize: 18;
            anchors.verticalCenter: parent.verticalCenter;
            text: idCheckBox.text;
            color: idCheckBox.enabled ? "#ddd" : "#2f2f34";
            textFormat: Text.RichText
        }
    }
}
