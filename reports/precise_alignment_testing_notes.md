-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Neighbourhood-Search LiDAR ICP Evaluation Framework

Overview

The framework provides a systematic evaluation of Generalised Iterative Closest Point (GICP) localisation for a LiDAR sensor against a 3D Gaussian Splatting (3DGS) scene reconstruction.
For each capture in a dataset of labelled lidar job folders, the algorithm runs GICP not once but across a structured set of 35 initial pose hypotheses — one nominal pose plus 34
perturbations organised into five groups — thereby characterising the sensitivity of ICP convergence to initialisation error in all six degrees of freedom.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. Target Point Cloud Construction

A single reference point cloud is built once at the start of a batch run and shared across all jobs. It is derived from a trained 3DGS model by extracting the Gaussian means (splat
centres) and applying a spatial crop that removes returns beyond a configurable far distance and inside a near-clip radius. The resulting cloud is optionally voxel-downsampled to a
uniform density. This target cloud represents the scene geometry against which all LiDAR scans are registered.


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

2. Initial Transform 

initial transform was measured by human.

job┌───────┬──────────┬───────┬───────────────────┬────────────────────────────────────────────────┐
│ Trial │ Distance │ Angle │ Label             │ Purpose                                        │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 1     │ 40 cm    │ −15°  │ Close / Left      │ Near-field oblique                             │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 2     │ 40 cm    │ 0°    │ Close / Frontal   │ Near-field baseline                            │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 3     │ 40 cm    │ +15°  │ Close / Right     │ Near-field oblique (symmetry check vs Trial 1) │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 4     │ 60 cm    │ −15°  │ Nominal / Left    │ Nominal oblique                                │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 5     │ 60 cm    │ 0°    │ Nominal / Frontal │ Centre point — primary operating condition     │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 6     │ 60 cm    │ +15°  │ Nominal / Right   │ Nominal oblique (symmetry check vs Trial 4)    │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 7     │ 80 cm    │ −15°  │ Far / Left        │ Far-field oblique                              │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 8     │ 80 cm    │ 0°    │ Far / Frontal     │ Far-field baseline                             │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 9     │ 80 cm    │ +15°  │ Far / Right       │ Far-field oblique (symmetry check vs Trial 7)  │
├───────┼──────────┼───────┼───────────────────┼────────────────────────────────────────────────┤
│ 10    │ 60 cm    │ 0°    │ Nominal / Frontal │ Centre replicate — repeatability estimate      │
└───────┴──────────┴───────┴───────────────────┴────────────────────────────────────────────────┘


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

3. Neighbourhood Transform Generation

The core contribution of the framework is the generation of 34 perturbed initial transforms around T₀, producing 35 hypotheses in total. All perturbations are constructed as a
local-frame delta matrix Δ ∈ SE(3) and applied by right-multiplication:

 Tᵢ = T₀ · Δᵢ

Right-multiplication applies Δ in the sensor's own coordinate frame, ensuring that a translational perturbation of magnitude δt produces a Euclidean displacement of exactly δt metres
regardless of the sensor's position in the scene (in contrast to left-multiplication, which would rotate about the world origin and produce displacement proportional to the sensor's
distance from that origin).

The 34 perturbations are divided into five groups, each targeting a different aspect of the six-degree-of-freedom pose space:

Group A — Inner translational shell (6 perturbations)

Six perturbations of magnitude δt/2 (default: 5 cm) along each of the three local Cartesian axes in both directions: ±X, ±Y, ±Z. These represent small close-range position errors and
provide a finer sampling of the immediate neighbourhood of T₀.

Group B — Outer XY cardinal (4 perturbations)

Four perturbations of magnitude δt (default: 10 cm) aligned with the cardinal directions of the local horizontal plane: North (+X), East (+Y), South (−X), West (−Y). No rotation is
applied. These probe pure lateral and forward/backward translation at the full neighbourhood radius.

Group C — Outer XY diagonal (4 perturbations)

Four perturbations at the four diagonal compass headings (NE, SE, SW, NW) in the local XY plane, with each component scaled by δt/√2 so that the Euclidean displacement remains exactly
δt. No rotation is applied. Together with Group B, Groups B and C provide uniform 8-point coverage of the horizontal plane at the outer radius.

Group D — Outer cardinal with coupled yaw (8 perturbations)

Each of the four cardinal translations (Group B) is paired with both signs of a yaw rotation (±δr, default: ±10°), yielding eight perturbations. Yaw is constructed as a rotation about
the sensor's local Z-axis using a standard 2D rotation matrix. This group targets the practically important failure mode in which both the horizontal position and the heading of the
sensor are simultaneously in error — a common situation when a photogrammetric initial estimate has combined translation and angular uncertainty.

Group E — Pure rotation, two bands (12 perturbations)

Twelve rotation-only perturbations (no translation) covering all three Euler axes at two magnitudes:

 - Inner band (δr/2 = 5°): ±yaw, ±pitch, ±roll — 6 perturbations
 - Outer band (δr = 10°): ±yaw, ±pitch, ±roll — 6 perturbations

Rotations are constructed using ZYX Euler convention (R = Rz · Ry · Rx) applied individually per axis. This group isolates the effect of angular initialisation error from position error,
and the two-band structure allows the framework to distinguish whether ICP is sensitive to small (5°) vs. large (10°) angular offsets.

Summary:

┌───────┬───────────────────────────────────────────┬──────┬──────────┬────────┐
│ Group │ Description                               │ Δt   │ Δr       │ Count  │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│ A     │ Inner shell, translation only             │ δt/2 │ 0        │ 6      │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│ B     │ Outer cardinal, translation only          │ δt   │ 0        │ 4      │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│ C     │ Outer diagonal, translation only          │ δt   │ 0        │ 4      │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│ D     │ Outer cardinal + yaw                      │ δt   │ ±δr      │ 8      │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│ E     │ Rotation only (yaw/pitch/roll), two bands │ 0    │ δr/2, δr │ 12     │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│ —     │ Original (nominal pose)                   │ —    │ —        │ 1      │
├───────┼───────────────────────────────────────────┼──────┼──────────┼────────┤
│       │ Total                                     │      │          │ 35     │
└───────┴───────────────────────────────────────────┴──────┴──────────┴────────┘

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

4. GICP Registration

For each of the 35 trial transforms, GICP is run using Open3D's registration_generalized_icp. The source cloud (processed LiDAR scan) is first transformed into the scene frame by the
trial initial transform, then surface normals are estimated on both source and target using a hybrid KD-tree search. A configurable robust loss function (default: L2) is applied within
the point-to-plane generalised ICP objective.

Convergence is governed by three criteria: maximum iteration count, relative fitness change, and relative RMSE change between successive iterations. An optional rotation-constrained
variant (--constrain-rotation) iteratively applies GICP and rejects solutions that deviate beyond a configurable pitch/roll limit, re-seeding from the previous accepted pose until
convergence.

Two primary metrics are recorded per trial:

 - Fitness: the fraction of source points that have a correspondence in the target within the maximum correspondence distance. A threshold of
  0.8 is used as the convergence criterion.
 - Inlier RMSE: the root-mean-square point-to-point distance over all inlier correspondences.

The final pose is decomposed into ZYX Euler angles and recorded alongside the raw 4×4 transformation matrix.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

5. Output and Analysis

Results for all 35 trials across all jobs are serialised to a JSON file, written incrementally after each job completes so that a partial run is not lost. An optional CSV export provides
a flat summary. The best-performing trial (by fitness) per job is surfaced at the top level of the JSON record for compatibility with downstream tooling.

The companion analysis script (analyse_icp_neighbourhood_results.py) reads this JSON and produces three figures:

 - A best-trial bar chart comparing original vs. best-neighbourhood fitness and RMSE per job.
 - A fitness/RMSE heatmap with rows sorted by group (A→E) and columns per job, with the best trial per job highlighted.
 - A group summary line chart showing the best fitness and RMSE achieved within each perturbation group per job, enabling direct comparison of how ICP convergence varies with
perturbation type and magnitude.