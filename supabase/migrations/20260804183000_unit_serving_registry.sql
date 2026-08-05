-- Unit-serving registry and Home unit-list correction.
--
-- Topic coverage remains deferred. This migration records the verified CED unit
-- universe for serving labels and corrects AP Statistics Home unit selection to
-- the revised 2026-27 five-unit structure.

begin;

create table if not exists app.taxonomy_units (
  taxonomy_unit_id uuid primary key default gen_random_uuid(),
  taxonomy_source_version uuid not null
    references app.taxonomy_source_versions(taxonomy_source_version)
    on delete restrict,
  unit_number integer not null,
  unit_title text not null,
  is_exam_assessed boolean not null default true,
  created_at timestamptz not null default now(),
  constraint taxonomy_units_unit_check check (unit_number > 0),
  constraint taxonomy_units_title_check check (char_length(btrim(unit_title)) > 0),
  constraint taxonomy_units_unique_number
    unique (taxonomy_source_version, unit_number)
);

create index if not exists taxonomy_units_source_assessed_idx
  on app.taxonomy_units (taxonomy_source_version, is_exam_assessed, unit_number);

alter table app.taxonomy_units enable row level security;
alter table app.taxonomy_units force row level security;
revoke all on app.taxonomy_units from public, anon, authenticated;
grant select, insert, update, delete on app.taxonomy_units to service_role;

create or replace function app.seed_taxonomy_units(
  _subject_key text,
  _school_year text,
  _source_title text,
  _source_citation text,
  _source_uri text,
  _verified_at timestamptz,
  _units jsonb
)
returns uuid
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_source_version uuid;
begin
  if jsonb_typeof(_units) <> 'array' then
    raise exception 'taxonomy_units:units_must_be_array' using errcode = '22023';
  end if;

  insert into app.taxonomy_source_versions (
    subject_key,
    school_year,
    source_title,
    taxonomy_confidence,
    source_citation,
    source_uri,
    verified_at
  ) values (
    _subject_key,
    _school_year,
    _source_title,
    'verified',
    _source_citation,
    _source_uri,
    _verified_at
  )
  on conflict (subject_key, school_year, source_title) do update
    set taxonomy_confidence = 'verified',
        source_citation = excluded.source_citation,
        source_uri = excluded.source_uri,
        verified_at = excluded.verified_at
  returning taxonomy_source_version into v_source_version;

  insert into app.taxonomy_units (
    taxonomy_source_version,
    unit_number,
    unit_title,
    is_exam_assessed
  )
  select
    v_source_version,
    (unit_row.value ->> 'unit_number')::integer,
    unit_row.value ->> 'unit_title',
    coalesce((unit_row.value ->> 'is_exam_assessed')::boolean, true)
  from jsonb_array_elements(_units) as unit_row(value)
  on conflict (taxonomy_source_version, unit_number) do update
    set unit_title = excluded.unit_title,
        is_exam_assessed = excluded.is_exam_assessed;

  return v_source_version;
end;
$$;

revoke all on function app.seed_taxonomy_units(
  text, text, text, text, text, timestamptz, jsonb
) from public, anon, authenticated;
grant execute on function app.seed_taxonomy_units(
  text, text, text, text, text, timestamptz, jsonb
) to service_role;

select app.seed_taxonomy_units(
  'ap_biology',
  '2026-2027',
  'AP Biology Course and Exam Description, Effective Fall 2025',
  'AP Biology CED Effective Fall 2025; verified 2026-08-04 from AP Biology CED Fact Pack',
  null,
  '2026-08-04 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Chemistry of Life"},{"unit_number":2,"unit_title":"Cells"},{"unit_number":3,"unit_title":"Cellular Energetics"},{"unit_number":4,"unit_title":"Cell Communication and Cell Cycle"},{"unit_number":5,"unit_title":"Heredity"},{"unit_number":6,"unit_title":"Gene Expression and Regulation"},{"unit_number":7,"unit_title":"Natural Selection"},{"unit_number":8,"unit_title":"Ecology"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_statistics',
  '2026-2027',
  'AP Statistics Course and Exam Description, Effective Fall 2026',
  'AP Statistics 2026-27 CED Fact Pack; approved 2026-08-02 with Jill edits incorporated; unit map verified',
  null,
  '2026-08-02 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Exploring One-Variable Data and Collecting Data"},{"unit_number":2,"unit_title":"Probability, Random Variables, and Probability Distributions"},{"unit_number":3,"unit_title":"Inference for Categorical Data: Proportions"},{"unit_number":4,"unit_title":"Inference for Quantitative Data: Means"},{"unit_number":5,"unit_title":"Regression Analysis"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_calculus_ab',
  '2026-2027',
  'AP Calculus AB and BC Course and Exam Description, Effective Fall 2020',
  'AP Calculus AB/BC CED Fact Pack; primary-source verified for 2026-27 authoring and review',
  null,
  '2026-08-04 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Limits and Continuity"},{"unit_number":2,"unit_title":"Differentiation: Definition and Basic Derivative Rules"},{"unit_number":3,"unit_title":"Differentiation: Composite, Implicit, and Inverse Functions"},{"unit_number":4,"unit_title":"Contextual Applications of Differentiation"},{"unit_number":5,"unit_title":"Applying Derivatives to Analyze Functions"},{"unit_number":6,"unit_title":"Integration and Accumulation of Change"},{"unit_number":7,"unit_title":"Differential Equations"},{"unit_number":8,"unit_title":"Applications of Integration"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_calculus_bc',
  '2026-2027',
  'AP Calculus AB and BC Course and Exam Description, Effective Fall 2020',
  'AP Calculus AB/BC CED Fact Pack; primary-source verified for 2026-27 authoring and review',
  null,
  '2026-08-04 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Limits and Continuity"},{"unit_number":2,"unit_title":"Differentiation: Definition and Basic Derivative Rules"},{"unit_number":3,"unit_title":"Differentiation: Composite, Implicit, and Inverse Functions"},{"unit_number":4,"unit_title":"Contextual Applications of Differentiation"},{"unit_number":5,"unit_title":"Applying Derivatives to Analyze Functions"},{"unit_number":6,"unit_title":"Integration and Accumulation of Change"},{"unit_number":7,"unit_title":"Differential Equations"},{"unit_number":8,"unit_title":"Applications of Integration"},{"unit_number":9,"unit_title":"Parametric Equations, Polar Coordinates, and Vector-Valued Functions"},{"unit_number":10,"unit_title":"Infinite Sequences and Series"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_chemistry',
  '2026-2027',
  'AP Chemistry Course and Exam Description, Effective Fall 2024',
  'AP Chemistry CED Fact Pack; primary-source verified for 2026-27 authoring and review',
  null,
  '2026-08-04 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Atomic Structure and Properties"},{"unit_number":2,"unit_title":"Compound Structure and Properties"},{"unit_number":3,"unit_title":"Properties of Substances and Mixtures"},{"unit_number":4,"unit_title":"Chemical Reactions"},{"unit_number":5,"unit_title":"Kinetics"},{"unit_number":6,"unit_title":"Thermochemistry"},{"unit_number":7,"unit_title":"Principles of Equilibrium"},{"unit_number":8,"unit_title":"Acids and Bases"},{"unit_number":9,"unit_title":"Thermodynamics and Electrochemistry"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_physics_1',
  '2026-2027',
  'AP Physics 1: Algebra-Based Course and Exam Description, Effective Fall 2024',
  'AP Physics 1 CED Fact Pack; primary-source verified and mirrored 2026-08-03',
  null,
  '2026-08-03 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Kinematics"},{"unit_number":2,"unit_title":"Force and Translational Dynamics"},{"unit_number":3,"unit_title":"Work, Energy, and Power"},{"unit_number":4,"unit_title":"Linear Momentum"},{"unit_number":5,"unit_title":"Torque and Rotational Dynamics"},{"unit_number":6,"unit_title":"Energy and Momentum of Rotating Systems"},{"unit_number":7,"unit_title":"Oscillations"},{"unit_number":8,"unit_title":"Fluids"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_physics_2',
  '2026-2027',
  'AP Physics 2: Algebra-Based Course and Exam Description, Effective Fall 2024',
  'AP Physics 2 CED Fact Pack; primary-source verified and mirrored 2026-08-03',
  null,
  '2026-08-03 00:00:00+00'::timestamptz,
  '[{"unit_number":9,"unit_title":"Thermodynamics"},{"unit_number":10,"unit_title":"Electric Force, Field, and Potential"},{"unit_number":11,"unit_title":"Electric Circuits"},{"unit_number":12,"unit_title":"Magnetism and Electromagnetism"},{"unit_number":13,"unit_title":"Geometric Optics"},{"unit_number":14,"unit_title":"Waves, Sound, and Physical Optics"},{"unit_number":15,"unit_title":"Modern Physics"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_physics_c_mechanics',
  '2026-2027',
  'AP Physics C: Mechanics Course and Exam Description, Effective Fall 2024',
  'AP Physics C Mechanics CED Fact Pack; primary-source verified and mirrored 2026-08-03',
  null,
  '2026-08-03 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Kinematics"},{"unit_number":2,"unit_title":"Force and Translational Dynamics"},{"unit_number":3,"unit_title":"Work, Energy, and Power"},{"unit_number":4,"unit_title":"Linear Momentum"},{"unit_number":5,"unit_title":"Torque and Rotational Dynamics"},{"unit_number":6,"unit_title":"Energy and Momentum of Rotating Systems"},{"unit_number":7,"unit_title":"Oscillations"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_physics_c_em',
  '2026-2027',
  'AP Physics C: Electricity and Magnetism Course and Exam Description, Effective Fall 2024',
  'AP Physics C E&M CED Fact Pack; primary-source verified and mirrored 2026-08-03',
  null,
  '2026-08-03 00:00:00+00'::timestamptz,
  '[{"unit_number":8,"unit_title":"Electric Charges, Fields, and Gauss''s Law"},{"unit_number":9,"unit_title":"Electric Potential"},{"unit_number":10,"unit_title":"Conductors and Capacitors"},{"unit_number":11,"unit_title":"Electric Circuits"},{"unit_number":12,"unit_title":"Magnetic Fields and Electromagnetism"},{"unit_number":13,"unit_title":"Electromagnetic Induction"}]'::jsonb
);

select app.seed_taxonomy_units(
  'ap_precalculus',
  '2026-2027',
  'AP Precalculus Course and Exam Description, Effective Fall 2026',
  'AP Precalculus CED Fact Pack; primary-source verified for 2026-27 authoring and review',
  null,
  '2026-08-04 00:00:00+00'::timestamptz,
  '[{"unit_number":1,"unit_title":"Polynomial and Rational Functions"},{"unit_number":2,"unit_title":"Exponential and Logarithmic Functions"},{"unit_number":3,"unit_title":"Trigonometric and Polar Functions"},{"unit_number":4,"unit_title":"Functions Involving Parameters, Vectors, and Matrices","is_exam_assessed":false}]'::jsonb
);

-- AP Statistics Home unit selection must use the revised five-unit CED, not the
-- retired nine-unit structure. Do not add Home manifests for subjects that do
-- not already have one in this release.
update app.home_release_manifest m
set allowed_unit_numbers = array[1,2,3,4,5]::integer[]
from app.exam_pack_versions epv
join app.exam_packs ep on ep.id = epv.exam_pack_id
where m.exam_pack_version_id = epv.id
  and ep.exam_code = 'ap_statistics';

comment on table app.taxonomy_units is
  'Verified CED unit universe for unit-serving labels. Topic-level coverage remains in taxonomy_topics and may be deferred.';

commit;
