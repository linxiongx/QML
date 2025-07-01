import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Row
{
    spacing: 10;

    Item
    {
        anchors.verticalCenter: parent.verticalCenter;
        width: 40;
        height: 40;
        Image
        {
            id: idMinImage;
            anchors.fill: parent;
            source: "qrc:/Image/Res/title/mirror.png"
        }

        // 灰度图像
        ColorOverlay {
            anchors.fill: idMinImage
            source: idMinImage
            color: "white"
            visible: idMinImageMouseArea.containsMouse  // 鼠标在时显示
        }

        MouseArea
        {
            id: idMinImageMouseArea;
            anchors.fill: parent;
            hoverEnabled: true;
        }
    }

    //最小化
    Rectangle
    {
        id: idMinButton;
        anchors.verticalCenter: parent.verticalCenter;
        width: 20;
        height: 2;
        color: "#75777f"
        MouseArea
        {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered:
            {
                idMinButton.color = "white";
            }
            onExited:
            {
                idMinButton.color = "#75777f";
            }
            onClicked:
            {
                root.showMinimized();
            }
        }
    }

    //最大化
   Rectangle
   {
       id: idMaxButton
       anchors.verticalCenter: parent.verticalCenter;
        width: 20;
        height: 20;
        color: "transparent"
        border.color: "#75777f";

        MouseArea
        {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered:
            {
                idMaxButton.border.color = "white";
            }
            onExited:
            {
                idMaxButton.border.color = "#75777f";
            }
            onClicked:
            {
                if (root.visibility === Window.Windowed)
                {
                   root.showMaximized();
                }
                 else if (root.visibility === Window.Maximized)
                 {
                    root.showNormal();
                 }
            }
        }
   }

   //关闭按钮
   Item
   {
       anchors.verticalCenter: parent.verticalCenter;
       width: 30;
       height: 30;

       Image
       {
           id: idCloseButtonImage;
            anchors.fill: parent;
           source: "qrc:/Image/Res/title/close.png";
           //scale: 0.2
       }

       ColorOverlay
       {
            anchors.fill: parent;
            source: idCloseButtonImage;
            color: "white";
            visible: idCloseButtonMouseArea.containsMouse;
       }

       MouseArea
       {
           id: idCloseButtonMouseArea;
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: Qt.quit();
       }

   }

}
