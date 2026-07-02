---
name: horison-mcp
description: How to connect to, run locally, and edit/test the Horison app MCP (horison-dev / horison-prod). Use when developing or changing an MCP tool locally, connecting Claude Code to Horison deal/KG data, or when horison-dev / horison-prod fails to connect.
---

# Horison App MCP

The Horison MCP exposes the platform's deal intelligence — knowledge graph,
document vault, metrics, and firm memory — as **17 read-only tools** to any MCP
client (Claude Code, ChatGPT, etc.). The tool code lives in the
[`agentic-chat-service`](https://github.com/horison-ai/agentic-chat-service) repo
under `app/mcp_server/`, mounted at `/mcp`. When deployed it runs as its own
Cloud Run service (`horison-mcp`); locally it's served by the same app on `:8010`.

The plugin registers **two** entries so you can hit either environment in the
same session. **Both authenticate via WorkOS OAuth (Dynamic Client Registration)
in the browser.** They differ only by URL and WorkOS environment:

| Server | URL | WorkOS env | Use it for |
|--------|-----|-----------|------------|
| `horison-prod` | `https://mcp.horison.ai/mcp` (hardcoded) | Production | Normal use against live production data |
| `horison-dev` | `http://localhost:8010/mcp` by default (override `DEV_HORISON_MCP_URL`) | Staging | Building/testing a tool against a server you run locally |

There are **no env vars or tokens to set** for either — auth is browser OAuth.
`DEV_HORISON_MCP_URL` only exists to repoint `horison-dev` at a non-default target
(e.g. the deployed staging service `https://staging---horison-mcp-iosxkhzrva-ew.a.run.app/mcp`).
Any target must be a **registered WorkOS resource indicator**, or OAuth rejects it.

## The 17 tools

15 named tools + a 2-verb ChatGPT facade (`search` / `fetch`). All are
**read-only** and tenant/ACL-scoped server-side:

`list_deals` · `get_deal_overview` · `search_knowledge_graph` ·
`get_entity_details` · `find_evidence` · `read_document` · `get_metric_history` ·
`explore_related` · `compare_entity_across_deals` · `search_firm_knowledge` ·
`search_themes` · `get_firm_memory` · `list_files` · `get_document_insights` ·
`get_suggested_questions`

Run `/mcp` in Claude Code to see the live list once connected.

## Using prod (no setup)

`horison-prod` is hardcoded and needs no configuration. On first use, run `/mcp`,
select **horison-prod → Authenticate**, and complete the WorkOS OAuth flow in the
browser (consent at `app.horison.ai`). Tools appear as `mcp__…horison-prod__*`.

## Editing & testing the local MCP (`horison-dev`)

This is the loop for changing tool code and trying it in Claude Code.

### 1. Run the server locally

In `agentic-chat-service`, on `:8010` with hot reload:

```bash
make mcp        # full app + MCP surface
make mcp-only   # MCP surface only — mirrors the deployed horison-mcp service
```

You'll sign in with OAuth as **your own account** — no token to set up (see
[How local auth works](#how-local-auth-works)).

### 2. Connect Claude Code

`horison-dev` already points at `http://localhost:8010/mcp`. Restart Claude Code,
then `/mcp → horison-dev → Authenticate`. Tools appear as `mcp__…horison-dev__*`.

### 3. Change a tool, in `agentic-chat-service/app/mcp_server/`

1. **Implement** the async function in `tools.py` (e.g. `async def my_tool(...)`).
   Put `Annotated[..., Field(description=...)]` on params — those descriptions are
   what the model sees. Return via `_serialize` / `_error`; `_strip_internal` drops
   internal fields (`tenant_id`, `embedding`, …) so they never leak. Keep it
   **read-only** and lean on the ACL gate (`acl_gate.py`) — don't hand-roll tenant
   filtering.
2. **Register** it in `server.py`:
   `server.tool(...)(audited("my_tool", mcp_tools.my_tool))`. Keep the `audited(...)`
   wrapper — it adds audit logging.

### 4. See your change in Claude Code

`--reload` restarts the server on save. The server is **stateless HTTP**, so:

- **Changed a tool's *behavior*** (same name/params) → just **re-run the tool**;
  the next call hits the reloaded code. No reconnect.
- **Added / renamed a tool, or changed its params or description** → Claude Code
  cached the tool list at connect, so **reconnect** it: `/mcp → horison-dev`
  (reconnect), or restart Claude Code, to refetch the tool surface.

## How local auth works {#how-local-auth-works}

`horison-dev` signs you in with **WorkOS OAuth**, exactly like prod — so every
tool call runs as **your real account** (your tenant, your ACLs). Every dev already
has a Horison user account, so there's nothing else to configure: just
`/mcp → horison-dev → Authenticate`.

The one setup cost is that WorkOS **Staging** routes its consent screen to
`localhost:3000`, so for the OAuth flow to complete the horison-ai frontend must
be running locally and the server needs WorkOS Staging credentials.

## Troubleshooting

- **`horison-dev` failed / connection refused** — the local server isn't running.
  `make mcp` and confirm `http://localhost:8010/mcp` is up.
- **OAuth won't complete for `horison-dev`** — the WorkOS Staging consent screen is
  `localhost:3000`; make sure the horison-ai frontend is running locally and the
  server has valid WorkOS Staging credentials.
- **OAuth rejects the URL / "invalid resource"** — the target isn't a registered
  WorkOS resource indicator (only `localhost:8010`, the staging Cloud Run URL, and
  `mcp.horison.ai` are).
- **Edited a tool but Claude Code doesn't see it** — for new/renamed/re-typed
  tools, reconnect `horison-dev` in `/mcp` (the tool list is cached at connect).
- **Changed env vars but nothing happened** — restart Claude Code; MCP servers
  connect at startup.
