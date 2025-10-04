#include "undomanager.h"
#include <QDateTime>
#include <QDebug>

UndoManager::UndoManager(QObject *parent)
    : QObject{parent}
{}

void UndoManager::recordDelete(const QString &filePath, int originalIndex)
{
    DeleteRecord record;
    record.filePath = filePath;
    record.originalIndex = originalIndex;
    record.deleteTime = QDateTime::currentMSecsSinceEpoch();

    // 添加到栈顶
    m_undoStack.prepend(record);

    // 限制栈大小
    if (m_undoStack.size() > m_maxUndoSteps) {
        m_undoStack.removeLast();
    }

    qDebug() << "记录删除操作，当前撤销栈大小:" << m_undoStack.size();
}

bool UndoManager::undoLastDelete()
{
    if (m_undoStack.isEmpty()) {
        qDebug() << "撤销栈为空，无法撤销";
        return false;
    }

    DeleteRecord record = m_undoStack.takeFirst();
    qDebug() << "撤销删除操作，文件:" << record.filePath;
    qDebug() << "撤销后栈大小:" << m_undoStack.size();

    return true;
}

bool UndoManager::canUndo() const
{
    return !m_undoStack.isEmpty();
}

DeleteRecord UndoManager::getLastDelete() const
{
    if (m_undoStack.isEmpty()) {
        return DeleteRecord{};
    }
    return m_undoStack.first();
}

void UndoManager::clearStack()
{
    m_undoStack.clear();
    qDebug() << "清空撤销栈";
}