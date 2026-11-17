---
name: context-handoff
description: Write a structured handoff file before compaction, a session switch, or when the context is ~75% full, so work can resume without loss.
---
# Context handoff

1. Fill in `templates/handoff.md` and save it as `handoff.md` in the project root (overwriting any old one).
2. Copy the GOAL and CONSTRAINTS **verbatim** from the user. Never paraphrase them.
3. Record exact commands and exact error text, plus file paths with line ranges.
4. Write 2–4 **probes**: questions the next agent must be able to answer from the handoff alone.
5. Self-check: re-read only `handoff.md` and answer the probes. If any answer is missing, add it.
6. Tell the user the handoff is ready, and that a fresh session can resume with: "Read handoff.md and continue."
