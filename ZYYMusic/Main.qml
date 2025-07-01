import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./CommonUI"
import "./RightPage"
import "./LeftPage"
import "./PlayMusic"
import "./Basic"
import "./mainPopups"

ZYYWindow
{
    id: root;

    Connections
    {
        target: BasicConfig;
        function onOpenLoginPopup()
        {
            idLoginPopup.open();
        }
    }

    LeftPage
    {
        id: idLeftRect;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.bottom: idBottomRect.top;

        color: "#1a1a21"
    }


    RightPage
    {
        id: idRrightRect;
        anchors.left: idLeftRect.right;
        anchors.top: parent.top;
        anchors.right: parent.right;
        anchors.bottom: idBottomRect.top;

        color: "#13131a"
    }


    PlayMusic
    {
        id: idBottomRect;
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        anchors.right: parent.right;
        height: 100;

        color: "#2d2d37"
    }

    LoginPopup
    {
        id: idLoginPopup
        anchors.centerIn: parent;
    }

    LoginByOtherMainsPopup
    {
        id: idLoginByOtherMainsPopup
        anchors.centerIn: parent;

    }
}
