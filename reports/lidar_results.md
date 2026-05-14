LiDAR ICP Registration Results
Generated: 2026-05-10 14:32
Primary results use the graduated ICP variant (Phase 1: Huber k=1.5, 30 iters → Phase 2: Cauchy k=0.5, 20 iters). Huber-only baseline results are included
in Section 8 for comparison.
Jobs: 7
Perturbation hypotheses per job: 35
Convergence threshold: fitness ≥ 0.8
Point-cloud processing: voxel downsampling + SOR outlier removal + normal-angle filtering

1. Per-Job Registration SummaryJob Raw pts Proc pts n hyp n accepted Accept % Median fit IQR fit Median RMSE
IQR RMSE
Best trial Best fitness Best RMSE (mm)(mm) (mm)lidar_job
4,422,405 349,663 35 0 0% 0.4020 0.0005 46.45 0.25 oN 0.4031 46.2202lidar_job
4,524,584 116,892 35 35 100% 0.9205 0.0000 34.93 0.68 oE_rm 0.9247 36.2703lidar_job
4,582,455 108,707 35 35 100% 0.9174 0.0000 33.25 0.00 original 0.9174 33.2504lidar_job
4,588,803 121,350 35 32 91% 0.9277 0.0000 24.41 0.00 original 0.9277 24.4105lidar_job
4,548,700 112,312 35 34 97% 0.9107 0.0059 34.77 1.72 original 0.9107 35.1706lidar_job
4,363,844 97,358 35 35 100% 0.8939 0.0079 32.30 2.36 original 0.9018 34.6407lidar_job
4,587,006 116,750 35 35 100% 0.9141 0.0001 23.38 0.02 oS_rm 0.9143 23.4108
Aggregate across all jobs: 206/245 hypotheses accepted (84.1%); median fitness=0.9141, IQR=0.0266; median RMSE=33.25 mm, IQR=10.54 mm
2. Per-Perturbation-Group Breakdown
Trials are grouped by perturbation type applied to the initial transform.Group Description n hyp n accepted Accept % Median fitness IQR fitness Median RMSE (mm) IQR RMSE (mm)orig Original init transform 7 6 86% 0.9142 0.0127 34.64 6.22A Inner shell (1⁄2δt, no rot) — ±X/Y/Z 5 cm 42 36 86% 0.9141 0.0187 33.25 10.52B Outer cardinal XY (δt, no rot) — N/E/S/W 10 cm 28 24 86% 0.9141 0.0187 33.25 10.52C Outer diagonal XY + yaw (δt ±δr) — NE/SE/SW
84 69 82% 0.9107 0.0246 33.25 7.35NW + yawE Roll / pitch / yaw sweeps (1⁄2δr and δr) 84 71 85% 0.9141 0.0266 33.25 10.54
Key observation: Groups are compared across all jobs; a higher acceptance rate in a group indicates that those perturbation directions are more tolerant
of initial pose error.
3. Recovered Transformation Components (Accepted Hypotheses)
Statistics computed over all hypotheses with fitness ≥ 0.8 within each job.
3a. Translation (metres)Job n acc tx median tx IQR ty median ty IQR tz median tz IQRlidar_job_02 0 — — — — — —lidar_job_03 35 -26.0111 0.0001 15.5155 0.0000 1.1255 0.0003lidar_job_04 35 -26.1081 0.0000 15.3781 0.0000 1.1239 0.0000lidar_job_05 32 -26.1926 0.0000 15.2737 0.0000 1.1437 0.0000lidar_job_06 34 -26.0556 0.0038 15.4496 0.0001 1.1409 0.0090lidar_job_07 35 -26.0832 0.0029 15.5395 0.0106 1.1273 0.0072lidar_job_08 35 -26.2030 0.0006 15.1342 0.0006 1.1096 0.0020
3b. Euler Angles — ZYX convention (degrees)Job n acc Yaw med Yaw IQR Pitch med Pitch IQR Roll med Roll IQRlidar_job_02 0 — — — — — —lidar_job_03 35 146.652 0.007 -0.209 0.016 36.418 0.040lidar_job_04 35 147.380 0.004 -0.644 0.003 35.021 0.002lidar_job_05 32 147.819 0.001 3.993 0.003 36.363 0.001lidar_job_06 34 146.473 0.177 1.185 0.939 37.932 1.780lidar_job_07 35 138.447 0.245 1.707 1.847 36.531 1.553lidar_job_08 35 153.315 0.033 2.317 0.203 35.518 0.207
4. Consistency Analyses4a. Within-Job Perturbation Convergence Consistency
Standard deviation of recovered pose across accepted hypotheses within each job. Low std = multiple starting points converge to the same pose (high
confidence).Job n acc σ tx (m) σ ty (m) σ tz (m) σ yaw (°) σ pitch (°) σ roll (°)lidar_job_02 0 n/a n/a n/a n/a n/a n/alidar_job_03 35 0.02409 0.00502 0.00564 0.9732 1.4458 3.4344lidar_job_04 35 0.13170 0.07724 0.01451 0.2450 1.1905 0.4803lidar_job_05 32 0.00001 0.00001 0.00002 0.0010 0.0020 0.0008lidar_job_06 34 0.00258 0.00345 0.00443 0.1141 0.9954 1.1811lidar_job_07 35 0.00226 0.01014 0.02470 1.0796 2.2601 4.0232lidar_job_08 35 0.07235 0.00431 0.08887 0.5746 1.5670 6.5872
4b. Inter-Job Consistency
Variation of the best-trial metrics across jobs (excluding non-converging jobs for fitness stats).
Converging jobs: 6/7
Best-trial fitness : mean=0.9161, std=0.0086, min=0.9018, max=0.9277
Best-trial RMSE : mean=31.19 mm, std=5.23 mm, min=23.41 mm, max=36.27 mm
Non-converging jobs: [‘lidar_job_02’] — best fitness [‘0.4031’]
4c. Replicate Pair Repeatability
Condition labels (D40/D60/D80 × A-15/A0/A15) were not mapped to job folders at the time of analysis. The replicate pair (D60A0 vs D60A0r) repeatability
check should be revisited once the job → condition mapping is established.
5. Timing Results
All times in seconds. ICP s/trial = mean elapsed ICP time per perturbation hypothesis.Job Preprocessing (s) Total ICP (s) ICP s/trial Total pipeline (s)lidar_job_02 2.44 54.8 1.57 75.9lidar_job_03 0.76 37.0 1.06 50.9lidar_job_04 0.70 36.3 1.04 50.0lidar_job_05 0.80 32.6 0.93 46.8lidar_job_06 0.71 34.4 0.98 48.1lidar_job_07 0.63 34.2 0.98 48.0lidar_job_08 0.75 34.1 0.98 48.0
Summary: - Preprocessing : mean=0.97 s ± 0.60 s - ICP per trial : mean=1.08 s ± 0.20 s - Total pipeline: mean=52.5 s ± 9.6 s
6. Cross-Job Trends
Jobs ordered by folder index (condition labels pending). Fitness and RMSE for the original-init trial and best neighbourhood trial are shown.Job Orig fitness Orig RMSE (mm) Best fitness Best RMSE (mm) Δ fitness Δ RMSE (mm)lidar_job_02 0.4022 46.38 0.4031 46.22 0.0009 -0.16lidar_job_03 0.9205 34.93 0.9247 36.27 0.0042 1.34lidar_job_04 0.9174 33.25 0.9174 33.25 0.0000 0.00lidar_job_05 0.9277 24.41 0.9277 24.41 0.0000 0.00lidar_job_06 0.9107 35.17 0.9107 35.17 0.0000 0.00lidar_job_07 0.9018 34.64 0.9018 34.64 0.0000 0.00lidar_job_08 0.9142 23.40 0.9143 23.41 0.0000 0.01
Δ fitness / Δ RMSE = best neighbourhood trial minus original-init trial. Positive Δ fitness means the neighbourhood search improved alignment; negative
Δ RMSE means tighter inlier spread.
7. Qualitative Visual Overlays
Point-cloud visual overlays (registered source cloud vs. target cloud) are not included in this document. To generate them, re-run the batch script with -
save-processed-dir to export processed source clouds, then load alongside the 3DGS target cloud in Open3D and apply each job’s
final_transform. The neighbourhood viewpoint renders produced during the batch run are saved as lidar_job_*_viewpoints.png in the data
directory.
8. Comparison: Huber Baseline vs. Graduated ICP (Huber → Cauchy)Job Huber best fit Grad best fit Huber best RMSE (mm) Grad best RMSE (mm) RMSE Δ (mm)lidar_job_02 0.4033 0.4031 46.45 46.22 -0.23lidar_job_03 0.9240 0.9247 36.58 36.27 -0.31lidar_job_04 0.9177 0.9174 33.94 33.25 -0.69lidar_job_05 0.9277 0.9277 24.49 24.41 -0.08lidar_job_06 0.9107 0.9107 35.56 35.17 -0.39lidar_job_07lidar_job_08 0.9143 0.9143 23.36 23.41 0.05
Aggregate summary: | Metric | Huber | Graduated | Δ | |——–|——-|———–|—| | Mean best fitness | 0.8428 | 0.8428 | +0.0000 | | Mean best RMSE (mm) |
33.57 | 33.34 | -0.23 | | Jobs improved (RMSE)| — | 5/7 | — | | Mean orig fitness | 0.8424 | 0.8421 | -0.0003 | | Mean orig RMSE (mm) | 33.44 | 33.17 | -0.28 |
9. Notes & Limitations
Condition labels (D40/D60/D80, A-15/A0/A15) were not available at analysis time; per-condition trend analysis and replicate-pair repeatability
check are deferred.
lidar_job_02 did not converge (fitness < 0.8 across all hypotheses with either ICP variant).
Fitness metric is the fraction of source points within the max-correspondence-distance (0.15 m) of a target point after registration.
RMSE is the inlier root-mean-square point-to-point distance.
All Euler angles follow the ZYX (yaw-pitch-roll) convention.