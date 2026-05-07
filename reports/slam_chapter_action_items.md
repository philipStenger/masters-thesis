# SLAM Chapter — Action Items

Extracted from `slam_chapter_review.md`. Excludes items already resolved (§11).

---

## Narrative and Claims

1. The term "proposed method" is used generically throughout. Give it a memorable, specific name to improve readability and distinguish it in the literature.

## Structure

2. **Introduction (§3.1):** Missing a roadmap paragraph at the end that previews the section structure.
3. **Related Work (§3.2):** The hyperparameter optimisation review (§3.2.2) is disproportionately long relative to the core SLAM architecture review. Consider moving LHS/LHSMDU details to Methodology and keeping only the motivation here.
4. **Methodology (§3.3):** Section title says "Proposed Methods" (plural) — should be singular or more specific, e.g., "GNSS-Augmented SLAM Pipeline".
5. **Summary (§3.6):** Very brief (1 paragraph). Should include a forward-pointer stating what limitation motivates Chapter 4.

## Evidence Quality

6. **Single run per parameterisation dataset:** Only the evaluation dataset uses multiple runs. Given acknowledged non-determinism, single-run parameterisation results may not be representative. Consider acknowledging this limitation.
7. **Ground truth circularity:** The ground truth (RTK-GNSS) is also used as input to the proposed method. Discuss why this does not invalidate the evaluation (e.g., ground truth is post-processed, continuous RTK vs. sparse factors).
8. **Same farm for 4/5 datasets:** Environmental diversity is limited (4 vineyard datasets from same farm + 1 apple orchard). Cross-farm generalisation is untested — acknowledge this limitation.
9. **GASP metric not externally validated:** GASP is a custom metric with empirically tuned weights. Its properties (sensitivity, ranking consistency) are not analysed.
10. **No computational performance reported:** Runtime, GPU utilisation, and memory usage are not reported — important for practical deployment claims.

## Figures and Tables

11. **`tab:slam_failure_modes`:** Caption is placed after the table body — move caption above the tabular content.
12. **`fig:large_grid_xy` / `fig:large_grid_z`:** 10 subfigures each is very dense. Consider whether all 10 are necessary or if a selection + appendix would serve the reader better.

## Writing Style

13. **`3-intro.tex:3`** — Replace "Furthermore" (banned filler word). Remove or restructure sentence.
14. **`3-results.tex:3`** — Replace "additionally" (banned filler word). Remove or replace with semicolon.
15. **`3-methodology.tex:97`** — Replace "Additionally" (banned filler word). Fold into previous sentence.
16. **`3-intro.tex:3`** — "high-fidelity localisation" is vague. Define quantitatively what "high-fidelity" means.

## Reproducibility / Transparency

17. **Missing parameter table (§3.3.5):** The IRR algorithm description never specifies which exact GLIM parameters are being optimised. Add a table listing all optimised parameters, their physical meaning, initial search bounds, and final optimised values.
18. **Planar Geometry Quality Assessment (§3.3.2):** The combined presentation of SVD, condition number, spread ratio, angular span, and baseline threshold is dense. Add a summary table of thresholds and a single algorithm box to improve clarity.

## Priority Recommendations (from reviewer)

19. **[HIGH]** Add the parameter table (see item 17). Essential for reproducibility.
20. **[HIGH]** Discuss ground truth circularity (see item 7). Add a sentence explaining why this does not invalidate the evaluation.
21. **[MEDIUM]** Add a computational performance table. Report per-frame processing time, GPU memory, and total pipeline latency for each configuration.
