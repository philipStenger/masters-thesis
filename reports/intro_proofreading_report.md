# Proofreading Report — Chapter 1: Introduction

**Reviewed:** 2026-05-07  
**Resolved:** 2026-05-07  
**Scope:** `1-intro/` — `1-research-context.tex`, `1-motivation.tex`, `1-research-objectives.tex`, `1-thesis-structure.tex`

---

## Status Summary

All high- and medium-priority findings have been resolved. Two open questions remain for author decision. The TODO placeholders in contributions are deferred pending results chapters.

---

## High-Priority Findings

- ✅ **Wrong SLAM acronym expansion.**  
  `1-motivation.tex`, line 4.  
  Fixed: `localisation and mapping (SLAM)` → `Simultaneous Localisation and Mapping (SLAM)`.

- ✅ **Sentence subject cannot be a bottleneck.**  
  `1-motivation.tex`, line 4.  
  Fixed: `Developing a system that can maintain this accuracy … is a critical bottleneck` → `Maintaining such accuracy … remains a critical bottleneck`.

- ✅ **Unsupported strong negative claim.**  
  `1-research-context.tex`, line 15.  
  Fixed: `No existing vineyard robotics system …` → `To the author's knowledge, no existing vineyard robotics system …`

- ✅ **Informal register: "in real life."**  
  `1-research-context.tex`, line 12.  
  Fixed: phrase removed; item 3 of the enumerate collapsed into a single sentence ending at "physical vine structures."

- ✅ **US spelling: "millimeter."**  
  `1-research-context.tex`, line 12.  
  Fixed: `millimeter` → `millimetre`.

---

## Medium-Priority Findings

- ✅ **"A primary objective" implies plurality.**  
  `1-research-context.tex`, line 6.  
  Fixed: `A primary objective` → `The primary objective`.

- ✅ **"The realignment" presupposes a prior alignment.**  
  `1-research-context.tex`, line 7.  
  Fixed: `the realignment of global and local coordinate frames` → `the alignment of the robot's current pose to the offline model's coordinate frame`.

- ✅ **Clichéd phrasing: "bridge the gap."**  
  `1-research-context.tex`, line 8.  
  Fixed: `it must bridge the gap between its real-time physical state and the coordinate system of the offline model` → `it must map its real-time physical state to the coordinate system of the offline model`.

- ✅ **"automated labour" is vague and contradictory.**  
  `1-research-context.tex`, line 4.  
  Fixed: `automated labour` → `autonomous intervention`.

- ✅ **Currency notation lacks qualifier.**  
  `1-motivation.tex`, line 6.  
  Fixed: `\$9.2 billion` → `NZ\$9.2 billion`; `\$2.3 billion` → `NZ\$2.3 billion`.

- ✅ **"Around 23\%" is informal.**  
  `1-motivation.tex`, line 6.  
  Fixed: `around` → `approximately`.

- ⚠️ **Asymmetric statistics — author decision required.**  
  `1-motivation.tex`, line 8.  
  "expenditure on manual pruning increased" gives no figure, while "spending on machine pruning declined by 21%" is quantified. Either supply the percentage increase from the source data or rephrase symmetrically (e.g., "expenditure on manual pruning rose year-on-year").

- ⚠️ **Unsupported claim: labour shortages — author decision required.**  
  `1-motivation.tex`, line 6.  
  "the sector faces chronic labour shortages and rising operational costs" is currently supported only by `\cite{2025MarlboroughVineyard}`. If that report does not directly address labour shortages, a second citation (e.g., an industry workforce survey) should be added.

- ✅ **"a principal limitation" → "the principal limitation."**  
  `1-motivation.tex`, line 8.  
  Fixed.

- ✅ **"insufficient precision" is under-specified.**  
  `1-motivation.tex`, line 8.  
  Fixed: `insufficient precision to meet vineyard managers' operational requirements` → `the inability to selectively remove individual canes without compromising cordon or trunk wood`.

- ✅ **"robotic labour" is an awkward phrase.**  
  `1-motivation.tex`, line 8.  
  Fixed: `robotic labour` → `robotic automation`.

- ✅ **"facilitates this alignment" is weak.**  
  `1-research-context.tex`, line 17.  
  Fixed: `a SLAM and relocalisation framework that facilitates this alignment` → `a SLAM and relocalisation framework that enables the registration chain described above`.

- ✅ **"seeks to advance the research objectives" is circular.**  
  `1-motivation.tex`, line 10.  
  Fixed: sentence rewritten to `this work also contributes to UCVision's broader mission of modelling occluded plant structures and tracking growth across multiple seasons`.

- ✅ **"The main objective" → "The primary objective."**  
  `1-research-objectives.tex`, line 4.  
  Fixed.

- ✅ **Passive construction in sub-objectives preamble.**  
  `1-research-objectives.tex`, line 6.  
  Fixed: `the following sub-objectives are defined` → `The research pursues the following sub-objectives:`.

---

## LaTeX Hygiene Notes

- ✅ **Inconsistent italicisation of "offline":** Verified — `\textit{offline}` appears on first use only in `1-research-context.tex`; all subsequent occurrences are plain. No action needed.
- ⚠️ **TODO placeholders in contributions:** `1-research-objectives.tex` lines 32–34 contain `\textbf{TODO:}` items. Deferred until results chapters are finalised. Must be resolved before submission.
- ✅ **Trailing space:** `1-thesis-structure.tex` line 4 — trailing space after colon removed.
- ⚠️ **Cross-references in `1-thesis-structure.tex`:** `\cref{chap:Background}`, `\cref{chap:SLAM}`, `\cref{chap:precise-alignment}`, `\cref{chap:Conclusion}` — verify these labels exist and match exactly in the corresponding chapter files. Requires a compilation check.
- ⚠️ **ICP acronym introduced in `1-thesis-structure.tex`:** "Iterative Closest Point (ICP)" is expanded here. Confirm it is not re-expanded on first use in `4-precise-alignment/`; if the chapter introduces it first in reading order, remove the expansion here instead.
- ✅ **Em-dashes in `1-research-objectives.tex`:** `---` used correctly throughout.

---

## Open Questions

- **"As of 2026" vs forecast language (`1-motivation.tex` line 6):** The cited source is from 2025 and describes a forecast. The current date is May 2026. Clarify whether NZ\$9.2 billion is still a forecast or is now an actuality — update the phrasing accordingly, and confirm the figure is still accurate.
- **Sub-objective 4 specificity:** The integration sub-objective mentions "feeds directly into the pruning arm's path planner" — confirm this level of system integration was actually implemented and tested, or hedge with "to be integrated into."
