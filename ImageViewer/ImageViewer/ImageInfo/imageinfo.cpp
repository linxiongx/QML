#include "imageinfo.h"
#include <QFileInfo>
#include <QImage>
#include <QImageReader>

ImageInfo::ImageInfo(QObject *parent)
    : QObject{parent}
{}

ImageInfo::~ImageInfo()
{

}

QString ImageInfo::imageSource() const
{
    return m_imageSource;
}

void ImageInfo::setImageSource(QString newImageSource)
{
    qDebug() << "C++ imageSource: " << newImageSource;

    newImageSource.remove("file:///");

    if (m_imageSource == newImageSource)
    {
        qDebug("m_imageSource == newImageSource");
        return;
    }


    QFileInfo fileInfo(newImageSource);
    if(!fileInfo.exists())
    {
        qDebug() << "File is not exist: " << newImageSource;
            return ;
    }


    //auto pImageInfoStruct = QSharedPointer<ImageInfoStruct>();
    //QSharedPointer<ImageInfoStruct> pImageInfoStruct(new ImageInfoStruct);
    ImageInfoStruct* pImageInfoStruct = new ImageInfoStruct;
    pImageInfoStruct->setModifyDate(fileInfo.lastModified().toString());
    pImageInfoStruct->setName(fileInfo.fileName());
    pImageInfoStruct->setSize(fileInfo.size());

    do
    {
        QString strExt = fileInfo.suffix();
        do
        {
            QImageReader reader(newImageSource);
            if(reader.canRead())
            {
                QString format = reader.format();
                strExt = format;
            }
        }
        while(0);


        QImage image(newImageSource);
        if(image.isNull())
        {
            qDebug("image.isNull()");
            return ;
        }


        QSize imageSize = image.size();
        QString strImageSize = QString("%1x%2(%3)").arg(imageSize.rwidth()).arg(imageSize.rheight()).arg(strExt);
        pImageInfoStruct->setInfo(strImageSize);

    }while(0);


    m_imageSource = newImageSource;
    emit imageSourceChanged();

    setImageInfo(pImageInfoStruct);
}

ImageInfoStruct* ImageInfo::getImageInfo() const
{
    return m_imageInfo.get();
}

void ImageInfo::setImageInfo(ImageInfoStruct* newImageInfo)
{
    if(newImageInfo != nullptr && m_imageInfo != nullptr)
    {
        if(newImageInfo->name() == m_imageInfo->name())
            return ;
    }

    m_imageInfo.reset(newImageInfo);

    emit imageInfoChanged();
}
