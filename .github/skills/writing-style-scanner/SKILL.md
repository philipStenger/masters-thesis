---
name: writing-style-scanner
description: "Use when: scanning thesis .tex files for banned words, passive voice, vague language, style violations, and anthropomorphisms from the ML paper writing guide. Produces a line-by-line flagged list ready for a writer agent to act on."
model: claude-haiku-4.5
---

# Skill: Writing Style Scanner

## Purpose
Mechanically scan all thesis `.tex` files for every writing style violation catalogued in the ML Paper Writing Guide. Produce an exhaustive, line-referenced list of flags grouped by violation type. Do NOT fix anything — report only.

## Scope
Scan every `.tex` file in the thesis (all chapters, front matter, appendices). Skip `.cls`, `.sty`, `.bst`, and `.bib` files.

---

## Step 1 — Collect All .tex Files

Use glob or search to find every `.tex` file under the thesis root.

---

## Step 2 — Run the Scanner Script

**Run `./scan_style.ps1` from this skill's directory, passing the thesis root as a parameter:**

```powershell
.\scan_style.ps1 -ThesisRoot <path-to-thesis-root>
```

> **Why use the script?** It implements all 11 checks exhaustively, strips LaTeX comments before matching, and produces consistently formatted, line-referenced output. Running the checks manually would be slower, less complete, and harder to reproduce.

> **Permissions note:** If PowerShell blocks execution due to execution policy, run this first in the same session:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
> ```

The script prints a grouped, line-referenced flag list followed by a summary table. **The script output IS your complete flag list — do not re-run the checks manually.** Read the output and carry the flags forward as evidence for Section 5 of the report.

If the script cannot be run, fall back to the manual pattern checks below. Otherwise, skip to Step 3.

---

## Checks Performed by the Script

The script applies these checks to every `.tex` file (pure comment lines and inline comments are stripped first):

For each `.tex` file, apply the checks below in order. Record every match as:

```
[VIOLATION TYPE] <file path>, near line <N>: "<quoted text (≤ 20 words)>"
```

### CHECK A — Banned Words (Remove Entirely)
Search for these words/phrases (case-insensitive, whole-word or phrase match where noted):
- `actually`
- `a bit`
- `fortunately`
- `to our knowledge`
- `note that`
- `observe that`
- `try to`
- `\bvery\b`
- `\breally\b`
- `\bextremely\b`
- `\bhowever\b`
- `\bfurthermore\b`
- `\badditionally\b`
- `\bin addition\b`
- `\bmoreover\b`
- `\bnevertheless\b`

### CHECK B — Words to Replace
- Contractions: `it's`, `don't`, `can't`, `won't`, `isn't`, `aren't`, `wasn't`, `weren't`, `doesn't`, `didn't`, `we've`, `we're`, `we'd`, `they're`, `that's`, `there's`
- `\bwant\b` (replace with "aim to", "seek to", "intend to")
- `\bhope\b` (replace with "expect", "aim")

### CHECK C — Passive Voice Patterns
Search for common passive constructions in prose (ignore math environments):
- `\b(is|are|was|were|be|been|being)\s+(shown|presented|used|performed|conducted|described|observed|found|demonstrated|evaluated|compared|achieved|obtained|computed|estimated|applied|proposed|introduced|defined|given|measured|tested|validated|reported|noted|discussed)\b`
- `\bhas been\b`
- `\bhave been\b`
- `\bhad been\b`

### CHECK D — Vague or Imprecise Language
- `\bperformance\b` (flag: replace with specific metric — accuracy, precision, recall, latency, etc.)
- `\beffective\b` (flag: replace with specific claim)
- `\bgood\b` and `\bbad\b` as standalone adjectives in prose
- `\bsignificantly\b` — flag unless followed by a p-value or quantitative comparison
- `\bdramatically\b`
- `\bgroundbreaking\b`
- `\bbreakthrough\b`
- `\bstate-of-the-art\b` — flag unless a specific benchmark is cited immediately
- `\bnovel\b` without explanation of what is novel
- `\brobust\b` without quantitative backing
- `\baccurate\b` without a specific metric
- `\bsuperior\b` — comparative without explicit referent

### CHECK E — Comparatives Without Explicit Referents
Search for comparative adjectives not immediately followed by "than <something explicit>":
- `\bbetter\b(?!\s+than)` — "better" not followed by "than"
- `\bfaster\b(?!\s+than)`
- `\bhigher\b(?!\s+than)`
- `\blower\b(?!\s+than)`
- `\bmore\s+\w+\b(?!\s+than)` — "more X" not followed by "than"
- `\bimproved\b(?!\s+(over|compared|relative|versus|vs))` — "improved" without explicit comparison

### CHECK F — Anthropomorphisms of Algorithms
- `the (model|network|algorithm|system|method|approach) (knows|understands|believes|thinks|assumes|decides|chooses|learns|sees|perceives|recognises|recognizes|feels|wants|tries)`
- `\bmodel knowledge\b`
- `\bnetwork understands\b`

### CHECK G — Pronoun and Sentence-Start Issues
- Lines of prose where two or more consecutive sentences begin with `We ` — flag the run.
- Standalone demonstrative pronouns not used as adjectives: ` this ` (not followed by a noun), ` these ` (not followed by a noun), ` those ` (not followed by a noun). Use heuristic: flag `\bthis\b` followed by a verb (e.g., "this is", "this shows", "this means", "this was").

### CHECK H — Apostrophe Possessives
- Pattern: `\b[A-Z][a-zA-Z]+'s\b` — e.g., "SLAM's", "Gaussian's", "system's" (flag: rephrase as "the X of Y")

### CHECK I — Excessive Hedging
- `\bmay\b`, `\bmight\b`, `\bcould\b` used in claims (flag when appearing in declarative sentences about results or contributions, rather than genuinely uncertain future work)

### CHECK J — Words in Quotation Marks Used to Dodge Precision
- Pattern in LaTeX: ` ``\w[^']*'' ` — words or short phrases wrapped in LaTeX quotes inside prose sentences (flag: replace with a precise term or rephrase)

### CHECK K — "On the other hand" Without "On the one hand"
- `on the other hand` appearing without `on the one hand` in the same paragraph

---

## Step 3 — Produce the Report

Print a grouped report in this format:

```
WRITING STYLE SCAN RESULTS
===========================
Scanned files: <list of files scanned>
Total flags: <N>

--- CHECK A: BANNED WORDS ---
<file>:<line>  "<quoted passage>"
...

--- CHECK B: REPLACEABLE WORDS ---
...

--- CHECK C: PASSIVE VOICE ---
...

[etc. for each check]

--- SUMMARY ---
Check A (Banned Words):        N flags
Check B (Replaceable Words):   N flags
Check C (Passive Voice):       N flags
Check D (Vague Language):      N flags
Check E (Bare Comparatives):   N flags
Check F (Anthropomorphisms):   N flags
Check G (Pronoun Issues):      N flags
Check H (Apostrophe Poss.):    N flags
Check I (Excessive Hedging):   N flags
Check J (Quoted Dodges):       N flags
Check K (Missing Counterpart): N flags
TOTAL:                         N flags
```

---

## Guardrails
- Do NOT edit any `.tex` files.
- Do NOT suggest fixes — flag and quote only.
- Skip content inside LaTeX math environments (`$...$`, `\[...\]`, `\begin{equation}`, `\begin{align}`, etc.) for checks C–K.
- Skip content inside LaTeX comments (`% ...`) for all checks.
- If a word appears in a figure caption or table cell where the rule clearly does not apply, note it but mark as `[LOW CONFIDENCE]`.
