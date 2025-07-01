import QtQuick
import QtQuick.Controls
import "../../../Basic"
import "../../../CommonUI"

Item
{
    id: idCustomShotCutRoot;

    height: 670;
    Label
    {
        id:idShotcutTitleLabel
        text: "快捷键";
        font.pixelSize: 22;
        font.bold: true;
        font.family: "黑体";
        anchors.left: parent.left;
        color: "white";
    }
    Label
    {
        id: idFuctionLabel;
        text: "功能说明";
        font.pixelSize: 20;
        font.bold: true;
        font.family: "黑体";
        anchors.bottom: idShotcutTitleLabel.bottom;
        anchors.left: idShotcutTitleLabel.right;
        anchors.leftMargin: 120;
        color: "white";
    }
    Label
    {
        id: idShotcutLabel;
        text: "快捷键";
        font.pixelSize: 20;
        font.bold: true;
        font.family: "黑体";
        anchors.bottom: idShotcutTitleLabel.bottom;
        anchors.left: idFuctionLabel.right;
        anchors.leftMargin: 80;
        color: "white";
    }
    Label
    {
        id: idGlobalShotCutLabel;
        text: "全局快捷键";
        font.pixelSize: 20;
        font.bold: true;
        font.family: "黑体";
        anchors.bottom: idShotcutTitleLabel.bottom;
        anchors.left: idShotcutLabel.right;
        anchors.leftMargin: 120;
        color: "white"
    }
    ListModel
    {
        id: idShortcutModel;
        ListElement{description: "播放/暂停"; shotcut: "Ctrl + P"; globalShotcut: "Ctrl + Alt + P"}
        ListElement{description: "上一首"; shotcut: "Ctrl + Left"; globalShotcut: "Ctrl + Alt + Left"}
        ListElement{description: "下一首"; shotcut: "Ctrl + Right"; globalShotcut: "Ctrl + Alt + Right"}
        ListElement{description: "音量加"; shotcut: "Ctrl + Up"; globalShotcut: "Ctrl + Alt + Up"}
        ListElement{description: "音量减"; shotcut: "Ctrl + Down"; globalShotcut: "Ctrl + Alt + Down"}
        ListElement{description: "mini/完整模式"; shotcut: "Ctrl + M"; globalShotcut: "Ctrl + Alt + M"}
        ListElement{description: "喜欢歌曲"; shotcut: "Ctrl + L"; globalShotcut: "Ctrl + Alt + L"}
        ListElement{description: "打开/关闭歌词"; shotcut: "Ctrl + D"; globalShotcut: "Ctrl + Alt + D"}
    }
    Column
    {
        id: idCol;
        anchors.top: idShotcutTitleLabel.bottom;
        anchors.left: idShotcutTitleLabel.right;
        anchors.right: parent.right;
        anchors.leftMargin: 120;
        anchors.topMargin: 30;
        spacing: 20;
        Repeater
        {
            model: idShortcutModel;
            Item
            {
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.rightMargin: 100;
                height: 50;
                Item
                {
                    id: idDescriptionItem
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.bottom: parent.bottom;
                    width: 80;
                    Label
                    {
                        anchors.left: parent.left;
                        text: description;
                        font.pixelSize: 18;
                        font.bold: true;
                        anchors.verticalCenter: parent.verticalCenter;
                        font.family: BasicConfig.commFont;
                        color: "#ddd";
                    }
                }
                ZYYShotcutTextField
                {
                    id: idTextField;
                    anchors.left: idDescriptionItem.right;
                    anchors.leftMargin: 80;
                    anchors.verticalCenter: parent.verticalCenter;
                    width: 150;

                    text: shotcut;
                }
                ZYYShotcutTextField
                {
                    anchors.left: idTextField.right;
                    anchors.leftMargin: 33;
                    anchors.verticalCenter: parent.verticalCenter;
                    width: 200;

                    text: globalShotcut;
                }
             }
        }
    }

    ZYYCheckBox
    {
        id: idGlobalShotCutEnableCheckbox;
        anchors.left: idCol.left;
        anchors.top: idCol.bottom;
        anchors.topMargin: 10;

        text: "启用全局快捷键<font size='3' color='#888888'>(云音乐在后台也能响应)</font>"
        checked: true;
    }

    ZYYCheckBox
    {
        id: idGlobalSystemShotCutEnableCheckbox
        anchors.left: idCol.left;
        anchors.top: idGlobalShotCutEnableCheckbox.bottom;
        anchors.topMargin: 10;

        text: "使用系统媒体快捷键<font size='3' color='#888888'>(播放/暂停、上一首、下一首、停止)</font>"
        checked: true;
    }

    Rectangle
    {
        anchors.left: idGlobalSystemShotCutEnableCheckbox.right;
        anchors.leftMargin: 30;
        anchors.top: idGlobalSystemShotCutEnableCheckbox.top;
        width: idRecoverDefualtText.implicitWidth + 20
        height: idRecoverDefualtText.implicitHeight + 8
        radius: height;
        color: "transparent";
        border.width: 1;
        border.color: "#2e2d31"

        Text
        {
            id: idRecoverDefualtText;
            anchors.centerIn: parent;
            font.pixelSize: 16;
            font.family: BasicConfig.commFont;
            color: "#ceced0";
            text: "默认恢复"
        }

        MouseArea
        {
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: cursorShape = Qt.PointingHandCursor;
            onExited: cursorShape = Qt.ArrowCursor;
            onClicked:
            {
                idShortcutModel.clear();
                idShortcutModel.append({description: "播放/暂停", shotcut: "Ctrl + P", globalShotcut: "Ctrl + Alt + P"});
                idShortcutModel.append({description: "上一首", shotcut: "Ctrl + Left", globalShotcut: "Ctrl + Alt + Left"});
                idShortcutModel.append({description: "下一首", shotcut: "Ctrl + Right", globalShotcut: "Ctrl + Alt + Right"});
                idShortcutModel.append({description: "音量加", shotcut: "Ctrl + Up", globalShotcut: "Ctrl + Alt + Up"});
                idShortcutModel.append({description: "音量减", shotcut: "Ctrl + Down", globalShotcut: "Ctrl + Alt + Down"});
                idShortcutModel.append({description: "mini/完整模式", shotcut: "Ctrl + M", globalShotcut: "Ctrl + Alt + M"});
                idShortcutModel.append({description: "喜欢歌曲", shotcut: "Ctrl + L", globalShotcut: "Ctrl + Alt + L"});
                idShortcutModel.append({description: "打开/关闭歌词", shotcut: "Ctrl + D", globalShotcut: "Ctrl + Alt + D"});
            }
        }
    }
}
