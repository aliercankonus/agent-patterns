# Context budgeting, compaction and handoff

## Problem
Long tasks hit the context limit. Default auto-compaction is lossy: it drops file paths, exact errors and constraints.

## Strategy stack (apply in order)
1. **Prevent.** Delegate read-heavy work to subagents. Read line ranges, not whole files. Use `grep` before `cat`.
2. **Clear.** Drop stale tool outputs (old test runs, superseded file reads) as soon as they are acted on.
3. **Externalize.** Keep durable state in files:
   - `PROGRESS.md`: goal, decisions, done/next, open questions
   - `handoff.md`: written before compaction or a session switch (see `templates/handoff.md`)
4. **Compact with structure.** When you must summarize, use a fixed schema (below), not free prose.
5. **Fresh-context restart.** For very long tasks, start a new session or subagent from `handoff.md` instead of compacting repeatedly.

## Structured compaction schema
```
GOAL: <one sentence, verbatim from user>
CONSTRAINTS: <bullet list, verbatim>
DECISIONS: <decision — reason>
FILES TOUCHED: <path:lines — what changed>
CURRENT STATE: <what works / what fails, with exact error text>
NEXT STEPS: <ordered>
OPEN QUESTIONS: <for user>
```

## Budget thresholds (heuristic)
- At **~60%** of the window: start delegating all further reading.
- At **~75%**: write or update `handoff.md`.
- At **~85%**: compact with the schema, or restart from the handoff.

## Measure the right thing
Track **tokens per completed task**. Over-aggressive compression raises the total because the agent re-reads and re-explores (Factory). Test summaries with *probes*: can the agent still answer "which file had the failing test and what was the error?"
