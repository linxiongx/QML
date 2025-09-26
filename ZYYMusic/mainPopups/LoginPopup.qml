import QtQuick
import QtQuick.Controls
import "../Basic"

Popup
{
    width: 466;
    height: 638;
    anchors.centerIn: parent;
    clip: true;
    closePolicy: Popup.NoAutoClose;
    onOpened: {
        // animationContainer.state = "showQR";  // 默认显示二维码，自动优化动画
    }
    background: Rectangle
    {
        anchors.fill: parent;
        color: "#1b1b23";
        radius: 10;
        border.width: 1;
        border.color: "#75777f";
        //关闭
        Image
        {
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.topMargin: 10;
            anchors.rightMargin: 10;
            source: "qrc:/Image/Res/title/close.png";
            width: 32; height: 32;

            MouseArea
            {
                anchors.fill: parent;
                hoverEnabled: true;
                onEntered:
                {
                    cursorShape = Qt.PointingHandCursor;
                }
                onExited:
                {
                    cursorShape = Qt.ArrowCursor;
                }
                onClicked:
                {
                    idLoginPopup.close();
                }
            }
        }

        //标题
        Label
        {
            id: idLoginText;
            text: "扫码登陆";
            color: "white";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 80;
            font.bold: true;
            font.family: "黑体";
            font.pixelSize: 32;
        }

        Image
        {
            id: idQrcode;
            x: 250;
            y: 130;
            scale: 0.8;
            source: "qrc:/Image/Res/MainLogin/QrCode.png"
            MouseArea
            {
                anchors.fill: parent;
                hoverEnabled:  true;
                onEntered:
                {
                    idShowAnimation.showFlag = true;
                    idShowAnimation.start();
                }
                onExited:
                {
                    idShowAnimation.showFlag = false;
                    idShowAnimation.start();
                }
            }
        }

        Image
        {
            id: idCode;
            x: 20;
            y: 100;
            scale: 0.8;
            opacity: 0;
            source: "qrc:/Image/Res/MainLogin/code.png"
        }
        ParallelAnimation
        {
            id: idShowAnimation;
            property bool showFlag: false;
            NumberAnimation
            {
                target: idCode;
                property: "x";
                duration: 500;
                from: idShowAnimation.showFlag ? (idLoginPopup.width - idCode.implicitWidth) / 2 : 10;
                to: idShowAnimation.showFlag ? 10 : (idLoginPopup.width - idCode.implicitWidth) / 2;
            }
            NumberAnimation
            {
                target: idCode;
                property: "y";
                duration: 500;
                from: idShowAnimation.showFlag ? 60 : (idLoginPopup.height - idCode.implicitHeight) / 2 + 30;
                to: idShowAnimation.showFlag ?  (idLoginPopup.height - idCode.implicitHeight) / 2 + 30 : 60;
            }

            NumberAnimation
            {
                target: idCode;
                property: "opacity";
                duration: 500;
                from: idShowAnimation.showFlag ? 0 : 1;
                to: idShowAnimation.showFlag ?  1 : 0;
            }

            NumberAnimation
            {
                target: idQrcode;
                property: "scale";
                duration: 500;
                from: idShowAnimation.showFlag ? 0.8 : 0.5;
                to: idShowAnimation.showFlag ?  0.5 : 0.8;
            }
            NumberAnimation
            {
                target: idQrcode;
                property: "x";
                duration: 500;
                from: idShowAnimation.showFlag ? (idLoginPopup.width - idQrcode.implicitWidth) / 2 : 250;
                to: idShowAnimation.showFlag ?  250 : (idLoginPopup.width - idQrcode.implicitWidth) / 2;
            }
        }

        Label {
            id: otherLoginLabel;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 30;
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: 20;
            font.family: "微软雅黑 Light";
            color: "#75777f";

            text: "其它方式登陆 >"

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true;
                onEntered: {
                    cursorShape = Qt.PointingHandCursor;
                }
                onExited: {
                    cursorShape = Qt.ArrowCursor;
                }
                onClicked: {
                    idLoginPopup.close();
                    idLoginByOtherMainsPopup.open();
                }
            }
        }
        }
    }

