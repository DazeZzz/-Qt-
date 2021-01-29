#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "loginhandler.h"
#include "registerhandler.h"
#include "storestatus.h"
#include "favorite.h"
#include "timerC.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<LoginHandler>("Login.Handler", 1, 0, "LoginHandler");
    qmlRegisterType<RegisterHandler>("Register.Handler", 1, 0, "RegisterHandler");
    qmlRegisterType<StoreStatus>("Store.Status", 1, 0, "StoreStatus");
    qmlRegisterType<Favorite>("Favorite", 1, 0, "Favorite");
    qmlRegisterType<TimerC>("TimerC", 1, 0, "TimerC");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/SplashScreen.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
