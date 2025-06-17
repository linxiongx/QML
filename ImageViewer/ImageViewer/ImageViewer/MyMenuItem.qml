import QtQuick
import QtQuick.Controls

MenuItem
{
    id: idMenu;
    checkable: true;

    indicator: null; //禁用默认的指示器

    contentItem: Row
    {
        anchors.fill: parent;
        anchors.leftMargin: idMenu.checked ? 13 : 30;
        spacing: 5;
        Image
        {
            anchors.verticalCenter: parent.verticalCenter;
            source: Qt.resolvedUrl("res/ok.png");
            width: 12; height: 12;
            visible: idMenu.checked;
        }
        Text
        {
            text: idMenu.text;
            anchors.verticalCenter: parent.verticalCenter;
        }
    }
}
