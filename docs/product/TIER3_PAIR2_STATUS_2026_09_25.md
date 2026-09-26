# Tier 3 Pair 2 Status (2026-09-25, kickoff)

Per `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`. Pair 1 (AP Statistics/Claude, AP
Chemistry/Codex) is CLOSED — see `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md`. This is Pair 2: **AP
Calculus AB (Codex)** and **AP Precalculus (Claude)**.

## Assignment rationale

The paired plan named the pair but not who takes which subject. Baseline counts (verified against
Production, `pcntajvbdfqhbeewmdry`, 2026-09-25):

| Subject | Live items | No label | `legacy_unvalidated` | `stale` | `held` | `provisional_model` | `validated` | Difficulty rows |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Calculus AB | 128 | 34 | 46 | 17 | 16 | 6 | 9 | 0 |
| AP Precalculus | 126 | 20 | 28 | 6 | 10 | 31 | 31 | 0 |

Calculus AB's label queue is larger (97 items need a fresh label vs. Precalculus's 54) and neither subject
has an existing difficulty-assignment CSV — unlike Pair 1, where both CSVs already existed. Codex gets
Calculus AB (bigger label queue, runs unsupervised overnight, has more time to build and validate a new
difficulty classifier). Claude takes AP Precalculus in the same session as this kickoff.

No duplicate-current-serving-label-row anomaly (the Chemistry 12-item case) was found in either subject.

## AP Calculus AB (Codex's half) — DONE, cross-QA'd, follow-up fixes applied

`docs/content/CODEX_TASK_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md` (v1). Codex ran it without a
clarification round this time (unlike Chemistry's v1→v4) and opened PR #197: 93 label decisions (64
`provisional_model` + 29 `held`) targeting the 97-candidate/42-published-after-filtering set, and 122
difficulty rows (12 Easy / 99 Medium / 11 Hard) via a Calculus-specific regex classifier
(`assign_difficulty_calcab.py`), since — as anticipated — the generic verb list didn't fit Calculus phrasing.

Claude's independent cross-QA (`docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md`, PR #199)
re-verified every count, contamination check, and migration-file byte-fidelity claim from scratch against
Production and found them all correct. It also spot-checked unit-assignment reasoning and difficulty-band
placement against real item text and found the work generally strong, with three fixable issues:

1. `apcalcab-frq-005` held for `empty_required_units` — a Gemini model-output-extraction bug (its own prose
   evidence agreed with GPT-5.5's `required_units=[2,3]`/`primary_unit=3`, but its structured array came back
   empty).
2. `apcalcab-mcq-030` held for `model_unit_disagreement` — a narrow secondary-unit-tagging disagreement
   ([3] vs [2,3]), not a substantive one.
3. `apcalcab-frq-033` — a real rubric defect (`part-a-criterion-3` scored an operation part (a)'s stem never
   asked for) that also caused a difficulty misclassification (Easy, when the item is actually a non-routine
   existence-and-uniqueness proof — Hard).

All three were fixed 2026-09-26 (`docs/content/CLAUDE_CROSS_QA_FOLLOWUP_FIXES_APCALCAB_2026_09_26.md`):
both holds resolved with a new current label row superseding the held one; `apcalcab-frq-033`'s stem reworded
to match its (correct) rubric criterion, and its difficulty corrected to Hard (corroborated independently by
the item's own authored `prompt_json.difficulty` field, which already said Hard). `apcalcab-frq-033`'s
serving-label hold was deliberately left in place — resolving it requires re-running the two-model label
pipeline against the now-corrected stem, not a hand-typed guess. PRs #197, #199, and the follow-up fix PR are
merged.

- Label target: 42 published items after filtering (36 clean + 6 Group A analog — see the run report for
  exact composition). Post-fix current-row state for the full live AP Calculus AB pack (128 items): 72
  `provisional_model`, 43 `held`, 9 `validated` (untouched), 3 `legacy_unvalidated` (untouched, non-published
  exclusions) — the two resolved holds moved from `held` to `provisional_model`.
- Difficulty target: 122 items (item-and-current-version published), 12 Easy / 99 Medium / 11 Hard, 1
  corrected to Hard post-fix.

## AP Precalculus (Claude's half) — in progress

Started this session. See follow-up commits/PR for progress; this doc will be updated (or a closing status
doc added) once Claude's half lands, mirroring Pair 1's status-doc pattern.

- Label target: ~54 items before published-filtering (20 no-current-row + 28 `legacy_unvalidated` + 6
  `stale`).
- Difficulty target: 117 items (item-and-current-version published), 0 existing rows, no CSV yet — same
  build-a-classifier-first requirement as Calculus AB.

## Not started

- Cross-QA of either half (required before Pair 2 is closed, per the paired plan).
- Pair 3 (AP Physics 1 + AP Physics 2), Pair 4 (AP Physics C: Mechanics + AP Physics C: E&M), and AP
  Calculus BC (solo or paired with whichever finishes first).
