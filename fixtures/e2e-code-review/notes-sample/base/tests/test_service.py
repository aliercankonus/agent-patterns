import unittest

from notes import db, service
from notes.auth import AuthError


def setup():
    conn = db.connect()
    conn.execute("INSERT INTO users (id, name, token) VALUES (1, 'alice', 'tok-alice')")
    conn.execute("INSERT INTO users (id, name, token) VALUES (2, 'bob', 'tok-bob')")
    conn.commit()
    return conn


class ServiceTests(unittest.TestCase):
    def test_create_and_get(self):
        conn = setup()
        nid = service.create_note(conn, "tok-alice", "t", "b")
        self.assertEqual(service.get_note(conn, "tok-alice", nid)["body"], "b")

    def test_other_user_cannot_read(self):
        conn = setup()
        nid = service.create_note(conn, "tok-alice", "t", "secret")
        self.assertIsNone(service.get_note(conn, "tok-bob", nid))

    def test_bad_token(self):
        with self.assertRaises(AuthError):
            service.list_notes(setup(), "nope")

    def test_list_pagination(self):
        conn = setup()
        for i in range(5):
            service.create_note(conn, "tok-alice", f"n{i}", "")
        self.assertEqual(len(service.list_notes(conn, "tok-alice", 0, 3)), 3)


if __name__ == "__main__":
    unittest.main()
