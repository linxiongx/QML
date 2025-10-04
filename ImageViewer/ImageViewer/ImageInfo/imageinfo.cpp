#include "imageinfo.h"
#include <QFileInfo>
#include <QImage>
#include <QImageReader>
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <QDir>

void logToFile(const QString& message)
{
#if 0
    // 首先尝试在应用程序目录创建日志
    QString logPath = "imageinfo_debug.log";
    QFile file(logPath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)) {
        QTextStream out(&file);
        out << QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss.zzz")
            << " - " << message << "\n";
        file.close();
        return;
    }
#endif
}

ImageInfo::ImageInfo(QObject *parent)
    : QObject{parent}
{

}

ImageInfo::~ImageInfo()
{

}

QString ImageInfo::imageSource() const
{
    return m_imageSource;
}

void ImageInfo::setImageSource(QString newImageSource)
{
    logToFile("setImageSource called with: " + newImageSource);

    newImageSource.remove("file:///");

    if (m_imageSource == newImageSource)
    {
        logToFile("m_imageSource == newImageSource, skipping");
        return;
    }

    QFileInfo fileInfo(newImageSource);
    if(!fileInfo.exists())
    {
        logToFile("File is not exist: " + newImageSource);
        return ;
    }

    // 创建新的 ImageInfoStruct 对象
    ImageInfoStruct* newImageInfo = new ImageInfoStruct();
    logToFile("Created new ImageInfoStruct object at address: " + QString::number(reinterpret_cast<quintptr>(newImageInfo)));

    newImageInfo->setModifyDate(fileInfo.lastModified().toString());
    newImageInfo->setName(fileInfo.fileName());
    newImageInfo->setSize(fileInfo.size());

    logToFile("Set basic image info: " + fileInfo.fileName());

    // 获取图片尺寸和格式
    QString strExt = fileInfo.suffix();
    QImageReader reader(newImageSource);
    if(reader.canRead())
    {
        QString format = reader.format();
        strExt = format;
    }

    QImage image(newImageSource);
    if(image.isNull())
    {
        logToFile("image.isNull()");
        delete newImageInfo;  // 清理内存
        return ;
    }

    QSize imageSize = image.size();
    QString strImageSize = QString("%1x%2(%3)").arg(imageSize.rwidth()).arg(imageSize.rheight()).arg(strExt);
    newImageInfo->setInfo(strImageSize);

    m_imageSource = newImageSource;
    emit imageSourceChanged();

    // 设置新的图片信息
    logToFile("setImageSource: before setImageInfo");
    try {
        setImageInfo(newImageInfo);
        logToFile("setImageSource: after setImageInfo");
    } catch (...) {
        logToFile("setImageSource: exception during setImageInfo");
    }
}

ImageInfoStruct* ImageInfo::getImageInfo() const
{
    return m_imageInfo.get();
}

void ImageInfo::setImageInfo(ImageInfoStruct* newImageInfo)
{
    // 检查空指针
    if (!newImageInfo) {
        logToFile("setImageInfo: newImageInfo is null");
        return;
    }

    logToFile("setImageInfo: newImageInfo name = " + newImageInfo->name());

    // 检查当前是否有图片信息
    if (m_imageInfo) {
        logToFile("setImageInfo: current imageInfo name = " + m_imageInfo->name());
        // 检查名称是否相同，避免不必要的更新
        if (m_imageInfo->name() == newImageInfo->name()) {
            logToFile("setImageInfo: same name, skipping update");
            delete newImageInfo;  // 清理不需要的对象
            return;
        }
    } else {
        logToFile("setImageInfo: current imageInfo is null");
    }

    // 设置新的图片信息 - 使用 QSharedPointer 管理内存
    m_imageInfo = QSharedPointer<ImageInfoStruct>(newImageInfo);
    logToFile("setImageInfo: successfully set new image info");

    // 添加更多调试信息
    logToFile("setImageInfo: before emit imageInfoChanged");
    emit imageInfoChanged();
    logToFile("setImageInfo: after emit imageInfoChanged");
}
