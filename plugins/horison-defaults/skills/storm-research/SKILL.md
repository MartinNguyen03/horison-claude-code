---
name: storm-research
description: Run a multi-perspective deep-research pass (Stanford STORM method) on any topic, market, technology, or decision. Use when the user asks to research, evaluate, compare, assess, or make a non-trivial build/buy/architecture decision — anything where a single-prompt answer would inherit one viewpoint's blind spots. Produces a sourced briefing with a contradiction map, a synthesis, and a self-critique with a reliability score.
metadata:
  author: horison-ai
  version: "1.0.0"
  source: "Adapted from Stanford OVAL STORM (NAACL 2024) — github.com/stanford-oval/storm — and the 4-prompt reduction popularised by @heynavtoor."
---

# STORM — multi-perspective deep research

Single-prompt research returns the **majority view** and inherits its blind spots. STORM's insight: ask the same question from several deliberately conflicting expert viewpoints, then mine the disagreements — that is where the real risk and the real decision live. Use this for research, market scans, technology evaluation, and build/buy/architecture decisions.

This skill is the *methodology*, not the Stanford Python package (which is a standalone DSPy pipeline needing search-API keys). Run it as four ordered phases inside this session.

## The five voices

Frame every topic through these five lenses — they see different things on purpose:

| Voice | Asks |
|---|---|
| **Practitioner** | What actually works day-to-day? Where does this break in production? |
| **Skeptic** | What's overhyped, immature, or churning? What could go wrong? |
| **Economist** | Follow the money — incentives, pricing, total cost, build-vs-buy. |
| **Historian** | Where has this pattern played out before? What's the durable lesson? |
| **Academic** | What does the peer-reviewed / primary-source evidence actually say? |

## The four phases (a waterfall — do them in order)

1. **Multi-perspective scan.** Answer the question once from each of the five voices. For factual/market topics, gather evidence first — fan out parallel research subagents (one per area or per voice) using the Agent tool with web search; have each return sourced findings. Concrete citations (URLs, real companies/systems) beat abstract theory.
2. **Contradiction map.** Lay the five reads against each other. Where do they fight, and why? Where is the field *silent* (nobody addressed it)? Agreement across all five ≈ probably true; a silence ≈ a genuine gap. The contradictions are the output that matters most.
3. **Synthesis.** Pull it together into a briefing no single voice could write: name the contradictions, rank claim reliability, and land on a **specific recommended action** — not a survey.
4. **Peer review.** Attack your own briefing. Separate strong claims from weak ones; name biases (anchoring, availability, recency, vendor-framing); list missing angles and unvalidated assumptions; give a **reliability score (%)** and state what evidence would raise it.

## Output shape

- Lead with the recommended action and its confidence.
- Show the contradiction map explicitly — don't bury the disagreements.
- Cite real systems/sources inline; flag every place a claim is vendor-sourced or unverified.
- End with the peer-review section (strong/weak claims, biases, reliability score, what would change the answer).

## When to invoke vs. when not

- **Invoke** for: market/competitor research, technology or vendor evaluation, build-vs-buy, architecture decisions, "should we adopt X", investment/strategy questions.
- **Skip** for: simple factual lookups, mechanical code edits, anything where one authoritative source settles it. Five personas on a trivial question is theatre.

## Scaling the effort

- Quick pass: run the four phases inline in one turn, single-vote peer review.
- Deep pass (the user says "thorough" / "deep" / a real decision): fan out parallel research subagents for phase 1, run phase 4 as an adversarial multi-voice critique. The Workflow tool is appropriate only if the user has opted into multi-agent orchestration.
