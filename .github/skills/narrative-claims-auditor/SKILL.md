---
name: narrative-claims-auditor
description: "Evaluates the thesis narrative: whether 1–3 concrete claims are clearly stated, calibrated to evidence strength, properly motivated, situated in the literature, and sufficiently novel. Produces structured findings for Section 1 of the critique report."
model: claude-opus-4.6
---

# Skill: Narrative and Claims Auditor

## Purpose
Evaluate the overall narrative of the thesis against ML paper writing best practices. The thesis should present one to three specific, concrete claims supported by rigorous evidence. Everything else should serve that narrative.

## How to Use the Worksheet

**Before writing any findings, work through `./claims_analysis_worksheet.md` from this skill folder.** The worksheet structures your analysis into five sequential steps — extracting claims, evaluating calibration, assessing motivation, checking foregrounding, and synthesising findings. Working through it first prevents overlooking claims and ensures each 1.N finding is grounded in specific evidence rather than general impressions.

## What to Evaluate

### Claims
- Are there 1–3 clear, concrete claims? Are they explicitly stated anywhere (abstract, introduction, contributions list)?
- Is each claim calibrated to the strength of the available evidence? Classify each claim as: existence-proof, systematic, hedged, narrow, or guarantee — and judge whether the calibration is appropriate.
- Are stronger or more general claims backed by correspondingly stronger evidence?
- Do all sections serve the narrative? Is there content that does not support any claim?

### Motivation and Context
- Does the paper make clear why anyone should care about these claims? Is there a compelling answer to "so what?"
- Is the work clearly situated in the existing literature — not just cited, but contextualised?
- Is novelty explicit? Does the paper clearly distinguish what is new in this work from what is prior art?
- Are relevant prior papers cited and their differences from this work explained? Flag any obvious omissions.

### Foregrounding
- What are the one to three most exciting or important results? Are they prominently foregrounded — visible in the abstract, introduction, and contributions list?
- What was hard about this work that others have not done? Is that difficulty communicated to the reader?

---

## Output Format

Produce a numbered list of findings. Use this entry format for each issue:

```
[1.N] PRIORITY: HIGH | MEDIUM | LOW
Location: <file path> — section "<heading>" — near: "<≤20-word quote>"
Guideline: <one-sentence statement of the rule violated>
Problem: <2–5 sentences: what is wrong and why it matters>
Fix:
  1. <Concrete instruction, with suggested replacement text where helpful>
  2. <Additional step if needed>
```

If a narrative dimension is genuinely strong, note it in one sentence and move on — do not invent problems.

Number issues 1.1, 1.2, 1.3, etc.
