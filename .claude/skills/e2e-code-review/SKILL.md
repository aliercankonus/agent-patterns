---
name: e2e-code-review
description: Run a full multi-role code review (triage → developer and tester reviewers → verifier → manager verdict) on a branch, PR or path. Use when asked to review changes end to end before merge.
---
# End-to-end code review

Target: `$ARGUMENTS` (branch, PR number, or path; default is the current branch against the default branch).

Finding format: `.claude/skills/e2e-code-review/finding-schema.json`. Every reviewer returns it.

## Steps
1. **Resolve the base.** For a PR, run `gh pr view <n> --json baseRefName,headRefName,body`. Otherwise use `origin/HEAD`.
2. **Triage.** Spawn `diff-scout` with the base and keep its JSON. Skip docs-only units.
3. **Review in parallel**, in ONE message:
   - one `code-reviewer` per unit (brief = unit files + risk tags + base, following `.claude/skills/delegate/brief-template.md`)
   - one `test-reviewer` covering all units
4. **Merge.** Concatenate the findings, drop duplicates (same file, ±3 lines, same claim) and keep the higher severity.
5. **Verify.** Send all merged findings to one `finding-verifier`. Drop REJECTED findings and mark PLAUSIBLE ones as such.
6. **Verdict.** Send `eng-manager` only the verified findings + `git diff --stat` + test results + PR body.
7. **Report.** Print the manager verdict, then the findings grouped by severity as `file:line — claim — fix`. With `--comment` and a PR target, post inline comments via `gh`.

## Budget rules
- Never paste file contents into a subagent brief. Pass paths and line ranges.
- If the diff has more than 8 units, review the highest-risk 8 and list the rest as "not reviewed".
- Do not read source files yourself except to resolve a disagreement between agents.
