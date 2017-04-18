#include "lifecycleconsumer.h"
#include <QtDBus/QtDBus>
#include <QDebug>
#include "lifecycleconsumeradaptor.h"
 #include <QDBusInterface>
LifeCycleConsumer::LifeCycleConsumer(QObject *parent) : QObject(parent),
  m_lifecycleconsumeradaptor(new LifeCycleConsumerAdaptor(this))
{
    const QString objectPath = "/org/genivi/development/platform/Notepad";
    const QString serviceName = "org.genivi.development.platform.Notepad";

    if (setupDBusInterface(serviceName, objectPath)) {
        registerAsShutdownConsumer(serviceName, objectPath);
    }
}

int LifeCycleConsumer::LifecycleRequest(uint Request, uint RequestId)
{
    return 0;
}

bool LifeCycleConsumer::setupDBusInterface(const QString &serviceName, const QString &objectPath)
{
    // Register
    QDBusConnection connection = QDBusConnection::connectToBus(QDBusConnection::SessionBus,"com.genivi.gpd");
    if (!connection.isConnected())
    {
        qWarning() << "Could not connect to " << connection.name() << connection.lastError().message();
        return false;
    }

    const bool registerObjectResult = connection.registerObject(objectPath, this);
    if (!registerObjectResult) {
        qWarning() << "Error while registering object on " << connection.name();
        qWarning() << connection.lastError().name();
        qWarning() << connection.lastError().message();
        return false;
    }
    qDebug() << "Successfully registered object "<<connection.name() << " obj: " << objectPath;


    const bool registerServiceResult = connection.registerService(serviceName);
    if (!registerServiceResult) {
        qWarning() << "Error while registering service on " << connection.name() << "the service: " <<serviceName;
        qWarning() << connection.lastError().name();
        qWarning() << connection.lastError().message();
        return false;
    }
    qDebug() << "Successfully registered service " << serviceName;
    return true;
}

bool LifeCycleConsumer::registerAsShutdownConsumer(const QString &serviceName, const QString &objectPath)
{
    QDBusInterface iface("org.genivi.NodeStateManager",
                         "/org/genivi/NodeStateManager/Consumer",
                         "org.genivi.NodeStateManager.Notepad",
                         QDBusConnection::sessionBus());

    if (!iface.isValid()) {
         // Could not connect to NSM
        qWarning() << "Could not connect to NSM";
        qWarning() <<iface.service();
        qWarning() << iface.lastError().name();
        qWarning() << iface.lastError().message();
        return false;
    }

    uint shutdownMode = 1;
    uint timeoutMs = 3000;

    QDBusMessage message = iface.call("RegisterShutdownClient", serviceName, objectPath, shutdownMode, timeoutMs);
    qDebug() << message;
    qDebug() << message.arguments();
    qDebug() << "Successfully registered as NodeShutdownClient";
    return true;
}
