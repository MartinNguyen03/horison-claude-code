---
name: setup
description: Guide for configuring Horison MCP server API keys. Use when an MCP server fails to connect, when the user asks about setup, or when environment variables are missing.
---

# Horison MCP Setup Guide

## MCP servers that need manual configuration

Neo4j and Langfuse are **not** included in the plugin's `.mcp.json`. Users must add them manually in `~/.claude.json` under `projects.<project-path>.mcpServers`.

### Neo4j Cypher MCP (graph database)

Add to `~/.claude.json`:
```json
{
  "projects": {
    "/path/to/Horison": {
      "mcpServers": {
        "neo4j-database": {
          "command": "uvx",
          "args": ["--with", "fastmcp<3", "mcp-neo4j-cypher@0.5.2", "--transport", "stdio"],
          "env": {
            "NEO4J_URI": "neo4j+s://xxxxxxxx.databases.neo4j.io",
            "NEO4J_USERNAME": "neo4j",
            "NEO4J_PASSWORD": "your-password",
            "NEO4J_DATABASE": "neo4j"
          }
        }
      }
    }
  }
}
```

**Important:** The `--with fastmcp<3` flag is required. `mcp-neo4j-cypher` is incompatible with `fastmcp>=3.0` due to a removed `stateless_http` kwarg. Without pinning, the server will crash on startup.

For Aura: use `neo4j+s://` (encrypted). Find URI in Aura Console → instance → Connect.

### Langfuse (prompt management)

Add to `~/.claude.json`:
```json
{
  "projects": {
    "/path/to/Horison": {
      "mcpServers": {
        "langfuse": {
          "type": "http",
          "url": "https://cloud.langfuse.com/api/public/mcp",
          "headers": {
            "Authorization": "Basic <base64-encoded-pk:sk>"
          }
        }
      }
    }
  }
}
```

To encode keys: `echo -n "pk-lf-XXX:sk-lf-XXX" | base64`

Regions: `cloud.langfuse.com` (EU default), `us.cloud.langfuse.com`, `hipaa.cloud.langfuse.com`. Change the URL if not EU.

## MCP servers included in the plugin (no manual setup)

These are defined in the plugin's `.mcp.json` and work automatically:

| Server | Auth |
|--------|------|
| **Supabase** | OAuth in browser on first use |
| **Context7** | No auth required |
| **Playwright** | No auth required |
| **Memory** | No auth required |
| **Firebase** | Run `firebase login` once |
| **Serena** | No auth required |
| **Langfuse Docs** | No auth required |

## If an MCP server fails

- For stdio servers (npx/uvx): ensure `node`/`npx` or `uv`/`uvx` is installed
- Check `~/.claude.json` for conflicting entries: `enabledMcpjsonServers: []` blocks all plugin servers, `disabledMcpServers` can explicitly disable servers
- Servers with missing keys will fail silently — they won't appear in Claude's tools
- Restart Claude Code after any config changes — MCP servers connect at startup
