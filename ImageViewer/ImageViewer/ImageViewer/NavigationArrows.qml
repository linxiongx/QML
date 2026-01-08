import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    signal prevClicked()
    signal nextClicked()

    // 箭头样式配置
    property int arrowSize: 50
    property color arrowColor: "white"
    property color arrowBgColor: "#80000000" // 半透明黑色
    property int hoverZoneWidth: 100

    // 外部传入胶片栏开启状态
    property bool filmStripOpen: false

    // 左侧导航 - 仅占据垂直中间区域
    Item {
        id: leftNav
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height / 3 // 只占据垂直中间 1/3
        width: root.hoverZoneWidth
        
        // 只有当胶片栏未展开时才启用
        visible: !root.filmStripOpen

        // 悬停检测区域
        MouseArea {
            id: leftHoverZone
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons // 拦截事件，避免触发下层
            
            // 调试用：显示区域
            // Rectangle { anchors.fill: parent; color: "#20FF0000"; visible: false }
        }

        // 左箭头按钮
        Rectangle {
            id: leftArrowBtn
            width: root.arrowSize
            height: root.arrowSize
            radius: width / 2
            color: leftArrowMouseArea.pressed ? "#aa000000" : root.arrowBgColor
            
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            
            // 只有当鼠标在检测区域或按钮本身上时显示
            visible: leftHoverZone.containsMouse || leftArrowMouseArea.containsMouse
            opacity: visible ? 1.0 : 0.0
            
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: "❮" // Unicode Left Arrow
                color: root.arrowColor
                font.pixelSize: 30
                font.bold: true
            }

            MouseArea {
                id: leftArrowMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.prevClicked()
            }
        }
    }

    // 右侧导航 - 仅占据垂直中间区域（保持与左侧对称）
    Item {
        id: rightNav
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height / 3 // 只占据垂直中间 1/3
        width: root.hoverZoneWidth
        
        // 悬停检测区域
        MouseArea {
            id: rightHoverZone
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
        }

        // 右箭头按钮
        Rectangle {
            id: rightArrowBtn
            width: root.arrowSize
            height: root.arrowSize
            radius: width / 2
            color: rightArrowMouseArea.pressed ? "#aa000000" : root.arrowBgColor
            
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            
            visible: rightHoverZone.containsMouse || rightArrowMouseArea.containsMouse
            opacity: visible ? 1.0 : 0.0
            
            Behavior on opacity { NumberAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: "❯" // Unicode Right Arrow
                color: root.arrowColor
                font.pixelSize: 30
                font.bold: true
            }

            MouseArea {
                id: rightArrowMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.nextClicked()
            }
        }
    }
}
