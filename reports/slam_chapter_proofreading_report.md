# Proofreading Report — Chapter 3: SLAM

**Scope:** `3-SLAM/SLAM.tex` and all six section files:
`3-intro/tex/3-intro.tex`, `3-related-work/tex/3-related-work.tex`,
`3-methodology/tex/3-methodology.tex`, `3-results/tex/3-results.tex`,
`3-discussion/tex/3-discussion.tex`, `3-summary/tex/3-summary.tex`

**Status:** 15 trivial fixes applied. 7 items below require author review before changes are made.

---

## Outstanding Items (Require Review)

### HP-4 — Run-on opening paragraph
**File:** `3-intro/tex/3-intro.tex`, line 3

The entire introductory paragraph is effectively one sentence listing three independent
points (GNSS independence, temporal robustness, corridor robustness), producing a dense,
hard-to-parse opening. A suggested rewrite is provided below.

**Suggested rewrite:**
```latex
This chapter presents the development and evaluation of a LiDAR-inertial SLAM pipeline
designed to operate independently of frequent GNSS updates, targeting three core
requirements. First, the system must achieve high-fidelity localisation in GNSS-denied or
GNSS-degraded scenarios. Second, the SLAM front-end must remain invariant to fluctuating
visual appearances, enabling continuous operation across diurnal cycles, varying weather
conditions, and seasonal plant growth. Third, as noted in \cref{chap:background}, vineyard
and orchard rows form long, symmetric, corridor-like structures that limit the geometric
diversity available to scan-matching algorithms, making them susceptible to ambiguity and
longitudinal drift.
```

---

### HP-5 — Mathematical notation inconsistency
**File:** `3-methodology.tex`, line ~221 vs line ~223

The parameter vector is typeset as `$\Theta$` (non-bold scalar) in inline text but as
`$\boldsymbol{\Theta}$` (bold vector) in the display equation. **Author decision required:**
which form is intended? Once confirmed, the non-display occurrences throughout the
subsection should be updated to match.

---

### MP-1 — Vague "as aforementioned"
**File:** `3-intro/tex/3-intro.tex`, line 3

"Thirdly, as aforementioned, vineyard and orchard rows…" — informal and imprecise. The
suggested rewrite under HP-4 above replaces this with `\cref{chap:background}`. This item
is resolved if HP-4 is accepted. **No separate action needed if HP-4 is applied.**

---

### MP-2 — Result cited before it is presented
**File:** `3-intro/tex/3-intro.tex`, line 11 (motivation bullet)

"sub-1\% GNSS factor utilisation" is stated as a known fact in the section introduction,
but the quantitative evidence only appears later in `3-results.tex`. Two options:

- Add a forward reference: `sub-1\% GNSS factor utilisation (see \cref{sec:slam-results})`
- Soften to: `very low GNSS factor utilisation`

**Author decision required** on which approach is preferred.

---

### MP-3 — Suspicious RPE improvement magnitude
**File:** `3-discussion/tex/3-discussion.tex`, line ~66

The claim "roughly tenfold to thirty-fivefold reduction" in RPE standard deviation does not
appear to match the table values. Cross-checking `tab:proposed_performance` vs
`tab:refined_performance`:

| Comparison | Ratio |
|---|---|
| Best refined (0.2449) ÷ best GLIM-GNSS (0.0205) | ≈ 12× |
| Worst refined (0.8239) ÷ worst GLIM-GNSS (0.0479) | ≈ 17× |

The "thirty-fivefold" upper bound is not reproducible from the reported numbers. Suggested
replacement: **"twelve- to seventeen-fold"**. Please verify the comparison methodology and
correct accordingly.

---

### MP-14 — Inapt example for SLAM parameter constraints
**File:** `3-related-work/tex/3-related-work.tex`, line ~123

"such as turn radii or computational resource limits" — turn radii are not typical
LiDAR-SLAM parameters. Suggested replacement examples: voxel resolution bounds, minimum
feature counts, registration iteration limits, or IMU pre-integration window size.
**Author to confirm preferred examples.**

---

### MP-15 — Undefined coined term "Mean-Performance Optimisation"
**File:** `3-methodology/tex/3-methodology.tex`, line ~243

``Mean-Performance Optimisation'' appears capitalised and in quotation marks as though being
coined, but is never formally introduced as such. Two options:

- Define explicitly: *"We refer to this as \textit{mean-performance optimisation}…"*
- Lower-case and paraphrase: *"optimising for mean performance across datasets"*

**Author decision required.**

---

## LaTeX Hygiene — Passing ✓

- **Cross-references:** `\cref{}` used consistently; no bare `\ref{}` calls observed.
- **Citations:** All citations use `\cite{}` or `\protect\cite{}`; no placeholders found.
- **Caption/label ordering:** `\caption{}` before `\label{}` throughout.
