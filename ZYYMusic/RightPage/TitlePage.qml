import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Controls

Item
{

    //投屏、最大化、最小化、关闭
    MinMax
    {
        id: idMinMaxRect
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: root.width * 0.01;
        height: parent.height
    }

    OthersPage
    {
        anchors.right: idMinMaxRect.left;
        anchors.rightMargin: 5;
        anchors.verticalCenter: parent.verticalCenter;
        height: parent.height;
    }

    //搜索框
    Search
    {
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter;
        height: parent.height;
    }

}
