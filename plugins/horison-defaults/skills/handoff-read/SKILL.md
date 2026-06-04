---
name: handoff-read
description: Find and read the HANDOFF.md handoff document left by a previous agent, then delete it to keep the repo clean before continuing the work.
---

Pick up a handoff left by a previous agent: find `HANDOFF.md`, absorb it, delete it, then continue the work.

## Steps

1. Determine the session's working directory (`pwd`) and look for `HANDOFF.md` there — that's where `/handoff` writes it.
2. If it isn't in the working directory, search the additional working directories and the tree below the cwd (e.g. `find . -maxdepth 3 -iname 'HANDOFF.md'`). If none is found, tell the user there's no handoff to read and stop.
3. Read the file in full and internalize the **Goal / Current Progress / What Worked / What Didn't Work / Next Steps**.
4. **Delete the file** (`rm HANDOFF.md` at the path you found it) now that you've read it. This is the same instruction the self-destruct banner inside the document gives — a handoff is one-time, so removing it keeps the repository clean.
5. Briefly confirm to the user what you picked up (the goal and the next steps) and that you deleted the handoff, then begin the work from where it left off.
