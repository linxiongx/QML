import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ImageViewerWindow
{
    id: window;

    width: 360; height: 520;

    header: ToolBar
    {
        Material.background: Material.Orange;

        ToolButton
        {
            id: menuButton;
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            icon.source: Qt.resolvedUrl("images/baseline-menu-24px.svg");
            onClicked: drawer.open();
        }
        Label
        {
            anchors.centerIn: parent;
            text: "Image Viewer"
            font.pixelSize: 20;
            elide: Label.ElideRight;
        }
    }

    Drawer
    {
        id: drawer;
        width: Math.min(window.width, window.height) / 3 * 2;
        height: window.height;

        ListView
        {
            focus: true;
            currentIndex: -1;
            anchors.fill: parent;

            delegate: ItemDelegate
            {
                required property var model;
                width: parent.width;
                text: model.text;
                highlighted: ListView.isCurrentItem;
                onClicked:{
                    drawer.close();
                    model.triggered();
                }
            }

            model: ListModel
            {
                ListElement
                {
                    text: qsTr("Open...");
                    triggered: function() { window.openFileDialog() }
                }
                ListElement
                {
                    text: qsTr("About...");
                    triggered: function() { window.openAboutDialog() }
                }
            }
            ScrollIndicator.vertical: ScrollIndicator{}
        }
    }
}
