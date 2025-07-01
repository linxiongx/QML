import QtQuick
import QtQuick.Controls
import "../../../Basic"
import "../../../CommonUI"

Item
{
    height: 180;
    Label
    {
        id: idSysTitleLabel;
        anchors.left: parent.left;
        text: "系统";
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        color: "white"
    }

    //定时关闭
    Item
    {
        id: idTimerCloseItems;
        anchors.left: idSysTitleLabel.right;
        anchors.right: parent.right;
        height: 150;
        anchors.leftMargin: 150;
        Column
        {
            anchors.fill: parent;
            spacing: 20;
            ZYYCheckBox
            {
                id: idSysCbx;
                width: 100; height: 30;
                //textColor: "white";
                anchors.left: parent.left;
                text: "开启定时关闭软件";
            }
            Row
            {
                spacing: 5;
                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "剩余关闭时间";
                    color: "white";
                    font.pixelSize: 16;
                    font.family: BasicConfig.commFont;
                }

                ZYYComboBox
                {
                    maxVisibleItem: 5;
                    //model: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
                    model:[]
                    Component.onCompleted:
                    {
                        for(let i = 0; i < 24; ++i)
                        {
                            model.push(i);
                        }
                    }
                }

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "小时";
                    color: "white";
                    font.pixelSize: 16;
                    font.family: BasicConfig.commFont;
                }

                ZYYComboBox
                {
                    maxVisibleItem: 5;
                    //model: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
                    model: []
                    Component.onCompleted:
                    {
                        for(let i = 0; i <= 59; ++i)
                        {
                            model.push(i);
                        }
                    }
                }

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "分钟";
                    color: "white";
                    font.pixelSize: 16;
                    font.family: BasicConfig.commFont;
                }
             }
            ZYYCheckBox
            {
                width: 100; height: 30;
                //textColor: "white";
                anchors.left: parent.left;
                text: "关闭软件同时关机";
                enabled: false;
            }

            Row
            {
                id: idCloseRow;
                spacing: 10;

                Label
                {
                    id: idCloseLabel;
                    anchors.verticalCenter: parent.verticalCenter;
                    text:"关闭主面板";
                    color: "white";
                    font.bold: true;
                    font.pixelSize: 18;
                    font.family: BasicConfig.commFont;
                }

                ButtonGroup
                {
                    id: btnGroup;
                }

                ZYYRadioButton
                {
                    text: "最小化到系统托盘"
                    anchors.verticalCenter: idCloseLabel.verticalCenter;
                    //autoExclusive:  btnGroup;
                    ButtonGroup.group: btnGroup;
                }

                ZYYRadioButton
                {
                    text: "退出云音乐"
                    anchors.verticalCenter: idCloseLabel.verticalCenter;
                    ButtonGroup.group: btnGroup;
                }
            }
        }
    }
}
