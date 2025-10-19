#ifndef CWINDOWMANAGER_H
#define CWINDOWMANAGER_H

#include <QObject>
#include <QWindow>
#include <QAbstractNativeEventFilter>

class CWindowManager : public QObject, public QAbstractNativeEventFilter
{
    Q_OBJECT
    Q_PROPERTY(bool isMinimized READ isMinimized NOTIFY minimizedStateChanged)

public:
    explicit CWindowManager(QObject *parent = nullptr);
    ~CWindowManager();

    // 设置主窗口对象
    void setMainWindow(QWindow *window);

    // 获取最小化状态
    bool isMinimized() const { return m_isMinimized; }

    // 公开的 Q_INVOKABLE 方法
    Q_INVOKABLE void toggleWindowVisibility();
    Q_INVOKABLE void showWindow();
    Q_INVOKABLE void hideWindow();
    Q_INVOKABLE void minimizeWindow();

signals:
    void minimizedStateChanged(bool minimized);
    void taskbarIconClicked();

protected:
    // 原生事件过滤器
    bool nativeEventFilter(const QByteArray &eventType, void *message, long *result) override;

private:
    QWindow *m_mainWindow;
    bool m_isMinimized;
    bool m_isHidden;

#ifdef Q_OS_WIN
    void setupWindowsEventFilter();
    void handleWindowsMessage(MSG *msg);
#endif
};

#endif // CWINDOWMANAGER_H
