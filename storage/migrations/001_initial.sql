CREATE TABLE documents (
    id INTEGER PRIMARY KEY,
    file_path TEXT NOT NULL UNIQUE,
    title TEXT,
    added_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    color TEXT NOT NULL DEFAULT '#14B391'
);

CREATE TABLE reading_progress (
    document_id INTEGER PRIMARY KEY REFERENCES documents(id),
    page_index INTEGER NOT NULL CHECK (page_index >= 0),
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);