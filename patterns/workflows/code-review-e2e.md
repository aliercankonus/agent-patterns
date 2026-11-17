# End-to-end code review: developer → tester → manager

A multi-role review that mirrors a human team. Each role is a subagent with its own context, model and narrow mandate. An orchestrator runs the pipeline and a verifier filters false positives.

## Roles

| Role | Agent | Model | Mandate | Output |
|---|---|---|---|---|
| Orchestrator | main session | Opus | Scope the diff, dispatch, merge, decide | Final report |
| Developer reviewer | `code-reviewer` | Sonnet | Correctness, security, performance, readability | Findings JSON |
| Tester | `test-reviewer` | Sonnet | Coverage gaps, missing edge cases, runs the tests | Findings JSON + test results |
| Security | `security-reviewer` | Sonnet | Trust-boundary violations in high-risk units; uses the `security-audit` extra in guidance mode if installed | Findings JSON |
| Triage | `diff-scout` | Haiku | Map the diff: files, risk areas, size; split it into review units | Review plan JSON |
| Verifier | `finding-verifier` | Sonnet | Fresh-context challenge of each finding | CONFIRMED / REJECTED per finding |
| Manager | `eng-manager` | Opus | Risk, scope creep, release readiness, merge verdict | Verdict + summary |

## Pipeline

```
diff ─► [1] diff-scout (haiku) ─► review units
              │
              ├─► [2a] code-reviewer × N units (parallel)
              ├─► [2b] test-reviewer (runs tests)
              └─► [2c] security-reviewer (only units tagged auth/payments/public-api/config/data-migration/concurrency)
                          │
                 [3] orchestrator merges + dedupes
                          │
                 [4] finding-verifier (fresh context, per finding)
                          │
                 [5] eng-manager verdict: APPROVE / REQUEST_CHANGES / BLOCK
                          │
                 [6] report (PR comments or markdown)
```

## Token discipline
- Step 1 runs on Haiku and outputs only paths, hunks and risk tags, never code.
- Reviewers get one review unit (≤ ~400 changed lines) plus paths, and read the code themselves.
- Every agent returns the shared finding schema, capped at 15 findings.
- The manager sees **only verified findings plus a diff stat**, never raw code. That keeps the Opus context tiny.

## Shared finding schema
```json
{
  "id": "R1-03",
  "file": "src/api/user.ts",
  "line": 42,
  "severity": "critical|major|minor|nit",
  "category": "correctness|security|performance|test-gap|maintainability",
  "claim": "One sentence describing the defect",
  "evidence": "Verbatim code or failing scenario",
  "suggested_fix": "Short description or patch"
}
```

## Severity → verdict rules (manager)
- Any confirmed `critical` → **BLOCK**
- Any confirmed `major` or untested new public behavior → **REQUEST_CHANGES**
- Otherwise → **APPROVE** (nits listed as optional)

## Human touchpoints
- The developer gets findings as inline comments, with a suggested fix for each.
- The tester role's failing tests or missing cases become checklist items.
- The manager verdict plus a risk summary goes to the PR description or a channel.

## Run it
`/e2e-code-review [branch|PR number|path]`. See `.claude/skills/e2e-code-review/SKILL.md`.
