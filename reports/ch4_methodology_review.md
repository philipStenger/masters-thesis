# Chapter 4 Methodology — Detailed Review

**Scope:** Full review of `4-methodology.tex` with focus on experimental methodology; cross-chapter inconsistencies also flagged.  
**Date:** 2026-05-10

---

## 1. Critical Issues

### 1.1 ICP vs GICP — algorithm name inconsistency (partially fixed)

**Partially addressed:** The algorithm name was updated from "ICP" to "Generalised Iterative Closest Point (GICP)" in the approach overview (§4.1.2, line 37 of `4-intro.tex`). However, three issues remain:

1. **Wrong citation:** The text still cites `\cite{beslMethodRegistration3D1992a}` (Besl & McKay, 1992), which is the reference for standard point-to-point ICP. It should cite `\cite{segalGeneralizedICP2009}` (Segal et al., 2009) for GICP.
2. **Wrong description:** The sentence following the algorithm name still describes the standard ICP objective: *"ICP iteratively solves for the rigid transformation... that minimises the sum of squared distances between corresponding point pairs."* GICP uses a probabilistic plane-to-plane metric, not point-to-point sum-of-squares.
3. **Figure caption:** The caption for `pa-approach-overview` (line 47) still says *"registered against the SfM target cloud derived from the 3DGS model using ICP"* — should say "using GICP".

### ~~1.2 Missing GICP parameter values~~ ✅ Fixed

*(All parameter values filled in: δ_r = 10°, max iterations = 50, max correspondence distance = 0.15 m, relative fitness and RMSE convergence = 1×10⁻⁶. Inner/outer perturbation magnitudes documented. Robust kernel left as TODO pending strategy review.)*

### ~~1.3 "3DGS rendering" listed as GPU-resident stage contradicts methodology~~ ✅ Fixed

*(Execution model updated: "3DGS rendering" replaced with "target cloud extraction"; GPU semaphore now only protects FoundationStereo inference; target cloud extraction noted as CPU-bound.)*

### ~~1.4 Missing accumulation interval for LiDAR dense mapping~~ ✅ Fixed

*(Accumulation interval set to 25 s, yielding ~4.4–4.6 M raw points, reduced to ~100 k by the filtering pipeline.)*

---

## 2. Experimental Methodology — Major Concerns

### ~~2.1 No external ground truth for pose accuracy~~ ✅ Fixed

*(Limitations paragraph added to the evaluation metrics section, acknowledging that fitness and RMSE are internal metrics, not direct pose accuracy measurements. Notes that outdoor validation with surveyed references remains future work.)*

### ~~2.2 Very small sample size (n=10) for a factorial design~~ ✅ Fixed

*(Reframed from "3×3 factorial design" to "structured evaluation across nine operating conditions". Added caveat that with n=1 per non-centre condition, the design is exploratory. Replicate described as a repeatability check.)*

### ~~2.3 No statistical analysis plan for the factorial design~~ ✅ Fixed

*(Added descriptive analysis plan: per-condition summary of hypothesis counts, median/IQR of fitness and RMSE, qualitative cross-condition trend discussion. Explicitly states formal statistical tests are not applicable.)*

### ~~2.4 Manual pose measurement — method unspecified~~ ✅ Fixed

*(Added description of the triangulation-based tape-measure procedure: orthogonal distance for translation, three-sided triangle measurement for angle computation. Uncertainty sources explained.)*

### ~~2.5 Indoor environment — ecological validity~~ ✅ Fixed

*(Three limitations added: indoor lighting/reflectance differences, single vine specimen eliminating inter-vine ambiguity, and manual model re-alignment conflated with pipeline error.)*

### 2.6 Missing stereo experimental setup

The experimental setup section (§4.3.8, line 447) states: *"The stereo experimental setup is addressed in a subsequent section."* No such section exists in the methodology. This leaves the stereo modality — one of the two central contributions — without any evaluation framework.

### ~~2.7 No timing/computational cost metrics~~ ✅ Fixed

*(Wall-clock timing added to evaluation protocol: total pipeline latency, preprocessing time, GICP registration time. Reported as mean ± std.)*

---

## 3. Experimental Methodology — Minor Concerns

### ~~3.1 Settling period between trials~~ ✅ Fixed

*(Described as informal — operator waited until robot visibly stationary.)*

### 3.2 Randomised trial order — seed not reported

The trials were executed in randomised order, but the random seed or the actual execution order is not reported. For full reproducibility, either the seed or the actual order should be provided (e.g., in an appendix).

### 3.3 Visual overlay validation is purely qualitative

"Visual overlay" is listed as a complementary validation strategy, but it is inherently subjective. This is acceptable as supplementary evidence but should not be presented as a primary validation method.

**Proposed solution:** Present visual overlays in a structured way: include at least one "good alignment" example and one "borderline/failed" example side-by-side in the results section, with captions that direct the reader's attention to specific geometric features (e.g., trunk centreline alignment, branch junction correspondence). This elevates them from ad-hoc inspection to informative qualitative evidence.

### ~~3.4 Replicate trial naming~~ ✅ Fixed

*(Renamed C1r → D60A0r throughout.)*

---

## 4. Technical Methodology — Issues

### 4.1 Group E perturbation count (10) — not self-evidently derivable

Group E is described as combining *"one axis-aligned translation from Group B with one axis-aligned rotation from Group C."* Group B has 6 elements, Group C has 6 elements, giving 36 possible pairings. Only 10 are used, but the selection criterion is not stated. Which 10 of the 36 possible combinations were chosen, and why?

**Proposed solution:** Check the implementation to identify which 10 pairings are used, then add a brief explanation. The most likely selection is: each of the 3 translation axes (ignoring sign) paired with each of the 3 rotation axes (ignoring sign), giving 9 combinations, plus the identity — but that gives 9, not 10. Alternatively, it may be 5 axis pairs × 2 sign combinations. Whatever the logic, state it explicitly. If there is no principled selection and the 10 were chosen ad-hoc, state that and consider whether a more systematic scheme (e.g., all 36, or a Latin hypercube sample) would be preferable.

### 4.2 Group D perturbation count (12) — clarify selection

Group D combines *"pairs of axis-aligned translations from Group B."* C(6,2) = 15 pairs, but only 12 are used. The text likely excludes same-axis opposing pairs (e.g., +x and −x), giving C(3,2) × 2² = 12. This logic should be made explicit.

**Proposed solution:** Add a parenthetical or footnote: *"Same-axis opposing pairs (e.g., $+\delta_t$ along $x$ combined with $-\delta_t$ along $x$) are excluded, as their net effect is a null translation along that axis; the remaining $\binom{3}{2} \times 2^2 = 12$ combinations are retained."*

### 4.3 Normal-based filtering — "expected surface orientation" undefined

The normal-based filtering step (§4.3.4.3) discards points *"whose estimated normal deviates by more than 100° from the expected surface orientation"*, but the expected surface orientation is never defined. Is it the vertical? The sensor viewing direction? A locally estimated average? This makes the filtering criterion uninterpretable.

**Proposed solution:** State the reference direction explicitly. The most likely candidates are:

- **The vertical axis (gravity direction):** *"Points whose estimated normal deviates by more than 100° from the vertical ($+z$) are discarded, targeting points with pathologically inverted normals caused by noisy surface estimation on thin vine structures."*
- **The sensor viewing direction:** *"Points whose normal deviates by more than 100° from the sensor-to-point viewing ray are discarded, as back-facing normals indicate either surface estimation failure or self-occluded geometry."*

The 100° threshold (just over 90°) suggests this is intended to catch approximately inverted normals rather than to enforce a tight orientation constraint, which is consistent with the "pathological normal" interpretation. Whichever reference is used, state it and briefly explain why 100° (rather than, say, 90° or 120°) is the appropriate threshold.

### ~~4.4 Dual-camera "consistency-based outlier rejection"~~ ✅ Fixed

*(Revised to conditional language: "could in principle enable", "not exploited in the current implementation". Both body text and figure caption updated.)*

### ~~4.5 LiDAR Cauchy kernel rationale~~ ✅ Fixed

*(Added rationale: geometric filtering cannot distinguish vine wood from structurally similar non-vine objects; robust kernel down-weights these residual outlier correspondences.)*

### ~~4.6 Fitness threshold of 0.8~~ ✅ Fixed

*(Added principled justification: threshold ensures alignment is supported by the majority of observed structure.)*

### 4.7 Morphological closing parameters seem inverted

The morphological closing uses a voxel size of 0.02 m and a closing kernel radius of 0.005 m. Typically, the closing kernel should be **larger** than the voxel size to be effective — a kernel of radius 0.005 m operating on a 0.02 m voxel grid can only affect immediately adjacent voxels (and may in fact be too small to bridge any gaps). Verify these parameters are correct and not transposed.

**Proposed solution:** Check the implementation source code. Three possibilities:

1. **Parameters are transposed:** The intended values were voxel size 0.005 m and closing radius 0.02 m. A 5 mm voxel grid preserves fine trunk geometry, and a 20 mm closing kernel bridges gaps of up to ~2 cm — consistent with typical stereo depth holes on bark surfaces. If so, correct the text and table.
2. **Closing radius is in voxel units, not metres:** If the implementation specifies the kernel radius in voxel units (radius = 0.005 / 0.02 ≈ 0.25 voxels), this is effectively a no-op. Check whether the API expects metres or voxel counts.
3. **Parameters are correct but the closing is intentionally minimal:** If so, explain why — perhaps the closing is intended only to fill single-voxel holes and the 0.005 m radius achieves this at the 0.02 m voxel resolution. This would be unusual but defensible if stated explicitly.

### ~~4.8 Patchwork++ RNR/RVPF for solid-state LiDAR~~ ✅ Fixed

*(Clarified that Patchwork++ assigns points to virtual concentric rings based on radial distance regardless of scan pattern; RNR/RVPF operate on this spatial partition.)*

---

## 5. Writing and Structural Issues

### 5.1 Excessive TODO comments

There are approximately **25 TODO comments** embedded in the methodology. While these are invisible in the compiled PDF, their density suggests many parameter choices remain unjustified. The most critical are the missing GICP parameter values (§1.3 above) and the missing accumulation interval (§1.5).

### 5.2 Cross-reference to non-existent content

- `\cref{subsec:system-context}` in §4.3.2 (line 61) points to the introduction's system context section — this is fine but should be verified.
- `\cref{subsec:stereo-depth}` is referenced twice in the stereo pipeline (lines 80, 84) — points to the related work section. This is valid but creates a forward reference from methodology to related work, which is unusual in a thesis structure where related work precedes methodology. Verify the section ordering is correct.

### ~~5.3 Section numbering relative to chapter~~ ✅ Fixed

*(Section title changed to "Precise-Alignment Pipeline".)*

### ~~5.4 Figure caption note~~ ✅ Fixed

*(Editorial note removed from `pa-icp-candidates` caption.)*

---

## 6. Cross-Chapter Consistency

### 6.1 ATE range claim — verified correct

The methodology (line 507) claims the SLAM ATE *"ranges from 0.07 to 0.17 m"*. Cross-checking against the SLAM results (Table 3.x), GLIM-GNSS ATE values across datasets are: 0.0846, 0.0811, 0.1741, 0.0711, 0.1031 m. The range 0.0711–0.1741 m is consistent with the stated "0.07 to 0.17 m". ✅

### ~~6.2 Dense LiDAR — slightly misleading~~ ✅ Fixed

*(Changed "dense LiDAR" → "accumulated LiDAR" in opening paragraph.)*

### 6.3 Results and Discussion are stubs

The results section contains only *"illustrate results"* and the discussion contains only *"discuss results."* This confirms the experimental work is incomplete or in progress, which contextualises several of the methodology gaps above (missing parameters, missing stereo setup, incomplete validation framework).

---

## 7. Summary of Actions Required

| Priority | Issue | Section | Solution |
|----------|-------|---------|----------|
| ~~🔴 Critical~~ | ~~Fix "spinning LiDAR" → "solid-state LiDAR" in intro~~ | ~~§4.1~~ | ✅ Fixed |
| ~~🔴 Critical~~ | ~~Fill in 5 remaining GICP parameter values~~ | ~~§4.3.5, Table~~ | ✅ Fixed (robust kernel left as TODO pending strategy review) |
| ~~🔴 Critical~~ | ~~Fix ICP → GICP citation (Besl→Segal) + description + figure caption~~ | ~~§4.1.2~~ | ✅ Fixed |
| ~~🔴 Critical~~ | ~~Resolve 3DGS rendering contradiction in execution model~~ | ~~§4.3.7~~ | ✅ Fixed |
| ~~🔴 Critical~~ | ~~State the LiDAR accumulation interval~~ | ~~§4.3.4.1~~ | ✅ Fixed (25 s, ~4.4–4.6 M raw points) |
| ~~🟠 Major~~ | ~~Address lack of external ground truth or acknowledge limitation~~ | ~~§4.3.8~~ | ✅ Fixed (limitation acknowledged) |
| ~~🟠 Major~~ | ~~Increase replicates or reframe factorial design language~~ | ~~§4.3.8.3~~ | ✅ Fixed (reframed as exploratory) |
| ~~🟠 Major~~ | ~~Describe manual measurement procedure for initial poses~~ | ~~§4.3.8.4~~ | ✅ Fixed (triangulation procedure described) |
| 🟠 Major | Define "expected surface orientation" for normal filtering | §4.3.4.3 | See §4.3 solution |
| 🟠 Major | Clarify Group E perturbation selection (why 10 of 36?) | §4.3.5 | See §4.1 solution |
| 🟠 Major | Write stereo experimental setup section | §4.3.8 | *Trivial — write it, mirroring LiDAR structure* |
| 🟡 Minor | Verify morphological closing kernel vs voxel size | §4.3.3.3 | See §4.7 solution (3 possibilities) |
| ~~🟡 Minor~~ | ~~Clarify dual-camera outlier rejection (implemented or potential?)~~ | ~~§4.3.3.2~~ | ✅ Fixed |
| ~~🟡 Minor~~ | ~~Justify Cauchy kernel for LiDAR given extensive pre-filtering~~ | ~~§4.3.5~~ | ✅ Fixed |
| ~~🟡 Minor~~ | ~~Justify fitness threshold of 0.8~~ | ~~§4.3.5~~ | ✅ Fixed |
| ~~🟡 Minor~~ | ~~Clarify Patchwork++ ring-based modules on non-ring sensor~~ | ~~§4.3.4.2~~ | ✅ Fixed |
| ~~🟡 Minor~~ | ~~Remove editorial note from ICP candidates figure caption~~ | ~~§4.3.5~~ | ✅ Fixed |
| ~~🟡 Minor~~ | ~~Rename section from "Proposed Methods" to something specific~~ | ~~§4.3~~ | ✅ Fixed |
| ~~🟡 Minor~~ | ~~Specify settling period duration~~ | ~~§4.3.8.3~~ | ✅ Fixed (informal, operator judgment) |
| 🟡 Minor | Add statistical analysis plan or drop factorial framing | §4.3.8.6 | ✅ Fixed (descriptive plan added, factorial language removed) |
| ~~🟡 Minor~~ | ~~Add timing metrics to evaluation protocol~~ | ~~§4.3.8.5~~ | ✅ Fixed |
| ℹ️ Note | ~25 TODO comments remain throughout section | All | — |
| ℹ️ Note | Results and Discussion sections are stubs | §4.4, §4.5 | — |
