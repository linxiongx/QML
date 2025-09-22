#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Fusion"));

    QQmlApplicationEngine engine;
    qmlRegisterSingletonType(QUrl("qrc:/qt/qml/ZYYMusic/Basic/BasicConfig.qml"), "Basic", 1, 0, "BasicConfig");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ZYYMusic", "Main");

    return app.exec();
}
