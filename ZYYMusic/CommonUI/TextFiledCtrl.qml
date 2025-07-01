//实现一个可以点击，可以接收输入的输入框

import QtQuick
import QtQuick.Controls

Item
{
    id: idTextFiledItem;
    width: 400
    height: 40

    //输入框背景
    Rectangle
    {
        id: idBackground;
        anchors.fill: parent
        radius: idTextFiledItem.height / 2
        color: "#222"
        border.width: 1
        border.color: "#d9d9da"
    }

    //输入框
    TextField
    {
        id: idPasswordTextField
        anchors.fill: parent
        font.pixelSize: idTextFiledItem.height / 2
        color: "#d9d9da"
        placeholderText: "请输入密码"
        placeholderTextColor: "#a1a1a3"
        font.family: "微软雅黑 Light"
        verticalAlignment: Text.AlignVCenter
        echoMode: TextInput.Password
        leftPadding: idTextFiledItem.height / 2
        background: null //默认背景设置为空
    }

    //鼠标区域接收点击消息，"后声明的元素在视觉上和事件处理上都在“上层”"。
    MouseArea
    {
        anchors.fill: parent
        hoverEnabled: true;
        onClicked:
        {
            idPasswordTextField.forceActiveFocus(); //点击后让输入框获得焦点
        }
        onEntered:
        {
            cursorShape = Qt.IBeamCursor;
        }
        onExited:
        {
            cursorShape = Qt.ArrowCursor;
        }
    }
}
