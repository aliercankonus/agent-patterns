#!/usr/bin/env bash
# Build the e2e-code-review test fixture as a git repo OUTSIDE the starter, so reviewers can't see answer-key.md.
#   ./setup.sh [target-dir]      (default: a new temp dir)
# Result: branch main (clean base) and branch feature/search-and-sharing (planted defects), with the starter installed.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTER="$(cd "$HERE/../../.." && pwd)"
T="${1:-$(mktemp -d)/notes-sample}"
[[ ! -e "$T" ]] || { echo "error: $T already exists" >&2; exit 1; }
mkdir -p "$T" && cp -R "$HERE/base/." "$T/"
G=(git -C "$T" -c user.name=fixture -c user.email=fixture@example.invalid)
"${G[@]}" init -q -b main && "${G[@]}" add -A && "${G[@]}" commit -qm "notes service: base"
"${G[@]}" checkout -q -b feature/search-and-sharing && "${G[@]}" am -q "$HERE/feature.patch"
"$STARTER/bootstrap.sh" "$T" --with recommended >/dev/null
echo "$T"
