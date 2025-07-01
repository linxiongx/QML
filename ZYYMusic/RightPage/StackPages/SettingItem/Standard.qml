import QtQuick
import QtQuick.Controls
import "../../../Basic"
import "../../../CommonUI"

Item
{
    height: 70;
    Label
    {
        id: idCounterTitleLabel;
        text: "常规";
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        anchors.left: parent.left;
        color: "white";
    }
    Label
    {
        id: idCounterDiscriptionLabel;
        font.pixelSize: 18;
        font.family: BasicConfig.commFont;
        anchors.verticalCenter: idCounterTitleLabel.verticalCenter;
        anchors.left: idCounterTitleLabel.right;
        anchors.leftMargin: 150;
        color: "#e8e8e8"
        textFormat: Text.RichText;
        text: "<span style=\"font-size: 20px;color:white;font-family:'黑体';font-bold:true;\">字体选择</span>
                   <span style=\"font-size: 20px;color:#89898c; font-family:'黑体';\">(如果字体显示不清晰，请在控制面板-字体设置中启动系统Clear Type设置)</span>";
    }

    ZYYComboBox
    {
        anchors.left: idCounterDiscriptionLabel.left;
        anchors.top: idCounterDiscriptionLabel.bottom;
        anchors.topMargin: 20;

        model: ["默认", "仿宋", "华文中宋", "华文仿宋", "华文宋体", "华文新魏", "华文楷体", "华文行书", "花纹楷书", "宋体", "幼圆", "微软雅黑", "新宋体"];

    }
}
