-- apphy1-frq-054 remediation, 2026-08-09.
--
-- Context: completed two-reviewer blind pair. Muhammad Saood approved cleanly
-- (tutor_score=1). Ahmed Ali scored approve_with_edits (tutor_score=2) with
-- three notes: (i) connect the three part-(a) calculations via a symbolic
-- range derivation, (ii) give part (b) real comparative teeth (50 deg vs
-- 40 deg), (iii) a meta-comment re: whether to bank the item at all next to
-- #6 -- NOT actionable, not acted on here. Per protocol Sec9.4: never edit
-- the reviewed version row in place -- insert a NEW content_item_versions
-- row (version_num+1) carrying the fix; the old version and its
-- review_decisions rows are left completely untouched as the historical
-- record.
--
-- Edits applied (Ahmed Ali's notes (i) and (ii) only; (iii) is out of scope
-- for a content repair -- it is a banking/retirement decision, not acted on):
--  1. Part (a) stem now requires deriving R = v0^2 sin(2*theta) / g
--     symbolically -- from R = v0x*t and t = 2*v0y/g -- BEFORE plugging in
--     numbers, connecting the three previously-independent calculations.
--     New criterion 'a-symbolic-range' (1 pt) credits this step.
--  2. Part (b) replaced: was a one-line "vertical/horizontal motion are
--     independent" recall prompt. Now asks the student to find the range of
--     a second launch at 50.0 deg (same 25.0 m/s speed) and explain why it
--     is the same as the 40.0 deg range, in terms of R's dependence on
--     sin(2*theta) and the 40/50 complementary-angle pair. New criteria
--     'b-50deg-range' (1 pt) and 'b-symmetry-explanation' (1 pt) replace the
--     old 'b-explanation' (1 pt).
--  Total points rises 4 -> 6; prompt_json.total_points updated to match.
--
-- Independent physics re-derivation (protocol Sec9, done before writing this
-- script, not read-and-trust):
--   v0x = 25.0*cos(40deg) = 19.15 m/s;  v0y = 25.0*sin(40deg) = 16.07 m/s
--   H = v0y^2/(2*9.8) = 16.07^2/19.6 = 13.2 m
--   t = 2*v0y/9.8 = 32.15/9.8 = 3.28 s
--   R = v0x*t = 19.15*3.28 = 62.8 m
--   Cross-check via symbolic formula: R = v0^2 sin(2*40deg)/g
--     = 625*sin(80deg)/9.8 = 625*0.98481/9.8 = 62.85 m  -- matches, small
--     rounding difference only, confirms the stored 62.8 m answer key.
--   50 deg case: v0x=16.07, v0y=19.15 m/s (components swap); t=2*19.15/9.8=
--     3.91 s; R=16.07*3.91=62.8 m. Via formula: R=625*sin(100deg)/9.8=
--     625*0.98481/9.8=62.85 m -- IDENTICAL to the 40 deg case, not just
--     "nearly" so: sin(100deg) = sin(180deg-100deg) = sin(80deg) EXACTLY,
--     by the identity sin(180-x)=sin(x), because 80deg and 100deg are
--     supplementary (sum to 180deg) precisely because 40deg and 50deg are
--     complementary (sum to 90deg, so their doubles sum to 180deg). So the
--     two ranges are mathematically exactly equal, and the item/criteria
--     below are worded to reflect "exactly equal" rather than "nearly
--     identical" -- correcting the reviewer note's own hedge ("nearly
--     identical") against the derivation.
--
-- Everything else in part (a) -- H=13.2 m, t=3.28 s, R=62.8 m -- is left
-- untouched; both reviewers independently confirmed it and the
-- re-derivation above agrees.
--
-- Status convention: this repair itself will go through a separate,
-- independent QA pass before publish, so no owner_remediation_approval
-- assignment/decision row is inserted here (per task instruction, matching
-- 20260809_apphy1_frq_019_ahmed_ali_repair.sql / Pool 2 pattern). The new
-- version is left at 'reviewed_approved' and is NOT published.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy1-frq-054-ahmed-ali-repair-20260809'));

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_new_stem text;
  v_new_stimulus text;
  v_new_prompt_json jsonb;
  v_old_total integer;
  v_new_total integer;
begin
  select * into strict v_item
  from app.content_items
  where content_key='apphy1-frq-054' and item_type='frq'
  for update;

  select * into strict v_old
  from app.content_item_versions
  where content_item_id=v_item.id
  order by version_num desc
  limit 1
  for update;

  if v_old.id <> '557ba080-3a9b-4754-ad13-8cb3c9ebbd15'::uuid then
    raise exception 'unexpected current latest version id %, expected 557ba080-3a9b-4754-ad13-8cb3c9ebbd15', v_old.id;
  end if;

  select coalesce(sum(points_possible),0) into v_old_total
  from app.frq_criteria where content_item_version_id=v_old.id;

  if v_old_total <> 4 then
    raise exception 'unexpected old points total %, expected 4', v_old_total;
  end if;
  v_new_total := v_old_total + 2;

  v_new_stem := 'Answer all parts of the following question.'
    || E'\n\n(a) Determine the horizontal and vertical components of the initial velocity, v0x and v0y. Before substituting any numbers, combine R = v0x t and t = 2v0y/g (with v0x = v0 cosθ, v0y = v0 sinθ) to derive the range symbolically as R = v0² sin(2θ)/g. Then use this relationship, together with H = v0y²/(2g), to calculate the maximum height, the total time of flight, and the horizontal range.'
    || E'\n\n(b) A second projectile is launched from the same location at the same initial speed, 25.0 m/s, but at 50.0° above the horizontal instead of 40.0°. Determine the range of this second launch and compare it to the range found in part (a). Then explain, in terms of the dependence of R on sin(2θ), why launching at 40° and at 50° (at the same speed) produces the same range.';

  v_new_stimulus := v_old.stimulus;

  v_new_prompt_json := coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
    'total_points', v_new_total,
    'content_version', v_old.version_num+1,
    'qa_remediation', '2026-08-09 apphy1-frq-054 repair per Ahmed Ali approve_with_edits note items (i) and (ii); note (iii) [bank-vs-#6] is a meta/scheduling comment, not acted on (protocol Sec9.4)',
    'qa_source_version_id', v_old.id
  );

  insert into app.content_item_versions (
    id, content_item_id, version_num, stem, stimulus, prompt_json,
    explanation, help_text, content_hash, status, created_by,
    canonical_answer_1, canonical_answer_2, review_status,
    rubric_type, evaluator_strategy, stimulus_image_path
  ) values (
    v_new, v_item.id, v_old.version_num+1, v_new_stem, v_new_stimulus, v_new_prompt_json,
    v_old.explanation, v_old.help_text,
    md5(coalesce(v_new_stem,'')||E'\n'||coalesce(v_new_stimulus,'')),
    'reviewed_approved', v_old.created_by,
    v_old.canonical_answer_1, v_old.canonical_answer_2, 'question_review_approved',
    v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
  );

  -- Carry forward unchanged part-(a) numeric criteria verbatim.
  insert into app.frq_criteria (
    content_item_version_id, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  )
  select v_new, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  from app.frq_criteria
  where content_item_version_id=v_old.id
    and criterion_key in ('a-height','a-time','a-range');

  -- New criterion: symbolic derivation connecting the three part-(a) results.
  -- New criteria replacing 'b-explanation': 50-degree range + sin(2theta) symmetry.
  insert into app.frq_criteria (
    content_item_version_id, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  ) values (
    v_new, 'a-symbolic-range',
    'Derives the range symbolically as R = v0² sin(2θ)/g by combining R = v0x t with t = 2v0y/g and v0x = v0 cosθ, v0y = v0 sinθ, before substituting numbers.',
    1,
    'Shows the algebraic combination R = v0x t, t = 2v0y/g → R = 2 v0x v0y / g = v0² sin(2θ)/g, prior to plugging in v0=25.0 m/s and θ=40.0°.',
    'Combine the horizontal-velocity and time-of-flight expressions algebraically to reach R = v0² sin(2θ)/g before substituting numbers.',
    '["Equivalent algebraic derivation reaching R = v0² sin(2θ)/g by a different valid route earns credit."]'::jsonb
  ), (
    v_new, 'b-50deg-range',
    'Determines the range for a 50.0° launch at the same 25.0 m/s speed (R ≈ 62.8 m) and states that it equals the 40.0° range from part (a).',
    1,
    'Uses R = v0² sin(2θ)/g with θ=50.0° (sin 100° ≈ 0.985) to get ≈ 62.8 m, or recomputes v0x, v0y, t, R at 50.0° directly, and explicitly compares the result to part (a).',
    'Substitute θ=50° into R = v0² sin(2θ)/g (or recompute v0x, v0y, t, R at 50°) and compare the result to the 40° range.',
    '["Equivalent algebraically correct reasoning with consistent units earns credit."]'::jsonb
  ), (
    v_new, 'b-symmetry-explanation',
    'Explains that the two ranges are equal because range depends on sin(2θ), and 40° and 50° are complementary angles (sum to 90°), so 2×40°=80° and 2×50°=100° are supplementary (sum to 180°) and therefore have exactly equal sine, by sin(180°−x)=sin(x).',
    1,
    'States or uses the sin(2θ) dependence of R and identifies that θ and 90°−θ give the same range because their doubled angles are supplementary, so sin(2θ) is the same for both; credits recognizing the equality is exact, not merely approximate.',
    'Identify that 40° and 50° sum to 90°, so their doubled angles (80°, 100°) are supplementary and have equal sine, making the ranges equal.',
    '["Equivalent algebraically correct reasoning with consistent units earns credit."]'::jsonb
  );

  update app.content_item_versions
  set content_hash = md5(coalesce(stem,'')||E'\n'||coalesce(stimulus,'')||E'\n'||
    coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text, E'\n' order by fc.criterion_key)
              from app.frq_criteria fc where fc.content_item_version_id=v_new),''))
  where id=v_new;

  update app.content_items
  set status='reviewed_approved', updated_at=now()
  where id=v_item.id;

  -- Sanity checks.
  select coalesce(sum(points_possible),0) into v_new_total
  from app.frq_criteria where content_item_version_id=v_new;
  if v_new_total <> v_old_total + 2 then
    raise exception 'new points total % does not equal old total %+2', v_new_total, v_old_total;
  end if;

  if (select count(*) from app.frq_criteria where content_item_version_id=v_new) <> 6 then
    raise exception 'expected 6 criteria rows on new version, got %',
      (select count(*) from app.frq_criteria where content_item_version_id=v_new);
  end if;

  -- Confirm the old version row was not touched.
  if (select row(civ.*) from app.content_item_versions civ where civ.id=v_old.id) is distinct from (select row(v_old.*)) then
    raise exception 'old version row was modified -- protocol Sec9.4 violation';
  end if;

  raise notice 'new content_item_version_id: %', v_new;
end $$;

select v.id as new_version_id, v.version_num, v.status, v.review_status,
       v.stem, v.stimulus, v.prompt_json->'total_points' as total_points
from app.content_item_versions v
join app.content_items ci on ci.id=v.content_item_id
where ci.content_key='apphy1-frq-054'
order by v.version_num desc
limit 1;

select criterion_key, points_possible, learner_facing_text
from app.frq_criteria fc
join app.content_item_versions v on v.id=fc.content_item_version_id
join app.content_items ci on ci.id=v.content_item_id
where ci.content_key='apphy1-frq-054' and v.version_num = (
  select max(version_num) from app.content_item_versions v2
  join app.content_items ci2 on ci2.id=v2.content_item_id
  where ci2.content_key='apphy1-frq-054'
)
order by criterion_key;

commit;
