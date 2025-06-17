#include "cslide.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QRandomGenerator>

CSlide::CSlide(QObject *parent)
    : QObject{parent}
{}

CSlide::SlideType CSlide::slideType() const
{
    return m_slideType;
}

void CSlide::setSlideType(SlideType newSlideType)
{
    qDebug() << "setSlideType: newSlideType = " << (int)newSlideType;
    if (m_slideType == newSlideType)
        return;
    m_slideType = newSlideType;
    emit slideTypeChanged();
}

void CSlide::imageSourceChanged(QString strImagePath)
{
    strImagePath.remove("file:///");

    QFile imageFile(strImagePath);
    if(imageFile.exists() == false)
        return ;

    if(strImagePath == m_strImageSourcePath)
        return ;

    m_strImageSourcePath = strImagePath;

    qDebug() << "strImagePath = " << strImagePath;


    QFileInfo fileInfo(strImagePath);

    QString strDirectoryPath = fileInfo.absolutePath();
    qDebug() << "strDirectoryPath = " << strDirectoryPath;

    QDir directory(strDirectoryPath);

    m_lstImagePath.clear();

    auto lstImagePathTemp = directory.entryList(QDir::Files);

    for(auto iter = lstImagePathTemp.begin(); iter != lstImagePathTemp.end(); ++iter)
    {
        QString fileExtension = iter->section('.', -1);
        if(fileExtension == "jpg" || fileExtension == "png" || fileExtension ==  "gif")
        {
            m_lstImagePath.append(strDirectoryPath + "/" + (*iter));
        }
    }

    qDebug() << "文件数量：" << m_lstImagePath.size();

}

QString CSlide::getImageFile()
{
    if(m_lstImagePath.size() == 0)
        return {};

    QString strFile = "";
    int index = m_lstImagePath.indexOf(m_strImageSourcePath);

    switch (m_slideType)
    {
    case SlideType::RANDOMIZATION:
    {
        int nRandomIndex = index;
        while(!(m_lstImagePath.size() != 1 && index != nRandomIndex))
        {
            nRandomIndex = QRandomGenerator::global()->bounded(m_lstImagePath.size());
        }

        strFile = m_lstImagePath.at(nRandomIndex);
        break;
    }
    case SlideType::SEQUENCES:
    {
        index = (++index) % m_lstImagePath.size();
        strFile = m_lstImagePath[index];
        break;
    }
    default:
        break;
    }

    return strFile;
}
