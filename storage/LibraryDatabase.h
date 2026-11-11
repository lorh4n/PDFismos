#pragma once

#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariantList>

class QSqlDatabase;

bool initializeLibrarySchema(QSqlDatabase &db);
qint64 addDocument(QSqlDatabase &db, const QString &filePath, const QString &title);
QVariantList listDocuments(QSqlDatabase &db);
