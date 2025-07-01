import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

Item
{
    Row
    {
        id: idLoginStateRightRect;
        spacing: 8;
        anchors.right: parent.right;
        anchors.verticalCenter: parent.verticalCenter;
        height: parent.height;

        //下拉箭头
        Label
        {
            anchors.verticalCenter: parent.verticalCenter;
            width: 30;
            height: 30;
            x: -200;

            Text
            {
                anchors.centerIn: parent;
                id: idLabelText;
                text: "<"
                color: "#75777f"
                rotation: -90;
                font.pointSize: 18;
            }

            MouseArea
            {
                anchors.fill: parent;
                hoverEnabled: true;
                onEntered: idLabelText.color = "white";
                onExited: idLabelText.color = "#75777f";
            }
        }

        //信息
        Image
        {
            id: idMessageImage;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:/Image/Res/LoginState/message.png"
            width: 30;
            height: 30;

            ColorOverlay
            {
                anchors.fill: parent;
                source: idMessageImage;
                color: "white";
                visible:idMessageImageMouseArea.containsMouse;
            }

            MouseArea
            {
                id: idMessageImageMouseArea;
                anchors.fill: parent;
                hoverEnabled: true;
            }
        }

        //设置
        Image
        {
            id: idSettingImage
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:/Image/Res/LoginState/setting.png"
            width: 30;
            height: 30;
            scale: 0.8

            ColorOverlay
            {
                anchors.fill: parent;
                source: idSettingImage;
                color: "white";
                visible: idSettingImageMouseArea.containsMouse;
            }

            MouseArea
            {
                id: idSettingImageMouseArea;
                anchors.fill: parent;
                hoverEnabled: true;
                onClicked:
                {
                    idMainStackView.push("./StackPages/Setting.qml");
                }
            }
        }

        //换肤
        Image
        {
            id: idSkinImage;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:/Image/Res/LoginState/skin.png"
            width: 30;
            height: 30;

            ColorOverlay
            {
                anchors.fill: parent;
                source: idSkinImage;
                color: "white";
                visible: idSkinImageMouseArea.containsMouse;
            }

            MouseArea
            {
                id: idSkinImageMouseArea
                anchors.fill: parent;
                hoverEnabled: true;
            }
        }

        //竖线
        Rectangle
        {
            anchors.verticalCenter: parent.verticalCenter;
            height: 20;
            width: 1;
            color: "gray"
        }
    }

    Row
    {
        id: idLoginStateLeftRect;
        anchors.right: idLoginStateRightRect.left;
        anchors.verticalCenter: parent.verticalCenter;
        height: parent.height;

        //用户头像
        Image
        {
            id: idUserImage;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:/Image/Res/LoginState/user.png"
            width: 30;
            height: 30;
            scale: 0.9;

            ColorOverlay
            {
                anchors.fill: parent;
                source: idUserImage;
                color: "white";
                visible: idUserImageMouseArea.containsMouse;
            }
            MouseArea
            {
                id: idUserImageMouseArea;
                anchors.fill: parent;
                hoverEnabled: true;
            }
        }

        //未登录
        Text
        {
            id: idLoginStateText;
            anchors.verticalCenter: parent.verticalCenter;
            text: "未登录"
            color: "#75777f"
            padding: 5;

            MouseArea
            {
                hoverEnabled: true;
                anchors.fill: parent;
                onEntered: idLoginStateText.color = "white";
                onExited: idLoginStateText.color = "#75777f";
                onClicked:
                {
                    BasicConfig.openLoginPopup();
                }
            }
        }

        Rectangle
        {
            anchors.verticalCenter: parent.verticalCenter;
            width: 50;
            height: 10;
            radius: 10;

            Rectangle
            {
                anchors.verticalCenter: parent.verticalCenter;
                height: 15;
                width: 15;
                radius: 10;
                border.color: "black";
            }
        }

    }

}
