-- AP Calculus BC Tier 1 criterion-4, part 2 of 2: the 19 apcalcbc-frq-u13-* items (2026-09-25).
--
-- Codex's original migration proposed all 29 Calc BC targets using
-- string_agg(frq_criteria.learner_facing_text, ...) as the canonical_answer_1 source, the same method
-- used for AP Precalculus and (successfully) for this batch's 10 np1-* siblings
-- (20260925160000_apcalcbc_np1_canonical_answers_10_items.sql). Claude's independent cross-QA (two
-- parallel agents covering these 19 items) found a genuine P1 completeness defect specific to this
-- batch: for u13-001 through u13-020 (minus u13-017, which already had a canonical), frq_criteria's
-- learner_facing_text is generic rubric-label prose ("Correctly evaluates the limit.",
-- "States the correct final derivative.") with no numbers at all, while the actual computed values
-- (limits, derivatives, tangent-line equations) live only in evidence_requirements -- a field the
-- original method never concatenates. As a result, Codex's proposed canonical text for these 19 items
-- would have stated what a correct response *does* without ever stating what the correct response *is*.
--
-- Fix: source canonical_answer_1/spans from evidence_requirements instead, which independent
-- verification confirmed contains the actual correct computed values for every one of the 19 items
-- (spot-checked against fresh from-scratch derivation, not just accepted at face value). Stripped one
-- repeated boilerplate sentence ("This criterion requires the displayed expected value and enough
-- justification to distinguish a shown argument from a bare assertion.") that QA found duplicated across
-- many criteria in the u13-010/014/018 items, which would otherwise have made the assembled text
-- extremely repetitive.
--
-- Also fixes apcalcbc-frq-u13-016's stimulus: it never stated the point (1,2) that parts B/C require,
-- even though frq_criteria's evidence_requirements assumes it (literally checks "1^2(2)+2^3=10").
-- Verified (1,2) satisfies x^2 y + y^3 = 10. Added the point to the stimulus, matching the phrasing
-- style of the sibling item u13-020, which already states its own point ("The point (1, 2) lies on this
-- curve.") for the same kind of implicit-differentiation item.
--
-- The checks below prove: target count, exact span reconstruction, exact criterion-key coverage, the
-- boilerplate sentence is fully stripped, and every one of the 19 assembled canonical texts contains at
-- least one digit (a cheap but real proof that the completeness defect this migration exists to fix is
-- actually gone, not just reworded).

begin;

update app.content_item_versions
set stimulus = stimulus || ' The point (1, 2) lies on this curve.'
where id = (
  select civ.id from app.content_items ci
  join app.content_item_versions civ on civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
  )
  where ci.content_key = 'apcalcbc-frq-u13-016'
);

do $$
declare
  v_target_count int;
begin
  with latest_versions as (
    select ci.content_key, civ.id as version_id
    from app.content_items ci
    join app.content_item_versions civ on civ.id = (
      select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
    )
    where ci.content_key = any(array[
      'apcalcbc-frq-u13-001','apcalcbc-frq-u13-002','apcalcbc-frq-u13-003','apcalcbc-frq-u13-004','apcalcbc-frq-u13-005',
      'apcalcbc-frq-u13-006','apcalcbc-frq-u13-007','apcalcbc-frq-u13-008','apcalcbc-frq-u13-009','apcalcbc-frq-u13-010',
      'apcalcbc-frq-u13-011','apcalcbc-frq-u13-012','apcalcbc-frq-u13-013','apcalcbc-frq-u13-014','apcalcbc-frq-u13-015',
      'apcalcbc-frq-u13-016','apcalcbc-frq-u13-018','apcalcbc-frq-u13-019','apcalcbc-frq-u13-020'
    ])
  )
  select count(*) into v_target_count from latest_versions;
  if v_target_count <> 19 then raise exception 'Expected 19 Calc BC u13 target versions, found %', v_target_count; end if;
end $$;

with latest_versions as (
  select ci.content_key, civ.id as version_id
  from app.content_items ci
  join app.content_item_versions civ on civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
  )
  where ci.content_key = any(array[
    'apcalcbc-frq-u13-001','apcalcbc-frq-u13-002','apcalcbc-frq-u13-003','apcalcbc-frq-u13-004','apcalcbc-frq-u13-005',
    'apcalcbc-frq-u13-006','apcalcbc-frq-u13-007','apcalcbc-frq-u13-008','apcalcbc-frq-u13-009','apcalcbc-frq-u13-010',
    'apcalcbc-frq-u13-011','apcalcbc-frq-u13-012','apcalcbc-frq-u13-013','apcalcbc-frq-u13-014','apcalcbc-frq-u13-015',
    'apcalcbc-frq-u13-016','apcalcbc-frq-u13-018','apcalcbc-frq-u13-019','apcalcbc-frq-u13-020'
  ])
),
cleaned as (
  select lv.version_id, fc.criterion_key,
    btrim(replace(fc.evidence_requirements, ' This criterion requires the displayed expected value and enough justification to distinguish a shown argument from a bare assertion.', '')) as clean_text
  from latest_versions lv
  join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
),
assembled as (
  select version_id, string_agg(clean_text, E'\n\n' order by criterion_key) as full_text
  from cleaned
  group by version_id
)
update app.content_item_versions civ
set canonical_answer_1 = assembled.full_text
from assembled
where civ.id = assembled.version_id;

with latest_versions as (
  select ci.content_key, civ.id as version_id
  from app.content_items ci
  join app.content_item_versions civ on civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
  )
  where ci.content_key = any(array[
    'apcalcbc-frq-u13-001','apcalcbc-frq-u13-002','apcalcbc-frq-u13-003','apcalcbc-frq-u13-004','apcalcbc-frq-u13-005',
    'apcalcbc-frq-u13-006','apcalcbc-frq-u13-007','apcalcbc-frq-u13-008','apcalcbc-frq-u13-009','apcalcbc-frq-u13-010',
    'apcalcbc-frq-u13-011','apcalcbc-frq-u13-012','apcalcbc-frq-u13-013','apcalcbc-frq-u13-014','apcalcbc-frq-u13-015',
    'apcalcbc-frq-u13-016','apcalcbc-frq-u13-018','apcalcbc-frq-u13-019','apcalcbc-frq-u13-020'
  ])
),
cleaned as (
  select lv.version_id, fc.criterion_key,
    btrim(replace(fc.evidence_requirements, ' This criterion requires the displayed expected value and enough justification to distinguish a shown argument from a bare assertion.', '')) as clean_text,
    row_number() over (partition by lv.version_id order by fc.criterion_key) as rn,
    count(*) over (partition by lv.version_id) as cnt
  from latest_versions lv
  join app.frq_criteria fc on fc.content_item_version_id = lv.version_id
),
span_rows as (
  select version_id, rn * 2 - 1 as span_ordinal, clean_text as span_text,
         array[criterion_key]::text[] as criterion_keys, 'drafted'::text as provenance
  from cleaned
  union all
  select version_id, rn * 2 as span_ordinal, E'\n\n' as span_text,
         array[]::text[] as criterion_keys, 'assembly_literal'::text as provenance
  from cleaned
  where rn < cnt
)
insert into app.canonical_answer_spans
  (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run)
select version_id, 'canonical_answer_1', span_ordinal, span_text, criterion_keys, provenance,
       'tier1-apcalcbc-u13-refix-2026-09-25'
from span_rows
order by version_id, span_ordinal;

do $$
declare
  v_bad_reconstruction int;
  v_bad_coverage int;
  v_boilerplate_remaining int;
  v_no_numbers int;
begin
  with latest_versions as (
    select ci.content_key, civ.id as version_id, civ.canonical_answer_1
    from app.content_items ci
    join app.content_item_versions civ on civ.id = (
      select id from app.content_item_versions v2 where v2.content_item_id = ci.id order by v2.version_num desc, v2.created_at desc limit 1
    )
    where ci.content_key = any(array[
      'apcalcbc-frq-u13-001','apcalcbc-frq-u13-002','apcalcbc-frq-u13-003','apcalcbc-frq-u13-004','apcalcbc-frq-u13-005',
      'apcalcbc-frq-u13-006','apcalcbc-frq-u13-007','apcalcbc-frq-u13-008','apcalcbc-frq-u13-009','apcalcbc-frq-u13-010',
      'apcalcbc-frq-u13-011','apcalcbc-frq-u13-012','apcalcbc-frq-u13-013','apcalcbc-frq-u13-014','apcalcbc-frq-u13-015',
      'apcalcbc-frq-u13-016','apcalcbc-frq-u13-018','apcalcbc-frq-u13-019','apcalcbc-frq-u13-020'
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
    (select count(*) from criteria_keys ck join span_keys sk using (version_id) where ck.expected_keys <> sk.actual_keys),
    (select count(*) from latest_versions where canonical_answer_1 like '%displayed expected value%'),
    (select count(*) from latest_versions where canonical_answer_1 !~ '[0-9]')
  into v_bad_reconstruction, v_bad_coverage, v_boilerplate_remaining, v_no_numbers;

  if v_bad_reconstruction <> 0 then raise exception 'Calc BC u13 refix: span reconstruction failed for % item(s)', v_bad_reconstruction; end if;
  if v_bad_coverage <> 0 then raise exception 'Calc BC u13 refix: criterion coverage failed for % item(s)', v_bad_coverage; end if;
  if v_boilerplate_remaining <> 0 then raise exception 'Calc BC u13 refix: boilerplate still present in % item(s)', v_boilerplate_remaining; end if;
  if v_no_numbers <> 0 then raise exception 'Calc BC u13 refix: % item(s) still contain no digits at all', v_no_numbers; end if;
end $$;

commit;
