# Memory skill

This skill acts as a **memory file** for Claude: when to use tools and what to do or avoid after certain operations.

- **When to use tools:** Use read/write/run only when needed; don’t call tools speculatively.
- **After edits:** Do re-check or run linter when relevant; don’t run destructive or broad commands unless asked.
- **After failures:** Report and suggest next step; don’t retry the same failing command without a change.
- **After successful tool use:** Use the result; don’t repeat the same search/read.

Edit `SKILL.md` to add project-specific rules. Claude uses this skill when deciding on tool use and follow-up behavior.
