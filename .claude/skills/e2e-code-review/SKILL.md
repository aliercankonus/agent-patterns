---
name: e2e-code-review
description: Run a full multi-role code review (triage → developer, tester and security reviewers → verifier → manager verdict) on a branch, PR or path. Use when asked to review changes end to end before merge.
---
# End-to-end code review

Target: `$ARGUMENTS` (branch, PR number, or path; default is the current branch against the default branch).

Finding format: `.claude/skills/e2e-code-review/finding-schema.json`. Every reviewer returns it.

## Steps
1. **Resolve the base.** For a PR, run `gh pr view <n> --json baseRefName,headRefName,body`. Otherwise use the base the user named. If none was named, use `origin/HEAD` when it exists (`git rev-parse --verify -q origin/HEAD`); in a local-only repo fall back to `main`, then `master`. Say which base you used in the report.
2. **Triage.** Spawn `diff-scout` with the base and keep its JSON. Skip docs-only units.
3. **Review in parallel**, in ONE message:
   - one `code-reviewer` per unit (brief = unit files + risk tags + base, following `.claude/skills/delegate/brief-template.md`). For every unit the security reviewer also covers, add `Security lane: separate` to the brief, so the two reviewers don't spend tokens finding the same bugs.
   - one `test-reviewer` covering all units
   - one `security-reviewer` covering every unit tagged `auth`, `payments`, `public-api`, `config`, `data-migration` or `concurrency` (skip this if no unit carries those tags). It uses the `security-audit` skill in guidance mode when that extra is installed.
4. **Merge.** Concatenate the findings and drop duplicates, keeping the higher severity. Two findings are duplicates when they are in the same file, make the same claim, and are within ±3 lines **or** in the same function.
   - Cap `test-gap` findings at `major`: a missing test is never critical on its own. The defect it would have caught is reported separately.
   - **Don't trust empty results blindly.** If a reviewer returns `[]` for a unit tagged high-risk, do one targeted check yourself (e.g. grep the unit's diff for the risky call), or re-run that reviewer one model tier up.
   - If any agent claims it ran tests or changed something, confirm with the command output or `git diff`, not its word.
5. **Verify.** Send all merged findings to one `finding-verifier`. Drop REJECTED findings and mark PLAUSIBLE ones as such.
6. **Verdict.** Send `eng-manager` only the verified findings + `git diff --stat` + test results + PR body.
7. **Report.** Print the manager verdict, then the findings grouped by severity as `file:line — claim — fix`. With `--comment` and a PR target, post inline comments via `gh`.

## Budget rules
- Never paste file contents into a subagent brief. Pass paths and line ranges.
- If the diff has more than 8 units, review the highest-risk 8 and list the rest as "not reviewed".
- Do not read source files yourself except to resolve a disagreement between agents.
