#include "cslide.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QRandomGenerator>
#include <QUrl>
#include <QImage>
#include <QPainter>

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
    case SlideType::PSEUDO_RANDOM:
    {
        if (m_lstImagePath.size() == 1) {
            strFile = m_lstImagePath.at(0);  // 单文件直接返回
            break;
        }

        // 伪随机算法：在1~7里随机一个数，30%是负数，70%是整数
        int randomStep = QRandomGenerator::global()->bounded(1, 4); // 生成1~7的随机数

        // 30%概率为负数，70%概率为正数
        if (QRandomGenerator::global()->bounded(100) < 30) {
            randomStep = -randomStep;
        }

        // 计算新的索引位置
        int newIndex = (index + randomStep + m_lstImagePath.size()) % m_lstImagePath.size();

        // 确保新索引与当前索引不同
        if (newIndex == index) {
            newIndex = (newIndex + 1) % m_lstImagePath.size();
        }

        strFile = m_lstImagePath.at(newIndex);
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
    case SlideType::PSEUDO_RANDOM:
    {
        if (m_lstImagePath.size() == 1) {
            strFile = m_lstImagePath.at(0);
            break;
        }

        // 伪随机算法：在1~7里随机一个数，30%是负数，70%是整数
        int randomStep = QRandomGenerator::global()->bounded(1, 8); // 生成1~7的随机数

        // 30%概率为负数，70%概率为正数
        if (QRandomGenerator::global()->bounded(100) < 30) {
            randomStep = -randomStep;
        }

        // 计算新的索引位置（注意：上一张图片使用相反的步长方向）
        int newIndex = (index - randomStep + m_lstImagePath.size()) % m_lstImagePath.size();

        // 确保新索引与当前索引不同
        if (newIndex == index) {
            newIndex = (newIndex - 1 + m_lstImagePath.size()) % m_lstImagePath.size();
        }

        strFile = m_lstImagePath.at(newIndex);
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

QString CSlide::cropImage(QString imagePath, int x, int y, int width, int height, int containerWidth, int containerHeight)
{
    qDebug() << "开始裁剪图片:" << imagePath;
    qDebug() << "裁剪区域: x=" << x << "y=" << y << "width=" << width << "height=" << height;
    qDebug() << "容器尺寸: width=" << containerWidth << "height=" << containerHeight;

    // 加载原始图片
    QImage originalImage(imagePath);
    if (originalImage.isNull()) {
        qDebug() << "无法加载图片:" << imagePath;
        return "";
    }

    // 获取图片的原始尺寸
    int imgWidth = originalImage.width();
    int imgHeight = originalImage.height();

    qDebug() << "图片原始尺寸: width=" << imgWidth << "height=" << imgHeight;

    // 由于裁剪功能只能在初始状态下使用（无缩放、无旋转）
    // 且图片在QML中以PreserveAspectFit模式显示，我们需要计算实际的显示尺寸

    // 计算图片在容器中的实际显示尺寸（保持宽高比）
    double aspectRatio = (double)imgWidth / imgHeight;
    double displayWidth, displayHeight;

    if ((double)containerWidth / containerHeight > aspectRatio) {
        // 容器更宽，图片高度等于容器高度
        displayHeight = containerHeight;
        displayWidth = displayHeight * aspectRatio;
    } else {
        // 容器更高，图片宽度等于容器宽度
        displayWidth = containerWidth;
        displayHeight = displayWidth / aspectRatio;
    }

    // 计算图片在容器中的偏移量（居中显示）
    double offsetX = (containerWidth - displayWidth) / 2;
    double offsetY = (containerHeight - displayHeight) / 2;

    // 计算缩放比例 - 从显示尺寸到原始尺寸
    double scaleX = (double)imgWidth / displayWidth;
    double scaleY = (double)imgHeight / displayHeight;

    qDebug() << "显示尺寸: width=" << displayWidth << "height=" << displayHeight;
    qDebug() << "缩放比例: scaleX=" << scaleX << "scaleY=" << scaleY;

    // 将屏幕坐标转换为原始图片坐标（考虑图片在容器中的偏移）
    int originalX = (x - offsetX) * scaleX;
    int originalY = (y - offsetY) * scaleY;
    int cropWidth = width * scaleX;
    int cropHeight = height * scaleY;

    // 确保裁剪区域在图片范围内
    originalX = qMax(0, qMin(originalX, originalImage.width() - 1));
    originalY = qMax(0, qMin(originalY, originalImage.height() - 1));
    cropWidth = qMin(cropWidth, originalImage.width() - originalX);
    cropHeight = qMin(cropHeight, originalImage.height() - originalY);

    qDebug() << "原始图片裁剪区域: x=" << originalX << "y=" << originalY
             << "width=" << cropWidth << "height=" << cropHeight;

    // 直接裁剪原始图片，创建与选区尺寸相同的新图片
    QImage croppedImage = originalImage.copy(originalX, originalY, cropWidth, cropHeight);

    if (croppedImage.isNull()) {
        qDebug() << "裁剪失败";
        return "";
    }

    // 生成裁剪后图片的文件名（在原文件名基础上添加_cropped后缀）
    QFileInfo fileInfo(imagePath);
    QString croppedImagePath = fileInfo.path() + "/" + fileInfo.completeBaseName() + "_cropped." + fileInfo.suffix();

    // 保存裁剪后的图片到新文件
    bool saveSuccess = croppedImage.save(croppedImagePath);

    if (saveSuccess) {
        qDebug() << "裁剪成功，裁剪后图片已保存到:" << croppedImagePath;
        // 返回裁剪后图片的路径，以便QML可以显示它
        return croppedImagePath;
    } else {
        qDebug() << "保存裁剪后的图片失败";
        return "";
    }
}
