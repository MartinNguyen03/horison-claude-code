#!/bin/bash
# Detect potential secrets before writing files
# Warns but does not block (exit 0 always)

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty')

# Skip if no content or it's a test/example file
if [[ -z "$CONTENT" ]]; then
  exit 0
fi

if [[ "$FILE_PATH" =~ (test|spec|example|mock|fixture|\.test\.|\.spec\.) ]]; then
  exit 0
fi

# Skip known safe patterns (environment variable references, not actual values)
if [[ "$CONTENT" =~ ^\$\{.*\}$ || "$CONTENT" =~ ^process\.env\. ]]; then
  exit 0
fi

WARNINGS=()

# Check for common secret patterns
# API Keys (various formats)
if echo "$CONTENT" | grep -qiE '(api[_-]?key|apikey)\s*[:=]\s*["\047][a-zA-Z0-9_\-]{20,}["\047]'; then
  WARNINGS+=("Possible API key detected")
fi

# AWS Keys
if echo "$CONTENT" | grep -qE 'AKIA[0-9A-Z]{16}'; then
  WARNINGS+=("AWS Access Key ID pattern detected")
fi

# Private Keys
if echo "$CONTENT" | grep -q '-----BEGIN.*PRIVATE KEY-----'; then
  WARNINGS+=("Private key detected")
fi

# Passwords in code
if echo "$CONTENT" | grep -qiE '(password|passwd|pwd)\s*[:=]\s*["\047][^"\047]{8,}["\047]'; then
  # Exclude common placeholder values
  if ! echo "$CONTENT" | grep -qiE '(password|passwd|pwd)\s*[:=]\s*["\047](password|changeme|secret|test|example|your[_-]?password)["\047]'; then
    WARNINGS+=("Hardcoded password detected")
  fi
fi

# JWT tokens
if echo "$CONTENT" | grep -qE 'eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*'; then
  WARNINGS+=("JWT token detected")
fi

# Supabase keys (service role is sensitive)
if echo "$CONTENT" | grep -qE 'sbp_[a-zA-Z0-9]{40}'; then
  WARNINGS+=("Supabase access token detected")
fi

if echo "$CONTENT" | grep -qE 'service_role.*eyJ[a-zA-Z0-9_-]*'; then
  WARNINGS+=("Supabase service_role key detected - this should be in env vars")
fi

# Google Cloud service account
if echo "$CONTENT" | grep -qE '"type"\s*:\s*"service_account"'; then
  WARNINGS+=("GCP service account JSON detected")
fi

# Generic secrets
if echo "$CONTENT" | grep -qiE '(secret|token|credential)\s*[:=]\s*["\047][a-zA-Z0-9_\-]{20,}["\047]'; then
  WARNINGS+=("Possible secret/token detected")
fi

# Connection strings with passwords
if echo "$CONTENT" | grep -qiE '(postgres|mysql|mongodb|redis)://[^:]+:[^@]+@'; then
  WARNINGS+=("Database connection string with credentials detected")
fi

# Output warnings if any found
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  echo "" >&2
  echo "=== SECRET DETECTION WARNING ===" >&2
  echo "File: $FILE_PATH" >&2
  echo "" >&2
  for warning in "${WARNINGS[@]}"; do
    echo "  - $warning" >&2
  done
  echo "" >&2
  echo "Consider using environment variables instead." >&2
  echo "================================" >&2
  echo "" >&2
fi

# Always exit 0 - warn but don't block
exit 0
