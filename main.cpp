#include "notemanager.h"
#include <time.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>


#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QDebug>
#include "UnixSignalHandler.h"
#include "lifecycleconsumer.h"

int main(int argc, char *argv[])
{
    setenv("QT_QPA_PLATFORM","wayland", 1); // force to use wayland plugin
    setenv("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1", 1);

    QGuiApplication app(argc, argv);
    QQuickView view;
    NoteManager noteManager;

    QObject::connect(&app, &QCoreApplication::aboutToQuit, &noteManager, &NoteManager::finalizeWrite);

    view.engine()->rootContext()->setContextProperty("noteManager", &noteManager);
    view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view.show();


#ifdef Q_OS_UNIX
    UnixSignalHandler signalHandler;
    QObject::connect(&signalHandler, &UnixSignalHandler::interruptRequested,
                     &app, &QCoreApplication::quit);
    QObject::connect(&signalHandler, &UnixSignalHandler::terminateRequested,
                     &app, &QCoreApplication::quit);
#endif // Q_OS_UNIX

    return app.exec();
}
