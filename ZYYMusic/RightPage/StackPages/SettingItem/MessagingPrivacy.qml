import QtQuick
import QtQuick.Controls
import "../../../Basic"
import "../../../CommonUI"

//消息与隐私
Item
{
    height: 200;

    Label
    {
        id: idMessageLabel;
        anchors.left: parent.left;
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        color: "white"
        text: "消息与隐私"
    }


    //私信
    Column
    {
        anchors.left: idMessageLabel.right;
        anchors.right: parent.right;
        anchors.leftMargin: 80;
        spacing: 20;

        Item
        {
            anchors.left: parent.left;
            anchors.right: parent.right;
            height: idMessageLabel.implicitHeight;

            Row
            {
                anchors.fill: parent;
                spacing: 0;

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;

                    font.pixelSize: 18;
                    font.bold: true;
                    font.family: "黑体";
                    color: "white"
                    text: "私信"
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "所有人"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "我关注的人"
                    enabled: false;
                }
            }
        }

        //我的听歌排行榜
        Item
        {
            anchors.left: parent.left;
            anchors.right: parent.right;
            height: idMessageLabel.implicitHeight;

            Row
            {
                anchors.fill: parent;
                spacing: 0;

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;

                    font.pixelSize: 18;
                    font.bold: true;
                    font.family: "黑体";
                    color: "white"
                    text: "我的听歌排行榜"
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "所有人可见"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "我关注的人可见"
                    enabled: false;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "仅自己可见"
                    enabled: false;
                }
            }
        }

        //个性化服务
        Item
        {
            anchors.left: parent.left;
            anchors.right: parent.right;
            height: idMessageLabel.implicitHeight;

            Row
            {
                anchors.fill: parent;
                spacing: 0;

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;

                    font.pixelSize: 18;
                    font.bold: true;
                    font.family: "黑体";
                    color: "white"
                    text: "个性化服务"
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "开启"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "关闭(关闭后，即不会使用你的个性化信息提供个性化服务)"
                    enabled: false;
                }

            }
        }

        //通知
        Item
        {
            anchors.left: parent.left;
            anchors.right: parent.right;
            height: idMessageLabel.implicitHeight;

            Row
            {
                anchors.fill: parent;
                spacing: 0;

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;

                    font.pixelSize: 18;
                    font.bold: true;
                    font.family: "黑体";
                    color: "white"
                    text: "通知"
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYCheckBox
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "歌单被收藏"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYCheckBox
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "收到赞"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYCheckBox
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "新粉丝"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYCheckBox
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "每日推荐"
                    checked: true;
                }
            }
        }

        //通知
        Item
        {
            anchors.left: parent.left;
            anchors.right: parent.right;
            height: idMessageLabel.implicitHeight;

            Row
            {
                anchors.fill: parent;
                spacing: 0;

                Label
                {
                    anchors.verticalCenter: parent.verticalCenter;

                    font.pixelSize: 18;
                    font.bold: true;
                    font.family: "黑体";
                    color: "white"
                    text: "通知"
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                ZYYRadioButton
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    text: "我的黑名单"
                    enabled: false;
                    checked: true;
                }

                Item
                {
                    width: 40;
                    height: parent.height;
                }

                Rectangle
                {
                    anchors.verticalCenter: parent.verticalCenter;
                    width:  idLableLookup.implicitWidth + 20
                    height: parent.height - 5;
                    color: "transparent";
                    radius: 10;
                    border.color: "#2e2d31";
                    border.width: 1;
                    Label
                    {
                        id: idLableLookup
                        anchors.centerIn: parent;
                        text: "查看"
                        font.family: BasicConfig.commFont;
                        font.pixelSize: 14;
                        color: "#5b5a61"
                    }
                }
            }
        }
    }
}
