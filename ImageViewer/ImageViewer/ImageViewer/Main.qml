import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.example.cslide 1.0

ApplicationWindow
{
    width: 1367
    height: 836
    visible: true
    title: qsTr("图片浏览器")

    id: root;
    property int marginValue: 5;

    minimumWidth: 500;

    // background: Rectangle {
    //     color: "lightblue"   // 这里改颜色
    // }

    Rectangle
    {
        id: idToolBarRectangle;

        anchors
        {
            left: parent.left;
            right: parent.right;
            top: parent.top;
            leftMargin: root.marginValue;
            rightMargin: root.marginValue;
        }

        height: 30;
        color: "darkgray"

        MyToolButton
        {
            visible: false; //禁用
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.verticalCenter: parent.verticalCenter;
            text: qsTr("EXIF");
            imageSource: Qt.resolvedUrl("res/favicon.ico");
            onClicked: idMyImageInfo.visible = !idMyImageInfo.visible;
        }



        RowLayout
        {
            anchors.right: parent.right;
            anchors.rightMargin: 20;
            layoutDirection: Qt.RightToLeft;
            anchors.verticalCenter: parent.verticalCenter;

            spacing: 15;


            // LockerToolButton
            // {
            //     onClicked:
            //     {
            //         //root.flags = Qt.FramelessWindowHint;
            //     }
            // }

            // CopyToolButton
            // {
            //     marginValue: root.marginValue + 2;
            // }

            // EditToolButton
            // {
            //     marginValue: root.marginValue + 2;
            // }

            // BookmarksToolButton
            // {
            //     marginValue: root.marginValue + 2;
            // }

            RotateToolButton
            {
                id: idRotateToolButton
                //marginValue: root.marginValue + 2;
                onClicked: {
                    // 旋转图片90度，以图片中心为旋转中心
                    idImageRotation.angle = (idImageRotation.angle + 90) % 360;
                }
            }

            SlideToolButton
            {
                id: idSlideToolButton
                marginValue: root.marginValue + 2;

                imageSource: idImage.source;
                slideEngine: mainCSlide;
            }

            // ScanToolButton
            // {
            //     marginValue: root.marginValue + 2;
            // }
        }
    }

    // 左侧胶片栏组件 - 悬浮在图片容器上方
    FilmStrip {
        id: filmStrip
        anchors.left: parent.left
        anchors.top: idToolBarRectangle.bottom
        anchors.bottom: parent.bottom
        slideEngine: mainCSlide
        currentImageSource: idImage.source
        z: 100  // 确保胶片栏在最高层级

        onImageSelected: function(imageSource) {
            idImage.source = imageSource;
            // 重置缩放和位置
            imageScale = 1.0
            imageContainer.x = (idContainer.width - imageContainer.width) / 2
            imageContainer.y = (idContainer.height - imageContainer.height) / 2
        }
    }

    Connections
    {
        target: idSlideToolButton;
        function onImageFileSourceChanged(strFilePath)
        {
            if (idSlideToolButton.currentEffect === "flip") {
                // 先翻转当前图片
                // 计算旋转中心为窗口中心 (idContainer 中心相对于 imageContainer 的偏移)
                var centerOffsetX = idContainer.width / 2 - imageContainer.x;
                var centerOffsetY = idContainer.height / 2 - imageContainer.y;
                idImageRotation.origin.x = centerOffsetX;
                idImageRotation.origin.y = centerOffsetY;

                idFlipAnimation.start();
                // 动画完成后切换图片并立即显示 (一次性连接)
                var flipHandler = function() {
                    idImage.source = "file:///" + strFilePath;
                    idImageRotation.angle = 0; // 重置旋转角度
                    idImage.opacity = 1; // 确保新图片完全显示
                    // 断开此连接，避免重复
                    idFlipAnimation.onStopped.disconnect(flipHandler);
                };
                idFlipAnimation.onStopped.connect(flipHandler);
            } else if (idSlideToolButton.currentEffect === "fade") {
                // 缓入缓出效果
                idFadeOutAnimation.start();
                // 淡出动画完成后切换图片并开始淡入 (一次性连接)
                var fadeHandler = function() {
                    idImage.source = "file:///" + strFilePath;
                    idFadeInAnimation.start();
                    // 断开此连接，避免重复
                    idFadeOutAnimation.onStopped.disconnect(fadeHandler);
                };
                idFadeOutAnimation.onStopped.connect(fadeHandler);
            } else {
                // 无效果，直接切换图片
                idImage.source = "file:///" + strFilePath;
            }
            // 更新主 CSlide 对象的当前图片路径
            mainCSlide.imageSourceChanged(strFilePath);
        }
    }


    Rectangle
    {
        id: idContainer;
        anchors
        {
            top: idToolBarRectangle.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            leftMargin: root.marginValue;
            rightMargin: root.marginValue;
            bottomMargin: root.marginValue;
        }

        color: "black";
        z: 0  // 确保在较低层级

        // 双击容器还原功能
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onDoubleClicked: function(mouse) {
                // 双击容器还原缩放和位置
                imageScale = 1.0
                imageContainer.x = (idContainer.width - imageContainer.width) / 2
                imageContainer.y = (idContainer.height - imageContainer.height) / 2
                // 还原旋转角度
                idImageRotation.angle = 0
            }
        }

        ScrollView
        {
            id: idScrollView;

            anchors.fill: parent;

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            clip: true;
            wheelEnabled: false;

            Item {
                id: imageContainer
                width: Math.min(idImage.sourceSize.width, idContainer.width - 20) * imageScale;
                height: Math.min(idImage.sourceSize.height, idContainer.height - 20) * imageScale;
                x: (idContainer.width - width) / 2;
                y: (idContainer.height - height) / 2;

                // 鼠标拖拽移动图片功能
                property bool dragging: false

                MouseArea {
                    id: dragMouseArea
                    anchors.fill: parent
                    cursorShape: {
                        if (cropping) {
                            return Qt.CrossCursor
                        } else if (parent.dragging) {
                            return Qt.ClosedHandCursor
                        } else {
                            return Qt.ArrowCursor
                        }
                    }
                    drag.target: parent.dragging ? parent : null
                    drag.axis: Drag.XAndYAxis
                    drag.threshold: 0 // 立即开始拖拽，无延迟
                    drag.smoothed: false // 禁用平滑，提高响应速度
                    preventStealing: true // 防止事件被窃取
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onPressed: function(mouse) {
                        if (mouse.button === Qt.LeftButton) {
                            parent.dragging = true
                        } else if (mouse.button === Qt.RightButton && canCrop) {
                            // 开始裁剪选区
                            cropping = true
                            cropStartX = mouse.x
                            cropStartY = mouse.y
                            cropEndX = mouse.x
                            cropEndY = mouse.y
                        }
                    }

                    onPositionChanged: function(mouse) {
                        if (cropping) {
                            // 更新选区结束位置
                            cropEndX = mouse.x
                            cropEndY = mouse.y
                        }
                    }

                    onReleased: function(mouse) {
                        if (mouse.button === Qt.LeftButton) {
                            parent.dragging = false
                        } else if (mouse.button === Qt.RightButton && cropping) {
                            // 执行裁剪操作
                            if (cropStartX !== cropEndX && cropStartY !== cropEndY) {
                                var currentImagePath = idImage.source.toString().replace("file:///", "")
                                var normalizedRect = getNormalizedCropRect()
                                var croppedImagePath = mainCSlide.cropImage(currentImagePath,
                                    normalizedRect.x, normalizedRect.y,
                                    normalizedRect.width, normalizedRect.height,
                                    imageContainer.width, imageContainer.height,
                                    imageScale)

                                if (croppedImagePath !== "") {
                                    // 显示裁剪后的图片，并重置为原始状态
                                    imageScale = 1.0
                                    idImage.source = ""
                                    idImage.source = "file:///" + croppedImagePath

                                    // 等待图片加载完成后居中显示
                                    var centerImage = function() {
                                        imageContainer.x = (idContainer.width - imageContainer.width) / 2
                                        imageContainer.y = (idContainer.height - imageContainer.height) / 2
                                        idImage.sourceSizeChanged.disconnect(centerImage)
                                    }
                                    idImage.sourceSizeChanged.connect(centerImage)
                                }
                            }
                            cropping = false
                        }
                    }

                    onCanceled: {
                        parent.dragging = false
                        cropping = false
                    }

                    onDoubleClicked: function(mouse) {
                        // 双击还原缩放和位置
                        imageScale = 1.0
                        imageContainer.x = (idContainer.width - imageContainer.width) / 2
                        imageContainer.y = (idContainer.height - imageContainer.height) / 2
                        // 还原旋转角度
                        idImageRotation.angle = 0
                    }
                }

                Image
                {
                    id: idImage;
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    opacity: 1;

                    transform: Rotation {
                        id: idImageRotation
                        // 动态设置为窗口中心，将在动画前计算
                        origin.x: imageContainer.width / 2
                        origin.y: imageContainer.height / 2
                    }
                }

                // 裁剪选区显示
                Rectangle {
                    id: cropRect
                    visible: cropping
                    x: Math.min(cropStartX, cropEndX)
                    y: Math.min(cropStartY, cropEndY)
                    width: Math.abs(cropEndX - cropStartX)
                    height: Math.abs(cropEndY - cropStartY)
                    color: "transparent"
                    border.color: "red"
                    border.width: 2
                    z: 10
                }

                ParallelAnimation
                {
                    id: idImageAnimation;

                    RotationAnimation
                    {
                        target: imageContainer;
                        properties: "x";
                        from: idScrollView.width;
                        to: imageContainer.x;
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }

                    NumberAnimation
                    {
                        target: idImage;
                        properties: "opacity";
                        from: 0;
                        to: 1;
                        duration: 300;
                    }
                }

                // 翻转动画
                SequentialAnimation
                {
                    id: idFlipAnimation;

                    ParallelAnimation
                    {
                        RotationAnimation
                        {
                            target: idImageRotation;
                            property: "angle";
                            from: 0;
                            to: 180;
                            duration: 500;
                            easing.type: Easing.InOutQuad;
                        }

                        NumberAnimation
                        {
                            target: idImage;
                            property: "opacity";
                            from: 1;
                            to: 0;
                            duration: 500;
                        }
                    }
                }

                // 淡出动画
                NumberAnimation
                {
                    id: idFadeOutAnimation;
                    target: idImage;
                    property: "opacity";
                    from: 1;
                    to: 0;
                    duration: 500;
                    easing.type: Easing.OutQuad;
                }

                // 淡入动画
                NumberAnimation
                {
                    id: idFadeInAnimation;
                    target: idImage;
                    property: "opacity";
                    from: 0;
                    to: 1;
                    duration: 500;
                    easing.type: Easing.InQuad;
                }
            }

            DropArea
            {
                id: idDropArea;
                anchors.fill: parent;

                // 鼠标滚轮缩放功能
                WheelHandler {
                    onWheel: function(event) {
                        // 滚轮缩放图片
                        var delta = event.angleDelta.y / 120; // 标准化滚轮增量
                        var newScale = imageScale + delta * scaleStep;

                        // 限制缩放范围
                        if (newScale >= minScale && newScale <= maxScale) {
                            // 计算鼠标位置相对于图片容器的坐标
                            var mouseX = event.x
                            var mouseY = event.y

                            // 计算缩放前的图片中心点
                            var oldCenterX = imageContainer.x + imageContainer.width / 2
                            var oldCenterY = imageContainer.y + imageContainer.height / 2

                            // 更新缩放比例
                            imageScale = newScale

                            // 计算缩放后的图片中心点
                            var newCenterX = imageContainer.x + imageContainer.width / 2
                            var newCenterY = imageContainer.y + imageContainer.height / 2

                            // 调整位置以保持鼠标位置在图片上的相对位置
                            imageContainer.x -= (newCenterX - oldCenterX)
                            imageContainer.y -= (newCenterY - oldCenterY)

                            // 显示缩放比例
                            idScanInfoLayout.visible = true;
                            idScanInfoTimer.restart();
                        }
                    }
                }

                onDropped: (drop)=>
                           {
                               if(drop.hasUrls)
                               {
                                   for(var i = 0; i < drop.urls.length; ++i)
                                   {
                                       var url = drop.urls[i].toString();
                                       var extension = url.split('.').pop().toLowerCase();
                                       if(["jpg", "png", "gif"].indexOf(extension) !== -1)
                                       {
                                           idImage.source = drop.urls[0];
                                           return;
                                       }
                                   }
                               }
                           }
            }
        }
    }

    // 图片缩放相关属性
    property real imageScale: 1.0
    property real minScale: 0.1
    property real maxScale: 10.0
    property real scaleStep: 0.1

    // 裁剪功能相关属性
    property bool canCrop: !idSlideToolButton.isPlaying && idImageRotation.angle === 0
    property bool cropping: false
    property real cropStartX: 0
    property real cropStartY: 0
    property real cropEndX: 0
    property real cropEndY: 0

    // 删除当前图片函数
    function deleteCurrentImage(imagePath) {
        console.log("删除图片:" + imagePath);

        // 在删除前获取下一张图片
        var nextImage = mainCSlide.getImageFile();
        console.log("下一张图片:" + nextImage);

        // 调用C++删除函数
        var success = mainCSlide.deleteImageFile(imagePath);

        if (success) {
            console.log("删除成功");

            // 更新图片显示
            if (mainCSlide.getImageList().length > 0) {
                // 显示下一张图片（如果获取到了）
                if (nextImage !== "" && nextImage !== imagePath) {
                    idImage.source = "file:///" + nextImage;
                    // 重置缩放和位置
                    imageScale = 1.0;
                    imageContainer.x = (idContainer.width - imageContainer.width) / 2;
                    imageContainer.y = (idContainer.height - imageContainer.height) / 2;
                    // 更新主 CSlide 对象的当前图片路径
                    mainCSlide.imageSourceChanged(nextImage);
                } else {
                    // 如果没有获取到下一张，显示第一张
                    var firstImage = mainCSlide.getImageList()[0];
                    idImage.source = "file:///" + firstImage;
                    // 重置缩放和位置
                    imageScale = 1.0;
                    imageContainer.x = (idContainer.width - imageContainer.width) / 2;
                    imageContainer.y = (idContainer.height - imageContainer.height) / 2;
                    // 更新主 CSlide 对象的当前图片路径
                    mainCSlide.imageSourceChanged(firstImage);
                }
            } else {
                // 如果没有图片了，清空显示
                idImage.source = "";
            }
        } else {
            console.log("删除失败");
        }
    }

    // 裁剪功能辅助函数
    function getNormalizedCropRect() {
        var rect = {
            x: Math.min(cropStartX, cropEndX),
            y: Math.min(cropStartY, cropEndY),
            width: Math.abs(cropEndX - cropStartX),
            height: Math.abs(cropEndY - cropStartY)
        }

        // 确保选区在图片范围内
        rect.x = Math.max(0, Math.min(rect.x, imageContainer.width))
        rect.y = Math.max(0, Math.min(rect.y, imageContainer.height))
        rect.width = Math.min(rect.width, imageContainer.width - rect.x)
        rect.height = Math.min(rect.height, imageContainer.height - rect.y)

        return rect
    }


    CSlide {
        id: mainCSlide
    }

    // 键盘事件处理
    Shortcut {
        sequence: "Left"
        onActivated: {
            var prevImage = mainCSlide.getPrevImageFile()
            if (prevImage !== "") {
                idImage.source = "file:///" + prevImage
                // 重置缩放和位置
                imageScale = 1.0
                imageContainer.x = (idContainer.width - imageContainer.width) / 2
                imageContainer.y = (idContainer.height - imageContainer.height) / 2
                // 更新主 CSlide 对象的当前图片路径
                mainCSlide.imageSourceChanged(prevImage);
            }
        }
    }

    Shortcut {
        sequence: "Right"
        onActivated: {
            var nextImage = mainCSlide.getImageFile()
            if (nextImage !== "") {
                idImage.source = "file:///" + nextImage
                // 重置缩放和位置
                imageScale = 1.0
                imageContainer.x = (idContainer.width - imageContainer.width) / 2
                imageContainer.y = (idContainer.height - imageContainer.height) / 2
                // 更新主 CSlide 对象的当前图片路径
                mainCSlide.imageSourceChanged(nextImage);
            }
        }
    }

    // 空白键控制幻灯片开始/暂停
    Shortcut {
        sequence: "Space"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("onActivated   ")
            if (idSlideToolButton.isPlaying) {
                // 如果正在播放，则暂停
                idSlideToolButton.stopSlideShow();
            } else {
                // 如果已暂停，则开始播放（使用当前设置的间隔时间）
                if (idSlideToolButton.slideInterval > 0) {
                    idSlideToolButton.startSlideShow();
                } else {
                    // 如果没有设置间隔时间，默认使用3秒
                    idSlideToolButton.setSlideInterval(3000);
                    idSlideToolButton.startSlideShow();
                }
            }
        }
    }

    // Delete键删除当前图片
    Shortcut {
        sequence: "Delete"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Delete key pressed")
            // 获取当前图片路径
            var currentImagePath = idImage.source.toString().replace("file:///", "");
            if (currentImagePath && currentImagePath !== "") {
                // 调用删除函数
                deleteCurrentImage(currentImagePath);
            }
        }
    }

    // 图片信息组件
    MyImageInfo {
        id: idMyImageInfo
        anchors {
            top: idToolBarRectangle.bottom
            right: parent.right
            topMargin: 10
            rightMargin: 10
        }
        visible: false
        imageSource: idImage.source
        scaleValue: Math.round(imageScale * 100)
    }



    //显示放大系数
    Item
    {
        id: idScanInfoLayout;
        anchors.centerIn: parent;
        visible: false;
        Rectangle
        {
            id: idScaleRect;
            width: 240;
            height: 60;
            anchors.centerIn: parent;
            radius: 5;
            color: "black"
            opacity: 0.7;
        }

        Text
        {
            id: idScanInfoText;
            text: Math.round(imageScale * 100) + "%";
            anchors.centerIn: idScaleRect;
            font.pointSize: 18;
            color: "white"
            opacity: 1;
        }

        Timer
        {
            id: idScanInfoTimer;
            interval: 1000;
            repeat: false;
            onTriggered: idScanInfoLayout.visible = false;
        }
    }

}
