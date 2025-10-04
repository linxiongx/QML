#ifndef UNDOMANAGER_H
#define UNDOMANAGER_H

#include <QObject>
#include <QString>
#include <QList>

struct DeleteRecord
{
    QString filePath;        // 删除的文件路径
    int originalIndex;       // 在胶片栏中的原始位置
    qint64 deleteTime;       // 删除时间戳
};

class UndoManager : public QObject
{
    Q_OBJECT

public:
    explicit UndoManager(QObject *parent = nullptr);

    // 记录删除操作
    void recordDelete(const QString &filePath, int originalIndex);

    // 撤销最后一次删除
    bool undoLastDelete();

    // 检查是否可以撤销
    bool canUndo() const;

    // 获取最后一次删除记录
    DeleteRecord getLastDelete() const;

    // 清空撤销栈
    void clearStack();

private:
    QList<DeleteRecord> m_undoStack;
    int m_maxUndoSteps = 10;  // 最大撤销步数
};

#endif // UNDOMANAGER_H