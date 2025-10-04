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
        RANDOMIZATION = 1,   //随机浏览
        PSEUDO_RANDOM = 2    //伪随机浏览
    };
    Q_ENUM(SlideType)

    Q_PROPERTY(SlideType slideType READ slideType WRITE setSlideType NOTIFY slideTypeChanged)
    Q_PROPERTY(QString imageSourcePath READ imageSourcePath NOTIFY imageSourcePathChanged)

    SlideType slideType() const;
    Q_INVOKABLE void setSlideType(SlideType newSlideType);

    Q_INVOKABLE void imageSourceChanged(QString strImagePath);
    QString imageSourcePath() const;

    Q_INVOKABLE QString getImageFile();
    Q_INVOKABLE QString getPrevImageFile();
    Q_INVOKABLE QStringList getImageList();
    Q_INVOKABLE bool deleteImageFile(QString imagePath);
    Q_INVOKABLE QString cropImage(QString imagePath, int x, int y, int width, int height, int containerWidth, int containerHeight, double imageScale);
    Q_INVOKABLE void clearPendingDelete(); // 清空待删除路径
    Q_INVOKABLE void cleanupOnExit(); // 程序退出时清理

signals:
    void slideTypeChanged();
    void imageSourcePathChanged();
    void imageListChanged();

private:
    SlideType m_slideType = SlideType::SEQUENCES;
    QStringList m_lstImagePath;
    QString m_strImageSourcePath;
    QString m_pendingDeletePath; // 待删除的图片路径
    QString m_lastDeletedPath; // 最近删除的图片路径（用于恢复时显示）
};

#endif // CSLIDE_H
