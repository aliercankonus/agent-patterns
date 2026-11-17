---
name: delegate
description: Apply the orchestrator–worker pattern to a task. Plan, fan out to right-sized subagents with tight briefs, synthesize and verify, while keeping the main context small.
---
# Delegate

Task: `$ARGUMENTS`

1. **Decide whether to delegate at all.** If the task is small or tightly coupled, do it directly and stop here.
2. **Plan.** Break the task into 2–8 independent subtasks. For each, pick a model tier:
   search, extraction or classification → haiku; focused code work → sonnet; judgment → keep it yourself.
3. **Brief.** Write each brief with `.claude/skills/delegate/brief-template.md`: exact inputs, boundaries, an output schema with a size cap, and done criteria.
4. **Fan out.** Launch independent subtasks in a single message. Subtasks must not edit the same files.
5. **Synthesize.** Merge the structured results. Re-delegate any subtask whose output fails its schema or says "unsure", one tier up.
6. **Verify.** For non-trivial results, a fresh-context agent checks the merged output against the sources.
7. **Record.** Update `PROGRESS.md` with decisions and results so they survive compaction.
