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

| Name | Original source | Status | Notes |
|---|---|---|---|
| skill-creator | `anthropics/skills` | to review | Build and test new skills for this repo |
| frontend-design | `anthropics/skills` | to review | Only for projects with a UI |
| collectivebrain.de catalog | various | blocked | Full list not yet retrieved; review category by category (AI & Automation, Office & Data first) |

## Adding an extra
1. Copy the skill from its **original** repository at a specific commit into `extras/skills/<name>/` (agents go in `extras/agents/<name>.md`).
2. Read every file in it. Remove anything that fetches remote content or widens tool permissions without a reason.
3. Add a row to the Extras table with the source, commit, reviewer and date.
4. Commit with the message `extras: add <name> @ <commit>`.
