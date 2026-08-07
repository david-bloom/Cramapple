-- Extend Chisom Anuba's gold-set marking queue with 1 answer from each of the
-- three Calculus-family subjects (AP Calculus AB, AP Calculus BC, AP
-- Precalculus), in addition to the 4 Physics gold-set answers assigned
-- earlier today (20260806_chisom_physics_calc_onboarding.sql).
--
-- Owner instruction, 2026-08-06: "Assign Chisom 1 item of each of the three
-- calculus subjects in addition to the physics."
--
-- No reviewer has touched any Calc AB / BC / Precalculus gold-set answer
-- before this. Chisom already holds the gold-set-review feature flag and an
-- active grading qualification covering all three subjects.

select app.seed_gold_set_verification_assignments(
  '1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid,
  array[
    '98960690-c953-45ad-a939-91abd113774e', -- AP Calculus AB, apcalcab-frq-023, A1
    'caef9f60-ff4f-4505-832e-b88effc213cc', -- AP Calculus BC, apcalcbc-frq-017, A1
    '34703f13-dcfc-4441-b925-e33bddba832f'  -- AP Precalculus, apprecalc-frq-001, A1
  ]::uuid[],
  1
) as gold_set_assignments_created;

-- Verification.
select ci.content_key, s.display_name subject, ga.answer_type, gva.status
from app.gold_set_verification_assignments gva
join app.gold_set_answers ga on ga.gold_set_answer_id=gva.gold_set_answer_id
join app.content_item_versions civ on civ.id=ga.content_item_version_id
join app.content_items ci on ci.id=civ.content_item_id
join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
join app.exam_packs ep on ep.id=epv.exam_pack_id
join app.subjects s on s.id=ep.subject_id
where gva.reviewer_id='1cb76137-fe12-4973-877b-f1e32e9e4cfc'::uuid
order by subject, ci.content_key;
