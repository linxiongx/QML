import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../Basic"
import "../CommonUI"

Popup
{
    id: idOtherLoginPopup
    width: 466;
    height: 638;
    clip: true;
    closePolicy: Popup.NoAutoClose;

    background: Rectangle
    {
        anchors.fill: parent;
        color: "#1b1b23";
        radius: 10;
        border.width: 1;
        border.color: "#75777f";

        Image
        {
            id: idQrcodeMini;
            anchors.left: parent.left;
            anchors.top: parent.top;
            scale: 0.5;
            anchors.leftMargin: -60;
            anchors.topMargin: -60;
            source: "qrc:/Image/Res/MainLogin/QrCode.png"
            MouseArea
            {
                anchors.left: parent.left;
                anchors.top: parent.top;
                width: 132 / 2 + 60;
                height: 138 / 2 + 60;
                hoverEnabled:  true;
                onEntered:
                {
                    cursorShape = Qt.PointingHandCursor;
                }
                onExited:
                {
                    cursorShape = Qt.ArrowCursor;
                }
                onClicked:
                {
                    idLoginByOtherMainsPopup.close();
                    idLoginPopup.open();
                }
            }
        }
        Canvas
        {
            id: idCanvas;
            anchors.fill: parent;
            onPaint:
            {
                let ctx = getContext("2d");
                ctx.beginPath();
                ctx.moveTo(132, 1);
                ctx.lineTo(1, 138);
                ctx.lineTo(132, 138);
                ctx.lineTo(132, 1);
                ctx.fillStyle = "#1b1b23";
                ctx.fill();
            }
        }

        //关闭
        Image
        {
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.topMargin: 10;
            anchors.rightMargin: 10;
            source: "qrc:/Image/Res/title/close.png";
            width: 32; height: 32;

            MouseArea
            {
                anchors.fill: parent;
                hoverEnabled: true;
                onEntered:
                {
                    cursorShape = Qt.PointingHandCursor;
                }
                onExited:
                {
                    cursorShape = Qt.ArrowCursor;
                }
                onClicked:
                {
                    idLoginByOtherMainsPopup.close();
                }
            }
        }

        Row
        {
            id: idTitleRowItems;
            anchors.top: idQrcodeMini.top;
            anchors.topMargin: 130;
            anchors.horizontalCenter: parent.horizontalCenter;
            spacing: 5;
            Image
            {
                width: 48;
                height: 48;
                source: "qrc:/Image/Res/MainLogin/ZyyMusic.png";
            }
            Label
            {
                text: "网易云音乐"
                color: "white";
                font.bold: true;
                font.pixelSize: 32;
                font.family: BasicConfig.commFont;
                anchors.verticalCenter: parent.verticalCenter;
            }
        }

        Column
        {
            id: idLonginClumnItems
            anchors.top: idTitleRowItems.bottom;
            anchors.topMargin: 40;
            anchors.horizontalCenter: parent.horizontalCenter;
            spacing: 20;

            //手机号输入框
            Item
            {
                width: 400;
                height: 40;

                TextField
                {
                    id: idTelNumberTextFiled;
                    anchors.fill: parent;
                    font.pixelSize: parent.height / 2;
                    color: BasicConfig.fieldTextColor;
                    placeholderText: "请输入手机号";
                    placeholderTextColor: "#a1a1a3";
                    font.family: BasicConfig.commFont;
                    verticalAlignment: Text.AlignVCenter;
                    leftPadding: 70;
                    background: Rectangle
                    {
                        anchors.fill:parent;
                        radius: idTelNumberTextFiled.height / 2;
                        color: "#222"
                        border.width: 1;
                        border.color: "#d9d9da";
                        Item
                        {
                            id: idCountryTelTextItem;
                            anchors.top: parent.top;
                            anchors.bottom: parent.bottom;
                            width: idTelNumberTextFiled.leftPadding;
                            Row
                            {
                                anchors.centerIn: parent;
                                spacing: 10;
                                Label
                                {
                                    id: idCountryTelNumText;
                                    text: "+86";
                                    color: "white";
                                    font.bold: true;
                                    font.pixelSize: 16;
                                    font.family: BasicConfig.commFont;
                                    anchors.verticalCenter: parent.verticalCenter;
                                }
                                Label
                                {
                                    id: idArrowLabel;
                                    text: ">";
                                    rotation: 90;
                                    color: "white";
                                    font.bold: true;
                                    font.pixelSize: 16;
                                    font.family: BasicConfig.commFont;
                                    anchors.verticalCenter: parent.verticalCenter;
                                }
                            }
                        }
                    }

                    Item
                    {
                        anchors.top: parent.top;
                        anchors.left: parent.left;
                        width: parent.leftPadding;
                        height: parent.height;
                        MouseArea
                        {
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onEntered:
                            {
                                cursorShape = Qt.PointingHandCursor;
                            }
                            onExited:
                            {
                                cursorShape = Qt.ArrowCursor
                            }
                            onClicked:
                            {
                                idTelNumberTextFiled.focus = false;
                                idTelDatasPop.open();
                            }

                        }
                    }
                }

                ListModel
                {
                    id: idNationFlagsModel;
                    ListElement{src:"qrc:/Image/Res/MainLogin/China.png"; country: "中国"; tel:"+86"}
                    ListElement{src:"qrc:/Image/Res/MainLogin/Usa.png"; country: "美国"; tel:"+1"}
                }
                Popup
                {
                    id: idTelDatasPop;
                    width: idTelNumberTextFiled.width;
                    y: idTelNumberTextFiled.height + 5;
                    height: 370;
                    background: Rectangle
                    {
                        anchors.fill: parent;
                        radius: 10;
                        color: "#2d2d37";
                        clip: true;

                        ListView
                        {
                            id: idListView;
                            anchors.fill: parent;
                            anchors.topMargin: 15;
                            model: idNationFlagsModel;
                            ScrollBar.vertical: ScrollBar
                            {
                                anchors.right: parent.right;
                                anchors.rightMargin: 5;
                                width: 10;
                                contentItem: Rectangle
                                {
                                    visible: parent.active;
                                    implicitWidth: 10;
                                    radius: 4;
                                    color: "#42424b"
                                }
                            }
                            delegate: Rectangle
                            {
                                height: 50;
                                anchors.left: parent.left;
                                anchors.right: parent.right;
                                //anchors.rightMargin: 12;
                                color: "transparent";
                                //国旗
                                Image
                                {
                                    id: idNationFlagImg;
                                    anchors.left: parent.left;
                                    anchors.leftMargin: 20;
                                    anchors.verticalCenter: parent.verticalCenter;
                                    //width: idNationFlagRe;
                                    height: 32;
                                    width: 32;
                                    source: src;
                                }
                                //国家
                                Text
                                {
                                    id: idCountryText;
                                    color: "#b7b7ba";
                                    font.bold: true;
                                    font.pixelSize: 20;
                                    font.family: BasicConfig.commFont;
                                    anchors.left: idNationFlagImg.right;
                                    anchors.leftMargin: 8;
                                    anchors.verticalCenter: parent.verticalCenter;
                                    text: country;
                                }
                                //号码
                                Text
                                {
                                    id: idCountryTel;
                                    color: "#b7b7ba";
                                    font.bold: true;
                                    font.pixelSize: 20;
                                    font.family: BasicConfig.commFont;
                                    anchors.right: parent.right;
                                    anchors.rightMargin:  20;
                                    anchors.verticalCenter: parent.verticalCenter;
                                    text: tel;
                                }
                                MouseArea
                                {
                                    anchors.fill: parent;
                                    hoverEnabled: true;
                                    onEntered:
                                    {
                                        parent.color = "#393943";
                                        cursorShape = Qt.PointingHandCursor;
                                    }
                                    onExited:
                                    {
                                        parent.color = "transparent";
                                        cursorShape = Qt.ArrowCursor;
                                    }
                                    onClicked:
                                    {
                                        idCountryTelNumText.text = idCountryTel.text;
                                        idTelDatasPop.close();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            //密码输入框
            Item
            {
                id: idTextFiledItem;
                width: 400
                height: 40

                Rectangle
                {
                    anchors.fill: parent
                    radius: idTextFiledItem.height / 2
                    color: "#222"
                    border.width: 1
                    border.color: "#d9d9da"

                    TextField
                    {
                        id: idPasswordTextField

                        property bool isShowPassword: false;

                        anchors.fill: parent
                        anchors.rightMargin: 80  // 给右侧按钮留出空间

                        font.pixelSize: idTextFiledItem.height / 2
                        color: "#ffffff"  // 假设文本颜色为白色
                        placeholderText: "请输入密码"
                        placeholderTextColor: "#a1a1a3"
                        verticalAlignment: Text.AlignVCenter
                        echoMode: TextInput.Password
                        leftPadding: idTextFiledItem.height / 2
                        rightPadding: 10
                        background: null
                    }

                    Row
                    {
                        id: idButtonRow
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 0

                        // 清除按钮
                        Rectangle
                        {
                            id: idClearButton
                            width: 28
                            height: 28
                            color: "transparent"
                            visible: idPasswordTextField.text !== ""

                            Image
                            {
                                id: idClearImg
                                anchors.centerIn: parent
                                source: "qrc:/Image/Res/MainLogin/clear.png"
                                width: 24
                                height: 24
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked:  idPasswordTextField.text = ""
                            }
                        }

                        // 显示/隐藏密码按钮
                        Rectangle
                        {
                            id: idToggleButton
                            width: 28
                            height: 28
                            color: "transparent"

                            Image
                            {
                                id: idToggleImg
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                source: idPasswordTextField.isShowPassword ? "qrc:/Image/Res/MainLogin/OpenEye.png" : "qrc:/Image/Res/MainLogin/CloseEye.png"
                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked:
                                {
                                    idPasswordTextField.isShowPassword = !idPasswordTextField.isShowPassword
                                    idPasswordTextField.echoMode = idPasswordTextField.isShowPassword ? TextInput.Normal : TextInput.Password
                                }
                            }
                        }
                    }
                }
            }

            Item
            {
                id: idLonginItems;
                height: 25;
                anchors.left: idTextFiledItem.left;
                anchors.right: idTextFiledItem.right;

                ZYYCheckBox
                {
                    text: "记住密码";
                }

                //忘记密码、验证码登陆
                Row
                {
                    id: idForgetPwdRow;
                    width: 210;
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter;
                    spacing: 10;
                    Label
                    {
                        id: idForgetPwdLabel;
                        color: "#818186";
                        text: "忘记密码";
                        font.pixelSize: 20;
                        font.family: BasicConfig.commFont;
                        anchors.verticalCenter: parent.verticalCenter;
                        MouseArea
                        {
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onEntered:
                            {
                                cursorShape = Qt.PointingHandCursor;
                            }
                            onExited:
                            {
                                cursorShape = Qt.ArrowCursor;
                            }
                        }
                    }
                    Rectangle
                    {
                        width: 1;
                        height: 20;
                        color: "#818186";
                        anchors.verticalCenter: parent.verticalCenter;
                    }
                    Label
                    {
                        id: idCheckCodeLoginLabel;
                        color: "#818186";
                        text: "验证码登陆";
                        font.pixelSize: 20;
                        font.family: BasicConfig.commFont;
                        anchors.verticalCenter: parent.verticalCenter;
                        MouseArea
                        {
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onEntered:
                            {
                                cursorShape = Qt.PointingHandCursor;
                            }
                            onExited:
                            {
                                cursorShape = Qt.ArrowCursor;
                            }
                        }
                    }
                }

                //登陆按键
                Rectangle
                {
                    id: idLoginBtn;
                    height: 50;
                    width: 400;
                    anchors.top: idForgetPwdRow.bottom;
                    anchors.topMargin: 30;
                    anchors.horizontalCenter:  parent.horizontalCenter;
                    radius: height / 2;

                    gradient: Gradient
                    {
                        orientation: Gradient.Horizontal;
                        GradientStop
                        {
                            color: "#e93b63";
                            position: 0;
                        }
                        GradientStop
                        {
                            color: "#e84f50";
                            position: 1;
                        }
                    }
                    Label
                    {
                        color: "white";
                        text: "登陆";
                        font.pixelSize: 24;
                        font.family: BasicConfig.commFont;
                        anchors.centerIn: parent;
                    }
                    MouseArea
                    {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered:
                        {
                            cursorShape = Qt.PointingHandCursor;
                        }
                        onExited:
                        {
                            cursorShape = Qt.ArrowCursor;
                        }
                    }
                }

                //注册按钮
                Label
                {
                    id: idRegisterBtn;
                    color: "#818186";
                    text: "注册";
                    font.pixelSize: 20;
                    font.family: BasicConfig.commFont;
                    anchors.top: idLoginBtn.bottom;
                    anchors.topMargin: 30;
                    anchors.horizontalCenter:  parent.horizontalCenter;
                }

                //其它方式登陆
                Row
                {
                    id: idOtherMethodRow;
                    anchors.top: idRegisterBtn.bottom;
                    anchors.topMargin: 40;
                    spacing: 30;
                    anchors.horizontalCenter: parent.horizontalCenter;

                    //静态数据用Repeater，动态数据用ListView
                    Repeater
                    {
                        model: ["qrc:/Image/Res/MainLogin/weixin.png",
                            "qrc:/Image/Res/MainLogin/qq.png",
                            "qrc:/Image/Res/MainLogin/wangyi.png",
                            "qrc:/Image/Res/MainLogin/weibo.png"
                        ];
                        delegate:Rectangle
                        {
                            width: 40;
                            height: width;
                            radius: width / 2;
                            color: "transparent";
                            border.width: 1;
                            border.color: "#222";
                            Image
                            {
                                id: idLoignMethodIcon;
                                anchors.centerIn: parent;
                                source: modelData;
                                width: 32;
                                height: 32;

                                ColorOverlay
                                {
                                    id: idLoignMethodIconColorOverlay
                                    anchors.fill: parent;
                                    source: idLoignMethodIcon;
                                    visible: false;
                                    color:
                                    {
                                        if(index === 0)
                                            return "#629b4a";
                                        else if(index === 1)
                                            return "#4e8ac0";
                                        else if(index === 2)
                                            return "#9f2c31";
                                        else if(index === 3)
                                            return "#9f2c31";
                                    }
                                }
                            }

                            MouseArea
                            {
                                anchors.fill: parent;
                                hoverEnabled: true;
                                onEntered:
                                {
                                    cursorShape = Qt.PointingHandCursor;
                                    idLoignMethodIconColorOverlay.visible = true;
                                    if(index === 0)
                                    {
                                        parent.color = "#252d28";
                                        parent.border.color = "#2d3a2b";
                                    }
                                    else if(index === 1)
                                    {
                                        parent.color = "#222a38";
                                        parent.border.color = "#263346";
                                    }
                                    else if(index === 2)
                                    {
                                        parent.color = "#251c24";
                                        parent.border.color = "#321e26";
                                    }
                                    else if(index === 3)
                                    {
                                        parent.color = "#251c24";
                                        parent.border.color = "#321e26";
                                    }
                                }
                                onExited:
                                {
                                    cursorShape = Qt.ArrowCursor;
                                    idLoignMethodIconColorOverlay.visible = false;
                                    parent.color = "transparent";
                                    parent.border.color = "#222";
                                }
                            }
                        }
                    }
                }


                //同意条款
                Item
                {
                    anchors.top: idOtherMethodRow.bottom;
                    anchors.topMargin: 30;
                    anchors.left: idLoginBtn.left;
                    anchors.right: idLoginBtn.right;
                    height: 25;
                    MouseArea
                    {
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered:
                        {
                            cursorShape = Qt.PointingHandCursor;
                        }
                        onExited:
                        {
                            cursorShape = Qt.ArrowCursor;
                        }
                    }
                    Row
                    {
                        anchors.fill: parent;
                        spacing: 0;
                        Rectangle
                        {
                            width: 24;
                            height: width;
                            radius: width / 2;
                            border.width: 1;
                            color: selected ? "#eb4d44" : "transparent";
                            property bool selected: false;
                            Label
                            {
                                anchors.centerIn: parent;
                                text: parent.selected ? "√" : "";
                                font.pixelSize: 18;
                                font.family: BasicConfig.commFont;
                            }
                            MouseArea
                            {
                                anchors.fill: parent;
                                hoverEnabled: true;
                                onClicked: parent.selected = !parent.selected;
                            }
                        }

                        Repeater
                        {
                            //model: {"同意"; "《服务条款》"; "《隐私政策》"; "《儿童隐私政策》"}
                            model: 4;
                            Label
                            {
                                font.bold: true;
                                //text: modelData;
                                text:
                                {
                                    if(index === 0)
                                        "同意";
                                    else if(index === 1)
                                        "《服务条款》"
                                    else if(index === 2)
                                        "《隐私政策》"
                                    else if(index === 3)
                                        "《儿童隐私政策》"
                                }
                                color: index > 0 ? "#5d72aa" : "#8e8e92";
                                font.pixelSize: 18;
                                font.family: BasicConfig.commFont;
                                MouseArea
                                {
                                    anchors.fill: parent;
                                    hoverEnabled: true;
                                    onEntered:
                                    {
                                        if(index !== 0)
                                        {
                                            cursorShape = Qt.PointingHandCursor;
                                            parent.opacity = 0.8;
                                        }
                                    }
                                    onExited:
                                    {
                                        parent.opacity = 1.0;
                                        cursorShape = Qt.ArrowCursor;
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
    }
}
