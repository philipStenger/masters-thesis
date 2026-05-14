Graduated ICP: Huber → Cauchy

The Core Idea

Standard ICP picks one robust loss for the entire run. The graduated approach recognises that the two jobs of ICP — pulling the clouds together and locking in precise alignment — have
conflicting requirements, so it splits them across two phases with different loss functions.

---

Robust Loss Functions: Background

In GICP, each point correspondence contributes a residual r (the point-to-plane distance). The optimizer minimises Σ ρ(r). A standard L2 loss (ρ(r) = r²) is dominated by large residuals,
so outlier correspondences (noisy edge points, thin-structure edges) drag the solution off.

Robust losses down-weight large residuals. The key difference is how aggressively they do so:

┌───────────────┬──────────────────────────────┬───────────────────────┬──────────────────────────────────┐
│ Loss          │ ρ(r)                         │ Behaviour for large r │ Effect                           │
├───────────────┼──────────────────────────────┼───────────────────────┼──────────────────────────────────┤
│ L2 (standard) │ r²                           │ Grows unbounded       │ Outliers dominate                │
├───────────────┼──────────────────────────────┼───────────────────────┼──────────────────────────────────┤
│ Huber         │ ½r² if |r|≤k, else k(|r|−½k) │ Linear beyond k       │ Soft — outliers still contribute │
├───────────────┼──────────────────────────────┼───────────────────────┼──────────────────────────────────┤
│ Cauchy        │ k²/2 · ln(1 + (r/k)²)        │ Grows logarithmically │ Hard — outliers nearly ignored   │
└───────────────┴──────────────────────────────┴───────────────────────┴──────────────────────────────────┘

The parameter k is the threshold that separates inlier from outlier behaviour. Smaller k = more aggressive rejection.

---

Phase 1 — Huber (Broad Alignment)

- -phase1-k 1.5 # threshold in point-to-plane distance units
--phase1-iters 30 # max iterations

Why Huber first:
The Huber loss is soft. Even correspondences with residuals larger than k still contribute — they're down-weighted but not rejected. This is important early on because:

- The scans are not yet aligned, so most correspondences have large residuals
- Thin structures (branches, wires) produce sparse, noisy correspondences — you want the optimizer to "feel" them even weakly so they pull the clouds together
- A large k (e.g.
1.5–2.0) means the transition from quadratic to linear happens late, keeping more correspondences in play

The risk is that the final solution is still contaminated by noisy outliers — hence phase 2.

---

Phase 2 — Cauchy (Precision Refinement)

- -phase2-loss CAUCHY # alternatives: TUKEY, GML, HUBER (with smaller k)
--phase2-k 0.5 # much smaller threshold than phase 1
--phase2-iters 20 # max iterations

Why Cauchy second:
The Cauchy loss is hard. Its weight function w(r) = 1 / (1 + (r/k)²) drops rapidly to near-zero for large residuals. After phase 1 has brought the clouds close, the remaining large
residuals are genuinely bad correspondences (edge noise, thin-structure ambiguity). Cauchy lets the optimizer reject them and focus on the clean inlier set.

The small k (e.g. 0.5) means even moderate residuals (~1.5× k) are strongly down-weighted, locking the solution tightly around the dense, reliable correspondences.

Handoff between phases:
In the unconstrained path, the phase 1 result transform is passed directly as the initial estimate to phase 2 (Open3D's init argument). In the constrained path (--constrain-rotation),
the phase 1 transform is applied to the source cloud in-place before phase 2 runs, preserving the pitch/roll clamping logic across both phases.

Graduated ICP + Rotation Constraints: Full Detail

What --constrain-rotation does

Open3D's GICP has no built-in rotation constraint. The constraint is implemented by replacing Open3D's internal loop with our own, running one GICP step at a time and surgically
modifying the rotation matrix after each step.

The function is _constrained_gicp_loop. Here is exactly what happens per iteration:

1. Apply accumulated correction T_accum to the original source points → source_now
2. Run ONE step of GICP: registration_generalized_icp(..., max_iteration=1, ...)
→ returns delta_T (the tiny step transform)
3. Compose: T_accum = delta_T @ T_accum
4. Decompose T_accum rotation into ZYX Euler angles (yaw, pitch, roll)
5. Clamp: pitch = clip(pitch, -max_pitch_roll_deg, +max_pitch_roll_deg)
roll = clip(roll, -max_pitch_roll_deg, +max_pitch_roll_deg)
6. Recompose the clamped angles back into a rotation matrix → write into T_accum
7. Check convergence; repeat

Key design choices:

- Clamping is on T_accum (the correction relative to the initial transform), not the absolute pose. So if the initial pose already has pitch=20°, that 20° is preserved — only the
ICP-introduced change is constrained.
- Yaw and all translation components are completely unconstrained — only pitch and roll are clamped.
- The clamping is applied after the step and before the next step uses the corrected position, so it actively steers the optimizer away from impossible rotations at every iteration.

---

Parameters

- -constrain-rotation # flag — enables the constrained loop
--max-pitch-roll-deg 5.0 # clamp limit in degrees, applied symmetrically ±

The convergence criteria inside the constrained loop are the same shared args:

- -relative-fitness 1e-6 # exit if fitness improvement < this between steps
--relative-rmse 1e-6 # exit if RMSE improvement < this between steps

But note: these are actually not used in the single-step call — the single_step criteria are hardcoded to relative_fitness=0.0, relative_rmse=0.0 to force exactly one step per call. The
convergence check is instead done manually:

if delta_rot_deg < 0.01°  AND  delta_trans < 1e-4 m:
converged → break

There's also an early-exit if fitness == 0 for 3 consecutive iterations (no correspondences found).

---

How Graduated + Constrained Interact

This is where it gets nuanced. The two phases are run as two entirely separate calls to _constrained_gicp_loop, with a manual handoff between them:

Phase 1 (Huber k=1.5, max_iter=30, constrained):
└── runs _constrained_gicp_loop → returns T_p1

```
               ↓  handoff
```

_advance_source(source_pcd, T_p1)
└── applies T_p1 to the original source points & normals
→ produces source_p2 (a new PointCloud at the phase-1-converged position)

Phase 2 (Cauchy k=0.5, max_iter=20, constrained):
└── runs _constrained_gicp_loop(source_p2, ...) → returns T_p2

Final correction:  T_icp = T_p2 @ T_p1

Why _advance_source instead of just passing T_p1 as init?

The constrained loop always starts its own T_accum at identity (eye(4)). It corrects relative to whatever source cloud it's handed. So to continue from where phase 1 left off, we must
bake T_p1 into the actual point positions before calling phase 2 — otherwise phase 2 would start from the uncorrected position.

What this means for the constraint:

Each phase's clamping is relative to that phase's starting position:

- Phase 1 clamps any pitch/roll correction beyond ±max_pitch_roll_deg relative to the initial pose
- Phase 2 clamps any pitch/roll correction beyond ±max_pitch_roll_deg relative to the phase-1-converged pose

In practice, phase 2 is a small refinement, so its correction is tiny and the clamp rarely triggers. The constraint does real work in phase 1.

---

Contrast: unconstrained graduated path

Without --constrain-rotation, both phases use Open3D's native loop:

Phase 1:  registration_generalized_icp(..., init=eye(4), ...)  → result1
Phase 2:  registration_generalized_icp(..., init=result1.transformation, ...)  → result2
T_icp = result2.transformation   # single combined matrix from Open3D

Here the handoff is clean — Open3D carries the phase-1 transform directly as init to phase 2, no manual point manipulation needed. But there is no per-iteration rotation clamping.

---

Complete parameter set for constrained graduated ICP

python batch_lidar_icp_neighbourhood.py \

# ── Enable both features ──────────────────────────────────────

- -graduated-icp \
--constrain-rotation \

# ── Rotation constraint ───────────────────────────────────────

- -max-pitch-roll-deg 5.0 \ # clamp ±5° on pitch and roll of the ICP correction
# yaw is free; initial pitch/roll are unaffected

# ── Phase 1: Huber (broad, constrained) ──────────────────────

- -phase1-k 1.5 \ # Huber threshold — large so thin structures contribute
--phase1-iters 30 \ # max 30 single-step constrained iterations

# ── Phase 2: Cauchy (precision, constrained) ─────────────────

- -phase2-loss CAUCHY \ # hard outlier rejection
--phase2-k 0.5 \ # small threshold — rejects noisy edge correspondences
--phase2-iters 20 \ # max 20 single-step constrained iterations

# ── Shared / correspondence ───────────────────────────────────

- -max-correspondence-distance 0.15 \ # max point-pair distance for valid correspondence (m)
--relative-fitness 1e-6 \ # (used in unconstrained path only)
--relative-rmse 1e-6 # (used in unconstrained path only)