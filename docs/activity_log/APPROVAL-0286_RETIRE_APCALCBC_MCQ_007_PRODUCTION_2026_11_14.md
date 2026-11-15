# APPROVAL-0286 — Retire `apcalcbc-mcq-007` (Newton's method), 2026-11-14

- **Date:** 2026-11-14.
- **Authorization:** David Bloom (Product Owner), in chat: "Retire 007", in answer to the question left open after APPROVAL-0285.
- **What is written (Production `pcntajvbdfqhbeewmdry`), one transaction:** the published item `apcalcbc-mcq-007` and its only version (version 1) are set to `retired`; any open review assignment on it is marked skipped (there were none).
- **Basis:** the item asks for one Newton iteration for x^3 - 2 = 0. The CED PDF text has zero occurrences of "Newton" (the same extraction finds "Euler" 5 times), so the item is outside the course description; it had no validated label and was never served. Recorded in `docs/qa/LABEL_UNITLESS_76_TRIAGE_2026_11_14.md`.
- **Checked before the write:** the item has exactly one version, no variants naming it as seed, no open review assignment and no validated serving label (the transaction asserts the first and last).
- **NOT changed:** any other item, any label or cell, schema, functions, frontends. Nothing is deleted; the row and its history stay.
- **Rollback:** set the item and its version back to `published` (the item has no labels, so it would stay unserved until labeled).
- **Numbering check:** highest APPROVAL on origin/main, open PRs and remote branches was 0285; this record takes 0286.
- **Rehearsal:** one `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record below.

## Execution record (2026-11-14)
- Transaction COMMITTED; read-back MATCH (item and version both `retired`). Fresh export of all ten subjects afterwards: the only published items missing a topic cell or serving label are the 176 Statistics MCQs that carry topic-by-skill cells and are served by the live selector (176/176 `topic_match` when checked earlier today).
