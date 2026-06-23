#!/bin/bash
# Ensure the Diagram Cloud CLI is installed at the pinned version.
# Runs as a SessionStart hook — always exits 0, never blocks the session.
#
# Installs @horison-ai/diagram-cloud-cli from GitHub Packages (private).
# Auth: sources NPM_TOKEN from the GitHub CLI (needs `gh auth login -s read:packages`).
# Robust by design: verifies the RESOLVED binary is the published package at the
# pinned version (a dev clone reports the same version string, so command -v alone
# is not enough), self-heals the ~/.npmrc scope mapping, and never errors out.

# Consume stdin (SessionStart hook contract)
cat > /dev/null

PKG="@horison-ai/diagram-cloud-cli"
DESIRED="1.1.1"          # bump in lockstep with cli/package.json releases
MIN_NODE=20
REGISTRY="https://npm.pkg.github.com"
SCOPE_LINE="@horison-ai:registry=${REGISTRY}"
TOKEN_LINE="//npm.pkg.github.com/:_authToken=\${NPM_TOKEN}"

empty() { echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'; }
ctx()   { echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"$1\"}}"; }

# True if the active `diagram` is the published package at $DESIRED (not a dev clone).
is_correct() {
  command -v diagram >/dev/null 2>&1 || return 1
  local real ver
  real=$(readlink -f "$(command -v diagram)" 2>/dev/null)
  case "$real" in
    */node_modules/@horison-ai/diagram-cloud-cli/*) ;;   # a real install
    *) return 1 ;;                                        # dev clone / link / stray
  esac
  ver=$(diagram --version 2>/dev/null | tr -d '[:space:]')
  [ "$ver" = "$DESIRED" ]
}

# ── Prereqs (silent skip) ────────────────────────────────────────────────────
command -v node >/dev/null 2>&1 || { echo "diagram-cli: node not found, skip" >&2; empty; exit 0; }
NODE_MAJOR=$(node -e "process.stdout.write(String(process.versions.node.split('.')[0]))" 2>/dev/null)
[ "${NODE_MAJOR:-0}" -ge "$MIN_NODE" ] 2>/dev/null || { echo "diagram-cli: node ${MIN_NODE}+ required, skip" >&2; empty; exit 0; }
command -v npm >/dev/null 2>&1 || { echo "diagram-cli: npm not found, skip" >&2; empty; exit 0; }

# ── Fast path: already correct (no network) ─────────────────────────────────
if is_correct; then empty; exit 0; fi

# ── Auth: source a GitHub Packages token from gh (self-sufficient) ──────────
if [ -z "${NPM_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
  NPM_TOKEN="$(gh auth token 2>/dev/null)"; export NPM_TOKEN
fi
if [ -z "${NPM_TOKEN:-}" ]; then
  echo "diagram-cli: no NPM_TOKEN — run 'gh auth login -s read:packages', skip" >&2
  empty; exit 0
fi

# ── Self-heal ~/.npmrc scope + token mapping (idempotent) ───────────────────
NPMRC="$HOME/.npmrc"; touch "$NPMRC"
grep -qxF "$SCOPE_LINE" "$NPMRC" 2>/dev/null || printf '%s\n' "$SCOPE_LINE" >> "$NPMRC"
grep -qxF "$TOKEN_LINE" "$NPMRC" 2>/dev/null || printf '%s\n' "$TOKEN_LINE" >> "$NPMRC"

# ── Install the pinned version ──────────────────────────────────────────────
echo "diagram-cli: installing ${PKG}@${DESIRED}" >&2
npm install -g "${PKG}@${DESIRED}" >/dev/null 2>&1

# ── Verify the RESOLVED binary (not just that *a* diagram exists) ────────────
if is_correct; then
  ctx "Diagram Cloud CLI ${DESIRED} ready. Use \`diagram push\` to share diagrams, \`diagram ls\` to browse. (Reads need \`gcloud auth application-default login\`.)"
else
  echo "diagram-cli: install did not yield ${PKG}@${DESIRED} on PATH" >&2
  empty
fi
exit 0
