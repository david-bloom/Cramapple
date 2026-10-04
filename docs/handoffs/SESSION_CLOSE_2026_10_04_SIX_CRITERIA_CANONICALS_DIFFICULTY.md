# Session Close — 2026-10-04 (six-criteria re-run, Calc AB canonicals, difficulty inheritance)

**Session:** Claude Code, cloud. Branch `claude/cramapple-launch-readiness-1q9dcq`.
**Next owner:** David Bloom.
**Single best next action:** none blocking from this session. Optional follow-up: add `derived_from_content_item_id`
/ `family_key` provenance columns (seeded-item protocol §7). That way new variants inherit difficulty through a
query instead of a key pattern, and DECISION-0096's forward rule can be checked automatically.

## 1. What was asked

1. "Have all subjects gone through the checklist?" The repo's checklist has **six** servability criteria
   (`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`); no seven-point checklist exists in current docs.
2. Re-run the six-criteria check, record it, and write the missing Calc AB canonical answers.
3. Make MCQ variants inherit their seed's difficulty, rating seeds first where needed (DECISION-0096); then extend
   the rule to FRQ variants.

## 2. What changed

| Change | Record | PR |
|---|---|---|
| 2026-10-04 six-criteria re-run section | `SUBJECT_SERVABILITY_CRITERIA.md` | #327 |
| Canonical answers + spans for 20 Calc AB Unit 1 FRQs (`apcalcab-frq-u1n-001..005`, `u1v-001..005-v1..v3`); 20 human-validated serving labels carried forward to the new hash | migration `20261004120000`, APPROVAL-0116 | #327 |
| 31 seeds rated (28 Calc AB Unit 2–3 originals, 3 Precalculus); 733 MCQ variants and 278 Calc BC copies inherit their seed's band | migration `20261004130000`, DECISION-0096, APPROVAL-0117 | #328 |
| Last unrated FRQ variant (`apcalcab-frq-u1v-001-v2`) inherits Medium from its seed | migration `20261004140000`, DECISION-0096 (extended) | #328 |

All three migrations are applied to Production and recorded in the ledger under their file versions.

## 3. Verified (Production, after commit)

- **Criterion 4:** 0 published Calc AB FRQs without a canonical. All 20 new canonicals are MD5-identical to the
  independently reviewed text. 140 spans. All 20 labels are validated and hash-fresh, with their original
  validation records. All 20 are still served by `select_unit_gated_practice_items`.
- **Criterion 5:** every published item in all 10 subjects has a band: **FRQ 572/572, MCQ 1,718/1,718**.
- **Criteria 1, 2, 6:** hold in every subject (one live pack version each, unchanged from 2026-09-28).
- Each Production write was rehearsed first on Production with a forced rollback, and confirmed afterwards to have
  left nothing behind.

## 4. Open

- **Criterion 3 (validated serving labels)** is still partial in every subject, by design of TASK-0042's two-model
  pipeline. The flat practice path does not need it; unit-gated practice does. The largest gaps are FRQ labels in
  Calc BC, Chemistry, Precalculus and Physics.
- **Seed links are not in the database.** Inheritance resolved seeds from content keys (`-sv-<n>-vK` → `-<n>`;
  `-u<U>v-<n>-vK` → `-u<U>n-<n>`; `-u<U>n-<n>-vK` → `-u<U>n-<n>`; `apcalcbc-mcq-ab-<rest>` → `apcalcab-mcq-<rest>`).
  These match every batch manifest. A future batch with a new naming scheme would not match.
- **The 9 low-confidence seed bands** (raters disagreed by one band, resolved upward) are listed in APPROVAL-0117.
  They are candidates for re-rating once attempt data exists.
- **Hygiene, not served:** 2–23 items per subject are `published` at item level with no published version.
  DECISION-0095 chose not to rescan.
- **Carried over from earlier sessions, untouched here:** coupon checkout end to end on the live surface; fresh
  independent QA of TASK-0051 + TASK-0056; the TASK-0051 Production gate.

## 5. Approval state

APPROVAL-0116 and APPROVAL-0117: used and complete. Nothing pending from this session.

## 6. Do not touch

- Do not re-run `20261004130000` or `20261004140000` against environments where they are already recorded. Their
  preconditions refuse it, but check the ledger first.
- Do not re-rate the 31 seeds without updating their variants. A variant's band is a copy of its seed's; changing
  the seed alone breaks the rule.
