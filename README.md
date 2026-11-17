# agent-patterns

A catalog of proven patterns for running AI agents on real engineering tasks. It covers two areas:

1. **End-to-end workflows.** Multi-role processes such as a code review that involves a developer, a tester and a manager, encoded as agents and skills you can run.
2. **Orchestration and token optimization.** A capable "master" model delegates to cheaper sub-models and keeps its own context small, so long tasks survive context limits.

## Layout

| Path | What it holds |
|---|---|
| `docs/research.md` | Research findings and sources behind every pattern |
| `patterns/orchestration/` | Orchestrator–worker, model routing, context budgeting, compaction and handoff |
| `patterns/workflows/` | End-to-end workflows (code review first) |
| `templates/` | Delegation brief and handoff templates |
| `.claude/agents/` | Ready-to-use subagent definitions (Claude Code format) |
| `.claude/skills/` | Skills that run the workflows (`/e2e-code-review`, `/delegate`, `/context-handoff`) |

## Core principles

1. **Delegate to isolate context, not to look busy.** A subagent may read 50k tokens, but it should return a summary of 1–2k.
2. **Route by difficulty.** Use the strong model to plan, judge and synthesize, and cheap models to search, extract, classify and run checks.
3. **Brief like a contractor.** Each delegation states the objective, inputs, boundaries, output format and done criteria.
4. **Structured outputs between agents.** Agents pass JSON or fixed markdown sections to each other, never free prose.
5. **Externalize state.** Progress lives in files (`PROGRESS.md`, `handoff.md`), not in the context window.
6. **Verify adversarially.** A separate agent with fresh context checks findings before they are reported.
7. **Measure tokens per *task*, not per request.** Over-compressing context causes re-reads and costs more in total.

## Quick start (Claude Code)

```bash
cp -r .claude /path/to/your/project/
```

Then, inside that project, run `/e2e-code-review` on a branch or PR, or `/delegate <task>` to apply the orchestrator pattern.
