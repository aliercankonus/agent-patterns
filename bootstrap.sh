#!/usr/bin/env bash
# Install the agent-patterns starter into a project.
#
#   ./bootstrap.sh <target-dir> [--with a,b] [--force]   copy into a new or existing project
#   ./bootstrap.sh --init        [--with a,b]             turn a repo created from the GitHub template into a project
#   ./bootstrap.sh --list                                 list available extras
#   --with recommended  installs skill-creator, verification-before-completion, ponytail, security-audit
#
# Core skills and agents are always installed. Extras (from extras/) only with --with.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="" WITH="" FORCE=0 INIT=0

usage() { sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }
die() { echo "error: $*" >&2; exit 1; }

list_extras() {
  echo "skills:"; find "$SRC/extras/skills" -mindepth 1 -maxdepth 1 -type d -printf '  %f\n' 2>/dev/null | sort
  echo "agents:"; find "$SRC/extras/agents" -mindepth 1 -maxdepth 1 -name '*.md' -printf '  %f\n' 2>/dev/null | sed 's/\.md$//' | sort
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with) [[ $# -ge 2 ]] || die "--with needs a comma-separated list"; WITH="$2"; shift 2 ;;
    --with=*) WITH="${1#*=}"; shift ;;
    --force) FORCE=1; shift ;;
    --init) INIT=1; shift ;;
    --list) list_extras; exit 0 ;;
    -h|--help) usage 0 ;;
    -*) die "unknown option $1" ;;
    *) [[ -z "$TARGET" ]] || die "only one target allowed"; TARGET="$1"; shift ;;
  esac
done

if [[ $INIT -eq 1 ]]; then
  [[ -z "$TARGET" ]] || die "--init works in place; do not pass a target"
  TARGET="$SRC"
else
  [[ -n "$TARGET" ]] || usage 1
  mkdir -p "$TARGET"
  TARGET="$(cd "$TARGET" && pwd)"
  [[ "$TARGET" != "$SRC" ]] || die "target is the starter itself; use --init for a repo created from the template"
fi

VERSION="$(git -C "$SRC" rev-parse --short HEAD 2>/dev/null || echo unknown)"

# Copy src -> dst, refusing to overwrite unless --force (or we're in --init, where files are already in place).
copy() {
  local src="$1" dst="$2"
  [[ "$src" -ef "$dst" ]] && return 0
  if [[ -e "$dst" && $FORCE -eq 0 ]]; then echo "  skip (exists): ${dst#"$TARGET"/}"; return 0; fi
  mkdir -p "$(dirname "$dst")"
  cp -R "$src" "$dst"
  echo "  add: ${dst#"$TARGET"/}"
}

# Validate extras before changing anything. "recommended" expands to the vetted default set.
RECOMMENDED="skill-creator,verification-before-completion,ponytail,security-audit"
WITH="${WITH//recommended/$RECOMMENDED}"
IFS=',' read -r -a EXTRAS <<< "$WITH"
for name in "${EXTRAS[@]}"; do
  [[ -z "$name" ]] && continue
  [[ -d "$SRC/extras/skills/$name" || -f "$SRC/extras/agents/$name.md" ]] || die "unknown extra '$name' (see --list)"
done

echo "Installing agent-patterns @ $VERSION into $TARGET"

# Core: skills + agents.
for d in "$SRC"/.claude/skills/*/; do copy "${d%/}" "$TARGET/.claude/skills/$(basename "$d")"; done
for f in "$SRC"/.claude/agents/*.md; do copy "$f" "$TARGET/.claude/agents/$(basename "$f")"; done

# Extras.
for name in "${EXTRAS[@]}"; do
  [[ -z "$name" ]] && continue
  [[ -d "$SRC/extras/skills/$name" ]] && copy "$SRC/extras/skills/$name" "$TARGET/.claude/skills/$name"
  [[ -f "$SRC/extras/agents/$name.md" ]] && copy "$SRC/extras/agents/$name.md" "$TARGET/.claude/agents/$name.md"
done

# Reference docs, manifest.
copy "$SRC/patterns" "$TARGET/docs/agent-patterns/patterns"
copy "$SRC/docs/research.md" "$TARGET/docs/agent-patterns/research.md"
copy "$SRC/skills.manifest.md" "$TARGET/docs/agent-patterns/skills.manifest.md"

# Project CLAUDE.md: never overwrite an existing one outside --init (the starter's own CLAUDE.md is replaced in --init).
if [[ $INIT -eq 1 ]]; then
  cp "$SRC/templates/CLAUDE.project.md" "$TARGET/CLAUDE.md"; echo "  add: CLAUDE.md (from template)"
elif [[ -e "$TARGET/CLAUDE.md" && $FORCE -eq 0 ]]; then
  cp "$SRC/templates/CLAUDE.project.md" "$TARGET/CLAUDE.agent-patterns.md"
  echo "  CLAUDE.md exists: wrote CLAUDE.agent-patterns.md; merge its 'Agent workflow' section by hand"
else
  cp "$SRC/templates/CLAUDE.project.md" "$TARGET/CLAUDE.md"; echo "  add: CLAUDE.md (from template)"
fi

printf 'version=%s\nextras=%s\ninstalled=%s\n' "$VERSION" "$WITH" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$TARGET/.claude/agent-patterns.version"

# --init: remove starter-only files so the repo becomes a clean project.
if [[ $INIT -eq 1 ]]; then
  rm -rf "$SRC/patterns" "$SRC/docs/research.md" "$SRC/extras" "$SRC/templates" "$SRC/skills.manifest.md"
  printf '# %s\n\nCreated from the agent-patterns starter (%s). See `docs/agent-patterns/`.\n' \
    "$(basename "$SRC")" "$VERSION" > "$SRC/README.md"
  rm -f "$SRC/bootstrap.sh"
  echo "Starter files removed. Review the changes with 'git status' and commit."
fi

echo "Done. Next: fill in the {{placeholders}} in CLAUDE.md."
