#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "cslide.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // 调试：打印命令行参数
    qDebug() << "命令行参数数量:" << argc;
    for (int i = 0; i < argc; ++i) {
        qDebug() << "参数" << i << ":" << argv[i];
    }

    QIcon icon(":/qt/qml/ImageViewer/res/app.png");
    app.setWindowIcon(icon);

    QQmlApplicationEngine engine;

    qmlRegisterType<CSlide>("org.example.cslide",1, 0, "CSlide");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ImageViewer", "Main");

    return app.exec();
}
