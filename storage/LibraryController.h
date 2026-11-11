#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QUrl>

class LibraryController : public QObject {
   Q_OBJECT

   public:
      explicit LibraryController(const QSqlDatabase &db);

      Q_INVOKABLE qint64 registerDocument(const QUrl &source);
   private:

      QSqlDatabase m_db;
};