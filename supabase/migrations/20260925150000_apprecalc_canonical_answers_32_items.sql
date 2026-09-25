-- AP Precalculus Tier 1 criterion-4 proposal (2026-09-25).
--
-- Scope: the 32 published AP Precalculus FRQ current versions that currently have blank
-- canonical_answer_1, identified by prompts/CODEX_WORK_ORDER_AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md
-- and re-confirmed read-only against Production before this proposal was written.
--
-- This migration is intentionally proposal-only in this branch. Do not apply without the cross-QA
-- pass described in docs/product/SUBJECT_READINESS_COMPLETION_PLAN_2026_09_25.md.
--
-- Content investigation: the missing set clusters into apprecalc-frq-006/007/029,
-- apprecalc-frq-np2-001..010, and apprecalc-frq-u12-002..020. Stems and stimuli are complete
-- student-facing FRQs; none looked like placeholder/test content. Local package files under
-- content/item-packages/ap-precalculus/ also show that this generated bank's canonical-answer shape
-- is the ordered rubric evidence joined into one answer, so this proposal derives each answer from
-- that same item's current Production frq_criteria rather than guessing or remapping old package keys.
--
-- Mechanics: canonical_answer_1 is assembled from learner_facing_text ordered by criterion_key, using
-- a blank line between criteria. canonical_answer_spans receives one drafted span per criterion plus
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
    select distinct on (ci.id)
      ci.content_key,
      civ.id as version_id,
      civ.canonical_answer_1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.content_items ci on ci.exam_pack_version_id = epv.id
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ep.exam_code = 'ap_precalculus'
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and ci.item_type = 'frq'
      and ci.content_key = any(array[
        'apprecalc-frq-006','apprecalc-frq-007','apprecalc-frq-029',
        'apprecalc-frq-np2-001','apprecalc-frq-np2-002','apprecalc-frq-np2-003',
        'apprecalc-frq-np2-004','apprecalc-frq-np2-005','apprecalc-frq-np2-006',
        'apprecalc-frq-np2-007','apprecalc-frq-np2-008','apprecalc-frq-np2-009',
        'apprecalc-frq-np2-010',
        'apprecalc-frq-u12-002','apprecalc-frq-u12-003','apprecalc-frq-u12-004',
        'apprecalc-frq-u12-005','apprecalc-frq-u12-006','apprecalc-frq-u12-007',
        'apprecalc-frq-u12-008','apprecalc-frq-u12-009','apprecalc-frq-u12-010',
        'apprecalc-frq-u12-011','apprecalc-frq-u12-012','apprecalc-frq-u12-013',
        'apprecalc-frq-u12-014','apprecalc-frq-u12-015','apprecalc-frq-u12-016',
        'apprecalc-frq-u12-017','apprecalc-frq-u12-018','apprecalc-frq-u12-019',
        'apprecalc-frq-u12-020'
      ])
    order by ci.id, civ.version_num desc
  )
  select count(*),
         count(*) filter (where nullif(btrim(coalesce(canonical_answer_1,'')), '') is not null),
         coalesce((select count(*) from app.canonical_answer_spans s join latest_versions lv on lv.version_id = s.content_item_version_id where s.answer_field = 'canonical_answer_1'), 0)
    into v_target_count, v_nonblank_count, v_existing_span_count
  from latest_versions;

  if v_target_count <> 32 then
    raise exception 'Expected 32 AP Precalculus target versions, found %', v_target_count;
  end if;
  if v_nonblank_count <> 0 then
    raise exception 'Expected all AP Precalculus targets to have blank canonical_answer_1, found % nonblank', v_nonblank_count;
  end if;
  if v_existing_span_count <> 0 then
    raise exception 'Expected AP Precalculus targets to have 0 existing canonical_answer_1 spans, found %', v_existing_span_count;
  end if;
end $$;

with latest_versions as (
  select distinct on (ci.id)
    ci.content_key,
    civ.id as version_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.content_items ci on ci.exam_pack_version_id = epv.id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  where ep.exam_code = 'ap_precalculus'
    and epv.status = 'published'
    and epv.retired_at is null
    and ci.status = 'published'
    and ci.item_type = 'frq'
    and ci.content_key = any(array[
      'apprecalc-frq-006','apprecalc-frq-007','apprecalc-frq-029',
      'apprecalc-frq-np2-001','apprecalc-frq-np2-002','apprecalc-frq-np2-003',
      'apprecalc-frq-np2-004','apprecalc-frq-np2-005','apprecalc-frq-np2-006',
      'apprecalc-frq-np2-007','apprecalc-frq-np2-008','apprecalc-frq-np2-009',
      'apprecalc-frq-np2-010',
      'apprecalc-frq-u12-002','apprecalc-frq-u12-003','apprecalc-frq-u12-004',
      'apprecalc-frq-u12-005','apprecalc-frq-u12-006','apprecalc-frq-u12-007',
      'apprecalc-frq-u12-008','apprecalc-frq-u12-009','apprecalc-frq-u12-010',
      'apprecalc-frq-u12-011','apprecalc-frq-u12-012','apprecalc-frq-u12-013',
      'apprecalc-frq-u12-014','apprecalc-frq-u12-015','apprecalc-frq-u12-016',
      'apprecalc-frq-u12-017','apprecalc-frq-u12-018','apprecalc-frq-u12-019',
      'apprecalc-frq-u12-020'
    ])
  order by ci.id, civ.version_num desc
),
assembled as (
  select
    lv.version_id,
    string_agg(fc.learner_facing_text, E'\n\n' order by fc.criterion_key) as full_text
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
  select distinct on (ci.id)
    ci.content_key,
    civ.id as version_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.content_items ci on ci.exam_pack_version_id = epv.id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  where ep.exam_code = 'ap_precalculus'
    and epv.status = 'published'
    and epv.retired_at is null
    and ci.status = 'published'
    and ci.item_type = 'frq'
    and ci.content_key = any(array[
      'apprecalc-frq-006','apprecalc-frq-007','apprecalc-frq-029',
      'apprecalc-frq-np2-001','apprecalc-frq-np2-002','apprecalc-frq-np2-003',
      'apprecalc-frq-np2-004','apprecalc-frq-np2-005','apprecalc-frq-np2-006',
      'apprecalc-frq-np2-007','apprecalc-frq-np2-008','apprecalc-frq-np2-009',
      'apprecalc-frq-np2-010',
      'apprecalc-frq-u12-002','apprecalc-frq-u12-003','apprecalc-frq-u12-004',
      'apprecalc-frq-u12-005','apprecalc-frq-u12-006','apprecalc-frq-u12-007',
      'apprecalc-frq-u12-008','apprecalc-frq-u12-009','apprecalc-frq-u12-010',
      'apprecalc-frq-u12-011','apprecalc-frq-u12-012','apprecalc-frq-u12-013',
      'apprecalc-frq-u12-014','apprecalc-frq-u12-015','apprecalc-frq-u12-016',
      'apprecalc-frq-u12-017','apprecalc-frq-u12-018','apprecalc-frq-u12-019',
      'apprecalc-frq-u12-020'
    ])
  order by ci.id, civ.version_num desc
),
criteria_ordered as (
  select
    lv.version_id,
    fc.criterion_key,
    fc.learner_facing_text,
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
       'tier1-apprecalc-canonical-2026-09-25'
from span_rows
order by version_id, span_ordinal;

do $$
declare
  v_bad_reconstruction int;
  v_bad_coverage int;
  v_bad_span_count int;
begin
  with latest_versions as (
    select distinct on (ci.id)
      ci.content_key,
      civ.id as version_id,
      civ.canonical_answer_1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.content_items ci on ci.exam_pack_version_id = epv.id
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ep.exam_code = 'ap_precalculus'
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and ci.item_type = 'frq'
      and ci.content_key = any(array[
        'apprecalc-frq-006','apprecalc-frq-007','apprecalc-frq-029',
        'apprecalc-frq-np2-001','apprecalc-frq-np2-002','apprecalc-frq-np2-003',
        'apprecalc-frq-np2-004','apprecalc-frq-np2-005','apprecalc-frq-np2-006',
        'apprecalc-frq-np2-007','apprecalc-frq-np2-008','apprecalc-frq-np2-009',
        'apprecalc-frq-np2-010',
        'apprecalc-frq-u12-002','apprecalc-frq-u12-003','apprecalc-frq-u12-004',
        'apprecalc-frq-u12-005','apprecalc-frq-u12-006','apprecalc-frq-u12-007',
        'apprecalc-frq-u12-008','apprecalc-frq-u12-009','apprecalc-frq-u12-010',
        'apprecalc-frq-u12-011','apprecalc-frq-u12-012','apprecalc-frq-u12-013',
        'apprecalc-frq-u12-014','apprecalc-frq-u12-015','apprecalc-frq-u12-016',
        'apprecalc-frq-u12-017','apprecalc-frq-u12-018','apprecalc-frq-u12-019',
        'apprecalc-frq-u12-020'
      ])
    order by ci.id, civ.version_num desc
  ),
  reconstructed as (
    select lv.version_id,
           string_agg(s.span_text, '' order by s.span_ordinal) as reconstructed_text
    from latest_versions lv
    join app.canonical_answer_spans s on s.content_item_version_id = lv.version_id
     and s.answer_field = 'canonical_answer_1'
    group by lv.version_id
  ),
  criteria_keys as (
    select lv.version_id,
           array_agg(fc.criterion_key order by fc.criterion_key) as expected_keys
    from latest_versions lv
    join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
    group by lv.version_id
  ),
  span_keys as (
    select lv.version_id,
           array_agg(k.criterion_key order by k.criterion_key) as actual_keys
    from latest_versions lv
    join app.canonical_answer_spans s on s.content_item_version_id = lv.version_id
     and s.answer_field = 'canonical_answer_1'
    cross join lateral unnest(s.criterion_keys) as k(criterion_key)
    group by lv.version_id
  ),
  criteria_counts as (
    select lv.version_id,
           count(fc.*) as criteria_count
    from latest_versions lv
    join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
    group by lv.version_id
  ),
  span_counts as (
    select lv.version_id,
           count(s.*) as span_count
    from latest_versions lv
    join app.canonical_answer_spans s on s.content_item_version_id = lv.version_id
     and s.answer_field = 'canonical_answer_1'
    group by lv.version_id
  )
  select
    (select count(*) from latest_versions lv join reconstructed r using (version_id) where r.reconstructed_text <> lv.canonical_answer_1),
    (select count(*) from criteria_keys ck join span_keys sk using (version_id) where ck.expected_keys <> sk.actual_keys),
    (select count(*) from criteria_counts cc join span_counts sc using (version_id) where sc.span_count <> (2 * cc.criteria_count - 1))
  into v_bad_reconstruction, v_bad_coverage, v_bad_span_count;

  if v_bad_reconstruction <> 0 then
    raise exception 'AP Precalculus canonical span reconstruction failed for % target(s)', v_bad_reconstruction;
  end if;
  if v_bad_coverage <> 0 then
    raise exception 'AP Precalculus canonical criterion coverage failed for % target(s)', v_bad_coverage;
  end if;
  if v_bad_span_count <> 0 then
    raise exception 'AP Precalculus canonical span count failed for % target(s)', v_bad_span_count;
  end if;
end $$;

commit;
