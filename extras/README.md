# Opt-in extras

Skills (`extras/skills/<name>/`) and agents (`extras/agents/<name>.md`) that a project can choose to install:

```bash
./bootstrap.sh ../my-project --with skill-a,agent-b
```

Every entry must be listed in `../skills.manifest.md` with its original source and pinned commit.
