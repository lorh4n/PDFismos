#include "LibraryDatabase.h"

bool initializeLibrarySchema(QSqlDatabase &db) {
    QSqlQuery query(db);

    if (!query.exec("PRAGMA foreign_keys = ON")) {
        qWarning() << query.lastError().text();
        return false;
    }

    if (!query.exec("PRAGMA user_version") || !query.next()) {
        qWarning() << "Erro ao ler a versão do banco :"
                   << query.lastError().text();
        return false;
    }

    const int version = query.value(0).toInt();
    query.finish();

    if (version == 1) {
        return true;
    }

    if (version != 0) {
        qWarning() << "Versão do banco não suportada:" << version;
        return false;
    }

    if (!db.transaction()) {
        qWarning() << db.lastError().text();
        return false;
    }

    if (!query.exec(R"(
      CREATE TABLE IF NOT EXISTS documents (
         id INTEGER PRIMARY KEY,
         file_path TEXT NOT NULL UNIQUE,
         title TEXT,
         added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      )") ||
        !query.exec(R"(
            CREATE TABLE IF NOT EXISTS reading_progress (
               document_id INTEGER PRIMARY KEY REFERENCES documents(id),
               page_index INTEGER NOT NULL CHECK (page_index >= 0),
               updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            )
         )")) {
        qWarning() << query.lastError().text();
        db.rollback();
        return false;
    }

    if (!query.exec("PRAGMA user_version = 1")) {
        qWarning() << "Erro ao gravar a versão do banco:"
                   << query.lastError().text();
        db.rollback();
        return false;
    }
    if (!db.commit()) {
        qWarning() << db.lastError().text();
        db.rollback();
        return false;
    }

    return true;
}

qint64 addDocument(QSqlDatabase &db, const QString &filePath, const QString &title) {
   QSqlQuery query(db);

   query.prepare(
      "INSERT INTO documents (file_path, title) "
      "VALUES (:file_path, :title)");
   query.bindValue(":file_path", filePath);
   query.bindValue(":title", title);

   if (!query.exec()) {
      qWarning() << "Erro ao cadastrar PDF: " << query.lastError().text();
      return -1;
   }

   return query.lastInsertId().toLongLong();
}