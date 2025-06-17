#ifndef IMAGEINFOSTRUCT_H
#define IMAGEINFOSTRUCT_H

#include <QObject>
#include <QString>
#include <QDebug>

class ImageInfoStruct : public QObject
{
    Q_OBJECT

public:

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)
    Q_PROPERTY(float size READ size WRITE setSize NOTIFY sizeChanged FINAL)
    Q_PROPERTY(QString modifyDate READ modifyDate WRITE setModifyDate NOTIFY modifyDateChanged FINAL)
    Q_PROPERTY(QString info READ info WRITE setInfo NOTIFY infoChanged FINAL)

public:
    QString name() const;
    void setName(const QString &newName);
    float size() const;
    void setSize(float newSize);

    QString modifyDate() const;
    void setModifyDate(const QString &newModifyDate);

    QString info() const;
    void setInfo(const QString &newInfo);

signals:
    void nameChanged();
    void sizeChanged();

    void modifyDateChanged();

    void infoChanged();

private:
    QString m_name;
    float m_size;
    QString m_modifyDate;
    QString m_info;
};

#endif // IMAGEINFOSTRUCT_H
