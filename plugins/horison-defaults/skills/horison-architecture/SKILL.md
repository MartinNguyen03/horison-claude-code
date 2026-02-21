---
name: horison-architecture
description: Horison platform architecture knowledge — service topology, data flows, technology stack, and integration patterns. Activated when working on cross-service concerns or architectural decisions.
---

# Horison Platform Architecture

## Technology Stack

- **Frontend**: Next.js (horison-ai)
- **KG Worker**: FastAPI (Python, port 8082) — document ingestion and knowledge graph extraction
- **Database**: Supabase (PostgreSQL) — primary data store, auth, storage
- **Graph DB**: Neo4j — knowledge graph for extracted entities and relationships
- **LLM Ops**: Langfuse — prompt management, tracing, evaluation, cost tracking
- **Cloud**: Google Cloud Platform (GCP)
- **MCP Servers**: Supabase, Neo4j, Langfuse, GitHub, Context7, Playwright, and more

## Data Flow

```
Document Upload (Supabase Storage)
  → KG Worker (FastAPI)
    → Chunking (TokenChunker)
    → LLM Extraction (traced via Langfuse)
    → Entity Resolution
    → Neo4j Graph Loading (MERGE-based)
    → Embedding Generation
  → Frontend queries (Supabase + Neo4j)
```

## Key Integration Points

- **Supabase ↔ KG Worker**: Documents stored in Supabase Storage, metadata in PostgreSQL, KG Worker reads via Supabase client
- **KG Worker ↔ Neo4j**: Extracted entities and relationships written to Neo4j via Bolt protocol
- **KG Worker ↔ Langfuse**: All LLM calls traced, prompts managed in Langfuse
- **Frontend ↔ Supabase**: Real-time subscriptions, RLS-based data access
- **Frontend ↔ Neo4j**: Graph queries for entity exploration (via API layer)

## Conventions

- Python services use virtual environments (PEP 668)
- `python3` / `pip3` (not `python` / `pip`)
- TokenChunker is the active chunker (RecursiveChunker is dead code)
- All infrastructure on GCP
