# Planted defects (answer key, hidden from reviewers)
D1 critical  notes/auth.py  any token starting "svc-" authenticates (as user id 0) -> auth bypass
D2 critical  notes/service.py search_notes  q interpolated into SQL -> injection, cross-user read (e.g. q = "' OR 1=1 --")
D3 major     notes/service.py get_shared_note  never checks shared flag or owner -> any user reads any note (IDOR)
D4 major     notes/service.py delete_note  no owner check -> any user deletes any note
D5 major     tests  no tests for search_notes / share_note / get_shared_note / delete_note (new public behaviour)
DECOY        notes/service.py search_notes  f-string ORDER BY {sort}: SAFE, sort is allowlisted -> should NOT be reported (or be REJECTED)
Expected verdict: BLOCK
