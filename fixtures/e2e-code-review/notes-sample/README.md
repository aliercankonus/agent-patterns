# Fixture: notes-sample

A tiny multi-user notes library (Python, stdlib `unittest`) with a feature branch containing **planted defects**. Use it to check that `/e2e-code-review` still catches them after you change the review skill or its agents.

## Run

```bash
fixtures/e2e-code-review/notes-sample/setup.sh
```

The script prints the path of a fresh git repo (outside this starter) with the starter installed. Then, in Claude Code:

```
/e2e-code-review feature/search-and-sharing in <printed path> (base: main)
```

Do **not** give reviewers this folder or `answer-key.md`. Score the result against the answer key afterwards.

## Scoring

| Check | Pass when |
|---|---|
| Recall | D1–D5 all reported and CONFIRMED by the verifier |
| Precision | The DECOY is not reported, or the verifier REJECTS it; no other REJECTED-worthy finding survives |
| Verdict | Manager says BLOCK |
| Cost | Note total subagent tokens. The manager should stay small because it never sees code |

## Last run

| Date | Starter commit | Recall | Decoy | Verdict | Extra findings | Subagent tokens |
|---|---|---|---|---|---|---|
| 2026-11-17 | `df39f5d` | 5/5 | not reported ✅ | BLOCK ✅ | none beyond the answer key and the migration gap | ~73k across 6 agents (manager ~5k) |
| 2026-11-17 | `9ebad7b` | 5/5 | not reported ✅ | BLOCK ✅ | migration gap (now CONFIRMED: `connect()` takes a file path); `share_note` silently succeeds on notes you don't own, and there's no unshare (minor) | ~76k across 6 agents (manager ~6k) |
| 2026-11-17 | `ccdb4a8` | 5/5 | not reported ✅ | BLOCK ✅ | migration gap for the `shared` column (real, PLAUSIBLE) | ~75k across 6 agents (manager ~6k) |

Issues found in the `ccdb4a8` run, fixed in `9ebad7b` and checked in the run above:
- No `origin/HEAD` in local repos. ✅ The review fell back to `main` without being told.
- The duplicate rule missed the same bug reported 6 lines apart. ✅ Lines 50 and 56 merged as the same function.
- Test-gap findings were marked critical. ✅ All were major or minor.

The `9ebad7b` run also showed that the security reviewer opens the security-audit skill (`SKILL.md`, `ATTACK-CLASSES.md`, by its own report).

### `df39f5d` run notes
- **Fixed-branch check (should approve).** Alongside the planted run, all 8 findings were fixed in a throwaway copy, with 13 new tests that fail on the buggy code and pass after the fix. Reviewing that branch gave **APPROVE**. No critical or major findings remained. The reviewers surfaced a real spec conflict: README says "only their own notes", while docs/sharing.md lets anyone signed in read shared notes. The manager flagged it for a product decision. To repeat this check, fix the bugs in a `setup.sh` copy and re-review it.
- **Reviewer overlap fix: inconclusive.** The developer reviewer still reported the four security bugs despite `Security lane: separate`. Agent definitions load when a session starts, and this session started before `code-reviewer.md` was edited, so it most likely ran the old definition. Re-check in a fresh session: the developer reviewer should report no security findings.
- **Security reviewer under-uses the skill.** On the fixed branch it opened no security-audit files. On the planted branch it opened only `ATTACK-CLASSES.md`. Its findings were still correct, and the orchestrator's targeted check agreed with its empty result.
