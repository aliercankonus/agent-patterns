# Orchestrator–worker

## Problem
A single agent doing everything fills its context with search noise and loses track of the goal.

## When to use
- The task breaks into **independent** subtasks: files, modules, facets, checks.
- Subtasks need a lot of reading but produce small answers.

## When NOT to use
- Tightly coupled edits where every step depends on the last one. Use one agent there.
- Tiny tasks: delegation overhead (≈ brief + summary + coordination) exceeds the savings.

## Mechanics
1. **Plan (strong model).** Break the task into N subtasks, each with a brief (see `.claude/skills/delegate/brief-template.md`).
2. **Fan out (cheaper models, in parallel).** Each worker gets *only* its brief plus pointers (paths, line ranges, IDs).
3. **Workers return structured output.** JSON or fixed sections, with a hard size cap (e.g. ≤ 300 words or ≤ 20 findings).
4. **Synthesize (strong model).** Merge, dedupe and resolve conflicts.
5. **Verify (fresh context).** A separate agent checks the merged result against the source.

```
            ┌── worker A (haiku/sonnet) ──┐
plan ──────►├── worker B                  ├──► synthesize ──► verify ──► output
(opus)      └── worker C                  ┘     (opus)        (fresh agent)
```

## Rules of thumb
- Parallelize only subtasks that don't share mutable state (for example, two workers must not edit the same file).
- Cap the fan-out (3–8 workers). Beyond that, synthesis quality drops and cost explodes.
- The orchestrator never reads raw files that a worker has already summarized, unless it is verifying.
- Prefer "return paths + line numbers + one-line claim" over "return the code".

## Pitfalls
- **Vague briefs** lead to duplicated or overlapping work. Give every worker an explicit boundary ("only `src/api/`").
- **Unbounded output** means a worker returns 10k tokens and the isolation benefit is gone.
- **Telephone game:** the summary loses an exact error string. Ask workers to quote verbatim when exactness matters.
