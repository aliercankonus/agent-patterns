# {{PROJECT_NAME}}

<!-- Installed by agent-patterns bootstrap. Keep this file lean: everything here is loaded into every agent's context. -->

## Project
- Purpose: {{one sentence}}
- Stack: {{languages, frameworks, runtime}}
- Default branch: {{main}}

## Commands
- Install: `{{...}}`
- Test (all): `{{...}}`
- Test (single file): `{{...}}`
- Lint / format: `{{...}}`
- Run locally: `{{...}}`

## Code conventions
- {{e.g. error handling style, module layout, naming}}
- {{things agents get wrong in this codebase}}

## Do not touch
- {{generated files, vendored code, migrations already applied, secrets}}

## Agent workflow
- Large or parallel tasks: use `/delegate`. Read-heavy work goes to subagents, which return summaries, not file dumps.
- Before merging: run `/e2e-code-review`.
- When the context is ~75% full, or before switching sessions: run `/context-handoff`, then resume from `handoff.md`.
- Keep durable progress in `PROGRESS.md` (goal, decisions, done/next).
- Model tiers: haiku for search/extract/classify, sonnet for focused code work, opus for planning and final judgment.
