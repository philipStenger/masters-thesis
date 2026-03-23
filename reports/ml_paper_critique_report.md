# Thesis Critique Report: Precise Localisation for Vineyard Pruning Operations

**Author:** Philip Stenger
**Date:** 22 March 2026
**Severity Legend:** 🔴 Critical — Must fix before submission | 🟠 Major — Significant quality issue | 🟡 Minor — Polish item

---

## §1 — Narrative and Claims

| #   | Sev. | Location                                        | Finding                                                                                                                                                              |
| --- | ---- | ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.1 | 🔴   | `abstract.tex`                                  | Abstract is a placeholder: "This thesis is bloody brilliant." Must be replaced with a proper structured abstract (context, gap, method, results, conclusion).        |
| 1.2 | 🔴   | `3-methodology.tex:241` vs `3-discussion.tex:74`| GASP acronym inconsistent: "Global Alignment and **Smoothness** Profile" in methodology/results vs "**Geometric** Alignment and **Scatter** Profile" in discussion. |
| 1.3 | 🟠   | `3-discussion.tex:72–77`                        | GASP metric worsens across optimisation stages but explanation is speculative ("effectively plateaued early"). Needs rigorous analysis or an alternative metric.     |
| 1.4 | 🟠   | `3-discussion.tex:50`                           | "Two orders of magnitude improvement" compares no-GNSS to with-GNSS. The improvement is expected by design; frame as architectural validation, not a surprise.      |
| 1.5 | 🟡   | `3-discussion.tex:62`                           | "Overall excellence of the proposed method" is promotional. Use restrained, evidence-led language.                                                                   |

---

## §2 — Structure

| #    | Sev. | Location                  | Finding                                                                                              |
| ---- | ---- | ------------------------- | ---------------------------------------------------------------------------------------------------- |
| 2.1  | 🔴   | `4-results.tex`           | Stub: "illustrate results". The entire Chapter 4 experimental evaluation is missing.                 |
| 2.2  | 🔴   | `4-discussion.tex`        | Stub: "discuss results".                                                                             |
| 2.3  | 🔴   | `4-summary.tex`           | Stub: "Summarise findings from this chapter".                                                        |
| 2.4  | 🔴   | `conclusion.tex`          | Stub: "Highlight key findings. Link back to Introduction". No actual conclusion written.             |
| 2.5  | 🔴   | `5-future-work.tex`       | Stub: "What could be extended upon in future work?"                                                  |
| 2.6  | 🟠   | `preface.tex`             | Template boilerplate text, not a real preface.                                                       |
| 2.7  | 🟠   | `notation.tex`            | Template boilerplate text, no notation defined.                                                      |
| 2.8  | 🟠   | `acknowledgements.tex`    | Placeholder: "Thanks mum and dad!"                                                                   |
| 2.9  | 🟠   | `appendix-a.tex`          | Empty body — no supplementary figures.                                                               |
| 2.10 | 🟠   | `precise-alignment.tex:1` | Chapter title is `\chapter{precise-alignment}` — should be `\chapter{Precise Alignment}`.           |

---

## §3 — Evidence Quality

| #   | Sev. | Location                                           | Finding                                                                                                                                                             |
| --- | ---- | -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 3.1 | 🔴   | `3-results.tex:70–95`                              | **Copy-paste error:** Dataset 1 and Dataset 3 columns in Table 3.5 are identical across all 17 metrics.                                                            |
| 3.2 | 🔴   | `3-results.tex:126–139` vs `3-discussion.tex:58,92`| **Contradictory GNSS numbers:** Table shows 0.65–0.78% utilisation; discussion text claims "65–78%" and "filtered ~22–35%". Off by two orders of magnitude.         |
| 3.3 | 🟠   | Ch. 3 results                                      | No statistical significance testing — no confidence intervals, p-values, or variance analysis across the five datasets.                                             |
| 3.4 | 🟠   | Ch. 3 discussion                                   | Ground truth is RTK-GNSS, but the proposed method also uses GNSS as input. Potential circularity is never discussed.                                                |
| 3.5 | 🟠   | Ch. 3 results                                      | Datasets are not characterised: no vine variety, row spacing, terrain slope, weather, time of day, or canopy state reported.                                        |
| 3.6 | 🟠   | Ch. 3                                              | No comparison against other SLAM systems (LIO-SAM, FAST-LIO2, VineSLAM) despite reviewing them in related work.                                                   |
| 3.7 | 🟡   | `3-discussion.tex:107`                             | All experiments at ~0.5 m/s. Limitation is acknowledged but never tested at higher speeds.                                                                          |
| 3.8 | 🟠   | `3-methodology.tex:244–246`                        | GASP weights w_drift and w_smoothness are "empirically tuned" but their values are never stated. Prevents reproducibility.                                          |

---

## §4 — Figures and Tables

| #   | Sev. | Location                      | Finding                                                                                                         |
| --- | ---- | ----------------------------- | --------------------------------------------------------------------------------------------------------------- |
| 4.1 | 🟡   | Thesis-wide                   | No page-1 overview figure showing the end-to-end workflow (survey → 3DGS → SLAM → alignment → pruning).        |
| 4.2 | 🟡   | `4-methodology.tex:19–27`     | System-level pipeline dataflow figure is commented out.                                                         |
| 4.3 | 🟡   | `4-methodology.tex:302–310`   | TF tree correction diagram is commented out.                                                                    |
| 4.4 | 🟡   | Ch. 3 results                 | Excessive use of `[H]` float specifier on most figures/tables. Prefer `[htbp]` to avoid whitespace issues.      |

---

## §5 — Writing Style

| #   | Sev. | Location                          | Finding                                                                                 |
| --- | ---- | --------------------------------- | --------------------------------------------------------------------------------------- |
| 5.1 | 🟠   | `3-related-work.tex:7`           | American English: "optimizing" → "optimising".                                          |
| 5.2 | 🟠   | `3-related-work.tex:9`           | American English: "re-parameterization" → "re-parameterisation", "optimization" → "optimisation". |
| 5.3 | 🟠   | `4-related-work.tex:32`          | American English: "relocalization" → "relocalisation".                                  |
| 5.4 | 🟠   | `1-research-context.tex:14`      | American English: "modeling" → "modelling".                                             |
| 5.5 | 🟡   | `1-research-context.tex:6,10,19` | Three manual `\vspace{\medskipamount}` between paragraphs. Remove; let LaTeX handle spacing. |
| 5.6 | 🟡   | `3-discussion.tex:12`            | "reconvening" — use "reconverging" or "returning to".                                   |
| 5.7 | 🟡   | `3-discussion.tex:10,13,18`      | "disfigurement" / "disfigures" — prefer "distortion" / "distorts".                     |

---

## §6 — LaTeX Hygiene

| #   | Sev. | Location                    | Finding                                                                                                  |
| --- | ---- | --------------------------- | -------------------------------------------------------------------------------------------------------- |
| 6.1 | 🔴   | `4-methodology.tex:13,51`  | `\cite{TODO-FoundationStereo}` — broken citation (3 occurrences across Ch. 4).                          |
| 6.2 | 🔴   | `4-methodology.tex:90`     | `\cite{TODO-DBSCAN}` — broken citation.                                                                 |
| 6.3 | 🔴   | `4-methodology.tex:143`    | `\cite{TODO-Patchwork}` — broken citation.                                                               |
| 6.4 | 🔴   | `4-methodology.tex:230`    | `\cite{TODO-Open3D}` — broken citation.                                                                  |
| 6.5 | 🔴   | `4-related-work.tex:21`    | `\cite{TODO-FoundationStereo}` — broken citation.                                                        |
| 6.6 | 🟠   | `4-methodology.tex`        | 33 `% TODO:` comments requesting parameter justifications and verification.                              |
| 6.7 | 🟠   | `4-methodology.tex:263–266`| ICP parameter table has four cells containing literal "TODO" text for max iterations, correspondence distance, and convergence thresholds. |
| 6.8 | 🟡   | `2-robot-localisation.tex:5` | Adjacent `\cite{}` without comma: `\cite{X}\cite{Y}` → should be `\cite{X,Y}`.                        |
| 6.9 | 🟡   | `3-related-work.tex:7`     | Straight ASCII quotes `"edge"` and `"planar"` — use LaTeX backtick/apostrophe quotes.                   |

---

## §7 — Common Pitfalls

| #   | Sev. | Location                        | Finding                                                                                                                        |
| --- | ---- | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| 7.1 | 🔴   | Thesis-wide                     | **Half-written thesis.** Ch. 4 results/discussion/summary, Ch. 5, abstract, and all front matter are stubs (~40% missing).     |
| 7.2 | 🟠   | `3-methodology.tex:244–246`     | GASP weights are undisclosed — prevents reproducibility.                                                                       |
| 7.3 | 🟡   | `3-methodology.tex:202–228`     | IRR procedure may miss basins of attraction if the initial LHS sample does not cover them. Limitation not discussed.           |

---

## Summary

| Severity     | Count |
| ------------ | ----- |
| 🔴 Critical  | 13    |
| 🟠 Major     | 14    |
| 🟡 Minor     | 10    |
| **Total**    | **37**|

---

## Top-Priority Actions

1. **Fix data errors** — Correct the Dataset 1/3 copy-paste duplication and the GNSS utilisation number discrepancy (§3.1, §3.2).
2. **Write the abstract** — Replace placeholder with a structured 150–300 word abstract (§1.1).
3. **Complete Chapter 4** — Write results, discussion, and summary sections (§2.1–2.3).
4. **Write the conclusion** — Complete Ch. 5 body and future work (§2.4–2.5).
5. **Add missing BibTeX entries** — FoundationStereo, DBSCAN, Patchwork++, Open3D (§6.1–6.5).
6. **Resolve GASP acronym** — Pick one expansion and use it everywhere (§1.2).
7. **Fill ICP parameter table** — Replace TODO cells with actual values (§6.7).
8. **Fix UK English** — Replace all American spellings (§5.1–5.4).
9. **Write front matter** — Preface, notation, acknowledgements (§2.6–2.8).
10. **Add statistical analysis** — Confidence intervals or similar for Ch. 3 results (§3.3).

---

## Assessment

The completed portions of this thesis (Chapters 1–3 and Chapter 4 intro/related-work/methodology) are technically strong, well-structured, and demonstrate genuine methodological contribution. The SLAM pipeline design, the geometric outlier rejection procedure, and the IRR parameter optimisation framework are all sound contributions. However, the thesis is approximately 40% incomplete, with critical data integrity issues in the existing results. These must be resolved before submission.
