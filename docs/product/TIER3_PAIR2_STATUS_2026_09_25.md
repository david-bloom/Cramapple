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

## AP Calculus AB (Codex's half) — task handed off, not yet started

`docs/content/CODEX_TASK_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md` (v1, not yet preflighted by
Codex — expect a discrepancy pass like Chemistry's v1→v4 the first time Codex actually runs it). Paste-ready
prompt is in that doc. Key difference from Pair 1: **there is no existing difficulty-assignment CSV for
Calculus AB** — the task requires building and validating a task-verb (or subject-specific regex) classifier
from scratch, following the documented method in
`docs/research/apbio_difficulty_calibration_2026_09_22/README.md`, before any load can happen.

- Label target: ~97 items before published-filtering (34 no-current-row + 46 `legacy_unvalidated` + 17
  `stale`), expected to shrink once filtered to published-only, the way Chemistry's 55 became 42.
- Difficulty target: 122 items (item-and-current-version published), 0 existing rows, no CSV yet.

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
