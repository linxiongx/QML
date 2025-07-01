pragma Singleton
import QtQuick

QtObject
{
    signal blanAreaClicked() //窗口空白区域被点击
    signal openLoginPopup() //打开扫码登陆弹窗

    readonly property color fieldTextColor: "#d9d9da";
    readonly property string commFont: "微软雅黑 Light";
}
