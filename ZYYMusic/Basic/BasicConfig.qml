pragma Singleton
import QtQuick

QtObject
{
    signal blankAreaClicked() //窗口空白区域被点击
    signal openLoginPopup() //打开扫码登陆弹窗

    readonly property color fieldTextColor: "#d9d9da";
    readonly property string commFont: "微软雅黑 Light";

    property color finishedLyricsUpColor: "#ee8784"; //已播放歌词的上渐变颜色
    property color finishedLyricsDownColor: "#f3b3b1"; //已播放歌词的下渐变颜色
    property color finishedLyricsBorderColor: "#ffff91";//已播放歌词的边框颜色
    property color unFinishedLyricsUpColor: "white"; //未播放歌词的上渐变颜色
    property color unFinishedLyricsDownColor: "white"; //未播放歌词的下渐变颜色
    property color unFinishedLyricsBorderColor: "white"; //未播放歌词的边框颜色

    property color backgroundColor: "#00000040" // 背景色

    property var colorScheme: ({
        finishedUp: finishedLyricsUpColor,
        finishedDown: finishedLyricsDownColor,
        finishedBorder: finishedLyricsBorderColor,
        unFinishedUp: unFinishedLyricsUpColor,
        unFinishedDown: unFinishedLyricsDownColor,
        unFinishedBorder: unFinishedLyricsBorderColor,
        background: backgroundColor
    })

    signal colorSchemeUpdated(var scheme)

    function updateScheme(scheme) {
        if (scheme.finishedUp !== undefined) finishedLyricsUpColor = scheme.finishedUp;
        if (scheme.finishedDown !== undefined) finishedLyricsDownColor = scheme.finishedDown;
        if (scheme.finishedBorder !== undefined) finishedLyricsBorderColor = scheme.finishedBorder;
        if (scheme.unFinishedUp !== undefined) unFinishedLyricsUpColor = scheme.unFinishedUp;
        if (scheme.unFinishedDown !== undefined) unFinishedLyricsDownColor = scheme.unFinishedDown;
        if (scheme.unFinishedBorder !== undefined) unFinishedLyricsBorderColor = scheme.unFinishedBorder;
        if (scheme.background !== undefined) backgroundColor = scheme.background;
        colorSchemeUpdated(scheme);
    }
}
