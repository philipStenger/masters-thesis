---
name: compile-pdf
description: "Use when: compile the thesis PDF, build the LaTeX project, or run pdflatex/bibtex for thesis.tex."
model: gpt-5-mini
---

# Compile Thesis PDF

## Goal
Compile the LaTeX thesis into a PDF using the repository's standard build sequence.

## Preconditions
- Run from the workspace root.
- The main entry file is thesis.tex.

## Steps
1. Run the standard build sequence in the terminal:
   - `pdflatex -interaction=nonstopmode thesis.tex && bibtex thesis && pdflatex -interaction=nonstopmode thesis.tex && pdflatex -interaction=nonstopmode thesis.tex`
2. If the build fails:
   - Identify the first LaTeX error and its log context.
   - Propose and apply minimal, local edits to fix the issue (follow the thesis instructions).
   - Re-run the build sequence.
3. If the build still fails because the build command is incorrect or incomplete for this project, update this skill:
   - Adjust the command in the Steps section.
   - Update the frontmatter description to reflect the new command or tool (e.g., latexmk).
4. Confirm that a new thesis.pdf is produced in the workspace root:
   - If thesis.pdf exists, compare its modified time to the build start time and verify it updated.
   - If it does not exist or the timestamp did not change, treat the build as failed and report the first error.

## Notes
- Prefer minimal, local edits that preserve chapter structure and citations.
- Do not modify .cls, .sty, or .bst files unless explicitly requested.
