# AP Statistics + AP Precalculus — Units 1-2 early-year FRQ batch (2026-08-03)

40 new, original FRQs authored from the sanctioned CED fact packs
(`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`,
`docs/product/AP_PRECALCULUS_CED_FACT_PACK.md`), scoped to Units 1-2 only so
they're usable early in the school year before later units are taught.

- `apstats-frq-u12-001` .. `-020` — AP Statistics, Units 1-2 (one-variable
  data/collecting data; probability, random variables, probability
  distributions). 10 points each, part counts vary by item.
- `apprecalc-frq-u12-001` .. `-020` — AP Precalculus, Units 1-2 (polynomial &
  rational functions; exponential & logarithmic functions). Exactly 6 points
  each, exactly 3 parts of 2 points, per the real CED FRQ structure.

Both sets hit the requested difficulty mix: **3 easy / 7 medium / 7 hard / 3
very hard** per subject (20 each, 40 total).

## Files

- `stats_items.json`, `precalc_items.json` — the authored content (stimulus,
  parts, prompts, per-point rubric criteria as `[text, evidence, fix]`
  triples). Source of truth; hand-verified for internally consistent
  arithmetic/algebra and CED scope (no Unit 3+ content in either subject).
- `generate-sql.mjs` — generates the two batch SQL files and `manifest.json`
  from the JSON above. Deterministic UUIDs (md5-seeded on `content_key`), so
  reruns are stable/idempotent.
- `apstats-units1-2-frq-batch.sql`, `apprecalc-units1-2-frq-batch.sql` —
  generated insert scripts (`app.content_items` / `content_item_versions` /
  `frq_criteria`), one per subject.
- `manifest.json` — flat listing of every item's IDs, unit, difficulty,
  archetype, and point breakdown.

Regenerate after editing the JSON with:

```bash
node generate-sql.mjs
```

## Not yet verified against a live database

This session had no authenticated database connection (Supabase MCP is
unauthenticated here), so the following were **not** checked live and must be
confirmed before running the SQL in any environment:

1. **Exactly one `published` `app.exam_pack_versions` row exists for each of
   `ap_statistics` and `ap_precalculus`.** The scripts look this up
   dynamically at runtime and raise `expected_exactly_one_published_exam_pack_version`
   if that's not true — they do **not** hardcode an `exam_pack_version_id` —
   but that guard has only been read, not executed.
2. **No existing `content_key` collisions.** The `-u12-NNN` suffix was chosen
   specifically to avoid clashing with whatever numbering scheme is already
   live for `apstats-frq-*` / `apprecalc-frq-*`, but this hasn't been checked
   against the live table.
3. **Reviewer assignment.** Unlike the physics-frq-full-scale precedent, this
   batch does **not** insert `app.content_review_assignments` rows — no
   reviewer_id was confirmed for AP Statistics/Precalculus in this session.
   Items land as `content_items.status = 'draft'` /
   `content_item_versions.review_status = 'tutor_review_pending'`, unassigned.
   Assign to a qualified, active reviewer for each subject before or after
   running this batch (see `scripts/content-seed/reviewer-management/` for
   the assignment-script pattern).
4. **Schema/constraint drift.** Column names, check constraints, and enum
   values were read from `supabase/migrations/20260731160000_schema_baseline.sql`
   (the newest baseline in this checkout) and cross-checked against the most
   recent working precedent (`publication/20260802_decision_0044_universal_publish_rule.sql`,
   `physics-frq-full-scale-2026-07-25/`), but the live production schema was
   not queried directly.

Run each batch inside a transaction against a non-production environment
first if at all possible, and re-verify item 1-2 above with a live query
before applying to production.
