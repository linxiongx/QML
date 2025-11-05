import QtQuick
import QtQuick.Layouts

Item
{
    id: idContainer;

    // 外部属性
    property string text: "桌面背景"
    property string imageSource: Qt.resolvedUrl("res/favicon.ico")
    property bool enabled: true
    property string currentImagePath: ""
    property var slideEngine: null
    property int clickCount: 0
    property string currentStyleName: "拉伸"

    signal clicked
    signal wallpaperRequested(int clickCount)

    implicitWidth: childrenRect.width;
    implicitHeight: childrenRect.height;

    RowLayout
    {
        spacing: 2;

        Text
        {
            id: idText;
            text: idContainer.text;
            opacity: idContainer.enabled ? 1.0 : 0.5
        }

        Item
        {
            implicitWidth: childrenRect.width;
            implicitHeight: childrenRect.height;

            Image
            {
                id: idImage;
                source: idContainer.imageSource;
                opacity: idContainer.enabled ? 1.0 : 0.5
                property real initialY: 0;

                Component.onCompleted:
                {
                    initialY = y;
                }

                Behavior on y
                {
                    NumberAnimation
                    {
                        duration: 100;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        }
    }

    MouseArea
    {
        anchors.fill: parent;
        onClicked:
        {
            if (idContainer.enabled && idContainer.slideEngine) {
                // 获取当前平铺模式名称
                idContainer.currentStyleName = idContainer.slideEngine.getWallpaperStyleName(idContainer.clickCount)

                console.log("设置桌面背景按钮被点击，图片路径:", idContainer.currentImagePath)
                console.log("点击次数:", idContainer.clickCount, "，平铺模式:", idContainer.currentStyleName)

                idContainer.wallpaperRequested(idContainer.clickCount)

                // 增加点击计数，为下一次点击做准备
                idContainer.clickCount = (idContainer.clickCount + 1) % 4
            } else {
                console.log("无幻灯片引擎，无法设置桌面背景")
            }
        }
        onPressed:
        {
            idImage.y = idImage.initialY + 3;
        }
        onReleased:
        {
            idImage.y = idImage.initialY;
        }
        onCanceled:
        {
            idImage.y = idImage.initialY;
        }
    }

    // 更新当前图片路径
    function updateImagePath(imagePath) {
        if (imagePath && imagePath !== "") {
            // 移除 file:/// 前缀
            idContainer.currentImagePath = imagePath.toString().replace("file:///", "")
            idContainer.enabled = true

            // 重置点击计数
            resetClickCount()
        } else {
            idContainer.currentImagePath = ""
            idContainer.enabled = false
        }
    }

    // 重置点击计数
    function resetClickCount() {
        idContainer.clickCount = 0
        idContainer.currentStyleName = "拉伸"
    }
}