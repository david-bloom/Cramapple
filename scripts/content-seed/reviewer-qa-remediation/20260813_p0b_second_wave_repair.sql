-- P0-B remediation, 2026-08-13: 3 items with an open reviewer finding against
-- already-published content, surfaced by the P0-B net re-verification step of
-- docs/research/REVIEWED_APPROVED_BACKLOG_PUBLISH_2026_08_13.md (a fresh check after
-- the 2026-08-12 sweep had confirmed the net at 0 -- new findings landed in between).
-- Standard insertion discipline: retire old version, insert corrected version,
-- owner_remediation_approval, republish directly (matches the
-- 20260812_p0b_flagged_batch_repair.sql pattern for live P0-B items).
--
-- Findings, all confirmed correct on independent review before fixing:
--   APBIO-HDG-2026-GRAPH-010 (Sarah Sohail, disapprove): item only tested generic
--     scatterplot mechanics -- plot points, label axes, draw a trend line, describe
--     the correlation -- with no AP-Biology-specific reasoning required. Added a 5th
--     criterion (BIOLOGICAL_INTERPRETATION, 1pt) requiring the student to explain
--     forage biomass as a limiting resource for the rabbit population; reworded the
--     stem/stimulus to ask for it; bumped total points 4 -> 5.
--   APBIO-MCQ-095 (Sarah Sohail, approve_with_edits): choice A's rationale claimed
--     "conservation of energy applies to physics, not ecological energy transfer
--     efficiency" -- false, energy is always conserved; only ~10% is retained as
--     biomass per trophic level, the rest lost as heat/waste. Corrected to state this
--     accurately. Choice D's numeric value (0.1 kcal/m^2/year) was arithmetically
--     inconsistent with its own (flawed) stated reasoning -- corrected to 1
--     kcal/m^2/year, which is what "one extra 10% step from the sun" actually yields.
--   apphy2-mcq-015 (Ahmed Ali, approve_with_edits, vague note "revise stem and option
--     C rationale"): independent re-derivation found no factual defect. Made a light
--     precision edit -- reworded the stem as a complete question instead of a
--     fill-in-the-blank continuation, and tightened choice C's rationale.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-p0b-remediation-20260813'));

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  -- APBIO-HDG-2026-GRAPH-010
  select * into strict v_item from app.content_items where content_key='APBIO-HDG-2026-GRAPH-010' and item_type='frq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;
  v_new := gen_random_uuid();
  update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, explanation, help_text, content_hash, status, created_by, canonical_answer_1, canonical_answer_2, review_status, rubric_type, evaluator_strategy, stimulus_image_path)
  values (
    v_new, v_item.id, v_old.version_num+1, v_old.stem,
    'Ecologists recorded rabbit population size and available forage biomass across nine sample plots. Construct a scatterplot, sketch a reasonable trend line, describe the direction, form, and strength of the association in context, and explain what this relationship suggests about forage biomass as a limiting resource for the rabbit population.' || E'\n\n' ||
    '| Forage biomass (kg/hectare) | Rabbit population size |' || E'\n' || '| --- | --- |' || E'\n' ||
    '| 10 | 24 |' || E'\n' || '| 20 | 13 |' || E'\n' || '| 30 | 21 |' || E'\n' || '| 40 | 18 |' || E'\n' ||
    '| 50 | 46 |' || E'\n' || '| 60 | 49 |' || E'\n' || '| 70 | 33 |' || E'\n' || '| 80 | 50 |' || E'\n' || '| 90 | 43 |',
    (v_old.prompt_json
      #- '{parts,0,points_possible}' || jsonb_build_object('parts', jsonb_build_array(jsonb_build_object('is_drawn', true, 'part_key', 'a', 'prompt_text', 'See stimulus.', 'points_possible', 5)))
    ) || jsonb_build_object(
      'stimulus', 'Ecologists recorded rabbit population size and available forage biomass across nine sample plots. Construct a scatterplot, sketch a reasonable trend line, describe the direction, form, and strength of the association in context, and explain what this relationship suggests about forage biomass as a limiting resource for the rabbit population.' || E'\n\n' ||
        '| Forage biomass (kg/hectare) | Rabbit population size |' || E'\n' || '| --- | --- |' || E'\n' ||
        '| 10 | 24 |' || E'\n' || '| 20 | 13 |' || E'\n' || '| 30 | 21 |' || E'\n' || '| 40 | 18 |' || E'\n' ||
        '| 50 | 46 |' || E'\n' || '| 60 | 49 |' || E'\n' || '| 70 | 33 |' || E'\n' || '| 80 | 50 |' || E'\n' || '| 90 | 43 |',
      'criteria', jsonb_build_array(
        jsonb_build_object('criterion_key','POINTS_PLOTTED','points_possible',1,'learner_facing_text','Plots all nine ordered pairs at recoverable locations.'),
        jsonb_build_object('criterion_key','AXIS_LABELS','points_possible',1,'learner_facing_text','Labels forage biomass and rabbit population size on the correct axes.'),
        jsonb_build_object('criterion_key','TREND_LINE','points_possible',1,'learner_facing_text','Sketches a reasonable increasing line through the point cloud.'),
        jsonb_build_object('criterion_key','ASSOCIATION_DESCRIPTION','points_possible',1,'learner_facing_text','Describes a strong, positive, roughly linear association in context.'),
        jsonb_build_object('criterion_key','BIOLOGICAL_INTERPRETATION','points_possible',1,'learner_facing_text','Explains that forage (food) availability is a limiting resource, so greater forage biomass supports a larger rabbit population by providing more energy/resources before density-dependent limits are reached.')
      ),
      'content_version', v_old.version_num+1,
      'qa_remediation', '2026-08-13 P0-B repair: added biological-interpretation requirement per Sarah Sohail''s disapproval (item tested generic scatterplot mechanics, not AP Biology reasoning)',
      'qa_source_version_id', v_old.id
    ),
    v_old.explanation, v_old.help_text, v_old.content_hash, 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_old.canonical_answer_1, v_old.canonical_answer_2, null, v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
  );
  insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
  values
    (v_new, 'POINTS_PLOTTED', 'Plots all nine ordered pairs at recoverable locations.', 1, 'Earns when the response satisfies this criterion: Plots all nine ordered pairs at recoverable locations. Accept equivalent correct wording, and correct numeric values within normal rounding. Does not earn if the required element is missing, incorrect, or contradicted elsewhere in the response.', 'To earn this point, make sure your response: plots all nine ordered pairs at recoverable locations.'),
    (v_new, 'AXIS_LABELS', 'Labels forage biomass and rabbit population size on the correct axes.', 1, 'Earns when the response satisfies this criterion: Labels forage biomass and rabbit population size on the correct axes. Accept equivalent correct wording, and correct numeric values within normal rounding. Does not earn if the required element is missing, incorrect, or contradicted elsewhere in the response.', 'To earn this point, make sure your response: labels forage biomass and rabbit population size on the correct axes.'),
    (v_new, 'TREND_LINE', 'Sketches a reasonable increasing line through the point cloud.', 1, 'Earns when the response satisfies this criterion: Sketches a reasonable increasing line through the point cloud. Accept equivalent correct wording, and correct numeric values within normal rounding. Does not earn if the required element is missing, incorrect, or contradicted elsewhere in the response.', 'To earn this point, make sure your response: sketches a reasonable increasing line through the point cloud.'),
    (v_new, 'ASSOCIATION_DESCRIPTION', 'Describes a strong, positive, roughly linear association in context.', 1, 'Earns when the response satisfies this criterion: Describes a strong, positive, roughly linear association in context. Accept equivalent correct wording, and correct numeric values within normal rounding. Does not earn if the required element is missing, incorrect, or contradicted elsewhere in the response.', 'To earn this point, make sure your response: describes a strong, positive, roughly linear association in context.'),
    (v_new, 'BIOLOGICAL_INTERPRETATION', 'Explains that forage (food) availability is a limiting resource, so greater forage biomass supports a larger rabbit population by providing more energy/resources before density-dependent limits are reached.', 1, 'Earns when the response satisfies this criterion: Explains that forage biomass is a limiting resource driving the rabbit population trend. Accept equivalent correct wording (e.g., references to carrying capacity or resource limitation). Does not earn if the required element is missing, incorrect, or contradicted elsewhere in the response.', 'To earn this point, make sure your response: explains that forage biomass limits the rabbit population as a resource, so more forage supports a larger population.');
  insert into repaired values ('APBIO-HDG-2026-GRAPH-010', v_old.id, v_new);

  -- APBIO-MCQ-095
  select * into strict v_item from app.content_items where content_key='APBIO-MCQ-095' and item_type='mcq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;
  v_new := gen_random_uuid();
  update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, explanation, help_text, content_hash, status, created_by, canonical_answer_1, canonical_answer_2, review_status, rubric_type, evaluator_strategy, stimulus_image_path)
  values (v_new, v_item.id, v_old.version_num+1, v_old.stem, v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version', v_old.version_num+1, 'qa_remediation', '2026-08-13 P0-B repair: corrected choice A''s rationale (falsely claimed energy conservation does not apply to ecology) and choice D''s numeric/rationale consistency, per Sarah Sohail''s finding', 'qa_source_version_id', v_old.id),
    v_old.explanation, v_old.help_text, v_old.content_hash, 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_old.canonical_answer_1, v_old.canonical_answer_2, null, v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
  );
  insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
  values
    (v_new, 'A', '1,000 kcal/m²/year, because energy is conserved between trophic levels',
     false, '1,000 kcal/m²/year is the energy available to PRIMARY consumers, not tertiary consumers -- this answer skips two trophic transfers. Energy is still conserved overall (the first law of thermodynamics always holds), but only about 10% of the energy at one trophic level is retained as new biomass and passed to the next; the rest is lost as heat through cellular respiration, in feces, and other metabolic costs. "Ecological efficiency" describes this transfer/retention rate, not a violation of energy conservation.'),
    (v_new, 'B', '10 kcal/m²/year, applying the 10% rule: 10,000 × 0.1 × 0.1 × 0.1 = 10 kcal/m²/year for the 4th trophic level',
     true, 'The 10% ecological efficiency rule: approximately 10% of energy at one trophic level is incorporated into the next. Starting from producers: (1) Primary consumers: 10,000 × 10% = 1,000; (2) Secondary consumers: 1,000 × 10% = 100; (3) Tertiary consumers: 100 × 10% = 10 kcal/m²/year. The data in the table confirm the 10% pattern for the first three levels, and the calculation extends it to tertiary consumers. This extreme energy loss (90% at each step) explains why food chains rarely exceed 4-5 trophic levels and why large top carnivores have large territory requirements and low population densities.'),
    (v_new, 'C', '100 kcal/m²/year, because tertiary consumers are only one trophic level above secondary consumers',
     false, '100 kcal/m²/year is the energy at the SECONDARY consumer level (frogs). Applying 10% efficiency to transfer from secondary to tertiary consumers: 100 × 0.1 = 10 kcal/m²/year. Each trophic level step loses ~90% of energy, so tertiary consumers have 10%, not 100%, of the energy available to secondary consumers.'),
    (v_new, 'D', '1 kcal/m²/year, because energy losses are multiplicative across all trophic levels starting from the sun, not from producers',
     false, 'This applies an extra, unwarranted 10% loss step by treating sunlight-to-producer conversion as a fourth trophic transfer. The 10% ecological efficiency rule measures energy transfer between biological trophic levels, starting from net primary productivity (producers) -- gross photosynthetic efficiency from sunlight to NPP is already accounted for in the given 10,000 kcal/m²/year NPP value. The question asks for energy available to tertiary consumers calculated from NPP, which requires exactly three 10% transfer steps (producer to primary to secondary to tertiary), yielding 10 kcal/m²/year, not an additional fourth step.');
  insert into repaired values ('APBIO-MCQ-095', v_old.id, v_new);

  -- apphy2-mcq-015
  select * into strict v_item from app.content_items where content_key='apphy2-mcq-015' and item_type='mcq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;
  v_new := gen_random_uuid();
  update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
  update app.content_items set status='draft', updated_at=now() where id=v_item.id;
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, explanation, help_text, content_hash, status, created_by, canonical_answer_1, canonical_answer_2, review_status, rubric_type, evaluator_strategy, stimulus_image_path)
  values (v_new, v_item.id, v_old.version_num+1,
    'Under what condition can total internal reflection occur?', v_old.stimulus,
    coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version', v_old.version_num+1, 'qa_remediation', '2026-08-13 P0-B repair: reworded stem as a complete question and tightened choice C''s rationale, per Ahmed Ali''s edit request', 'qa_source_version_id', v_old.id),
    v_old.explanation, v_old.help_text, v_old.content_hash, 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    v_old.canonical_answer_1, v_old.canonical_answer_2, null, v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
  );
  insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct, rationale)
  values
    (v_new, 'A', 'Light travels from a lower-index to a higher-index medium', false, 'Reverses the required index relationship; total internal reflection needs light traveling from higher to lower index, not the other way around.'),
    (v_new, 'B', 'Light travels from a higher-index to a lower-index medium at an angle of incidence above the critical angle', true, 'TIR requires high-to-low index and sufficiently large incidence angle'),
    (v_new, 'C', 'Light strikes the boundary at normal incidence (0 degrees)', false, 'Normal incidence (0 degrees) is far below the critical angle for any realistic pair of media, so total internal reflection cannot occur there -- TIR requires the angle of incidence to exceed the critical angle, not be at or near 0 degrees.'),
    (v_new, 'D', 'Light travels through a vacuum', false, 'Introduces an irrelevant medium requirement; total internal reflection depends on the index contrast between two media, not on vacuum specifically.');
  insert into repaired values ('apphy2-mcq-015', v_old.id, v_new);
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id and r.content_key='APBIO-HDG-2026-GRAPH-010';

create temporary table qa_blocked as
select r.content_key,
  case
    when ci.item_type='frq' and (select count(*) from app.frq_criteria fc where fc.content_item_version_id=civ.id) <> (case when r.content_key='APBIO-HDG-2026-GRAPH-010' then 5 else null end) then 'unexpected criteria count'
    when ci.item_type='frq' and (select sum(fc.points_possible) from app.frq_criteria fc where fc.content_item_version_id=civ.id) <> (case when r.content_key='APBIO-HDG-2026-GRAPH-010' then 5 else null end) then 'points do not sum as expected'
    when ci.item_type='frq' and exists (select 1 from app.frq_criteria fc where fc.content_item_version_id=civ.id and nullif(trim(fc.learner_facing_text),'') is null) then 'blank criterion text'
    when ci.item_type='mcq' and (select count(*) from app.mcq_choices mc where mc.content_item_version_id=civ.id) <> 4 then 'expected 4 choices'
    when ci.item_type='mcq' and (select count(*) from app.mcq_choices mc where mc.content_item_version_id=civ.id and mc.is_correct) <> 1 then 'expected exactly 1 correct choice'
    when ci.item_type='mcq' and exists (select 1 from app.mcq_choices mc where mc.content_item_version_id=civ.id and (nullif(trim(mc.choice_text),'') is null or nullif(trim(mc.rationale),'') is null)) then 'blank choice text or rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id
join app.content_items ci on ci.id=civ.content_item_id;
delete from qa_blocked where reason is null;

do $$
declare n integer;
begin
  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'P0-B second-wave repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;
end $$;

update app.content_items set practice_format=coalesce(practice_format,'targeted_drill'), updated_at=now()
where content_key in ('APBIO-HDG-2026-GRAPH-010') and practice_format is null;

insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), r.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question',
  ci.item_type, 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r join app.content_items ci on ci.id=(select content_item_id from app.content_item_versions where id=r.new_version_id);

insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select cra.content_review_assignment_id, r.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question',
  1, 'Medium', false, array[]::text[],
  'Pre-publish P0-B repair, 2026-08-13: resolved the open reviewer finding against this already-published item -- ' || r.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','p0b_repair','content_key',r.content_key,'qa_date','2026-08-13'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','p0b_repair','content_key',r.content_key,'qa_date','2026-08-13')::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ
set status='published', review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=now(),
    published_at=now(), updated_at=now()
from repaired r where civ.id=r.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>3 then raise exception 'expected 3 repaired items, got %', n; end if;

  select count(*) into n from app.content_item_versions where status='published' and review_status in ('excluded','modification_reserved');
  if n<>0 then raise exception 'P0-B net check still non-zero after repair: %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published' group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after P0-B repair: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired
union all select 'repaired_keys', string_agg(content_key, ', ' order by content_key) from repaired
union all select 'p0b_net_after', (select count(*) from app.content_item_versions where status='published' and review_status in ('excluded','modification_reserved'))::text;

commit;
