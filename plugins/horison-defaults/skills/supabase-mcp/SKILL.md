---
name: supabase-mcp
description: How to use the Supabase MCP server tools effectively. Activated when working with Supabase, writing RLS policies, querying the database, managing auth, or interacting with Supabase Storage.
---

# Using the Supabase MCP Server

The Supabase MCP server gives Claude direct access to your Supabase project. Auth is via OAuth (browser popup on first use).

## Available Tool Patterns

### Query the database
```
Use the Supabase MCP to run SQL:
  SELECT * FROM documents WHERE status = 'processed' LIMIT 10;
```

### Inspect schema
```
List all tables:
  SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

Show columns for a table:
  SELECT column_name, data_type, is_nullable FROM information_schema.columns
  WHERE table_name = 'documents';
```

### Check RLS policies
```
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies WHERE tablename = 'documents';
```

### Test RLS as a specific role
```sql
-- Test as authenticated user
SET role authenticated;
SET request.jwt.claims = '{"sub": "user-uuid-here", "role": "authenticated"}';
SELECT * FROM documents;  -- Should only return user's docs
RESET role;
```

### Manage storage buckets
Use MCP tools to list buckets, check bucket policies, and manage files.

### Auth operations
Use MCP tools to list users, check auth config, and inspect auth hooks.

## Best Practices

- **Always check RLS before writing queries** — understand what the current user can see
- **Use EXPLAIN ANALYZE** on queries before recommending them for production
- **Prefer parameterized patterns** — avoid string interpolation in SQL
- **Check indexes** before adding new queries: `SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'your_table';`
- **Use transactions** for multi-step operations: `BEGIN; ... COMMIT;`

## Common Horison Patterns

- Documents are stored in Supabase Storage, metadata in `documents` table
- User auth via Supabase Auth (email + OAuth providers)
- RLS enforces per-user access — always verify policies when changing schemas
- Edge Functions handle webhook processing and async tasks
