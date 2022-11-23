#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QLocale>
#include <QTranslator>
#include <QFile>

#include "speechmodel.h"
#include "brainstormingmodel.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<loquatious::SpeechModel>(       "Speech",        1, 0, "SpeechModel");
    qmlRegisterType<loquatious::BrainstormingModel>("Brainstorming", 1, 0, "BrainstormingModel");

    qmlRegisterUncreatableMetaObject(
        loquatious::staticMetaObject,
        "SpeechModelState",
        1, 0,
        "SpeechModelState",
        "Error: only enums"
    );

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "SpeechTrainer_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/SpeechTrainer/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
