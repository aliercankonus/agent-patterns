# Research findings

Research snapshot from 2026-11-17. Many numbers come from secondary write-ups, so treat them as directional and verify them against primary sources before you cite them externally.

## 1. Multi-agent orchestration

- **Orchestrator–worker is the dominant pattern.** A lead agent breaks the task into facets, runs subagents in parallel, and synthesizes their results. Anthropic's research system (an Opus lead with Sonnet workers) reportedly beat a single Opus agent by about 90% on an internal research eval. *(Secondary source: DEV Community summary; primary post not verified.)*
- **Cost.** Multi-agent runs use roughly 15× the tokens of a plain chat, versus about 4× for a single agent with tools. Other estimates say 3–10× a single agent. The overhead comes from duplicated context, coordination messages and handoff summaries.
- **Good fit:** breadth-first, parallelizable work (research, review across many files, independent checks).
- **Poor fit:** work where every agent needs the same context, or where subtasks are tightly coupled (most single-feature coding).
- **A good delegation brief has** an objective, an output format, tool and source guidance, and clear task boundaries.

## 2. Token efficiency

- Each subagent can burn tens of thousands of tokens but should return a condensed result. That isolation is the main benefit.
- Route mechanical subtasks (extraction, classification, grep-style search, lint triage) to a small model, and keep the orchestrator on the strongest one. Routing by difficulty is one of the biggest cost levers.
- Pass each worker only the context it needs: file paths and line ranges, not file dumps.
- Return compact structured results instead of transcripts.
- Use prompt caching for stable prefixes such as system prompts, tool definitions and agent instructions.

## 3. Context limits: compaction, memory, eviction

- **Three distinct tools:** (a) compaction, which summarizes history; (b) memory, which externalizes state to files or a store; (c) tool-result clearing, which drops stale tool outputs. Subagents are a companion strategy *(Anthropic cookbook)*.
- **Default compaction is lossy for coding.** It can drop exact file paths, error strings and task constraints. Structured custom summaries scored higher (3.70) than provider defaults (3.44 and 3.35) in one vendor evaluation.
- **Over-compression backfires.** Factory found that cutting tokens per request too hard *increases* tokens per task, because the agent re-reads files and re-explores.
- **Evaluate with probes** (questions the agent must still be able to answer after compaction), not with ROUGE-style similarity.
- **Newer research:** structured context eviction ("Beyond Compaction", 2026) and parallel block compaction (2026) avoid blocking, error-prone mid-task summaries. These are preprints.

## 4. Claude Code specifics

- Subagents are selected by their `description` field, so write descriptions as trigger conditions ("Use after code changes to…").
- Restrict each subagent's `tools` list and choose its `model` explicitly.
- Skills (`.claude/skills/<name>/SKILL.md`): one skill = one capability. Keep the body short and link to reference files, which load only when needed (progressive disclosure).
- A bloated CLAUDE.md degrades every agent that loads it, so keep it lean.
- Code review in practice: parallel specialist reviewers, then a challenge/verification pass that filters false positives.

## Sources

- [Building multi-agent systems: when and how to use them (Claude blog)](https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them)
- [How and when to use subagents in Claude Code (Claude blog)](https://claude.com/blog/how-and-when-to-use-subagents-in-claude-code)
- [Context engineering tools (Claude cookbook)](https://platform.claude.com/cookbook/tool-use-context-engineering-context-engineering-tools)
- [Anthropic context engineering notes](https://agentic-ai.readthedocs.io/en/latest/ContextEngineering/anthropic/)
- [Anthropic's multi-agent blueprint: what production constraints add (DEV)](https://dev.to/sebastian_chedal/anthropic8217s-multi-agent-blueprint-what-production-constraints-add-2fm7)
- [Cutting token cost in Claude multi-agent systems](https://callsphere.ai/blog/cutting-token-cost-in-claude-multi-agent-systems)
- [When and how to use multi-agent LLM systems](https://www.besthub.dev/articles/when-and-how-to-use-multi-agent-llm-systems-practical-insights-from-anthropic-924cb01fd2e4)
- [Evaluating context compression (Factory)](https://docs.factory.ai/guides/power-user/evaluating-context-compression.md)
- [Context compression strategies (ZenML LLMOps DB)](https://www.zenml.io/llmops-database/evaluating-context-compression-strategies-for-long-running-ai-agent-sessions)
- [Memory compaction for long-running agents (fast.io)](https://www.fast.io/resources/ai-agent-memory-compaction-strategies/)
- [Beyond Compaction: structured context eviction](https://huggingface.co/papers/2606.11213.md)
- [Parallel context compaction](https://www.alphaxiv.org/abs/2605.23296)
- [Sub-agent patterns skill (community)](https://tessl.io/skills/github/jezweb/claude-skills/sub-agent-patterns)
- [Building a skill-based agentic reviewer (DZone)](https://dzone.com/articles/building-a-skill-based-agentic-reviewer-with-claude)
- [obra/superpowers: subagent-driven-development, verification-before-completion](https://github.com/obra/superpowers)
- [juliusbrussee/caveman: cavecrew output contracts](https://github.com/juliusbrussee/caveman)
- [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail)
- [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill)
- [mattpocock/skills: handoff](https://github.com/mattpocock/skills)
- [anthropics/skills: skill-creator](https://github.com/anthropics/skills)
