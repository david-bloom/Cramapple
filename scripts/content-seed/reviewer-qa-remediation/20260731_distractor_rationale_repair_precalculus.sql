-- Distractor-rationale repair, AP Precalculus (2026-07-31) — APPLIED.
--
-- Defect class: a distractor's stated rationale does not derive its own stated
-- value. Diagnosed by Abdul Hanan (8 items) and Shazia Fazal (3 overlapping),
-- whose approve_with_edits notes had sat unapplied because an approve_with_edits
-- leaves the item `reviewed_approved` with no successor version cut.
--
-- Each item gets a v2 successor; v1 is retired; open assignments on v1 skipped.
-- v2 lands as `draft` and requires review before it can be approved again.
--
-- Two items required a choice-VALUE change, not just a rationale rewrite,
-- because no defensible error path produced the printed value:
--   apprecalc-mcq-015 C: 3π/5 → 5π/3   (now: uses π/90 instead of π/180)
--   apprecalc-mcq-019 D: (3/2,−3√3/2) → (−3/2,−3√3/2)  (clean sin/cos swap)
-- All four choices remain distinct in both items.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-rationale-repair-precalc-20260731'));

create temporary table repair_map on commit drop as
select ci.id item_id, civ.id old_vid, ci.content_key,
       gen_random_uuid() new_vid, civ.version_num+1 nv
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in (
  'apprecalc-mcq-001','apprecalc-mcq-006','apprecalc-mcq-009','apprecalc-mcq-011',
  'apprecalc-mcq-012','apprecalc-mcq-015','apprecalc-mcq-016','apprecalc-mcq-019')
  and civ.status<>'retired'
  and not exists (select 1 from app.content_item_versions n
                  where n.content_item_id=ci.id and n.version_num>civ.version_num);

do $$ declare n int; begin
  select count(*) into n from repair_map;
  if n<>8 then raise exception 'expected 8 precalc targets, found %', n; end if;
end $$;

insert into app.content_item_versions (
  id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,
  content_hash,status,created_by,canonical_answer_1,canonical_answer_2,
  review_status,rubric_type,evaluator_strategy,stimulus_image_path)
select r.new_vid, r.item_id, r.nv, o.stem, o.stimulus,
       coalesce(o.prompt_json,'{}'::jsonb) || jsonb_build_object(
         'content_version', r.nv,
         'qa_remediation','2026-07-31 distractor-rationale repair'),
       o.explanation,o.help_text,md5(o.stem),'draft',
       'f5a26c6b-3566-4d58-9e97-979fbb947564',
       o.canonical_answer_1,o.canonical_answer_2,null,
       o.rubric_type,o.evaluator_strategy,o.stimulus_image_path
from repair_map r join app.content_item_versions o on o.id=r.old_vid;

insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
select r.new_vid, c.choice_key, c.choice_text, c.is_correct, c.rationale
from repair_map r join app.mcq_choices c on c.content_item_version_id=r.old_vid;

update app.content_review_assignments set status='skipped'
where content_item_version_id in (select old_vid from repair_map)
  and status in ('pending','in_progress');

update app.content_item_versions set status='retired', updated_at=now()
where id in (select old_vid from repair_map);

update app.content_items set status='draft', updated_at=now()
where id in (select item_id from repair_map);

-- Authored corrections applied to the v2 choices.
with fixes(ck, chk, new_text, new_rat) as (values
 ('apprecalc-mcq-001','A', null, 'Evaluates the function at the change in input, f(4 − 1) = f(3) = 3² − 3(3) = 0, instead of forming the difference quotient [f(4) − f(1)]/(4 − 1).'),
 ('apprecalc-mcq-001','D', null, 'Treats the −3x term as the constant −3, so f(1) = 1 − 3 = −2 and f(4) = 16 − 3 = 13; dividing the difference by 3 gives 5.'),
 ('apprecalc-mcq-006','C', null, 'Computes f(g(x)) = 2(x² + 3) − 1 = 2x² + 5 instead of g(f(x)), reversing the order of composition.'),
 ('apprecalc-mcq-009','A', null, 'Treats the equation as x − 1 = 3, using the exponent alone and omitting the exponentiation, which gives x = 4.'),
 ('apprecalc-mcq-011','C', null, 'Solves 2x − 1 = log₅17 incorrectly by multiplying by 2 and adding 1, instead of adding 1 and dividing by 2, giving 1 + 2log₅17.'),
 ('apprecalc-mcq-011','D', null, 'Attempts to remove the coefficient 2 by dividing the argument rather than the exponent, giving log₅(17/2), and drops the −1 term entirely.'),
 ('apprecalc-mcq-012','D', null, 'A U-shaped residual pattern is evidence about model fit, not about variable type. It says nothing about whether the response is categorical; a categorical response would not produce a residual plot of this kind at all.'),
 ('apprecalc-mcq-015','C', '5π/3', 'Uses π/90 instead of π/180 in the conversion, giving 150 × π/90 = 5π/3, twice the correct measure.'),
 ('apprecalc-mcq-016','C', null, 'Takes the amplitude correctly as 4 but mistakes the given period, 8, for the midline. The midline is the average of the maximum and minimum, (14 + 6)/2 = 10.'),
 ('apprecalc-mcq-019','D', '(−3/2,−3√3/2)', 'Interchanges the sine and cosine components, computing x = r sinθ = −3(1/2) = −3/2 and y = r cosθ = −3(√3/2) = −3√3/2.')
)
update app.mcq_choices c
set rationale = f.new_rat,
    choice_text = coalesce(f.new_text, c.choice_text)
from fixes f
join repair_map r on r.content_key = f.ck
where c.content_item_version_id = r.new_vid and c.choice_key = f.chk;

commit;
