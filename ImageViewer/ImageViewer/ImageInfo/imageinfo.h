#ifndef IMAGEINFO_H
#define IMAGEINFO_H

#include <QObject>
#include "imageinfostruct.h"


class ImageInfo : public QObject
{
    Q_OBJECT

public:
    ImageInfo(QObject *parent = nullptr);

    ~ImageInfo();

    Q_PROPERTY(QString imageSource READ imageSource WRITE setImageSource NOTIFY imageSourceChanged FINAL)
    Q_PROPERTY(ImageInfoStruct* imageInfo READ getImageInfo WRITE setImageInfo NOTIFY imageInfoChanged FINAL)

    QString imageSource() const;
    Q_INVOKABLE void setImageSource(QString newImageSource);

    Q_INVOKABLE ImageInfoStruct* getImageInfo() const;
    void setImageInfo(ImageInfoStruct* newImageInfo);

signals:
    void imageSourceChanged();

    void imageInfoChanged();

private:
    QString m_imageSource;

    QSharedPointer<ImageInfoStruct>  m_imageInfo;
};

#endif // IMAGEINFO_H
