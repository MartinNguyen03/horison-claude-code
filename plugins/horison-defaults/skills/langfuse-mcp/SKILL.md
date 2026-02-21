---
name: langfuse-mcp
description: How to use the Langfuse MCP server tools effectively. Activated when managing prompts, checking LLM traces, or working with prompt versions and labels.
---

# Using the Langfuse MCP Server

The Langfuse MCP server gives Claude access to prompt management via the Langfuse API. Auth is via `LANGFUSE_MCP_AUTH` env var (`Basic <base64(pk:sk)>`).

## Available Tools

The Langfuse MCP exposes these capabilities:

### List prompts
Browse all managed prompts in the project. Use to discover what prompts exist, their names, and versions.

### Get a specific prompt
Fetch a prompt by name and optionally by version or label (`production`, `staging`, `latest`). Returns the full prompt template with variables.

### Create/update a prompt
Create a new prompt or add a new version to an existing prompt. Supports both text and chat (message array) formats.

## Workflow Patterns

### Discover existing prompts
```
1. List all prompts to see what's available
2. Get the "production" label version of a specific prompt
3. Review the template and variables
```

### Update a prompt safely
```
1. Get current production version
2. Create a new version with changes
3. Label the new version as "staging" for testing
4. After validation, move the "production" label to the new version
```

### Move prompts from code to Langfuse
```
1. Find hardcoded prompts in the codebase (grep for system prompts, templates)
2. Create them in Langfuse with meaningful names
3. Replace hardcoded strings with langfuse.get_prompt("name", label="production")
4. Use {{variable}} syntax for dynamic parts
```

## Prompt Template Format

### Text prompt
```
Extract entities from the following text:

{{document_text}}

Return a JSON array of entities with fields: name, type, confidence.
```

### Chat prompt (message array)
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
- **Include few-shot examples in prompts** — improves extraction quality, managed centrally

## Horison-Specific Patterns

- KG Worker extraction prompts should be managed in Langfuse
- Entity extraction, relationship extraction, and summarization prompts are prime candidates
- Use Langfuse experiments to A/B test prompt versions on evaluation datasets
- Track per-prompt cost to optimize token usage
