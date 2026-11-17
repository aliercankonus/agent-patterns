# Skills review: collectivebrain.de catalog

Reviewed 2026-11-17 against `https://collectivebrain.de/skills.json` (**100 skills**: content 25, dev 19, design 18, ai 12, office 9, product 7, branding 6, visual 4).

**Yardstick:** does the skill help an engineering starter repo with (a) end-to-end workflows, (b) token-efficient orchestration, or (c) code quality, without breaking our rules (original source, pinned commit, full read, no hidden context cost)?

**Method:** sorted all 100 entries by category and source. For the engineering-relevant ones, shallow-cloned the original repositories and read the SKILL.md files and licenses. Nothing was executed. Catalog descriptions are in German. Many community entries have no SKILL.md in the catalog, so judgments on those rest on their upstream repos.

> **Never install from the catalog's commands.** For Anthropic and Collective Brain skills they `curl` the SKILL.md from collectivebrain.de, which is a mirror, not the original. Always vendor from the upstream repository at a pinned commit (see `skills.manifest.md`).

## Verdict summary

| Verdict | Count | Meaning |
|---|---|---|
| Adopt | 3 (+1) | Vendor into `extras/` and recommend for most projects. The +1 is `verification-before-completion`, taken from inside Superpowers. |
| Borrow ideas | 4 | Don't install; fold the good ideas into our core skills (Superpowers counted here) |
| Per project | 22 | Install with `--with` only when the project's stack needs it |
| Skip | 71 | Off-topic for an engineering starter, unverifiable, or conflicts with our rules |

## Adopt (vendor into `extras/`)

| Skill | Upstream @ commit read | License | Why | Notes |
|---|---|---|---|---|
| `skill-creator` | `anthropics/skills` @ `e4bb5d9` (`skills/skill-creator`) | Apache-2.0 | Builds and evaluates new skills, including description tuning for triggering. This repo's job is growing skills. | 485-line SKILL.md + 17 files. Long, but only loaded on demand. |
| `verification-before-completion` | `obra/superpowers` @ `22f0b46` | MIT | "No completion claims without fresh verification evidence." Cheap, and it backs up our finding-verifier and test-reviewer. | 120 lines. Take this skill only, not the whole Superpowers plugin (see below). |
| `ponytail` (+ optionally `ponytail-review`) | `dietrichgebert/ponytail` @ `96608e0` | MIT | Smallest complete change. Smaller diffs mean fewer tokens, faster reviews and less risk. It keeps validation, security and tests ("never cut"). | 52 lines. The repo also ships hooks and other harness files; vendor only `skills/ponytail*`. |
| `security-audit` | `cloudflare/security-audit-skill` @ `c1c8a8c` | MIT | Evidence-first security review with strict sandbox rules (no network, no live targets). It becomes the security lane of `/e2e-code-review`. | 192 lines. Defaults to guidance mode and only runs the full audit when explicitly asked. |

## Borrow ideas (don't install)

| Skill | What to take | Why not install |
|---|---|---|
| `superpowers` (`obra/superpowers`) | From `subagent-driven-development`: a fresh implementer per task, a spec-compliance review after each task, and a **ruling ledger** (`Ruling: what — why — cost if wrong`) so the orchestrator doesn't stall. Add these to `/delegate`. | A full framework with 15 skills and a SessionStart hook that injects context every session. It overlaps our core and adds a fixed token cost. |
| `caveman` / `cavecrew` (`juliusbrussee/caveman`, Apache-2.0) | Cavecrew's **output contracts** (`path:line — symbol — note`, terminal status tokens such as `too-big.` and `ambiguous.`), plus the rule to spot-check a subagent's "No match." before trusting it. Tighten our agent outputs with them. | The voice skill persists for the whole session and changes how Claude talks to people. `caveman-compress` sends file contents to a model provider through a script. |
| `mattpocock-handoff` (`mattpocock/skills`) | Add a "suggested skills for the next agent" section to our handoff template. Reference existing artifacts instead of duplicating them. Redact secrets. | It saves to `/tmp`, but our handoff must be durable (project root). |
| `task-observer` (`rebelytics/one-skill-to-rule-them-all`, CC-BY-4.0) | The idea of logging corrections as evidence for skill updates, with every change staged for approval. Revisit once the repo has many skills. | A 753-line skill that must load before the **first tool call of every session**: a large fixed token cost, which works against our core goal. |

## Per project (install only when the stack matches)

| Area | Skills (upstream) |
|---|---|
| LLM and agent apps | `claude-api`, `mcp-builder` (anthropics/skills) |
| Browser testing | `playwright-cli` (microsoft/playwright-cli), `agent-browser` (vercel-labs/agent-browser) |
| Frontend / UI | `anthropic-frontend-design`, `shadcn` (shadcn/ui), `vercel-react-best-practices`, `vercel-web-design-guidelines` (vercel-labs/agent-skills), `accessibility` (addyosmani/web-quality-skills), `design-accessibility-review` (Anthropic plugin) |
| Backend / data | `supabase-postgres-best-practices` (supabase/agent-skills), `fastify-best-practices` (mcollina/skills) |
| Monorepo / TS | `turborepo` (vercel/turborepo), `typescript-advanced-types` (wshobson/agents) |
| Engineering practice | `mattpocock-tdd`, `improve-codebase-architecture` (mattpocock/skills; read before vendoring, since `setup-matt-pocock-skills` wants to configure the repo for its own conventions) |
| CI cost | `github-actions-sparen` (Collective Brain's own; German; cancel-in-progress, paths-ignore, timeouts) |
| Docs and files | `doc-coauthoring`, `anthropic-docx`, `anthropic-pdf`, `anthropic-xlsx` (anthropics/skills) |
| Cloud-specific | `azure-ai` (microsoft/azure-skills) |

## Skip

- **Content & marketing / SEO (25):** ai-marketing-team, backlink-kampagne, brand-serp-optimierung, indexierungs-audit, internal-comms, interne-verlinkung, keyword-recherche-cluster, keyword-strategy-planner, local-seo-audit, marketing-campaign-plan, marketing-competitive-brief, marketing-content-creation, marketing-email-sequence, marketing-performance-report, marketing-seo-audit, onpage-optimierung, sales-enablement-pack, schema-markup-generator, search-console-analyse, seo-artikel-schreiben, seo-geo-aeo-audit, seo-strategie-roadmap, seo-wettbewerbsanalyse, ux-copy-refiner, google-ads-analyzer. These are useful for a marketing team, not an engineering starter.
- **Branding (6):** anthropic-brand-guidelines, brand-voice-discover-brand, brand-voice-enforcement, brand-voice-guideline-generation, brandkit, marketing-brand-review.
- **Visual (4):** algorithmic-art, anthropic-canvas-design, anthropic-divi-edit, imagegen-frontend-mobile.
- **Design for designers (14):** animation-vocabulary, apple-design, design-design-critique, design-design-handoff, design-design-system, design-research-synthesis, design-user-research, design-ux-copy, emil-design-eng, figma-to-code, impeccable, review-animations, theme-factory, ux-flow-wireframer. Worth a look for UI-heavy teams; out of scope for the default starter.
- **Product / business (5):** b2b-value-proposition-mapper, founder-pitch-deck-coach, persona-workshop-facilitator, ux-research-interview-kit, website-builder.
- **Office connectors and apps (6):** anthropic-pptx, gws-gmail, lark-im, notion-ops-connector, obsidian-bases, obsidian-markdown.
- **Platform-specific / tooling (11):** anthropic-schedule, anthropic-setup-cowork, cowork-cowork-plugin-customizer, cowork-create-cowork-plugin (Cowork-only); google-agents-cli-adk-code, google-agents-cli-deploy, google-agents-cli-publish (only if you use Google ADK); herdrdev-herdr (a specific terminal multiplexer); vopixsounds (sound notifications, personal preference); setup-matt-pocock-skills (configures the repo for another skill set); **find-skills**, which searches for and installs skills automatically and so bypasses our vetted-manifest rule.
- **Covered by "Adopt" / "Borrow"** (not counted again): superpowers, caveman, mattpocock-handoff, task-observer, ponytail, security-audit, anthropic-skill-creator.

## Red flags seen in the catalog

- **Mirror installs:** the catalog's install commands fetch SKILL.md from collectivebrain.de, not from the original repository.
- **No source link** on 16 community entries (e.g. brandkit, google-ads-analyzer, website-builder). There's no way to verify their origin, so they are excluded whatever their topic.
- **Always-on skills** (task-observer, caveman, superpowers' SessionStart hook) carry a fixed per-session token cost. Prefer on-demand skills.
- **Scripts that send data out** (caveman-compress sends file text to a model provider). Read every script before vendoring.
