import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

//右侧区域
Rectangle
{
     //标题栏
    TitlePage
    {
        id: idTitleRect;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.top: parent.top;
        height: 60;
    }

    //客户区
    StackView
    {
        id: idMainStackView;
        anchors.left: parent.left;
        anchors.top: idTitleRect.bottom;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 100;

        clip:true;
        initialItem: "./StackPages/CloudMusic.qml";
    }
}
