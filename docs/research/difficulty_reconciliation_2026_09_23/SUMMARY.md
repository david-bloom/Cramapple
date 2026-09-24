# Work order J.0 — Biology difficulty regeneration

## Outcome

**Stopped at J.0. No difficulty data-load proposal was emitted.**

The existing categorical method reproduces every one of its 81 task-verb bands against the current
Production snapshot, with no band drift. However, it does not compute the requested continuous
attainment ratio, and the committed evidence does not define enough verified mappings or an
aggregation rule to reconstruct those ratios. Emitting numbers would be a new method and would make
the bands appear re-derivable when they are not.

This is the missing-required-input case in the overnight protocol: preserve the packet, report the
discrepancy, and skip the proposal stage. Per the queue gate, N and N.1 were not started.

## Measured results

| Measure | Result |
| --- | ---: |
| Current latest-published AP Biology items | 118 |
| FRQ / MCQ | 75 / 43 |
| Existing Easy / Medium / Hard assignments | 23 / 75 / 20 |
| Task-verb / judgment basis | 81 / 37 |
| Task-verb bands independently reproduced | 81 / 81 |
| Band differences | 0 |
| Fully exact-joinable to CRR `verb_auto` | 6 |
| Partially exact-joinable | 24 |
| No exact CRR verb join | 51 |
| Judgment rows with no ratio by design | 37 |
| Defensible per-item ratios emitted | **0** |
| Production writes | **0** |

## Invariants

| Invariant | Result | Evidence |
| --- | --- | --- |
| Scope is the current 118-item Biology corpus | PASS | `packet.jsonl`; 118 unique keys and version IDs; 75 FRQ + 43 MCQ |
| Snapshot identities remain current | PASS | Production and packet identity MD5 both `0fd8ab863891be18662c1fe3ac08c891` at 2026-09-24 16:26:17 UTC |
| Existing task-verb bands reproduce exactly | PASS | 81/81 `band_match=true` in `j0_reproduction.csv` |
| No item is silently re-banded | PASS | 0 differences |
| 81 task-verb rows carry a measured, sourced ratio | **FAIL** | The method has no ratio calculation; 51 no joins, 24 partial, 6 blocked on unverified source plus absent aggregation rule |
| 37 judgment rows remain null | PASS | 37 `unavailable_by_design`; no value manufactured |
| Basis can be mapped safely to migration vocabulary | PARTIAL | `calibrated_judgement` is supported; `calibrated_task_verb` must not imply numeric provenance until the ratio method exists |
| Source values remain null for Biology | PASS BY SCOPE | Production has zero difficulty rows; Biology has no prior value to translate |
| No Production writes | PASS | Read-only SQL only; `run_metadata.json` records zero |
| No QA-owned artifact created or changed | PASS | No `qa_report.md` or `qa_findings.csv` in this directory |

## Files

- `packet.jsonl` — model-neutral live inputs used by the classifier: item/version identity, stem,
  and learner-facing criteria.
- `j0_reproduction.csv` — per-item band reproduction and ratio-derivability verdict.
- `reproduce_j0.py` — deterministic reproduction/audit script using the committed classifier rules.
- `DISCREPANCY.md` — evidence that the ratio premise is unsupported and the exact inputs needed to
  unblock it.
- `run_metadata.json` — snapshot, hashes, branch, model, and zero-write record.

## Lowest-confidence / reviewer-first evidence

1. The six fully exact `verb_auto` joins are not usable as-is because the source field is explicitly
   documented as unverified; review them first if a mapping is supplied.
2. The 24 partial joins demonstrate why an aggregation rule is necessary: an item can contain both
   observed and unobserved verbs.
3. The 51 zero-join rows prove that exact joining cannot produce the expected 81 ratios.
4. The 37 judgment rows correctly have no numeric anchor and should remain null under any resumed
   run.

## Open question

Should the Product Owner supply a verified verb/Science-Practice calibration and aggregation rule,
or revise DECISION-0061 so task-verb bands without a direct measurement also carry a null ratio?
That choice changes the meaning of `calibrated_task_verb`; it cannot be inferred safely here.
