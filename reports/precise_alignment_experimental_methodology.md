 1. Reframe the Experiment: Component-Level Modality Comparison

  The strongest framing is: this experiment is a controlled component-level evaluation of the ICP registration stage, isolating the sensing modality as
  the independent variable.

  In the full deployment pipeline, the SLAM system delivers a coarse initial pose and the precise-alignment module refines it. These two stages are
  architecturally independent — the ICP module consumes an initial SE(3) transform and a source point cloud, and it outputs a refined transform. It does
  not care how the initial pose was obtained. Your indoor experiment tests this module in isolation, which is standard practice in systems engineering:
  test components individually before integration.

  Frame it positively: the indoor controlled environment removes confounding variables (wind-induced vine motion, adjacent vine clutter, variable
  lighting, GNSS multipath) that would make it harder to isolate the effect of the sensing modality. You're not apologising for indoor testing — you're
  justifying it as the methodologically cleaner comparison.

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  2. Formalise the Initial Pose as a Simulated SLAM Estimate

  This is the critical methodological move. Don't describe it as "approximate measurements" — describe it as a synthetic initial pose designed to simulate
  SLAM-delivered accuracy.

  Procedure for each trial:

   1. Before each trial, measure the robot-to-vine distance with a tape measure and record the approach angle relative to the vine's facing direction.
   2. Construct an SE(3) transform from these measurements, placing the vine at a chosen local origin.
   3. Explicitly characterise your measurement uncertainty — e.g., tape measure ±3–5 cm in translation, protractor/visual estimation ±5–10° in heading.

  The key justification argument:

  From Chapter 3, GLIM-GNSS delivers:

   - ATE:
    0.07–0.17 m (typical positioning error)
   - Max single-point error:
    0.7–1.0 m (worst case)

  If your manual measurements introduce comparable or larger initial pose error (say ±10–30 cm translation, ±5–10° rotation), then your experiment is
  testing ICP convergence from a conservative (pessimistic) starting condition. If ICP converges reliably from these coarser initial guesses, it will
  certainly converge from the more accurate SLAM-delivered poses in deployment.

  You should also consider deliberately adding extra noise to a subset of trials during post-processing: take your best-estimate initial transform and
  perturb it by known amounts (e.g., +10 cm, +20 cm, +30 cm, +50 cm in translation; +5°, +10°, +15° in rotation). This gives you a convergence basin
  analysis — at what initial pose error does ICP fail? This is extremely valuable data and costs nothing because you already have the bag files.

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  3. Ground Truth Strategy

  This is your biggest methodological gap. You need to answer: how do you know the ICP result is correct? Here are your options, in order of strength:

  Option A — Cross-Modal Consistency (strongest available)

  Since each of the 8 trials captures LiDAR and stereo simultaneously from the same robot pose, both modalities should converge to the same rigid
  transform if both are correct. Compute the inter-modal transform discrepancy:

  $$\Delta T = T_{\text{stereo}}^{-1} \cdot T_{\text{LiDAR}}$$

  If $\Delta T$ is close to identity across all 8 trials, this provides strong evidence that both modalities are converging to the true solution rather
  than different local minima. Report the translation norm and rotation angle of $\Delta T$ for each trial.

  Option B — Inter-Trial Consistency

  All 8 trials observe the same static vine from different poses. If you express each ICP result as the recovered vine position in the robot frame (or
  equivalently, the robot position in the vine frame), the recovered vine geometry should be spatially consistent across trials. Large discrepancies
  between trials would indicate convergence failures.

  Option C — Qualitative Visual Inspection

  For each trial, render an overlay of the ICP-aligned source cloud on the 3DGS target cloud. Show these as figures. An examiner can visually assess
  whether the trunk structure is correctly aligned. This is standard practice in point cloud registration papers.

  Option D — Perturbation Convergence Consistency

  If you perturb the initial pose across a range of offsets (as suggested in §2) and ICP consistently converges to the same final transform, this is
  evidence of a single dominant basin of attraction — i.e., the correct solution.

  My recommendation: Use all four. A + D are your quantitative evidence, B is your consistency check, C provides visual confirmation for the reader.

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  4. Structure the 8 Trials as a Factorial-Style Design

  Categorise your 8 trials along two axes and present them in a table:

  ┌───────┬────────────────────┬─────────────────┬─────────────────┐
  │ Trial │ Distance (approx.) │ Angle (approx.) │ Category        │
  ├───────┼────────────────────┼─────────────────┼─────────────────┤
  │ 1     │ 0.5 m              │ ~0° (head-on)   │ Close / Frontal │
  ├───────┼────────────────────┼─────────────────┼─────────────────┤
  │ 2     │ 0.5 m              │ ~20°            │ Close / Oblique │
  ├───────┼────────────────────┼─────────────────┼─────────────────┤
  │ 3     │ 0.75 m             │ ~0°             │ Mid / Frontal   │
  ├───────┼────────────────────┼─────────────────┼─────────────────┤
  │ ...   │ ...                │ ...             │ ...             │
  └───────┴────────────────────┴─────────────────┴─────────────────┘

  This lets you discuss how distance and viewing angle affect registration quality for each modality. Even with 8 trials you can observe trends: does
  stereo degrade faster at oblique angles (due to trunk self-occlusion)? Does LiDAR maintain consistency at longer range (denser scan coverage)? This is
  where the modality comparison becomes interesting.

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  5. Define Your Evaluation Metrics Explicitly

  For each trial × each modality, report:

  ┌───────────────────────────────┬────────────────────────────────────────────────────────────────┐
  │ Metric                        │ Purpose                                                        │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ ICP fitness                   │ Fraction of inlier correspondences — measures overlap quality  │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ Point-to-point RMSE           │ Registration tightness after convergence                       │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ Iterations to convergence     │ Computational cost / convergence difficulty                    │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ Recovered SE(3) transform     │ The actual result — translation vector + rotation              │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ Cross-modal ΔT                │ Discrepancy between stereo and LiDAR results for same trial    │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ Source cloud point count      │ After preprocessing — characterises input quality per modality │
  ├───────────────────────────────┼────────────────────────────────────────────────────────────────┤
  │ Wall-clock time               │ End-to-end pipeline latency per modality                       │
  └───────────────────────────────┴────────────────────────────────────────────────────────────────┘

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  6. Address the Single-Vine Limitation Honestly

  In the discussion, acknowledge:

   - A single vine limits claims about generalisation across vine morphologies.
   - The indoor floor (flat, uniform) is geometrically simpler than vineyard soil for ground removal.
   - No adjacent vine clutter is present, which simplifies segmentation.

  But argue:

   - The registration pipeline is geometry-agnostic — ICP operates on whatever point cloud structure is presented. The single vine is a representative 
  instance, not a special case.
   - The controlled setting is necessary for a clean modality comparison. Field testing introduces too many confounders to isolate the sensing modality 
  effect.
   - Future work (Chapter 5) should validate on multiple vines in situ during an actual pruning season.

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  7. Coordinate Frame Setup for the Experiment

  Since you can't use the global ENU frame, define a local experiment frame:

   - Place the vine trunk base at the origin.
   - X-axis: perpendicular to the vine row (i.e., the direction the robot approaches from).
   - Z-axis: vertical (up).
   - All initial poses and ICP results are expressed in this local frame.

  In the thesis, explain that in deployment the local experiment frame would be replaced by the ENU-anchored global frame via the SLAM system, and the ICP
  registration result is a local relative correction that is frame-agnostic — it doesn't depend on which global frame is used.

  -------------------------------------------------------------------------------------------------------------------------------------------------------

  Summary of the Argument Structure

   "The precise-alignment pipeline is architecturally independent of the upstream SLAM system: it consumes an initial SE(3) pose and a sensor-derived 
  point
   cloud, and outputs a refined pose via ICP registration against a 3DGS reference model. This experiment evaluates the registration stage in isolation
   under controlled laboratory conditions, with manually measured initial poses that introduce translational uncertainty of ±X cm and rotational
   uncertainty of ±Y° — comparable to or exceeding the positioning error of the GLIM-GNSS system evaluated in Chapter 3 (ATE 0.07–0.17 m). If the pipeline
   converges reliably from these conservative initial estimates, it is expected to perform at least as well when initialised from the more accurate
   SLAM-delivered poses available in deployment."