#pragma once

#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariantList>
#include <QUrl>

class QSqlDatabase;

bool initializeLibrarySchema(QSqlDatabase &db);
qint64 addDocument(QSqlDatabase &db, const QString &filePath, const QString &title);
QVariantList listDocuments(QSqlDatabase &db);
bool saveDocumentProgress(QSqlDatabase &db, qint64 documentId, int pageIndex);
int loadDocumentProgress(QSqlDatabase &db, qint64 documentId);
QString loadDocumentColor(QSqlDatabase &db, qint64 documentId);
