import QtQuick
import QtQuick.Controls

RadioButton
{
    id: idExitRadioButton;

    indicator: Rectangle
    {
        id: idExitRadioButtonIndicator;
        anchors.verticalCenter: parent.verticalCenter;
        implicitHeight: 18;
        implicitWidth: 18;
        radius: width / 2;
        border.color: "#eb4d44";
        border.width: 1;
        color: "transparent";

        Rectangle
        {
            anchors.fill: parent;
            anchors.margins: 4;
            radius: width / 2;
            visible: idExitRadioButton.checked;
            color: idExitRadioButton.enabled ? "#eb4d44" : "#532426";
        }
    }

    contentItem: Text
    {
        verticalAlignment: Text.AlignVCenter;
        leftPadding: idExitRadioButtonIndicator.width;
        height: idExitRadioButtonIndicator.height;
        width: implicitWidth;
        font.pixelSize: 16;
        font.family: "黑体";
        text: idExitRadioButton.text;
        color: idExitRadioButton.enabled ? "#ddd" : "#707074";
    }
}
