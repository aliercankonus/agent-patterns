## Objective
<one sentence>

## Why
<the larger goal this serves>

## Inputs
- Paths / line ranges: <...>
- Commands you may run: <...>
- Known facts (don't re-verify): <...>

## Boundaries
- In scope: <...>
- Out of scope / do not modify: <...>
- Budget: <max files to read / max output words>

## Output format
<JSON schema or fixed markdown sections; hard cap, e.g. ≤ 15 items, ≤ 300 words>
- Lead with locations: `path:line — symbol — short note`. No prose preamble or recap.
- Quote errors and code verbatim (shortest decisive line).
- If you cannot finish, reply with exactly one status token and one line of reason:
  `too-big.` (needs splitting) · `ambiguous.` (spec unclear) · `needs-confirm.` (risky/irreversible step) · `unsure.` (low confidence)

## Done when
<explicit criteria>
