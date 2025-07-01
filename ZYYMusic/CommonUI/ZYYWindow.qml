import QtQuick
import "../Basic"

Window
{
    id: root;
    width: 1317
    height: 933
    visible: true
    title: qsTr("Hello World")

    flags: Qt.FramelessWindowHint | Qt.Window | Qt.WindowSystemMenuHint | Qt.WindowMaximizeButtonHint | Qt.WindowMinimizeButtonHint

    property point mousePressedPos;

    MouseArea
    {
        anchors.fill:  parent;
        onPressed: function(mouse)
        {
            mousePressedPos.x = mouse.x;
            mousePressedPos.y = mouse.y;
        }
        onPositionChanged: function(mouse)
        {
            var ptPosDelt = Qt.point(mouse.x - mousePressedPos.x, mouse.y - mousePressedPos.y);
            root.x += ptPosDelt.x;
            root.y += ptPosDelt.y;
        }
        onClicked:
        {
            BasicConfig.blanAreaClicked();
        }
    }
}
