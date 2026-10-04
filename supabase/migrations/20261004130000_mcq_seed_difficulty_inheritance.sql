-- DECISION-0096 / APPROVAL-0117: MCQ variants inherit the difficulty band of their seed; seeds without a band are rated
-- first and then applied to their variants. Closes servability criterion 5 for MCQ in all 10 subjects
-- (2026-10-04 six-criteria re-run, docs/product/SUBJECT_SERVABILITY_CRITERIA.md).
--
-- Step 1: rate 31 seeds that had no band (28 Calc AB Unit 2-3 originals, 3 Precalculus items). Two blind raters
--   (Claude, plus an independent fresh-context rater) on the Calc AB rubric already used in Production:
--   Easy = recognition/substitution, Medium = routine operation, Hard = justification or non-routine multi-stage;
--   ties break upward. 22 agreed (confidence medium); 9 adjacent disagreements resolved upward (confidence low).
-- Step 2: every published MCQ with no difficulty row inherits its seed's band (basis 'translated', source_value =
--   the seed's content_key, seed's confidence carried). Seed resolution, all within the subject's live pack:
--     <prefix>-sv-<n>-vK     -> <prefix>-<n>             (seeded-variant pipeline keys; case-insensitive)
--     <prefix>-u<U>v-<n>-vK  -> <prefix>-u<U>n-<n>       (Calc AB / BC Unit 1 variants)
--     <prefix>-u<U>n-<n>-vK  -> <prefix>-u<U>n-<n>       (Calc AB Unit 2-3 variants)
--   The seed's band is read from its latest version that has a difficulty row (one seed, APBIO-MCQ-025, is retired;
--   its last version's band is used).
-- Step 3: Calc BC items keyed apcalcbc-mcq-ab-<rest> are copies of AB items and inherit from apcalcab-mcq-<rest>
--   (which steps 1-2 have just rated where needed).
-- Variants that already had their own difficulty row are NOT changed.
--
-- Rollback: delete from app.content_item_difficulty where proposal_run = 'mcq-seed-difficulty-2026-10-04';
-- Trap 1: record this as version 20261004130000 on every environment (file name = ledger version).
-- Applied to Production 2026-10-04 under APPROVAL-0117: 31 seed ratings + 733 variant inheritances + 278 BC copies =
-- 1,042 rows; 0 published MCQs left without a band.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-mcq-seed-difficulty-20261004'));

create temporary table live on commit drop as
select epv.id epv_id, ep.exam_code from app.exam_pack_versions epv join app.exam_packs ep on ep.id = epv.exam_pack_id
where epv.status = 'published' and epv.retired_at is null;

-- current published version of every published MCQ in a live pack
create temporary table cur on commit drop as
select distinct on (ci.id) l.exam_code, l.epv_id, ci.id item_id, ci.content_key, civ.id civ_id
from live l
join app.content_items ci on ci.exam_pack_version_id = l.epv_id and ci.status = 'published' and ci.item_type = 'mcq'
join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
order by ci.id, civ.version_num desc;

-- step 1: the 31 seeds; a = Claude's rating, b = the independent rater's; difficulty = the higher of the two
create temporary table seed_rating (content_key text primary key, difficulty text not null, confidence text not null, a text, b text) on commit drop;
insert into seed_rating values
('apcalcab-mcq-u2n-001','Easy','medium','Easy','Easy'),('apcalcab-mcq-u2n-003','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-004','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-005','Hard','low','Medium','Hard'),('apcalcab-mcq-u2n-006','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-007','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-008','Medium','low','Easy','Medium'),('apcalcab-mcq-u2n-009','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-010','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-011','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-012','Hard','low','Medium','Hard'),('apcalcab-mcq-u2n-013','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-014','Medium','medium','Medium','Medium'),('apcalcab-mcq-u2n-015','Medium','medium','Medium','Medium'),
('apcalcab-mcq-u3n-001','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-002','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-003','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-004','Hard','medium','Hard','Hard'),('apcalcab-mcq-u3n-005','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-006','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-008','Hard','low','Medium','Hard'),('apcalcab-mcq-u3n-009','Hard','low','Medium','Hard'),('apcalcab-mcq-u3n-010','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-011','Medium','medium','Medium','Medium'),('apcalcab-mcq-u3n-012','Easy','medium','Easy','Easy'),('apcalcab-mcq-u3n-013','Hard','low','Medium','Hard'),('apcalcab-mcq-u3n-014','Hard','low','Medium','Hard'),('apcalcab-mcq-u3n-015','Hard','medium','Hard','Hard'),
('apprecalc-mcq-033','Medium','medium','Medium','Medium'),('apprecalc-mcq-np2-003','Hard','low','Medium','Hard'),('apprecalc-mcq-np2-004','Medium','low','Easy','Medium');

do $$ declare n int; begin
  select count(*) into n from seed_rating s join cur c on c.content_key = s.content_key
   where not exists (select 1 from app.content_item_difficulty d where d.content_item_version_id = c.civ_id);
  if n <> 31 then raise exception 'step 1 precondition: expected 31 unrated seeds, found %', n; end if;
end $$;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, rationale, confidence, proposal_run)
select c.civ_id, s.difficulty, 'calibrated_judgement',
  'Two blind raters (Calc AB rubric: Easy = recognition/substitution, Medium = routine operation, Hard = justification or non-routine multi-stage): '
  || s.a || ' / ' || s.b || case when s.a = s.b then '; agreed.' else '; adjacent disagreement resolved upward per the rubric.' end,
  s.confidence, 'mcq-seed-difficulty-2026-10-04'
from seed_rating s join cur c on c.content_key = s.content_key;

-- step 2: variants inherit from their seed
create temporary table resolved on commit drop as
select c.civ_id, c.content_key, s.content_key seed_key, sd.difficulty, sd.confidence
from cur c
join lateral (
  select case
    when c.content_key ~* '-sv-.+-v[0-9]+$' then regexp_replace(c.content_key, '(?i)-sv-(.+)-v[0-9]+$', '-\1')
    when c.content_key ~ '-u[0-9]+v-[0-9]+-v[0-9]+$' then regexp_replace(c.content_key, '-u([0-9]+)v-([0-9]+)-v[0-9]+$', '-u\1n-\2')
    when c.content_key ~ '-u[0-9]+n-[0-9]+-v[0-9]+$' then regexp_replace(c.content_key, '-v[0-9]+$', '')
  end seed_key_guess) g on g.seed_key_guess is not null
join app.content_items s on lower(s.content_key) = lower(g.seed_key_guess) and s.exam_pack_version_id = c.epv_id
join lateral (
  select d.difficulty, d.confidence from app.content_item_versions sv join app.content_item_difficulty d on d.content_item_version_id = sv.id
  where sv.content_item_id = s.id order by (sv.status = 'published') desc, sv.version_num desc limit 1) sd on true
where not exists (select 1 from app.content_item_difficulty d where d.content_item_version_id = c.civ_id);

insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select civ_id, difficulty, 'translated', seed_key,
  'Inherited from seed ' || seed_key || ' (DECISION-0096: an MCQ variant takes its seed''s difficulty band).', confidence,
  'mcq-seed-difficulty-2026-10-04'
from resolved;

-- step 3: Calc BC copies of AB items inherit from the AB item
create temporary table bc on commit drop as
select c.civ_id, c.content_key, ab.content_key ab_key, d.difficulty, d.confidence
from cur c
join cur ab on ab.exam_code = 'ap_calculus_ab' and ab.content_key = 'apcalcab-mcq-' || substring(c.content_key from '^apcalcbc-mcq-ab-(.*)$')
join app.content_item_difficulty d on d.content_item_version_id = ab.civ_id
where c.exam_code = 'ap_calculus_bc' and c.content_key ~ '^apcalcbc-mcq-ab-'
  and not exists (select 1 from app.content_item_difficulty x where x.content_item_version_id = c.civ_id);

insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, source_value, rationale, confidence, proposal_run)
select civ_id, difficulty, 'translated', ab_key,
  'Inherited from the AB item ' || ab_key || ', of which this BC item is a copy (DECISION-0096).', confidence,
  'mcq-seed-difficulty-2026-10-04'
from bc;

-- postcondition: no published MCQ in a live pack is left without a band
do $$ declare n int; begin
  select count(*) into n from cur c where not exists (select 1 from app.content_item_difficulty d where d.content_item_version_id = c.civ_id);
  if n <> 0 then raise exception 'postcondition: % published MCQs still without difficulty', n; end if;
  select count(*) into n from app.content_item_difficulty where proposal_run = 'mcq-seed-difficulty-2026-10-04';
  if n <> 1042 then raise exception 'postcondition: expected 1042 rows, wrote %', n; end if;
end $$;

commit;
