import QtQuick

/**
 * ImageAnimations 组件 - 图片切换动画系统
 * 职责：处理翻转、淡入淡出等图片切换动画
 *
 * 属性：
 *   - currentEffect: 当前效果类型 ("flip"、"fade"、"none")
 *   - isCrossFading: 是否正在进行淡入淡出
 *
 * 方法：
 *   - startFlipAnimation(imagePath, centerX, centerY): 启动翻转动画
 *   - changeImage(newImagePath): 启动淡入淡出并切换图片
 */

Item {
    id: imageAnimations

    // 外部属性接口
    property string currentEffect: "flip"  // "flip", "fade", "none"
    property bool isCrossFading: false
    property string nextImagePath: ""

    // 对图片层的引用（需要由父组件设置）
    property var baseImage: null     // 底层图片（id: idImage）
    property var nextImage: null     // 顶层图片（id: idImageNext）
    property var baseImageRotation: null   // 底层旋转变换
    property var nextImageRotation: null   // 顶层旋转变换
    property var scrollView: null    // ScrollView 容器

    // 翻转动画定义
    SequentialAnimation {
        id: flipAnimation

        property string newImagePath: ""
        property real centerOffsetX: 0
        property real centerOffsetY: 0

        // 第一步：翻转到90度（图片消失）
        RotationAnimation {
            target: imageAnimations.baseImageRotation
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
                if (imageAnimations.baseImage) {
                    imageAnimations.baseImage.source = "file:///" + flipAnimation.newImagePath
                }
            }
        }

        // 第三步：从270度翻转回360度（0度）
        RotationAnimation {
            target: imageAnimations.baseImageRotation
            property: "angle"
            from: 270
            to: 360
            duration: 250
            easing.type: Easing.OutQuad
        }

        // 第四步：重置角度为0
        ScriptAction {
            script: {
                if (imageAnimations.baseImageRotation) {
                    imageAnimations.baseImageRotation.angle = 0
                }
            }
        }
    }

    // 淡入淡出动画定义
    ParallelAnimation {
        id: crossFadeAnimation

        OpacityAnimator {
            target: imageAnimations.baseImage
            from: 1
            to: 0
            duration: 500
            easing.type: Easing.OutQuad
        }

        OpacityAnimator {
            target: imageAnimations.nextImage
            from: 0
            to: 1
            duration: 500
            easing.type: Easing.InQuad
        }

        onStarted: {
            console.log("=== 淡入淡出动画开始 ===")
            imageAnimations.isCrossFading = true
        }

        onFinished: {
            console.log("=== 淡入淡出动画完成 ===")
            // 动画完成后，将新图片内容复制到底层
            if (imageAnimations.baseImage && imageAnimations.nextImage) {
                imageAnimations.baseImage.source = imageAnimations.nextImage.source
                imageAnimations.baseImage.opacity = 1
                imageAnimations.nextImage.opacity = 0
                imageAnimations.nextImage.source = ""
            }
            imageAnimations.isCrossFading = false
        }

        onStopped: {
            imageAnimations.isCrossFading = false
        }
    }

    // 启动翻转动画的函数
    function startFlipAnimation(newImagePath, centerOffsetX, centerOffsetY) {
        console.log("=== startFlipAnimation 被调用 ===")
        console.log("新图片路径:", newImagePath)

        if (!baseImageRotation) {
            console.warn("baseImageRotation 未设置")
            return
        }

        // 设置旋转中心
        baseImageRotation.origin.x = centerOffsetX
        baseImageRotation.origin.y = centerOffsetY

        // 设置新图片路径并启动动画
        flipAnimation.newImagePath = newImagePath
        flipAnimation.centerOffsetX = centerOffsetX
        flipAnimation.centerOffsetY = centerOffsetY
        flipAnimation.start()
    }

    // 使用淡入淡出切换图片的函数
    function changeImage(newImagePath) {
        console.log("=== changeImage 被调用 ===")
        console.log("旧图片:", baseImage ? baseImage.source : "null")
        console.log("新图片路径:", newImagePath)

        if (!baseImage || !nextImage) {
            console.warn("baseImage 或 nextImage 未设置")
            return
        }

        // 如果动画正在运行，先停止
        if (crossFadeAnimation.running) {
            console.log("停止正在运行的动画")
            crossFadeAnimation.stop()
            // 清理状态
            baseImage.source = nextImage.source
            baseImage.opacity = 1
            nextImage.opacity = 0
        }

        // 设置标志位，防止 idImage 被修改
        isCrossFading = true
        console.log(">>> 设置 isCrossFading = true，防止 idImage 被修改")

        // 先加载新图片到顶层（opacity为0，不可见）
        var newSource = "file:///" + newImagePath
        console.log("设置 nextImage.source =", newSource)
        nextImage.source = newSource

        // 强制设置初始状态
        baseImage.opacity = 1
        nextImage.opacity = 0

        // 确保两层图片的旋转角度一致
        if (nextImageRotation && baseImageRotation) {
            nextImageRotation.angle = baseImageRotation.angle
        }

        console.log("等待新图片加载，当前状态:", nextImage.status)
        console.log("baseImage.source =", baseImage.source)
        console.log("nextImage.source =", nextImage.source)

        // 定义加载完成后的处理函数
        var startAnimationWhenReady = function() {
            console.log(">>> 准备开始动画")
            console.log(">>> baseImage.source =", baseImage.source)
            console.log(">>> nextImage.source =", nextImage.source)

            // 再次确认两个图片源不同
            if (baseImage.source === nextImage.source) {
                console.log("!!! 警告：两个图片源相同，取消动画")
                isCrossFading = false
                return
            }

            // 确保初始状态正确
            baseImage.opacity = 1
            nextImage.opacity = 0

            console.log(">>> 现在开始动画")
            crossFadeAnimation.start()
        }

        // 等待新图片加载完成后开始动画
        if (nextImage.status === Image.Ready) {
            console.log("图片已就绪，立即启动动画流程")
            startAnimationWhenReady()
        } else if (nextImage.status === Image.Loading) {
            console.log("图片正在加载，等待...")
            // 如果正在加载，监听加载完成信号
            var loadHandler = function() {
                console.log("图片状态变化:", nextImage.status)
                if (nextImage.status === Image.Ready) {
                    console.log("图片加载完成")
                    nextImage.statusChanged.disconnect(loadHandler)
                    startAnimationWhenReady()
                } else if (nextImage.status === Image.Error) {
                    console.log("图片加载失败:", nextImage.source)
                    nextImage.statusChanged.disconnect(loadHandler)
                    isCrossFading = false
                }
            }
            nextImage.statusChanged.connect(loadHandler)
        } else {
            console.log("图片状态异常:", nextImage.status)
            isCrossFading = false
        }
    }

    // 重置状态
    function reset() {
        isCrossFading = false
        if (crossFadeAnimation.running) {
            crossFadeAnimation.stop()
        }
        if (flipAnimation.running) {
            flipAnimation.stop()
        }
    }
}
