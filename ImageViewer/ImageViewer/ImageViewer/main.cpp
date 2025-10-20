#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "cslide.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);


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
