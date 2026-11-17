---
name: delegate
description: Apply the orchestrator–worker pattern to a task. Plan, fan out to right-sized subagents with tight briefs, synthesize and verify, while keeping the main context small.
---
# Delegate

Task: `$ARGUMENTS`

1. **Decide whether to delegate at all.** If the task is small or tightly coupled, do it directly and stop here.
2. **Plan.** Break the task into 2–8 independent subtasks, each with a one-line spec of what "done" means. For each, pick a model tier:
   search, extraction or classification → haiku; focused code work → sonnet; judgment → keep it yourself.
3. **Brief.** Write each brief with `.claude/skills/delegate/brief-template.md`: exact inputs, boundaries, an output schema with a size cap, done criteria, and the status tokens the worker may answer with.
4. **Fan out.** Launch independent subtasks in a single message. Each worker gets a fresh context: give it only its brief, never this conversation. Subtasks must not edit the same files.
5. **Check each result against its spec** as it returns, before starting dependent work:
   - A status token (`too-big.`, `ambiguous.`, `needs-confirm.`, `unsure.`) means: split the task, clarify it, or re-delegate one tier up.
   - An empty or absence claim ("No match.", `[]`, "nothing to change") gets one targeted check by you before you rely on it.
   - A claimed change or test run is confirmed from `git diff` or the command output, not from the report.
6. **Decide, don't stall.** Settle conflicts, ambiguities and plan defects yourself, and log each decision in `PROGRESS.md` as `Ruling: <decision> — <why> — <cost if wrong>`. Stop and ask the user only for: an irreversible or destructive step, a security-sensitive action, an outward-facing action (push to a shared branch, merge, publish, message), or a plan so broken that every path is a guess.
7. **Synthesize and verify.** Merge the structured results. For non-trivial results, a fresh-context agent checks the merged output against the sources.
8. **Record.** Update `PROGRESS.md` with results and rulings so they survive compaction.
