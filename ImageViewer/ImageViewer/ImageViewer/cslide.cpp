#include "cslide.h"
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QRandomGenerator>
#include <QUrl>
#include <QImage>
#include <QPainter>
#include <QStandardPaths>

#ifdef Q_OS_WIN
#include <windows.h>
#include <shlobj.h>
#include <winreg.h>
#endif

CSlide::CSlide(QObject *parent)
    : QObject{parent}
{}

CSlide::SlideType CSlide::slideType() const
{
    return m_slideType;
}

QString CSlide::imageSourcePath() const
{
    // 直接返回本地文件路径，让QML处理编码
    if (m_strImageSourcePath.isEmpty()) {
        return "";
    }
    return m_strImageSourcePath;
}

void CSlide::setSlideType(SlideType newSlideType)
{
    if (m_slideType == newSlideType)
        return;
    m_slideType = newSlideType;
    emit slideTypeChanged();
}

void CSlide::imageSourceChanged(QString strImagePath)
{
    qDebug() << "CSlide::imageSourceChanged 被调用，传入路径:" << strImagePath;

    // 移除file:///前缀
    strImagePath.remove("file:///");
    qDebug() << "移除 file:/// 前缀后:" << strImagePath;

    // 解码URL编码的路径（QML传递的路径是编码过的）
    strImagePath = QUrl::fromPercentEncoding(strImagePath.toUtf8());
    qDebug() << "URL解码后:" << strImagePath;

    // 标准化路径格式（Windows上统一使用正斜杠）
    strImagePath = QDir::fromNativeSeparators(strImagePath);
    qDebug() << "标准化路径后:" << strImagePath;

    QFile imageFile(strImagePath);
    if(imageFile.exists() == false)
    {
        qDebug() << "图片文件不存在:" << strImagePath;
        return ;
    }

    // 保存原始路径
    QString originalPath = m_strImageSourcePath;
    m_strImageSourcePath = strImagePath;
    qDebug() << "原始路径:" << originalPath << "新路径:" << m_strImageSourcePath;

    QFileInfo fileInfo(strImagePath);
    QString strDirectoryPath = fileInfo.absolutePath();
    qDebug() << "目录路径:" << strDirectoryPath;

    QDir directory(strDirectoryPath);
    if(!directory.exists())
    {
        qDebug() << "目录不存在:" << strDirectoryPath;
        return;
    }

    m_lstImagePath.clear();

    auto lstImagePathTemp = directory.entryList(QDir::Files);
    qDebug() << "目录中文件数量:" << lstImagePathTemp.size();

    for(auto iter = lstImagePathTemp.begin(); iter != lstImagePathTemp.end(); ++iter)
    {
        QString fileExtension = iter->section('.', -1).toLower();
        if(fileExtension == "jpg" || fileExtension == "png" || fileExtension ==  "gif")
        {
            QString fullPath = strDirectoryPath + "/" + (*iter);
            fullPath = QDir::fromNativeSeparators(fullPath); // 标准化路径
            m_lstImagePath.append(fullPath);
            qDebug() << "添加到图片列表:" << fullPath;
        }
    }

    qDebug() << "图片列表构建完成，包含" << m_lstImagePath.size() << "个文件";
    qDebug() << "当前图片是否在列表中:" << m_lstImagePath.contains(m_strImageSourcePath);

    // 确保当前图片路径在新的图片列表中
    if (!m_lstImagePath.contains(m_strImageSourcePath) && !m_lstImagePath.isEmpty()) {
        // 如果当前图片不在新列表中，使用第一张图片
        qDebug() << "当前图片不在列表中，使用第一张图片:" << m_lstImagePath.first();
        m_strImageSourcePath = m_lstImagePath.first();
    }

    // 只有在路径确实改变时才发出信号
    if (originalPath != m_strImageSourcePath) {
        qDebug() << "路径已改变，发出 imageSourcePathChanged 信号";
        emit imageSourcePathChanged();
    } else {
        qDebug() << "路径未改变，不发出信号";
    }
}

QString CSlide::getImageFile()
{
    if(m_lstImagePath.size() == 0)
        return {};

    QString strFile = "";
    int index = m_lstImagePath.indexOf(m_strImageSourcePath);

    // 如果当前图片不在列表中，从第一张开始
    if (index == -1) {
        index = 0;
    }

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
        int randomStep = QRandomGenerator::global()->bounded(1, 5); // 生成1~7的随机数

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
        index = (index + 1) % m_lstImagePath.size();
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

    // 如果当前图片不在列表中，从第一张开始
    if (index == -1) {
        index = 0;
    }

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
    qDebug() << "getImageList 返回列表长度:" << m_lstImagePath.size();

    // 直接返回本地文件路径
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

    // 记录删除信息用于撤销
    int originalIndex = m_lstImagePath.indexOf(imagePath);
    m_undoManager.recordDelete(imagePath, originalIndex);

    // 简化实现：移动到临时trash目录（模拟回收站）
    // 在实际应用中，应该使用Windows Shell API来操作真正的回收站
    QFileInfo fileInfo(imagePath);
    QString trashDir = QDir::tempPath() + "/ImageViewer_Trash";

    // 确保trash目录存在
    QDir().mkpath(trashDir);

    QString trashFilePath = trashDir + "/" + fileInfo.fileName();

    // 先复制到trash目录（防止跨设备问题）
    //bool success = file.copy(trashFilePath); ///////////////////////////////////////////////////////
    bool success = copyFileOverwrite(imagePath, trashFilePath);

    if (success) {
        // 从原位置删除
        bool removeSuccess = file.remove();
        if (removeSuccess) {
            qDebug() << "图片已移动到回收站:" << qUtf8Printable(imagePath);
        } else {
            qDebug() << "从原位置删除失败";
            // 尝试恢复
            QFile::remove(trashFilePath);
            success = false;
        }
    } else {
        qDebug() << "移动到回收站失败:" << qUtf8Printable(imagePath);
        return false;
    }

    if (success) {
        // 记录删除前的索引
        int originalIndex = m_lstImagePath.indexOf(imagePath);

        // 从内存列表中移除
        m_lstImagePath.removeOne(imagePath);

        // 发出图片列表改变信号
        emit imageListChanged();

        // 如果删除的是当前显示的图片，更新当前图片路径
        if (m_strImageSourcePath == imagePath) {
            if (m_lstImagePath.isEmpty()) {
                // 列表为空，直接清空路径
                m_strImageSourcePath = "";
            } else {
                // 1. 尝试使用删除前的索引 (originalIndex)
                int newIndex = originalIndex;

                // 2. 如果删除前索引大于等于列表当前大小（即删除了最后一张），则指向新的最后一张
                if (newIndex >= m_lstImagePath.size()) {
                    newIndex = m_lstImagePath.size() - 1;
                }

                // 确保索引在有效范围内
                if (newIndex >= 0 && newIndex < m_lstImagePath.size()) {
                    m_strImageSourcePath = m_lstImagePath.at(newIndex);
                    qDebug() << "下一张图片路径：" << m_strImageSourcePath;
                } else {
                    // 如果索引无效，使用第一张图片
                    m_strImageSourcePath = m_lstImagePath.at(0);
                    qDebug() << "索引无效，使用第一张图片：" << m_strImageSourcePath;
                }
            }
            emit imageSourcePathChanged();
        }
    } else {
        qDebug() << "移动到回收站失败:" << imagePath;
    }

    return success;
}

bool CSlide::undoLastDelete()
{
    if (!m_undoManager.canUndo()) {
        qDebug() << "无法撤销，撤销栈为空";
        return false;
    }

    DeleteRecord record = m_undoManager.getLastDelete();

    // 检查文件是否实际存在（应该不存在，因为已在回收站）
    QFile file(record.filePath);
    bool fileExists = file.exists();

    if (!fileExists) {
        // 尝试从回收站恢复文件
        bool restoreSuccess = restoreFromTrash(record.filePath);
        if (!restoreSuccess) {
            return false;
        }
    }

    // 从撤销栈中移除记录
    m_undoManager.undoLastDelete();

    // 重新添加到图片列表的原始位置
    if (record.originalIndex >= 0 && record.originalIndex <= m_lstImagePath.size()) {
        m_lstImagePath.insert(record.originalIndex, record.filePath);
    } else {
        // 如果原始位置无效，添加到末尾
        m_lstImagePath.append(record.filePath);
    }

    // 发出图片列表改变信号
    emit imageListChanged();

    // 自动切换到恢复的图片
    m_strImageSourcePath = record.filePath;
    emit imageSourcePathChanged();

    return true;
}

bool CSlide::canUndo() const
{
    return m_undoManager.canUndo();
}

QString CSlide::cropImage(QString imagePath, int x, int y, int width, int height, int containerWidth, int containerHeight, double imageScale)
{

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

    // 图片在QML中以PreserveAspectFit模式显示，我们需要计算实际的显示尺寸

    // 在缩放状态下，我们需要重新计算坐标转换
    // 鼠标坐标是相对于imageContainer的，而imageContainer的尺寸已经包含了缩放

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
    // 注意：displayWidth/Height 已经考虑了缩放，因为 containerWidth/Height 包含了缩放
    double scaleX = (double)imgWidth / displayWidth;
    double scaleY = (double)imgHeight / displayHeight;


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


    // 直接裁剪原始图片，创建与选区尺寸相同的新图片
    QImage croppedImage = originalImage.copy(originalX, originalY, cropWidth, cropHeight);

    if (croppedImage.isNull()) {
        qDebug() << "裁剪失败";
        return "";
    }

    // 生成裁剪后图片的文件名（在原文件名基础上添加_cropped后缀）
    QFileInfo fileInfo(imagePath);
    QString croppedImagePath = fileInfo.path() + "/" + fileInfo.completeBaseName() + "_cropped." + fileInfo.suffix();
    qDebug() << "裁剪后的图片：" << croppedImagePath;

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

// 清理延迟删除相关代码，已改为即时删除+撤销机制

bool CSlide::restoreFromTrash(const QString& filePath)
{
    // 简化的"回收站"实现：将文件从temp/trash目录恢复到原始位置
    // 在实际应用中，应该使用Windows Shell API来操作真正的回收站

    QFileInfo fileInfo(filePath);
    QString trashDir = QDir::tempPath() + "/ImageViewer_Trash";
    QString trashFilePath = trashDir + "/" + fileInfo.fileName();

    // 检查trash中是否存在该文件
    QFile trashFile(trashFilePath);
    if (trashFile.exists()) {
        // 确保目标目录存在
        QDir().mkpath(fileInfo.absolutePath());

        // 将文件从trash目录恢复到原始位置
        bool success = trashFile.rename(fileInfo.absoluteFilePath());
        if (success) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

bool CSlide::copyFileOverwrite(const QString &src, const QString &dst)
{
    if (QFile::exists(dst)) {
        if (!QFile::remove(dst)) {
            qWarning() << "Failed to remove existing file:" << dst;
            return false;
        }
    }
    return QFile::copy(src, dst);
}

bool CSlide::setAsWallpaper(QString imagePath, int clickCount)
{
    if (imagePath.isEmpty()) {
        qWarning() << "图片路径为空，无法设置桌面背景";
        return false;
    }

    // 确保路径格式正确
    QFileInfo fileInfo(imagePath);
    if (!fileInfo.exists()) {
        qWarning() << "图片文件不存在:" << imagePath;
        return false;
    }

    // 检查文件格式是否支持作为桌面背景
    QString suffix = fileInfo.suffix().toLower();
    if (suffix != "jpg" && suffix != "jpeg" && suffix != "png" && suffix != "bmp") {
        qWarning() << "不支持的图片格式作为桌面背景:" << suffix;
        return false;
    }

    // 根据点击次数获取平铺模式
    WallpaperStyle style = getWallpaperStyleFromClickCount(clickCount);
    QString styleName = getWallpaperStyleName(clickCount);

    // 记录设置操作
    qDebug() << "开始设置桌面背景，图片路径:" << fileInfo.absoluteFilePath();
    qDebug() << "点击次数:" << clickCount << "，平铺模式:" << styleName;

    return setDesktopWallpaper(fileInfo.absoluteFilePath(), style);
}

bool CSlide::setDesktopWallpaper(const QString& imagePath, WallpaperStyle style)
{
#ifdef Q_OS_WIN
    // Windows 平台实现
    std::wstring wImagePath = imagePath.toStdWString();

    qDebug() << "调用 Windows API 设置桌面背景:" << imagePath;

    // 首先设置图片路径
    BOOL result = SystemParametersInfoW(
        SPI_SETDESKWALLPAPER,    // 设置桌面背景
        0,                       // 未使用
        (LPVOID)wImagePath.c_str(), // 图片文件路径
        SPIF_UPDATEINIFILE | SPIF_SENDCHANGE  // 更新配置并通知系统
    );

    if (result) {
        // 设置平铺样式
        int wallpaperStyle = 0;
        // 平铺开关标志
        int tileWallpaper = 0;

        switch (style) {
            case STRETCH:  // 拉伸
                wallpaperStyle = 2;
                tileWallpaper = 0;
                break;
            case TILE:     // 平铺
                wallpaperStyle = 0;
                tileWallpaper = 1;  // 启用平铺
                break;
            case CENTER:   // 居中
                wallpaperStyle = 0;
                tileWallpaper = 0;
                break;
            case FIT:      // 适应
                wallpaperStyle = 6;
                tileWallpaper = 0;
                break;
            default:
                wallpaperStyle = 2; // 默认拉伸
                tileWallpaper = 0;
                break;
        }

        // 通过注册表设置壁纸样式
        HKEY hKey;
        LONG regResult = RegOpenKeyExW(HKEY_CURRENT_USER,
                                       L"Control Panel\\Desktop",
                                       0, KEY_WRITE, &hKey);
        if (regResult == ERROR_SUCCESS) {
            // 设置壁纸样式
            std::wstring styleValue = std::to_wstring(wallpaperStyle);
            RegSetValueExW(hKey, L"WallpaperStyle", 0, REG_SZ,
                          (BYTE*)styleValue.c_str(),
                          (styleValue.length() + 1) * sizeof(wchar_t));

            // 设置平铺开关
            std::wstring tileValue = std::to_wstring(tileWallpaper);
            RegSetValueExW(hKey, L"TileWallpaper", 0, REG_SZ,
                          (BYTE*)tileValue.c_str(),
                          (tileValue.length() + 1) * sizeof(wchar_t));

            RegCloseKey(hKey);

            // 通知系统壁纸样式已更改
            SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, NULL,
                                 SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
        }

        qDebug() << "桌面背景设置成功:" << imagePath << "，平铺模式:" << getWallpaperStyleName(static_cast<int>(style));
        return true;
    } else {
        DWORD error = GetLastError();
        qWarning() << "桌面背景设置失败，错误代码:" << error;

        // 提供更详细的错误信息
        switch (error) {
            case ERROR_INVALID_PARAMETER:
                qWarning() << "错误：无效参数";
                break;
            case ERROR_ACCESS_DENIED:
                qWarning() << "错误：访问被拒绝，可能需要管理员权限";
                break;
            case ERROR_FILE_NOT_FOUND:
                qWarning() << "错误：文件未找到";
                break;
            default:
                qWarning() << "错误：未知错误";
                break;
        }
        return false;
    }
#else
    // 其他平台暂不支持
    qWarning() << "当前平台不支持设置桌面背景功能";
    return false;
#endif
}

CSlide::WallpaperStyle CSlide::getWallpaperStyleFromClickCount(int clickCount)
{
    // 循环模式：拉伸 → 平铺 → 居中 → 适应
    int styleIndex = clickCount % 4;
    switch (styleIndex) {
        case 0: return STRETCH;  // 第1次点击（或第5、9次...）
        case 1: return TILE;     // 第2次点击（或第6、10次...）
        case 2: return CENTER;   // 第3次点击（或第7、11次...）
        case 3: return FIT;      // 第4次点击（或第8、12次...）
        default: return STRETCH; // 默认
    }
}

QString CSlide::getWallpaperStyleName(int clickCount)
{
    WallpaperStyle style = getWallpaperStyleFromClickCount(clickCount);
    switch (style) {
        case STRETCH: return "拉伸";
        case TILE: return "平铺";
        case CENTER: return "居中";
        case FIT: return "适应";
        default: return "拉伸";
    }
}

