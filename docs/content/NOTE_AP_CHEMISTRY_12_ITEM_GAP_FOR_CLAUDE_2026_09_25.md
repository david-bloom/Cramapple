# Note for Claude — AP Chemistry 12-item gap / duplicate current serving labels (2026-09-25)

Codex began executing `docs/content/CODEX_TASK_AP_CHEMISTRY_TIER3_LABELS_DIFFICULTY_2026_09_25.md` and stopped before any Production writes because the work order's original 148-item live-pack baseline did not match current Production.

Production facts re-derived via Supabase MCP against project `pcntajvbdfqhbeewmdry`:

- AP Chemistry has one live pack version: `c9ca46b2-b529-4ed3-9741-dddea455ab9b` (`published`, `retired_at is null`).
- Live AP Chemistry item count is **136**, not 148.
- Item-level published count is **123**.
- Item + latest-version published difficulty target remains **119**.
- Current AP Chemistry difficulty rows on that 119-item target: **0**.

The apparent 12-item gap is not a second live pack/version issue. It is paired with a serving-label integrity anomaly: 12 AP Chemistry live-pack items currently have **two** current serving-label rows (`label_scope='serving' and superseded_by is null`), both `legacy_unvalidated`. That means the old 148 figure likely counted current serving-label rows, not distinct content items: 124 single-current-label items + 24 current rows across the 12 duplicated items = 148 current label rows. The task definition says an item should have exactly one current serving-label row, so Codex treated these as report-only integrity findings rather than silently fixing them.

Duplicate-current-label items:

- `apchem-frq-l-002`
- `apchem-frq-l-006`
- `apchem-frq-l-012`
- `apchem-frq-l-013`
- `apchem-frq-l-014`
- `apchem-mcq-001`
- `apchem-mcq-070`
- `apchem-sfrq-003`
- `apchem-sfrq-006`
- `apchem-sfrq-010`
- `apchem-sfrq-014`
- `apchem-sfrq-024`

Suggested handling:

1. Keep the Tier 3 label run scoped to the 48 clean single-current-label targets (14 clean `legacy_unvalidated` + 34 `stale`) unless David explicitly authorizes duplicate-current-label cleanup.
2. Treat the 12 duplicate-current-label items as a separate cleanup decision: inspect both current rows per item, decide which should be superseded or whether both should be replaced by a fresh model-generated current row, and record the before/after lineage.
3. Do not include those 12 in the normal pipeline run without adding explicit idempotency and supersession checks, because the pipeline assumes exactly one current row per item.

## Resolution (Claude, 2026-09-25, follow-up session)

Investigated all 12 directly against Production. Both current rows on every one of the 12 are empty
`legacy_unvalidated` placeholders (`required_units=[]`, no real classification) — so there's no real content
to adjudicate between the two rows on any item. The meaningful difference is `validated_against_version_id`:
each row was generated against a specific historical content version, and `superseded_by` was never set when
a newer content revision produced a new placeholder. That splits the 12 into two distinct situations:

- **Group A (7 items)** — the newer of the two rows matches the item's *current* content version; the older
  one is simply a stale leftover. A clean, unambiguous fix: supersede the older row.
  `apchem-frq-l-002`, `apchem-frq-l-006`, `apchem-frq-l-012`, `apchem-mcq-001`, `apchem-mcq-070`,
  `apchem-sfrq-006`, `apchem-sfrq-010`.
- **Group B (5 items)** — *neither* row matches the item's current content version (each has been revised
  again since, to content version 3 or 4, with zero labels ever generated against that current version).
  Superseding one stale duplicate doesn't actually fix anything here — these items have effectively had no
  label at all against their real current content for some time.
  `apchem-frq-l-013`, `apchem-frq-l-014`, `apchem-sfrq-003`, `apchem-sfrq-014`, `apchem-sfrq-024`.

**David's decision:** fold the 7 Group A items into this Tier 3 run (target set becomes 55, not 48) — see
`docs/content/CODEX_TASK_AP_CHEMISTRY_TIER3_LABELS_DIFFICULTY_2026_09_25.md` v3 for the updated target set
and the dual-supersession requirement for those 7. Set the 5 Group B items aside entirely as a separate,
documented gap — do not touch them in this task or any Tier 3 pipeline run; they need their own follow-up
(likely: generate a first real label against their actual current content version, the same as any
zero-current-row item, once someone decides to pick that up).
