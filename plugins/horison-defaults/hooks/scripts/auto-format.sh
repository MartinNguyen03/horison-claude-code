#!/bin/bash
# Auto-format files after Claude Code edits
# Supports: TypeScript/JavaScript (Prettier), Python (Ruff), Go (gofmt)

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Get the project root (look for package.json, pyproject.toml, or go.mod)
find_project_root() {
  local dir="$1"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/package.json" || -f "$dir/pyproject.toml" || -f "$dir/go.mod" ]]; then
      echo "$dir"
      return
    fi
    dir=$(dirname "$dir")
  done
  echo ""
}

PROJECT_ROOT=$(find_project_root "$(dirname "$FILE_PATH")")

case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.scss|*.md)
    # TypeScript/JavaScript - use Prettier
    if command -v npx &> /dev/null; then
      if [[ -n "$PROJECT_ROOT" && -f "$PROJECT_ROOT/node_modules/.bin/prettier" ]]; then
        # Use project's Prettier if available
        cd "$PROJECT_ROOT" && npx prettier --write "$FILE_PATH" 2>/dev/null
      elif command -v prettier &> /dev/null; then
        prettier --write "$FILE_PATH" 2>/dev/null
      fi
    fi
    ;;

  *.py)
    # Python - use Ruff (fast, Rust-based)
    if command -v ruff &> /dev/null; then
      ruff format "$FILE_PATH" 2>/dev/null
      ruff check --fix "$FILE_PATH" 2>/dev/null
    elif command -v black &> /dev/null; then
      # Fallback to Black if Ruff not available
      black --quiet "$FILE_PATH" 2>/dev/null
    fi
    ;;

  *.go)
    # Go - use gofmt (built-in)
    if command -v gofmt &> /dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null
    fi
    # Also run goimports if available
    if command -v goimports &> /dev/null; then
      goimports -w "$FILE_PATH" 2>/dev/null
    fi
    ;;
esac

exit 0
