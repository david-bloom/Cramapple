-- Staging bridge: keep review assignments alive during content ingestion.
--
-- Migration 202606260002 created content_review_assignments and
-- content_review_decisions with generic `id` PKs and required
-- content_item_version_id (NOT NULL). That blocked assignment creation
-- during intake, before content is promoted to a content_item_version.
--
-- This migration:
--   1. Renames PKs and FK columns to explicit names (matches edge-function API).
--   2. Makes content_item_version_id nullable on both tables so assignments
--      can be created against staging rows and promoted later.
--   3. Adds ingest_row_id to assignments (FK → content_ingest_rows).
--   4. Adds review_kind ('frq'|'mcq') back to assignments.
--   5. Replaces the broken unique constraint with two partial indexes.
--   6. Adds frq_form ('short'|'long') to content_ingest_rows so the parser
--      writes the canonical distinction at intake time.

begin;

-- ── 1. Rename PKs and FK columns ─────────────────────────────────────────────

alter table app.content_review_assignments
  rename column id to content_review_assignment_id;

alter table app.content_review_decisions
  rename column id to content_review_decision_id;

-- The FK column in decisions that points back to assignments.
alter table app.content_review_decisions
  rename column assignment_id to content_review_assignment_id;

-- ── 2. Make content_item_version_id nullable ──────────────────────────────────
--
-- Assignments are created during staging (ingest_row exists, no
-- content_item_version yet). Decisions must allow the same because a
-- reviewer may submit before promotion.

alter table app.content_review_assignments
  alter column content_item_version_id drop not null;

alter table app.content_review_decisions
  alter column content_item_version_id drop not null;

-- ── 3. Add ingest_row_id to assignments ───────────────────────────────────────
--
-- Links the assignment to the staging row it was created from.
-- Set null on cascade so a deleted ingest row does not orphan the assignment
-- once it has been promoted (content_item_version_id will be set by then).

alter table app.content_review_assignments
  add column if not exists ingest_row_id uuid
    references app.content_ingest_rows(ingest_row_id) on delete set null;

create index if not exists cra_ingest_row_idx
  on app.content_review_assignments (ingest_row_id)
  where ingest_row_id is not null;

-- ── 4. Add review_kind to assignments ────────────────────────────────────────

alter table app.content_review_assignments
  add column if not exists review_kind text
    check (review_kind is null or review_kind in ('frq', 'mcq'));

-- ── 5. Fix unique constraint ──────────────────────────────────────────────────
--
-- The prior cra_unique_active_assignment was on
-- (content_item_version_id, reviewer_id, review_stage). With
-- content_item_version_id now nullable, NULLs are not comparable and
-- staging assignments would have no deduplication.
--
-- Replace with two partial unique indexes:
--   - One per staging row (ingest_row_id set, content_item_version_id null)
--   - One per promoted content version (content_item_version_id set)

alter table app.content_review_assignments
  drop constraint if exists cra_unique_active_assignment;

create unique index if not exists cra_unique_by_ingest_row
  on app.content_review_assignments (ingest_row_id, reviewer_id, review_stage)
  where ingest_row_id is not null;

create unique index if not exists cra_unique_by_content_version
  on app.content_review_assignments (content_item_version_id, reviewer_id, review_stage)
  where content_item_version_id is not null;

-- ── 6. Add frq_form to content_ingest_rows ───────────────────────────────────
--
-- The upload parser now extracts the short/long distinction at intake time
-- so it is stored once and does not need to be inferred later.

alter table app.content_ingest_rows
  add column if not exists frq_form text
    check (frq_form is null or frq_form in ('short', 'long'));

commit;
