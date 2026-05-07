# Introduction & Background Review (Chapters 1-2)
 
 **Reviewed:** 2026-05-06
 **Scope:** 1-intro/ (§1.1-1.4) and 2-background/ (§2.1-2.3)
 
 ---
 
 ## 1. Missing Abstract
 **File:** abstract.tex | **Severity:** Critical
 
 The abstract is a placeholder. Must contain: problem statement, method summary, key quantitative results, and implications.
 
 ---
 
 ## 2. No Explicit Contributions List
 **File:** 1-intro/tex/1-research-objectives.tex | **Severity:** High
 
 The introduction lacks a numbered contributions list. Sub-objectives describe aims, not achieved outcomes. Add a \subsection{Contributions} with 3-4 
numbered items stated as accomplished results.
 
 ---
 
 ## 23. Unquantified Comparative Claims
 **Files:** 2-vineyard-robotics.tex:38, 2-vineyard-robotics.tex:68 | **Severity:** Medium
 
 - "VineSLAM outperforms LeGO-LOAM" - no metric or margin given.
 - "has proven essential for centimetre-level accuracy" - strong claim without inline evidence.
 
 Provide metric and approximate margin when claiming one system outperforms another.
 
 ---
 
 ## 24. Missing 3DGS Background Section
 **File:** 2-background/ (overall) | **Severity:** High
 
 3D Gaussian Splatting is referenced repeatedly as the core reconstruction technology, yet the Background provides no explanation of what 3DGS is, how 
it differs from NeRF/SfM, or why extracting point clouds from it is non-trivial.
 
 ---
 
 ## 25. Duplicate Citation for Same Claim
 **File:** 2-background/tex/2-vineyard-robotics.tex, line 4 | **Severity:** Low
 
 \cite{tangFruitTreeMappingSystem2024} used twice in same paragraph for different claims. If from different sections of the paper, this is fine; 
otherwise merge.
 
 ---
 
 ## Summary Table
 
 | Priority | Count | Issues |
 |----------|-------|--------|
 | Critical | 1 | #1 |
 | High | 2 | #2, #24 |
 | Medium | 1 | #23 |
 | Low | 1 | #25 |