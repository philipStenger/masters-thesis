# Figure and Table Audit Checklist

Apply this checklist to **every** `\begin{figure}`, `\begin{table}`, and `\begin{subfigure}` environment in the thesis.
Fill in the figure label and file location, then work through each criterion.

---

## Checklist Template

```
Figure/Table: \label{<label>}
File: <relative path>
Caption (first 10 words): "<...>"

CLARITY
  [ ] The intended take-away is immediately obvious from the figure alone
  [ ] The most important element is visually emphasised (annotation, bold line, highlighted bar, etc.)
  [ ] No distracting visual clutter that obscures the key message

AXIS LABELS AND READABILITY (plots only)
  [ ] All axes have descriptive titles (including units where applicable)
  [ ] Axis tick labels are legible at print size (≥ paper body font size)
  [ ] Legend text is legible at print size
  [ ] In-figure annotations are legible at print size

COLOURMAP (heatmaps and colour plots only)
  [ ] A colorblind-friendly colourmap is used (viridis, cividis, Blues, RdBu, etc.)
  [ ] NOT using jet/rainbow/hsv (perceptually non-uniform, not colorblind-safe)
  [ ] Colourmap choice matches data type:
        Signed data with meaningful zero → diverging (e.g., RdBu, white at zero)
        Non-negative from zero → sequential (e.g., Blues, viridis)
        Qualitative categories → categorical palette

CAPTION
  [ ] Caption is self-contained — figure fully understandable from figure + caption alone
  [ ] Caption gives: (1) what is shown, (2) intended interpretation, (3) key technical detail
  [ ] Caption is not just a title — it adds interpretive value

LaTeX STRUCTURE
  [ ] \caption{} appears BEFORE \label{} within the environment
  [ ] \label{} is present and follows the thesis naming convention

PLACEMENT
  [ ] Figure appears close to where it is first referenced in the text
  [ ] Figure is referenced in the text with \cref{} before it appears

NOTES / ISSUES FOUND:
  -
```

---

## Page-1 Figure Check

After auditing all individual figures, answer these questions for the whole chapter:

| Question | Answer |
|----------|--------|
| Is there an eye-catching figure on or near the first page of the chapter? | |
| If yes: does it convey the problem setup, system overview, or key result at a glance? | |
| If no: is there a candidate figure that could be moved or a new overview diagram needed? | |

---

## Common Figure Pitfalls to Watch For

- **Axes without labels**: extremely common — check every plot.
- **Tiny tick labels**: often readable on screen but illegible when printed at A4/Letter.
- **jet/rainbow colourmap**: visually appealing but misleading and not colorblind-safe.
- **Caption as title only**: "Figure 3: SLAM results" tells the reader nothing.
- **\label before \caption**: LaTeX ordering issue — hyperref links break.
- **Subfigures with no individual captions**: each subfigure should have its own (a), (b) description.
