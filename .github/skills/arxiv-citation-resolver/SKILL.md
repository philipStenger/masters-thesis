---
name: arxiv-citation-resolver
description: "Takes a citation placeholder (e.g., \\cite{TODO-icp}) or a described citation gap, searches arXiv for the best matching paper, downloads and reads it to confirm the match, and returns a complete ready-to-paste BibTeX entry. Used by BibManager and PaperResearcher."
model: claude-haiku-4.5
---

# Skill: arXiv Citation Resolver

## Purpose
Given a citation placeholder key or a described gap in the bibliography, find the best matching paper on arXiv, confirm it is the right paper by reading it, and return a complete BibTeX entry following the thesis naming convention.

## Inputs
- A **placeholder citation key** (e.g., `\cite{TODO-icp}`, `\cite{TODO-orb-slam}`) and/or the surrounding sentence(s) from the `.tex` file that provides context
- The **thesis BibTeX key naming convention** (inferred from `MastersThesis.bib` by the calling agent — pass as context)

---

## Step 1 — Extract Search Context

From the placeholder key and surrounding text, identify:
- The **core concept or method** being cited (e.g., "Iterative Closest Point algorithm")
- The likely **paper type** (foundational algorithm, survey, application paper, dataset paper)
- Any **author or title hints** embedded in the placeholder key (e.g., `TODO-besl1992` hints at Besl, 1992)
- Whether this is likely a **landmark/seminal paper** (original algorithm publication) or a **recent application**

---

## Step 2 — Search arXiv

Use the `arxiv-paper-search` skill (or call `arxiv-mcp-server-search_papers` directly) with:
- A targeted query built from the extracted context
- Appropriate category filters (`cs.RO`, `cs.CV`, `cs.AI`, `cs.LG`)
- For seminal papers: add `date_to` to restrict to the likely publication era

If the placeholder key contains a year hint (e.g., `TODO-besl1992`), use `date_to: "1993-12-31"` to constrain the search.

---

## Step 3 — Download and Confirm

For the top 1–2 candidates from the search:
1. Call `arxiv-mcp-server-download_paper` to retrieve the paper.
2. Call `arxiv-mcp-server-read_paper` to read the content.
3. Confirm the match by checking:
   - Does the paper introduce or primarily describe the method referenced in the placeholder context?
   - Do the authors, year, and venue match any hints in the placeholder key?
   - Is the abstract consistent with how the method is described in the thesis text?

If no arXiv record exists (e.g., pre-arXiv classic papers like Besl & McKay 1992), note this and provide the BibTeX entry from known publication facts without downloading.

---

## Step 4 — Produce BibTeX Entry

Generate a complete BibTeX entry using:
- The **metadata from the downloaded paper** (authors, title, year, venue, DOI if available)
- The **key naming convention** from `MastersThesis.bib` (typically `AuthorYYYYkeyword`, e.g., `Besl1992ICP`)
- The appropriate entry type: `@article`, `@inproceedings`, `@techreport`, or `@misc`

Prefer `@inproceedings` for conference papers and `@article` for journal papers. Use `@misc` with `howpublished = {arXiv preprint arXiv:XXXX.XXXXX}` only if no formal venue is available.

---

## Output Format

```
## Citation Resolution: \cite{<placeholder-key>}

**Context**: "<surrounding sentence from .tex file>"

**Resolved paper**: <Full title>
**Confidence**: HIGH | MEDIUM | LOW
**Reason**: <1–2 sentences justifying the match>
**arXiv ID**: <XXXX.XXXXX> (or "Not on arXiv — classic publication")

**Suggested BibTeX key**: `<AuthorYYYYkeyword>`

**BibTeX entry**:
```bibtex
@inproceedings{AuthorYYYYkeyword,
  author    = {Surname, Firstname and Surname2, Firstname2},
  title     = {Full Title of the Paper},
  booktitle = {Proceedings of the Conference Name},
  year      = {YYYY},
  pages     = {X--Y},
  doi       = {10.xxxx/...},
}
```

**Replace in .tex**: `\cite{<placeholder-key>}` → `\cite{<AuthorYYYYkeyword>}`
```

---

## Guardrails
- Do not fabricate metadata. If a field cannot be confirmed, write `UNKNOWN — verify manually`.
- If confidence is LOW, say so clearly and explain why — do not silently produce a questionable entry.
- For pre-arXiv classic papers (pre-1991), provide the BibTeX from established publication facts and mark as `[NOT ON ARXIV]`.
- Do not add entries to `MastersThesis.bib` directly — output only; the calling agent decides whether to apply.
