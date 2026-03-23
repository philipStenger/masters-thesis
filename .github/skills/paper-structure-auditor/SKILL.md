---
name: paper-structure-auditor
description: "Evaluates each thesis section against its prescribed structural template: abstract sentence-by-sentence, introduction paragraph-by-paragraph, background, methods/results, related work, and discussion/conclusion. Produces structured findings for Section 2 of the critique report."
model: claude-opus-4.6
---

# Skill: Paper Structure Auditor

## Purpose
Compare every major section of the thesis against its prescribed structural template from ML paper writing best practices. Identify missing elements, misplaced content, and structural weaknesses.

## Templates to Apply

**Before evaluating, read `./section_templates_reference.md` from this skill folder.** It provides a tick-box checklist table for every section type (abstract through conclusion). Using it as your comparison baseline prevents evaluation gaps and keeps the analysis systematic — tick off what is present in the thesis and flag missing or misplaced elements.

### Abstract
Evaluate sentence by sentence:
1. **Sentence 1**: Should situate the reader in the correct sub-field with an uncontroversially true statement.
2. **Sentence 2**: Should establish a need, unknown quantity, or problem — conveying motivation.
3. **Middle sentences**: Should state the crucial contribution and why it is exciting; must define any necessary jargon.
4. **Concrete metric**: Must include at least one concrete metric or result that shows results are real and substantial.
5. **Final 1–2 sentences**: Should remind the reader why the paper matters, its implications, and how it fits the broader context.

### Introduction
Evaluate paragraph by paragraph:
1. **Para 1 — Context**: Topic, key motivating question, why it matters.
2. **Para 2 — Technical background**: What is known about this problem; what established techniques the paper rests on.
3. **Para 3 — Key contribution**: The main claim with nuance, detail, and context.
4. **Para 3.5 (optional but ideal) — Evidence summary**: The most critical supporting evidence for the main claim.
5. **Para 4 — Impact**: Takeaways, implications, why this is a big deal.
6. **Contributions list**: Should end with a bullet-point list — concise claim descriptions with brief references to supporting evidence.

### Background
- Explains all concepts and prior work required to understand the method.
- Includes a Problem Setting subsection with a formal problem definition and notation.
- Does not over-explain widely known facts, but errs toward defining specialised terms — readers have less context than the author.

### Methods and Results
- Communicates at multiple levels of abstraction: big picture and fine technical detail.
- Explains what results are and how to interpret them.
- Describes experiments in full, reproducible detail.
- Justifies why each experimental choice was reasonable and relevant to the claims.
- Specifies all technical choices and their implications.

### Related Work
- Compares and contrasts — does not merely describe what another paper does.
- Explains how each cited approach differs in assumptions or method from this work.
- Where another method is applicable to this problem setting: either includes an experimental comparison, or explicitly states why comparison is infeasible.

### Discussion / Conclusion
- Explains limitations of the work clearly (crucial for scientific credibility).
- Discusses broader implications, general takeaways, and future work.
- Contains material that could not fit in the introduction because it required the full context of the paper.

---

## Output Format

```
[2.N] PRIORITY: HIGH | MEDIUM | LOW
Location: <file path> — section "<heading>" — near: "<≤20-word quote>"
Guideline: <one-sentence statement of the structural rule violated>
Problem: <2–5 sentences: what element is missing or misplaced and why it matters>
Fix:
  1. <Concrete instruction>
  2. <Additional step if needed>
```

Number issues 2.1, 2.2, 2.3, etc.
