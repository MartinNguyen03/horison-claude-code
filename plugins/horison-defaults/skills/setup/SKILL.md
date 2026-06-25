---
name: setup
description: Guide for configuring Horison MCP server API keys. Use when an MCP server fails to connect, when the user asks about setup, or when environment variables are missing.
---

# Horison MCP Setup Guide

## MCP servers that need environment variables

Neo4j and Langfuse are included in the plugin's `.mcp.json` but need env vars to connect. Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

### Neo4j Cypher MCP (graph databases)

The plugin registers **three** Neo4j MCP servers — one per Horison graph environment:

| Server | Graph (Horison environment) | Env var prefix |
|--------|------------------------------|----------------|
| `neo4j-prod` | Horison Prod — tenant graph, **production** (cabde9ed) | `PROD_NEO4J_*` |
| `neo4j-dev` | Horison Dev — tenant graph, **development** (37d16874) | `DEV_NEO4J_*` |
| `neo4j-ta` | Horison TA — consultancy benchmarking graph | `TA_NEO4J_*` |

All run side-by-side as independent stdio subprocesses and surface as separately-namespaced tools (`mcp__...neo4j-prod__*`, `mcp__...neo4j-dev__*`, `mcp__...neo4j-ta__*`), so you can query any graph in the same session. **`neo4j-prod` is production data — prefer `neo4j-dev` for anything exploratory or write-bearing.**

```bash
# Horison Prod (neo4j-prod server)
# For Aura: use neo4j+s:// (encrypted). Find URI in Aura Console → instance → Connect
export PROD_NEO4J_URI="neo4j+s://cabde9ed.databases.neo4j.io"
export PROD_NEO4J_USERNAME="neo4j"
export PROD_NEO4J_PASSWORD="your-prod-password"
export PROD_NEO4J_DATABASE="neo4j"

# Horison Dev (neo4j-dev server)
export DEV_NEO4J_URI="neo4j+s://37d16874.databases.neo4j.io"
export DEV_NEO4J_USERNAME="neo4j"
export DEV_NEO4J_PASSWORD="your-dev-password"
export DEV_NEO4J_DATABASE="neo4j"

# Horison TA (neo4j-ta server)
export TA_NEO4J_URI="neo4j+s://yyyyyyyy.databases.neo4j.io"
export TA_NEO4J_USERNAME="neo4j"
export TA_NEO4J_PASSWORD="your-ta-password"
export TA_NEO4J_DATABASE="neo4j"
```

If you only work on one of the graphs, set just that prefix. Any unconfigured server appears as **failed** in `/mcp` (the Neo4j driver rejects an empty URI at connect time) — that's expected and doesn't affect the working ones.

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

- Check env vars are set: `echo $NEO4J_URI`, `echo $TA_NEO4J_URI`, `echo $LANGFUSE_MCP_AUTH`
- For stdio servers (npx/uvx): ensure `node`/`npx` or `uv`/`uvx` is installed
- Check `~/.claude.json` for conflicting entries: `enabledMcpjsonServers: []` blocks all plugin servers, `disabledMcpServers` can explicitly disable servers
- Servers with missing env vars fail silently — they won't appear in `/mcp`
- Langfuse MCP returning 404? Your instance needs v3.125.0+ — check with `curl -s https://your-instance/api/public/health`
- Restart Claude Code after any config changes — MCP servers connect at startup
