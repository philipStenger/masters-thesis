---
name: arxiv-check-citation
description: "Downloads a cited paper from arXiv and checks that the claim made in the thesis text is actually consistent with what the paper says. Use this to catch accidentally wrong citations, overclaiming, and misrepresented results."
model: claude-opus-4.6
---

# Skill: arXiv Citation Consistency Checker

## Purpose
Given a citation used in the thesis, download the cited paper and compare what the thesis claims it says against what it actually says. Catches wrong-paper citations, overclaimed results, underclaimed contributions, and misattributed methods.

## Inputs
- One or more **citation keys** to check (e.g., `Besl1992ICP`, `Mur2015ORB`)
- The **thesis `.tex` file(s)** where those keys are used — provided by the calling agent or the user
- `MastersThesis.bib` — to retrieve the arXiv ID, DOI, or enough metadata to locate the paper

---

## Step 1 — Extract Citation Contexts

For each citation key to check:
1. Search the thesis `.tex` files (using grep across all chapter files) for every occurrence of `\cite{<key>}` and `\autocite{<key>}`.
2. For each occurrence, extract a **citation context window**: the full sentence containing the citation, plus one sentence before and one sentence after.
3. From each context window, identify the **claim being attributed** to the cited paper — what is the thesis asserting that this paper says, shows, or contributes?

Record each occurrence as:
```
File: <relative path>
Line: <N>
Citation key: <key>
Attributed claim: "<the specific assertion the thesis is making about this paper>"
Full context: "<3-sentence window>"
```

---

## Step 2 — Locate and Download the Paper

Look up the citation key in `MastersThesis.bib` to retrieve:
- `eprint` / `archivePrefix` field (arXiv ID) — use directly with `arxiv-mcp-server-download_paper`
- `doi` field — use as a search hint if no arXiv ID is available
- `title` and `author` — use to search arXiv if neither of the above is present

If no arXiv ID is available, use `arxiv-mcp-server-search_papers` with `ti:"<title>"` to find the paper. If found, download it. If not found on arXiv (e.g., classic pre-arXiv paper), mark as `[NOT ON ARXIV]` and skip to Step 4.

Use `arxiv-mcp-server-download_paper` then `arxiv-mcp-server-read_paper` to retrieve the full paper content.

---

## Step 3 — Verify Each Attributed Claim

For each citation context extracted in Step 1, read the downloaded paper and assess:

### Consistency Questions
1. **Correct paper?** — Does this paper's title, authors, and topic match what the thesis context implies it should be about? If not, flag immediately as a likely wrong-paper citation.
2. **Claim supported?** — Does the paper actually make the claim, report the result, or introduce the method the thesis attributes to it?
3. **Accuracy of detail?** — If the thesis cites a specific number, technique name, or result, does it match what is in the paper? (e.g., "achieves 3 cm accuracy" — is that in the paper?)
4. **Correct attribution level?** — Is the thesis attributing a contribution to this paper that actually originated in a different prior work the paper merely builds on?
5. **Context preserved?** — Does the thesis represent the finding in a way consistent with the conditions and limitations described in the paper? (e.g., citing an indoor result as if it applies outdoors)

### Verdict Classification
Assign one verdict per citation occurrence:

| Verdict | Meaning |
|---------|---------|
| ✓ **CONSISTENT** | The attributed claim is well-supported by the paper |
| ⚠ **IMPRECISE** | The claim is broadly correct but overstated, understated, or missing an important condition/caveat |
| ✗ **INCONSISTENT** | The paper does not support the attributed claim — likely a wrong citation or misreading |
| ? **UNVERIFIABLE** | The paper is not on arXiv or the relevant section could not be found in the downloaded content |

---

## Step 4 — Produce the Report

Output a structured report for each citation key checked:

```
## Citation Consistency Report

**Keys checked**: N
**Consistent**: N | **Imprecise**: N | **Inconsistent**: N | **Unverifiable**: N

---

### \cite{<key>} — <Paper Title> (<Year>)

**arXiv ID**: <XXXX.XXXXX> (or "[NOT ON ARXIV]")

#### Occurrence 1 — <file>:<line>
**Attributed claim**: "<what the thesis says this paper shows/says/contributes>"
**Verdict**: ✗ INCONSISTENT
**Explanation**: The thesis states X, but the paper actually reports Y under condition Z. The figure cited (Table 3) shows results only for the indoor dataset; the thesis applies this claim to outdoor vineyard environments without qualification.
**Suggested fix**: Replace the attribution with a more accurate paraphrase, or cite a different paper. Suggested replacement text:
  > "... as demonstrated in indoor environments by \cite{<key>} ..."

---

#### Occurrence 2 — <file>:<line>
**Attributed claim**: "..."
**Verdict**: ⚠ IMPRECISE
**Explanation**: The claim is correct in substance but omits the key condition that the result holds only for structured environments. Consider adding a caveat.
**Suggested fix**: Add "in structured environments" after the claim.

---

#### Occurrence 3 — <file>:<line>
**Attributed claim**: "..."
**Verdict**: ✓ CONSISTENT
**Note**: Claim matches the paper's abstract and Section 4.2 conclusion directly.

---

### \cite{<next-key>} — ...
```

---

## Guardrails
- Read the **full paper content** (not just the abstract) before making a verdict — many specific claims are only in the results or discussion sections.
- Do not modify any `.tex` or `.bib` files — report only.
- Do not infer that a claim is inconsistent simply because the paper is about a related but different topic — only flag if the specific attributed claim is not supported.
- If the paper is not available on arXiv, do not attempt to guess the content — mark as `[UNVERIFIABLE]` and suggest the user check manually.
- Use UK English throughout (localisation, optimisation, modelling).
- For an `IMPRECISE` verdict, always suggest the minimal fix that would make the citation accurate.
- For an `INCONSISTENT` verdict, always suggest either a corrected paraphrase or an alternative citation to look for.
