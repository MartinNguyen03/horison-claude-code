---
name: visual-explainer
description: Generate beautiful, self-contained HTML pages that visually explain systems, code changes, plans, and data. Includes Diagram Cloud integration for team sharing. Use when the user asks for a diagram, architecture overview, diff review, plan review, project recap, comparison table, or any visual explanation of technical concepts. Also use proactively when you are about to render a complex ASCII table (4+ rows or 3+ columns) — present it as a styled HTML page instead.
license: MIT
compatibility: Requires a browser to view generated HTML files. Optional surf-cli for AI image generation. Optional diagram CLI for team sharing.
metadata:
  author: horison-ai
  version: "1.0.0"
---

# Visual Explainer — Horison Edition

Generate self-contained HTML files for technical diagrams, visualizations, and data tables. Always open the result in the browser. Never fall back to ASCII art when this skill is loaded.

**Proactive table rendering.** When you're about to present tabular data as an ASCII box-drawing table in the terminal (comparisons, audits, feature matrices, status reports, any structured rows/columns), generate an HTML page instead. The threshold: if the table has 4+ rows or 3+ columns, it belongs in the browser. Don't wait for the user to ask — render it as HTML automatically and tell them the file path. You can still include a brief text summary in the chat, but the table itself should be the HTML page.

---

## Horison Branding & Style

All diagrams generated for Horison projects should follow the Horison design language:

### Color Palette

```css
:root {
  /* Horison Dark (primary) */
  --bg: #0c0c0c;
  --surface: #111111;
  --border: #222222;
  --text: #888888;
  --text-bright: #cccccc;
  --text-dim: #555555;

  /* Horison Accents */
  --accent: #7aa2f7;        /* Primary blue */
  --accent-dim: #1a1b26;
  --green: #9ece6a;
  --yellow: #e0af68;
  --orange: #ff9e64;
  --red: #f7768e;
  --cyan: #7dcfff;
}

@media (prefers-color-scheme: light) {
  :root {
    --bg: #fafafa;
    --surface: #ffffff;
    --border: #e5e5e5;
    --text: #666666;
    --text-bright: #1a1a1a;
    --text-dim: #999999;
    --accent: #4a6adf;
    --accent-dim: #f0f4ff;
    --green: #4d9375;
    --yellow: #b58900;
    --orange: #cb4b16;
    --red: #dc322f;
    --cyan: #2aa198;
  }
}
```

### Typography

**Primary font:** IBM Plex Mono — the Horison signature font. Use for all technical content, labels, and body text.

**Heading font:** IBM Plex Sans or Inter — for larger titles when monospace feels too dense.

```html
<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
```

```css
:root {
  --font: 'IBM Plex Mono', 'SF Mono', Consolas, monospace;
  --font-sans: 'IBM Plex Sans', system-ui, sans-serif;
}
```

### Visual Identity

- **Sharp corners** — no border-radius on containers (or minimal 2-4px max)
- **Monospace everything** — labels, badges, status indicators
- **Lowercase aesthetic** — titles and labels in lowercase for terminal feel
- **Subtle borders** — 1px borders using `var(--border)`
- **No shadows** — use border and background shifts for depth instead
- **Grid/terminal feel** — align to an implicit grid, use consistent spacing (8px base unit)

### Status Indicators

Use styled `<span>` elements with Horison colors, never emoji:

```css
.status {
  font-family: var(--font);
  font-size: 11px;
  padding: 2px 8px;
  text-transform: lowercase;
}
.status--active { background: rgba(158, 206, 106, 0.15); color: var(--green); }
.status--draft { background: rgba(224, 175, 104, 0.15); color: var(--yellow); }
.status--review { background: rgba(122, 162, 247, 0.15); color: var(--accent); }
.status--archived { background: rgba(85, 85, 85, 0.15); color: var(--text-dim); }
.status--error { background: rgba(247, 118, 142, 0.15); color: var(--red); }
```

---

## Diagram Cloud Integration

**CRITICAL:** Every diagram MUST include metadata in the HTML `<head>` section. This metadata is used by the Diagram Cloud CLI to organize and index diagrams for team sharing.

### Required Meta Tags

Add these meta tags after the `<title>` tag in every generated HTML file:

```html
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>descriptive title — subtitle</title>

  <!-- Diagram Cloud Metadata (REQUIRED) -->
  <meta name="diagram:description" content="1-2 sentence description of what this diagram covers">
  <meta name="diagram:folder" content="project/feature-area">
  <meta name="diagram:tags" content="tag1, tag2, tag3">
  <meta name="diagram:category" content="architecture">
  <meta name="diagram:status" content="active">
  <meta name="diagram:project" content="horison-ai">

  <!-- Horison fonts -->
  <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <style>/* ... */</style>
</head>
```

### Metadata Field Guidelines

#### `diagram:description`
A concise 1-2 sentence summary that helps users understand at a glance:
- **What** the diagram covers
- **Scope qualifiers** — is it exhaustive or partial? Does it supersede another diagram?
- **Purpose** — is it a proposal, final spec, analysis, or documentation?

**Good examples:**
- "Final architecture proposal for the file mention system. Defines mention types, context injection, and tool behavior changes."
- "Gap analysis of existing document tools. Identifies what file mentions should and shouldn't do. Non-exhaustive."
- "Draft implementation plan for Diagram Cloud v2. Work in progress."

**Bad examples:**
- "Architecture diagram" (too vague)
- "This diagram shows the system" (says nothing)

#### `diagram:folder`
A 2-3 level path that determines where the diagram is stored:

```
{project}/{feature-or-category}/

Examples:
- horison-ai/file-mentions
- horison-ai/architecture
- agentic-chat-service/analysis
- diagram-cloud/docs
- internal/planning
```

#### `diagram:tags`
Comma-separated keywords for filtering and search:
- Content type: `architecture`, `analysis`, `planning`, `comparison`, `implementation`
- Feature area: `file-mentions`, `agentic`, `chat-service`, `kg-worker`
- Status indicators: `final`, `draft`, `proposal`

#### `diagram:project`
The Horison project this diagram belongs to. Used for filtering in the viewer:
- `horison-ai` — Main Horison platform
- `agentic-chat-service` — Chat backend service
- `diagram-cloud` — This tool's own infrastructure
- Any other project name relevant to the team

#### `diagram:category`
One of:
- `architecture` — System architecture, component diagrams
- `flow` — Flowcharts, pipelines, process flows
- `sequence` — Sequence diagrams, message flows
- `data` — Data models, ER diagrams, schemas
- `comparison` — Tables, feature matrices, gap analyses
- `timeline` — Roadmaps, timelines, milestones
- `state` — State machines, decision trees
- `documentation` — Changelogs, guides, documentation pages
- `other` — Anything that doesn't fit above

#### `diagram:status`
One of:
- `active` — Current, complete, ready for use
- `draft` — Work in progress, incomplete
- `review` — Pending team review before finalizing
- `superseded` — Replaced by newer diagram
- `archived` — Historical reference only

---

## Workflow

### 1. Think (5 seconds, not 5 minutes)

Before writing HTML, commit to a direction.

**Who is looking?** A developer understanding a system? A PM seeing the big picture? A team reviewing a proposal?

**What type of diagram?** Architecture, flowchart, sequence, data flow, schema/ER, state machine, mind map, data table, timeline, or dashboard.

**What aesthetic?** For Horison projects, default to the **monochrome terminal** aesthetic (dark mode with the Horison color palette). Vary only when the content demands it:
- **Terminal** (default) — dark bg, monospace, sharp corners, Horison colors
- **Blueprint** — technical drawing feel, grid lines, cyan accents
- **Data-dense** — small type, tight spacing, maximum information
- **Editorial** — for external-facing docs, serif headlines, generous whitespace

### 2. Structure

**Read the reference template** before generating. Don't memorize it — read it each time to absorb the patterns.
- For text-heavy architecture overviews: read `./templates/architecture.html`
- For flowcharts, sequence diagrams, ER, state machines: read `./templates/mermaid-flowchart.html`
- For data tables, comparisons, audits: read `./templates/data-table.html`

**For CSS/layout patterns and SVG connectors**, read `./references/css-patterns.md`.

**Choosing a rendering approach:**

| Diagram type | Approach | Why |
|---|---|---|
| Architecture (text-heavy) | CSS Grid cards + flow arrows | Rich card content needs CSS control |
| Architecture (topology-focused) | **Mermaid** | Connections need automatic edge routing |
| Flowchart / pipeline | **Mermaid** | Automatic node positioning and edge routing |
| Sequence diagram | **Mermaid** | Lifelines and messages need automatic layout |
| Data flow | **Mermaid** with edge labels | Connections need auto-routing |
| ER / schema diagram | **Mermaid** | Relationship lines need auto-routing |
| State machine | **Mermaid** | State transitions need automatic layout |
| Mind map | **Mermaid** | Hierarchical branching needs auto-positioning |
| Data table | HTML `<table>` | Semantic markup, accessibility, copy-paste |
| Timeline | CSS (central line + cards) | Simple linear layout |
| Dashboard | CSS Grid + Chart.js | Card grid with embedded charts |

**Mermaid theming:** Always use `theme: 'base'` with custom `themeVariables` matching the Horison palette:

```javascript
%%{init: {
  'theme': 'base',
  'themeVariables': {
    'primaryColor': '#1a1b26',
    'primaryTextColor': '#cccccc',
    'primaryBorderColor': '#222222',
    'lineColor': '#7aa2f7',
    'secondaryColor': '#111111',
    'tertiaryColor': '#0c0c0c',
    'fontFamily': 'IBM Plex Mono'
  }
}}%%
```

**Mermaid zoom controls:** Always add zoom controls (+/−/reset buttons) to every `.mermaid-wrap` container. See `./references/css-patterns.md` for the pattern.

### 3. Style

Apply these principles to every diagram:

**Typography is the diagram.** Use IBM Plex Mono as the primary font. All text lowercase unless it's a proper noun or acronym.

**Color tells a story.** Use the Horison CSS custom properties. Each accent color has a purpose:
- `--accent` (blue) — primary actions, links, focus states
- `--green` — success, active, positive
- `--yellow` — warnings, draft, attention
- `--orange` — highlights, important notes
- `--red` — errors, critical, negative
- `--cyan` — info, secondary highlights

**Surfaces whisper, they don't shout.** Build depth through subtle lightness shifts (2-4% between levels), not dramatic color changes. Use `var(--surface)` for cards, `var(--bg)` for page background.

**No rounded corners.** Sharp edges are part of the Horison terminal aesthetic. Maximum 2-4px if absolutely needed for visual softness.

**Borders over shadows.** Use `1px solid var(--border)` instead of box-shadow for depth.

### 4. Deliver

**Output location:** Write to `~/.agent/diagrams/`. Use a descriptive, lowercase, kebab-case filename: `chat-service-architecture.html`, `kg-pipeline-flow.html`, `api-schema-overview.html`.

**Open in browser:**
```bash
open ~/.agent/diagrams/filename.html  # macOS
xdg-open ~/.agent/diagrams/filename.html  # Linux
```

**Share with the team:**
```bash
diagram push --file filename.html
```

The CLI reads metadata from the HTML file automatically.

**View all team diagrams at:** https://diagrams.horison.ai/

### Post-Generation Response

After writing a diagram, include this in your response:

```
📍 Saved to: ~/.agent/diagrams/{filename}.html

🌐 **Share with your team:**
diagram push --file {filename}.html

View at: https://diagrams.horison.ai/
```

---

## Diagram Types

### Architecture / System Diagrams

**Text-heavy overviews** (card content matters more than connections): CSS Grid with explicit row/column placement. Sections as sharp-cornered cards with colored left borders and monospace labels.

**Topology-focused diagrams** (connections matter more than card content): **Use Mermaid** with Horison theming.

### Flowcharts / Pipelines
**Use Mermaid.** Automatic node positioning produces proper diagrams with connecting lines and decision diamonds.

### Sequence Diagrams
**Use Mermaid.** Lifelines, messages, activation boxes, and loops all need automatic layout.

### Data Tables / Comparisons / Audits
Use a real `<table>` element with Horison styling:
- Sticky `<thead>` with `var(--surface)` background
- Alternating row backgrounds (2-3% lightness shift)
- Status indicators using Horison status classes
- Monospace font throughout
- No rounded corners on cells

### Timeline / Roadmap Views
Vertical timeline with a central line (CSS pseudo-element). Phase markers as squares (not circles) on the line. Content cards with sharp corners.

### Dashboard / Metrics Overview
Card grid layout with Horison styling. Hero numbers in `--accent` color. KPI cards with monospace labels.

---

## Complete HTML Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>diagram title — horison</title>

<!-- Diagram Cloud Metadata -->
<meta name="diagram:description" content="Brief description of this diagram">
<meta name="diagram:folder" content="horison-ai/feature">
<meta name="diagram:tags" content="architecture, planning">
<meta name="diagram:category" content="architecture">
<meta name="diagram:status" content="active">
<meta name="diagram:project" content="horison-ai">

<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<style>
:root {
  --font: 'IBM Plex Mono', 'SF Mono', Consolas, monospace;
  --bg: #0c0c0c;
  --surface: #111111;
  --border: #222222;
  --text: #888888;
  --text-bright: #cccccc;
  --text-dim: #555555;
  --accent: #7aa2f7;
  --accent-dim: #1a1b26;
  --green: #9ece6a;
  --yellow: #e0af68;
  --orange: #ff9e64;
  --red: #f7768e;
  --cyan: #7dcfff;
}

@media (prefers-color-scheme: light) {
  :root {
    --bg: #fafafa;
    --surface: #ffffff;
    --border: #e5e5e5;
    --text: #666666;
    --text-bright: #1a1a1a;
    --text-dim: #999999;
    --accent: #4a6adf;
    --accent-dim: #f0f4ff;
    --green: #4d9375;
    --yellow: #b58900;
    --orange: #cb4b16;
    --red: #dc322f;
    --cyan: #2aa198;
  }
}

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  background: var(--bg);
  color: var(--text);
  font-family: var(--font);
  font-size: 13px;
  line-height: 1.6;
  padding: 32px;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
}

h1 {
  font-size: 14px;
  font-weight: 500;
  color: var(--text-bright);
  text-transform: lowercase;
  letter-spacing: 0.05em;
  margin-bottom: 8px;
}

.subtitle {
  color: var(--text-dim);
  font-size: 12px;
  margin-bottom: 32px;
}

.card {
  background: var(--surface);
  border: 1px solid var(--border);
  padding: 16px;
  margin-bottom: 16px;
}

.card--accent {
  border-left: 3px solid var(--accent);
}

.label {
  font-size: 11px;
  color: var(--text-dim);
  text-transform: lowercase;
  letter-spacing: 0.1em;
  margin-bottom: 8px;
}

.status {
  display: inline-block;
  font-size: 11px;
  padding: 2px 8px;
  text-transform: lowercase;
}

.status--active { background: rgba(158, 206, 106, 0.15); color: var(--green); }
.status--draft { background: rgba(224, 175, 104, 0.15); color: var(--yellow); }
.status--review { background: rgba(122, 162, 247, 0.15); color: var(--accent); }

code {
  background: var(--accent-dim);
  color: var(--accent);
  padding: 2px 6px;
  font-family: var(--font);
  font-size: 12px;
}
</style>
</head>
<body>
<div class="container">
  <h1>// diagram title</h1>
  <p class="subtitle">brief description of what this shows</p>

  <!-- diagram content here -->

</div>
</body>
</html>
```

---

## Quality Checks

Before delivering, verify:
- **Horison branding**: IBM Plex Mono font, Horison color palette, sharp corners, lowercase text
- **Metadata complete**: All six `diagram:*` meta tags present and accurate
- **Both themes**: Toggle OS between light and dark mode — both should look intentional
- **Information completeness**: Does the diagram convey what was asked for?
- **No overflow**: Resize browser — no content should clip or escape
- **Mermaid zoom controls**: Every Mermaid diagram has +/−/reset buttons
- **File opens cleanly**: No console errors, no broken fonts

---

## CLI Quick Reference

```bash
# Push diagram (reads metadata from HTML)
diagram push --file my-diagram.html

# Push all diagrams in ~/.agent/diagrams/
diagram push

# List team diagrams
diagram ls
diagram ls --author anish
diagram ls --tag architecture

# Add feedback
diagram comment team/anish/my-diagram.html "Looks great!"

# Update status
diagram status team/anish/my-diagram.html review

# Archive a diagram (shortcut for status → archived)
diagram archive team/anish/old-design.html

# Permanently delete a diagram (manifest + GCS file)
diagram delete team/anish/old-design.html
diagram delete team/anish/old-design.html --yes  # skip confirmation
```

---

## Team

The Horison team includes:
- **anish** — Anish Kochhar
- **nikita** — Nikita
- **martin** — Martin

Author is automatically resolved from:
1. `--author` CLI flag
2. `DIAGRAM_AUTHOR` environment variable
3. `~/.diagram-cloud.json` config file
4. `git config user.name`
