#include "myextensionplugins.h"
#include "imageinfo.h"
#include <QQmlEngine>

MyExtensionPlugins::MyExtensionPlugins() {}

void MyExtensionPlugins::initializeEngine(QQmlEngine *engine, const char *uri)
{
}

void MyExtensionPlugins::registerTypes(const char *uri)
{
    qmlRegisterType<ImageInfo>(uri, 1, 0, "ImageInfo");
    qmlRegisterType<ImageInfoStruct>(uri, 1, 0, "ImageInfoStruct");
}
