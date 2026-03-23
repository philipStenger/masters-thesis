# Claims Analysis Worksheet

Use this worksheet as an intermediate analysis step **before writing findings** for the `narrative-claims-auditor` skill.
Work through each section to systematically extract and evaluate the thesis's claims.

---

## Step 1 — Extract the Claims

Read the abstract, introduction (especially contributions list), and chapter introductions.
List every concrete claim you can identify:

```
Claim 1: <State the claim in one sentence, as precisely as possible>
  - Source location: <file>:<section>
  - Claim type: existence-proof | systematic | hedged | narrow | guarantee
  - Explicitly stated? YES / NO / PARTIALLY
  - Evidence cited in the claim statement? YES / NO

Claim 2: <...>
  (add as many as found)
```

---

## Step 2 — Evaluate Each Claim

For each claim identified above, answer these questions:

```
Claim [N]:

  Is the claim concrete and specific?
  → YES / NO — if no: <what is vague or abstract about it?>

  Is the calibration appropriate for the evidence?
  → The evidence supports: existence-proof | systematic | hedged | narrow | guarantee
  → The paper claims:      existence-proof | systematic | hedged | narrow | guarantee
  → Mismatch? <describe if yes>

  Is there compelling evidence for this claim?
  → YES / NO / PARTIAL — <which experiment/result supports it most strongly?>

  Does everything in the paper serve this claim?
  → YES / NO — <list any sections or content that seem unrelated>
```

---

## Step 3 — Evaluate Motivation and Context

```
  Is there a clear answer to "why should anyone care?"
  → YES / NO — Location of best answer: <file>:<section>
  → If no: what is missing?

  Is the work situated in the existing literature?
  → YES / NO — Key related works cited: <list 2–3>
  → Are differences from prior work explained, or just listed?

  Is novelty made explicit?
  → YES / NO — Where? <file>:<section>
  → What is stated as new vs. what is prior art?
```

---

## Step 4 — Evaluate Foregrounding

```
  What is the single most exciting result in the thesis?
  → <describe it>
  → Is it visible in the abstract? YES / NO
  → Is it visible in the introduction? YES / NO
  → Is it in the contributions list? YES / NO

  What was hard about this work that others have not done?
  → <describe it>
  → Is this difficulty communicated to the reader? YES / NO / PARTIALLY
  → Where? <file>:<section>
```

---

## Step 5 — Synthesise Findings

Based on the above analysis, list the narrative and claims issues to report:

```
ISSUE 1.1:
  Problem:
  Evidence:
  Priority: HIGH | MEDIUM | LOW

ISSUE 1.2:
  ...
```

Carry these forward as findings 1.1, 1.2, ... in the critique report.
