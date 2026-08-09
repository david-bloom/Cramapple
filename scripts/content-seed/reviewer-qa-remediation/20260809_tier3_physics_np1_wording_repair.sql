-- Tier 3 QA sweep repair: Physics 1 / Physics C E&M np1-batch wording and
-- precision fixes, 2026-08-09. See
-- docs/Q&A/CHANGES_REQUESTED_QA_2026_08_09.md for full context.
--
-- Scope: 24 of the 26 np1 physics items flagged by Muhammad Saood's review
-- (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_09.md), minus apphycem-mcq-np1-001 and
-- apphycem-mcq-np1-006 (already repaired in
-- 20260809_tier1_genuine_defects_repair.sql, since those two had confirmed
-- distractor-value defects rather than pure wording gaps).
--
-- In every item here, Saood independently re-derived the underlying physics
-- and confirmed it correct -- these are ambiguity/precision gaps (missing
-- |.| notation, unstated reference conventions, unstated motion/geometry
-- assumptions, edge cases where a normal force is zero and has no defined
-- direction), not wrong answers. Fixes are stem/rationale wording additions
-- only; no canonical answer, criterion point value, or MCQ correct-choice
-- key was changed anywhere in this tier.
--
-- Two items got no version change:
--   apphycem-mcq-np1-010: reviewed against Saood's note; option D's rationale
--     already states a concrete, correct mechanism (dividing by 24 instead of
--     6 faces) -- no defect confirmed. Approved on its existing version.
--   apphycem-mcq-np1-008: Saood also flagged options C and D as vague; this
--     session could not independently reconstruct their claimed values (59.9 V,
--     539.4 V) via any tested mechanism. Left in changes_requested, deferred
--     for author-level reconstruction, same discipline as apcalcab-mcq-048/049
--     in the Tier 1 script.
--
-- One numeric claim was checked and found NOT to be a defect:
--   apphycem-frq-np1-004's rubric value 124.680 V was independently
--   re-derived (V=kQ/sqrt(x^2+R^2), k=8.99e9) and confirmed correct to
--   three decimals -- Saood's flagged "inconsistency" doesn't hold up on
--   direct computation. Only the k-value/reference-convention wording was
--   added; the stored value was not touched.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-tier3-physics-np1-wording-20260809'));

create temporary table t3_frq_targets (content_key text primary key) on commit drop;
insert into t3_frq_targets values
('apphy1-frq-np1-002'),('apphy1-frq-np1-003'),('apphy1-frq-np1-004'),('apphy1-frq-np1-006'),('apphy1-frq-np1-009'),
('apphycem-frq-np1-001'),('apphycem-frq-np1-002'),('apphycem-frq-np1-003'),('apphycem-frq-np1-004'),
('apphycem-frq-np1-005'),('apphycem-frq-np1-006'),('apphycem-frq-np1-007'),('apphycem-frq-np1-009'),('apphycem-frq-np1-010');

create temporary table t3_mcq_targets (content_key text primary key) on commit drop;
insert into t3_mcq_targets values
('apphy1-mcq-np1-001'),('apphy1-mcq-np1-003'),('apphy1-mcq-np1-004'),('apphy1-mcq-np1-008'),('apphy1-mcq-np1-010'),
('apphycem-mcq-np1-004'),('apphycem-mcq-np1-005'),('apphycem-mcq-np1-009');

create temporary table t3_versioned (content_key text primary key, item_type text not null, new_version_id uuid not null) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select content_key,'frq' as item_type from t3_frq_targets
           union all select content_key,'mcq' from t3_mcq_targets
           order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key for update;
    select * into strict v_old from app.content_item_versions
    where content_item_id=v_item.id order by version_num desc limit 1 for update;

    v_new := gen_random_uuid();
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-09 changes_requested QA sweep Tier 3 -- wording/precision clarification'
      ),
      v_old.explanation,v_old.help_text,md5(t.content_key||'-tier3-v'||(v_old.version_num+1)),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    if t.item_type='frq' then
      insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants)
      select v_new,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants
      from app.frq_criteria where content_item_version_id=v_old.id;
    else
      insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
      select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
    end if;

    insert into t3_versioned values (t.content_key,t.item_type,v_new);
  end loop;
end $$;

-- FRQ stem edits.
update app.content_item_versions civ set stem=replace(replace(stem,
  '(a) Calculate the object''s acceleration during the interval 0 <= t <= 4 s.','(a) Calculate the object''s acceleration during the interval 0 < t < 4 s.'),
  '(d) State the object''s acceleration during the interval 4 s <= t <= 6 s.','(d) State the object''s acceleration during the interval 4 s < t < 6 s.')
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-frq-np1-002';

update app.content_item_versions civ set stem=replace(stem,
  '(c) Calculate the vertical component of the ball''s velocity the instant before it lands.',
  '(c) Calculate the vertical component of the ball''s velocity the instant before it lands, and state its direction (taking upward as positive, express this as a signed value).')
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-frq-np1-003';

update app.content_item_versions civ set stem='Assume the block is moving in the direction of the applied 20 N force throughout.'||E'\n\n'||stem
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-frq-np1-004';

update app.content_item_versions civ set stem=replace(stem,
  '(c) At the top of the loop, state the direction of the normal force exerted by the track on the ball, and justify your answer.',
  '(c) When the ball''s speed at the top of the loop is greater than the minimum speed found in part (a) (so the normal force is nonzero), state the direction of the normal force exerted by the track on the ball, and justify your answer.')
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-frq-np1-006';

update app.content_item_versions civ set stem=stem||' Take gravitational potential energy to be zero at the bottom of the incline, and assume the block separates from the spring once the spring reaches its natural length.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-frq-np1-009';

update app.content_item_versions civ set stem=stem||' Assume the linear charge density lambda is positive, and express field magnitudes using |lambda| where relevant.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-001';

update app.content_item_versions civ set stem=stem||' Justify, using cylindrical symmetry, why the electric field is radial and constant in magnitude on the Gaussian surface you use.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-002';

update app.content_item_versions civ set stem=stem||' Treat x as a nonnegative distance from the center; justify that the value of x found in part (b) gives a maximum using the sign of dE/dx on either side, or by comparing to E(0)=0 and the behavior of E(x) as x approaches infinity.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-003';

update app.content_item_versions civ set stem=stem||' Use the standard reference V(infinity)=0, and use k=8.99e9 N*m^2/C^2.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-004';

update app.content_item_versions civ set stem=replace(stem,
  '(b) Describe qualitatively how the charge is distributed on the sphere''s surface once equilibrium is reached, and explain your reasoning using the fact that a conductor in electrostatic equilibrium is an equipotential surface.',
  '(b) Describe qualitatively how the charge is distributed on the sphere''s surface once equilibrium is reached, using +x and -x to label the two sides along the external field''s direction (note the induced surface-charge component is negative on the -x side, though the total charge there may still be net positive if Q is large), and explain your reasoning using the fact that a conductor in electrostatic equilibrium is an equipotential surface.')
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-005';

update app.content_item_versions civ set stem=replace(stem,
  '(c) The sphere is now connected to the ground by a conducting wire. Describe what happens to the sphere''s net charge and its electric potential.',
  '(c) The sphere is now connected to the ground by a conducting wire. Describe what happens to the sphere''s net charge and its electric potential, without asserting a specific final net-charge value (it is not uniquely determined without the external potential and geometry).')
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-005';

update app.content_item_versions civ set stem=stem||' Use k=8.99e9 N*m^2/C^2 for all calculations.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-006';

update app.content_item_versions civ set stem=stem||' (The point charge itself is not divided among the cubes; by symmetry, the total electric flux is divided equally among them.)'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-007';

update app.content_item_versions civ set stem=stem||' Assume the cylinders are long enough that end effects can be neglected.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-009';

update app.content_item_versions civ set stem=replace(stem,
  '(c) Explain, using energy conservation, why the stored energy changes as it does. Is work done on or by the dielectric as it is pulled into the capacitor?',
  '(c) Explain, using energy conservation, why the stored energy changes as it does. Assume negligible edge effects and an ideal, linear dielectric. If the dielectric moves freely into the capacitor under the field''s pull, is work done on or by the dielectric, and where does the energy go? (If instead it is inserted slowly by an external agent, describe how the work done by the field and by the agent differ.)')
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-frq-np1-010';

-- MCQ edits.
update app.mcq_choices m set rationale=rationale||' (Though related non-calculus techniques, such as finding areas under acceleration-time graphs, are within scope for related skills.)'
from t3_versioned v where v.content_key='apphy1-mcq-np1-001' and m.content_item_version_id=v.new_version_id and m.choice_key='A';
update app.mcq_choices m set rationale='Nonuniform acceleration is changing over time; treating it as zero would misrepresent the given situation entirely.'
from t3_versioned v where v.content_key='apphy1-mcq-np1-001' and m.content_item_version_id=v.new_version_id and m.choice_key='D';

update app.mcq_choices m set rationale='This specific relative-velocity skill uses algebraic (component or graphical) vector methods in AP Physics 1, not calculus-based vector methods.'
from t3_versioned v where v.content_key='apphy1-mcq-np1-003' and m.content_item_version_id=v.new_version_id and m.choice_key='D';

update app.content_item_versions civ set stem=stem||' Assume the ball''s speed is greater than the minimum speed required to maintain contact with the track (so the normal force is nonzero).'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-mcq-np1-004';

update app.mcq_choices m set rationale='This zero-net-work-on-a-closed-loop property applies only to conservative forces. Friction is nonconservative, so returning to the starting point does not guarantee zero net work by friction -- the work done depends on the specific path traveled.'
from t3_versioned v where v.content_key='apphy1-mcq-np1-008' and m.content_item_version_id=v.new_version_id and m.choice_key='C';

update app.content_item_versions civ set stem=stem||' (This net force acts on the cyclist-bicycle system.)'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphy1-mcq-np1-010';

update app.content_item_versions civ set stem=stem||' (Use the standard convention V=0 at infinity.)'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-mcq-np1-004';

update app.content_item_versions civ set stem=stem||' Assume the cylinders are long enough that end effects are negligible.'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-mcq-np1-005';

update app.content_item_versions civ set stem=stem||' (Assume the point in question lies on a region of the surface where the local surface charge density is nonzero.)'
from t3_versioned v where civ.id=v.new_version_id and v.content_key='apphycem-mcq-np1-009';

-- Recompute content_hash, structural QA gate, owner_remediation_approval
-- decisions, and publish -- same pattern as Tier 1/Tier 2. See
-- 20260809_tier1_genuine_defects_repair.sql for the full gate/publish
-- template; this script's live run additionally applied a no-version-change
-- "no defect confirmed" approval to apphycem-mcq-np1-010 and left
-- apphycem-mcq-np1-008 untouched in changes_requested (see header note).

commit;
