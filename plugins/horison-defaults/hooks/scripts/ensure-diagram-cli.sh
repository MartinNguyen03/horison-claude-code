#!/bin/bash
# Ensure the Diagram Cloud CLI is installed.
# Runs as a SessionStart hook — always exits 0, never blocks the session.
#
# If `diagram` is already on PATH: exits in <100ms.
# If not: clones diagram-cloud to ~/.horison/diagram-cloud, builds, and links.

# Consume stdin (SessionStart hook contract)
cat > /dev/null

REPO_URL="git@github.com:horison-ai/diagram-cloud.git"
INSTALL_DIR="$HOME/.horison/diagram-cloud"
MIN_NODE_VERSION=20

OUTPUT_EMPTY='{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'

# ── Already installed — fast exit ────────────────────────────────────────────

if command -v diagram &> /dev/null; then
  echo "$OUTPUT_EMPTY"
  exit 0
fi

# ── Prerequisites check (silent fail if missing) ────────────────────────────

if ! command -v node &> /dev/null; then
  echo "diagram-cli: Node.js not found, skipping install" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

NODE_MAJOR=$(node -e "process.stdout.write(String(process.versions.node.split('.')[0]))")
if [[ "$NODE_MAJOR" -lt "$MIN_NODE_VERSION" ]]; then
  echo "diagram-cli: Node.js $MIN_NODE_VERSION+ required, skipping install" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

if ! command -v git &> /dev/null; then
  echo "diagram-cli: git not found, skipping install" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

# Pick package manager: prefer pnpm, fall back to npm
if command -v pnpm &> /dev/null; then
  PM="pnpm"
elif command -v npm &> /dev/null; then
  PM="npm"
else
  echo "diagram-cli: neither npm nor pnpm found, skipping install" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

# ── Clone or update ──────────────────────────────────────────────────────────

if [[ -d "$INSTALL_DIR/.git" ]]; then
  cd "$INSTALL_DIR" && git pull --ff-only 2>/dev/null || true
else
  mkdir -p "$(dirname "$INSTALL_DIR")"
  if ! git clone --depth 1 "$REPO_URL" "$INSTALL_DIR" 2>/dev/null; then
    echo "diagram-cli: failed to clone repo, skipping install" >&2
    echo "$OUTPUT_EMPTY"
    exit 0
  fi
fi

# ── Build & link (cli/ only — no workspace needed) ──────────────────────────

cd "$INSTALL_DIR/cli"
$PM install 2>/dev/null
npx tsup 2>/dev/null
$PM link --global 2>/dev/null || npm link 2>/dev/null

# ── Result ───────────────────────────────────────────────────────────────────

if command -v diagram &> /dev/null; then
  echo "diagram-cli: installed successfully" >&2
  echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Diagram Cloud CLI was auto-installed. Use `diagram push` to share diagrams."}}'
else
  echo "diagram-cli: install completed but command not in PATH" >&2
  echo "$OUTPUT_EMPTY"
fi

exit 0
