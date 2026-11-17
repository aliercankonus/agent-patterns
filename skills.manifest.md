# Skills manifest

Every skill and agent that ships with this starter is listed here. Third-party skills are **vendored** (copied into `extras/`) at a pinned commit, never fetched at install time, and are only added after someone has read the full SKILL.md.

## Core (always installed)

| Name | Kind | Source | Purpose |
|---|---|---|---|
| delegate | skill | this repo | Orchestrator–worker with right-sized models |
| context-handoff | skill | this repo | Structured handoff before compaction or a session switch |
| e2e-code-review | skill | this repo | Developer → tester → verifier → manager review pipeline |
| diff-scout | agent | this repo | Haiku triage of a diff into review units |
| code-reviewer | agent | this repo | Developer-perspective review |
| test-reviewer | agent | this repo | Tester-perspective review, runs the tests |
| finding-verifier | agent | this repo | Fresh-context false-positive filter |
| security-reviewer | agent | this repo | Security lane of the review; uses the `security-audit` extra when installed |
| eng-manager | agent | this repo | Merge verdict from verified findings |

## Extras (opt-in with `--with`)

Install all four with `--with recommended`. Each folder has an `UPSTREAM.md` with the full commit hash.

| Name | Kind | Source (original, not a mirror) | Pinned commit | Reviewed (who, date) | Why |
|---|---|---|---|---|---|
| skill-creator | skill | `anthropics/skills` → `skills/skill-creator` | `e4bb5d9` | Claude for the repo owner, 2026-11-17 | Build and evaluate new skills |
| verification-before-completion | skill | `obra/superpowers` → `skills/verification-before-completion` | `22f0b46` | Claude for the repo owner, 2026-11-17 | No "done" claims without fresh evidence |
| ponytail | skill | `dietrichgebert/ponytail` → `skills/ponytail` | `96608e0` | Claude for the repo owner, 2026-11-17 | Smallest complete change; smaller diffs |
| security-audit | skill | `cloudflare/security-audit-skill` → `skills/security-audit` | `c1c8a8c` | Claude for the repo owner, 2026-11-17 | Evidence-first security review; powers `security-reviewer` |

### Review notes
- **Read in full:** every instruction and reference file an agent can load: all SKILL.md files; skill-creator `agents/grader.md`, `comparator.md`, `analyzer.md` and `references/schemas.md`; all 14 security-audit reference files and `report-schema.json` (completed 2026-11-17). Findings: no network access, no installs, no hidden instructions, no permission changes. The security-audit files are strictly defensive: source review plus sandboxed local checks, no live targets.
- **Code (scripts, validators, viewer HTML):** checked for network access, process execution and file writes, with every hit read in context. Not read line by line. The validators only read the JSON file they're given.
- **skill-creator behaviours to know about:**
  - `run_eval.py` / `run_loop.py` / `improve_description.py` start `claude -p` subprocesses, which spend tokens on your account.
  - `run_eval.py` writes a temporary command file under `.claude/commands/` and deletes it afterwards.
  - `generate_review.py` serves a viewer on 127.0.0.1 and stops (SIGTERM) whatever already listens on its port.
  - The viewer HTML loads Google Fonts and SheetJS from public CDNs (SheetJS is pinned with an integrity hash).
- **security-audit:** full-audit mode writes reports to `~/security-audit-skill/<repo>/` (outside the project) and only runs on an explicit request. Our `security-reviewer` uses guidance mode only. The upstream `*.test.cjs` files were not vendored.
- **Not vendored:** `ponytail-review`, which duplicates our `code-reviewer`; the ponytail hooks and commands; the rest of Superpowers (it has a SessionStart hook that adds context every session).

## Candidates (not adopted yet)

| Name | Status |
|---|---|
| 22 stack-specific skills | Vendor on demand when a project needs one. See `docs/skills-review-collectivebrain.md`, "Per project". |

## Adding an extra
1. Copy the skill from its **original** repository at a specific commit into `extras/skills/<name>/` (agents go in `extras/agents/<name>.md`).
2. Read every file in it. Remove anything that fetches remote content or widens tool permissions without a reason.
3. Add a row to the Extras table with the source, commit, reviewer and date.
4. Commit with the message `extras: add <name> @ <commit>`.
