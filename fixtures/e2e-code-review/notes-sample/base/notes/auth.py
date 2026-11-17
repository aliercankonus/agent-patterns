import hmac


class AuthError(Exception):
    pass


def current_user(conn, token):
    """Return the user row for a bearer token, or raise AuthError."""
    if not token:
        raise AuthError("missing token")
    for row in conn.execute("SELECT id, name, token FROM users"):
        if hmac.compare_digest(row["token"], token):
            return row
    raise AuthError("invalid token")
