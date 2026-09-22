begin;

-- Add the two missing AP Chemistry Unit 3 topic-guide pairs:
--   3.12 Properties of Photons
--   3.13 Beer-Lambert Law
--
-- Production coverage before this migration, verified 2026-08-25:
-- app.taxonomy_topics has 13 AP Chemistry Unit 3 topics, but only 11
-- published point briefs and explainers. The missing taxonomy topics are
-- exactly 3.12 and 3.13.
--
-- Grounding: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md Unit 3 section
-- (Properties of Substances and Mixtures). Topic 3.12 covers photon
-- absorption/emission energy changes with c = lambda * nu and E = h * nu.
-- Topic 3.13 covers Beer-Lambert A = epsilon * b * c; with wavelength and path
-- length held constant, absorbance is proportional to concentration, and
-- spectrophotometers are normally set to maximum absorbance for sensitivity.

with brief_seed (
  subject_key, unit_number, topic_code, title,
  class_importance, exam_importance, what_it_is, why_it_matters,
  how_points_are_earned, answer_move, common_point_loss, learn_more_path
) as (
  values
  (
    'ap_chemistry', 3, '3.12', 'Properties of Photons',
    'somewhat-important', 'somewhat-important',
    'A photon carries a discrete amount of energy. When a species absorbs or emits a photon, its energy changes by exactly that photon energy, with wavelength, frequency, and energy connected by c = lambda nu and E = h nu.',
    'This topic is the quantitative bridge from the electromagnetic-spectrum matching in 3.11 to concentration measurements in 3.13: wavelength tells you frequency, frequency tells you photon energy, and photon energy tells you what kind of transition can occur.',
    'You earn points by converting wavelength and frequency consistently, using E = h nu for photon energy, and explaining absorption or emission as an energy-level change of the species rather than as a vague light interaction.',
    'Before calculating, identify whether the prompt gives wavelength, frequency, or energy; convert units first, then chain c = lambda nu into E = h nu only as needed.',
    'Using wavelength directly in E = h nu, or forgetting that shorter wavelength means higher frequency and higher photon energy.',
    '/learn/ap-chemistry/unit-3/properties-of-photons'
  ),
  (
    'ap_chemistry', 3, '3.13', 'Beer-Lambert Law',
    'somewhat-important', 'somewhat-important',
    'The Beer-Lambert law relates absorbance to concentration: A = epsilon b c. For a fixed wavelength and cuvette path length, absorbance is directly proportional to the absorbing species concentration.',
    'This is how spectroscopy becomes quantitative chemistry. A calibration curve or absorbance reading can be turned into concentration only if the student tracks which quantities are held constant and uses the linear relationship correctly.',
    'You earn points by identifying epsilon, path length, and concentration in A = epsilon b c; using proportional reasoning when wavelength and path length are fixed; and interpreting larger absorbance as more absorbing species in the light path.',
    'First check whether epsilon and path length stay constant; if they do, compare concentrations by comparing absorbances before plugging numbers into the full equation.',
    'Treating absorbance as proportional to path length or concentration without checking which variable changed, or assuming the spectrophotometer wavelength is arbitrary.',
    '/learn/ap-chemistry/unit-3/beer-lambert-law'
  )
),
explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_chemistry', 3, '3.12', 'Properties of Photons',
    'A photon is a packet of electromagnetic energy, so its wavelength and frequency are not decoration: they determine the exact energy transferred when light is absorbed or emitted. Because c = lambda nu, shorter wavelength means higher frequency; because E = h nu, higher frequency means greater photon energy.',
    'Students need to keep the chain of relationships straight. Wavelength and frequency are inversely related, but energy and frequency are directly related. Absorption raises the species to a higher-energy state by the photon energy; emission lowers the species by that same emitted photon energy.',
    'Points usually come from a clean setup: convert wavelength to meters if needed, solve for frequency with c = lambda nu, then use E = h nu. The explanation point comes from connecting the number to an energy change in the species, not just reporting a calculator result.',
    'Before calculating, identify whether the prompt gives wavelength, frequency, or energy; convert units first, then chain c = lambda nu into E = h nu only as needed.',
    'A sample absorbs light with wavelength 500 nm. Without calculating a final numeric energy, explain whether photons at 400 nm or 700 nm would carry more energy and why.',
    'The 700 nm photon has more energy because the wavelength number is larger.',
    'The 400 nm photon carries more energy. Frequency is c divided by wavelength, so a shorter wavelength means a higher frequency. Photon energy is E = h nu, so the higher-frequency 400 nm photon has more energy than the 500 nm photon, while the longer-wavelength 700 nm photon has less energy. The answer should compare frequency and energy, not just the size of the wavelength number.',
    'Using wavelength directly in E = h nu, or forgetting that shorter wavelength means higher frequency and higher photon energy.',
    'Back in practice, write the relationship chain in words before the equations: shorter wavelength -> higher frequency -> higher photon energy. That prevents the common reversal.'
  ),
  (
    'ap_chemistry', 3, '3.13', 'Beer-Lambert Law',
    'Beer-Lambert turns spectrophotometry into a concentration measurement. Absorbance equals molar absorptivity times path length times concentration, A = epsilon b c; when wavelength and path length are fixed, epsilon and b are fixed too, so absorbance changes linearly with concentration.',
    'Students need to understand what must be controlled. The wavelength is normally chosen near maximum absorbance so small concentration differences produce clearer absorbance differences. The cuvette path length must also stay the same if absorbances are being compared by proportional reasoning.',
    'Points are earned by naming the variables in A = epsilon b c, using the direct proportionality only when epsilon and b are constant, and interpreting a larger absorbance as more absorbing species along the light path rather than as a different photon energy claim.',
    'First check whether epsilon and path length stay constant; if they do, compare concentrations by comparing absorbances before plugging numbers into the full equation.',
    'A solution in a 1.00 cm cuvette has absorbance 0.40 at the selected wavelength. A second solution of the same compound, measured at the same wavelength and path length, has absorbance 0.80. What can you conclude about concentration?',
    'The second solution absorbed twice as much light, so its photons must have twice the energy.',
    'Because the same compound, same wavelength, and same 1.00 cm path length are used, epsilon and b are constant. Beer-Lambert reduces to A proportional to concentration, so doubling absorbance from 0.40 to 0.80 means the concentration doubled. The photon energy did not double because the wavelength did not change; the amount of absorbing species in the path changed.',
    'Treating absorbance as proportional to path length or concentration without checking which variable changed, or assuming the spectrophotometer wavelength is arbitrary.',
    'In practice, circle the constants before solving a Beer-Lambert item. If wavelength and path length are unchanged, proportional absorbance reasoning is usually faster and safer than full substitution.'
  )
)
insert into app.topic_point_briefs (
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, practice_subject_key,
  practice_unit_number, practice_topic_code, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, class_importance,
  exam_importance, what_it_is, why_it_matters, how_points_are_earned,
  answer_move, common_point_loss, learn_more_path, subject_key,
  unit_number, topic_code, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Chemistry Unit 3 missing topics 3.12 and 3.13; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 3 section: photon energy via c=lambda*nu and E=h*nu; Beer-Lambert A=epsilon*b*c and fixed-wavelength/path-length proportionality; batch 2026-08-25-ap-chemistry-unit3-photons-beer-lambert; author=reviewer same session, no independent human review yet',
  now()
from brief_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  class_importance = excluded.class_importance,
  exam_importance = excluded.exam_importance,
  what_it_is = excluded.what_it_is,
  why_it_matters = excluded.why_it_matters,
  how_points_are_earned = excluded.how_points_are_earned,
  answer_move = excluded.answer_move,
  common_point_loss = excluded.common_point_loss,
  learn_more_path = excluded.learn_more_path,
  practice_subject_key = excluded.practice_subject_key,
  practice_unit_number = excluded.practice_unit_number,
  practice_topic_code = excluded.practice_topic_code,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_point_briefs.published_at, excluded.published_at);

with explainer_seed (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge
) as (
  values
  (
    'ap_chemistry', 3, '3.12', 'Properties of Photons',
    'A photon is a packet of electromagnetic energy, so its wavelength and frequency are not decoration: they determine the exact energy transferred when light is absorbed or emitted. Because c = lambda nu, shorter wavelength means higher frequency; because E = h nu, higher frequency means greater photon energy.',
    'Students need to keep the chain of relationships straight. Wavelength and frequency are inversely related, but energy and frequency are directly related. Absorption raises the species to a higher-energy state by the photon energy; emission lowers the species by that same emitted photon energy.',
    'Points usually come from a clean setup: convert wavelength to meters if needed, solve for frequency with c = lambda nu, then use E = h nu. The explanation point comes from connecting the number to an energy change in the species, not just reporting a calculator result.',
    'Before calculating, identify whether the prompt gives wavelength, frequency, or energy; convert units first, then chain c = lambda nu into E = h nu only as needed.',
    'A sample absorbs light with wavelength 500 nm. Without calculating a final numeric energy, explain whether photons at 400 nm or 700 nm would carry more energy and why.',
    'The 700 nm photon has more energy because the wavelength number is larger.',
    'The 400 nm photon carries more energy. Frequency is c divided by wavelength, so a shorter wavelength means a higher frequency. Photon energy is E = h nu, so the higher-frequency 400 nm photon has more energy than the 500 nm photon, while the longer-wavelength 700 nm photon has less energy. The answer should compare frequency and energy, not just the size of the wavelength number.',
    'Using wavelength directly in E = h nu, or forgetting that shorter wavelength means higher frequency and higher photon energy.',
    'Back in practice, write the relationship chain in words before the equations: shorter wavelength -> higher frequency -> higher photon energy. That prevents the common reversal.'
  ),
  (
    'ap_chemistry', 3, '3.13', 'Beer-Lambert Law',
    'Beer-Lambert turns spectrophotometry into a concentration measurement. Absorbance equals molar absorptivity times path length times concentration, A = epsilon b c; when wavelength and path length are fixed, epsilon and b are fixed too, so absorbance changes linearly with concentration.',
    'Students need to understand what must be controlled. The wavelength is normally chosen near maximum absorbance so small concentration differences produce clearer absorbance differences. The cuvette path length must also stay the same if absorbances are being compared by proportional reasoning.',
    'Points are earned by naming the variables in A = epsilon b c, using the direct proportionality only when epsilon and b are constant, and interpreting a larger absorbance as more absorbing species along the light path rather than as a different photon energy claim.',
    'First check whether epsilon and path length stay constant; if they do, compare concentrations by comparing absorbances before plugging numbers into the full equation.',
    'A solution in a 1.00 cm cuvette has absorbance 0.40 at the selected wavelength. A second solution of the same compound, measured at the same wavelength and path length, has absorbance 0.80. What can you conclude about concentration?',
    'The second solution absorbed twice as much light, so its photons must have twice the energy.',
    'Because the same compound, same wavelength, and same 1.00 cm path length are used, epsilon and b are constant. Beer-Lambert reduces to A proportional to concentration, so doubling absorbance from 0.40 to 0.80 means the concentration doubled. The photon energy did not double because the wavelength did not change; the amount of absorbing species in the path changed.',
    'Treating absorbance as proportional to path length or concentration without checking which variable changed, or assuming the spectrophotometer wavelength is arbitrary.',
    'In practice, circle the constants before solving a Beer-Lambert item. If wavelength and path length are unchanged, proportional absorbance reasoning is usually faster and safer than full substitution.'
  )
)
insert into app.topic_explainers (
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, status, source_note, published_at
)
select
  subject_key, unit_number, topic_code, title, core_idea,
  what_students_need_to_understand, how_this_becomes_points, answer_move,
  mini_example_question, weak_answer, point_attaining_answer,
  common_point_loss, practice_bridge, 'published',
  'cramapple-authored; new coverage 2026-08-25 for AP Chemistry Unit 3 missing topics 3.12 and 3.13; grounded in AP_CHEMISTRY_CED_FACT_PACK.md Unit 3 section: photon energy via c=lambda*nu and E=h*nu; Beer-Lambert A=epsilon*b*c and fixed-wavelength/path-length proportionality; batch 2026-08-25-ap-chemistry-unit3-photons-beer-lambert; author=reviewer same session, no independent human review yet',
  now()
from explainer_seed
on conflict (subject_key, topic_code) do update
set
  unit_number = excluded.unit_number,
  title = excluded.title,
  core_idea = excluded.core_idea,
  what_students_need_to_understand = excluded.what_students_need_to_understand,
  how_this_becomes_points = excluded.how_this_becomes_points,
  answer_move = excluded.answer_move,
  mini_example_question = excluded.mini_example_question,
  weak_answer = excluded.weak_answer,
  point_attaining_answer = excluded.point_attaining_answer,
  common_point_loss = excluded.common_point_loss,
  practice_bridge = excluded.practice_bridge,
  status = excluded.status,
  source_note = excluded.source_note,
  published_at = coalesce(app.topic_explainers.published_at, excluded.published_at);

do $$
declare
  v_briefs integer;
  v_explainers integer;
  v_pairing_orphans integer;
  v_unit_mismatches integer;
  v_route_mismatches integer;
  v_core_matches integer;
  v_duplicate_explainer_fields integer;
begin
  select count(*) into v_briefs
  from app.topic_point_briefs
  where subject_key = 'ap_chemistry'
    and unit_number = 3
    and topic_code in ('3.12', '3.13')
    and status = 'published';

  if v_briefs <> 2 then
    raise exception 'expected 2 published AP Chemistry Unit 3 photon/Beer-Lambert briefs, got %', v_briefs;
  end if;

  select count(*) into v_explainers
  from app.topic_explainers
  where subject_key = 'ap_chemistry'
    and unit_number = 3
    and topic_code in ('3.12', '3.13')
    and status = 'published';

  if v_explainers <> 2 then
    raise exception 'expected 2 published AP Chemistry Unit 3 photon/Beer-Lambert explainers, got %', v_explainers;
  end if;

  select count(*) into v_pairing_orphans
  from (
    select b.subject_key, b.topic_code
    from app.topic_point_briefs b
    left join app.topic_explainers e
      on e.subject_key = b.subject_key
     and e.topic_code = b.topic_code
     and e.status = 'published'
    where b.subject_key = 'ap_chemistry'
      and b.unit_number = 3
      and b.topic_code in ('3.12', '3.13')
      and b.status = 'published'
      and e.topic_code is null
    union all
    select e.subject_key, e.topic_code
    from app.topic_explainers e
    left join app.topic_point_briefs b
      on b.subject_key = e.subject_key
     and b.topic_code = e.topic_code
     and b.status = 'published'
    where e.subject_key = 'ap_chemistry'
      and e.unit_number = 3
      and e.topic_code in ('3.12', '3.13')
      and e.status = 'published'
      and b.topic_code is null
  ) orphans;

  if v_pairing_orphans <> 0 then
    raise exception 'expected 0 AP Chemistry 3.12/3.13 pairing orphans, got %', v_pairing_orphans;
  end if;

  select count(*) into v_unit_mismatches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('3.12', '3.13')
    and b.status = 'published'
    and e.status = 'published'
    and b.unit_number <> e.unit_number;

  if v_unit_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry 3.12/3.13 unit mismatches, got %', v_unit_mismatches;
  end if;

  select count(*) into v_route_mismatches
  from app.topic_point_briefs b
  where b.subject_key = 'ap_chemistry'
    and b.unit_number = 3
    and b.topic_code in ('3.12', '3.13')
    and b.status = 'published'
    and (
      b.practice_subject_key <> b.subject_key
      or b.practice_unit_number <> b.unit_number
      or b.practice_topic_code <> b.topic_code
      or b.learn_more_path not like '/learn/ap-chemistry/unit-3/%'
    );

  if v_route_mismatches <> 0 then
    raise exception 'expected 0 AP Chemistry 3.12/3.13 route mismatches, got %', v_route_mismatches;
  end if;

  select count(*) into v_core_matches
  from app.topic_point_briefs b
  join app.topic_explainers e
    on e.subject_key = b.subject_key
   and e.topic_code = b.topic_code
  where b.subject_key = 'ap_chemistry'
    and b.topic_code in ('3.12', '3.13')
    and b.status = 'published'
    and e.status = 'published'
    and e.core_idea = b.what_it_is;

  if v_core_matches <> 0 then
    raise exception 'expected 0 AP Chemistry 3.12/3.13 core_idea/what_it_is matches, got %', v_core_matches;
  end if;

  with new_explainers as (
    select
      topic_explainer_id,
      mini_example_question,
      weak_answer,
      point_attaining_answer,
      practice_bridge
    from app.topic_explainers
    where subject_key = 'ap_chemistry'
      and unit_number = 3
      and topic_code in ('3.12', '3.13')
      and status = 'published'
  ),
  field_values as (
    select 'mini_example_question' as field_name, mini_example_question as value from new_explainers
    union all
    select 'weak_answer', weak_answer from new_explainers
    union all
    select 'point_attaining_answer', point_attaining_answer from new_explainers
    union all
    select 'practice_bridge', practice_bridge from new_explainers
  )
  select count(*) into v_duplicate_explainer_fields
  from field_values fv
  join app.topic_explainers e
    on (
      e.mini_example_question = fv.value
      or e.weak_answer = fv.value
      or e.point_attaining_answer = fv.value
      or e.practice_bridge = fv.value
    )
  where e.status = 'published'
    and not (
      e.subject_key = 'ap_chemistry'
      and e.unit_number = 3
      and e.topic_code in ('3.12', '3.13')
    );

  if v_duplicate_explainer_fields <> 0 then
    raise exception 'expected 0 AP Chemistry 3.12/3.13 duplicate explainer fields, got %', v_duplicate_explainer_fields;
  end if;
end $$;

commit;
