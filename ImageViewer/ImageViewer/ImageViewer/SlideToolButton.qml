import QtQuick
import QtQuick.Controls
import org.example.cslide
 import QtQuick.Effects

MyToolButton
{
    id: idToolButton;
    text: qsTr("幻灯片放映");
    imageSource: Qt.resolvedUrl("res/favicon.ico");
    onClicked: idMenu.open();


    property alias marginValue: idMenu.marginValue;
    required property string imageSource;
    property CSlide slideEngine;
    property string currentEffect: "none";
    property bool isPlaying: idSlideTimer.running
    onIsPlayingChanged: {
        slidePlayingChanged(isPlaying)
    }
    property int slideInterval: idSlideTimer.interval;

    signal imageFileSourceChanged(string strFilePath);
    signal slidePlayingChanged(bool isPlaying);

    onImageSourceChanged:
    {
        if (slideEngine) {
            slideEngine.imageSourceChanged(imageSource);
        }
    }

    // 使用外部传入的 slideEngine 而不是创建新的 CSlide 实例
    // 这样可以确保键盘快捷键和幻灯片播放使用同一个图片列表和状态

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

        width: 180

        palette.window: "#505050"

        property int marginValue: 0;

        y: idToolButton.y + idToolButton.height + marginValue;
        x: idToolButton.x - 130;

        MyMenuItem
        {
            id: idStopSlide
            text: "停止放映";
            checked: true;
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
            }
        }

       //MenuSeparator{}
        Rectangle {
            width: parent.width
            height: 1
            color: Qt.rgba(0, 0, 0, 0.3)   // 线条颜色
            opacity: 0.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.leftMargin: 8
            anchors.rightMargin: 8
        }



        MyMenuItem
        {
            id:idSlide_1s
            text: "1s";
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
                idSlideTimer.interval = 1000;
                idSlideTimer.start();
            }
        }


        MyMenuItem
        {
            id:idSlide_3s
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
            id:idSlide_10s
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
            id:idSlide_30s
            text: "30s";
            ButtonGroup.group: idTimeGroup;
            onTriggered:
            {
                idSlideTimer.stop();
                idSlideTimer.interval = 30000;
                idSlideTimer.start();
            }
        }


        //MenuSeparator{}
         Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0, 0, 0, 0.3)   // 线条颜色
             opacity: 0.8
             anchors.horizontalCenter: parent.horizontalCenter
             anchors.leftMargin: 8
             anchors.rightMargin: 8
         }

        MyMenuItem
        {
            text: "循环";
            checked: true;
            ButtonGroup.group: idLoopGroup;
            onTriggered:
            {
                if (slideEngine) {
                    slideEngine.slideType = CSlide.SEQUENCES;
                }
            }
        }

        MyMenuItem
        {
            text: "随机";
            ButtonGroup.group: idLoopGroup;
            onTriggered:
            {
                if (slideEngine) {
                    slideEngine.slideType = CSlide.RANDOMIZATION;
                }
            }
        }

        MyMenuItem
        {
            text: "伪随机";
            ButtonGroup.group: idLoopGroup;
            onTriggered:
            {
                if (slideEngine) {
                    slideEngine.slideType = CSlide.PSEUDO_RANDOM;
                }
            }
        }

        //MenuSeparator{}
         Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0, 0, 0, 0.3)   // 线条颜色
             opacity: 0.8
             anchors.horizontalCenter: parent.horizontalCenter
             anchors.leftMargin: 8
             anchors.rightMargin: 8
         }

        MyMenuItem
        {
            text: "无效果";
            checked: true;
            ButtonGroup.group: idEffectGroup;
            onTriggered:
            {
                idToolButton.currentEffect = "none";
            }
        }

        MyMenuItem
        {
            text: "翻转";
            ButtonGroup.group: idEffectGroup;
            onTriggered:
            {
                idToolButton.currentEffect = "flip";
            }
        }

        MyMenuItem
        {
            text: "缓入缓出";
            ButtonGroup.group: idEffectGroup;
            onTriggered:
            {
                idToolButton.currentEffect = "fade";
            }
        }
    }

    Timer
    {
        id: idSlideTimer;
        repeat: true;
        interval: 3000;
        onTriggered:
        {
            var strFilePath = "";
            if (slideEngine) {
                strFilePath = slideEngine.getImageFile();
            }
            if (strFilePath !== "") {
                idToolButton.imageFileSourceChanged(strFilePath);
            } else {
                // 如果没有获取到图片，停止幻灯片播放
                idSlideTimer.stop();
                console.log("幻灯片播放结束：没有更多图片");
            }
        }
    }

    function startSlideShow() {
        switch(idSlideToolButton.slideInterval)
        {
        case 1000:
                idSlide_1s.checked = true;
            break;
        case 3000:
                idSlide_3s.checked = true;
            break;
        case 10000:
                idSlide_10s.checked = true;
            break;
        case 30000:
                idSlide_30s.checked = true;
            break;
        }
        idSlideTimer.start();
    }

    function stopSlideShow() {
        idSlideTimer.stop();
        idStopSlide.checked = true;
    }

    function setSlideInterval(interval) {
        idSlideTimer.interval = interval;
    }

}
