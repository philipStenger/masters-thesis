---
name: figure-table-auditor
description: "Evaluates every figure and table in the thesis: clarity of take-away, axis labels, font sizes, colorblind-friendly colourmaps, caption completeness, page-1 figure presence, and LaTeX label/caption ordering. Produces structured findings for Section 4 of the critique report."
model: claude-opus-4.6
---

# Skill: Figure and Table Auditor

## Purpose
Evaluate every figure and table in the thesis against ML paper writing best practices. Figures are often the first thing a reader looks at — they must be self-contained, clear, and well-captioned.

## How to Use the Checklist

**For each figure and table found, apply `./figure_audit_checklist.md` from this skill folder.** Use it rather than checking criteria from memory — the checklist covers every required criterion in order, including a final Page-1 Figure check that is easy to overlook. Any unchecked criterion becomes a candidate finding.

## What to Evaluate

For every `\begin{figure}`, `\begin{table}`, and `\begin{subfigure}` environment, check all of the following:

### Clarity
- Is the intended take-away immediately clear from the figure alone?
- Is the most important information visually emphasised? (annotation, bold line, highlighted bar, etc.)
- Is there any visual clutter that obscures the key message?

### Axis Labels and Readability
- Are axis titles present on all plots?
- Are axis tick labels, legend text, and in-figure annotations at least as large as the surrounding paper text? Small labels are a common failure mode in printed theses.

### Colourmaps (for heatmaps and colour plots)
- Is a colorblind-friendly colourmap used? (e.g., matplotlib `viridis`, perceptually uniform maps)
- For heatmaps with signed data (positive and negative, zero is meaningful): use a diverging map like `RdBu` with white at zero.
- For non-negative data starting at zero: use `Blues` or similar sequential map.
- Avoid `jet`/`rainbow` — these are not perceptually uniform and are not colorblind-friendly.

### Captions
- Is the caption self-contained? A reader should understand the figure fully from the figure and caption alone, without needing to read the surrounding text.
- Does the caption provide: (1) context on what is shown, (2) the intended interpretation, (3) key technical detail?
- Is the caption too brief (just a title) or too vague?

### Page-1 Figure
- Is there an eye-catching, explanatory figure on or near page 1 (first page of the thesis or first page of each chapter)?
- Explanatory diagrams showing the problem setup or system overview are particularly effective here.

### LaTeX Ordering
- Does `\label{}` follow `\caption{}` within every figure/table environment? (Note: the `latex-hygiene-checker` skill also catches this mechanically — cross-reference its output.)

---

## Output Format

```
[4.N] PRIORITY: HIGH | MEDIUM | LOW
Location: <file path> — figure/table label "<label>" — near: "<≤20-word caption quote>"
Guideline: <one-sentence statement of the figure/table rule violated>
Problem: <2–5 sentences: what is wrong and why it matters>
Fix:
  1. <Concrete instruction>
  2. <Additional step if needed>
```

Number issues 4.1, 4.2, 4.3, etc.
