import QtQuick
import QtQuick.Layouts

Item
{
    id: idContainer;
    property alias text: idText.text;
    property alias imageSource: idImage.source;
    signal clicked

    implicitWidth: childrenRect.width;
    implicitHeight: childrenRect.height;

    RowLayout
    {

        spacing:2;

        Text
        {
            id: idText;
            text: "旋转"
        }

        Item
        {
            implicitWidth: childrenRect.width;
            implicitHeight: childrenRect.height;

            Image
            {
                id: idImage;
                source: Qt.resolvedUrl("res/favicon.ico");
                property real initialY: 0;

                Component.onCompleted:
                {
                    initialY = y;
                }

                Behavior on y
                {
                    NumberAnimation
                    {
                        duration: 100;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        }

    }

    MouseArea
    {
        anchors.fill: parent;
        onClicked:
        {
            idContainer.clicked();
        }
        onPressed:
        {
            idImage.y = idImage.initialY + 3;
        }
        onReleased:
        {
            idImage.y = idImage.initialY;
        }
        onCanceled:
        {
            idImage.y = idImage.initialY;
        }
    }
}