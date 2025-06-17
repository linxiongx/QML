#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSettings>
#include <QCoreApplication>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QSettings settings("config.ini", QSettings::IniFormat);
    QString selector = settings.value("FileSelectors/Selector", "").toString();
    if (!selector.isEmpty())
    {
        qputenv("QT_FILE_SELECTORS", selector.toUtf8());
    }

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("ImageViwer", "MainFile");


    return app.exec();
}
