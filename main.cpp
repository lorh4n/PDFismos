#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QSqlDatabase>
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QDir>
#include <QStandardPaths>

#include "storage/LibraryDatabase.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("Estudismos");
    QCoreApplication::setApplicationName("PDFismos");
    QQmlApplicationEngine engine;
    qDebug() << "Driver SQLite disponível?"
             << QSqlDatabase::isDriverAvailable("QSQLITE");
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    // db.setDatabaseName(":memory");

    const QString dataDirectory =
        QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    QDir().mkpath(dataDirectory);
    db.setDatabaseName(dataDirectory + "/pdfismos.sqlite");

    if (!db.open()) {
        qWarning() << "Error ao abrir o banco: " << db.lastError().text();
    } else if (!initializeLibrarySchema(db)) {
        qWarning() << "Erro ao preparar a biblioteca.";
    }

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
        []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("PDFismos", "Main");

    return QGuiApplication::exec();
}
