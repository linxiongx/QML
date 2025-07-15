pragma Singleton
import QtQuick

QtObject
{
    signal blanAreaClicked() //窗口空白区域被点击
    signal openLoginPopup() //打开扫码登陆弹窗

    readonly property color fieldTextColor: "#d9d9da";
    readonly property string commFont: "微软雅黑 Light";

    property color finishedLyricsUpColor: "#ee8784"; //已播放歌词的上渐变颜色
    property color finishedLyricsDownColor: "#f3b3b1"; //已播放歌词的下渐变颜色
    property color finishedLyricsBorderColor: "#ffff91";//已播放歌词的边框颜色
    property color unFinishedLyricsUpColor: "white"; //未播放歌词的上渐变颜色
    property color unFinishedLyricsDownColor: "#ddd"; //未播放歌词的下渐变颜色
    property color unFinishedLyricsBorderColor: "white"; //未播放歌词的边框颜色
}
