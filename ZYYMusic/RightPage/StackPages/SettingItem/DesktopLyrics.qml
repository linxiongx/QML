import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "../../../Basic"
import "../../../CommonUI"

Item {
    anchors.left: parent.left;
    anchors.right: parent.right;
    height: 800;

    Label {
        id: idDestopLyricsLabel;
        anchors.left: parent.left;
        anchors.top: parent.top;
        verticalAlignment: Text.AlignVCenter
        text: "桌面歌词";
        font.pixelSize:  22;
        font.family: "黑体";
        font.bold: true;
        color: "white";
    }

    Column {
        anchors.left: idDestopLyricsLabel.right;
        anchors.leftMargin: 70;
        anchors.right: parent.right;
        anchors.top: idDestopLyricsLabel.top;
        spacing: 30;

        Row {
            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 10;

            ZYYCheckBox {
                text: "启用桌面歌词"
                checked: true;
            }
            ZYYCheckBox {
                text: "启用歌词总在最前"
                checked: true;
            }
            ZYYCheckBox {
                text: "外文歌曲显示翻译"
                checked: true;
            }
            ZYYCheckBox {
                text: "外文歌词显示音译"
            }
        }

        Row {

            anchors.left: parent.left;
            anchors.right: parent.right;
            spacing: 70;

            Repeater {

                model: ListModel {
                    id: idListModel;
                    ListElement{name: "字体";}
                    ListElement{name: "字号";}
                    ListElement{name: "字粗";}
                    ListElement{name: "描边";}
                }

                delegate: Item {
                    width: 100;
                    height: idLabel.implicitHeight + 25 + 10
                    Label {
                        anchors.left: parent.left;
                        anchors.leftMargin: 10;
                        anchors.top: parent.top;
                        id: idLabel;
                        text: name;
                        font.family: "黑体"
                        font.pixelSize: 18;
                        color: "white";
                    }
                    ZYYComboBox {
                        anchors.left: parent.left;
                        anchors.top: idLabel.bottom;
                        anchors.topMargin: 10;

                        height: 25;
                        width: 120;

                        Component.onCompleted:
                        {
                            if(index === 0)
                            {
                                model = ["默认", "仿宋", "华文中宋", "华文范松", "华文新魏", "华文楷体"];
                                defaultText ="默认";
                            }
                            else if(index === 1)
                            {
                                var varModel = [];
                                for(let i = 20; i < 97; ++i)
                                    varModel.push(i);
                                model = varModel;
                                defaultText = 20;
                            }
                            else if(index === 2)
                            {
                                model = ["标准", "加粗"]
                                defaultText = "标准";
                            }
                            else if(index === 3)
                            {
                                model = ["有描边", "无描边"];
                                defaultText = "有描边";
                            }

                        }
                    }
                }
            }
        }

        Item {
            height: 50;
            width: parent.width;

            Label {
                id: idAdjustFormat;
                text: "调整样式";
                font.family: "黑体"
                font.pixelSize: 18;
                color: "white";
            }
            Row {
                anchors.left: parent.left;
                anchors.top: idAdjustFormat.bottom;
                anchors.topMargin: 10;
                spacing: 50;

                Repeater {
                    model: [["单行显示", "多行显示"],["横排显示", "竖排显示"],["左对齐", "右对齐"]]
                    ZYYComboBox {
                        height: 25;
                        width: 120;
                        model: modelData;
                        defaultText: modelData[0];
                    }
                }
            }
        }

        Item {
            height: 50;
            width: parent.width;
            Label {
                id: idChangeColorLabel;
                text: "更改配色方案";
                font.family: "黑体"
                font.pixelSize: 18;
                color: "#ddd";
            }

            Row {
                anchors.left: parent.left;
                anchors.top: idChangeColorLabel.bottom;
                anchors.topMargin: 10;
                spacing: 50;

                ZYYComboBox {
                    model: ["自定义", "周易红", "落日晖", "可爱粉", "清新绿", "活力紫", "温柔黄", "低调灰"]
                    defaultText: "周易红";
                }

                Repeater {
                    model: ["已播放", "未播放"]
                    delegate: Rectangle {
                        radius: 15;
                        width: 150;
                        height: 30;
                        border.width: 1;
                        border.color: "#28282e";
                        color: "#1a1a20"

                        Rectangle {
                            id: colorRect;
                            width: parent.height / 2;
                            height: width;
                            anchors.left: parent.left;
                            anchors.leftMargin: 20;
                            anchors.verticalCenter: parent.verticalCenter;
                            gradient: Gradient {
                                GradientStop { position: 0; color: modelData === "已播放" ?
BasicConfig.finishedLyricsUpColor : BasicConfig.unFinishedLyricsUpColor}
                                GradientStop { position: 1; color: modelData === "已播放" ?
BasicConfig.finishedLyricsDownColor : BasicConfig.unFinishedLyricsDownColor}
                            }
                        }

                        Text {
                            color: "#ddd";
                            text: modelData;
                            font.pixelSize: 20;
                            anchors.left: colorRect.right;
                            anchors.leftMargin: 10;
                            font.family: BasicConfig.commFont;
                            anchors.verticalCenter:  colorRect.verticalCenter;
                        }

                        MouseArea {
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onEntered: cursorShape = Qt.PointingHandCursor;
                            onExited: cursorShape = Qt.ArrowCursor;
                            onClicked: {
                                if (modelData === "已播放") {
                                    finishedPopup.open();
                                } else {
                                    unfinishedPopup.open();
                                }
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: previewItem
            height: 120
            width: parent.width

            Label {
                id: previewLabel
                text: "预览"
                font.family: "黑体"
                font.pixelSize: 18
                color: "#ddd"
                anchors.top: parent.top
                anchors.left: parent.left
            }

            Rectangle {
                anchors.top: previewLabel.bottom
                anchors.topMargin: 20
                anchors.left: previewLabel.left
                anchors.right: parent.right
                anchors.rightMargin: 150
                height: 140
                radius: 10
                border.color: "#ddd"
                border.width: 1
                color: "#1a1a20"

                Canvas {
                    id: previewCanvas
                    anchors.centerIn: parent
                    width: parent.width - 40
                    height: 60

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);

                        var fontSize = Math.min(30, width / 6);
                        ctx.font = fontSize + "px " + (BasicConfig.commFont || "黑体");
                        ctx.textAlign = "center";
                        ctx.textBaseline = "middle";

                        var text = "网易云音乐";
                        var x = width / 2;
                        var y = height / 2;

                        // Left half: finished gradient vertical
                        ctx.save();
                        ctx.beginPath();
                        ctx.rect(0, 0, width / 2, height);
                        ctx.clip();

                        var grad1 = ctx.createLinearGradient(width / 4, 0, width / 4, height);
                        grad1.addColorStop(0.0, BasicConfig.finishedLyricsUpColor || "#ee8784");
                        grad1.addColorStop(1.0, BasicConfig.finishedLyricsDownColor || "#f3b1");
                        ctx.fillStyle = grad1;
                        ctx.fillText(text, x, y);
                        ctx.restore();

                        // Right half: unfinished gradient vertical
                        ctx.save();
                        ctx.beginPath();
                        ctx.rect(width / 2, 0, width / 2, height);
                        ctx.clip();

                        var grad2 = ctx.createLinearGradient(3 * width / 4, 0, 3 * width / 4, height);
                        grad2.addColorStop(0.0, BasicConfig.unFinishedLyricsUpColor || "white");
                        grad2.addColorStop(1.0, BasicConfig.unFinishedLyricsDownColor || "#ddd");
                        ctx.fillStyle = grad2;
                        ctx.fillText(text, x, y);
                        ctx.restore();
                    }

                    Connections {
                        target: BasicConfig
                        function onColorSchemeUpdated(scheme) {
                            previewCanvas.requestPaint();
                        }
                    }
                }
            }
        }

        Popup {
            id: finishedPopup
            modal: true
            anchors.centerIn: parent
            closePolicy: Popup.NoAutoClose
            width: 340
            height: 280
            property color selectedUp
            property color selectedDown

            onOpened: {
                selectedUp = BasicConfig.finishedLyricsUpColor;
                selectedDown = BasicConfig.finishedLyricsDownColor;
            }

            background: Rectangle {
                color: "#1a1a20"
                border.color: "#ddd"
                border.width: 2
                radius: 15
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1f1f25" }
                    GradientStop { position: 1.0; color: "#1a1a20" }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 10
                    width: 25
                    height: 25
                    radius: 15
                    color: "#2a2a30"
                    border.color: "#ddd"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#e74c3c"
                        onExited: parent.color = "#2a2a30"
                        onClicked: finishedPopup.close()
                    }
                }
            }

            Column {
                anchors.fill: parent
                anchors.margins: 30
                anchors.topMargin: 30
                spacing: 25

                Text {
                    text: "已播放颜色设置"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "黑体"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 300
                    height: 50
                    radius: 8
                    color: "#1a1a20"

                    Row {
                        spacing: 8
                        anchors.centerIn: parent

                        Rectangle {
                            width: 80
                            height: 35
                            radius: 5
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: finishedPopup.selectedUp }
                                GradientStop { position: 1.0; color: finishedPopup.selectedDown }
                            }
                        }

                        Rectangle {
                            width: 100
                            height: 35
                            color: "#1a1a20"
                            radius: 5
                            Row {
                                spacing: 5
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    width: 25
                                    height: 25
                                    radius: 3
                                    color: finishedPopup.selectedUp
                                }
                                Text {
                                    text: "上色"
                                    color: "#ddd"
                                    font.pixelSize: 12
                                    font.family: BasicConfig.commFont
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    finishedUpColorDialog.open()
                                }
                            }
                        }

                        Rectangle {
                            width: 100
                            height: 35
                            color: "#1a1a20"
                            radius: 5
                            Row {
                                spacing: 5
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    width: 25
                                    height: 25
                                    radius: 3
                                    color: finishedPopup.selectedDown
                                }
                                Text {
                                    text: "下色"
                                    color: "#ddd"
                                    font.pixelSize: 12
                                    font.family: BasicConfig.commFont
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    finishedDownColorDialog.open()
                                }
                            }
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 120
                    height: 45
                    text: "确认"
                    background: Rectangle {
                        color: "#e74c3c"
                        radius: 8
                        border.color: "#c0392b"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "黑体"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        var scheme = BasicConfig.colorScheme || {};
                        scheme.finishedUp = finishedPopup.selectedUp;
                        scheme.finishedDown = finishedPopup.selectedDown;
                        BasicConfig.updateScheme(scheme);
                        previewCanvas.requestPaint();
                        finishedPopup.close();
                    }
                }
            }
        }

        Popup {
            id: unfinishedPopup
            modal: true
            anchors.centerIn: parent
            closePolicy: Popup.NoAutoClose
            width: 340
            height: 280
            property color selectedUp
            property color selectedDown

            onOpened: {
                selectedUp = BasicConfig.unFinishedLyricsUpColor;
                selectedDown = BasicConfig.unFinishedLyricsDownColor;
            }

            background: Rectangle {
                color: "#1a1a20"
                border.color: "#ddd"
                border.width: 2
                radius: 15
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1f1f25" }
                    GradientStop { position: 1.0; color: "#1a1a20" }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 10
                    width: 25
                    height: 25
                    radius: 15
                    color: "#2a2a30"
                    border.color: "#ddd"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = "#e74c3c"
                        onExited: parent.color = "#2a2a30"
                        onClicked: unfinishedPopup.close()
                    }
                }
            }

            Column {
                anchors.fill: parent
                anchors.margins: 30
                anchors.topMargin: 30
                spacing: 25

                Text {
                    text: "未播放颜色设置"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "黑体"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 300
                    height: 50
                    radius: 8
                    color: "#1a1a20"

                    Row {
                        spacing: 8
                        anchors.centerIn: parent

                        Rectangle {
                            width: 80
                            height: 35
                            radius: 5
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: unfinishedPopup.selectedUp }
                                GradientStop { position: 1.0; color: unfinishedPopup.selectedDown }
                            }
                        }

                        Rectangle {
                            width: 100
                            height: 35
                            color: "#1a1a20"
                            radius: 5
                            Row {
                                spacing: 5
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    width: 25
                                    height: 25
                                    radius: 3
                                    color: unfinishedPopup.selectedUp
                                }
                                Text {
                                    text: "上色"
                                    color: "#ddd"
                                    font.pixelSize: 12
                                    font.family: BasicConfig.commFont
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    unfinishedUpColorDialog.open()
                                }
                            }
                        }

                        Rectangle {
                            width: 100
                            height: 35
                            color: "#1a1a20"
                            radius: 5
                            Row {
                                spacing: 5
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    width: 25
                                    height: 25
                                    radius: 3
                                    color: unfinishedPopup.selectedDown
                                }
                                Text {
                                    text: "下色"
                                    color: "#ddd"
                                    font.pixelSize: 12
                                    font.family: BasicConfig.commFont
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    unfinishedDownColorDialog.open()
                                }
                            }
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 120
                    height: 45
                    text: "确认"
                    background: Rectangle {
                        color: "#e74c3c"
                        radius: 8
                        border.color: "#c0392b"
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "黑体"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        var scheme = BasicConfig.colorScheme || {};
                        scheme.unFinishedUp = unfinishedPopup.selectedUp;
                        scheme.unFinishedDown = unfinishedPopup.selectedDown;
                        BasicConfig.updateScheme(scheme);
                        previewCanvas.requestPaint();
                        unfinishedPopup.close();
                    }
                }
            }
        }

        // 已播放上颜色对话框
        ColorDialog {
            id: finishedUpColorDialog
            title: "选择已播放上颜色"
            selectedColor: BasicConfig.finishedLyricsUpColor
            onAccepted: {
                console.log("已播放上颜色接受: " + selectedColor.toString());
                finishedPopup.selectedUp = selectedColor;
            }
            onRejected: {
                console.log("已播放上颜色取消");
            }
        }

        // 已播放下颜色对话框
        ColorDialog {
            id: finishedDownColorDialog
            title: "选择已播放下颜色"
            selectedColor: BasicConfig.finishedLyricsDownColor
            onAccepted: {
                console.log("已播放下颜色接受: " + selectedColor.toString());
                finishedPopup.selectedDown = selectedColor;
            }
            onRejected: {
                console.log("已播放下颜色取消");
            }
        }

        // 未播放上颜色对话框
        ColorDialog {
            id: unfinishedUpColorDialog
            title: "选择未播放上颜色"
            selectedColor: BasicConfig.unFinishedLyricsUpColor
            onAccepted: {
                console.log("未播放上颜色接受: " + selectedColor.toString());
                unfinishedPopup.selectedUp = selectedColor;
            }
            onRejected: {
                console.log("未播放上颜色取消");
            }
        }

        // 未播放下颜色对话框
        ColorDialog {
            id: unfinishedDownColorDialog
            title: "选择未播放下颜色"
            selectedColor: BasicConfig.unFinishedLyricsDownColor
            onAccepted: {
                console.log("未播放下颜色接受: " + selectedColor.toString());
                unfinishedPopup.selectedDown = selectedColor;
            }
            onRejected: {
                console.log("未播放下颜色取消");
            }
        }
    }
}
