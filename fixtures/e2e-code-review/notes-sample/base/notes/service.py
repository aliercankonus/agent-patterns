from .auth import current_user


def create_note(conn, token, title, body):
    user = current_user(conn, token)
    cur = conn.execute(
        "INSERT INTO notes (owner_id, title, body) VALUES (?, ?, ?)", (user["id"], title, body)
    )
    conn.commit()
    return cur.lastrowid


def list_notes(conn, token, offset=0, limit=10):
    user = current_user(conn, token)
    rows = conn.execute(
        "SELECT id, title FROM notes WHERE owner_id = ? ORDER BY id", (user["id"],)
    ).fetchall()
    return [dict(r) for r in rows[offset : offset + limit]]


def get_note(conn, token, note_id):
    user = current_user(conn, token)
    row = conn.execute(
        "SELECT id, title, body FROM notes WHERE id = ? AND owner_id = ?", (note_id, user["id"])
    ).fetchone()
    return dict(row) if row else None
