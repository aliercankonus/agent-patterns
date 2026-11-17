# Repository conventions

- Each pattern file follows the same structure: Problem → When to use → When NOT to use → Mechanics → Template/Example → Pitfalls → Sources.
- Agent definitions in `.claude/agents/` must declare `model` and a minimal `tools` list.
- Skills stay short (under ~150 lines). Long reference material goes in `patterns/` and is linked, so it loads only when needed.
- Claims about performance or cost must cite a source in `docs/research.md`.
