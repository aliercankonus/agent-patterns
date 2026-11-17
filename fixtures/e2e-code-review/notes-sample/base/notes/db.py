import sqlite3


def connect(path=":memory:"):
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.executescript(
        """
        CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, token TEXT UNIQUE);
        CREATE TABLE IF NOT EXISTS notes (
            id INTEGER PRIMARY KEY, owner_id INTEGER NOT NULL, title TEXT, body TEXT
        );
        """
    )
    return conn
