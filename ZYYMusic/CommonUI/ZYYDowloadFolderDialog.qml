import QtQuick
import QtQuick.Controls
import Qt.labs.platform

Item
{
                 property bool isDowload: true;

                 //height: idDowloadPath.implicitHeight;
                 height: 60;
                 Label
                 {
                                  //anchors.left: parent.left;
                                  id: idDowloadPathLabel;
                                  textFormat: Text.RichText
                                  text: {
                                                   if(isDowload)
                                                                    return '下载目录<span style="font-size: 16px; color: gray;">（默认将音乐文件下载在该文件夹中）</span>';
                                                   else
                                                                     return '缓存目录<span style="font-size: 16px; color: gray;">（默认将音乐文件缓存在该文件夹中）</span>';
                                  }
                                  font.pixelSize: 20;
                                  font.family: "黑体";
                                  color: "white";
                 }

                 Item
                 {
                                  //anchors.left: parent.left;
                                  anchors.top: idDowloadPathLabel.bottom;
                                  anchors.topMargin: 15;
                                  width: idDowloadPath.implicitWidth + idDowloadRect.implicitWidth;
                                  height: idDowloadPath.implicitHeight;
                                  Label
                                  {
                                                   id: idDowloadPath;
                                                   anchors.left: parent.left;
                                                   textFormat: Text.RichText
                                                   text: 'G:\\CloudMusic';
                                                   font.pixelSize: 20;
                                                   font.family: "黑体";
                                                   color: "white";
                                  }
                                  Rectangle
                                  {
                                                   id: idDowloadRect;
                                                   anchors.left: idDowloadPath.right;
                                                   anchors.leftMargin: 20;
                                                   width: idChangePathText.implicitWidth + 20;
                                                   height: idDowloadPath.implicitHeight + 5;
                                                   radius: 10;
                                                   color: "transparent";
                                                   border.color: "#2e2d31"
                                                   border.width: 1;
                                                   Text
                                                   {
                                                                    id: idChangePathText;
                                                                    anchors.fill: parent;
                                                                    verticalAlignment: Text.AlignVCenter;
                                                                    horizontalAlignment: Text.AlignHCenter;
                                                                    text: "更改目录";
                                                                    font.pixelSize: 14;
                                                                    font.family: "黑体";
                                                                    color: "white";
                                                   }
                                                   MouseArea
                                                   {
                                                                    anchors.fill: parent;
                                                                    hoverEnabled: true;
                                                                    onEntered: cursorShape = Qt.PointingHandCursor;
                                                                    onExited: cursorShape = Qt.ArrowCursor;
                                                                    onClicked: idFolderDialog.open();
                                                   }
                                  }

                                  FolderDialog
                                  {
                                                   id: idFolderDialog
                                                   folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
                                                   onAccepted:
                                                   {
                                                                    let s = String(idFolderDialog.currentFolder);
                                                                    let str = s.slice(8, s.length);
                                                                    idDowloadPath.text = str;
                                                   }
                                  }
                 }

}
