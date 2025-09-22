//实现一个可以接收快捷键的输入框（不可编辑）
import QtQuick
import QtQuick.Controls
import Basic 1.0

TextField
{
    id: idTextField;

    readOnly: true;
    font.pixelSize: 20;
    font.family: BasicConfig.commFont;
    color: "#8c8c90";
    width: 150;

    //cursorVisible:  true;

    Connections
    {
        target: BasicConfig;
        function onBlankAreaClicked()
        {
            focus = false;
        }
    }

    Keys.onPressed:function (event)
    {
        if(!focus) return;
        let str = "";
        if(event.modifiers & Qt.ControlModifier)
        {
            str += "Ctrl + ";
        }
        if(event.modifiers & Qt.SHIFT)
        {
            str += "Shift + ";
        }
        if(event.modifiers & Qt.AltModifier)
        {
            str += "Alt + ";
        }
        switch(event.key)
        {
        case Qt.Key_Up:
            str += "Up"
            break;
        case Qt.Key_Down:
            str += "Down";
            break;
        case Qt.Key_Left:
            str += "Left";
            break;
        case Qt.Key_Right:
            str += "Right";
        }
        if((event.key >= Qt.Key_0 && event.key <= Qt.Key_9) || (event.key >= Qt.Key_A && event.key <= Qt.Key_Z))
            str += String.fromCharCode(event.key);

        text = str;
    }

    background: Rectangle
    {
        anchors.fill: parent;
        color: "#222";
        border.width: 1;
        border.color: idTextField.focus ? "#333" : "#37363a";
        radius: height / 2;
        Rectangle
        {
            id: idFocusRect;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.topMargin: 4;
            anchors.bottomMargin: 4;
            width: 1;
            visible: idTextField.focus;
            anchors.leftMargin: idTextField.implicitWidth;
        }
        SequentialAnimation
        {
            id: ididFocusAnimation;
            running: idTextField.focus;
            loops: Animation.Infinite;
            PropertyAnimation
            {
                target: idFocusRect;
                property: "opacity";
                from: 1;
                to: 0;
                duration: 300;
            }
            PauseAnimation
            {
                duration: 500
            }
            PropertyAnimation
            {
                target: idFocusRect;
                property: "opacity";
                from: 0;
                to: 1;
                duration: 300;
            }
        }

    }
}
