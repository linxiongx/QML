import QtQuick 2.15

import QtQuick.Controls
import "../Basic"
TextField
{
    Connections
    {
        target: BasicConfig;
        function onBlankAreaClicked()
        {
            idInnerRect.positionValue = 1;
        }
    }
    id: idSearchTextField;

    placeholderText: "晴天";
    placeholderTextColor: "#75777f";
    font.pixelSize: 16;
    font.family: "微软雅黑 Light";
    leftPadding: 40;
    color: "white";

    background: Rectangle
    {
        anchors.fill: parent;
        radius: 8;
        gradient: Gradient
        {
            orientation: Gradient.Horizontal;
            GradientStop{color: "#21283d"; position: 0}
            GradientStop{color: "#382635"; position: 1}
        }

        Rectangle
        {
            id: idInnerRect;
            anchors.fill: parent;
            anchors.margins: 1;

            property real positionValue: 1

            gradient: Gradient
            {
                orientation: Gradient.Horizontal;
                GradientStop{color: "#1a1d29"; position: 0}
                GradientStop{color: "#241c26"; position: idInnerRect.positionValue}
            }

        }

        Image
        {
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            height: parent.height - 8;
            anchors.leftMargin: 10;
            width: height;
            source: "qrc:/Image/Res/LoginState/search.png";
        }


    }

    onPressed:
    {
        idInnerRect.positionValue = 0;
        idSearchPopup.open();
    }
}
