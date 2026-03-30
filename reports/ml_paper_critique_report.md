# Thesis Critique Report: Precise Localisation for Vineyard Pruning Operations

**Author:** Philip Stenger
**Date:** 22 March 2026 *(updated 30 March 2026)*
**Severity Legend:** 🔴 Critical — Must fix before submission | 🟠 Major — Significant quality issue | 🟡 Minor — Polish item

---

## §1 — Narrative and Claims

| #   | Sev. | Location       | Finding                                                                                                                                       |
| --- | ---- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.1 | 🔴   | `abstract.tex` | Abstract is a placeholder: "This thesis is bloody brilliant." Must be replaced with a proper structured abstract (context, gap, method, results, conclusion). |

---

## §2 — Structure

| #   | Sev. | Location            | Finding                                                                              |
| --- | ---- | ------------------- | ------------------------------------------------------------------------------------ |
| 2.1 | 🔴   | `4-results.tex`     | Stub: "illustrate results". The entire Chapter 4 experimental evaluation is missing. |
| 2.2 | 🔴   | `4-discussion.tex`  | Stub: "discuss results".                                                             |
| 2.3 | 🔴   | `4-summary.tex`     | Stub: "Summarise findings from this chapter".                                        |
| 2.4 | 🔴   | `conclusion.tex`    | Stub: "Highlight key findings. Link back to Introduction". No actual conclusion written. |
| 2.5 | 🔴   | `5-future-work.tex` | Stub: "What could be extended upon in future work?"                                  |
| 2.6 | 🟠   | `preface.tex`       | Template boilerplate text, not a real preface.                                       |
| 2.7 | 🟠   | `notation.tex`      | Template boilerplate text, no notation defined.                                      |
| 2.8 | 🟠   | `acknowledgements.tex` | Placeholder: "Thanks mum and dad!"                                                |
| 2.9 | 🟠   | `appendix-a.tex`    | Empty body — no supplementary figures.                                               |

---

## §3 — Evidence Quality

| #   | Sev. | Location                    | Finding                                                                                                                                         |
| --- | ---- | --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 3.1 | 🔴   | `3-results.tex:70–95`       | **Copy-paste error:** Dataset 1 and Dataset 3 columns in Table 3.5 are identical across all 17 metrics.                                        |
| 3.3 | 🟠   | Ch. 3 results               | No statistical significance testing — no confidence intervals, p-values, or variance analysis across the five datasets.                         |
| 3.4 | 🟠   | Ch. 3 discussion            | Ground truth is RTK-GNSS, but the proposed method also uses GNSS as input. Potential circularity is never discussed.                            |
| 3.5 | 🟠   | Ch. 3 results               | Datasets are not characterised: no vine variety, row spacing, terrain slope, weather, time of day, or canopy state reported.                    |
| 3.6 | 🟠   | Ch. 3                       | No comparison against other SLAM systems (LIO-SAM, FAST-LIO2, VineSLAM) despite reviewing them in related work.                               |
| 3.7 | 🟡   | `3-discussion.tex:107`      | All experiments at ~0.5 m/s. Limitation is acknowledged but never tested at higher speeds.                                                      |
| 3.8 | 🟠   | `3-methodology.tex:244–246` | GASP weights $w_\text{drift}$ and $w_\text{smoothness}$ are "empirically tuned" but their values are never stated. Prevents reproducibility.    |

---

## §4 — Figures and Tables

| #   | Sev. | Location                    | Finding                                                                                                  |
| --- | ---- | --------------------------- | -------------------------------------------------------------------------------------------------------- |
| 4.1 | 🟡   | Thesis-wide                 | No page-1 overview figure showing the end-to-end workflow (survey → 3DGS → SLAM → alignment → pruning). |
| 4.2 | 🟡   | `4-methodology.tex:19–27`   | System-level pipeline dataflow figure is commented out.                                                  |
| 4.3 | 🟡   | `4-methodology.tex:302–310` | TF tree correction diagram is commented out.                                                             |

---

## §6 — LaTeX Hygiene

| #   | Sev. | Location                    | Finding                                                                                                                                         |
| --- | ---- | --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 6.6 | 🟠   | `4-methodology.tex`         | 33 `% TODO:` comments requesting parameter justifications and verification.                                                                     |
| 6.7 | 🟠   | `4-methodology.tex:263–266` | ICP parameter table has four cells containing literal "TODO" text for max iterations, correspondence distance, and convergence thresholds.      |

---

## §7 — Common Pitfalls

| #   | Sev. | Location                    | Finding                                                                                                                    |
| --- | ---- | --------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| 7.1 | 🔴   | Thesis-wide                 | **Half-written thesis.** Ch. 4 results/discussion/summary, Ch. 5, abstract, and all front matter are stubs (~40% missing). |
| 7.2 | 🟠   | `3-methodology.tex:244–246` | GASP weights are undisclosed — prevents reproducibility.                                                                   |
| 7.3 | 🟡   | `3-methodology.tex:202–228` | IRR procedure may miss basins of attraction if the initial LHS sample does not cover them. Limitation not discussed.       |

---

## Summary

| Severity    | Remaining | Resolved | Original |
| ----------- | --------- | -------- | -------- |
| 🔴 Critical | 8         | 7        | 15       |
| 🟠 Major    | 12        | 9        | 21       |
| 🟡 Minor    | 5         | 9        | 14       |
| **Total**   | **25**    | **25**   | **50**   |

---

## Top-Priority Actions

1. **Fix copy-paste data error** — Correct the Dataset 1/3 duplicate columns in Table 3.5 (§3.1).
2. **Write the abstract** — Replace placeholder with a structured 150–300 word abstract (§1.1).
3. **Complete Chapter 4** — Write results, discussion, and summary sections (§2.1–2.3).
4. **Write the conclusion** — Complete Ch. 5 body and future work (§2.4–2.5).
5. **Fill ICP parameter table** — Replace TODO cells with actual values (§6.7).
6. **State GASP weights** — Report the numerical values of $w_\text{drift}$ and $w_\text{smoothness}$ in the methodology (§3.8, §7.2).
7. **Write front matter** — Preface, notation table, and acknowledgements (§2.6–2.8).
8. **Characterise datasets** — Add vine variety, row spacing, terrain slope, weather, and canopy state (§3.5).
9. **Address ground truth circularity** — Discuss that RTK-GNSS serves as both input and ground truth (§3.4).
10. **Add statistical analysis** — Confidence intervals or variance analysis across the five datasets (§3.3).

---

## Assessment

The completed portions of this thesis (Chapters 1–3 and Chapter 4 intro/related-work/methodology) are technically strong, well-structured, and demonstrate genuine methodological contribution. The SLAM pipeline design, the geometric outlier rejection procedure, and the IRR parameter optimisation framework are all sound contributions. However, the thesis remains approximately 40% incomplete, with a critical data integrity error in the existing results (§3.1) that must be corrected before submission. All style, hygiene, and most narrative issues from the original report have been resolved.

