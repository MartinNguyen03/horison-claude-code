#!/bin/bash
# Ensure the Diagram Cloud CLI is installed and up-to-date.
# Runs as a SessionStart hook — always exits 0, never blocks the session.
#
# Fresh install:  clones diagram-cloud, builds CLI, links globally.
# Existing install: compares installed version against latest cli-v* git tag.
#                   Only pulls + rebuilds when a newer version is tagged.

# Consume stdin (SessionStart hook contract)
cat > /dev/null

REPO_URL="git@github.com:horison-ai/diagram-cloud.git"
INSTALL_DIR="$HOME/.horison/diagram-cloud"
MIN_NODE_VERSION=20

OUTPUT_EMPTY='{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":""}}'

# ── Prerequisites check (silent fail if missing) ────────────────────────────

if ! command -v node &> /dev/null; then
  echo "diagram-cli: Node.js not found, skipping" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

NODE_MAJOR=$(node -e "process.stdout.write(String(process.versions.node.split('.')[0]))")
if [[ "$NODE_MAJOR" -lt "$MIN_NODE_VERSION" ]]; then
  echo "diagram-cli: Node.js $MIN_NODE_VERSION+ required, skipping" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

if ! command -v git &> /dev/null; then
  echo "diagram-cli: git not found, skipping" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

# Pick package manager: prefer pnpm, fall back to npm
if command -v pnpm &> /dev/null; then
  PM="pnpm"
elif command -v npm &> /dev/null; then
  PM="npm"
else
  echo "diagram-cli: neither npm nor pnpm found, skipping" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

# ── Helper: build and link the CLI ──────────────────────────────────────────

build_and_link() {
  cd "$INSTALL_DIR/cli" || return 1
  $PM install --frozen-lockfile 2>/dev/null || $PM install 2>/dev/null
  npx tsup 2>/dev/null
  $PM link --global 2>/dev/null || npm link 2>/dev/null
}

# ── Already installed — check for updates ────────────────────────────────────

if command -v diagram &> /dev/null && [[ -d "$INSTALL_DIR/.git" ]]; then
  LOCAL_VERSION=$(diagram --version 2>/dev/null)

  # Fetch latest cli-v* tag from remote (lightweight, no checkout)
  LATEST_TAG=$(git -C "$INSTALL_DIR" ls-remote --tags --sort=-v:refname origin 'refs/tags/cli-v*' 2>/dev/null \
    | head -1 \
    | sed 's|.*refs/tags/cli-v||')

  # If we couldn't reach remote or no tags exist, skip quietly
  if [[ -z "$LATEST_TAG" ]]; then
    echo "$OUTPUT_EMPTY"
    exit 0
  fi

  # Up to date — fast exit
  if [[ "$LOCAL_VERSION" == "$LATEST_TAG" ]]; then
    echo "$OUTPUT_EMPTY"
    exit 0
  fi

  # New version available — pull and rebuild
  echo "diagram-cli: updating $LOCAL_VERSION → $LATEST_TAG" >&2
  cd "$INSTALL_DIR" && git pull --ff-only 2>/dev/null || true
  build_and_link

  if command -v diagram &> /dev/null; then
    echo "diagram-cli: updated to $LATEST_TAG" >&2
    echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"Diagram CLI updated to $LATEST_TAG.\"}}"
  else
    echo "$OUTPUT_EMPTY"
  fi
  exit 0
fi

# ── Fresh install ────────────────────────────────────────────────────────────

mkdir -p "$(dirname "$INSTALL_DIR")"
if ! git clone --depth 1 "$REPO_URL" "$INSTALL_DIR" 2>/dev/null; then
  echo "diagram-cli: failed to clone repo, skipping install" >&2
  echo "$OUTPUT_EMPTY"
  exit 0
fi

build_and_link

if command -v diagram &> /dev/null; then
  echo "diagram-cli: installed successfully" >&2
  echo '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Diagram Cloud CLI was auto-installed. Use `diagram push` to share diagrams."}}'
else
  echo "diagram-cli: install completed but command not in PATH" >&2
  echo "$OUTPUT_EMPTY"
fi

exit 0
