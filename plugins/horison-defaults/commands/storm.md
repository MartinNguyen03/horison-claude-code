---
description: "Run a STORM multi-perspective deep-research pass on a topic, market, technology, or decision — produces a sourced briefing with a contradiction map, synthesis, and self-critique."
argument-hint: "<topic or decision to research>"
---

# /storm — multi-perspective deep research

Invoke the **`storm-research`** skill to research the following topic/decision through five conflicting expert lenses, then map contradictions, synthesize, and peer-review the result:

**Topic:** $ARGUMENTS

## Run the four phases in order

1. **Multi-perspective scan** — answer from the **practitioner, skeptic, economist, historian, and academic** voices. For factual/market topics, gather evidence first by fanning out parallel research subagents (Agent tool + web search), each returning sourced findings. Cite real systems/companies/URLs, not abstract theory.
2. **Contradiction map** — where do the five voices disagree, and why? Where is the field *silent* (a genuine gap)? The disagreements are the most important output.
3. **Synthesis** — a briefing no single voice could write: name the contradictions, rank claim reliability, and land on a **specific recommended action**.
4. **Peer review** — attack the briefing: strong vs. weak claims, biases (anchoring/availability/recency/vendor-framing), missing angles, unvalidated assumptions, a **reliability score (%)**, and what evidence would raise it.

Scale the effort to the ask: a quick inline pass for a light question, a full parallel fan-out for a real decision. If the user has opted into multi-agent orchestration, the Workflow tool is appropriate for the phase-1 fan-out; otherwise use parallel Agent calls. See the `storm-research` skill for the full method.
