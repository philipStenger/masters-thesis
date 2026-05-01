---
name: drawio-workflow
description: "Workflow for creating and editing draw.io diagram files (.drawio) from descriptions. Covers XML generation, file structure, and diagram conventions for architecture, flowchart, sequence, and ER diagrams. Use when creating or modifying a .drawio file."
---

# Draw.io Workflow

## When to Use

- Creating a new draw.io diagram from a user or agent description.
- Editing or extending an existing `.drawio` file.
- Producing architecture, flowchart, sequence, or entity-relationship diagrams for documentation or reports.

## Must-Follow Rules

- **Ask before generating** — If the description is ambiguous (unclear which services connect to which, which diagram type to use), ask before generating XML.
- **Root cells always present** — Every file must include `id="0"` and `id="1"` root cells. Never omit them.
- **Sequential IDs** — Assign sequential integer IDs starting from `2`. Never reuse an ID within a file.
- **Preserve existing IDs when editing** — Only append new IDs; never reassign or remove existing ones.
- **No binary content** — Never embed base64-encoded images or binary data inside `.drawio` files. Keep files text-only XML.
- **Confirm on completion** — After creating or editing, confirm the file path and describe what was drawn in one sentence.

---

## Workflow

### 1 — Clarify

If the request is ambiguous, resolve before generating:
- Which diagram type? (architecture, flowchart, sequence, ER)
- Which components or actors are involved?
- What are the relationships or data flows between them?

### 2 — Plan

Select the diagram type and determine the layout using [diagram-type-conventions](./references/diagram-type-conventions.md).

### 3 — Generate

Construct the `.drawio` XML using the required file header below and shape templates from [shape-styles](./references/shape-styles.md).

**Required file header:**

```xml
<mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="827" math="0" shadow="0">
  <root>
    <mxCell id="0" />
    <mxCell id="1" parent="0" />
    <!-- shapes and connectors here -->
  </root>
</mxGraphModel>
```

Structural rules:
- All shapes: `mxCell` with `vertex="1"` and `parent="1"`.
- All connectors: `mxCell` with `edge="1"`, `source="<id>"`, `target="<id>"`, and `parent="1"`.
- Geometry: nested `<mxGeometry>` child element with `as="geometry"`.
- Children of a swimlane: set `parent="<swimlane-id>"` instead of `parent="1"`.

### 4 — Save and Confirm

Save to the correct path using kebab-case filenames:

| Context | Path |
|---|---|
| Project-specific diagram | `projects/<project-name>/diagrams/<diagram-name>.drawio` |
| Standalone / cross-cutting | `diagrams/<diagram-name>.drawio` |

Examples: `data-pipeline-architecture.drawio`, `auth-flow.drawio`

Confirm the saved file path and describe what was drawn in one sentence.

### 5 — Export to PNG

After saving the `.drawio` file, export it to PNG using the draw.io desktop CLI:

**Executable path:** `C:\Program Files\draw.io\draw.io.exe`

```powershell
& "C:\Program Files\draw.io\draw.io.exe" --export --format png --border 10 "<in.drawio>"
```

**Critical:** Do **not** use the `--output` flag — it suppresses the write and the PNG is silently never created even though the exit code is 0. Omitting `--output` causes draw.io to write the PNG alongside the `.drawio` file with the same base name, which is the correct behaviour.

**Verifying success:**
```powershell
$drawio = "C:\Program Files\draw.io\draw.io.exe"
& $drawio --export --format png --border 10 "path\to\diagram.drawio"
Start-Sleep -Seconds 2   # the process exits before the write completes
Get-Item "path\to\diagram.png"  # confirm file exists with non-zero size
```

**Batch export (multiple files):** Add a `Start-Sleep -Seconds 2` between each export — the CLI exits before the renderer finishes writing, so back-to-back calls can collide:

```powershell
$drawio = "C:\Program Files\draw.io\draw.io.exe"
$dir = "C:\path\to\figures"
foreach ($f in Get-ChildItem $dir -Filter "*.drawio") {
    & $drawio --export --format png --border 10 $f.FullName
    Start-Sleep -Seconds 2
}
```

- For thesis figures, `.drawio` and `.png` files live in the same `figures/` subdirectory (e.g., `4-precise-alignment\4-methodology\figures\`).
- Always verify the PNG exists and has non-zero size after export.

---

## References

| Condition | Reference |
|---|---|
| Need shape XML templates (rectangles, diamonds, swimlanes, connectors) | [shape-styles](./references/shape-styles.md) |
| Choosing diagram type, layout rules, or colour conventions | [diagram-type-conventions](./references/diagram-type-conventions.md) |
