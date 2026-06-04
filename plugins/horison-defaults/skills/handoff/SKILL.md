---
name: handoff
description: Write or update a handoff document so the next agent with fresh context can continue this work.
---

Write or update a handoff document so the next agent with fresh context can continue this work.

## Where to save it

Save the file as `HANDOFF.md` in **the current working directory of this Claude Code session** — i.e. the directory the session was launched from (run `pwd` to confirm it). Do **not** walk up to a git root or drop it in a subdirectory.

- Session launched from `Horison/` → `Horison/HANDOFF.md`
- Session launched from `Horison/kg-worker/` → `Horison/kg-worker/HANDOFF.md`

This keeps the handoff next to the work and makes it trivial for the next agent (or `/handoff-read`) to find.

## Steps

1. Determine the session's working directory (`pwd`).
2. Check if `HANDOFF.md` already exists there. If it does, read it first to understand prior context before updating.
3. Create or update the document with:
   - **Goal**: What we're trying to accomplish
   - **Current Progress**: What's been done so far
   - **What Worked**: Approaches that succeeded
   - **What Didn't Work**: Approaches that failed (so they're not repeated)
   - **Next Steps**: Clear action items for continuing
4. Start the document with the self-destruct banner below (verbatim), so the next agent knows to clean it up after reading — even if they open it manually instead of via `/handoff-read`.
5. Tell the user the exact file path so they can start a fresh conversation pointing at it.

## Self-destruct banner

Put this as the very first lines of `HANDOFF.md`, above the Goal section:

```markdown
> **⚠️ One-time handoff — delete after reading.** This file exists only to transfer context to the next agent. Once you have fully read and internalized everything below, delete `HANDOFF.md` (it lives in this same directory) before you begin work, to keep the repository clean. Running `/handoff-read` does this for you.
```
