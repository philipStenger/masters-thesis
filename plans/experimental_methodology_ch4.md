# Plan: Update ICP Subsection + Write Experimental Setup (LiDAR)

Problem

The ICP Registration subsection (lines 278–346) describes an outdated approach (point-to-point ICP, per-viewpoint 3DGS rendering, N=5 candidates). The
actual system uses GICP, a single target cloud from Gaussian means, and 35 perturbation hypotheses. Additionally, there is no experimental setup section
describing the indoor test environment, trial design, or evaluation protocol.

Part A — Update \subsection{ICP Registration Against the 3DGS Model} (lines 278–346)

Changes needed:

 - [ ]  (a) Initial pose: keep as-is (SE(3) from SLAM or manual measurement)
 - [ ]  (b) Target cloud construction: replace per-viewpoint rendering with single target cloud built from Gaussian means (splat centres) + spatial 
cropping + optional voxel downsampling. Update \cref to reference model subsection. Remove candidate viewpoint rendering description.
 - [ ]  (c) Neighbourhood perturbation: replace N=5 candidate viewpoints with 35 perturbation hypotheses (1 nominal + 34 perturbations in Groups A–E). 
Describe right-multiplication convention. Add perturbation group summary table.
 - [ ]  (d) Downsampling: update to reflect that both source and the single target are downsampled
 - [ ]  (e) ICP → GICP: change from "point-to-point ICP" to "Generalised ICP (GICP)" using registration_generalized_icp. Update the ICP objective 
description. Note surface normal estimation (hybrid KD-tree).
 - [ ]  (f) Candidate selection: update to reflect selection across 35 hypotheses by fitness (threshold
  0.8)
 - [ ]  Table: update tab:pa-icp-params — remove "Candidate viewpoints (N) = 5", add perturbation parameters (δt, δr), change ICP backend to GICP, add 
fitness threshold
 - [ ]  Figure caption: update fig:pa-icp-candidates caption to match new perturbation approach (or mark as needing a new figure)
 - [ ]  LiDAR-Specific Robust Kernel: Cauchy kernel (k=0.15) confirmed still in use with GICP. Keep existing description, update only the ICP variant name (point-to-point → GICP).
 - [ ]  Reference model subsection: update \subsection{Reference Model: 3D Gaussian Splatting} (line 57) to describe Gaussian means extraction instead 
of per-viewpoint depth rendering

Part B — Add \subsection{Experimental Setup} (after line 412)

New subsection with the following content (LiDAR only for now):

 - [ ]  1. \subsubsection{Test Environment} — indoor lab, controlled conditions, justification (removes confounders), why outdoor not feasible (3DGS 
georeferenced to inaccessible car park → spatial mismatch in ENU frame)
 - [ ]  2. \subsubsection{Vine Specimen and Reference Model} — sourced dormant vine on physical frame, 3DGS from outdoor SfM, georeferencing constraint
 - [ ]  3. \subsubsection{Trial Design} — 3×3 factorial + 1 centre replicate = 10 trials. Factors: distance (40, 60, 80 cm) × angle (−15°, 0°, +15°). 
Table. Randomised order, settling time.
 - [ ]  4. \subsubsection{Initial Pose Construction} — manual measurement, SE(3) construction, uncertainty budget, comparison to GLIM-GNSS ATE 
(0.07–0.17 m), conservative-proxy argument
 - [ ]  5. \subsubsection{Evaluation Protocol} — 35 hypotheses per trial (cross-ref to perturbation protocol in updated ICP subsection), GICP 
convergence criteria, per-trial outputs (fitness, RMSE, SE(3), Euler angles), JSON serialisation
 - [ ]  6. \subsubsection{Evaluation Metrics and Validation} — fitness, inlier RMSE, per-group analysis, validation strategies (perturbation convergence
 consistency, inter-trial consistency, visual overlay). Cross-modal deferred to stereo section.

Execution Order

 1. Update Reference Model subsection (line 57–67)
 2. Update ICP Registration subsection (lines 278–346)
 3. Add Experimental Setup subsection (after line 412)
 4. Update closing paragraph (line 412)

Notes

 - LiDAR only; stereo experimental setup later
 - UK English throughout
 - \cref{} for cross-references
 - Only cite keys in MastersThesis.bib
 - Robust kernel: **RESOLVED** — Cauchy (k=0.15) confirmed for LiDAR GICP
 - All discrepancies now resolved: GICP ✓, single target cloud from Gaussian means ✓, 35 perturbations ✓, Cauchy kernel ✓