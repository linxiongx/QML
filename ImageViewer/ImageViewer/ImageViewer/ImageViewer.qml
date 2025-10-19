import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.example.cslide 1.0

Item
{
    id: root
    property int marginValue: 5

    // 全局属性
    property real imageScale: 1.0
    property real minScale: 0.1
    property real maxScale: 10.0
    property real scaleStep: 0.1

    // background: Rectangle {
    //     color: "lightblue"   // 这里改颜色
    // }

    // 工具栏组件 - 使用新的模块化组件
    MyToolBar {
        id: idToolBarRectangle
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: root.marginValue
            rightMargin: root.marginValue
        }
        marginValue: root.marginValue
        imageSource: idImageViewer.imageSource
        slideEngine: mainCSlide

        onRotateDegreeChanged: function(angle) {
            idImageViewer.setRotationAngle(angle)
        }
    }

    // 获取幻灯片按钮引用（用于快捷键处理）
    property var idSlideToolButton: null

    // 左侧胶片栏组件 - 悬浮在图片容器上方
    FilmStrip {
        id: filmStrip
        anchors.left: parent.left
        anchors.top: idToolBarRectangle.bottom
        anchors.bottom: parent.bottom
        slideEngine: mainCSlide
        currentImageSource: idImageViewer.imageSource
        z: 100  // 确保胶片栏在最高层级

        onImageSelected: function(imageSource) {
            idImageViewer.imageSource = imageSource
            // 重置缩放和位置
            idImageViewer.resetZoom()
        }
    }

    // 幻灯片事件处理 - 获取幻灯片按钮引用并连接信号
    Timer {
        interval: 100
        running: true
        repeat: false
        onTriggered: {
            // 动态获取幻灯片按钮并连接信号
            var slideButton = idToolBarRectangle.findSlideButton()
            if (slideButton) {
                root.idSlideToolButton = slideButton
                slideButton.imageFileSourceChanged.connect(function(strFilePath) {
                    if (slideButton.currentEffect === "flip") {
                        idImageViewer.startFlipAnimation(strFilePath)
                    } else if (slideButton.currentEffect === "fade") {
                        console.log("触发淡入淡出效果，路径:", strFilePath)
                        idImageViewer.startFadeAnimation(strFilePath)
                    } else {
                        idImageViewer.imageSource = "file:///" + strFilePath
                    }
                    mainCSlide.imageSourceChanged(strFilePath)
                })
            }
        }
    }

    // 图片显示区域 - 使用新的模块化 ImageViewer 组件
    Viewer {
        id: idImageViewer
        anchors {
            top: idToolBarRectangle.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: root.marginValue
            rightMargin: root.marginValue
            bottomMargin: root.marginValue
        }
        imageScale: root.imageScale
        minScale: root.minScale
        maxScale: root.maxScale
        scaleStep: root.scaleStep
        slideEngine: mainCSlide

        onZoomChanged: function(scale) {
            root.imageScale = scale
            idZoomIndicator.zoomValue = scale
            idZoomIndicator.show()
        }

        onImageCropped: function(croppedPath) {
            console.log("图片已裁剪:", croppedPath)
            // 可以在这里添加裁剪后的处理逻辑
        }

        onImageRotated: function(angle) {
            console.log("图片已旋转:", angle)
            // 可以在这里添加旋转后的处理逻辑
        }
    }

    // 缩放指示器组件
    ZoomIndicator {
        id: idZoomIndicator
        zoomValue: root.imageScale
    }

    // 快捷键处理组件
    KeyboardShortcuts {
        id: keyboardShortcuts
        slideEngine: mainCSlide
        slideButton: idSlideToolButton
        imageContainer: idImageViewer

        onNextImageRequested: {
            var nextImage = mainCSlide.getImageFile()
            if (nextImage !== "") {
                idImageViewer.imageSource = "file:///" + nextImage
                idImageViewer.resetZoom()
                mainCSlide.imageSourceChanged(nextImage)
            }
        }

        onPrevImageRequested: {
            var prevImage = mainCSlide.getPrevImageFile()
            if (prevImage !== "") {
                idImageViewer.imageSource = "file:///" + prevImage
                idImageViewer.resetZoom()
                mainCSlide.imageSourceChanged(prevImage)
            }
        }

        onZoomInRequested: {
            var centerX = idImageViewer.width / 2
            var centerY = idImageViewer.height / 2
            idImageViewer.zoomImage(1, centerX, centerY)
        }

        onZoomOutRequested: {
            var centerX = idImageViewer.width / 2
            var centerY = idImageViewer.height / 2
            idImageViewer.zoomImage(-1, centerX, centerY)
        }

        onDeleteImageRequested: {
            var currentImagePath = idImageViewer.imageSource.toString().replace("file:///", "")
            if (currentImagePath && currentImagePath !== "") {
                deleteCurrentImage(currentImagePath)
            }
        }

        onUndoDeleteRequested: {
            if (mainCSlide.canUndo()) {
                var success = mainCSlide.undoLastDelete()
                if (success) {
                    console.log("撤销成功")
                    filmStrip.updateFilmstripList()
                } else {
                    console.log("撤销失败")
                }
            } else {
                console.log("没有可撤销的操作")
            }
        }
    }

    // 删除当前图片函数（使用即时删除+撤销）
    function deleteCurrentImage(imagePath) {
        // 幻灯片模式下禁止删除
        if (idSlideToolButton && idSlideToolButton.isPlaying) {
            console.log("幻灯片播放中，禁止删除")
            return
        }

        console.log("即时删除图片:" + imagePath)

        // 调用C++即时删除函数
        var success = mainCSlide.deleteImageFile(imagePath)
        if (!success) {
            console.log("删除操作失败")
        }
    }

    CSlide {
        id: mainCSlide

        onImageSourcePathChanged: {
            console.log("imageSourcePathChanged - 新路径:", mainCSlide.imageSourcePath)

            // 如果正在进行淡入淡出，不要改变 idImage.source
            if (idImageViewer.getAnimations() && idImageViewer.getAnimations().isCrossFading) {
                console.log(">>> 正在进行交叉淡入淡出，跳过 idImage.source 的修改")
                return
            }

            if (mainCSlide.imageSourcePath !== "") {
                // 手动添加 file:///前缀
                var imagePath = "file:///" + mainCSlide.imageSourcePath
                console.log("设置主图片路径:", imagePath)
                idImageViewer.imageSource = imagePath
            } else {
                idImageViewer.imageSource = ""
            }

            //图片居中
            idImageViewer.resetZoom()
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
        imageSource: idImageViewer.imageSource
        scaleValue: Math.round(root.imageScale * 100)
    }

}
