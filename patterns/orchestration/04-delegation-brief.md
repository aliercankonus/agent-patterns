# Writing a delegation brief

The brief is the worker's entire world. It starts cold, so anything you leave out it must rediscover, and that costs tokens.

Required fields (see `templates/delegation-brief.md`):
1. **Objective:** what question to answer or what change to make, in one sentence.
2. **Why:** the larger goal, so the worker can make sensible judgment calls.
3. **Inputs:** exact paths, line ranges, IDs, commands. Never "look around the repo".
4. **Boundaries:** what is in and out of scope, which files must not be touched, the time or token budget.
5. **Output format:** schema plus a size cap.
6. **Done criteria:** how the worker knows it has finished.
7. **Known facts:** anything already established, so the worker doesn't re-derive it.

Anti-patterns: "Review the code", "Find bugs", passing the whole conversation, asking for an open-ended essay.
