# Evidence Review Checklist

Apply this checklist to **each distinct experiment or evaluation** reported in the thesis.
Identify the experiments first (one checklist entry per experiment), then work through each criterion.

---

## Experiment Identification

Before filling in checklists, list every experiment/evaluation in the thesis:

```
Experiment 1: <Name or description>
  - File/section: <location>
  - What is being measured: <metric(s)>
  - What claim does this support: <Claim N from claims_analysis_worksheet>

Experiment 2: <...>
```

---

## Per-Experiment Checklist Template

```
Experiment: <name>
Location: <file>:<section>
Claim it supports: <Claim N>

EXPERIMENTAL DESIGN
  [ ] The experiment distinguishes between the main hypothesis and plausible alternatives
  [ ] Results would differ meaningfully if the hypothesis were false
  [ ] This is a "hard to deny" result (not just marginal evidence)
  [ ] Lines of evidence are qualitatively different from other experiments
      (diverse evidence is more robust than many similar experiments)

BASELINES
  [ ] A meaningful baseline is included (not just absolute results)
  [ ] Baseline(s) represent plausible alternatives a sceptic would expect
  [ ] Baselines are properly optimised (hyperparameters tuned, not straw-manned)
  [ ] There is no sign that more effort was invested in the proposed method than in baselines

STATISTICAL RIGOUR
  [ ] Sample size is reported
  [ ] Variance / standard deviation is reported
  [ ] Results are clearly above noise (not borderline)
  [ ] p-values are reported where applicable
  [ ] p-value threshold is appropriate (p < 0.001 for exploratory work; p < 0.05 is insufficient)
  [ ] Confidence intervals are included where relevant

REPRODUCIBILITY
  [ ] All hyperparameters and configuration details are specified
  [ ] Dataset details (size, split, provenance) are described
  [ ] Implementation is available or sufficient detail is given to re-implement

PRE- vs POST-HOC
  [ ] It is clear whether this experiment was designed before or after the claim was formulated
  [ ] No cherry-picking: examples / cases were not selected post-hoc to support the narrative

ISSUES FOUND:
  -
```

---

## Cross-Experiment Summary

After completing all per-experiment checklists, answer:

| Question | Answer |
|----------|--------|
| Is there at least one "hard to deny", compelling experiment? | |
| Are there qualitatively different lines of evidence converging on the same conclusion? | |
| Are all claims supported by at least one experiment? | |
| Are there claims with NO experimental support at all? | |
| Are limitations of the experimental scope discussed? | |

---

## Carry Forward to Report

Based on the above checklists, list evidence quality issues to report as 3.1, 3.2, ...:

```
ISSUE 3.1:
  Experiment: <name>
  Problem:
  Priority: HIGH | MEDIUM | LOW

ISSUE 3.2:
  ...
```
