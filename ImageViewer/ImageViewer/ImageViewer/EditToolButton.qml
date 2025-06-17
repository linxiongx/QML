import QtQuick
import QtQuick.Controls

MyToolButton
{
    id: idToolButton;
    text: qsTr("编辑");
    imageSource: Qt.resolvedUrl("res/favicon.ico");
    onClicked: idMenu.open();

    property alias marginValue: idMenu.marginValue;

    Menu
    {
        id: idMenu;

        property int marginValue: 0;

        y: idToolButton.y + idToolButton.height + marginValue;
        x: idToolButton.x;

        MenuItem
        {
            text: "转换图片";
            onTriggered:
            {
                console.log("转换图片");
            }
        }

        MenuItem
        {
            text: "原始大小";
            onTriggered:
            {
                console.log("原始大小");
            }
        }
    }

}
