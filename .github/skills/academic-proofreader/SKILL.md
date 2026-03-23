# Skill: Academic Proofreader Workflow

## Purpose
Provide a repeatable proofreading workflow for this LaTeX thesis focused on grammar, argument flow, structural coherence, and LaTeX citation/reference hygiene.

## Use This Skill When
- A section or chapter needs a final language-quality pass.
- You want to improve logical flow, not just grammar.
- You need consistency checks across terminology, tense, and LaTeX conventions.

## Inputs
- Target `.tex` file(s) (section or chapter scope)
- `MastersThesis.bib` (for citation sanity checks)

## Project-Specific Conventions
- Prefer `localisation` unless a source-specific term must remain unchanged.
- Prefer `\\cref{...}` for cross-references where appropriate.
- Keep mathematical variables in math mode (`$...$`).
- Use `\\cite{...}` or `\\autocite{...}` and avoid raw citation placeholders.

## Workflow
1. Scope pass:
- Identify whether the request is section-level, chapter-level, or cross-chapter.
- Keep edits local to requested files.

2. Language pass:
- Fix grammar, punctuation, article usage, and subject-verb agreement.
- Convert vague or verbose wording into precise academic prose.

3. Logic pass:
- Ensure each paragraph has one main claim.
- Strengthen transitions and remove abrupt topic jumps.
- Flag unsupported assertions that likely need citations.

4. LaTeX pass:
- Check cross-reference consistency (`\\ref` vs `\\cref`).
- Check equation/table/figure references for clarity and consistency.
- Flag malformed citation patterns and placeholders (e.g., `[cite: n]`).

5. Consistency pass:
- Normalize terminology and tense within scope.
- Keep acronym use consistent after first definition.

6. Reporting:
- Return prioritized findings first.
- **Use `./assets/review-output-template.md` from this skill folder to structure your output.** Read the template first, then fill in each section with your findings. Using the template ensures the output is consistently structured and directly usable by whoever receives it — do not invent a different output format.
- Provide patch-ready LaTeX rewrite suggestions.
- End with unresolved questions only when essential.

## Guardrails
- Do not fabricate data, results, or citations.
- Do not introduce new technical claims without source support.
- Do not alter thesis structure unless the user asks for restructuring.
