# Chapter 4 (Precise Alignment) — Proofreading Report

**Reviewed:** 2026-05-07  
**Scope:** `4-precise-alignment/` — Introduction, Related Work, Methodology  
**Note:** Results, Discussion, and Summary sections are placeholder stubs and are not yet reviewable.

---

## 1. Executive Summary

The Precise Alignment chapter is clearly structured and technically coherent. The Introduction establishes the motivation compellingly, the Related Work is thorough and well-connected to the system design, and the Methodology is detailed and architecturally sound. Language quality is generally high — sentences are well-constructed, technical terminology is used correctly, and the narrative flows logically from problem to solution.

The main issues to address before submission are:

1. **Several incomplete sections** — Results, Discussion, and Summary are stubs.
2. **Numerous embedded TODO comments** with unresolved parameter values and design questions, including missing ICP parameter values in Table 4.3.
3. **A technical accuracy concern** about SfM producing a *dense* point cloud (it does not without MVS).
4. **A citation quality concern** in the Related Work (a probable malformed author string).
5. **Minor language issues** — a handful of weak sentence openers, one subject-verb agreement error, one informal phrasing, and one slightly contradictory term.

---

## 2. Incomplete Sections

| Section | Status | Action Required |
|---------|--------|-----------------|
| `4-results.tex` | Placeholder: "illustrate results" | Write in full |
| `4-discussion.tex` | Placeholder: "discuss results" | Write in full |
| `4-summary.tex` | Placeholder: "Summarise findings from this chapter" | Write in full |

---

## 3. Language and Style Issues

Issues are listed by file and approximate line number.

### 3.1 Introduction (`4-intro/tex/4-intro.tex`)

| Line | Issue | Suggested Revision |
|------|-------|--------------------|
| 4 | "the tolerance on positional error is far smaller" — slightly awkward phrasing | → "the permissible positional error is far smaller" |
| 6 | Sentence opener "Importantly," — weak adverbial opener not supported by a comparison; simply delete or restructure | → "By contrast, whereas the SLAM system…" |
| 6 | "This work relies on that leafless condition" — "this work" is vague; refers to the pipeline, not the thesis as a whole | → "The alignment pipeline relies on that leafless condition…" |
| 11 | "registered within a global Local East-North-Up (ENU) reference frame" — "global Local" is self-contradictory; ENU is inherently a local frame anchored to a geographic origin | → "anchored to an East-North-Up (ENU) reference frame" |
| 11 | "All downstream tasks … are computed against this 3DGS model" — "computed against" is imprecise | → "…are computed with reference to this 3DGS model" |

### 3.2 Related Work (`4-related-work/tex/4-related-work.tex`)

| Line | Issue | Suggested Revision |
|------|-------|--------------------|
| 9 | "by computing the disparity $d$ between a spatially separated pair of images" — "between a spatially separated pair" is awkward; disparity is computed *between* two image views, not between the images themselves | → "from the disparity $d$ between corresponding pixels in a rectified stereo pair, related to metric depth $Z$ by the standard pinhole relation:" |
| 13 | No punctuation after the depth equation — equations within prose require a comma or period | Add a comma after the `\end{equation}` block |
| 19 | "A related formulation by Tamura et al." — "related" is too vague here; the connection to Wang et al. is not obvious | → "A complementary approach by Tamura et al." or simply begin with "Tamura et al." |
| 43 | **Citation concern** — the author string rendered as "Pavol Jozef et al." is almost certainly a malformed BibTeX entry where an institution name has been parsed as a personal name (key: `pavoljozefsafarikuniversityinkosiceSynergisticUseLiDAR2025`). Check the `author` field in `MastersThesis.bib` and correct to the actual author surname(s). | Fix BibTeX entry |
| 43 | Mixed accuracy metrics in the same comparison: "48.9% *producer* accuracy" vs "96% *overall* accuracy" — these are not directly comparable | Either harmonise the reported metrics or add a brief parenthetical: "(producer accuracy: 48.9% vs.\ 96%)" to make the basis of comparison explicit |
| 54 | "the precise alignment problem" — inconsistent hyphenation; throughout the chapter the compound is hyphenated | → "the precise-alignment problem" |
| 61 | "the choice of … each independently determine" — subject-verb agreement error; with "each" as the operative subject, the verb should be singular | → "each independently **determines**" |
| 69 | "deep auto-encoder" — the standard form in the ML literature is unhyphenated | → "deep autoencoder" |
| 69 | "under the large initial misalignment typical when registering" — slightly informal | → "under the large initial misalignment typical of close-range-to-map registration scenarios" |

### 3.3 Methodology (`4-methodology/tex/4-methodology.tex`)

| Line | Issue | Suggested Revision |
|------|-------|--------------------|
| 4 | "both converge on a shared ICP registration back-end" — "converge on" implies approaching a consensus; the intended meaning is that both pipelines *feed into* the same module | → "both feed into a shared ICP registration backend" |
| 14 | "removing the ground plane with Patchwork++" — present participle dangles slightly in the long sentence | → "…using Patchwork++ for ground plane removal, and applying a multi-stage filtering sequence…" |
| 83 | "benchmarked performance" — adjective should be "benchmark" (noun used attributively) | → "its benchmark performance" |
| 100 | "each cloud would need to be trusted independently with no means of cross-validation" — informal register | → "each cloud would have to be accepted independently, with no means of cross-validation" |
| 154 | The input-cap sentence ("The combined cloud is capped at 600,000 points…") is placed *after* describing all three segmentation stages, but the cap is applied "prior to the first stage" — this ordering is confusing | Move this sentence to immediately *before* the description of Stage 1 (Morphological closing), or add a forward pointer at the top of the pipeline description |
| 237 | "Points whose estimated normal deviates by more than $100^{\circ}$ from the **expected surface orientation**" — "expected surface orientation" is never defined; the intent appears to be to reject inverted or pathological normals (> 90° from the consensus orientation), but this is not stated | Clarify: "…deviates by more than $100^{\circ}$ from the local consensus surface orientation" and briefly explain how the reference orientation is determined |
| 355 | Sentence beginning "Before this result can be applied…" is very long (two independent clauses joined by "and") | Split: "Before this result can be applied to the robot's localisation, it must be expressed in the base-link frame that serves as the canonical reference for all downstream planning and control components. It must also be introduced into the ROS~2 transform tree~\cite{macenskiRobotOperatingSystem2022} without disturbing the SLAM system's own transform publications." |
| 398 | "following the command design pattern" — design pattern names are conventionally capitalised | → "following the Command design pattern" |
| 398 | "executes them sequentially within a dedicated worker thread pool" — a thread pool executes tasks concurrently; "sequentially within a thread pool" is contradictory unless only one thread is active | Clarify: if the queue is single-threaded, write "a dedicated worker thread"; if concurrent execution is possible but logically ordered, explain the ordering constraint explicitly |

---

## 4. Technical Accuracy Concerns

### 4.1 SfM and dense point clouds (`4-intro.tex`, line 11)

> "The reconstruction pipeline applies Structure from Motion (SfM) photogrammetry to these images, recovering a **dense** 3D point cloud and camera trajectory via bundle adjustment."

SfM with bundle adjustment yields a *sparse* point cloud (from feature correspondences) plus camera poses. A *dense* reconstruction requires a subsequent Multi-View Stereo (MVS) step. If the pipeline uses an integrated SfM+MVS tool (e.g., COLMAP, Agisoft Metashape), the sentence should name both steps:

**Suggested revision:**
> "The reconstruction pipeline applies Structure from Motion with Multi-View Stereo (SfM+MVS) photogrammetry to these images, recovering a dense 3D point cloud and camera trajectory."

Alternatively, if only the sparse SfM output is used as the backbone for 3DGS training, remove "dense":
> "…recovering a sparse 3D point cloud and camera trajectory via bundle adjustment."

Please clarify which is technically correct for your pipeline.

### 4.2 "Sequential execution within a thread pool" (`4-methodology.tex`, line 398)

See §3.3 above. The architectural description of the execution model uses "sequentially" and "thread pool" in a way that is internally inconsistent. Confirm whether the worker is single-threaded or multi-threaded and revise accordingly.

---

## 5. LaTeX Hygiene

| Location | Issue |
|----------|-------|
| `4-related-work.tex`, eq. after line 13 | Missing punctuation (comma) after the depth equation — add `,` before the "where $f$…" sentence |
| `4-methodology.tex`, Table 4.3 (ICP params) | Four parameter values are written as `\textit{TODO}` — these will render as italic "TODO" in the compiled PDF. Resolve before submission |
| `4-methodology.tex` throughout | 19 embedded `% TODO:` comments remain. None break compilation, but all must be resolved. See §6 for a consolidated list |
| `4-results.tex`, `4-discussion.tex`, `4-summary.tex` | Stub sections will compile but produce trivial section content in the PDF |

---

## 6. Consolidated TODO List

The following TODO comments are embedded in the methodology source. They are reproduced here for convenience; resolve each before submission.

| # | File / approx. line | Summary |
|---|---------------------|---------|
| 1 | `4-methodology.tex` ~66 | State near- and far-clip values for 3DGS rendering and review justification |
| 2 | `4-methodology.tex` ~79 | Clarify which FoundationStereo checkpoint is used; confirm zero-shot vs fine-tuned (OQ4) |
| 3 | `4-methodology.tex` ~81 | Review justification for 0.7 downscale factor against ZED Mini resolution |
| 4 | `4-methodology.tex` ~90 | Review justification for $z_\mathrm{far} = 1.0$\,m against deployment geometry |
| 5 | `4-methodology.tex` ~143 | Review morphological closing parameters (voxel size 0.02 m, radius 0.005 m) |
| 6 | `4-methodology.tex` ~147 | Review DBSCAN parameters ($\varepsilon = 0.05$\,m, $m_\mathrm{min} = 200$) |
| 7 | `4-methodology.tex` ~151 | Review voxel density filter parameters (0.02 m, 20 points) |
| 8 | `4-methodology.tex` ~155 | Review whether 600,000-point input cap is the tightest practical bound |
| 9 | `4-methodology.tex` ~178 | Verify all stereo parameter values in Table 4.2 |
| 10 | `4-methodology.tex` ~192 | State the commanded scan accumulation interval and clarify motion compensation |
| 11 | `4-methodology.tex` ~202 | Verify sensor mounting height (0.88 m) against hardware specification |
| 12 | `4-methodology.tex` ~204 | Review Patchwork++ distance threshold (0.125 m) against terrain roughness |
| 13 | `4-methodology.tex` ~206 | Review seed threshold (0.5 m) justification |
| 14 | `4-methodology.tex` ~226 | Review SOR parameters ($k=16$, $\lambda=2.0$) |
| 15 | `4-methodology.tex` ~230 | Verify angular filter direction and sensor mounting orientation |
| 16 | `4-methodology.tex` ~234 | Review radial outlier parameters (radius 0.05 m, min 30) |
| 17 | `4-methodology.tex` ~238 | Review normal-filter parameters ($k=75$, $100^{\circ}$) |
| 18 | `4-methodology.tex` ~241 | Review normal-smoothing parameters ($k=30$, $25^{\circ}$) |
| 19 | `4-methodology.tex` ~276 | Verify all LiDAR parameter values in Table 4.3 |
| 20 | `4-methodology.tex` ~289 | Describe candidate viewpoint sampling strategy (OQ1) |
| 21 | `4-methodology.tex` ~324 | Review rationale for Cauchy kernel on LiDAR but not stereo (OQ2) |
| 22 | `4-methodology.tex` ~340–343 | Fill in missing ICP parameter values (max iterations, max correspondence distance, relative fitness/RMSE) in Table 4.3 |
| 23 | `4-methodology.tex` ~347 | Verify all ICP parameter values |

---

## 7. Minor Suggestions (Non-Blocking)

- **Section title** (`4-methodology.tex`, line 1): "Proposed Methods" is a generic title. A more informative alternative would be "Point Cloud Registration Pipeline" or "Precise-Alignment Pipeline". This mirrors a recommendation made for Chapter 3.
- **Consistency**: The chapter title uses "Precise Alignment" (two words, no hyphen) while the chapter label and body text consistently use "precise-alignment" (hyphenated compound modifier). Ensure the section title noun phrase and the compound adjective are distinguished correctly throughout (hyphenate only when used attributively before a noun).
- **Figure caption style**: Figure captions are well-written and self-contained — this is a strength. One minor inconsistency: some captions end with a period and others do not (e.g., `fig:pa-system-context` ends without a period while `fig:pa-dual-camera` and `fig:pa-trunk-segmentation` end with a period). Standardise to always ending with a period.

---

## 8. Summary of Priority Actions

| Priority | Action |
|----------|--------|
| **High** | Write Results, Discussion, and Summary sections |
| **High** | Fill in the four `\textit{TODO}` values in the ICP parameter table (Table 4.3) |
| **High** | Clarify whether the SfM step produces a *sparse* or *dense* point cloud (§4.1) |
| **Medium** | Fix malformed BibTeX author string for `pavoljozefsafarikuniversityinkosiceSynergisticUseLiDAR2025` |
| **Medium** | Resolve all 23 embedded TODO comments (§6) — at minimum, those affecting parameter tables |
| **Medium** | Fix subject-verb agreement: "each independently determines" (Related Work, ~line 61) |
| **Medium** | Define "expected surface orientation" in the normal-based filtering description |
| **Low** | Apply the language edits in §3 (sentence-level improvements) |
| **Low** | Standardise figure caption terminal punctuation |
