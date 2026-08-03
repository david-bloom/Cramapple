# AP Calculus AB + AP Calculus BC — Units 1-3 early-year FRQ batch (2026-08-03)

40 new, original FRQs authored from the sanctioned CED fact pack
(`docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`), scoped to Units 1-3 only
(Limits and Continuity; Differentiation: Definition and Fundamental
Properties; Differentiation: Composite, Implicit, and Inverse Functions) so
they're usable early in the school year. Units 1-3 are identical in scope
between AB and BC (no BC-only topics live there — those are confined to Unit
6.12/6.13, Unit 9, and Unit 10), but the two batches were authored
independently with distinct contexts/functions rather than shared items.

- `apcalcab-frq-u13-001` .. `-020` — AP Calculus AB.
- `apcalcbc-frq-u13-001` .. `-020` — AP Calculus BC.

Both sets follow the real Calc FRQ structure — **9 points per item, 3 or 4
lettered parts (2-5 points each)** — and hit the requested difficulty mix:
**3 easy / 7 medium / 7 hard / 3 very hard** per subject (20 each, 40 total).
Each item is tagged `calculator: required` or `not_permitted` (mostly
no-calculator symbolic/algebraic work, with a handful of table-driven
numerical-estimation items, consistent with Units 1-3 content).

## Files

- `calcab_items.json`, `calcbc_items.json` — the authored content (stimulus,
  parts, prompts, per-point rubric criteria as `[text, evidence, fix]`
  triples). Source of truth; hand-verified for correct, checkable calculus
  (limits, derivatives, continuity/discontinuity claims) and CED scope (no
  Unit 4+ content — no related rates, optimization, integration, differential
  equations, parametric/polar/vector, or sequences/series).
- `generate-sql.mjs` — generates the two batch SQL files and `manifest.json`
  from the JSON above. Deterministic UUIDs (md5-seeded on `content_key`), so
  reruns are stable/idempotent.
- `apcalcab-units1-3-frq-batch.sql`, `apcalcbc-units1-3-frq-batch.sql` —
  generated insert scripts (`app.content_items` / `content_item_versions` /
  `frq_criteria`), one per subject.
- `manifest.json` — flat listing of every item's IDs, unit, difficulty,
  archetype, calculator regime, and point breakdown.

Regenerate after editing the JSON with:

```bash
node generate-sql.mjs
```

## Not yet verified against a live database

Same caveats as the sibling Stats/Precalc batch
(`scripts/content-seed/stats-precalc-units1-2-frq-2026-08-03/README.md`) —
this session had no authenticated database connection:

1. **Exactly one `published` `app.exam_pack_versions` row exists for each of
   `ap_calculus_ab` and `ap_calculus_bc`.** The scripts look this up
   dynamically at runtime and raise
   `expected_exactly_one_published_exam_pack_version` if that's not true —
   they do **not** hardcode an `exam_pack_version_id` — but that guard has
   only been read, not executed.
2. **No existing `content_key` collisions.** The `-u13-NNN` suffix was chosen
   to avoid clashing with whatever numbering scheme is already live for
   `apcalcab-frq-*` / `apcalcbc-frq-*`, but this hasn't been checked against
   the live table.
3. **Reviewer assignment.** This batch does **not** insert
   `app.content_review_assignments` rows — no reviewer_id was confirmed for
   AP Calculus AB/BC in this session (the activity log notes AB has active
   qualified reviewers but BC currently has none assigned at all). Items land
   as `content_items.status = 'draft'` /
   `content_item_versions.review_status = 'tutor_review_pending'`,
   unassigned. Assign to a qualified, active reviewer per subject before or
   after running this batch (see `scripts/content-seed/reviewer-management/`
   for the assignment-script pattern) — and resolve the BC reviewer gap
   first if it's still open.
4. **Schema/constraint drift.** Column names, check constraints, and enum
   values were read from `supabase/migrations/20260731160000_schema_baseline.sql`
   and cross-checked against the most recent working precedent, not queried
   live.

Run each batch inside a transaction against a non-production environment
first if at all possible, and re-verify items 1-2 above with a live query
before applying to production.
