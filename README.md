# Horison Claude Code Plugin Marketplace

A curated plugin marketplace for [Claude Code](https://claude.com/claude-code) built around the Horison PE deal intelligence stack — GCP, Supabase, Neo4j Aura, and Langfuse.

One install gives you **11 MCP servers**, **10 specialized agents**, **6 skills**, and **20 optional plugin packs** covering Python, TypeScript, infrastructure, data engineering, and more.

## Quick Start

```bash
# 1. Add the marketplace
/plugin marketplace add <org>/horison-claude-code

# 2. Install the core plugin (MCP servers + agents + skills)
/plugin install horison-defaults@horison-claude-code
```

That's it. All 11 MCP servers, 10 agents, and 7 skills are now available.

## What's in `horison-defaults`

### MCP Servers (11)

| Server | Type | Auth | Purpose |
|--------|------|------|---------|
| **Supabase** | HTTP | OAuth (browser) | Query Postgres, manage auth, storage, edge functions |
| **Neo4j** | stdio (`uvx`) | Env vars | Cypher queries against Neo4j Aura knowledge graph |
| **Langfuse** | HTTP | API key | Prompt management, tracing, evaluation |
| **PostgreSQL** | stdio (`npx`) | Connection string | Direct SQL access |
| **Playwright** | stdio (`npx`) | None | Browser automation and testing |
| **Context7** | stdio (`npx`) | None | Up-to-date library documentation |
| **Linear** | HTTP | OAuth (browser) | Issue tracking and project management |
| **Firebase** | stdio (`npx`) | `firebase login` | Firebase/GCP services |
| **Serena** | stdio (`uvx`) | None | Code-aware AI assistant |
| **Filesystem** | stdio (`npx`) | None | Local file operations |
| **Memory** | stdio (`npx`) | None | Persistent key-value memory |

### Agents (10)

| Agent | Model | Focus |
|-------|-------|-------|
| `gcp-architect` | opus | GCP infrastructure, Cloud Run, IAM, networking |
| `supabase-pro` | opus | RLS policies, Edge Functions, Auth, Storage |
| `neo4j-graph-expert` | opus | Cypher, graph modeling, GDS, knowledge graphs |
| `langfuse-ops` | inherit | Tracing, prompt management, evaluation |
| `kg-pipeline-dev` | opus | Document ingestion, entity extraction, KG construction |
| `code-reviewer` | inherit | Code quality, correctness, readability |
| `security-analyzer` | inherit | OWASP Top 10, auth, data handling |
| `performance-analyzer` | inherit | N+1 queries, bottlenecks, complexity |
| `test-writer` | inherit | Unit and integration test generation |
| `api-documenter` | inherit | REST/GraphQL documentation |

### Skills (7)

| Skill | Purpose |
|-------|---------|
| `supabase-mcp` | How to use Supabase MCP tools effectively |
| `neo4j-mcp` | Cypher patterns, schema inspection, Aura connection |
| `langfuse-mcp` | Prompt management via Langfuse MCP |
| `horison-architecture` | Platform architecture and data flows |
| `memory` | Tool use policy and post-operation behaviour |
| `setup` | API key configuration guide for all MCP servers |

## API Key Setup

Servers that need environment variables — set these in `~/.zshrc` or `~/.bashrc`:

```bash
# Langfuse — encode: echo -n "pk-lf-XXX:sk-lf-XXX" | base64
export LANGFUSE_MCP_AUTH="Basic <base64-output>"

# Neo4j Aura — find URI in Aura Console → instance → Connect
export NEO4J_URI="neo4j+s://xxxxxxxx.databases.neo4j.io"
export NEO4J_USERNAME="neo4j"
export NEO4J_PASSWORD="your-password"
export NEO4J_DATABASE="neo4j"

# PostgreSQL
export DATABASE_URL="postgresql://user:pass@localhost:5432/mydb"
```

Restart Claude Code after setting env vars. See `.env.example` for the full template.

## Optional Plugins (20)

Install any of these for additional skills and commands:

```bash
/plugin install <plugin-name>@horison-claude-code
```

| Plugin | Category | What it adds |
|--------|----------|-------------|
| `python-development` | Languages | 16 skills, Python 3.12+, FastAPI, async, testing |
| `javascript-typescript` | Languages | JS/TS, advanced types, Node.js patterns |
| `backend-development` | Development | API design, GraphQL, microservices, CQRS |
| `frontend-mobile-development` | Development | Next.js App Router, React, Tailwind, React Native |
| `developer-essentials` | Development | Git, SQL, error handling, auth patterns |
| `llm-application-dev` | AI/ML | LangChain/LangGraph, RAG, vector search, prompts |
| `cloud-infrastructure` | Infra | AWS/Azure/GCP, Terraform, service mesh |
| `kubernetes-operations` | Infra | K8s manifests, Helm, GitOps, security policies |
| `devops` | Infra | CI/CD, GitHub Actions, observability, monitoring |
| `database` | Data | PostgreSQL schema, SQL optimization, migrations |
| `data-engineering` | Data | ETL, Spark, dbt, Airflow, data quality |
| `security` | Security | SAST, threat modeling, OWASP, SOC2/HIPAA/GDPR |
| `testing` | Quality | Unit testing, TDD, red-green-refactor |
| `code-quality` | Quality | Refactoring, tech debt, performance review |
| `debugging` | Quality | Error analysis, trace debugging, distributed systems |
| `documentation` | Docs | OpenAPI, Mermaid diagrams, ADRs, changelogs |
| `git-pr-workflows` | Workflows | Git automation, PR enhancement |
| `conductor` | Workflows | Context-Driven Development workflow |
| `agent-teams` | Workflows | Multi-agent parallel code review and development |
| `framework-migration` | Modernization | Framework upgrades, dependency updates |

## Prerequisites

- **Node.js / npx** — required for most stdio MCP servers
- **uv / uvx** — required for Neo4j and Serena MCP servers (`pip install uv` or `brew install uv`)
- **Claude Code** with plugin marketplace support

## Project Structure

```
horison-claude-code/
├── .claude-plugin/
│   └── marketplace.json       # Plugin catalog
├── .env.example               # API key template
├── plugins/
│   ├── horison-defaults/      # Core plugin (MCP + agents + skills)
│   │   ├── .claude-plugin/plugin.json
│   │   ├── .mcp.json          # 11 MCP server configs
│   │   ├── agents/            # 10 agent definitions
│   │   └── skills/            # 7 skill guides
│   ├── python-development/
│   ├── javascript-typescript/
│   └── ...                    # 18 more optional plugins
└── README.md
```

## Disabling MCP Servers

Any server can be disabled without uninstalling the plugin — remove or comment out its entry in the plugin's `.mcp.json`, or manage it through Claude Code's MCP settings.
