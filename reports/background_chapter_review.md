# Background Chapter — Proofreading Report

**Date:** 2026-05-07  
**Scope:** `2-background/tex/2-robot-localisation.tex`, `2-vineyard-robotics.tex`, `2-vineyard-pruning.tex`

---

## Diagnostic Summary

The chapter is well-structured and technically sound. The three sections trace a clear argumentative arc from foundational localisation theory → domain-specific SLAM → pruning-specific alignment. The main issues are:

1. **Critical structural defect** in `2-robot-localisation.tex` line 46: the Summary subsection is missing its opening sentence fragment.
2. Several overly long paragraphs that could benefit from subdivision.
3. Minor phrasing/grammar issues throughout.
4. One suspicious citation year (2026).
5. A few vague or slightly misleading phrasings worth tightening.

Overall quality: **Good** — the chapter reads as a mature, well-cited background review. The issues below are refinements rather than structural failures (except item 1).

---

## Section 1: Robot Localisation (`2-robot-localisation.tex`)

### Critical

| Line | Issue | Suggested Fix |
|------|-------|---------------|
| 46 | **Broken text after `\label{}`**. The Summary subsection begins mid-sentence: `\label{subsec:robot-localisation-summary} that persist in the vineyard localisation problem...`. The introductory sentence is missing. | Insert an opening sentence, e.g.: `The historical trajectory reviewed in this section highlights three foundational challenges that persist in the vineyard localisation problem addressed by this thesis.` |

### Language & Style

| Line | Issue | Suggested Fix |
|------|-------|---------------|
| 18 | "In a subsequent paper, Smith, Self, and Cheeseman extended this framework to the Stochastic Map" — missing citation. | Add `\cite{smithEstimatingUncertainSpatial1990}` or the appropriate key. |
| 18 | Paragraph is ~150 words covering Smith & Cheeseman's framework AND the Stochastic Map extension. Consider splitting after the merging explanation. | Split after "...smaller than either input." Start new paragraph with "In a subsequent paper..." |
| 20 | Paragraph on Elfes is ~170 words covering occupancy grids, sensor complementarity, AND the SLAM co-dependence insight. Very dense for a single paragraph. | Consider splitting after the sentence ending "...than either source alone, as illustrated in \cref{fig:occupancyGridSensorFusion}." |
| 32 | "Convergence to a local minimum is guaranteed" — technically ICP guarantees monotone decrease of the cost function; convergence to a local minimum requires additional regularity assumptions. | Rephrase to: "Monotone convergence is guaranteed; however, the solution is sensitive to initial conditions..." |
| 39 | "EKF-based SLAM integrates past measurements into a global state and then discards those measurements" — EKF marginalises over measurements rather than "discarding" them. | Rephrase: "...incorporates past measurements into a sufficient statistic and then discards the raw observations; over extended trajectories..." |

### LaTeX Hygiene

| Line | Issue |
|------|-------|
| 46 | The label `\label{subsec:robot-localisation-summary}` is on the same line as body text. Should be on its own line after `\subsection{Summary}`. |

---

## Section 2: Vineyard and Orchard Robotics (`2-vineyard-robotics.tex`)

### Language & Style

| Line | Issue | Suggested Fix |
|------|-------|---------------|
| 6 | "The reliance on Global Navigation Satellite Systems (GNSS) often falls short" — awkward subject. "Reliance" doesn't "fall short." | Rephrase: "Global Navigation Satellite Systems (GNSS), on which many agricultural platforms rely, often prove insufficient in orchards..." |
| 10 | "create unique constraints that pose a challenge for" — wordy. | Rephrase: "impose constraints that challenge generic SLAM algorithms designed for..." |
| 14 | "The long uniform rows create a ``corridor effect'', especially for LiDAR-based systems. The corridor effect is characterised by..." — repetitive. | Combine: "The long, uniform rows create a ``corridor effect'' --- particularly acute for LiDAR-based systems --- characterised by the absence of..." |
| 24 | "Many SLAM systems make an assumption of a static world" — wordy. | Rephrase: "Many SLAM systems assume a static world; however,..." |
| 33 | Citation `\cite{zhangKeyTechnologiesIntelligent2026}` — year 2026 seems suspicious. Is this correct or should it be 2024/2025? | **Verify citation year in `MastersThesis.bib`.** |
| 40 | "VineSLAM tries to address" — hedging weakens the claim. | Rephrase: "VineSLAM addresses the perceptual aliasing problem by..." (the system does address it; whether it succeeds fully is shown by the comparison). |
| 40 | "It utilises a Particle Filter that fuses these features; semi-planes offer lateral constraints to keep the robot centred, and point features provide longitudinal constraints along the row." — pronoun "It" is ambiguous (VineSLAM or the Particle Filter?). | Rephrase: "VineSLAM utilises a Particle Filter..." or restructure to remove ambiguity. |
| 70 | "Current research prioritises semantic SLAM to filter dynamic agricultural noise" — "dynamic agricultural noise" is vague. | Rephrase: "...to reject dynamic scene elements (e.g., wind-displaced foliage, passing machinery)..." |

### Minor

| Line | Issue | Suggested Fix |
|------|-------|---------------|
| 14 | "longitudinal position of the robot (the direction of movement down the row)" — redundant parenthetical given the figure caption explains this. | Consider removing the parenthetical or shortening: "...along the longitudinal axis (row direction)..." |
| 42 | Sentence is 50+ words. | Consider splitting after "...rather than a dense point cloud." |
| 69–70 | "The development of SLAM for orchards and vineyards has evolved from the application of generic algorithms to the design of domain-specific architectures." — slightly tautological ("development...evolved"). | Rephrase: "SLAM research for orchards and vineyards has progressed from applying generic algorithms to designing domain-specific architectures." |

---

## Section 3: Vineyard Pruning (`2-vineyard-pruning.tex`)

### Language & Style

| Line | Issue | Suggested Fix |
|------|-------|---------------|
| 3 | "a unique robot localisation challenge in the form of geometric sparsity and the lack of distinctive visual features" — "unique" is a strong claim; "particular" is safer unless justified. | Replace "unique" with "particular" or "distinctive". |
| 16 | "to maintain invariance against ambient shadows" — unnatural phrasing. | Rephrase: "achieving illumination invariance" or "maintaining robustness to ambient lighting variation." |
| 16 | "bypass the lighting and correspondence problem entirely" — "problem" should be plural since two problems are listed. | Change to: "bypass the lighting and correspondence problems entirely." |
| 18 | "they achieve trajectory errors below 1\%" — 1% of what? The baseline is unclear. | Clarify: "trajectory errors below 1\% of the total path length" (if that is what is meant). |
| 20 | "the high-speed obstacle-navigation of Felicetti et al." — Felicetti's system is for pruning, not obstacle navigation. | Rephrase: "the high-throughput processing of Felicetti et al." |

### Structural

| Line | Issue | Suggested Fix |
|------|-------|---------------|
| 16–20 | The paragraph from "However, even optimised trinocular systems..." through to "...toward commercial field speeds" is ~200 words covering three distinct systems/philosophies. | Consider splitting: (1) active sensing paragraph ending at "...7.3 seconds"; (2) computational backend paragraph starting at "The computational backend..." |

### LaTeX Hygiene

| Line | Issue |
|------|-------|
| 7 | Double dash `--` used for parenthetical. The rest of the thesis uses `---` (em-dash). | Change to `---` for consistency. |

---

## Unresolved Ambiguities (Requiring Author Input)

1. **Line 46 of `2-robot-localisation.tex`**: What was the intended opening sentence of the Summary subsection? The suggested reconstruction above is a best guess.
2. **Citation `zhangKeyTechnologiesIntelligent2026`** (line 33 of `2-vineyard-robotics.tex`): Is this a genuine 2026 publication (early online / accepted manuscript), or is the year a BibTeX typo?
3. **"trajectory errors below 1%"** (line 18 of `2-vineyard-pruning.tex`): Is this 1% of total path length, or 1% of vine length, or some other baseline?
4. **Missing citation for Stochastic Map** (line 18 of `2-robot-localisation.tex`): Confirm the correct BibTeX key for Smith, Self, and Cheeseman (1990).
5. **"Archie Jnr"** (line 18 of `2-vineyard-pruning.tex`): Is this the formal system name from Hizatate et al.? Confirm it matches the cited source.

---

## Overall Recommendations

1. **Fix the broken Summary subsection** in `2-robot-localisation.tex` immediately — this is a compilation-affecting defect.
2. **Split the longest paragraphs** (lines 18 and 20 in `2-robot-localisation.tex`; lines 16–20 in `2-vineyard-pruning.tex`) to improve readability.
3. **Tighten hedging language** — replace "tries to address," "often falls short," and similar weak constructions with more assertive phrasing backed by the cited evidence.
4. **Verify the 2026 citation** — if correct, consider adding "(early access)" or similar notation for the reader.
5. **Standardise dash usage** — use `---` (em-dash) consistently for parenthetical asides throughout all three files.
