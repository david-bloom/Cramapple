-- AP Calculus BC Tier 1 criterion-4, part 1 of 2: the 10 apcalcbc-frq-np1-* items (2026-09-25).
--
-- Codex originally proposed this migration covering all 29 AP Calculus BC targets (np1-001..010 plus
-- u13-001..016/018/019/020) in one file, using the same "concatenate frq_criteria.learner_facing_text"
-- method as the AP Precalculus proposal. Claude's independent cross-QA (four parallel agents, one per
-- ~15-item batch) found the np1-* 10 items clean -- correct and complete, only a P2 (cosmetic,
-- criteria-description-voice) readability note -- but found the 19 u13-* items had a genuine P1
-- completeness defect: for that specific batch, frq_criteria.learner_facing_text is generic rubric-label
-- text ("Correctly evaluates the limit.") with no numbers, while the actual computed values live only in
-- evidence_requirements, which this method never concatenates. See
-- 20260925170000_apcalcbc_u13_canonical_answers_19_items_evidence_source.sql for the u13-* fix, which
-- uses a different source field for that reason. This file is Codex's original migration, narrowed to
-- just the 10 np1-* items it was actually verified clean for.
--
-- Mechanics: canonical_answer_1 is assembled from learner_facing_text ordered by criterion_key, using a
-- blank line between criteria. canonical_answer_spans receives one drafted span per criterion plus
-- assembly_literal separator spans. The checks below prove target count, preblank state, exact span
-- reconstruction, and exact criterion-key coverage.

begin;

do $$
declare
  v_target_count int;
  v_nonblank_count int;
  v_existing_span_count int;
begin
  with latest_versions as (
    select ci.content_key, civ.id as version_id, civ.canonical_answer_1
    from app.content_items ci
    join app.content_item_versions civ on civ.id = (
      select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
    )
    where ci.content_key = any(array[
      'apcalcbc-frq-np1-001','apcalcbc-frq-np1-002','apcalcbc-frq-np1-003','apcalcbc-frq-np1-004','apcalcbc-frq-np1-005',
      'apcalcbc-frq-np1-006','apcalcbc-frq-np1-007','apcalcbc-frq-np1-008','apcalcbc-frq-np1-009','apcalcbc-frq-np1-010'
    ])
  )
  select count(*),
         count(*) filter (where nullif(btrim(coalesce(canonical_answer_1,'')), '') is not null),
         coalesce((select count(*) from app.canonical_answer_spans s join latest_versions lv on lv.version_id = s.content_item_version_id where s.answer_field = 'canonical_answer_1'), 0)
    into v_target_count, v_nonblank_count, v_existing_span_count
  from latest_versions;

  if v_target_count <> 10 then raise exception 'Expected 10 Calc BC np1 targets, found %', v_target_count; end if;
  if v_nonblank_count <> 0 then raise exception 'Expected all Calc BC np1 targets blank, found % nonblank', v_nonblank_count; end if;
  if v_existing_span_count <> 0 then raise exception 'Expected 0 existing spans, found %', v_existing_span_count; end if;
end $$;

with latest_versions as (
  select ci.content_key, civ.id as version_id
  from app.content_items ci
  join app.content_item_versions civ on civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
  )
  where ci.content_key = any(array[
    'apcalcbc-frq-np1-001','apcalcbc-frq-np1-002','apcalcbc-frq-np1-003','apcalcbc-frq-np1-004','apcalcbc-frq-np1-005',
    'apcalcbc-frq-np1-006','apcalcbc-frq-np1-007','apcalcbc-frq-np1-008','apcalcbc-frq-np1-009','apcalcbc-frq-np1-010'
  ])
),
assembled as (
  select lv.version_id, string_agg(fc.learner_facing_text, E'\n\n' order by fc.criterion_key) as full_text
  from latest_versions lv
  join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
  group by lv.version_id
)
update app.content_item_versions civ
set canonical_answer_1 = assembled.full_text
from assembled
where civ.id = assembled.version_id
  and nullif(btrim(coalesce(civ.canonical_answer_1,'')), '') is null;

with latest_versions as (
  select ci.content_key, civ.id as version_id
  from app.content_items ci
  join app.content_item_versions civ on civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
  )
  where ci.content_key = any(array[
    'apcalcbc-frq-np1-001','apcalcbc-frq-np1-002','apcalcbc-frq-np1-003','apcalcbc-frq-np1-004','apcalcbc-frq-np1-005',
    'apcalcbc-frq-np1-006','apcalcbc-frq-np1-007','apcalcbc-frq-np1-008','apcalcbc-frq-np1-009','apcalcbc-frq-np1-010'
  ])
),
criteria_ordered as (
  select lv.version_id, fc.criterion_key, fc.learner_facing_text,
    row_number() over (partition by lv.version_id order by fc.criterion_key) as rn,
    count(*) over (partition by lv.version_id) as cnt
  from latest_versions lv
  join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
),
span_rows as (
  select version_id, rn * 2 - 1 as span_ordinal, learner_facing_text as span_text,
         array[criterion_key]::text[] as criterion_keys, 'drafted'::text as provenance
  from criteria_ordered
  union all
  select version_id, rn * 2 as span_ordinal, E'\n\n' as span_text,
         array[]::text[] as criterion_keys, 'assembly_literal'::text as provenance
  from criteria_ordered
  where rn < cnt
)
insert into app.canonical_answer_spans
  (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run)
select version_id, 'canonical_answer_1', span_ordinal, span_text, criterion_keys, provenance,
       'tier1-apcalcbc-np1-canonical-2026-09-25'
from span_rows
order by version_id, span_ordinal;

do $$
declare
  v_bad_reconstruction int;
  v_bad_coverage int;
begin
  with latest_versions as (
    select ci.content_key, civ.id as version_id, civ.canonical_answer_1
    from app.content_items ci
    join app.content_item_versions civ on civ.id = (
      select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
    )
    where ci.content_key = any(array[
      'apcalcbc-frq-np1-001','apcalcbc-frq-np1-002','apcalcbc-frq-np1-003','apcalcbc-frq-np1-004','apcalcbc-frq-np1-005',
      'apcalcbc-frq-np1-006','apcalcbc-frq-np1-007','apcalcbc-frq-np1-008','apcalcbc-frq-np1-009','apcalcbc-frq-np1-010'
    ])
  ),
  reconstructed as (
    select lv.version_id, string_agg(s.span_text, '' order by s.span_ordinal) as reconstructed_text
    from latest_versions lv
    join app.canonical_answer_spans s on s.content_item_version_id = lv.version_id and s.answer_field = 'canonical_answer_1'
    group by lv.version_id
  ),
  criteria_keys as (
    select lv.version_id, array_agg(fc.criterion_key order by fc.criterion_key) as expected_keys
    from latest_versions lv join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
    group by lv.version_id
  ),
  span_keys as (
    select lv.version_id, array_agg(k.criterion_key order by k.criterion_key) as actual_keys
    from latest_versions lv
    join app.canonical_answer_spans s on s.content_item_version_id = lv.version_id and s.answer_field = 'canonical_answer_1'
    cross join lateral unnest(s.criterion_keys) as k(criterion_key)
    group by lv.version_id
  )
  select
    (select count(*) from latest_versions lv join reconstructed r using (version_id) where r.reconstructed_text <> lv.canonical_answer_1),
    (select count(*) from criteria_keys ck join span_keys sk using (version_id) where ck.expected_keys <> sk.actual_keys)
  into v_bad_reconstruction, v_bad_coverage;

  if v_bad_reconstruction <> 0 then raise exception 'Calc BC np1 span reconstruction failed for % target(s)', v_bad_reconstruction; end if;
  if v_bad_coverage <> 0 then raise exception 'Calc BC np1 criterion coverage failed for % target(s)', v_bad_coverage; end if;
end $$;

commit;
