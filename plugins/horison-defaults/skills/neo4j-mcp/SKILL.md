---
name: neo4j-mcp
description: How to use the Neo4j MCP server tools effectively. Activated when working with the knowledge graph, writing Cypher queries, inspecting graph schema, or managing entities and relationships.
---

# Using the Neo4j MCP Server

The Neo4j MCP server (`mcp-neo4j-cypher`) gives Claude direct Cypher query access to your Neo4j database. Uses the `neo4j+s://` protocol for Aura cloud instances. Requires `NEO4J_URI`, `NEO4J_USERNAME`, `NEO4J_PASSWORD`, `NEO4J_DATABASE` env vars.

## Connection

- **Aura**: `NEO4J_URI=neo4j+s://xxxxxxxx.databases.neo4j.io` (encrypted, required for Aura)
- **Local**: `NEO4J_URI=bolt://localhost:7687`
- Package: `mcp-neo4j-cypher@0.5.2` via `uvx` (requires uv installed)
- The server auto-discovers your graph schema (node labels, relationship types, properties) on startup

## Available Tool Patterns

### Run Cypher queries
```cypher
// Find all companies
MATCH (c:Company) RETURN c.name, c.sector LIMIT 20;

// Find companies with their investors
MATCH (f:Fund)-[r:INVESTED_IN]->(c:Company)
RETURN f.name AS fund, c.name AS company, r.deal_date
ORDER BY r.deal_date DESC LIMIT 20;
```

### Inspect graph schema
```cypher
// All node labels and counts
CALL db.labels() YIELD label
CALL { WITH label MATCH (n) WHERE label IN labels(n) RETURN count(n) AS cnt }
RETURN label, cnt ORDER BY cnt DESC;

// All relationship types
CALL db.relationshipTypes() YIELD relationshipType
RETURN relationshipType;

// Property keys for a label
MATCH (c:Company) WITH c LIMIT 1
RETURN keys(c);

// Indexes and constraints
SHOW INDEXES;
SHOW CONSTRAINTS;
```

### Knowledge graph patterns (Horison-specific)
```cypher
// Find deal flow: which funds invested in which companies
MATCH path = (f:Fund)-[:INVESTED_IN]->(c:Company)
RETURN path LIMIT 50;

// Entity with provenance (which document it came from)
MATCH (d:Document)-[:EXTRACTED]->(e:Entity)
WHERE e.name CONTAINS 'Acme'
RETURN e.name, e.type, d.filename, d.upload_date;

// Community detection prep
MATCH (c1:Company)<-[:INVESTED_IN]-(f:Fund)-[:INVESTED_IN]->(c2:Company)
WHERE c1 <> c2
RETURN c1.name, c2.name, count(f) AS shared_investors
ORDER BY shared_investors DESC LIMIT 20;
```

### Write operations (always use MERGE for idempotency)
```cypher
// Upsert a company
MERGE (c:Company {id: $company_id})
SET c.name = $name, c.sector = $sector, c.updated_at = datetime();

// Create relationship
MATCH (f:Fund {id: $fund_id}), (c:Company {id: $company_id})
MERGE (f)-[r:INVESTED_IN]->(c)
SET r.deal_date = date($deal_date), r.amount = $amount;
```

## Best Practices

- **Always MERGE, never CREATE** for entities — prevents duplicates across document extractions
- **PROFILE before recommending** — check db hits and query plan: `PROFILE MATCH ...`
- **Use parameters** (`$variable`) not string interpolation — prevents injection and enables plan caching
- **Check for indexes** before running filtered queries — missing indexes = full label scans
- **Limit results** when exploring — always add `LIMIT` to exploratory queries
- **Use UNWIND for batch operations** — not individual queries in a loop

## Anti-Patterns to Avoid

- `CREATE` for entities (use `MERGE`)
- Cartesian products (multiple unconnected `MATCH` clauses without `WITH`)
- Variable-length paths without upper bounds: `(a)-[*]->(b)` — always bound: `(a)-[*1..5]->(b)`
- `MATCH (n) WHERE n.name = 'x'` without an index — causes full scan
