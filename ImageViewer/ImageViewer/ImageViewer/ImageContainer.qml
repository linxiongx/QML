import QtQuick
import QtQuick.Controls
import org.example.cslide 1.0


Item {
    id: imageContainer

    // 外部属性
    property CSlide slideEngine
    property string currentImageSource: ""
    property real imageScale: 1.0
    property real minScale: 0.1
    property real maxScale: 10.0
    property real scaleStep: 0.1
    property bool canCrop: true

    // 内部属性
    property bool dragging: false
    property bool cropping: false
    property real cropStartX: 0
    property real cropStartY: 0
    property real cropEndX: 0
    property real cropEndY: 0
    property bool isCrossFading: false
    property string nextImagePath: ""

    // 信号
    signal containerImageScaleChanged(real scale)
    signal containerImagePositionChanged(real x, real y)
    signal containerImageCropped(string croppedImagePath)
    signal containerCropRectChanged(real x, real y, real width, real height)

    width: Math.min(idImage.sourceSize.width, parent.width - 20) * imageScale
    height: Math.min(idImage.sourceSize.height, parent.height - 20) * imageScale
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    // 鼠标拖拽移动图片功能
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
                containerCropRectChanged(Math.min(cropStartX, cropEndX),
                               Math.min(cropStartY, cropEndY),
                               Math.abs(cropEndX - cropStartX),
                               Math.abs(cropEndY - cropStartY))
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
                    var croppedImagePath = slideEngine.cropImage(currentImagePath,
                        normalizedRect.x, normalizedRect.y,
                        normalizedRect.width, normalizedRect.height,
                        imageContainer.width, imageContainer.height,
                        imageScale)

                    if (croppedImagePath !== "") {
                        containerImageCropped(croppedImagePath)
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
            imageContainer.x = (parent.width - imageContainer.width) / 2
            imageContainer.y = (parent.height - imageContainer.height) / 2
            // 还原旋转角度
            idImageRotation.angle = 0
        }
    }

    // 底层图片 - 当前显示的图片
    Image {
        id: idImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        opacity: 1
        z: 1
        visible: true

        // 图片加载状态
        onStatusChanged: {
            if (status === Image.Error) {
                console.log("主图片加载失败:", source)
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
    Image {
        id: idImageNext
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        opacity: 0
        z: 2
        visible: true

        // 图片加载状态
        onStatusChanged: {
            if (status === Image.Error) {
                console.log("次图片加载失败:", source)
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

    // 交叉淡入淡出动画
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

    // 公共方法
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

    function resetTransform() {
        imageScale = 1.0
        imageContainer.x = (parent.width - imageContainer.width) / 2
        imageContainer.y = (parent.height - imageContainer.height) / 2
        idImageRotation.angle = 0
    }
}
