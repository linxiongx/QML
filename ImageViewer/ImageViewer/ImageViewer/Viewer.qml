import QtQuick
import QtQuick.Controls

/**
 * ImageViewer 组件 - 核心图片显示和交互逻辑
 * 职责：处理图片显示、缩放、平移、旋转、裁剪等交互
 *
 * 属性：
 *   - imageSource: 当前图片路径
 *   - imageScale: 缩放比例
 *   - slideEngine: CSlide 引擎
 *   - minScale, maxScale: 缩放范围
 *
 * 信号：
 *   - zoomChanged(real scale): 缩放值改变
 *   - imageCropped(string croppedPath): 图片被裁剪
 *   - imageRotated(int angle): 图片被旋转
 *
 * 方法：
 *   - resetZoom(): 重置缩放和位置
 *   - zoomImage(delta, centerX, centerY): 缩放图片
 */

Rectangle {
    id: imageViewer

    color: "black"
    z: 0

    // 外部属性接口
    property url imageSource: ""
    property real imageScale: 1.0
    property real minScale: 0.1
    property real maxScale: 10.0
    property real scaleStep: 0.1
    property var slideEngine: null
    property int currentRotationAngle: 0

    // 裁剪相关属性
    property bool canCrop: !isSlidePlayingInternal && currentRotationAngle === 0
    property bool cropping: false
    property real cropStartX: 0
    property real cropStartY: 0
    property real cropEndX: 0
    property real cropEndY: 0
    property bool isSlidePlayingInternal: false

    // 信号定义
    signal zoomChanged(real scale)
    signal imageCropped(string croppedPath)
    signal imageRotated(int angle)

    // 双击容器还原功能
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onDoubleClicked: {
            resetZoom()
        }
    }

    ScrollView {
        id: scrollView

        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        clip: true
        wheelEnabled: false

        Item {
            id: imageContainer
            width: Math.min(idImage.sourceSize.width, imageViewer.width - 20) * imageScale
            height: Math.min(idImage.sourceSize.height, imageViewer.height - 20) * imageScale
            x: (imageViewer.width - width) / 2
            y: (imageViewer.height - height) / 2

            property bool dragging: false

            // 鼠标拖拽和裁剪处理
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
                drag.threshold: 0
                drag.smoothed: false
                preventStealing: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onPressed: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        parent.dragging = true
                    } else if (mouse.button === Qt.RightButton && canCrop) {
                        cropping = true
                        cropStartX = mouse.x
                        cropStartY = mouse.y
                        cropEndX = mouse.x
                        cropEndY = mouse.y
                        cropRect.visible = true
                    }
                }

                onPositionChanged: function(mouse) {
                    if (cropping) {
                        cropEndX = mouse.x
                        cropEndY = mouse.y
                    }
                }

                onReleased: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        parent.dragging = false
                    } else if (mouse.button === Qt.RightButton && cropping) {
                        if (cropStartX !== cropEndX && cropStartY !== cropEndY) {
                            executeCrop()
                        }
                        cropping = false
                        cropRect.visible = false
                    }
                }

                onCanceled: {
                    parent.dragging = false
                    cropping = false
                    cropRect.visible = false
                }

                onDoubleClicked: {
                    resetZoom()
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
                source: imageViewer.imageSource

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("主图片加载失败:", source)
                    }
                }

                transform: Rotation {
                    id: imageRotation
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

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("次图片加载失败:", source)
                    }
                }

                transform: Rotation {
                    id: imageNextRotation
                    origin.x: imageContainer.width / 2
                    origin.y: imageContainer.height / 2
                    angle: imageRotation.angle
                }
            }

            // 裁剪选区显示
            CropSelection {
                id: cropRect
                containerWidth: imageContainer.width
                containerHeight: imageContainer.height
            }

            // 图片动画系统
            ImageAnimations {
                id: imageAnimations
                baseImage: idImage
                nextImage: idImageNext
                baseImageRotation: imageRotation
                nextImageRotation: imageNextRotation
                scrollView: scrollView
            }
        }

        // 拖拽打开文件和滚轮缩放
        DropArea {
            id: dropArea
            anchors.fill: parent

            WheelHandler {
                onWheel: function(event) {
                    var delta = event.angleDelta.y / 120
                    zoomImage(delta, event.x, event.y)
                }
            }

            onDropped: function(drop) {
                if (drop.hasUrls) {
                    for (var i = 0; i < drop.urls.length; ++i) {
                        var url = drop.urls[i].toString()
                        var extension = url.split('.').pop().toLowerCase()
                        if (["jpg", "png", "gif"].indexOf(extension) !== -1) {
                            imageSource = drop.urls[0]

                            // 等待图片加载完成后居中显示
                            var centerImage = function() {
                                resetZoom()
                                idImage.sourceSizeChanged.disconnect(centerImage)
                            }
                            idImage.sourceSizeChanged.connect(centerImage)
                            return
                        }
                    }
                }
            }
        }
    }

    // 缩放图片的函数
    function zoomImage(delta, centerX, centerY) {
        var newScale = imageScale + delta * scaleStep

        if (newScale >= minScale && newScale <= maxScale) {
            var oldCenterX = imageContainer.x + imageContainer.width / 2
            var oldCenterY = imageContainer.y + imageContainer.height / 2

            imageScale = newScale

            var newCenterX = imageContainer.x + imageContainer.width / 2
            var newCenterY = imageContainer.y + imageContainer.height / 2

            imageContainer.x -= (newCenterX - oldCenterX)
            imageContainer.y -= (newCenterY - oldCenterY)

            zoomChanged(imageScale)
        }
    }

    // 重置缩放和位置
    function resetZoom() {
        imageScale = 1.0
        currentRotationAngle = 0
        imageRotation.angle = 0
        imageContainer.x = (width - imageContainer.width) / 2
        imageContainer.y = (height - imageContainer.height) / 2
    }

    // 执行裁剪操作
    function executeCrop() {
        if (!slideEngine) {
            console.warn("slideEngine 未设置")
            return
        }

        var currentImagePath = imageSource.toString().replace("file:///", "")
        var normalizedRect = cropRect.getNormalizedRect()

        var croppedImagePath = slideEngine.cropImage(
            currentImagePath,
            normalizedRect.x, normalizedRect.y,
            normalizedRect.width, normalizedRect.height,
            imageContainer.width, imageContainer.height,
            imageScale
        )

        if (croppedImagePath !== "") {
            imageSource = ""
            imageSource = "file:///" + croppedImagePath

            var centerImage = function() {
                resetZoom()
                idImage.sourceSizeChanged.disconnect(centerImage)
            }
            idImage.sourceSizeChanged.connect(centerImage)

            imageCropped(croppedImagePath)
        }
    }

    // 设置旋转角度
    function setRotationAngle(angle) {
        currentRotationAngle = angle
        imageRotation.angle = angle
        imageNextRotation.angle = angle
        imageRotated(angle)
    }

    // 启动翻转动画
    function startFlipAnimation(newImagePath) {
        var centerOffsetX = width / 2 - imageContainer.x
        var centerOffsetY = height / 2 - imageContainer.y
        imageAnimations.startFlipAnimation(newImagePath, centerOffsetX, centerOffsetY)
    }

    // 启动淡入淡出动画
    function startFadeAnimation(newImagePath) {
        imageAnimations.changeImage(newImagePath)
    }

    // 获取动画组件
    function getAnimations() {
        return imageAnimations
    }

    // 设置幻灯片播放状态
    function setSlidePlaying(isPlaying) {
        isSlidePlayingInternal = isPlaying
    }
}
