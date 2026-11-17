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
| eng-manager | agent | this repo | Merge verdict from verified findings |

## Extras (opt-in with `--with`)

| Name | Kind | Source (original, not a mirror) | Pinned commit | Reviewed (who, date) | Why |
|---|---|---|---|---|---|
| _none yet_ | | | | | |

## Candidates (not adopted yet)

Approved in `docs/skills-review-collectivebrain.md` but **not vendored yet**. Each needs the full read described below, then a move to the Extras table.

| Name | Original source @ commit reviewed | License | Status |
|---|---|---|---|
| skill-creator | `anthropics/skills` @ `e4bb5d9` (`skills/skill-creator`) | Apache-2.0 | adopt: to vendor |
| verification-before-completion | `obra/superpowers` @ `22f0b46` (`skills/verification-before-completion`) | MIT | adopt: to vendor |
| ponytail (+ ponytail-review) | `dietrichgebert/ponytail` @ `96608e0` (`skills/ponytail*`) | MIT | adopt: to vendor |
| security-audit | `cloudflare/security-audit-skill` @ `c1c8a8c` | MIT | adopt: to vendor; wire in as the security lane of `/e2e-code-review` |
| 22 stack-specific skills | see the review doc, "Per project" | various | vendor on demand, when a project needs one |

## Adding an extra
1. Copy the skill from its **original** repository at a specific commit into `extras/skills/<name>/` (agents go in `extras/agents/<name>.md`).
2. Read every file in it. Remove anything that fetches remote content or widens tool permissions without a reason.
3. Add a row to the Extras table with the source, commit, reviewer and date.
4. Commit with the message `extras: add <name> @ <commit>`.
