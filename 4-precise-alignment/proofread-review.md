# Proofreading Report — Chapter 4: Precise Alignment

**Date:** 2026-05-11
**Scope:** Full chapter (intro, related work, methodology, results, discussion, summary)

---

## Trivial Fixes Applied

| # | File | Issue | Fix |
|---|------|-------|-----|
| 1 | `4-results.tex` L51 | `Table~\ref{...}` used instead of `\cref{...}` | Changed to `\cref{tab:pa-results-per-job}` |
| 2 | `4-results.tex` L53 | Broken cross-reference `\cref{subsubsec:pa-ground-removal}` — label does not exist | Fixed to `\cref{subsubsec:pa-ground-segmentation}` |
| 3 | `4-related-work.tex` L24 | `\begin{figure}` missing placement specifier — inconsistent with all other figures in chapter | Added `[htbp]` |
| 4 | `4-methodology.tex` L536 | "An informal settling period" — "informal" is colloquial for academic prose | Changed to "A settling period" |

---

## High-Priority Findings

### H1. Perturbation group inconsistency between Methodology and Results

**Location:** `4-methodology.tex` §4.3.5 (Tab 4.4) vs `4-results.tex` §4.4.2 (Tab 4.8)

The methodology defines Groups A–E with counts 1+6+6+12+10 = 35. The results describe a *different* taxonomy: Orig (1) + A (6) + B (4) + C (12) + E (12) = 35, with no Group D. The results section explicitly acknowledges this: *"The group taxonomy used in these experiments represents a revised perturbation scheme relative to the parameterisation described in Table 4.4; the methodology section will be updated to reflect the final implementation."*

**Action required:** Update the methodology perturbation table to match the scheme actually used in the experiments, or vice versa. The two sections must agree.

---

### H2. Meta-comments in Results must be removed

**Location:** `4-results.tex` L9 and L60

Two paragraphs contain self-referential notes about the methodology text needing updating:
- L9: *"the methodology text in §4.3 will be updated separately to reflect this graduated strategy; the single-phase Cauchy parameterisation documented there was superseded during experimental development."*
- L60: *"the methodology section will be updated to reflect the final implementation."*

**Action required:** Once H1 is resolved, delete these meta-comments. They must not appear in the submitted thesis.

---

### H3. Placeholder sections: Discussion and Summary

**Location:** `4-discussion.tex`, `4-summary.tex`

Both sections contain only placeholder text ("discuss results" / "Summarise findings from this chapter").

**Action required:** Write these sections. The discussion should interpret the LiDAR results, contextualise the lidar_job_02 failure, compare against related work expectations, and address limitations (indoor-only, no ground truth). The summary should distil key contributions and bridge to the conclusion chapter.

---

### H4. Placeholder overlay figure

**Location:** `4-results.tex` L287–297 (`fig:pa-results-overlay`)

The visual overlay figure is a `\fbox` placeholder with *"[Placeholder: ... To be added.]"*.

**Action required:** Generate the overlay visualisations for converging trials and replace the placeholder, or remove the subsection if overlays will not be produced.

---

### H5. Condition-label mapping not established

**Location:** `4-results.tex` §4.4.7 and throughout results

Job identifiers (`lidar_job_02`–`lidar_job_08`) have not been mapped to the trial conditions defined in the trial matrix (D40A-15 … D60A0r). Multiple analyses are explicitly deferred because of this: distance effects, angle effects, and the replicate-pair repeatability check.

**Action required:** Establish the mapping and incorporate the deferred analyses. Without this, the experimental design (which was structured around distance × angle factors) cannot be evaluated.

---

### H6. Trial count discrepancy

**Location:** `4-methodology.tex` §4.3.7 defines 10 trials (9 conditions + 1 replicate); `4-results.tex` reports only 7 trials

Seven LiDAR jobs were recorded, but the experimental design specifies ten operating conditions. It is unclear whether three conditions were not executed, three jobs failed and were excluded, or the mapping simply hasn't been applied.

**Action required:** Clarify whether all 10 trials were conducted. If only 7 were, state which conditions were omitted and why.

---

## Medium-Priority Findings

### M1. Stereo pipeline results entirely deferred

**Location:** `4-results.tex` L6, L310

The results section covers only the LiDAR pipeline. Stereo results are noted as *"not yet available"*. The methodology describes the stereo pipeline in full detail (§4.3.3), creating an expectation that results will follow.

**Action required:** Either produce stereo results or add a clear scope statement in the introduction limiting the current evaluation to LiDAR only.

---

### M2. One-use acronyms in Related Work

**Location:** `4-related-work.tex` L21–22 (FoundationStereo paragraph)

The acronyms STA (Side-Tuning Adapter) and AHCF (Attentive Hybrid Cost Filtering) are defined but never used again in the thesis. Introducing single-use acronyms increases cognitive load without aiding readability.

**Action required:** Consider removing the acronyms and using the full terms, or removing the parenthetical definitions.

---

### M3. Starred subsubsection with `\label`

**Location:** `4-methodology.tex` L337–338

`\subsubsection*{Graduated Loss Strategy and Rotation Constraint}` is immediately followed by `\label{subsubsec:pa-graduated-icp}`. Starred sectioning commands do not increment the section counter, so the label resolves to the *previous* numbered entity (likely the enclosing subsection). The label is not currently referenced via `\cref` anywhere, so this is benign — but if it were referenced, `\cref` would produce a misleading number.

**Action required:** Either promote to a non-starred `\subsubsection` or remove the label.

---

### M4. Nineteen TODO comments in methodology

**Location:** `4-methodology.tex` (lines 80, 82, 91, 143, 146, 150, 154, 178, 200, 202, 204, 224, 228, 232, 236, 239, 274) and `4-related-work.tex` (L34)

Nineteen `% TODO` comments remain, primarily requesting parameter justification reviews. These are invisible in the PDF but indicate unfinished work:
- FoundationStereo checkpoint clarification
- Downscale factor justification
- Far-clip distance review
- Multiple filtering parameter reviews
- Sensor mounting height verification
- Missing SS-GLR citation (related work)

**Action required:** Address each TODO or convert the embedded justification text from comment to prose where appropriate.

---

## LaTeX Hygiene Notes

- **Cross-references:** All `\cref` usage is now consistent (the one `\ref` instance has been fixed).
- **Citations:** All 35 citation keys in Chapter 4 resolve to valid entries in `MastersThesis.bib`. No malformed keys or placeholders found.
- **Math notation:** Vectors use `\mathbf` consistently; covariance/mean notation ($\boldsymbol{\mu}_i$) is correct. Euler angles ($\psi$, $\theta$, $\phi$) and transformation matrices ($T$, $\mathbf{R}$, $\mathbf{t}$) are used consistently throughout.
- **Figure placement:** All figures now carry `[htbp]` specifiers consistently.

---

## Open Questions

### OQ1. Is the graduated loss strategy the *final* approach?
The results present Huber+Cauchy as the primary method, but the methodology still documents a single-phase Cauchy parameterisation. Which version should the methodology describe? (Relates to H1/H2.)

### OQ2. Should the results present preliminary data as-is, or should incomplete analyses be removed until the condition mapping is established?
Currently the results section mixes complete analyses (registration summary, timing, baseline comparison) with explicit deferral notices. An alternative structure would present only completed analyses and note the deferred work in a single forward-looking paragraph.

### OQ3. What is the intended scope of Chapter 4 at submission — LiDAR only, or both modalities?
If the stereo pipeline will not be evaluated before submission, the chapter framing (intro, methodology) should be updated to scope the evaluation to LiDAR, noting stereo as future work. If stereo results are expected, the placeholder in Results should remain.

### OQ4. FoundationStereo checkpoint: zero-shot or fine-tuned?
`4-methodology.tex` L80 has a TODO asking whether inference is purely zero-shot or uses a specific fine-tuned checkpoint. This affects the reproducibility of the stereo pipeline description.
