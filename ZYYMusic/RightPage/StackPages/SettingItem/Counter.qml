import QtQuick
import QtQuick.Controls

Item
{
    height: 70;
    Label
    {
        id: idCounterTitleLabel;
        text: "账号";
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        anchors.left: parent.left;
        color: "white";
    }
    Label
    {
        id: idCounterDescriptionLabel;
        text: "登陆网易云音乐，手机电脑多端同步，320k高音质无限下载";
        font.pixelSize: 18;
        font.family: BasicConfig.commFont;
        anchors.left: idCounterTitleLabel.right;
        anchors.leftMargin: 150;
        anchors.verticalCenter: parent.verticalAlignment;
        color: "#e8e8e8";
    }
    Rectangle
    {
        width: 100;
        height: 30;
        radius: 10;
        anchors.left: idCounterDescriptionLabel.left;
        anchors.top: idCounterDescriptionLabel.bottom;
        anchors.topMargin: 20;
        color: "#e84d5f";
        Label
        {
            text: "立即登陆";
            font.pointSize: 16;
            font.family: BasicConfig.commFont;
            anchors.centerIn: parent;
            color: "white";
        }
        MouseArea
        {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered:
            {
                parent.opacity = 0.8;
                cursorShape = Qt.PointingHandCursor;
            }
            onExited:
            {
                parent.opacity = 1;
                cursorShape = Qt.ArrowCursor;
            }
        }
    }
}
