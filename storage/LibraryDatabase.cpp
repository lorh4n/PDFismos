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

qint64 addDocument(QSqlDatabase &db, const QString &filePath,
                   const QString &title) {
    QSqlQuery query(db);

    if (!query.prepare("INSERT INTO documents (file_path, title) "
                       "VALUES (:file_path, :title) "
                       "ON CONFLICT(file_path) DO NOTHING")) {
        qWarning() << query.lastError().text();
        return -1;
    }
    query.bindValue(":file_path", filePath);
    query.bindValue(":title", title);

    if (!query.exec()) {
        qWarning() << "Erro ao cadastrar PDF: " << query.lastError().text();
        return -1;
    }

    if (!query.prepare(
            "SELECT id FROM documents WHERE file_path = :file_path")) {
        qWarning() << query.lastError().text();
        return -1;
    }

    query.bindValue(":file_path", filePath);

    if (!query.exec() || !query.next()) {
        qWarning() << "Erro ao consultar o ID do PDF:"
                   << query.lastError().text();
        return -1;
    }

    return query.value(0).toLongLong();
}

QVariantList listDocuments(QSqlDatabase &db) {
    QSqlQuery query(db);

    QVariantList documents;

    if (!query.exec("SELECT title, file_path "
                    "FROM documents "
                    "ORDER BY added_at DESC, id DESC")) {
        qWarning() << "Erro ao listar documentos:" << query.lastError().text();
        return documents;
    }

    while (query.next()) {
        QVariantMap document;
        document.insert("title", query.value(0).toString());
        document.insert("filePath", query.value(1).toString());
        documents.append(document);
    }

    return documents;
}