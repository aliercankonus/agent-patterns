# Model routing by difficulty

Route each subtask to the cheapest model that does it reliably.

| Tier | Typical model | Use for |
|---|---|---|
| Strong | Opus | Planning, architecture judgment, synthesis, final verdicts, ambiguous trade-offs |
| Mid | Sonnet | Most code reading/writing, focused reviews, test writing, debugging a known area |
| Small | Haiku | Search/grep triage, classification, extraction, formatting, log summarization, lint-result triage |

## Decision checklist
1. Does the subtask need judgment across many concerns? → Strong
2. Is the answer checkable mechanically (tests, lint, schema)? → Small or Mid, plus an automated check
3. Is it read-heavy with a short answer? → Small or Mid worker, so the strong model never sees the raw text
4. Would a wrong answer be expensive and hard to detect? → Strong, or Mid with a Strong verifier

## Escalation pattern
Run Small first. If its confidence is low, the output fails validation, or it reports "unsure", re-run on Mid or Strong. This cascade usually beats "always Strong" on cost while keeping quality.

## In Claude Code
Set `model:` in each `.claude/agents/*.md` frontmatter (`haiku`, `sonnet`, `opus`, or `inherit`).
