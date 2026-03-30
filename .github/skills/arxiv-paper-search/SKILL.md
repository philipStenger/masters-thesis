---
name: arxiv-paper-search
description: "Searches arXiv for papers relevant to a given topic, technical term, or thesis section. Returns a curated, ranked candidate list with metadata and relevance notes. Used by PaperResearcher and BibManager."
model: claude-haiku-4.5
---

# Skill: arXiv Paper Search

## Purpose
Given a research topic, technical term, or thesis section context, search arXiv and return a curated list of relevant candidate papers — ready for the calling agent to decide which to download and read.

## Inputs
- A **topic or query description** (e.g., "ICP point cloud registration outdoor environments", "vineyard robot localisation LiDAR")
- Optionally: a **thesis section or claim context** to calibrate relevance judgement
- Optionally: a **date range** hint (e.g., "foundational work pre-2015" or "recent advances post-2020")

---

## Step 1 — Construct Queries

Build **two to three distinct queries** from the input to cover different angles of the topic:

- **Query A — specific technique**: quoted exact phrases for the core method (`"iterative closest point"`, `"Gaussian process regression"`)
- **Query B — application domain**: combine method with domain (`"robot localisation" AND ("vineyard" OR "orchard" OR "agricultural")`)
- **Query C — recent advances**: same topic with `date_from: "2022-01-01"` to catch current state-of-the-art

Use relevant arXiv category filters to improve precision:
| Domain | Category |
|--------|----------|
| Robotics | `cs.RO` |
| Computer Vision | `cs.CV` |
| Machine Learning | `cs.LG` |
| AI | `cs.AI` |
| NLP | `cs.CL` |

Aim for 10–15 results per query. Prefer `sort_by: "relevance"`.

---

## Step 2 — Run Searches

Call `arxiv-mcp-server-search_papers` for each query constructed in Step 1.

---

## Step 3 — Deduplicate and Rank

Merge results across all queries. Remove duplicates (same arXiv ID). Rank the merged list by:
1. **Direct relevance** — does the title/abstract directly address the input topic?
2. **Credibility signals** — published in a known venue (ICRA, IROS, CVPR, IROS, IEEE RA-L, IJRR, etc.)
3. **Recency balance** — include at least one foundational paper and at least one paper from the last three years if both exist

Aim for a final shortlist of **5–10 candidates**.

---

## Step 4 — Return Candidate List

Output a structured candidate list in this format:

```
## arXiv Search Results — <topic>

### Candidate Papers

| # | arXiv ID | Title | Authors | Year | Venue | Relevance |
|---|----------|-------|---------|------|-------|-----------|
| 1 | XXXX.XXXXX | Full title | Surname et al. | YYYY | Conference/Journal | 1–2 sentence note |
| 2 | ...       | ...   | ...     | ...  | ...   | ...       |

### Recommended Downloads
Papers worth downloading and reading in full (for the calling agent to action):
- [1] <arXiv ID> — <reason>
- [3] <arXiv ID> — <reason>

### Search Coverage Notes
- Queries run: <list queries used>
- Any obvious gaps or alternative search angles to try if results are insufficient
```

---

## Guardrails
- Do not download papers — that is the calling agent's responsibility.
- Do not fabricate arXiv IDs, titles, or authors.
- If fewer than three strong candidates are found, say so explicitly and suggest refined queries.
- If arXiv returns no results for a query, try a simpler fallback query and note the adjustment.
