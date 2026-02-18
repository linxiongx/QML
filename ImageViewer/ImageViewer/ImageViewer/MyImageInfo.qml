import QtQuick

Column
{
    id: idContainer
    property url imageSource: ""
    property real scaleValue: 100
    spacing: 5

    // 内部状态，存储解析后的信息
    property string fileName: ""
    property string fileSize: ""
    property string modifyDate: ""
    property string resolution: ""

    // 监听图片源变化，更新信息
    onImageSourceChanged: {
        updateInfo()
    }

    function updateInfo() {
        if (!imageSource || imageSource.toString() === "") {
            resetInfo()
            return
        }

        // 调用后端 C++ 接口 (mainCSlide 是在全局上下文注册的 CSlide 实例)
        if (typeof mainCSlide !== "undefined") {
            var infoMap = mainCSlide.getImageInfo(imageSource.toString())
            if (infoMap) {
                fileName = infoMap.name || "未知"
                
                var size = infoMap.size || 0
                if (size > 1024 * 1024) {
                    fileSize = (size / 1024 / 1024).toFixed(2) + " MB"
                } else {
                    fileSize = (size / 1024).toFixed(2) + " KB"
                }
                
                modifyDate = infoMap.modifyDate || "未知"
                resolution = infoMap.info || "未知"
            }
        }
    }

    function resetInfo() {
        fileName = "未加载"
        fileSize = "-"
        modifyDate = "-"
        resolution = "-"
    }

    Text
    {
        id: idFileNameText
        text: "文件名: " + idContainer.fileName
        color: "white"
        font.pixelSize: 12
        renderType: Text.QtRendering
    }

    Text
    {
        id: idImageSizeText
        text: "图片大小：" + idContainer.fileSize
        color: "white"
        font.pixelSize: 12
        renderType: Text.QtRendering
    }

    Text
    {
        id: idImageModifyDateText
        text: "修改日期：" + idContainer.modifyDate
        color: "white"
        font.pixelSize: 12
        renderType: Text.QtRendering
    }

    Text
    {
        id: idImageInfoText
        text: "图片分辨率：" + idContainer.resolution
        color: "white"
        font.pixelSize: 12
        renderType: Text.QtRendering
    }

    Text
    {
        id: idImageScaleValue
        text: "缩放：" + Math.round(idContainer.scaleValue) + "%"
        color: "white"
        font.pixelSize: 12
        renderType: Text.QtRendering
    }
}
