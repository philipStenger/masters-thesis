---
name: arxiv-metadata-validator
description: "Validates existing BibTeX entries in MastersThesis.bib against arXiv records. Cross-checks title, authors, year, venue, and DOI, and reports discrepancies with suggested corrections. Used by BibManager."
model: claude-haiku-4.5
---

# Skill: arXiv Metadata Validator

## Purpose
Cross-check existing BibTeX entries in `MastersThesis.bib` against arXiv records to catch inaccuracies — wrong publication year, truncated author list, incorrect or missing venue, missing DOI or arXiv ID, and title variations.

## Inputs
- A list of **BibTeX entries** to validate (keys and their fields), passed by the calling agent
- Optionally: a **priority filter** (e.g., "only validate entries missing a DOI" or "validate all entries in Chapter 3")

---

## Step 1 — Identify Entries to Validate

From the provided list, prioritise entries that show any of these warning signs:
- Missing `doi` field
- Missing `url` or `eprint` (arXiv ID) field
- Only one author listed for a paper likely to have multiple authors
- `year` field that seems inconsistent with the key name (e.g., key says `Smith2018` but year field is `2019`)
- `booktitle` or `journal` field that is abbreviated, informal, or possibly incorrect
- Entries of type `@misc` that may have since been formally published

---

## Step 2 — Search arXiv for Each Entry

For each entry to validate, construct a search query:
- **Primary query**: `ti:"<title>"` — exact title search (most reliable)
- **Fallback query**: `au:"<first author surname>" <2–3 title keywords>` — if title search returns no results

Call `arxiv-mcp-server-search_papers` for each query.

If the paper predates arXiv (roughly pre-1991), skip arXiv search and mark as `[PRE-ARXIV — cannot validate via arXiv]`.

---

## Step 3 — Compare Metadata

For each entry where an arXiv match is found, compare the stored BibTeX fields against the arXiv record:

| Field | Check |
|-------|-------|
| `author` | All authors present? Correct spelling? Correct order? |
| `title` | Exact match or minor formatting difference? |
| `year` | Matches arXiv submission year or formal publication year? |
| `journal` / `booktitle` | Correct venue name? Full name vs abbreviation? |
| `doi` | Present and correct? |
| `eprint` / `url` | arXiv ID present and correct? |

Note: arXiv submission year may differ from formal publication year — flag this as informational, not an error.

---

## Step 4 — Report Discrepancies

For each validated entry, produce one of:
- **✓ VALID** — all checked fields match the arXiv record
- **⚠ MINOR** — small formatting differences (e.g., abbreviated venue, missing arXiv ID to add)
- **✗ ERROR** — substantive mismatch (wrong year, missing authors, incorrect venue)
- **? NOT FOUND** — no arXiv match found; cannot validate

---

## Output Format

```
## Metadata Validation Report

**Entries validated**: N
**Valid**: N | **Minor issues**: N | **Errors**: N | **Not found**: N

---

### ✗ ERRORS (fix these)

**Key**: `AuthorYYYYkeyword`
**Issue**: Wrong publication year — BibTeX says 2019, arXiv record shows 2018
**arXiv ID**: XXXX.XXXXX
**Suggested fix**:
  year = {2018},

---

### ⚠ MINOR ISSUES (recommended fixes)

**Key**: `Author2020keyword`
**Issue**: Missing DOI and arXiv eprint field
**Suggested additions**:
  doi    = {10.xxxx/...},
  eprint = {XXXX.XXXXX},
  archivePrefix = {arXiv},

---

### ? NOT FOUND ON ARXIV

**Key**: `ClassicPaper1992`
**Reason**: Pre-arXiv publication — manual verification required
**Suggested action**: Cross-check against IEEE Xplore / ACM DL / Semantic Scholar

---

### ✓ VALID ENTRIES
Keys confirmed correct: `Key1`, `Key2`, `Key3`, ...
```

---

## Guardrails
- Do not modify `MastersThesis.bib` directly — output corrections only.
- Do not flag the arXiv preprint year vs. formal publication year as an error — note it as informational.
- If arXiv returns multiple plausible matches for a title search, list them and flag as ambiguous rather than picking one.
- For entries not found on arXiv, suggest alternative databases but do not attempt to validate via other means.
