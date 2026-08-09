-- Gold-set reviewer expansion, 2026-08-09.
--
-- Owner directed: add Abdul Hanan (Calculus-qualified) and Ahmed Ali
-- (Physics-qualified) to the gold-set-review roster, pair them with Chisom
-- Anuba's existing unpaired answers rather than seeding a fresh batch, and
-- give Abdul the leftover Precalculus answer too.
--
-- Prior state: only Jill Schmidlkofer (Statistics), Muhammad Saood
-- (Physics/Calc/Precalc/Chemistry), Chisom Anuba (added 2026-08-06 --
-- Physics/Calc/Precalc), and the Tutor Beta fixture held the
-- 'gold-set-review' feature flag. Statistics already has real two-reader
-- coverage (65 answers assigned to both Jill and Saood, per the 2026-08-04
-- protocol amendment). Chisom's 7 pending answers (1 each: Calc AB, Calc
-- BC, Physics 1/2/C-Mech/C-E&M, Precalculus) were all unpaired.

begin;

insert into app.feature_flag_assignments (user_id, feature_key, enabled, expires_at, assigned_by)
select p.user_id, 'gold-set-review', true, null, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.profiles p
where p.full_name in ('Abdul Hanan','Ahmed Ali')
on conflict (user_id, feature_key) do update set enabled=true, expires_at=null;

commit;

-- Pairing (run as separate statements -- the seeding function uses an
-- on-commit-drop temp table internally and errors if called twice in the
-- same implicit transaction/statement batch).

select app.seed_gold_set_verification_assignments(
  (select user_id from app.profiles where full_name='Abdul Hanan'),
  array['98960690-c953-45ad-a939-91abd113774e','caef9f60-ff4f-4505-832e-b88effc213cc']::uuid[], -- Calc AB, Calc BC
  1
);

select app.seed_gold_set_verification_assignments(
  (select user_id from app.profiles where full_name='Ahmed Ali'),
  array['4d1742c5-a7e0-4371-87f5-061ec5d601d8','2a982ce8-1c69-475b-a34a-0f56bd6f6791','219ab99f-bc3e-43c5-bf29-60f8fc6a4e16','bec29523-1c59-4944-a875-ee0824bf5606']::uuid[], -- Physics 1/2/C-Mech/C-E&M
  1
);

select app.seed_gold_set_verification_assignments(
  (select user_id from app.profiles where full_name='Abdul Hanan'),
  array['34703f13-dcfc-4441-b925-e33bddba832f']::uuid[], -- Precalculus, leftover from Chisom's original unpaired set
  1
);
