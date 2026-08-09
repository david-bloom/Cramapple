-- apphy1-frq-019 remediation, 2026-08-09.
--
-- Context: completed two-reviewer blind pair. Muhammad Saood approved cleanly
-- (tutor_score=1, assignment 7e16268c-2bac-4518-8f06-26e10c8948d0). Ahmed Ali
-- (assignment 63adcb69-2ff1-4165-a614-1a17b25130c6) scored approve_with_edits
-- (tutor_score=2) with four notes. Per protocol Sec9.4: never edit the
-- reviewed version row in place -- insert a NEW content_item_versions row
-- (version_num+1) carrying the fix; the old version (053b7d9e-b39f-41ea-9048-
-- 5f5f58f9c17b, version_num=1) and its review_decisions rows are left
-- completely untouched as the historical record.
--
-- Edits applied (Ahmed Ali's note, and only that note):
--  1. CED-currency note: no content change requested -- Ahmed flagged it only
--     because the topic's CED status recently changed, for retagging IF the
--     item targeted the older framework. This item is already correctly
--     tagged prompt_json.topic='1.4' under the current CED (relative
--     velocity / reference frames, Physics 1 Unit 1) -- confirmed no
--     retag needed, so no change made for this note.
--  2. Added the v_bs = v_bw + v_ws subscript notation to part (a) of the
--     stem, so the item actually introduces the frame-bookkeeping
--     convention it tests.
--  3. Added an explicit statement that the river's banks run east-west, so
--     the 120 m width is stated (not left inferable) as measured
--     perpendicular to the current, to the stimulus (the scenario/geometry
--     field; "the stem" in the reviewer's shorthand for "item text").
--  4. Split criterion 'a-vector-sum' (1 pt) into two 1-pt criteria:
--     'a-vector-headtotail' (correct head-to-tail component placement) and
--     'a-vector-resultant' (correct labeled resultant). Total points rises
--     6 -> 7; prompt_json.total_points added/set to 7 to match.
--
-- Everything else -- parts (b)/(c), the 3-4-5 triangle result (5.0 m/s at
-- ~37 deg east of north), the 30 s crossing time (from the 4.0 m/s northward
-- component alone), and the 90 m downstream displacement -- is left
-- untouched; both reviewers independently confirmed it correct, and an
-- independent re-derivation this session (see below) agrees:
--   |v_bs| = sqrt(4.0^2 + 3.0^2) = sqrt(25) = 5.0 m/s
--   theta  = atan(3.0/4.0) = 36.87 deg ~= 37 deg east of north
--   t      = 120 m / 4.0 m/s (northward component only) = 30 s
--   drift  = 3.0 m/s * 30 s = 90 m
-- All four independently re-solved and match the existing answer key exactly.
--
-- Status convention: this repair itself will go through a separate,
-- independent QA pass before publish, so no owner_remediation_approval
-- assignment/decision row is inserted here (per task instruction). The new
-- version is left at 'reviewed_approved' -- matching this session's Pool 2
-- pattern (20260809_pool2_minor_notes_repair.sql) for a freshly-inserted
-- repaired version pending the next QA+publish step -- and is NOT published.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy1-frq-019-ahmed-ali-repair-20260809'));

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
  where content_key='apphy1-frq-019' and item_type='frq'
  for update;

  select * into strict v_old
  from app.content_item_versions
  where content_item_id=v_item.id
  order by version_num desc
  limit 1
  for update;

  if v_old.id <> '053b7d9e-b39f-41ea-9048-5f5f58f9c17b'::uuid then
    raise exception 'unexpected current latest version id %, expected 053b7d9e-b39f-41ea-9048-5f5f58f9c17b', v_old.id;
  end if;

  select coalesce(sum(points_possible),0) into v_old_total
  from app.frq_criteria where content_item_version_id=v_old.id;

  if v_old_total <> 6 then
    raise exception 'unexpected old points total %, expected 6', v_old_total;
  end if;
  v_new_total := v_old_total + 1;

  v_new_stem := 'Answer all parts of the following question.'
    || E'\n\n(a) Draw a vector diagram that relates the boat-water, water-shore, and boat-shore velocities, using the notation v⃗_bs = v⃗_bw + v⃗_ws.'
    || E'\n\n(b) Determine the boat''s speed and direction relative to shore.'
    || E'\n\n(c) Determine the crossing time and downstream displacement.';

  v_new_stimulus := 'A rescue boat moves at 4.0 m/s due north relative to the water while the river flows at 3.0 m/s east relative to shore. The river''s banks run east-west, so the river''s 120 m width is measured perpendicular to the current.';

  v_new_prompt_json := coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
    'total_points', v_new_total,
    'content_version', v_old.version_num+1,
    'qa_remediation', '2026-08-09 apphy1-frq-019 repair per Ahmed Ali approve_with_edits note (protocol Sec9.4)',
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

  -- Carry forward unchanged criteria verbatim.
  insert into app.frq_criteria (
    content_item_version_id, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  )
  select v_new, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  from app.frq_criteria
  where content_item_version_id=v_old.id
    and criterion_key <> 'a-vector-sum';

  -- Split criterion: a-vector-sum (1 pt) -> two 1-pt criteria.
  insert into app.frq_criteria (
    content_item_version_id, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix, accepted_variants
  ) values (
    v_new, 'a-vector-headtotail',
    'Places the northward 4.0 m/s vector (v⃗_bw) and eastward 3.0 m/s vector (v⃗_ws) head-to-tail.',
    1,
    'Two perpendicular component vectors drawn head-to-tail (the tail of one at the head of the other), each correctly oriented (north, east) and labeled.',
    'Redraw the two component vectors head-to-tail instead of from a common origin.',
    '["Equivalent algebraically correct reasoning with consistent units earns credit."]'::jsonb
  ), (
    v_new, 'a-vector-resultant',
    'Draws and labels the resultant v⃗_bs from the tail of the first vector to the head of the second, pointing northeast.',
    1,
    'A single labeled resultant vector (v⃗_bs) connecting the start of the head-to-tail diagram to its end, distinct from the two component vectors.',
    'Add a labeled resultant vector connecting the diagram''s start and end points.',
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
  if v_new_total <> v_old_total + 1 then
    raise exception 'new points total % does not equal old total %+1', v_new_total, v_old_total;
  end if;

  if (select count(*) from app.frq_criteria where content_item_version_id=v_new) <> 7 then
    raise exception 'expected 7 criteria rows on new version, got %',
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
where ci.content_key='apphy1-frq-019'
order by v.version_num desc
limit 1;

select criterion_key, points_possible, learner_facing_text
from app.frq_criteria fc
join app.content_item_versions v on v.id=fc.content_item_version_id
join app.content_items ci on ci.id=v.content_item_id
where ci.content_key='apphy1-frq-019' and v.version_num = (
  select max(version_num) from app.content_item_versions v2
  join app.content_items ci2 on ci2.id=v2.content_item_id
  where ci2.content_key='apphy1-frq-019'
)
order by criterion_key;

commit;
