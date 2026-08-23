-- Course Mode F4 — generated-instance -> servable-content path (schema).
--
-- Implements the DDL for plan step F4 (COURSE_MODE_PILOT_BUILD_PLAN.md), the
-- pivotal enabler flagged by CM-FACT-20: today a generated item's
-- deterministic_checks are dropped at DB load, there is no data-driven verifier,
-- and there is no item->cell tag. This migration adds the two tables and the
-- evaluator_strategy value those gaps require. The generic verifier itself lives
-- in supabase/functions/_shared/deterministic-verifier.ts.
--
-- SCOPE: this is "F4 core" only. It deliberately does NOT add the CM-D19
-- template-release machine-stamping (gated on D8 "release bars", ON HOLD pending
-- David). It also does not build the F2 cell mastery store or the F3 classifier;
-- these tables make a generated instance gradeable + cell-tagged, not yet
-- mastery-updating.
--
-- Home table note: per D4 and the 2026-08-23 schema convergence, generated item
-- packages live in app.content_item_versions.item_package_payload. That table is
-- a "deprecated compatibility projection" (new authoring targets
-- app.artifact_versions), but the pilot deliberately builds on it because that is
-- where item_package_payload was converged into both Dev and Prod. If/when the
-- pilot moves to artifact_versions, these FKs move with it.
--
-- Rights/governance: adds no content and releases nothing. Generated items remain
-- release_status 'unreleased_generated_pending_review' under CM-D19; the AP Stats
-- §3/§10 tags remain under the D2 SME gate.

-- ---------------------------------------------------------------------------
-- F4 part 1 — persist per-instance deterministic checks.
-- Keyed by (content_item_version_id, criterion_key). NOT app.frq_criteria, which
-- is a deprecated compatibility projection (schema_baseline) and has no checks
-- column. The generic verifier reads `checks` to grade any generated instance
-- without per-content_key TypeScript.
-- ---------------------------------------------------------------------------
create table if not exists app.content_item_checks (
  content_item_check_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  criterion_key text not null,
  checks jsonb not null,
  check_schema_version text not null default 'course-mode-generated-0.1',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (content_item_version_id, criterion_key),
  constraint content_item_checks_payload_is_array
    check (jsonb_typeof(checks) = 'array'),
  constraint content_item_checks_payload_nonempty
    check (jsonb_array_length(checks) >= 1)
);

comment on table app.content_item_checks is
  'F4: per-(version, criterion) deterministic check specs (interval/numeric/mcq_key/...) '
  'emitted by a generator and read by the data_driven_deterministic verifier at grading '
  'time. Survives DB load, unlike the dropped item-package deterministic_checks (CM-FACT-20).';

alter table app.content_item_checks enable row level security;
grant select, insert, update, delete on app.content_item_checks to service_role;
-- No authenticated grant: raw checks are grading-internal, never student-facing.

create index if not exists content_item_checks_version_idx
  on app.content_item_checks using btree (content_item_version_id);

-- ---------------------------------------------------------------------------
-- F4 part 3 — item -> cell tag (D3).
-- A dedicated table rather than a new app.content_taxonomy_labels scope: that
-- table's scope CHECK allows only 'serving'/'coverage' and its payload columns
-- (required_units / assessed_topics) are unit/topic-shaped, not (topic x skill).
-- The composite FK to app.taxonomy_cells guarantees every tag is a REAL
-- registered cell for its taxonomy version (INV: cannot tag a nonexistent cell).
-- Emission-time authoritative (written from the generator/intake), validated here.
-- ---------------------------------------------------------------------------
create table if not exists app.content_item_cells (
  content_item_cell_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  content_item_id uuid not null
    references app.content_items(id) on delete cascade,
  taxonomy_source_version uuid not null
    references app.taxonomy_source_versions(taxonomy_source_version) on delete restrict,
  topic_code text not null,
  skill_code text not null,
  created_at timestamptz not null default now(),
  unique (content_item_version_id, topic_code, skill_code),
  foreign key (taxonomy_source_version, topic_code, skill_code)
    references app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
    on delete restrict
);

comment on table app.content_item_cells is
  'F4/D3: maps a content item version to the (topic x skill) cell(s) it assesses, '
  'keyed by UUID taxonomy_source_version (never raw subject_key). Composite FK to '
  'app.taxonomy_cells enforces that every tag is a registered cell. This is the '
  'item->cell tag the DB previously lacked (CM-FACT-20).';

alter table app.content_item_cells enable row level security;
grant select, insert, update, delete on app.content_item_cells to service_role;
-- No authenticated grant: cell tags are internal (INV-1 "store fine, present coarse");
-- student-facing roll-ups are served later via F2/F3 functions, not this raw table.

create index if not exists content_item_cells_version_idx
  on app.content_item_cells using btree (content_item_version_id);
create index if not exists content_item_cells_cell_idx
  on app.content_item_cells using btree (taxonomy_source_version, topic_code, skill_code);

-- ---------------------------------------------------------------------------
-- F4 part 2 — generic data-driven evaluator strategy.
-- Extend the allowlist so a generated instance can be graded by reading its
-- persisted content_item_checks, with no per-content_key TypeScript (production
-- Stats grading is currently a hardcoded per-content_key map in
-- _shared/statistics-verifier.ts, which cannot scale to generated instances).
-- ---------------------------------------------------------------------------
alter table app.content_item_versions
  drop constraint if exists content_item_versions_evaluator_strategy_check;

alter table app.content_item_versions
  add constraint content_item_versions_evaluator_strategy_check
  check (
    evaluator_strategy is null
    or evaluator_strategy = any (array[
      'rule_based_mcq'::text,
      'llm_discrete_text'::text,
      'python_symbolic_ecf'::text,
      'human_shadow'::text,
      'data_driven_deterministic'::text
    ])
  );
