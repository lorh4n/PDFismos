#include "LibraryController.h"

#include "LibraryDatabase.h"

#include <QDebug>
#include <QFileInfo>


LibraryController::LibraryController(const QSqlDatabase &db) : m_db(db) {}

qint64 LibraryController::registerDocument(const QUrl &source)
{
    if (!source.isLocalFile()) {
        qWarning() << "O documento precisa ser um arquivo local.";
        return -1;
    }

    const QFileInfo fileInfo(source.toLocalFile());
    const QString filePath = fileInfo.canonicalFilePath();

    if (filePath.isEmpty()) {
        qWarning() << "Arquivo do documento não encontrado.";
        return -1;
    }

    return addDocument(m_db, filePath, fileInfo.fileName());
} 
