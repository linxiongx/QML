import QtQuick
import org.example.myplugins

Column
{
    property alias imageSource: idImageInfoPlugin.source;
    property alias scaleValue: idImageScaleValue.scaleValue;
   spacing: 5;

   property int intValue: 8;


   ImageInfoPlugin
   {
       id: idImageInfoPlugin;
       property string source;

       onSourceChanged:
       {
            console.log("onSourceChanged: source = " + source);
           idImageInfoPlugin.setImageSource(source);

           var imageInfoStruct = idImageInfoPlugin.getImageInfo(); //JavaScript 使用 var、let、const 等 来定义变量
           //ImageInfoStruct imageInfoStruct = idImageInfoPlugin.getImageInfo(); //这样报错


           if(imageInfoStruct === null)
               return ;

           idFileNameText.text = "文件名: " + imageInfoStruct.name;
           //idFileNameText.text = "文件名: " + imageInfoStruct->name; //这样报错：JavaScript没有指针，QML引擎会将指针转换为对象

           var nImageSize = imageInfoStruct.size;
           if(nImageSize > 1024 * 1024)
           {
               var str = ("图片大小：" + (nImageSize/ 1024 / 1024).toFixed(2) + "MB");
                idImageSizeText.text = str;
           }
           else
           {
                var str = ("图片大小：" + (nImageSize / 1024).toFixed(2) + "KB");
                idImageSizeText.text = str;
           }

           idImageModifyDateText.text = "修改日期：" + imageInfoStruct.modifyDate;
           idImageInfoText.text = "图片信息：" + imageInfoStruct.info;
           idImageScaleValue.scaleValue = 100;
       }
   }

    Row
    {
        spacing: 10;
        Image
        {
            source: Qt.resolvedUrl("res/favicon.ico");
        }

        Image
        {
            source: Qt.resolvedUrl("res/favicon.ico");
        }
    }

    Text
    {
        id: idFileNameText;
        text: "文件名: xxxxxxxxxxxxxxxxxxxxx";
        color: "white";
        font.pointSize: 12;
    }

    Text
    {
        id: idImageSizeText;
        text: "图片大小：xxxxxxxx";
        color: "white";
        font.pointSize: 12;
    }

    Text
    {
        id: idImageModifyDateText;
        text: "修改日期：xxxxxxxxx";
        color: "white";
        font.pointSize: 12;
    }

    Text
    {
        id: idImageInfoText;
        text: "图片信息：xxxxxxxxx";
        color: "white";
        font.pointSize: 12;
    }

    Text
    {
        id: idImageScaleValue;
        property real scaleValue;
        text: "缩放：" + scaleValue + "%";
        color: "white";
        font.pointSize: 12;
    }

}
