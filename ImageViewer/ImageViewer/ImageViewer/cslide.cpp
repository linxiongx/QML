#include "cslide.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QRandomGenerator>
#include <QUrl>

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

    // 解码URL编码的路径
    strImagePath = QUrl::fromPercentEncoding(strImagePath.toUtf8());

    QFile imageFile(strImagePath);
    if(imageFile.exists() == false)
    {
        qDebug() << "图片文件不存在:" << strImagePath;
        return ;
    }

    // 即使路径相同，也强制更新图片列表
    // 因为胶片栏需要获取当前目录的所有图片
    m_strImageSourcePath = strImagePath;

    QFileInfo fileInfo(strImagePath);

    QString strDirectoryPath = fileInfo.absolutePath();

    QDir directory(strDirectoryPath);
    if(!directory.exists())
    {
        qDebug() << "目录不存在:" << strDirectoryPath;
        return;
    }

    m_lstImagePath.clear();

    auto lstImagePathTemp = directory.entryList(QDir::Files);

    for(auto iter = lstImagePathTemp.begin(); iter != lstImagePathTemp.end(); ++iter)
    {
        QString fileExtension = iter->section('.', -1).toLower();
        if(fileExtension == "jpg" || fileExtension == "png" || fileExtension ==  "gif")
        {
            QString fullPath = strDirectoryPath + "/" + (*iter);
            m_lstImagePath.append(fullPath);
        }
    }
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
        if (m_lstImagePath.size() == 1) {
            strFile = m_lstImagePath.at(0);  // 单文件直接返回，无需随机
            break;
        }

        int nRandomIndex;
        do {
            nRandomIndex = QRandomGenerator::global()->bounded(m_lstImagePath.size());
        } while (nRandomIndex == index);  // 避免与当前相同

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

QString CSlide::getPrevImageFile()
{
    if(m_lstImagePath.size() == 0)
        return {};

    QString strFile = "";
    int index = m_lstImagePath.indexOf(m_strImageSourcePath);

    switch (m_slideType)
    {
    case SlideType::RANDOMIZATION:
    {
        // 随机模式下，上一张也使用随机逻辑，但避免与当前相同
        if (m_lstImagePath.size() == 1) {
            strFile = m_lstImagePath.at(0);
            break;
        }

        int nRandomIndex;
        do {
            nRandomIndex = QRandomGenerator::global()->bounded(m_lstImagePath.size());
        } while (nRandomIndex == index);

        strFile = m_lstImagePath.at(nRandomIndex);
        break;
    }
    case SlideType::SEQUENCES:
    {
        // 顺序模式下，上一张是前一张图片
        index = (index - 1 + m_lstImagePath.size()) % m_lstImagePath.size();
        strFile = m_lstImagePath[index];
        break;
    }
    default:
        break;
    }

    return strFile;
}

QStringList CSlide::getImageList()
{
    return m_lstImagePath;
}

bool CSlide::deleteImageFile(QString imagePath)
{
    // 检查图片是否在当前图片列表中
    if (!m_lstImagePath.contains(imagePath)) {
        qDebug() << "图片不在当前列表中:" << imagePath;
        return false;
    }

    QFile file(imagePath);
    if (!file.exists()) {
        qDebug() << "图片文件不存在:" << imagePath;
        return false;
    }

    // 尝试将文件移动到回收站
    bool success = file.moveToTrash();

    if (success) {
        qDebug() << "成功将图片移动到回收站:" << imagePath;

        // 从图片列表中移除
        m_lstImagePath.removeAll(imagePath);

        // 如果删除的是当前显示的图片，更新当前图片路径
        if (m_strImageSourcePath == imagePath) {
            if (!m_lstImagePath.isEmpty()) {
                m_strImageSourcePath = m_lstImagePath.first();
            } else {
                m_strImageSourcePath = "";
            }
        }
    } else {
        qDebug() << "删除图片失败:" << imagePath;
    }

    return success;
}
