#ifndef MYEXTENSIONPLUGINS_H
#define MYEXTENSIONPLUGINS_H

#include <QObject>
#include <QQmlExtensionPlugin>

class MyExtensionPlugins : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    MyExtensionPlugins();

public:
    virtual void initializeEngine(QQmlEngine* engine, const char* uri) override;
    virtual void registerTypes(const char* uri) override;
};

#endif // MYEXTENSIONPLUGINS_H
