import Qt.labs.platform as Platform
import QtQuick
import QtQuick.Controls

ApplicationWindow
{
    function openFileDialog() { fileOpenDialog.open(); }
    function openAboutDialog() { aboutDialog.open(); }

    visible: true;
    title: qsTr("Image Viewer");

    background: Rectangle{ color: "darkGray" }

    Image
    {
        id: image;
        anchors.fill: parent;
        fillMode: Image.PreserveAspectFit;
        asynchronous: true;
    }

    Platform.FileDialog
    {
        id: fileOpenDialog;
        title: "select an image file";
        folder: Platform.StandardPaths.writableLocation(Platform.StandardPaths.DocumentsLocation);
        nameFilters: ["Image files(*.png *.jpg *.jpeg)", "All files(*.*)"];
        onAccepted:
        {
            image.source = fileOpenDialog.currentFile;
        }
    }

    Dialog
    {
        id: aboutDialog;
        title: "About ImageViewer"
        Label
        {
            anchors.fill: parent;
            text: qsTr("QML Image Viewer\nA part of the QMLBOOK");
            horizontalAlignment: Text.AlignHCenter;
        }
        standardButtons: Dialog.Ok;
    }
}
