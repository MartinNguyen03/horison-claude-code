---
name: setup
description: Guide for configuring Horison MCP server API keys. Use when an MCP server fails to connect, when the user asks about setup, or when environment variables are missing.
---

# Horison MCP Setup Guide

## MCP servers that need environment variables

Neo4j and Langfuse are included in the plugin's `.mcp.json` but need env vars to connect. Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

### Neo4j Cypher MCP (graph database)

```bash
# For Aura: use neo4j+s:// (encrypted). Find URI in Aura Console → instance → Connect
export NEO4J_URI="neo4j+s://xxxxxxxx.databases.neo4j.io"
export NEO4J_USERNAME="neo4j"
export NEO4J_PASSWORD="your-password"
export NEO4J_DATABASE="neo4j"
```

> **Note:** The plugin pins `fastmcp<3` to avoid a known incompatibility with `mcp-neo4j-cypher`.

### Langfuse (prompt management)

```bash
# Encode your API keys as Base64: echo -n "pk-lf-XXX:sk-lf-XXX" | base64
export LANGFUSE_MCP_AUTH="<base64-encoded-pk:sk>"
```

Get keys from **Langfuse → Project Settings → API Keys**. The plugin prepends `Basic ` automatically.

> **Note:** The MCP endpoint requires Langfuse **v3.125.0+**.

## MCP servers included in the plugin (no setup needed)

| Server | Auth |
|--------|------|
| **Supabase** | OAuth in browser on first use |
| **Langfuse Docs** | No auth required |
| **Context7** | No auth required |
| **Playwright** | No auth required |
| **Memory** | No auth required |
| **Serena** | No auth required |

## If an MCP server fails

- Check env vars are set: `echo $NEO4J_URI`, `echo $LANGFUSE_MCP_AUTH`
- For stdio servers (npx/uvx): ensure `node`/`npx` or `uv`/`uvx` is installed
- Check `~/.claude.json` for conflicting entries: `enabledMcpjsonServers: []` blocks all plugin servers, `disabledMcpServers` can explicitly disable servers
- Servers with missing env vars fail silently — they won't appear in `/mcp`
- Langfuse MCP returning 404? Your instance needs v3.125.0+ — check with `curl -s https://your-instance/api/public/health`
- Restart Claude Code after any config changes — MCP servers connect at startup
