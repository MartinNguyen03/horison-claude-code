---
name: exa-mcp
description: How to use the Exa MCP server for AI-powered web search. Activated when researching topics, finding documentation, looking up APIs, or gathering external information.
---

# Using the Exa MCP Server

Exa is an AI-powered search engine. The MCP server gives Claude web search capabilities. Requires `EXA_API_KEY` env var.

## When to Use Exa vs Context7

| Use Exa for | Use Context7 for |
|---|---|
| General web research | Library/framework docs (React, Next.js, etc.) |
| Finding blog posts, articles, papers | API reference lookups |
| Searching for company info, news | Package documentation |
| Competitive research | Up-to-date SDK docs |
| Finding GitHub repos, tools | — |

## Search Patterns

### Technical research
```
Search: "FastAPI background tasks best practices 2024"
Search: "Neo4j vector index performance benchmarks"
Search: "Supabase Edge Functions vs Cloud Functions comparison"
```

### Company/deal research (Horison-specific)
```
Search: "company-name private equity acquisition"
Search: "fund-name portfolio companies"
Search: "sector-name M&A deal flow 2024"
```

### Finding documentation and examples
```
Search: "langfuse python SDK decorator tracing example"
Search: "mcp-neo4j-cypher setup guide"
Search: "supabase RLS multi-tenant pattern"
```

## Best Practices

- **Be specific** — "Neo4j GDS community detection Louvain algorithm" > "Neo4j clustering"
- **Include year** for time-sensitive topics — "GCP Cloud Run pricing 2024"
- **Use Exa for research, not for code** — for code patterns, prefer Context7 or reading actual docs
- **Verify results** — Exa returns summaries; always check the source URL for accuracy
