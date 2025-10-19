import QtQuick

/**
 * CropSelection 组件 - 图片裁剪选区显示
 * 职责：显示用户拖拽的裁剪选区框
 *
 * 属性：
 *   - startX, startY: 选区起点
 *   - endX, endY: 选区终点
 *   - visible: 是否显示选区
 *
 * 方法：
 *   - getNormalizedRect(): 获取规范化的选区信息
 */

Rectangle {
    id: cropSelection

    visible: false
    color: "transparent"
    border.color: "red"
    border.width: 2
    z: 10

    // 外部属性接口
    property real startX: 0
    property real startY: 0
    property real endX: 0
    property real endY: 0

    // 容器宽高（用于边界检查）
    property real containerWidth: parent.width
    property real containerHeight: parent.height

    onStartXChanged: updatePosition()
    onStartYChanged: updatePosition()
    onEndXChanged: updatePosition()
    onEndYChanged: updatePosition()

    // 更新选区位置和大小
    function updatePosition() {
        x = Math.min(startX, endX)
        y = Math.min(startY, endY)
        width = Math.abs(endX - startX)
        height = Math.abs(endY - startY)
    }

    // 获取规范化的裁剪矩形（加入边界检查）
    function getNormalizedRect() {
        var rect = {
            x: Math.min(startX, endX),
            y: Math.min(startY, endY),
            width: Math.abs(endX - startX),
            height: Math.abs(endY - startY)
        }

        // 确保选区在图片范围内
        rect.x = Math.max(0, Math.min(rect.x, containerWidth))
        rect.y = Math.max(0, Math.min(rect.y, containerHeight))
        rect.width = Math.min(rect.width, containerWidth - rect.x)
        rect.height = Math.min(rect.height, containerHeight - rect.y)

        return rect
    }

    // 重置选区
    function reset() {
        startX = 0
        startY = 0
        endX = 0
        endY = 0
        visible = false
    }
}
