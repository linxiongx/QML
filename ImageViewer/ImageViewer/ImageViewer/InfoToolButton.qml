import QtQuick
import QtQuick.Layouts

Item
{
    id: idContainer;

    // 外部属性
    property string text: "图片信息"
    property string imageSource: Qt.resolvedUrl("res/favicon.ico")
    property bool enabled: true
    property color textColor: "black" 

    signal clicked

    implicitWidth: childrenRect.width;
    implicitHeight: childrenRect.height;

    RowLayout
    {
        spacing: 2;

        Text
        {
            id: idText;
            text: idContainer.text;
            font.pixelSize: 12
            renderType: Text.QtRendering
            opacity: idContainer.enabled ? 1.0 : 0.5
            color: idContainer.textColor
        }

        Item
        {
            implicitWidth: childrenRect.width;
            implicitHeight: childrenRect.height;

            Image
            {
                id: idImage;
                source: idContainer.imageSource;
                opacity: idContainer.enabled ? 1.0 : 0.5
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
        hoverEnabled: true
        onClicked:
        {
            if (idContainer.enabled) {
                idContainer.clicked()
            }
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
