# agent-patterns

A catalog of proven patterns for running AI agents on real engineering tasks. It covers two areas:

1. **End-to-end workflows.** Multi-role processes such as a code review that involves a developer, a tester and a manager, encoded as agents and skills you can run.
2. **Orchestration and token optimization.** A capable "master" model delegates to cheaper sub-models and keeps its own context small, so long tasks survive context limits.

## Layout

| Path | What it holds |
|---|---|
| `docs/research.md` | Research findings and sources behind every pattern |
| `docs/skills-review-collectivebrain.md` | Verdicts on all 100 collectivebrain.de catalog skills |
| `patterns/orchestration/` | Orchestrator–worker, model routing, context budgeting, compaction and handoff |
| `patterns/workflows/` | End-to-end workflows (code review first) |
| `.claude/agents/` | Core subagent definitions (Claude Code format) |
| `.claude/skills/` | Core skills (`/e2e-code-review`, `/delegate`, `/context-handoff`), each with its templates |
| `extras/` | Opt-in skills and agents, installed per project with `--with` |
| `skills.manifest.md` | Every skill and agent: source, pinned commit, review status |
| `templates/CLAUDE.project.md` | The CLAUDE.md a new project starts from |
| `bootstrap.sh` | Installs the starter into a project |
| `fixtures/` | Test fixtures for the skills (e.g. a sample project with planted bugs for `/e2e-code-review`) |

## Core principles

1. **Delegate to isolate context, not to look busy.** A subagent may read 50k tokens, but it should return a summary of 1–2k.
2. **Route by difficulty.** Use the strong model to plan, judge and synthesize, and cheap models to search, extract, classify and run checks.
3. **Brief like a contractor.** Each delegation states the objective, inputs, boundaries, output format and done criteria.
4. **Structured outputs between agents.** Agents pass JSON or fixed markdown sections to each other, never free prose.
5. **Externalize state.** Progress lives in files (`PROGRESS.md`, `handoff.md`), not in the context window.
6. **Verify adversarially.** A separate agent with fresh context checks findings before they are reported.
7. **Measure tokens per *task*, not per request.** Over-compressing context causes re-reads and costs more in total.

## Starting a new project

**Option A: from the GitHub template** (for a brand-new repository)

```bash
gh repo create my-project --private --template <owner>/agent-patterns --clone
```

```bash
cd my-project && ./bootstrap.sh --init
```

`--init` replaces CLAUDE.md with the project template, moves the pattern docs to `docs/agent-patterns/`, and removes the files only the starter needs.

**Option B: copy into a new or existing project**

```bash
./bootstrap.sh ../my-project
```

Existing files are never overwritten unless you pass `--force`. If the project already has a CLAUDE.md, the template is written to `CLAUDE.agent-patterns.md` for you to merge.

**Opt-in extras** (either option):

```bash
./bootstrap.sh --list
```

```bash
./bootstrap.sh ../my-project --with recommended
```

`recommended` installs four vetted extras: `skill-creator`, `verification-before-completion`, `ponytail` and `security-audit`. You can also name extras one by one, e.g. `--with ponytail,security-audit`.

Each install records the starter version and extras in `.claude/agent-patterns.version`, so you can tell later which projects are behind.

After installing, fill in the `{{placeholders}}` in CLAUDE.md, then use `/delegate`, `/e2e-code-review` and `/context-handoff`.

## Maintaining the starter
- Turn on the template flag once the repository is on GitHub: `gh repo edit <owner>/agent-patterns --template`
- Rules for changing the starter itself are in `CLAUDE.md`.
- Adding a third-party skill: follow "Adding an extra" in `skills.manifest.md`.
