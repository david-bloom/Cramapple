-- Taxonomy label layer for unit-gated serving and CED coverage remediation.
--
-- Implements the execution groundwork from TAXONOMY_LABELING_PLAN_V3_2026_08_04:
--   * taxonomy leaves immutable content_item_versions.prompt_json
--   * legacy prompt_json modules/subtopics are preserved as non-authoritative
--   * serving labels and coverage labels are separate scopes
--   * labels record the exact taxonomy-relevant content state they were
--     validated against, using a hash that includes choices and FRQ criteria

begin;

-- ── Registry ────────────────────────────────────────────────────────────────

create table app.taxonomy_source_versions (
  taxonomy_source_version uuid primary key default gen_random_uuid(),
  subject_key text not null,
  school_year text not null,
  source_title text not null,
  taxonomy_confidence text not null,
  source_citation text not null,
  source_uri text,
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  constraint taxonomy_source_versions_confidence_check
    check (taxonomy_confidence in ('verified', 'provisional')),
  constraint taxonomy_source_versions_subject_key_check
    check (char_length(btrim(subject_key)) > 0),
  constraint taxonomy_source_versions_school_year_check
    check (char_length(btrim(school_year)) > 0),
  constraint taxonomy_source_versions_unique
    unique (subject_key, school_year, source_title)
);

create table app.taxonomy_topics (
  taxonomy_topic_id uuid primary key default gen_random_uuid(),
  taxonomy_source_version uuid not null
    references app.taxonomy_source_versions(taxonomy_source_version)
    on delete restrict,
  unit_number integer not null,
  unit_title text not null,
  topic_code text not null,
  topic_title text not null,
  created_at timestamptz not null default now(),
  constraint taxonomy_topics_unit_check check (unit_number between 1 and 20),
  constraint taxonomy_topics_topic_code_check
    check (topic_code ~ '^[0-9]+\.[0-9]+$'),
  constraint taxonomy_topics_title_check
    check (
      char_length(btrim(unit_title)) > 0
      and char_length(btrim(topic_title)) > 0
    ),
  constraint taxonomy_topics_unique_code
    unique (taxonomy_source_version, topic_code)
);

create index taxonomy_topics_source_unit_idx
  on app.taxonomy_topics (taxonomy_source_version, unit_number, topic_code);

alter table app.taxonomy_source_versions enable row level security;
alter table app.taxonomy_source_versions force row level security;
alter table app.taxonomy_topics enable row level security;
alter table app.taxonomy_topics force row level security;

revoke all on app.taxonomy_source_versions from public, anon, authenticated;
revoke all on app.taxonomy_topics from public, anon, authenticated;
grant select, insert, update, delete on app.taxonomy_source_versions to service_role;
grant select, insert, update, delete on app.taxonomy_topics to service_role;

-- ── Content-state hash ──────────────────────────────────────────────────────

create or replace function app.taxonomy_relevant_hash(
  _content_item_version_id uuid
)
returns text
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select encode(
    extensions.digest(
      jsonb_build_object(
        'stem', civ.stem,
        'stimulus', civ.stimulus,
        'prompt_json', coalesce(civ.prompt_json, '{}'::jsonb)
          - 'modules'
          - 'subtopics',
        'canonical_answer_1', civ.canonical_answer_1,
        'canonical_answer_2', civ.canonical_answer_2,
        'mcq_choices', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'choice_key', mc.choice_key,
              'choice_text', mc.choice_text,
              'is_correct', mc.is_correct,
              'rationale', mc.rationale
            )
            order by mc.choice_key
          )
          from app.mcq_choices mc
          where mc.content_item_version_id = civ.id
        ), '[]'::jsonb),
        'frq_criteria', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'criterion_key', fc.criterion_key,
              'learner_facing_text', fc.learner_facing_text,
              'points_possible', fc.points_possible,
              'evidence_requirements', fc.evidence_requirements,
              'minimum_fix', fc.minimum_fix
            )
            order by fc.criterion_key
          )
          from app.frq_criteria fc
          where fc.content_item_version_id = civ.id
        ), '[]'::jsonb)
      )::text,
      'sha256'
    ),
    'hex'
  )
  from app.content_item_versions civ
  where civ.id = _content_item_version_id;
$$;

revoke all on function app.taxonomy_relevant_hash(uuid)
  from public, anon, authenticated;
grant execute on function app.taxonomy_relevant_hash(uuid) to service_role;

-- ── Labels ─────────────────────────────────────────────────────────────────

create table app.content_taxonomy_labels (
  content_taxonomy_label_id uuid primary key default gen_random_uuid(),
  content_item_id uuid not null
    references app.content_items(id) on delete cascade,
  label_version integer not null,
  label_scope text not null,
  validated_against_version_id uuid
    references app.content_item_versions(id) on delete restrict,
  validated_against_taxo_hash text,
  required_units integer[] not null default '{}'::integer[],
  max_required_unit integer,
  assessed_topics text[] not null default '{}'::text[],
  primary_unit integer,
  required_units_by_criterion jsonb,
  taxonomy_source_version uuid
    references app.taxonomy_source_versions(taxonomy_source_version)
    on delete restrict,
  taxonomy_confidence text,
  label_status text not null,
  source text not null default 'migration',
  source_payload jsonb not null default '{}'::jsonb,
  model_run_id text,
  input_packet_hash text,
  validation_decision_id uuid,
  validated_by uuid references app.profiles(user_id),
  validated_at timestamptz,
  superseded_by uuid references app.content_taxonomy_labels(content_taxonomy_label_id),
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  constraint content_taxonomy_labels_scope_check
    check (label_scope in ('serving', 'coverage')),
  constraint content_taxonomy_labels_status_check
    check (
      label_status in (
        'legacy_unvalidated',
        'provisional_model',
        'validated',
        'stale',
        'held'
      )
    ),
  constraint content_taxonomy_labels_confidence_check
    check (
      taxonomy_confidence is null
      or taxonomy_confidence in ('verified', 'provisional')
    ),
  constraint content_taxonomy_labels_units_check
    check (
      array_position(required_units, null) is null
      and (cardinality(required_units) = 0 or 0 < all(required_units))
      and (
        max_required_unit is null
        or max_required_unit = any(required_units)
      )
      and (primary_unit is null or primary_unit > 0)
    ),
  constraint content_taxonomy_labels_scope_payload_check
    check (
      (label_scope = 'serving' and cardinality(assessed_topics) = 0)
      or (label_scope = 'coverage' and cardinality(required_units) = 0)
    ),
  constraint content_taxonomy_labels_validation_check
    check (
      (label_status = 'validated') =
      (
        validated_by is not null
        and validated_at is not null
        and validation_decision_id is not null
        and validated_against_version_id is not null
        and validated_against_taxo_hash is not null
      )
    ),
  constraint content_taxonomy_labels_criterion_shape_check
    check (
      required_units_by_criterion is null
      or jsonb_typeof(required_units_by_criterion) = 'array'
    ),
  constraint content_taxonomy_labels_source_payload_shape_check
    check (jsonb_typeof(source_payload) = 'object'),
  constraint content_taxonomy_labels_unique_version
    unique (content_item_id, label_scope, label_version)
);

create index content_taxonomy_labels_item_scope_idx
  on app.content_taxonomy_labels (content_item_id, label_scope, label_status);

create index content_taxonomy_labels_serving_validated_idx
  on app.content_taxonomy_labels (content_item_id, max_required_unit)
  where label_scope = 'serving'
    and label_status = 'validated'
    and superseded_by is null;

create index content_taxonomy_labels_coverage_validated_idx
  on app.content_taxonomy_labels using gin (assessed_topics)
  where label_scope = 'coverage'
    and label_status = 'validated'
    and superseded_by is null;

create index content_taxonomy_labels_stale_idx
  on app.content_taxonomy_labels (label_status, created_at)
  where label_status in ('legacy_unvalidated', 'stale', 'held');

alter table app.content_taxonomy_labels enable row level security;
alter table app.content_taxonomy_labels force row level security;
revoke all on app.content_taxonomy_labels from public, anon, authenticated;
grant select, insert, update, delete on app.content_taxonomy_labels to service_role;

create or replace function app.set_content_taxonomy_label_derived_fields()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
declare
  v_max integer;
begin
  if new.label_scope = 'serving' then
    select max(unit_number)
      into v_max
    from unnest(new.required_units) as units(unit_number);
    new.max_required_unit := v_max;
  else
    new.required_units := '{}'::integer[];
    new.max_required_unit := null;
    new.primary_unit := null;
    new.required_units_by_criterion := null;
  end if;

  if new.label_status <> 'validated' then
    new.validated_by := null;
    new.validated_at := null;
    new.validation_decision_id := null;
  end if;

  return new;
end;
$$;

create trigger tg_content_taxonomy_labels_derive
  before insert or update on app.content_taxonomy_labels
  for each row execute function app.set_content_taxonomy_label_derived_fields();

create or replace function app.mark_content_taxonomy_labels_stale_for_version(
  _content_item_version_id uuid
)
returns void
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_content_item_id uuid;
  v_taxo_hash text;
begin
  select civ.content_item_id, app.taxonomy_relevant_hash(civ.id)
    into v_content_item_id, v_taxo_hash
  from app.content_item_versions civ
  where civ.id = _content_item_version_id;

  if v_content_item_id is null or v_taxo_hash is null then
    return;
  end if;

  update app.content_taxonomy_labels ctl
  set label_status = 'stale'
  where ctl.content_item_id = v_content_item_id
    and ctl.superseded_by is null
    and ctl.label_status in ('validated', 'provisional_model')
    and ctl.validated_against_taxo_hash is distinct from v_taxo_hash;
end;
$$;

revoke all on function app.mark_content_taxonomy_labels_stale_for_version(uuid)
  from public, anon, authenticated;
grant execute on function app.mark_content_taxonomy_labels_stale_for_version(uuid)
  to service_role;

create or replace function app.mark_content_taxonomy_labels_stale_from_version_trigger()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  perform app.mark_content_taxonomy_labels_stale_for_version(new.id);
  return new;
end;
$$;

create trigger tg_content_versions_taxonomy_stale
  after insert or update of stem, stimulus, prompt_json,
    canonical_answer_1, canonical_answer_2
  on app.content_item_versions
  for each row execute function app.mark_content_taxonomy_labels_stale_from_version_trigger();

create or replace function app.mark_content_taxonomy_labels_stale_from_child_trigger()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
declare
  v_content_item_version_id uuid;
begin
  if tg_op = 'DELETE' then
    v_content_item_version_id := old.content_item_version_id;
  else
    v_content_item_version_id := new.content_item_version_id;
  end if;

  perform app.mark_content_taxonomy_labels_stale_for_version(v_content_item_version_id);
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$$;

create trigger tg_mcq_choices_taxonomy_stale
  after insert or update or delete on app.mcq_choices
  for each row execute function app.mark_content_taxonomy_labels_stale_from_child_trigger();

create trigger tg_frq_criteria_taxonomy_stale
  after insert or update or delete on app.frq_criteria
  for each row execute function app.mark_content_taxonomy_labels_stale_from_child_trigger();

-- ── AP Biology verified registry seed ───────────────────────────────────────

with source_row as (
  insert into app.taxonomy_source_versions (
    subject_key,
    school_year,
    source_title,
    taxonomy_confidence,
    source_citation,
    verified_at
  ) values (
    'ap_biology',
    '2026-2027',
    'AP Biology Course and Exam Description, Effective Fall 2025',
    'verified',
    'AP Biology CED Effective Fall 2025, pp. 17, 20-22, 197-203; verified 2026-08-04',
    '2026-08-04 00:00:00+00'::timestamptz
  )
  on conflict (subject_key, school_year, source_title) do update
    set taxonomy_confidence = excluded.taxonomy_confidence,
        source_citation = excluded.source_citation,
        verified_at = excluded.verified_at
  returning taxonomy_source_version
)
insert into app.taxonomy_topics (
  taxonomy_source_version,
  unit_number,
  unit_title,
  topic_code,
  topic_title
)
select source_row.taxonomy_source_version, topic.unit_number, topic.unit_title,
       topic.topic_code, topic.topic_title
from source_row
cross join (values
  (1, 'Chemistry of Life', '1.1', 'Structure of Water and Hydrogen Bonding'),
  (1, 'Chemistry of Life', '1.2', 'Elements of Life'),
  (1, 'Chemistry of Life', '1.3', 'Introduction to Macromolecules'),
  (1, 'Chemistry of Life', '1.4', 'Carbohydrates'),
  (1, 'Chemistry of Life', '1.5', 'Lipids'),
  (1, 'Chemistry of Life', '1.6', 'Nucleic Acids'),
  (1, 'Chemistry of Life', '1.7', 'Proteins'),
  (2, 'Cells', '2.1', 'Cell Structure and Function'),
  (2, 'Cells', '2.2', 'Cell Size'),
  (2, 'Cells', '2.3', 'Plasma Membrane'),
  (2, 'Cells', '2.4', 'Membrane Permeability'),
  (2, 'Cells', '2.5', 'Membrane Transport'),
  (2, 'Cells', '2.6', 'Facilitated Diffusion'),
  (2, 'Cells', '2.7', 'Tonicity and Osmoregulation'),
  (2, 'Cells', '2.8', 'Mechanisms of Transport'),
  (2, 'Cells', '2.9', 'Cell Compartmentalization'),
  (2, 'Cells', '2.10', 'Origins of Cell Compartmentalization'),
  (3, 'Cellular Energetics', '3.1', 'Enzymes'),
  (3, 'Cellular Energetics', '3.2', 'Environmental Impacts on Enzyme Function'),
  (3, 'Cellular Energetics', '3.3', 'Cellular Energy'),
  (3, 'Cellular Energetics', '3.4', 'Photosynthesis'),
  (3, 'Cellular Energetics', '3.5', 'Cellular Respiration'),
  (4, 'Cell Communication and Cell Cycle', '4.1', 'Cell Communication'),
  (4, 'Cell Communication and Cell Cycle', '4.2', 'Introduction to Signal Transduction'),
  (4, 'Cell Communication and Cell Cycle', '4.3', 'Signal Transduction Pathways'),
  (4, 'Cell Communication and Cell Cycle', '4.4', 'Feedback'),
  (4, 'Cell Communication and Cell Cycle', '4.5', 'Cell Cycle'),
  (4, 'Cell Communication and Cell Cycle', '4.6', 'Regulation of Cell Cycle'),
  (5, 'Heredity', '5.1', 'Meiosis'),
  (5, 'Heredity', '5.2', 'Meiosis and Genetic Diversity'),
  (5, 'Heredity', '5.3', 'Mendelian Genetics'),
  (5, 'Heredity', '5.4', 'Non-Mendelian Genetics'),
  (5, 'Heredity', '5.5', 'Environmental Effects on Phenotype'),
  (6, 'Gene Expression and Regulation', '6.1', 'DNA and RNA Structure'),
  (6, 'Gene Expression and Regulation', '6.2', 'DNA Replication'),
  (6, 'Gene Expression and Regulation', '6.3', 'Transcription and RNA Processing'),
  (6, 'Gene Expression and Regulation', '6.4', 'Translation'),
  (6, 'Gene Expression and Regulation', '6.5', 'Regulation of Gene Expression'),
  (6, 'Gene Expression and Regulation', '6.6', 'Gene Expression and Cell Specialization'),
  (6, 'Gene Expression and Regulation', '6.7', 'Mutations'),
  (6, 'Gene Expression and Regulation', '6.8', 'Biotechnology'),
  (7, 'Natural Selection', '7.1', 'Introduction to Natural Selection'),
  (7, 'Natural Selection', '7.2', 'Natural Selection'),
  (7, 'Natural Selection', '7.3', 'Artificial Selection'),
  (7, 'Natural Selection', '7.4', 'Population Genetics'),
  (7, 'Natural Selection', '7.5', 'Hardy-Weinberg Equilibrium'),
  (7, 'Natural Selection', '7.6', 'Evidence of Evolution'),
  (7, 'Natural Selection', '7.7', 'Common Ancestry'),
  (7, 'Natural Selection', '7.8', 'Continuing Evolution'),
  (7, 'Natural Selection', '7.9', 'Phylogeny'),
  (7, 'Natural Selection', '7.10', 'Speciation'),
  (7, 'Natural Selection', '7.11', 'Variations in Populations'),
  (7, 'Natural Selection', '7.12', 'Origins of Life on Earth'),
  (8, 'Ecology', '8.1', 'Responses to the Environment'),
  (8, 'Ecology', '8.2', 'Energy Flow Through Ecosystems'),
  (8, 'Ecology', '8.3', 'Population Ecology'),
  (8, 'Ecology', '8.4', 'Effect of Density of Populations'),
  (8, 'Ecology', '8.5', 'Community Ecology'),
  (8, 'Ecology', '8.6', 'Biodiversity'),
  (8, 'Ecology', '8.7', 'Disruptions in Ecosystems')
) as topic(unit_number, unit_title, topic_code, topic_title)
on conflict (taxonomy_source_version, topic_code) do update
  set unit_number = excluded.unit_number,
      unit_title = excluded.unit_title,
      topic_title = excluded.topic_title;

-- ── Legacy containment backfill ─────────────────────────────────────────────
--
-- The backfill intentionally does not canonicalize anything. Old modules and
-- subtopics are copied into source_payload and, where possible, modules are
-- parsed into integer required_units for audit only. legacy_unvalidated rows are
-- not servable under unit-gated practice.

with tagged_versions as (
  select
    civ.id as content_item_version_id,
    civ.content_item_id,
    civ.version_num,
    civ.prompt_json,
    app.taxonomy_relevant_hash(civ.id) as taxo_hash
  from app.content_item_versions civ
  where civ.prompt_json ? 'modules'
     or civ.prompt_json ? 'subtopics'
), serving_rows as (
  select
    tv.*,
    row_number() over (
      partition by tv.content_item_id
      order by tv.version_num, tv.content_item_version_id
    ) as label_version
  from tagged_versions tv
  where tv.prompt_json ? 'modules'
), coverage_rows as (
  select
    tv.*,
    row_number() over (
      partition by tv.content_item_id
      order by tv.version_num, tv.content_item_version_id
    ) as label_version
  from tagged_versions tv
  where tv.prompt_json ? 'subtopics'
)
insert into app.content_taxonomy_labels (
  content_item_id,
  label_version,
  label_scope,
  validated_against_version_id,
  validated_against_taxo_hash,
  required_units,
  label_status,
  source,
  source_payload
)
select
  sr.content_item_id,
  sr.label_version,
  'serving',
  sr.content_item_version_id,
  sr.taxo_hash,
  coalesce((
    select array_agg(distinct module_num order by module_num)
    from (
      select (module_text)::integer as module_num
      from jsonb_array_elements_text(sr.prompt_json -> 'modules') as m(module_text)
      where module_text ~ '^[0-9]+$'
        and (module_text)::integer > 0
    ) parsed
  ), '{}'::integer[]),
  'legacy_unvalidated',
  'legacy_prompt_json',
  jsonb_build_object(
    'content_item_version_id', sr.content_item_version_id,
    'version_num', sr.version_num,
    'modules', coalesce(sr.prompt_json -> 'modules', '[]'::jsonb)
  )
from serving_rows sr
on conflict (content_item_id, label_scope, label_version) do nothing;

with tagged_versions as (
  select
    civ.id as content_item_version_id,
    civ.content_item_id,
    civ.version_num,
    civ.prompt_json,
    app.taxonomy_relevant_hash(civ.id) as taxo_hash
  from app.content_item_versions civ
  where civ.prompt_json ? 'modules'
     or civ.prompt_json ? 'subtopics'
), coverage_rows as (
  select
    tv.*,
    row_number() over (
      partition by tv.content_item_id
      order by tv.version_num, tv.content_item_version_id
    ) as label_version
  from tagged_versions tv
  where tv.prompt_json ? 'subtopics'
)
insert into app.content_taxonomy_labels (
  content_item_id,
  label_version,
  label_scope,
  validated_against_version_id,
  validated_against_taxo_hash,
  assessed_topics,
  label_status,
  source,
  source_payload
)
select
  cr.content_item_id,
  cr.label_version,
  'coverage',
  cr.content_item_version_id,
  cr.taxo_hash,
  '{}'::text[],
  'legacy_unvalidated',
  'legacy_prompt_json',
  jsonb_build_object(
    'content_item_version_id', cr.content_item_version_id,
    'version_num', cr.version_num,
    'subtopics', coalesce(cr.prompt_json -> 'subtopics', '[]'::jsonb)
  )
from coverage_rows cr
on conflict (content_item_id, label_scope, label_version) do nothing;

comment on table app.content_taxonomy_labels is
  'Append-only independent taxonomy label layer. prompt_json modules/subtopics are legacy provenance only.';

comment on column app.content_taxonomy_labels.required_units is
  'Serving prerequisite units. A unit is required if full credit depends on it; MCQs include keyed-answer justification and distractor refutations.';

comment on column app.content_taxonomy_labels.assessed_topics is
  'Coverage topics only. Do not use for unit-gated serving.';

comment on column app.content_taxonomy_labels.primary_unit is
  'Teaching home only. Never use as serving eligibility.';

commit;
