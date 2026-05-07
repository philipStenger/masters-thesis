# SLAM Chapter Fix Plan

## Fixes that can be completed without further information

These are mechanical/objective corrections that require no authorial decisions:

### 1. LaTeX Quote Fixes (2 locations)
- `3-related-work.tex:18` — `"sliding window"` → ``` ``sliding window'' ```
- `3-methodology.tex:243` — `"surviving"` → ``` ``surviving'' ```

### 2. Cross-reference Consistency (2 locations)
- `3-related-work.tex:78` — `Table~\ref{tab:sampling_comparison}` → `\cref{tab:sampling_comparison}`
- `3-related-work.tex:126` — `Table~\ref{tab:slam_failure_modes}` → `\cref{tab:slam_failure_modes}`

### 3. UK English Spelling Fixes (3 locations in methodology)
- `3-methodology.tex:201` — "minimize" → "minimise"
- `3-methodology.tex:201` — "center" → "centre"
- `3-methodology.tex:243` — "normalized" → "normalised"

### 4. Figure Caption Fix — `fig:samplingComparison`
- Fix caption to reference "(a)" and "(b)" instead of "(a) and (b)" + "(g) and (h)"
- Add `\caption{}` to the two subfigures (`fig:mcDist`, `fig:lhsDist`)

### 5. Spider Plot Caption — `fig:comparison_spider`
- `3-results.tex:226` — "glim" → "GLIM"

### 6. Table Float Specifier
- `3-discussion.tex:34` — `[H]` → `[htbp]`

### 7. Bare Superscript Citations (investigate bib file first)
- `3-related-work.tex:136` — `$^{10}$` (×2) → identify correct `\cite{}` key
- `3-related-work.tex:140` — `$^{19}$` → identify correct `\cite{}` key

---

## Fixes that require author input (NOT included above)
- Adding parameter table (need data from experiments)
- Statistical significance testing (authorial/computational decision)
- Ground truth circularity discussion (new prose needed)
- Reframing GNSS-independence claim (authorial decision)
- Computational performance table (need runtime data)
- Reducing "However" density (subjective judgment per instance)
