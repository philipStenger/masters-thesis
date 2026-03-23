---
name: latex-hygiene-checker
description: "Use when: checking thesis .tex files for LaTeX convention violations from the ML paper writing guide — citation command misuse, broken references, wrong quotation marks, label/caption ordering, equation punctuation, and missing \\cref usage. Produces a line-referenced flag list. Does NOT edit files."
model: claude-haiku-4.5
---

# Skill: LaTeX Hygiene Checker

## Purpose
Mechanically scan all thesis `.tex` files for LaTeX convention violations catalogued in the ML Paper Writing Guide §6. Produce a line-referenced list of flags. Do NOT fix anything — report only.

## Scope
Scan every `.tex` file under the thesis root. Skip `.cls`, `.sty`, `.bst`, and `.bib` files.

---

## Step 1 — Collect All .tex Files

Use glob or search to find every `.tex` file.

---

## Step 2 — Run the Checker Script

**Run `./check_latex.ps1` from this skill's directory, passing the thesis root as a parameter:**

```powershell
.\check_latex.ps1 -ThesisRoot <path-to-thesis-root>
```

> **Why use the script?** It implements all single-line checks via regex and also handles multi-line analysis (label/caption ordering, equation punctuation, blank lines after equations) that would be tedious to perform by hand. Output is consistently formatted and line-referenced, ready to carry directly into the report.

> **Permissions note:** If PowerShell blocks execution due to execution policy, run this first in the same session:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
> ```

The script prints a grouped, line-referenced flag list followed by a summary table. **The script output IS your complete flag list — do not re-run the checks manually.** Read the output and carry the flags forward as evidence for Section 6 of the report.

If the script cannot be run, fall back to the manual checks below. Otherwise, skip to Step 3.

---

## Checks Performed by the Script

Record every match as:
```
[CHECK NAME] <file path>, near line <N>: "<quoted text (≤ 20 words)>"
  → Reason: <one-sentence explanation>
```

---

### CHECK 1 — Citation Command Misuse

**1a. Parenthetical citation used as a grammatical subject**
Pattern: `\([A-Z][a-zA-Z\s]+,\s*\d{4}\)\s+(shows?|demonstrates?|finds?|argues?|reports?|states?|notes?|suggests?|proposes?|introduces?|presents?)`
Flag: A parenthetical citation form used as the sentence subject. Should use `\citet{}` instead.
Example to flag: `(Smith, 2001) shows that...`

**1b. Raw author-year citation in text (not using a command)**
Pattern: `[A-Z][a-zA-Z]+\s+et al\.\s*\(\d{4}\)` appearing without a preceding `\citet` or `\citeauthor`
Flag: Author-year expressed in prose without a LaTeX citation command.

**1c. `\cite{}` or `\autocite{}` used as a grammatical subject**
Pattern: `\b(\\cite|\\autocite)\{[^}]+\}\s+(shows?|demonstrates?|finds?|argues?|states?|notes?|proposes?)`
Flag: Should use `\citet{}` when the citation is the sentence subject.

**1d. Citation without preceding non-breaking space**
Pattern: `[^~]\s(\\cite|\\autocite|\\citep)\{`
Flag: Citation not preceded by `~`. Should be `word~\cite{key}` to prevent line breaks.

---

### CHECK 2 — Broken References

Pattern: `\?\?`
Flag: Unresolved cross-reference — a `\ref{}`, `\cref{}`, `\label{}`, or `\cite{}` that LaTeX could not resolve. Must be fixed before submission.

---

### CHECK 3 — Wrong Quotation Marks

**3a. Straight double quotes used in prose**
Pattern: `"[^"]{1,50}"`
Flag: Should use LaTeX quotation marks: ` ``text'' ` or `\enquote{text}`.

**3b. Straight single quotes used as quotation marks**
Pattern: `'[^']{1,30}'` in prose context (not in BibTeX key or LaTeX argument)
Flag: Use ` `text' ` (LaTeX single quotes) or restructure.

---

### CHECK 4 — `\label{}` Before `\caption{}`

Scan every `figure`, `table`, `subfigure` environment. Within each:
- If `\label{` appears before `\caption{` in the same environment, flag it.
- Pattern to detect: `\label{[^}]+}` occurring before `\caption{` within the same `\begin{figure}...\end{figure}` block.
- Correct order: `\caption{...}` then `\label{...}`.

---

### CHECK 5 — `\ref{}` Used Instead of `\cref{}`

Pattern: `\bref\{` (not preceded by `\c`, `\auto`, `\name`, `\page`, `\eq`, etc.)
Flag: Plain `\ref{}` found. Prefer `\cref{}` from the cleveref package for intelligent cross-referencing.
Exception: do not flag inside `.cls` or `.sty` files, or inside `\newcommand` definitions.

---

### CHECK 6 — Display Equation Punctuation

For every `\begin{equation}`, `\begin{align}`, `\begin{gather}`, `\begin{multline}`, `\begin{eqnarray}` environment:
- Check the last token before `\end{...}` or `\\` (end of last line).
- Flag if the equation does not end with `,` or `.` (or `\,` followed by `.`/`,`).
- Note: punctuation should appear inside the environment, not after `\end{equation}`.

Pattern heuristic: `\end{equation}` or `\end{align}` NOT preceded (within the environment) by `,` or `.`

---

### CHECK 7 — Blank Line After Equation Causing Paragraph Break

Pattern: A blank line immediately after `\end{equation}`, `\end{align}`, `\end{gather}`, `\]`, or a closing `$` in display-math context, where the surrounding context is mid-sentence prose.
Flag: Creates an unintended paragraph break. Remove the blank line.

---

### CHECK 8 — Footnote Placement

Pattern: Footnote marker `\footnote{` appearing immediately before `.` or `,` rather than after:
- Flag: `\footnote{[^}]+}[.,]` — footnote comes before punctuation. Move footnote after the punctuation mark.
- Correct: `word.\footnote{...}` or `word,\footnote{...}`.

---

### CHECK 9 — `fullpage` Package Usage

Pattern: `\usepackage.*{fullpage}`
Flag: The `fullpage` package overrides options in many style files. Remove it.

---

### CHECK 10 — Orphaned Words at Line End

This check applies to the compiled output and cannot be fully verified from source. Flag as a reminder:
- Search for `\\` (manual line break) in prose paragraphs (outside tabular/equation environments).
- Flag each occurrence as a potential forced break that may create a one-word orphan line.
- Note: full verification requires inspecting the compiled PDF.

---

### CHECK 11 — Non-Trivial Equality Without Justification

Pattern: `\stackrel` used (good — annotated equality). Conversely:
- Flag display equations containing `=` with a comment like `% TODO: justify` or no surrounding prose justification.
- More practically: flag `\begin{equation}` blocks where the immediately following prose paragraph does not contain "where", "because", "since", "as", "therefore", "by", "from", "using", "recall", "note", or "substituting" — suggesting the equality may be unjustified.

---

## Step 3 — Produce the Report

```
LATEX HYGIENE SCAN RESULTS
===========================
Scanned files: <list>
Total flags: <N>

--- CHECK 1: CITATION COMMAND MISUSE ---
<file>:<line>  "<quoted passage>"
  → Reason: ...
...

--- CHECK 2: BROKEN REFERENCES (??) ---
...

--- CHECK 3: WRONG QUOTATION MARKS ---
...

--- CHECK 4: LABEL BEFORE CAPTION ---
...

--- CHECK 5: \ref{} INSTEAD OF \cref{} ---
...

--- CHECK 6: EQUATION MISSING PUNCTUATION ---
...

--- CHECK 7: BLANK LINE AFTER EQUATION ---
...

--- CHECK 8: FOOTNOTE BEFORE PUNCTUATION ---
...

--- CHECK 9: fullpage PACKAGE ---
...

--- CHECK 10: FORCED LINE BREAKS ---
...

--- CHECK 11: UNJUSTIFIED EQUALITIES ---
...

--- SUMMARY ---
Check 1 (Citation misuse):         N flags
Check 2 (Broken refs):             N flags
Check 3 (Wrong quotes):            N flags
Check 4 (Label before caption):    N flags
Check 5 (\ref not \cref):          N flags
Check 6 (Equation punctuation):    N flags
Check 7 (Blank after equation):    N flags
Check 8 (Footnote placement):      N flags
Check 9 (fullpage package):        N flags
Check 10 (Forced line breaks):     N flags
Check 11 (Unjustified equality):   N flags
TOTAL:                             N flags
```

---

## Guardrails
- Do NOT edit any files.
- Do NOT suggest fixes beyond the one-line reason note.
- Skip content inside LaTeX comments (`%...` to end of line).
- If uncertain whether a flag is a true violation, include it and mark as `[LOW CONFIDENCE]`.
