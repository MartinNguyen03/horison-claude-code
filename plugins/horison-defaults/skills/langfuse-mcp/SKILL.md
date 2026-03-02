---
name: langfuse-mcp
description: How to use the Langfuse MCP server tools effectively. Activated when managing prompts, checking LLM traces, or working with prompt versions and labels.
---

# Using Langfuse with Claude Code

Langfuse access is split across two tools:

- **Langfuse MCP server** — prompt management (list, get, create, update prompts)
- **Langfuse CLI** (`npx langfuse-cli`) — trace querying, observations, scores, datasets

## Trace Querying (via CLI)

When the user asks about traces, errors, LLM calls, or observability, use the Langfuse CLI — **not** curl or the REST API.

### Authentication

The CLI reads from environment variables. Source credentials from the service `.env`:

```bash
cd ~/Documents/Horison/agentic-chat-service && source .env
```

Required env vars: `LANGFUSE_PUBLIC_KEY`, `LANGFUSE_SECRET_KEY`, `LANGFUSE_HOST`

### Key Commands

```bash
# List recent traces
npx langfuse-cli api traces list --limit 10

# Get a specific trace
npx langfuse-cli api traces get <trace-id>

# List observations for a trace
npx langfuse-cli api observations list --trace-id <trace-id>

# Filter observations by type (GENERATION, SPAN, EVENT)
npx langfuse-cli api observations list --trace-id <trace-id> --type GENERATION

# Filter by error level
npx langfuse-cli api observations list --level ERROR

# List sessions
npx langfuse-cli api sessions list --limit 20

# List scores
npx langfuse-cli api scores list --limit 20

# Discover all available resources
npx langfuse-cli api __schema

# Preview the equivalent curl command (dry run)
npx langfuse-cli api traces list --limit 5 --curl
```

### Output

- Add `--json` for raw JSON output (useful for piping)
- Default output is formatted for readability

## Prompt Management (via MCP)

The Langfuse MCP server gives Claude access to prompt management. Auth is via `LANGFUSE_MCP_AUTH` env var.

### Available MCP Tools

- **listPrompts** — browse all managed prompts in the project
- **getPrompt** — fetch a prompt by name, optionally by version or label (`production`, `staging`, `latest`)
- **createTextPrompt** — create a new text prompt or add a version
- **createChatPrompt** — create a new chat (message array) prompt or add a version
- **updatePromptLabels** — move labels between versions (e.g. promote staging to production)

### Workflow Patterns

**Discover existing prompts:**
1. List all prompts to see what's available
2. Get the "production" label version of a specific prompt
3. Review the template and variables

**Update a prompt safely:**
1. Get current production version
2. Create a new version with changes
3. Label the new version as "staging" for testing
4. After validation, move the "production" label to the new version

**Move prompts from code to Langfuse:**
1. Find hardcoded prompts in the codebase (grep for system prompts, templates)
2. Create them in Langfuse with meaningful names
3. Replace hardcoded strings with `langfuse.get_prompt("name", label="production")`
4. Use `{{variable}}` syntax for dynamic parts

### Prompt Template Format

**Text prompt:**
```
Extract entities from the following text:

{{document_text}}

Return a JSON array of entities with fields: name, type, confidence.
```

**Chat prompt (message array):**
```json
[
  {"role": "system", "content": "You are an entity extraction expert for PE deal intelligence."},
  {"role": "user", "content": "Extract entities from:\n\n{{document_text}}"}
]
```

## Best Practices

- **Always use labels** — `production` for live, `staging` for testing, `latest` for dev
- **Use variables** (`{{var}}`) for dynamic content — don't create separate prompts for each use case
- **Version, don't overwrite** — create new versions so you can roll back
- **Name prompts by function** — e.g. `entity-extraction`, `relationship-extraction`, `summarization`
- **Use CLI for debugging** — check traces and observations when investigating LLM behavior
- **Use MCP for prompt ops** — manage prompts without leaving Claude Code
