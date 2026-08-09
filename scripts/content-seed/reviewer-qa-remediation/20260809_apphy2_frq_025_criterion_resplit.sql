-- apphy2-frq-025: re-split part (a) values criteria by QUANTITY instead of by TIME.
--
-- Ahmed Ali's original changes_requested note (implemented in v2, confirmed by the
-- independent §9 QA agent to have MISSED the actual ask): "split a-values into three
-- points, one per quantity, because a student who nails V_C but fumbles current gets
-- the same credit as one who gets nothing." v2 split by time instant (t0/tau/longtime),
-- which still bundles V_C+V_R+I together at each instant -- the exact granularity gap
-- Ahmed named was not fixed. This is a pure criterion re-partition: the numeric values
-- themselves (already confirmed correct by two independent QA passes) are unchanged,
-- only how they're grouped into gradable criteria changes. Per protocol Sec 9.4, insert
-- a new version rather than editing v2 in place.
begin;

with new_version as (
  insert into app.content_item_versions (
    content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status
  )
  select
    content_item_id,
    version_num + 1,
    stem,
    stimulus,
    prompt_json,
    md5(coalesce(stem,'')||E'\n'||coalesce(stimulus,'')),
    status
  from app.content_item_versions
  where id = 'f4b24d30-66eb-4b9b-9655-8267967f9535'
  returning id, content_item_id
),
criteria as (
  insert into app.frq_criteria (
    content_item_version_id, criterion_key, learner_facing_text, points_possible,
    evidence_requirements, minimum_fix
  )
  select nv.id, c.criterion_key, c.learner_facing_text, c.points_possible,
         c.evidence_requirements, c.minimum_fix
  from new_version nv
  cross join (values
    ('a-loop-rule',
     'Uses Kirchhoff''s loop rule (ε = V_C + V_R) to explain that V_R = ε − V_C at every instant, as the reasoning connecting the values rather than memorized numbers.',
     1,
     'Explicit loop-rule statement (or equivalent) linking V_R and V_C at any time, not just at the three sampled instants.',
     'State the series-loop KVL relation ε = V_C + V_R and note it holds for all t.'),
    ('a-trends',
     'Explains that capacitor voltage rises while resistor voltage and current fall as the capacitor charges.',
     1,
     'Qualitative trends agree with the values.',
     'Connect current to the shrinking resistor voltage.'),
    ('a-values-VC',
     'States the capacitor voltage V_C at all three times: t=0, V_C=0; t=τ, V_C≈0.63ε; t→∞, V_C→ε.',
     1,
     'All three V_C values correct (0, 0.63ε, ε), scored independently of V_R and I.',
     'Use V_C(t)=ε(1-e^(-t/τ)) evaluated at t=0, τ, and the long-time limit.'),
    ('a-values-VR',
     'States the resistor voltage V_R at all three times: t=0, V_R=ε; t=τ, V_R≈0.37ε; t→∞, V_R→0.',
     1,
     'All three V_R values correct (ε, 0.37ε, 0), scored independently of V_C and I.',
     'Use V_R=ε−V_C (loop rule) evaluated at t=0, τ, and the long-time limit.'),
    ('a-values-I',
     'States the current I at all three times: t=0, I=ε/R; t=τ, I≈0.37ε/R; t→∞, I→0.',
     1,
     'All three I values correct (ε/R, 0.37ε/R, 0), scored independently of V_C and V_R.',
     'Use I(t)=(ε/R)e^(-t/τ) evaluated at t=0, τ, and the long-time limit.'),
    ('b-energy',
     'Gives the quantitative energy accounting: total charge delivered by the battery is Q=Cε, so total energy delivered is Qε=Cε²; the capacitor stores U_C=½Cε² (from U=½CV² at V=ε); the remaining ½Cε² is dissipated as heat in the resistor.',
     1,
     'Numeric/symbolic accounting showing Cε² total, ½Cε² stored, ½Cε² dissipated — not just a qualitative "half and half" claim.',
     'Compute Qε for total delivered energy and ½CV² at V=ε for stored energy, then subtract.'),
    ('b-r-independence',
     'States that the 50/50 energy split between capacitor and resistor is independent of R — it depends only on C and ε, not on R or the time constant τ=RC.',
     1,
     'Explicit observation that R (and thus τ) drops out of the energy-split derivation entirely; changing R changes charging speed but not the final energy division.',
     'Note that neither Qε nor ½CV² contains R, so the split ratio is fixed at ½/½ for any R.')
  ) as c(criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
  returning content_item_version_id, points_possible
)
select
  (select id from new_version) as new_version_id,
  (select count(*) from criteria) as criteria_count,
  (select sum(points_possible) from criteria) as points_sum;

commit;
