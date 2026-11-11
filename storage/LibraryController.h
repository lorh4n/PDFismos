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
   private:

      QSqlDatabase m_db;
};