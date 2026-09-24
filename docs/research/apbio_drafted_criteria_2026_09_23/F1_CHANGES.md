# Work Order F.1 — APBIO-FRQ-S-101 subpart relabel

Status: **builder correction complete; awaiting independent re-grade by Claude**

## Change

The accepted biological content is unchanged. The retired three-part parent placed both the definition of “most parsimonious” and the reason parsimony is preferred under label `(iii)`; the child stem asks those as `(a)(iii)` and `(a)(iv)`.

Before:

```text
(iii) "Most parsimonious" means the cladogram requiring the fewest total number of evolutionary character-state changes to explain the observed distribution of traits among the taxa. Parsimony is preferred in phylogenetic analysis because, all else being equal, the simplest explanation requiring the fewest independent (convergent) evolutionary events is the most probable and avoids unnecessary assumptions about homoplasy (the same trait evolving independently more than once).
```

After:

```text
(iii) "Most parsimonious" means the cladogram requiring the fewest total number of evolutionary character-state changes to explain the observed distribution of traits among the taxa.
(iv) Parsimony is preferred in phylogenetic analysis because, all else being equal, the simplest explanation requiring the fewest independent (convergent) evolutionary events is the most probable and avoids unnecessary assumptions about homoplasy (the same trait evolving independently more than once).
```

The former one span became two spans, both tagged only to `a-iv` because the stored criterion combines the child stem’s parts (iii) and (iv). The unchanged `(iii)` sentence remains `recovered_parent` at source offset 1090. The `(iv)` sentence is `drafted` because adding its label changes the bytes; it has no source offset. A typed `f1_subpart_relabel` flag records the exception.

## Re-verified invariants

| Invariant | Result |
|---|---:|
| Proposal items | 71 |
| Exact span concatenation | 71 / 71 |
| Items with full criterion coverage | 71 / 71 |
| Stored criteria | 261 |
| Criteria without an exclusive span | 0 / 261 |
| S-101 spans before / after | 4 / 5 |
| Production writes | 0 |

## General label scan

The 71-item scan found three parent-split presentation patterns:

- `APBIO-FRQ-S-101`: missing explicit `(iv)`; corrected here.
- `APBIO-FRQ-S-102`: two distinct reasons are numbered inside its combined `(iii)` paragraph rather than carrying a separate `(iv)` label.
- `APBIO-FRQ-S-103`: the three requested `d(i)`–`d(iii)` lines are presented as one `(d)` paragraph with numbered evidence types.

Per the F.1 boundary, S-102 and S-103 were not changed; both score 100% on the current deployment. No other F proposal showed this parent-split pattern. This scan is structural evidence only and is not a re-grade.

The existing `qa_report.md` and `qa_findings.csv` describe F before this F.1 presentation correction and were not edited.
