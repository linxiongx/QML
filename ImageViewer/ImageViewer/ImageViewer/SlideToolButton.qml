import QtQuick
import QtQuick.Controls
import org.example.cslide

MyToolButton
{
    id: idToolButton;
    text: qsTr("幻灯片放映");
    imageSource: Qt.resolvedUrl("res/favicon.ico");
    onClicked: idMenu.open();

    property alias marginValue: idMenu.marginValue;
    required property string imageSource;

    signal imageFileSourceChanged(string strFilePath);

    onImageSourceChanged:
    {
        id:idCSlide.imageSourceChanged(imageSource);
    }

    CSlide
    {
        id: idCSlide;
        slideType: CSlide.SEQUENCES;
    }

    ButtonGroup
    {
        id: idTimeGroup
    }
    ButtonGroup
    {
        id: idLoopGroup
    }
    ButtonGroup
    {
        id: idEffectGroup
    }


    Menu
    {
        id: idMenu;

        property int marginValue: 0;

        y: idToolButton.y + idToolButton.height + marginValue;
        x: idToolButton.x;

        MyMenuItem
        {
            text: "停止放映";
            checked: true;
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
            }
        }

        MenuSeparator{}


        MyMenuItem
        {
            text: "3s";
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
                idSlideTimer.interval = 3000;
                idSlideTimer.start();
            }
        }

        MyMenuItem
        {
            text: "10s";
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
                idSlideTimer.interval = 10000;
                idSlideTimer.start();
            }
        }

        MyMenuItem
        {
            text: "30s";
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
                idSlideTimer.interval = 30000;
                idSlideTimer.start();
            }
        }


        MenuSeparator{}

        MyMenuItem
        {
            text: "循环";
            checked: true;
            ButtonGroup.group: idLoopGroup;
            onTriggered:
            {
                idCSlide.slideType = CSlide.SEQUENCES;
            }
        }

        MyMenuItem
        {
            text: "随机";
            ButtonGroup.group: idLoopGroup;
            onTriggered:
            {
                idCSlide.slideType = CSlide.RANDOMIZATION;
            }
        }

        MenuSeparator{}

        MyMenuItem
        {
            text: "无效果";
            checked: true;
            ButtonGroup.group: idEffectGroup;
            onTriggered:
            {
                console.log("点击10s");
            }
        }

        MyMenuItem
        {
            text: "翻转";
            ButtonGroup.group: idEffectGroup;
            onTriggered:
            {
                console.log("点击10s");
            }
        }
    }

    Timer
    {
        id: idSlideTimer;
        repeat: true;
        onTriggered:
        {
            var strFilePath = idCSlide.getImageFile();
            idToolButton.imageFileSourceChanged(strFilePath);
            console.log("strFilePath = " + strFilePath);
        }
    }

}
