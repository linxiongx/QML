import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.example.myplugins

ApplicationWindow
{
    width: 1367
    height: 836
    visible: true
    title: qsTr("图片浏览器")

    id: root;
    property int marginValue: 5;

    minimumWidth: 500;

    Rectangle
    {
        id: idToolBarRectangle;

        anchors
        {
            left: parent.left;
            right: parent.right;
            top: parent.top;
            leftMargin: root.marginValue;
            rightMargin: root.marginValue;
        }

        height: 30;
        color: "darkgray"

        MyToolButton
        {
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.verticalCenter: parent.verticalCenter;
            text: qsTr("EXIF");
            imageSource: Qt.resolvedUrl("res/favicon.ico");
            onClicked: idImageInfoText.visible = !idImageInfoText.visible;
        }



        RowLayout
        {
            anchors.right: parent.right;
            anchors.rightMargin: 10;
            layoutDirection: Qt.RightToLeft;
            anchors.verticalCenter: parent.verticalCenter;

            spacing: 15;


            LockerToolButton
            {
                onClicked:
                {
                    //root.flags = Qt.FramelessWindowHint;
                }
            }

            CopyToolButton
            {
                marginValue: root.marginValue + 2;
            }

            EditToolButton
            {
                marginValue: root.marginValue + 2;
            }

            BookmarksToolButton
            {
                marginValue: root.marginValue + 2;
            }

            SlideToolButton
            {
                id: idSlideToolButton
                marginValue: root.marginValue + 2;

                imageSource: idImage.source;
            }

            ScanToolButton
            {
                marginValue: root.marginValue + 2;
            }
        }
    }

    Connections
    {
        target: idSlideToolButton;
        function onImageFileSourceChanged(strFilePath)
        {
            idImage.source = "file:///" + strFilePath;
        }
    }


    Rectangle
    {
        id: idContainer;
        anchors
        {
            top: idToolBarRectangle.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            leftMargin: root.marginValue;
            rightMargin: root.marginValue;
            bottomMargin: root.marginValue;
        }

        color: "black";

        ScrollView
        {
            id: idScrollView;

            anchors.fill: parent;

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            clip: true;
            wheelEnabled: false;

            Image
            {
                id: idImage;

                width: idContainer.width;
                height: idContainer.height;
                x: (idContainer.width - sourceSize.width) / 2;
                y: (idContainer.height - sourceSize.height) / 2;

                // width: 500;
                // height: 500;
                // x: (idContainer.width - 500) / 2;
                // y: (idContainer.height - 500) / 2;


                //source: Qt.resolvedUrl("file:///H:\\图片\\Group 5\\file 963x1440_004302.jpg");
                //source: Qt.resolvedUrl("file:///H:\\图片\\Group 5\\file 963x1440_00430xxxxx2.jpg");
                //source: Qt.resolvedUrl("file:///H:\\图片\\Snipaste 1816x1028_000093.png");
                fillMode: Image.PreserveAspectFit

                transform: Scale
                {
                    id: idImageScale;
                    origin.x: idImage.width / 2;
                    origin.y: idImage.height / 2;
                    xScale: 1.0;
                    yScale: 1.0;
                }

                onSourceChanged:
                {
                    idImageScale.xScale = 1.0;
                    idImageScale.yScale = 1.0;

                    idImageAnimation.start();
                }

                opacity: 1;

                ParallelAnimation
                {
                    id: idImageAnimation;

                    RotationAnimation
                    {
                        target: idImage;
                        properties: "x";
                        from: idScrollView.width;
                        to: idImage.x;
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }

                    NumberAnimation
                    {
                        target: idImage;
                        properties: "opacity";
                        from: 0;
                        to: 1;
                        duration: 300;
                    }
                }
            }

            DropArea
            {
                id: idDropArea;
                anchors.fill: parent;
                onDropped: (drop)=>
                           {
                               if(drop.hasUrls)
                               {
                                   for(var i = 0; i < drop.urls.length; ++i)
                                   {
                                       var url = drop.urls[i].toString();
                                       var extension = url.split('.').pop().toLowerCase();
                                       if(["jpg", "png", "gif"].indexOf(extension) !== -1)
                                       {
                                           idImage.source = drop.urls[0];
                                           idImageScale.xScale = 1;
                                           idImageScale.yScale = 1;

                                           return;
                                       }
                                   }
                               }
                           }
            }
        }

        WheelHandler
        {
            target: idScrollView;
            onWheel: (event) => {
                         if(idImage.status === Image.Ready)
                         {
                             const delta = event.angleDelta.y / 120;
                             let newScale = idImageScale.xScale + delta * 0.1;
                             newScale = Math.max(0, Math.min(newScale, 3.0));

                             idImageScale.xScale = newScale;
                             idImageScale.yScale = newScale;

                             idScanInfoLayout.visible = true;
                             idScanInfoTimer.start();

                             idScanInfoText.text = parseInt(newScale * 100) + "%";
                             idImageInfoText.scaleValue = parseInt(newScale * 100);

                            // idImageScale.origin.x = event.x;
                            // idImageScale.origin.y = event.y;


                             //  console.log(idImage.sourceSize.width  * newScale +","+idContainer.width+"  ");
                             //  if(idImage.sourceSize.width * newScale < idContainer.width)
                             //  {
                             //      idImage.x = (idContainer.width - idImage.sourceSize.width   * newScale ) / 2;

                             //  }
                             //  if(idImage.sourceSize.height * newScale < idContainer.height)
                             //  {
                             //      idImage.y = (idContainer.height - idImage.sourceSize.height  * newScale ) / 2;
                             //  }
                             // idImage.x = 0 - (idImage.width * (idImageScale.xScale - 1)) / 2;
                         }
                     }
        }


        DragHandler
        {
            id: idHandler;
            //target: idScrollView.contentItem;
            //target: idScrollView;
            target: idScrollView;
            acceptedButtons: Qt.LeftButton;
            xAxis.onActiveValueChanged: (delta) => {
                                            idImage.x = idImage.x + delta;
                                            //idScrollView.contentItem.contentX -= delta;
                                            //idScrollView.x -= delta;
                                        }
            yAxis.onActiveValueChanged: (delta) => {
                                            idImage.y = idImage.y + delta;
                                            //idScrollView.contentItem.contenY -= delta;
                                            //idScrollView.y -= delta;
                                        }
        }

        MyImageInfo
        {
            id: idImageInfoText;

            visible: false;
            anchors.left: parent.left;
            anchors.leftMargin: 10;
            anchors.top: parent.top;
            anchors.topMargin: 20;

            imageSource: idImage.source.toString();
        }
    }

    //显示放大系数
    Item
    {
        id: idScanInfoLayout;
        anchors.centerIn: parent;
        visible: false;
        Rectangle
        {
            id: idScaleRect;
            width: 240;
            height: 60;
            anchors.centerIn: parent;
            radius: 5;
            color: "black"
            opacity: 0.7;
        }

        Text
        {
            id: idScanInfoText;
            text: "70%";
            anchors.centerIn: idScaleRect;
            font.pointSize: 18;
            color: "white"
            opacity: 1;
        }

        Timer
        {
            id: idScanInfoTimer;
            interval: 1000;
            repeat: false;
            onTriggered: idScanInfoLayout.visible = false;
        }
    }
}
