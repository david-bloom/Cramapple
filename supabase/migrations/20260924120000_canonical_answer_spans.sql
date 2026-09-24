-- M0 of the AP Biology completion plan (docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md).
-- DECISION-0060: credited-response segmentation is stored in a dedicated child
-- table, one row per span, NOT in prompt_json.
--
-- What this is for. A canonical answer is a block of text in
-- content_item_versions.canonical_answer_1/2. The segmentation records which
-- span of that text earns which rubric criterion, so Open Hand can strike
-- exactly the text earning a deselected point. Verified 2026-09-24: that
-- mapping had NO storage location anywhere in Production -- no column, no
-- table, and zero items carrying it in prompt_json -- while work orders A, B,
-- C, F and G had already produced thousands of criterion-tagged spans (work
-- order F alone produced 576 across 71 Biology items).
--
-- Why a table rather than a prompt_json key. A credited-response span is
-- ANSWER-KEY MATERIAL: a student who can read it knows which sentence earns
-- each point before submitting. prompt_json is read by evaluate-attempt on
-- every attempt and already carries topic, difficulty, hand_drawn and
-- expected_graph_spec. Enforcing RLS on a dedicated table is materially easier
-- to get right, and to verify, than hiding one key inside a blob the grader
-- must read. Cramapple already has an open exposure of exactly this class
-- (mcq_choices.is_correct readable by authenticated users), which is the
-- mistake this table is shaped to avoid repeating.
--
-- This migration creates the store EMPTY. No span data is written here; M1
-- does that, only after this shape and its RLS have been verified.

create table if not exists app.canonical_answer_spans (
  canonical_answer_span_id uuid primary key default gen_random_uuid(),

  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,

  -- which stored answer field this span belongs to
  answer_field text not null default 'canonical_answer_1'
    check (answer_field = any (array['canonical_answer_1', 'canonical_answer_2'])),

  -- position within that field; spans ordered by ordinal must concatenate
  -- back to the field exactly. That invariant is what QA recomputes.
  span_ordinal integer not null check (span_ordinal >= 0),
  span_text text not null,

  -- the criteria this span earns. Empty is legal and meaningful: assembly
  -- literals (paragraph breaks) and retained uncredited prose earn nothing.
  criterion_keys text[] not null default '{}',

  provenance text not null
    check (provenance = any (array[
      'drafted',
      'recovered_ca1',
      'recovered_ca2',
      'recovered_parent',
      'unchanged_from_prior_run',
      'assembly_literal'
    ])),

  -- where recovered text came from, so a span's claim stays checkable against
  -- Production after the fact. recovered_parent legitimately points at a
  -- DIFFERENT item's version (a split child citing its retired parent), so
  -- this is deliberately not constrained to the same content_item.
  source_version_id uuid references app.content_item_versions(id),
  source_field text
    check (source_field is null or source_field = any (array[
      'canonical_answer_1', 'canonical_answer_2',
      'parent_canonical_answer_1', 'parent_canonical_answer_2'
    ])),
  source_offset integer check (source_offset is null or source_offset >= 0),

  -- which proposal run produced this row, e.g. 'work_order_F_2026_09_23'
  proposal_run text not null,

  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),

  unique (content_item_version_id, answer_field, span_ordinal)
);

create index if not exists canonical_answer_spans_version_idx
  on app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal);

-- one of the reasons DECISION-0060 chose a table over a blob: answering
-- "which items have a span earning criterion X" must be a query, not a scan.
create index if not exists canonical_answer_spans_criterion_idx
  on app.canonical_answer_spans using gin (criterion_keys);

alter table app.canonical_answer_spans enable row level security;

-- service_role only. There is deliberately NO policy and NO grant for anon or
-- authenticated: this table is an answer key. If a student-facing surface ever
-- needs post-submission span data, it must come through a server-side function
-- that checks the attempt is already submitted -- never by granting read here.
drop policy if exists "canonical_answer_spans_service_all"
  on app.canonical_answer_spans;
create policy "canonical_answer_spans_service_all"
on app.canonical_answer_spans
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.canonical_answer_spans to service_role;

comment on table app.canonical_answer_spans is
  'Credited-response segmentation: one row per span of a canonical answer, tagged with the rubric criteria it earns. DECISION-0060. ANSWER-KEY MATERIAL -- service_role only, never grant to anon or authenticated.';
