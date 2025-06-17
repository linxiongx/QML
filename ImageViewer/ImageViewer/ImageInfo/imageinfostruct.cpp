#include "imageinfostruct.h"

QString ImageInfoStruct::name() const
{
    return m_name;
}

void ImageInfoStruct::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

float ImageInfoStruct::size() const
{
    return m_size;
}

void ImageInfoStruct::setSize(float newSize)
{
    if (qFuzzyCompare(m_size, newSize))
        return;
    m_size = newSize;
    emit sizeChanged();
}

QString ImageInfoStruct::modifyDate() const
{
    return m_modifyDate;
}

void ImageInfoStruct::setModifyDate(const QString &newModifyDate)
{
    if (m_modifyDate == newModifyDate)
        return;
    m_modifyDate = newModifyDate;
    emit modifyDateChanged();
}

QString ImageInfoStruct::info() const
{
    return m_info;
}

void ImageInfoStruct::setInfo(const QString &newInfo)
{
    if (m_info == newInfo)
        return;
    m_info = newInfo;
    emit infoChanged();
}
