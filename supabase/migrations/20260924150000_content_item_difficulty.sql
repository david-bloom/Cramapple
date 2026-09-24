-- M3 of the AP Biology completion plan (docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md).
-- D3, approved 2026-09-24 as DECISION-0061: three levels are operative;
-- four-level sources translate down non-destructively; store the per-item
-- attainment ratio, its source and the subject cut points alongside the band so
-- banding is re-derivable at read time.
--
-- APPLIED TO PRODUCTION 2026-09-24 on Product Owner authorisation, EMPTY.
-- Verified after: 0 rows, RLS enabled, one policy scoped to service_role, 0
-- grants to anon/authenticated/public, and `authenticated` functionally blocked.
-- The Biology data load is a separate step and remains blocked -- see "What
-- blocks the data load" below.
--
-- NOTE FOR ANY FUTURE app-SCHEMA TABLE, INCLUDING canonical_answer_spans.
-- Production carries ALTER DEFAULT PRIVILEGES granting content_reviewer SELECT
-- on every new table in the app schema (pg_default_acl shows
-- {content_reviewer=r/postgres} for objtype 'r'). Dev does NOT. So a grant you
-- did not write appears automatically on Production. It is inert here because
-- RLS is enabled with a service_role-only policy, so content_reviewer's SELECT
-- returns zero rows -- but anyone adding a broader RLS policy later would
-- activate it silently. Check pg_default_acl before assuming a new table's
-- grants match what its migration says.
--
-- ---------------------------------------------------------------------------
-- Why a table rather than prompt_json keys
--
-- Following the precedent just set by DECISION-0060 for credited-response
-- spans. DECISION-0061 requires five facts per item (band, ratio, ratio source,
-- subject cut points, and the raw prior value), and prompt_json is read by
-- evaluate-attempt on every attempt while already carrying topic, hand_drawn,
-- expected_graph_spec and more. Five more keys per item bloats a hot blob.
--
-- This is a choice made by precedent, not a decision that was separately asked.
-- The table is applied but EMPTY, so the shape can still be changed cheaply if
-- the Product Owner prefers a different one.
--
-- Note the existing 838 items across nine other subjects carry only a bare
-- prompt_json.difficulty, with no ratio and no provenance. Those are legacy and
-- are work order J's to reconcile into this table; this migration does not
-- touch them.
--
-- ---------------------------------------------------------------------------
-- Non-destructive translation (DECISION-0061 point 3)
--
-- source_value holds the raw string as found before any translation -- including
-- 'Very Hard', 'Easy-Medium' and the casing variants. difficulty holds the
-- operative three-level band. Collapsing is reversible while source_value
-- survives and irreversible the moment it does not, which is the whole point.
-- For Biology source_value is null: Biology carries no existing difficulty
-- value, so there is nothing to translate. That is why it is the clean subject
-- to prove this shape on.

create table if not exists app.content_item_difficulty (
  content_item_difficulty_id uuid primary key default gen_random_uuid(),

  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,

  -- the operative band. Three levels, per DECISION-0061.
  difficulty text not null
    check (difficulty = any (array['Easy', 'Medium', 'Hard'])),

  -- how this band was arrived at
  basis text not null
    check (basis = any (array[
      'calibrated_task_verb',   -- verb mapped to measured CRR attainment
      'calibrated_judgement',   -- method applied, no verb anchor available
      'translated',             -- collapsed from a four-level source value
      'normalised_casing',      -- same label, written differently
      'undetermined'
    ])),

  -- DECISION-0061 point 4: the band must be re-derivable, so the continuous
  -- score it was cut from is stored, not discarded. Nullable because some items
  -- have no attainment anchor -- an honest null with an explaining basis beats a
  -- fabricated number, which would look re-derivable and not be.
  attainment_ratio numeric,
  ratio_source text,
  subject_cut_points jsonb,

  -- DECISION-0061 point 3: the raw value as found, before translation.
  source_value text,

  rationale text,
  confidence text
    check (confidence is null or confidence = any (array['high', 'medium', 'low'])),

  proposal_run text not null,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),

  unique (content_item_version_id)
);

create index if not exists content_item_difficulty_band_idx
  on app.content_item_difficulty (difficulty);

alter table app.content_item_difficulty enable row level security;

-- Difficulty is NOT answer-key material -- unlike canonical_answer_spans, a
-- student learning an item is "Hard" reveals nothing about the answer. But
-- nothing reads it yet either, so it starts service_role-only and a read grant
-- is added when a real consumer exists, rather than being opened speculatively.
drop policy if exists "content_item_difficulty_service_all"
  on app.content_item_difficulty;
create policy "content_item_difficulty_service_all"
on app.content_item_difficulty
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.content_item_difficulty to service_role;

comment on table app.content_item_difficulty is
  'Per-item difficulty: the operative three-level band plus the attainment ratio, cut points and raw prior value it was derived from, so banding stays re-derivable at read time. DECISION-0061.';

-- ---------------------------------------------------------------------------
-- WHAT BLOCKS THE BIOLOGY DATA LOAD
--
-- docs/research/apbio_difficulty_calibration_2026_09_22/apbio_difficulty_assignments.csv
-- holds all 118 Biology bands, but its columns are only
-- content_key, item_type, difficulty, basis, rationale. THERE IS NO RATIO.
-- The continuous score was computed during calibration and discarded -- which
-- is precisely the gap Project 3 work order J.1b was written to stop, and
-- Biology predates it.
--
-- Two further facts from that file:
--   - 81 of 118 carry basis 'task verb', whose ratio COULD be reconstructed by
--     joining the recorded verbs to crr_calibration_all_subjects.csv;
--   - 37 of 118 carry basis 'judgement', which has no attainment anchor at all,
--     so no ratio exists for them even in principle under this method.
--
-- The right fix is NOT for QA to reconstruct the ratios -- that would make the
-- QA model the author of the numbers it then verifies. It is a small, well
-- specified regeneration for Codex: re-run assign_difficulty.py for Biology
-- emitting attainment_ratio, ratio_source and subject_cut_points per item, and
-- leaving the ratio null with basis 'calibrated_judgement' where no anchor
-- exists. 118 items, the method already written.
--
-- Until that lands, loading bands here with 118 null ratios would ship Biology
-- as the one subject that does not carry the thing DECISION-0061 exists for.
--
-- ---------------------------------------------------------------------------
-- Verification, once the store is applied (before any data):
--
--   select count(*) from app.content_item_difficulty;                  -- expect 0
--   select relrowsecurity from pg_class
--     where oid = 'app.content_item_difficulty'::regclass;             -- expect true
--   select count(*) from information_schema.role_table_grants
--     where table_schema='app' and table_name='content_item_difficulty'
--       and grantee in ('anon','authenticated','public');              -- expect 0
--
-- And after the data load:
--   -- 118 of 118 published Biology items carry exactly one row
--   -- every difficulty is in ('Easy','Medium','Hard')
--   -- every row with basis 'calibrated_task_verb' carries a non-null ratio
--   -- source_value is null for all 118 (Biology had no prior value)
