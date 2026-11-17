---
name: context-handoff
description: Write a structured handoff file before compaction, a session switch, or when the context is ~75% full, so work can resume without loss.
---
# Context handoff

1. Fill in `.claude/skills/context-handoff/handoff-template.md` and save it as `handoff.md` in the project root (overwriting any old one).
2. Copy the GOAL and CONSTRAINTS **verbatim** from the user. Never paraphrase them.
3. Record exact commands and exact error text, plus file paths with line ranges. Point to existing artifacts (specs, plans, PRs, commits) by path or URL instead of copying them.
   **Redact** API keys, passwords, tokens and personal data: the file lives in the project and may get committed.
4. Name the skills the next agent should use, in "Suggested skills".
5. Write 2–4 **probes**: questions the next agent must be able to answer from the handoff alone.
6. Self-check: re-read only `handoff.md` and answer the probes. If any answer is missing, add it.
7. Tell the user the handoff is ready, and that a fresh session can resume with: "Read handoff.md and continue."
