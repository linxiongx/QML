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

    onClosing: {
        console.log("程序关闭")
        // 不再需要清理待删除图片，已改为即时删除
    }

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
            idImageNext.opacity = 0;  // 确保顶层图片隐藏
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
                // 翻转效果：使用翻转动画
                imageContainer.isCrossFading = false;

                // 计算旋转中心为窗口中心 (idContainer 中心相对于 imageContainer 的偏移)
                var centerOffsetX = idContainer.width / 2 - imageContainer.x;
                var centerOffsetY = idContainer.height / 2 - imageContainer.y;

                // 启动翻转动画
                imageContainer.startFlipAnimation(strFilePath, centerOffsetX, centerOffsetY);

                // 确保顶层图片隐藏
                idImageNext.opacity = 0;

            } else if (idSlideToolButton.currentEffect === "fade") {
                // 使用方案2：OpacityAnimator 实现交叉淡入淡出
                console.log("触发淡入淡出效果，路径:", strFilePath)
                imageContainer.changeImage(strFilePath);
            } else {
                // 无效果，直接切换图片
                imageContainer.isCrossFading = false;
                idImage.source = "file:///" + strFilePath;
                idImageNext.opacity = 0;
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

                // 底层图片 - 当前显示的图片
                Image
                {
                    id: idImage;
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    opacity: 1;
                    z: 1
                    visible: true

                    // 图片加载状态
                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("主图片加载失败:", source);
                        }
                    }

                    transform: Rotation {
                        id: idImageRotation
                        // 动态设置为窗口中心，将在动画前计算
                        origin.x: imageContainer.width / 2
                        origin.y: imageContainer.height / 2
                    }
                }

                // 顶层图片 - 用于淡入淡出效果
                Image
                {
                    id: idImageNext;
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    opacity: 0;
                    z: 2
                    visible: true

                    // 图片加载状态
                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("次图片加载失败:", source);
                        }
                    }

                    transform: Rotation {
                        id: idImageNextRotation
                        origin.x: imageContainer.width / 2
                        origin.y: imageContainer.height / 2
                        angle: idImageRotation.angle
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
                SequentialAnimation {
                    id: flipAnimation
                    property string newImagePath: ""

                    // 第一步：翻转到90度（图片消失）
                    RotationAnimation {
                        target: idImageRotation
                        property: "angle"
                        from: 0
                        to: 90
                        duration: 250
                        easing.type: Easing.InQuad
                    }

                    // 第二步：切换图片
                    ScriptAction {
                        script: {
                            console.log("翻转动画：切换图片到", flipAnimation.newImagePath)
                            idImage.source = "file:///" + flipAnimation.newImagePath
                        }
                    }

                    // 第三步：从270度翻转回360度（0度）
                    RotationAnimation {
                        target: idImageRotation
                        property: "angle"
                        from: 270
                        to: 360
                        duration: 250
                        easing.type: Easing.OutQuad
                    }

                    // 第四步：重置角度为0
                    ScriptAction {
                        script: {
                            idImageRotation.angle = 0
                        }
                    }
                }

                // 启动翻转动画的函数
                function startFlipAnimation(newImagePath, centerOffsetX, centerOffsetY) {
                    console.log("=== startFlipAnimation 被调用 ===")
                    console.log("新图片路径:", newImagePath)

                    // 设置旋转中心
                    idImageRotation.origin.x = centerOffsetX
                    idImageRotation.origin.y = centerOffsetY

                    // 设置新图片路径并启动动画
                    flipAnimation.newImagePath = newImagePath
                    flipAnimation.start()
                }

                // 使用方案2：OpacityAnimator 实现交叉淡入淡出（硬件加速）
                property string nextImagePath: ""
                property bool isCrossFading: false  // 添加标志位

                ParallelAnimation {
                    id: crossFadeAnimation

                    OpacityAnimator {
                        target: idImage
                        from: 1
                        to: 0
                        duration: 500
                        easing.type: Easing.OutQuad  // 旧图片缓出
                    }

                    OpacityAnimator {
                        target: idImageNext
                        from: 0
                        to: 1
                        duration: 500
                        easing.type: Easing.InQuad   // 新图片缓入
                    }

                    onStarted: {
                        console.log("=== 动画开始 ===")
                        console.log("idImage opacity:", idImage.opacity, "source:", idImage.source)
                        console.log("idImageNext opacity:", idImageNext.opacity, "source:", idImageNext.source)
                        imageContainer.isCrossFading = true  // 设置标志
                    }

                    onFinished: {
                        console.log("=== 动画完成 ===")
                        console.log("idImage opacity:", idImage.opacity)
                        console.log("idImageNext opacity:", idImageNext.opacity)
                        // 动画完成后，将新图片内容复制到底层
                        idImage.source = idImageNext.source
                        idImage.opacity = 1
                        idImageNext.opacity = 0
                        idImageNext.source = ""
                        imageContainer.isCrossFading = false  // 清除标志
                        console.log("清理完成")
                    }

                    onStopped: {
                        imageContainer.isCrossFading = false  // 确保标志被清除
                    }
                }

                // 切换图片的函数
                function changeImage(newImagePath) {
                    console.log("=== changeImage 被调用 ===")
                    console.log("旧图片:", idImage.source)
                    console.log("新图片路径:", newImagePath)

                    // 如果动画正在运行，先停止
                    if (crossFadeAnimation.running) {
                        console.log("停止正在运行的动画")
                        crossFadeAnimation.stop()
                        // 清理状态
                        idImage.source = idImageNext.source
                        idImage.opacity = 1
                        idImageNext.opacity = 0
                    }

                    // *** 关键：在设置 idImageNext.source 之前就设置标志 ***
                    imageContainer.isCrossFading = true
                    console.log(">>> 设置 isCrossFading = true，防止 idImage 被修改")

                    // 先加载新图片到顶层（opacity为0，不可见）
                    var newSource = "file:///" + newImagePath
                    console.log("设置 idImageNext.source =", newSource)
                    idImageNext.source = newSource

                    // 强制设置初始状态
                    idImage.opacity = 1
                    idImageNext.opacity = 0

                    // 确保两层图片的旋转角度一致
                    idImageNextRotation.angle = idImageRotation.angle

                    console.log("等待新图片加载，当前状态:", idImageNext.status)
                    console.log("idImage.source =", idImage.source)
                    console.log("idImageNext.source =", idImageNext.source)

                    // 定义加载完成后的处理函数
                    var startAnimationWhenReady = function() {
                        console.log(">>> 准备开始动画")
                        console.log(">>> idImage.source =", idImage.source)
                        console.log(">>> idImageNext.source =", idImageNext.source)

                        // 再次确认两个图片源不同
                        if (idImage.source === idImageNext.source) {
                            console.log("!!! 警告：两个图片源相同，取消动画")
                            imageContainer.isCrossFading = false
                            return
                        }

                        // 确保初始状态正确
                        idImage.opacity = 1
                        idImageNext.opacity = 0

                        console.log(">>> 现在开始动画")
                        crossFadeAnimation.start()
                    }

                    // 等待新图片加载完成后开始动画
                    if (idImageNext.status === Image.Ready) {
                        console.log("图片已就绪，立即启动动画流程")
                        startAnimationWhenReady()
                    } else if (idImageNext.status === Image.Loading) {
                        console.log("图片正在加载，等待...")
                        // 如果正在加载，监听加载完成信号
                        var loadHandler = function() {
                            console.log("图片状态变化:", idImageNext.status)
                            if (idImageNext.status === Image.Ready) {
                                console.log("图片加载完成")
                                idImageNext.statusChanged.disconnect(loadHandler)
                                startAnimationWhenReady()
                            } else if (idImageNext.status === Image.Error) {
                                console.log("图片加载失败:", idImageNext.source)
                                idImageNext.statusChanged.disconnect(loadHandler)
                                imageContainer.isCrossFading = false
                            }
                        }
                        idImageNext.statusChanged.connect(loadHandler)
                    } else {
                        console.log("图片状态异常:", idImageNext.status)
                        imageContainer.isCrossFading = false
                    }
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
                        zoomImage(delta, event.x, event.y);
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

    // 缩放函数 - 复用滚轮缩放逻辑
    function zoomImage(delta, centerX, centerY) {
        var newScale = imageScale + delta * scaleStep;

        // 限制缩放范围
        if (newScale >= minScale && newScale <= maxScale) {
            // 计算缩放前的图片中心点
            var oldCenterX = imageContainer.x + imageContainer.width / 2
            var oldCenterY = imageContainer.y + imageContainer.height / 2

            // 更新缩放比例
            imageScale = newScale

            // 计算缩放后的图片中心点
            var newCenterX = imageContainer.x + imageContainer.width / 2
            var newCenterY = imageContainer.y + imageContainer.height / 2

            // 调整位置以保持中心点在图片上的相对位置
            imageContainer.x -= (newCenterX - oldCenterX)
            imageContainer.y -= (newCenterY - oldCenterY)

            // 显示缩放比例
            idScanInfoLayout.visible = true;
            idScanInfoTimer.restart();
        }
    }

    // 裁剪功能相关属性
    property bool canCrop: !idSlideToolButton.isPlaying && idImageRotation.angle === 0
    property bool cropping: false
    property real cropStartX: 0
    property real cropStartY: 0
    property real cropEndX: 0
    property real cropEndY: 0

    // 删除当前图片函数（使用即时删除+撤销）
    function deleteCurrentImage(imagePath) {
        // 幻灯片模式下禁止删除
        if (idSlideToolButton.isPlaying) {
            console.log("幻灯片播放中，禁止删除");
            return;
        }

        console.log("即时删除图片:" + imagePath);

        // 调用C++即时删除函数
        var success = mainCSlide.deleteImageFile(imagePath);

        if (success) {
            console.log("删除操作成功，图片已移动到回收站");

            // 界面立即更新
            filmStrip.updateFilmstripList();

            // 自动切换到下一张图片（如果还有图片）
            if (mainCSlide.getImageList().length > 0) {
                var nextImage = mainCSlide.getImageList()[0];
                idImage.source = "file:///" + nextImage;
                // 重置缩放和位置
                resetImagePosition();
                // 更新主 CSlide 对象的当前图片路径
                mainCSlide.imageSourceChanged(nextImage);
            } else {
                // 如果没有图片了，清空显示
                idImage.source = "";
            }
        } else {
            console.log("删除操作失败");
        }
    }

    // 重置图片位置和缩放
    function resetImagePosition() {
        imageScale = 1.0;
        imageContainer.x = (idContainer.width - imageContainer.width) / 2;
        imageContainer.y = (idContainer.height - imageContainer.height) / 2;
        idImageRotation.angle = 0;
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

        onImageSourcePathChanged: {
            console.log("imageSourcePathChanged - 新路径:", mainCSlide.imageSourcePath);

            // 如果正在进行淡入淡出，不要改变 idImage.source
            if (imageContainer.isCrossFading) {
                console.log(">>> 正在进行交叉淡入淡出，跳过 idImage.source 的修改");
                return;
            }

            if (mainCSlide.imageSourcePath !== "") {
                // 手动添加 file:///前缀
                var imagePath = "file:///" + mainCSlide.imageSourcePath;
                console.log("设置主图片路径:", imagePath);
                idImage.source = imagePath;
            } else {
                idImage.source = "";
            }
        }
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
            // 幻灯片模式下禁止删除
            if (idSlideToolButton.isPlaying) {
                console.log("幻灯片播放中，禁止删除");
                return;
            }

            console.log("Delete key pressed")
            // 获取当前图片路径
            var currentImagePath = idImage.source.toString().replace("file:///", "");
            if (currentImagePath && currentImagePath !== "") {
                // 调用删除函数
                deleteCurrentImage(currentImagePath);
            }
        }
    }

    // 上方向键放大图片
    Shortcut {
        sequence: "Up"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行放大
            var centerX = idContainer.width / 2
            var centerY = idContainer.height / 2
            zoomImage(1, centerX, centerY)
        }
    }

    // 下方向键缩小图片
    Shortcut {
        sequence: "Down"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行缩小
            var centerX = idContainer.width / 2
            var centerY = idContainer.height / 2
            zoomImage(-1, centerX, centerY)
        }
    }

    // WASD键控制 - 复用方向键功能
    // W键 - 上方向键（放大）
    Shortcut {
        sequence: "W"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行放大
            var centerX = idContainer.width / 2
            var centerY = idContainer.height / 2
            zoomImage(1, centerX, centerY)
        }
    }

    // A键 - 左方向键（上一张图片）
    Shortcut {
        sequence: "A"
        context: Qt.ApplicationShortcut
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

    // S键 - 下方向键（缩小）
    Shortcut {
        sequence: "S"
        context: Qt.ApplicationShortcut
        onActivated: {
            // 以窗口中心为缩放中心进行缩小
            var centerX = idContainer.width / 2
            var centerY = idContainer.height / 2
            zoomImage(-1, centerX, centerY)
        }
    }

    // D键 - 右方向键（下一张图片）
    Shortcut {
        sequence: "D"
        context: Qt.ApplicationShortcut
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

    // Ctrl+Z 撤销最后一次删除
    Shortcut {
        sequence: "Ctrl+Z"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("Ctrl+Z pressed - 撤销最后一次删除")

            // 检查是否可以撤销
            if (mainCSlide.canUndo()) {
                // 调用撤销函数
                var success = mainCSlide.undoLastDelete();
                if (success) {
                    console.log("撤销成功");
                    // 更新胶片栏
                    filmStrip.updateFilmstripList();
                    // 界面会自动切换到恢复的图片
                    console.log("撤销后当前图片:", mainCSlide.imageSourcePath);
                } else {
                    console.log("撤销失败");
                }
            } else {
                console.log("没有可撤销的操作");
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
