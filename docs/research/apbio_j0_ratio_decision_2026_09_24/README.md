# J.0 resumption — scope and rules fixed 2026-09-24, per DECISION-0065

This directory holds the exact scope for the two-AI CRR verification J.0 needs to resume, computed
directly against Codex's own `docs/research/difficulty_reconciliation_2026_09_23/` output (the run
that stopped and correctly reported no ratio method existed yet — see
`docs/activity_log/DECISIONS_LOG.md`, DECISION-0065, for the four decisions that unblock it).

## `crr_rows_to_verify.csv` — the 87 rows

Biology's 81 task-verb items use 23 distinct base verbs (after normalizing inflections — the raw
`detected_verbs` column in `j0_reproduction.csv` mixes forms like `describes`/`describe`). Of those:

- **8 verbs never appear anywhere in the 316-row `crr_calibration_all_subjects.csv`, in any
  subject:** `apply`, `classify`, `contrast`, `distinguish`, `label`, `name`, `support`, `trace`.
- The other **15 verbs do appear**, across Biology's own 18 rows and the other 7 subjects' 298 rows.

This file is exactly the rows carrying one of those 15 reachable verbs — **10 from AP Biology, 77
from six other subjects** (Chemistry 31, Calculus AB 19, Calculus BC 14, Physics C: E&M 6, Physics
C: Mechanics 5, Precalculus 2). Verifying only these 87 (not all 316, not just Biology's 18) covers
every item that can possibly get a ratio under the rules below.

## The tier-fallback rule (resolves the 8 unreachable verbs, decision #2)

The existing, already-validated task-verb tier table (`apbio_difficulty_calibration_2026_09_22/
README.md` §3) already groups verbs by difficulty:

| Tier | Verbs |
|---|---|
| Easy | identify, state, name, list, label, annotate, indicate, select, classify, recall |
| Medium | describe, explain, determine, compare, contrast, distinguish, construct, represent, write, analyze, apply, trace, graph, plot |
| Hard | justify, predict, evaluate, design, propose, support (a claim), synthesize, integrate, critique, calculate |

Every one of the 8 unreachable verbs has same-tier siblings that are CRR-reachable. Rule: **try an
exact verb match first; if none exists, fall back to the mean of that item's tier's reachable
verbs.** This closes the gap completely — 0 of the 81 task-verb items are permanently unreachable
under this rule (confirmed by direct computation against `j0_reproduction.csv`; 4 items —
`APBIO-MCQ-022`, `-026`, `-084`, `-086` — depend entirely on the tier fallback).

**Every emitted ratio must carry `ratio_source: exact_verb` or `ratio_source: tier_fallback`.**
Tier-fallback ratios rest on an untested assumption (same-tier verbs have similar attainment, not
just similar judged difficulty) and must never be presented with the same confidence as an exact
match — this is exactly the kind of distinction `packet.jsonl`'s confidence field exists for.

## Aggregation rule (decision #3)

**Mean** of an item's per-criterion (or, for a single-verb MCQ stem, per-detected-verb) ratios,
after each criterion/verb resolves to a ratio under the rule above (exact match preferred, tier
fallback only if no exact match for that specific verb).

## Cross-subject normalization (the gap flagged before decision #2 was finalized)

Subject baselines differ by up to 21 points (AP Physics 2 mean 0.653 vs. AP Chemistry mean 0.440;
see `apbio_difficulty_calibration_2026_09_22/README.md` §2's cut-point table). A raw ratio borrowed
from another subject imports that subject's baseline. **Do not copy a raw ratio across subjects.**
Normalize: express the source row's ratio as its position relative to that subject's own mean (or
its own tertile cut points), then re-express that same relative position against Biology's cut
points (0.49 / 0.75) before using it. This applies whenever a Biology item's ratio draws on a
non-Biology CRR row — both for exact-verb matches to other subjects and for tier-fallback matches.

## Cut-point inclusivity (decision #4)

`Hard <= 0.49`; `Medium` is the open interval `(0.49, 0.75)`; `Easy >= 0.75`. A value landing exactly
on a boundary belongs to the outer band, matching the already-published inclusive operators on Hard
and Easy.

## What this does not resolve

The 37 judgment-basis items remain null by original design (J.0's original brief) — untouched by
any of this. This only concerns the 81 task-verb items.
