---
name: setup
description: Guide for configuring Horison MCP server API keys. Use when an MCP server fails to connect, when the user asks about setup, or when environment variables are missing.
---

# Horison MCP Setup Guide

## MCP servers that need API keys

Set these as environment variables (in `~/.zshrc`, `~/.bashrc`, or your shell profile):

### Langfuse (prompt management)
```bash
# Get keys from: Langfuse → Project Settings → API Keys
# Encode: echo -n "pk-lf-XXX:sk-lf-XXX" | base64
export LANGFUSE_MCP_AUTH="Basic <base64-output>"
```
Regions: `cloud.langfuse.com` (EU default), `us.cloud.langfuse.com`, `hipaa.cloud.langfuse.com`. Edit `.mcp.json` `langfuse.url` if not EU.

### Neo4j Cypher MCP (graph database)
```bash
# For Aura: use neo4j+s:// (encrypted). Find URI in Aura Console → instance → Connect
export NEO4J_URI="neo4j+s://xxxxxxxx.databases.neo4j.io"
export NEO4J_USERNAME="neo4j"
export NEO4J_PASSWORD="your-password"
export NEO4J_DATABASE="neo4j"
```

### PostgreSQL
```bash
export DATABASE_URL="postgresql://user:pass@localhost:5432/mydb"
```

## MCP servers that need no keys

These work immediately or authenticate via browser:

| Server | Auth |
|--------|------|
| **Supabase** | OAuth in browser on first use |
| **Linear** | OAuth in browser on first use |
| **Context7** | No auth required |
| **Playwright** | No auth required |
| **Filesystem** | No auth required (uses project dir) |
| **Memory** | No auth required |
| **Firebase** | Run `firebase login` once |
| **Serena** | No auth required |

## If an MCP server fails

- Check if the env var is set: `echo $VARIABLE_NAME`
- For stdio servers (npx/uvx): ensure `node`/`npx` or `uv`/`uvx` is installed
- Servers with missing keys will fail silently — they won't appear in Claude's tools
- You can disable any server by removing its entry from `.mcp.json` in the plugin directory

## After setting keys

Restart Claude Code for env vars to take effect. MCP servers connect at startup.
