# Migration history archive

These files are **archived history**. They are not applied and not replayable.
The authoritative schema starts at `supabase/migrations/20260731160000_schema_baseline.sql`.

## Why this exists

Until 2026-07-31 the repo and Production carried two different migration
lineages. Production recorded 70 migrations under `YYYYMMDDHHMMSS` versions; the
repo held 58 files, 44 of them under a hand-numbered `YYYYMMDD####` scheme. The
same logical migration existed under different versions in each.

Production's schema could not be rebuilt from its own history. A clean replay
failed at migration 39 of 70 (`curated_public_interface`,
`column p.review_queue_scope does not exist`) — reproduced independently on a
Supabase branch and on a local PostgreSQL 17 cluster. Root cause: 11 objects
existed in Production that no migration in either lineage ever created, and 6
migrations assert app-authored content that no migration creates.

Rather than repair an unreplayable history, the schema was squashed to a
baseline verified equal to Production across 3,568 schema facts in 9 object
classes (columns, functions, views, policies, indexes, constraints, triggers,
grants, RLS flags) with zero differences.

## Contents

- `production-recorded/` — all 70 records from Production's
  `supabase_migrations.schema_migrations`, exported verbatim from the
  `statements` column. This is the authoritative record of what Production
  actually ran, and the backup that made rewriting Production's history table
  reversible.
- `repo-lineage/` — the 52 repo migration files superseded by the baseline.
  Retained for authorship context; 50 correspond to Production records under
  different version numbers, and 2 (`canonical_answer_on_versions`,
  `content_pipeline_state_machine`) were applied to Production by hand and never
  recorded.

## Rules from here

1. Schema changes are 14-digit forward migrations from `supabase migration new`.
2. Nothing applies DDL to Production except a reviewed repo migration via CLI —
   not the Studio SQL editor, not an agent's `apply_migration`. Every one of the
   11 hand-made objects arrived that way.
3. Content remediation runs as data scripts, never as migrations. Six migrations
   in `production-recorded/` are permanently unreplayable because they assert
   content counts.
4. A fresh replay must pass before any migration merges.
