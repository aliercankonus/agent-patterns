# agent-patterns: rules for working on the starter itself

<!-- This file is for the starter repo. New projects get templates/CLAUDE.project.md instead (via bootstrap.sh). -->

- Each pattern file follows the same structure: Problem → When to use → When NOT to use → Mechanics → Template/Example → Pitfalls → Sources.
- Agent definitions in `.claude/agents/` must declare `model` and a minimal `tools` list.
- Skills must be **self-contained**: they may reference only files under `.claude/`, because `patterns/` is not at the same path in installed projects. Keep each SKILL.md under ~150 lines and put templates and schemas next to it.
- Every skill or agent, core or extra, has a row in `skills.manifest.md`. Third-party extras are vendored from their original source at a pinned commit, after a full read.
- Claims about performance or cost must cite a source in `docs/research.md`.
- After changing `bootstrap.sh`, test both flows: copy into an empty directory, and `--init` on a throwaway clone.
- After changing `/e2e-code-review` or its agents, re-run `fixtures/e2e-code-review/notes-sample` and update its "Last run" table.
