#ifndef CSLIDE_H
#define CSLIDE_H

#include <QObject>
#include <QStringList>

class CSlide : public QObject
{
    Q_OBJECT
public:
    explicit CSlide(QObject *parent = nullptr);

    enum SlideType
    {
        SEQUENCES = 0, //顺序浏览
        RANDOMIZATION = 1   //随机浏览
    };
    Q_ENUM(SlideType)

    Q_PROPERTY(SlideType slideType READ slideType WRITE setSlideType NOTIFY slideTypeChanged)

    SlideType slideType() const;
    Q_INVOKABLE void setSlideType(SlideType newSlideType);

    Q_INVOKABLE void imageSourceChanged(QString strImagePath);

    Q_INVOKABLE QString getImageFile();

signals:
    void slideTypeChanged();

private:
    SlideType m_slideType = SlideType::SEQUENCES;
    QStringList m_lstImagePath;
    QString m_strImageSourcePath;
};

#endif // CSLIDE_H
