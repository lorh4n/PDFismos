#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QUrl>
#include <QVariantList>

class LibraryController : public QObject {
    Q_OBJECT

  public:
    explicit LibraryController(const QSqlDatabase &db);

    Q_INVOKABLE qint64 registerDocument(const QUrl &source);
    Q_INVOKABLE QVariantList documents();
    Q_INVOKABLE bool saveReadingProgress(qint64 documentId, int pageIndex);
    Q_INVOKABLE int readingProgress(qint64 documentId);
    Q_INVOKABLE QString documentColor(qint64 documentId);
    Q_INVOKABLE QString fileName(const QUrl &source);

  private:
    QSqlDatabase m_db;
};
