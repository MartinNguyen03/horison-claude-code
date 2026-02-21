---
name: memory
description: When to use tools, and what to do or avoid after certain operations. Use when deciding whether to call a tool, after edits/writes, or when checking follow-up behavior.
---

# Memory: tool use and post-operation behavior

Apply these rules when working in this project.

## When to use tools

- **Use read/search tools** when you need to understand the codebase, find definitions, or verify context before editing.
- **Use write/edit tools** only after you know what to change; prefer one logical change per edit when possible.
- **Use run/terminal tools** when you need to verify behavior (tests, linter, build) or when the user explicitly asks to run something.
- **Do not** invoke tools speculatively (e.g. running a command "to see what happens") unless the user asked for exploration.
- **Do not** use tools for information you already have in the conversation or in provided files.

## After certain operations: do and do not

### After writing or editing files

- **Do:** Re-read the changed region or run the project linter/formatter if the project uses one, when it’s relevant to the task.
- **Do not:** Automatically run destructive or broad commands (e.g. full test suite, deploy, database migrations) unless the user asked for it.
- **Do not:** Assume the edit is correct without checking; if the user asked for a fix, confirm the fix addresses the issue (e.g. by re-reading the code or running a targeted check).

### After running a command that fails

- **Do:** Report the failure clearly and suggest a next step (e.g. fix the command, fix the code, or ask the user).
- **Do not:** Re-run the same failing command repeatedly without changing something.
- **Do not:** Run additional unrelated commands to "see if something else works" unless the user asked.

### After a successful tool use (e.g. search, read)

- **Do:** Use the result to answer or to plan the next edit/command.
- **Do not:** Redo the same search or read if the context is already in the conversation.

### After completing a multi-step task

- **Do:** Summarize what was done and any remaining steps or caveats.
- **Do not:** Start unrelated follow-up tasks unless the user asks.

## Scope

These rules apply in this workspace. Override them only when the user gives explicit instructions (e.g. "run the full test suite" or "don’t run any commands").
