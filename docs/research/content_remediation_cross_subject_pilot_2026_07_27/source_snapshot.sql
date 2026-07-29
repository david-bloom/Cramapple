-- Read-only resolver for the frozen cross-subject remediation pilot.
-- Run against Production project pcntajvbdfqhbeewmdry.

with frozen(content_key, source_version_num) as (
  values
    ('apphy1-frq-013',2),
    ('apphy1-frq-034',1),
    ('apphy2-frq-018',1),
    ('apphy2-frq-024',1),
    ('apphy2-frq-028',1),
    ('apphycem-frq-024',1),
    ('apphycm-frq-019',1),
    ('apphycm-frq-028',1),
    ('apphy2-frq-013',1),
    ('apphy2-frq-016',1),
    ('apphycem-frq-002',1),
    ('apphycem-frq-029',1),
    ('apphycm-frq-021',1),
    ('apphycm-mcq-004',1),
    ('APBIO-HDG-2026-GRAPH-006',1),
    ('APBIO-MCQ-069',1),
    ('apchem-mcq-050',1),
    ('apphy1-frq-009',1),
    ('apphy2-frq-009',1),
    ('apphycem-frq-011',1),
    ('APSTAT-MOD8-M004',1)
),
latest as (
  select distinct on (ci.id)
    ci.id as content_item_id,
    ci.content_key,
    ci.item_type,
    ci.status as item_status,
    civ.id as content_item_version_id,
    civ.version_num,
    civ.status as version_status,
    civ.stem,
    civ.stimulus,
    civ.prompt_json,
    civ.canonical_answer_1,
    civ.canonical_answer_2,
    civ.explanation,
    civ.help_text,
    civ.rubric_type,
    civ.evaluator_strategy,
    civ.created_at
  from app.content_items ci
  join frozen f on lower(f.content_key)=lower(ci.content_key)
  join app.content_item_versions civ on civ.content_item_id=ci.id
  order by ci.id, civ.version_num desc, civ.created_at desc
),
active_finding as (
  select distinct on (d.content_item_version_id)
    d.content_item_version_id,
    d.content_review_decision_id,
    d.reviewer_id,
    d.concern_codes,
    d.note,
    d.submitted_at
  from app.content_review_decisions d
  where d.review_stage='tutor_question'
    and d.tutor_decision='approve_with_edits'
    and not exists (
      select 1
      from app.content_review_decisions newer
      where newer.supersedes_id=d.content_review_decision_id
    )
  order by d.content_item_version_id, d.submitted_at desc
)
select
  f.source_version_num as frozen_version_num,
  (l.version_num=f.source_version_num) as version_matches_freeze,
  l.*,
  af.content_review_decision_id as source_finding_id,
  af.reviewer_id as source_reviewer_id,
  af.concern_codes,
  af.note,
  (
    select jsonb_agg(
      jsonb_build_object(
        'choice_key',c.choice_key,
        'choice_text',c.choice_text,
        'is_correct',c.is_correct,
        'rationale',c.rationale
      )
      order by c.choice_key
    )
    from app.mcq_choices c
    where c.content_item_version_id=l.content_item_version_id
  ) as choices,
  (
    select jsonb_agg(
      jsonb_build_object(
        'criterion_key',r.criterion_key,
        'learner_facing_text',r.learner_facing_text,
        'points_possible',r.points_possible,
        'evidence_requirements',r.evidence_requirements,
        'minimum_fix',r.minimum_fix,
        'accepted_variants',r.accepted_variants
      )
      order by r.criterion_key
    )
    from app.frq_criteria r
    where r.content_item_version_id=l.content_item_version_id
  ) as criteria
from frozen f
join latest l on lower(l.content_key)=lower(f.content_key)
left join active_finding af
  on af.content_item_version_id=l.content_item_version_id
order by lower(l.content_key);
