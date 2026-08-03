-- Distractor-rationale repair, AP Chemistry (2026-07-31) — APPLIED.
--
-- Same defect class as the Precalculus batch: a distractor's stated rationale
-- does not derive its own stated value, or two distractors carry the SAME value.
-- Diagnosed by Muhammad Saood, plus two duplicate-value defects found by the
-- value-level check during the 2026-07-31 sweep (the string-distinctness check
-- passes on both because the prose differs).
--
-- Each item gets a v2 successor; v1 retired; open v1 assignments skipped.
-- v2 lands as `draft` and must be reviewed before it can be approved again.
--
-- Value changes (not just rationale rewrites):
--   apchem-mcq-068 D  +179 kJ/mol -> +90 kJ/mol
--       B and D were BOTH "+179 kJ/mol; nonfavorable" — indistinguishable to a
--       student who computed +179. Choices are now a clean sign x n grid:
--       A -179 (correct), B +179, C -90, D +90.
--   apchem-mcq-070 D  8.98 g -> 2.24 g
--       C and D were BOTH "approximately 8.98 g" AND encoded the same
--       misconception (n=1 instead of n=2). D now uses a distinct error path:
--       0.224 mol e- / 4 = 0.056 mol Ca = 2.24 g. (Saood suggested ~2.25 g.)
--   apchem-mcq-030 B  reworded so it no longer implies CH3F has ONLY
--       dipole-dipole forces; London dispersion is present in every molecule.
--
-- Stem change:
--   apchem-mcq-069  "Ecell = +1.10 V" -> "E°cell = +1.10 V". The stem defined
--       Ecell and then asked the student to compare Ecell to Ecell(standard) —
--       a symbol compared against itself.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-rationale-repair-chem-20260731'));

create temporary table cm on commit drop as
select ci.id item_id, civ.id old_vid, ci.content_key,
       gen_random_uuid() new_vid, civ.version_num+1 nv
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id=ci.id
where ci.content_key in (
  'apchem-mcq-001','apchem-mcq-030','apchem-mcq-059',
  'apchem-mcq-068','apchem-mcq-069','apchem-mcq-070')
  and civ.status<>'retired'
  and not exists (select 1 from app.content_item_versions n
                  where n.content_item_id=ci.id and n.version_num>civ.version_num);

do $$ declare n int; begin
  select count(*) into n from cm;
  if n<>6 then raise exception 'expected 6 chemistry targets, found %', n; end if;
end $$;

insert into app.content_item_versions (
  id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,
  content_hash,status,created_by,canonical_answer_1,canonical_answer_2,
  review_status,rubric_type,evaluator_strategy,stimulus_image_path)
select m.new_vid, m.item_id, m.nv,
       case when m.content_key='apchem-mcq-069'
            then replace(o.stem,'Ecell = +1.10 V','E°cell = +1.10 V')
            else o.stem end,
       o.stimulus,
       coalesce(o.prompt_json,'{}'::jsonb) || jsonb_build_object(
         'content_version',m.nv,
         'qa_remediation','2026-07-31 distractor-rationale repair'),
       o.explanation,o.help_text,md5(o.stem),'draft',
       'f5a26c6b-3566-4d58-9e97-979fbb947564',
       o.canonical_answer_1,o.canonical_answer_2,null,
       o.rubric_type,o.evaluator_strategy,o.stimulus_image_path
from cm m join app.content_item_versions o on o.id=m.old_vid;

insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
select m.new_vid, c.choice_key, c.choice_text, c.is_correct, c.rationale
from cm m join app.mcq_choices c on c.content_item_version_id=m.old_vid;

update app.content_review_assignments set status='skipped'
where content_item_version_id in (select old_vid from cm)
  and status in ('pending','in_progress');

update app.content_item_versions set status='retired', updated_at=now()
where id in (select old_vid from cm);
update app.content_items set status='draft', updated_at=now()
where id in (select item_id from cm);

with fixes(ck, chk, new_text, new_rat) as (values
 ('apchem-mcq-001','B', null, 'Correct: n = m/M = 9.00 g ÷ 18.0 g mol⁻¹ = 0.500 mol. The grams cancel to leave moles, and the answer carries three significant figures to match the data.'),
 ('apchem-mcq-030','B', 'CH3OH can form hydrogen bonds through its O-H bond, while CH3F is limited to dipole-dipole and London dispersion forces.', 'Correct: CH3OH has an O-H bond, so its molecules form strong hydrogen bonds with one another. CH3F is polar but has no H bonded directly to N, O, or F, so it is limited to dipole-dipole attraction together with the London dispersion forces every molecule has. Hydrogen bonding accounts for the much higher boiling point of CH3OH.'),
 ('apchem-mcq-059','C', null, 'Incorrect: rounds the pH to 2.40 rather than 2.60 before subtracting, giving 14.00 − 2.40 = 11.60.'),
 ('apchem-mcq-059','D', null, 'Incorrect: misplaces the decimal in the concentration, using 0.025 M to obtain pH = 1.60, then 14.00 − 1.60 = 12.40.'),
 ('apchem-mcq-068','D', 'deltaG approximately +90 kJ/mol; nonfavorable, using deltaG = nFE with n = 1 and E = 0.93 V.', 'Incorrect: this compounds two errors. It omits the negative sign in deltaG = -nFE and uses n = 1 instead of the two electrons actually transferred, giving +90 kJ/mol rather than -179 kJ/mol.'),
 ('apchem-mcq-070','D', 'approximately 2.24 g, from dividing the electron amount by 4 instead of 2.', 'Incorrect: divides the 0.224 mol of electrons by 4 rather than by the 2 electrons required per Ca2+ ion, giving 0.056 mol Ca and about 2.24 g.')
)
update app.mcq_choices c
set rationale=f.new_rat, choice_text=coalesce(f.new_text,c.choice_text)
from fixes f join cm m on m.content_key=f.ck
where c.content_item_version_id=m.new_vid and c.choice_key=f.chk;

commit;
