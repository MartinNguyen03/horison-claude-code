# Plugin manifest

Only **plugin.json** belongs here. All other plugin contents live at the plugin root:

- `skills/` — agent skills (e.g. memory)
- `commands/` — slash commands
- `agents/` — subagent definitions
- `hooks/` — hooks.json
- `.mcp.json` — MCP server config (if this plugin bundles its own MCP)

Do not put those directories inside `.claude-plugin/`.

**MCP servers:** This plugin does not bundle MCP. The Horison repo provides MCP servers (Langfuse, GitHub, Neo4j, Postgres, Exa, Supabase, Linear, etc.) at the repo root: use **setup.sh** or copy/merge the root **.mcp.json** into your project and set env vars from **.env.example**.
