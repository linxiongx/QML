import QtQuick
import QtQuick.Controls
import "../../../Basic"
import "../../../CommonUI"

Item
{
    height: idPlayColumn.implicitHeight + idPlayLabel.implicitHeight;

    Label
    {
        id: idPlayLabel;
        anchors.left: parent.left;
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        color: "white"
        text: "播放"
    }

    Column
    {
        id: idPlayColumn
        anchors.left: idPlayLabel.right;
        anchors.right: parent.right;
        anchors.leftMargin: 150;
        spacing: 20;
        ZYYCheckBox
        {
            text: "程序启动时自动播放";
        }
        ZYYCheckBox
        {
            text: '首次进入播客时自动播放 <span style="font-size:14px; color:#aaaaaa;">(不播歌时)</span>';
        }
        ZYYCheckBox
        {
            checked: true;
            text: "程序启动时记住上一次播放进度";
        }
        ZYYCheckBox
        {
            checked: true;
            text: "开启音乐淡入淡出";
        }
        ZYYCheckBox
        {
            text: "平衡不同音频之间的音量大小";
        }
        Column
        {
            spacing: 5;
            Label
            {
                font.pixelSize: 18;
                font.bold: true;
                font.family: "黑体";
                color: "white"
                text: "输出设备"
            }
            ZYYComboBox
            {
                width: 250;
                model: ["DirectSound 主声音驱动程序", "DirectSound 次声音驱动程序", "OpenCv 声音驱动程序"]
            }
        }
        Column
        {
            spacing: 5;
            Label
            {
                font.pixelSize: 18;
                font.bold: true;
                font.family: "黑体";
                color: "white"
                text: "播放列表"
            }

            ButtonGroup
            {
                id: idButtonGroupPlay;
            }
            ZYYRadioButton
            {
                text: "双击播放单曲时，用当前单曲所在的歌曲列表替换播放列表"
                ButtonGroup.group: idButtonGroupPlay;
            }
            ZYYRadioButton
            {
                text: "双击播放单曲时，仅把当前歌曲添加到播放列表"
                ButtonGroup.group: idButtonGroupPlay;
            }
        }
        Column
        {
            spacing: 5;
            Label
            {
                font.pixelSize: 18;
                font.bold: true;
                font.family: "黑体";
                color: "white"
                text: "最近播放记录"
            }
            ZYYCheckBox
            {
                text: "开启后，同步当前账号所在设备名称的最近播放记录"
            }
        }
    }
}
