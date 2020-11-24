#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "AVRCommunicator.h"
#include <QtQml>
#include <QQmlContext>
#include "dbmodel.h"
#include "platformios.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QtQuick2ApplicationViewer viewer;
    qmlRegisterType<AVRCommunicator>("st.app", 1, 0, "AVRCommunicator");
    qmlRegisterType<DbModel>("st.app", 1, 0, "DbModel");
    qmlRegisterType<PlatformiOS>("st.app", 1, 0, "PlatformiOS");
    bool isiOs = false;
    bool isMac = false;
    bool isBlackberry = false;
    bool isAndroid = false;
#if defined(Q_OS_IOS)
    isiOs = true;
#elif defined(Q_OS_MAC)
    isMac = true;
#elif defined(Q_OS_BLACKBERRY)
    isBlackberry = true;
#elif defined(Q_OS_ANDROID)
    isAndroid = true;
#endif
    viewer.rootContext()->setContextProperty("cpPlatform_iOS", isiOs);
    viewer.rootContext()->setContextProperty("cpPlatform_Mac", isMac);
    viewer.rootContext()->setContextProperty("cpPlatform_Blackberry", isBlackberry);
    viewer.rootContext()->setContextProperty("cpPlatform_Android", isAndroid);

    viewer.setMainQmlFile(QStringLiteral("qml/remote/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
