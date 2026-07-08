-- Phase 3: seed AP Chemistry and AP Physics 1 as additional subjects.
-- These rows are draft-only at the exam-pack layer so the backend can support
-- the subjects without changing launch posture.

begin;

with upserted_subject as (
  insert into app.subjects (subject_key, display_name, status)
  values ('ap-chemistry', 'AP Chemistry', 'active')
  on conflict (subject_key)
  do update set
    display_name = excluded.display_name,
    status = excluded.status
  returning id
),
upserted_pack as (
  insert into app.exam_packs (exam_code, exam_name, subject_id)
  select
    'ap_chemistry',
    'AP Chemistry',
    id
  from upserted_subject
  on conflict (exam_code)
  do update set
    exam_name = excluded.exam_name,
    subject_id = excluded.subject_id
  returning id
),
upserted_version as (
  insert into app.exam_pack_versions (
    exam_pack_id,
    school_year,
    official_exam_date,
    status,
    source_uri,
    source_published_at,
    released_at
  )
  select
    id,
    '2026',
    date '2026-05-05',
    'draft',
    null,
    null,
    null
  from upserted_pack
  on conflict (exam_pack_id, school_year)
  do update set
    official_exam_date = excluded.official_exam_date,
    status = excluded.status,
    source_uri = excluded.source_uri,
    source_published_at = excluded.source_published_at,
    released_at = excluded.released_at
  returning id, exam_pack_id
),
all_labels as (
  select
    upserted_pack.id as exam_pack_id,
    unit_label.label_key,
    unit_label.label_name,
    'unit'::text as label_type
  from upserted_pack
  cross join upserted_version
  cross join (
    values
      ('unit_1', 'AP Chemistry Unit 1'),
      ('unit_2', 'AP Chemistry Unit 2'),
      ('unit_3', 'AP Chemistry Unit 3'),
      ('unit_4', 'AP Chemistry Unit 4'),
      ('unit_5', 'AP Chemistry Unit 5'),
      ('unit_6', 'AP Chemistry Unit 6'),
      ('unit_7', 'AP Chemistry Unit 7'),
      ('unit_8', 'AP Chemistry Unit 8'),
      ('unit_9', 'AP Chemistry Unit 9')
  ) as unit_label(label_key, label_name)
  union all
  select
    upserted_pack.id as exam_pack_id,
    taxonomy_label.label_key,
    taxonomy_label.label_name,
    taxonomy_label.label_type
  from upserted_pack
  cross join upserted_version
  cross join (
    values
      ('topic_stoichiometry', 'Stoichiometry', 'topic'),
      ('topic_atomic_structure', 'Atomic Structure', 'topic'),
      ('topic_bonding', 'Bonding and Molecular Structure', 'topic'),
      ('topic_thermochemistry', 'Thermochemistry', 'topic'),
      ('topic_kinetics', 'Kinetics', 'topic'),
      ('topic_equilibrium', 'Chemical Equilibrium', 'topic'),
      ('topic_acids_bases', 'Acids and Bases', 'topic'),
      ('topic_electrochemistry', 'Electrochemistry', 'topic'),
      ('skill_unit_conversions', 'Unit Conversions and Significant Figures', 'skill'),
      ('skill_equation_balancing', 'Equation Balancing', 'skill'),
      ('skill_particle_reasoning', 'Particle-Level Reasoning', 'skill'),
      ('skill_graph_interpretation', 'Graph and Table Interpretation', 'skill'),
      ('skill_lab_data_reasoning', 'Lab Data Reasoning', 'skill'),
      ('skill_chemical_notation', 'Chemical Notation', 'skill')
  ) as taxonomy_label(label_key, label_name, label_type)
)
insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status
)
select
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  'draft'
from all_labels
on conflict (exam_pack_id, label_key)
do update set
  label_name = excluded.label_name,
  label_type = excluded.label_type,
  status = excluded.status;

with upserted_subject as (
  insert into app.subjects (subject_key, display_name, status)
  values ('ap-physics-1', 'AP Physics 1', 'active')
  on conflict (subject_key)
  do update set
    display_name = excluded.display_name,
    status = excluded.status
  returning id
),
upserted_pack as (
  insert into app.exam_packs (exam_code, exam_name, subject_id)
  select
    'ap_physics_1',
    'AP Physics 1: Algebra-Based',
    id
  from upserted_subject
  on conflict (exam_code)
  do update set
    exam_name = excluded.exam_name,
    subject_id = excluded.subject_id
  returning id
),
upserted_version as (
  insert into app.exam_pack_versions (
    exam_pack_id,
    school_year,
    official_exam_date,
    status,
    source_uri,
    source_published_at,
    released_at
  )
  select
    id,
    '2026',
    date '2026-05-06',
    'draft',
    null,
    null,
    null
  from upserted_pack
  on conflict (exam_pack_id, school_year)
  do update set
    official_exam_date = excluded.official_exam_date,
    status = excluded.status,
    source_uri = excluded.source_uri,
    source_published_at = excluded.source_published_at,
    released_at = excluded.released_at
  returning id, exam_pack_id
),
all_labels as (
  select
    upserted_pack.id as exam_pack_id,
    unit_label.label_key,
    unit_label.label_name,
    'unit'::text as label_type
  from upserted_pack
  cross join upserted_version
  cross join (
    values
      ('unit_1', 'AP Physics 1 Unit 1'),
      ('unit_2', 'AP Physics 1 Unit 2'),
      ('unit_3', 'AP Physics 1 Unit 3'),
      ('unit_4', 'AP Physics 1 Unit 4'),
      ('unit_5', 'AP Physics 1 Unit 5'),
      ('unit_6', 'AP Physics 1 Unit 6'),
      ('unit_7', 'AP Physics 1 Unit 7')
  ) as unit_label(label_key, label_name)
  union all
  select
    upserted_pack.id as exam_pack_id,
    taxonomy_label.label_key,
    taxonomy_label.label_name,
    taxonomy_label.label_type
  from upserted_pack
  cross join upserted_version
  cross join (
    values
      ('topic_kinematics', 'Kinematics', 'topic'),
      ('topic_dynamics', 'Dynamics', 'topic'),
      ('topic_energy', 'Energy', 'topic'),
      ('topic_momentum', 'Momentum', 'topic'),
      ('topic_rotation', 'Rotation and Circular Motion', 'topic'),
      ('topic_circuits', 'Circuits', 'topic'),
      ('topic_experimental_design', 'Experimental Design', 'topic'),
      ('skill_vector_reasoning', 'Vector Reasoning', 'skill'),
      ('skill_sign_conventions', 'Sign Conventions', 'skill'),
      ('skill_graph_interpretation', 'Graph Interpretation', 'skill'),
      ('skill_diagram_reasoning', 'Diagram Reasoning', 'skill'),
      ('skill_unit_analysis', 'Unit Analysis', 'skill'),
      ('skill_symbolic_manipulation', 'Symbolic Manipulation', 'skill')
  ) as taxonomy_label(label_key, label_name, label_type)
)
insert into app.content_labels (
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  status
)
select
  exam_pack_id,
  label_key,
  label_name,
  label_type,
  'draft'
from all_labels
on conflict (exam_pack_id, label_key)
do update set
  label_name = excluded.label_name,
  label_type = excluded.label_type,
  status = excluded.status;

commit;
