begin;
do $stats_precalc_units1_2$
declare
  v_epv_id uuid;
  v_epv_count integer;
begin
  select count(*) into v_epv_count
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_statistics'
    and epv.status = 'published';

  if v_epv_count <> 1 then
    raise exception 'expected_exactly_one_published_exam_pack_version:%:%', 'ap_statistics', v_epv_count;
  end if;

  select epv.id into v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_statistics'
    and epv.status = 'published';

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-001'
      and id <> '0d5cc3fa-48fa-44d6-a0c9-c8e9d6067a6e'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-001';
  end if;

  if not exists (
    select 1 from app.content_items where id = '0d5cc3fa-48fa-44d6-a0c9-c8e9d6067a6e'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '0d5cc3fa-48fa-44d6-a0c9-c8e9d6067a6e'::uuid,
      v_epv_id,
      'apstats-frq-u12-001',
      'frq',
      'After-School Activity Survey',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid,
      '0d5cc3fa-48fa-44d6-a0c9-c8e9d6067a6e'::uuid,
      1,
      'After-School Activity Survey: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A student council surveyed all 80 students in the tenth grade at Lincoln High School, asking each student to identify the after-school activity in which they participate most.

Table 1: After-School Activity of Tenth-Grade Students
Activity | Number of Students
Sports | 32
Music | 12
Clubs | 20
None | 16',
      '{"content_key":"apstats-frq-u12-001","subject":"ap_statistics","unit":1,"topic":"1.4 Graphical Representations for One Categorical Variable","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Easy","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the relative frequency (proportion) of tenth-grade students in each of the four activity categories. Show the division used for at least one category.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Construct a bar graph of the distribution of after-school activity.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Describe the distribution of after-school activity based on the graph, identifying the most and least common activities.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]},{"part_key":"part-d","prompt":"Classify the type of variable recorded (activity), and justify why a bar graph, rather than a histogram, is the appropriate display for this variable.","points":3,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1},{"criterion_key":"part-d-criterion-03","points":1}]}]}'::jsonb,
      md5('After-School Activity Survey: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('05206504-3d65-493d-a9c4-ab8dffb50e4f'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-a-criterion-01', 'States correct relative frequencies for all four categories.', 1, 'Sports = 0.40, Music = 0.15, Clubs = 0.25, None = 0.20 (each count divided by 80).', 'Recompute each count divided by the total of 80 students.', '[]'::jsonb),
      ('928a9ccd-0620-42fa-a57c-a072531c4eba'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-a-criterion-02', 'Shows the arithmetic (count ÷ 80) used to obtain at least one relative frequency.', 1, 'Work such as 32/80 = 0.40 is displayed, not just a final answer.', 'Add the division step for at least one category, e.g., 32 ÷ 80.', '[]'::jsonb),
      ('14681321-b92f-4ce4-aba3-4632e5d75f84'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-b-criterion-01', 'Draws a bar for each of the four categories with heights proportional to the relative frequencies (or counts) found in part A.', 1, 'Bar for Sports is tallest, Clubs second, None third, Music shortest, in proportion to 0.40/0.25/0.20/0.15.', 'Redraw bars so their heights match the computed relative frequencies or counts in the correct rank order.', '[]'::jsonb),
      ('f4508718-73c6-4859-a846-a98858777a16'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-b-criterion-02', 'Labels both axes (activity categories and count or relative frequency) and includes a title.', 1, 'Axis labels and a graph title are present.', 'Add axis labels identifying the categories and the count/relative-frequency scale, plus a title.', '[]'::jsonb),
      ('8e68e735-f0d7-4850-ad19-1c1d3122b452'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-b-criterion-03', 'Uses equal-width bars with gaps between them (not touching), consistent with a categorical variable.', 1, 'Bars are uniform width and separated by visible gaps rather than adjoining.', 'Redraw with uniform bar widths and gaps between bars.', '[]'::jsonb),
      ('9932f919-f40a-4688-a83f-5a0a09b726d4'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-c-criterion-01', 'Correctly identifies Sports as the most common activity and Music as the least common.', 1, 'Response names Sports as highest and Music as lowest.', 'Reread the counts/relative frequencies and identify the largest (Sports) and smallest (Music) categories.', '[]'::jsonb),
      ('3898dbc8-574b-4f41-a145-37fa1c79c8ec'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-c-criterion-02', 'Compares the two using the actual relative frequency or count values.', 1, 'Statement such as "Sports (0.40) occurs more than twice as often as Music (0.15)" is included.', 'Add a numeric comparison between the most and least common categories using the computed values.', '[]'::jsonb),
      ('a72797fd-d693-4149-a40d-99320e41e146'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-d-criterion-01', 'Identifies "activity" as a categorical (qualitative) variable.', 1, 'Response explicitly labels the variable as categorical, not quantitative.', 'State that activity is a categorical variable since its values are named groups, not numbers.', '[]'::jsonb),
      ('91353759-4b9f-43b2-a228-43804f6ed7eb'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-d-criterion-02', 'Justifies that a bar graph is appropriate because the categories have no inherent numerical order or scale.', 1, 'Explanation references the categories as unordered labels rather than numeric values.', 'Explain that bar graphs display counts/frequencies for distinct category labels.', '[]'::jsonb),
      ('b0e28dfe-26a2-4674-a01c-1985ec8435ff'::uuid, '1300dd2b-de29-4d8b-a990-376c8d3ff876'::uuid, 'part-d-criterion-03', 'Explains why a histogram would be inappropriate here.', 1, 'Explanation notes histograms require quantitative data grouped into equal-width numeric intervals, which does not apply to activity names.', 'Add that histograms are for quantitative variables with numeric intervals, which activity data does not have.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-002'
      and id <> 'd49c417a-ffc9-4836-a070-bd356e021b69'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-002';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'd49c417a-ffc9-4836-a070-bd356e021b69'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'd49c417a-ffc9-4836-a070-bd356e021b69'::uuid,
      v_epv_id,
      'apstats-frq-u12-002',
      'frq',
      'Carnival Spinner Probabilities',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid,
      'd49c417a-ffc9-4836-a070-bd356e021b69'::uuid,
      1,
      'Carnival Spinner Probabilities: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A carnival game uses a spinner divided into 8 equally likely sectors: 3 red, 2 blue, 2 green, and 1 yellow. A player spins the spinner once.',
      '{"content_key":"apstats-frq-u12-002","subject":"ap_statistics","unit":2,"topic":"2.4 Introduction to Probability","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Easy","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the probability that the spinner lands on red or blue.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Calculate the probability that the spinner does not land on green.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Determine whether the events \"the spinner lands on red\" and \"the spinner lands on blue\" are mutually exclusive, and justify your answer.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Suppose the player spins the spinner twice, and the spins are independent. Calculate the probability that both spins land on red.","points":3,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1},{"criterion_key":"part-d-criterion-03","points":1}]}]}'::jsonb,
      md5('Carnival Spinner Probabilities: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('b7d4f0dc-e4ae-4b84-a786-3416936d928b'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-a-criterion-01', 'Recognizes that landing on red and landing on blue are mutually exclusive outcomes, so their probabilities can be added.', 1, 'Response adds P(red) and P(blue) rather than multiplying or using a joint-probability approach.', 'Use the addition rule for mutually exclusive events: P(red or blue) = P(red) + P(blue).', '[]'::jsonb),
      ('214b79e4-d59a-4f36-af21-5504692bd5d4'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-a-criterion-02', 'Calculates the correct value.', 1, 'P(red or blue) = 3/8 + 2/8 = 5/8 (0.625).', 'Recompute 3/8 + 2/8.', '[]'::jsonb),
      ('e2200284-61ec-473d-a6c4-1d893a69e320'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-b-criterion-01', 'Uses the complement rule: P(not green) = 1 − P(green).', 1, 'Work shows 1 − 2/8 rather than a direct count of non-green sectors alone without reference to the complement.', 'Apply the complement rule using P(green) = 2/8.', '[]'::jsonb),
      ('ac3cfd62-8ac7-4930-a92c-73ff90194632'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-b-criterion-02', 'Calculates the correct value.', 1, 'P(not green) = 6/8 = 3/4 (0.75).', 'Recompute 1 − 2/8.', '[]'::jsonb),
      ('ee84edb3-2599-46c8-a4ee-b173aa94ab3f'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-c-criterion-01', 'States that the events are mutually exclusive.', 1, 'Response explicitly classifies the two events as mutually exclusive.', 'State the classification: mutually exclusive.', '[]'::jsonb),
      ('4a397cef-6d59-4249-adc0-17a31db0a67a'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-c-criterion-02', 'Justifies using the fact that no sector is both red and blue, since each spin results in exactly one sector.', 1, 'Justification references that a single spin can land on only one color.', 'Explain that a single spin cannot simultaneously produce two different colors.', '[]'::jsonb),
      ('1fb30e48-08ef-4f37-a6f2-e0c131843893'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-c-criterion-03', 'Connects this to the definition that mutually exclusive events cannot occur together, i.e., P(red and blue) = 0.', 1, 'Response states P(red and blue) = 0 as the defining condition.', 'State that mutually exclusive events satisfy P(A and B) = 0.', '[]'::jsonb),
      ('a42749bf-9be6-42f0-a367-44c48fe9d68a'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-d-criterion-01', 'Recognizes the spins are independent, so probabilities can be multiplied.', 1, 'Response multiplies P(red) by P(red) rather than adding or using a conditional adjustment.', 'Apply the multiplication rule for independent events: P(A and B) = P(A) × P(B).', '[]'::jsonb),
      ('d84ecd4d-15dd-44aa-a176-7073c179b23e'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-d-criterion-02', 'Writes the correct expression.', 1, 'Expression (3/8) × (3/8) appears in the work.', 'Set up the product of the two individual probabilities of red.', '[]'::jsonb),
      ('146fcc61-f1ab-400d-a7ba-7f12d00afe88'::uuid, '2899b6c0-815c-4b54-a8a3-1f912e11d97d'::uuid, 'part-d-criterion-03', 'Calculates the correct final value.', 1, 'Final answer is 9/64 (≈0.141).', 'Recompute (3/8) × (3/8).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-003'
      and id <> '614b65b6-f98c-4319-ae0a-b540ce47233d'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-003';
  end if;

  if not exists (
    select 1 from app.content_items where id = '614b65b6-f98c-4319-ae0a-b540ce47233d'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '614b65b6-f98c-4319-ae0a-b540ce47233d'::uuid,
      v_epv_id,
      'apstats-frq-u12-003',
      'frq',
      'Selecting a Random Sample of Students',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 1 and 2'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid,
      '614b65b6-f98c-4319-ae0a-b540ce47233d'::uuid,
      1,
      'Selecting a Random Sample of Students: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A school has 400 students enrolled, each assigned a unique ID number from 001 to 400. A researcher wants to select a simple random sample (SRS) of 15 students to survey about cafeteria satisfaction. The researcher has a list of all 400 ID numbers and access to a table of random digits.',
      '{"content_key":"apstats-frq-u12-003","subject":"ap_statistics","unit":1,"topic":"1.11 Random Sampling","archetype":"Multi-Focus on Practices 1 and 2","difficulty":"Easy","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Explain a complete and correct procedure the researcher could use with the random digit table to select an SRS of 15 students from the 400.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Explain why using this SRS procedure to select students reduces bias compared to only surveying whichever students happen to be in the cafeteria line during 5th period.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Calculate the probability that a particular student, Maria, is included in the sample of 15.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Selecting a Random Sample of Students: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('7f73ed4c-8087-46e4-a00b-98747d11d29d'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-a-criterion-01', 'Reads the random digits in groups of three, since IDs range from 001 to 400 (three-digit labels).', 1, 'Procedure specifies reading three-digit groups from the table.', 'State that digits should be read in groups of three to match the three-digit ID labels.', '[]'::jsonb),
      ('bc720d7d-6aaf-4c13-ad78-039eaacaa4ae'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-a-criterion-02', 'States a rule for discarding invalid groups (numbers above 400, or 000) as they are read.', 1, 'Procedure explicitly skips any three-digit group greater than 400 or equal to 000.', 'Add a rule to skip any group outside the range 001–400.', '[]'::jsonb),
      ('dee4298f-5424-4f74-aa07-2bffb5cc658c'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-a-criterion-03', 'States that repeated (duplicate) valid numbers are also skipped, and the process continues until 15 distinct valid numbers are obtained.', 1, 'Procedure mentions ignoring a number if it has already been selected.', 'Add that already-selected ID numbers are skipped if they reappear.', '[]'::jsonb),
      ('5b3b1424-1c57-43b5-ae2b-c0c45d80e85c'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-a-criterion-04', 'States that the students corresponding to the 15 selected ID numbers make up the sample.', 1, 'Procedure ties the final list of numbers back to the specific students holding those IDs.', 'Conclude by stating the sample consists of the students whose ID numbers were drawn.', '[]'::jsonb),
      ('a8cae57b-1602-4cbe-a608-d11b36a493e1'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-b-criterion-01', 'Notes that surveying only students in the cafeteria line during one period is a convenience sample that may not represent the whole school.', 1, 'Response identifies that a single lunch period excludes students with other schedules.', 'State that surveying only one lunch period is a convenience sample, not representative of all students.', '[]'::jsonb),
      ('e0f1f6dc-9e74-4e88-a7da-c236437c4bcc'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-b-criterion-02', 'States that the SRS procedure gives every student in the school an equal chance of selection, avoiding this systematic exclusion.', 1, 'Response explains that all 400 students, regardless of lunch period, could be chosen under the SRS.', 'Explain that an SRS gives each of the 400 students an equal chance of being selected.', '[]'::jsonb),
      ('de146ec8-ecf8-47f7-a35b-101e4838c16f'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-b-criterion-03', 'Ties the reasoning to context: because cafeteria satisfaction opinions could plausibly differ by lunch period or schedule, the convenience sample could bias results.', 1, 'Response connects the potential difference in opinions across lunch periods to a biased estimate.', 'Add that opinions may vary by lunch period, so excluding other periods could bias the results.', '[]'::jsonb),
      ('5fda35a2-a23f-4cbb-ab61-b19ebc98c86c'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-c-criterion-01', 'Uses the correct approach: probability equals sample size divided by population size.', 1, 'Work shows 15/400 rather than an unrelated calculation.', 'Set up the ratio of sample size to population size.', '[]'::jsonb),
      ('b7a3fda4-6995-4100-ac33-af48be4a3e17'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-c-criterion-02', 'Uses the correct values in the computation.', 1, 'Expression 15/400 is shown explicitly.', 'Use sample size 15 and population size 400.', '[]'::jsonb),
      ('de593ad7-dc2e-4063-a553-556998e326e1'::uuid, 'f8ebd5b5-6ac8-405f-a564-bb6b0dfb0759'::uuid, 'part-c-criterion-03', 'Calculates the correct final value.', 1, 'Final answer is 0.0375 (3.75%).', 'Recompute 15 ÷ 400.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-004'
      and id <> '66dba214-f1d0-41ba-a52e-1e16996ce0d7'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-004';
  end if;

  if not exists (
    select 1 from app.content_items where id = '66dba214-f1d0-41ba-a52e-1e16996ce0d7'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '66dba214-f1d0-41ba-a52e-1e16996ce0d7'::uuid,
      v_epv_id,
      'apstats-frq-u12-004',
      'frq',
      'Marathon Training Distances',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid,
      '66dba214-f1d0-41ba-a52e-1e16996ce0d7'::uuid,
      1,
      'Marathon Training Distances: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A running coach recorded the weekly training distance (in miles) for 12 runners preparing for a marathon:

18, 22, 24, 25, 26, 28, 28, 29, 31, 33, 35, 61',
      '{"content_key":"apstats-frq-u12-004","subject":"ap_statistics","unit":1,"topic":"1.6 Descriptions for One Quantitative Variable Distributions","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the mean and the median weekly training distance for these 12 runners. Show your work.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Describe the shape of the distribution and explain how the shape is reflected in the relationship between the mean and median found in part A.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"A sports reporter wants to summarize the \"typical\" weekly training distance for this group. Justify which measure of center (mean or median) is more appropriate to report, and calculate an appropriate measure of spread to accompany your choice.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Marathon Training Distances: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('1d031092-beb5-46a7-a3b1-b1a1a50a89ec'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-a-criterion-01', 'Calculates the correct mean.', 1, 'Mean = 360/12 = 30 miles, with the sum of all 12 values shown.', 'Recompute the sum of all 12 values and divide by 12.', '[]'::jsonb),
      ('426f928b-48ce-4091-a920-87e2acd97ee6'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-a-criterion-02', 'Calculates the correct median.', 1, 'Median = 28 miles (average of the 6th and 7th ordered values, both 28).', 'Order the data and average the 6th and 7th values.', '[]'::jsonb),
      ('c7540497-008e-444e-a0c5-37f861edfbf1'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-a-criterion-03', 'Shows correct method/work for both calculations, including ordering the data for the median.', 1, 'Data is listed in sorted order before identifying the middle values.', 'Show the sorted list of 12 values before computing the median.', '[]'::jsonb),
      ('6851083a-6f7a-406d-afb7-6fab297ec9f4'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-b-criterion-01', 'Correctly describes the shape as skewed to the right (due to the high value of 61).', 1, 'Response identifies right skew or a high outlier pulling the distribution.', 'Describe the distribution as right-skewed because of the unusually high value of 61.', '[]'::jsonb),
      ('d0121e66-7312-443b-a605-f9ac395107d9'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-b-criterion-02', 'Correctly states that the mean (30) is greater than the median (28) in this distribution.', 1, 'Response explicitly compares the two values with mean > median.', 'State the numeric relationship: mean 30 is greater than median 28.', '[]'::jsonb),
      ('86865a0c-21c4-4de9-a190-30bcd2e37dd3'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-b-criterion-03', 'Explains that the high value of 61 pulls the mean upward while the median is resistant to it.', 1, 'Explanation references the mean being sensitive to extreme values/skew, unlike the median.', 'Explain that extreme high values inflate the mean but do not affect the median as strongly.', '[]'::jsonb),
      ('1039974d-af36-426b-ab1d-14d2994523b8'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-c-criterion-01', 'Chooses the median as the more appropriate measure of typical distance.', 1, 'Response explicitly selects median over mean.', 'State that the median should be used to describe the typical distance.', '[]'::jsonb),
      ('67787fae-a1a5-4432-ad5c-005f451eea42'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-c-criterion-02', 'Justifies the choice by referencing the outlier/skew that reduces the mean''s representativeness.', 1, 'Justification connects to the 61-mile value distorting the mean.', 'Explain that the outlier (61) makes the mean an unrepresentative measure of a typical runner''s distance.', '[]'::jsonb),
      ('2a8486a8-6be9-4c51-ab5a-dba3abd05137'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-c-criterion-03', 'Selects the interquartile range (IQR) as the resistant measure of spread and correctly computes Q1 and Q3.', 1, 'Q1 = 24.5 (median of 18,22,24,25,26,28) and Q3 = 32 (median of 28,29,31,33,35,61) are shown.', 'Split the ordered data into lower and upper halves and find the median of each half.', '[]'::jsonb),
      ('a3f7df78-31b0-4234-a856-2e06c48731ab'::uuid, 'a01f2bff-79df-4a27-a7d8-39a12a4cb5df'::uuid, 'part-c-criterion-04', 'Calculates the correct IQR value.', 1, 'IQR = 32 − 24.5 = 7.5 miles.', 'Recompute Q3 minus Q1.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-005'
      and id <> 'c19e2b4d-b0f5-4944-a4d9-46840f005aab'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-005';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c19e2b4d-b0f5-4944-a4d9-46840f005aab'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c19e2b4d-b0f5-4944-a4d9-46840f005aab'::uuid,
      v_epv_id,
      'apstats-frq-u12-005',
      'frq',
      'Tomato Plant Heights',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid,
      'c19e2b4d-b0f5-4944-a4d9-46840f005aab'::uuid,
      1,
      'Tomato Plant Heights: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A gardener measured the heights (in cm) of 11 tomato plants grown from the same seed batch. The five-number summary of the heights is given below.

Table 1: Five-Number Summary of Tomato Plant Heights (cm)
Min | Q1 | Median | Q3 | Max
34 | 42 | 48 | 55 | 90',
      '{"content_key":"apstats-frq-u12-005","subject":"ap_statistics","unit":1,"topic":"1.8 Graphical Representations of Summary Statistics for One Quantitative Variable","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Determine whether the maximum value of 90 cm is an outlier using the 1.5×IQR rule. Show all work.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Construct a modified boxplot for the data that correctly displays the outlier identified in part A.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Describe the shape of the distribution suggested by the five-number summary and boxplot, and explain how the presence of the outlier affects the choice between the mean/standard deviation and the median/IQR for describing center and spread.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Tomato Plant Heights: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d593678b-d611-42ed-aa7c-a777d6ae2f99'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-a-criterion-01', 'Calculates the correct IQR.', 1, 'IQR = 55 − 42 = 13.', 'Recompute Q3 minus Q1.', '[]'::jsonb),
      ('e269ff21-6196-4a21-a06f-05f68d59abff'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-a-criterion-02', 'Calculates the correct upper fence.', 1, 'Upper fence = 55 + 1.5(13) = 74.5.', 'Recompute Q3 + 1.5 × IQR.', '[]'::jsonb),
      ('907bd80e-a798-4635-aae5-3ea107029b95'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-a-criterion-03', 'States the correct conclusion with comparison shown.', 1, '90 > 74.5, so 90 is an outlier.', 'Compare 90 to the computed upper fence and state the conclusion.', '[]'::jsonb),
      ('5c70c4d0-b2c0-42df-ad2a-eb0bc1bb22e6'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-b-criterion-01', 'Draws a box from Q1 (42) to Q3 (55) with a line at the median (48).', 1, 'Box spans 42 to 55 with an internal line at 48.', 'Redraw the box using Q1 = 42, median = 48, and Q3 = 55.', '[]'::jsonb),
      ('99e0c9f5-4a82-4868-a069-935cfb662ef5'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-b-criterion-02', 'Draws whiskers only to the most extreme non-outlier values, not to 90.', 1, 'Lower whisker extends to 34; upper whisker extends to the largest value less than 74.5.', 'Extend the upper whisker only to the largest non-outlier value, not to 90.', '[]'::jsonb),
      ('a83fa2eb-b496-420c-a9f0-02b0522f4144'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-b-criterion-03', 'Plots 90 as a separate point beyond the whisker, consistent with part A''s conclusion.', 1, 'A distinct dot or asterisk appears at 90, separated from the whisker.', 'Add a separate marker for 90 beyond the upper whisker.', '[]'::jsonb),
      ('9e109dfa-98c7-4ac1-ae29-d7eca6962e59'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-c-criterion-01', 'Describes the shape as skewed to the right.', 1, 'Response states right skew, supported by the boxplot/outlier.', 'Describe the distribution as right-skewed.', '[]'::jsonb),
      ('9c86416b-4bba-45f4-abfb-be1d4efba18a'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-c-criterion-02', 'Supports the shape description with a numeric comparison (e.g., median is closer to Q1 than to Q3, and there is a long right tail to 90).', 1, 'Response computes median − Q1 = 6 versus Q3 − median = 7, or references the gap up to 90.', 'Compare the distances from the median to Q1 and Q3, and note the long tail toward the max.', '[]'::jsonb),
      ('ab9409a8-1a12-4a01-aae0-243273d6fa14'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-c-criterion-03', 'States that median/IQR is preferred over mean/SD for describing this distribution.', 1, 'Response explicitly recommends median and IQR.', 'State the preference for median/IQR given the outlier.', '[]'::jsonb),
      ('3d1e9764-38bb-4275-a187-2cab8ed2c8c5'::uuid, 'f0416713-2e3f-46f5-a306-80a8baa6ee48'::uuid, 'part-c-criterion-04', 'Explains why: mean and SD are sensitive to (not resistant to) outliers/skew, so the outlier would distort them upward.', 1, 'Explanation references resistance/non-resistance of the statistics.', 'Explain that the mean and SD are pulled upward by extreme values, unlike the median and IQR.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-006'
      and id <> 'c9e06a78-dfe6-49eb-a069-5a3bf2aa1ad7'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-006';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c9e06a78-dfe6-49eb-a069-5a3bf2aa1ad7'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c9e06a78-dfe6-49eb-a069-5a3bf2aa1ad7'::uuid,
      v_epv_id,
      'apstats-frq-u12-006',
      'frq',
      'Streaming Service Preference by Age Group',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid,
      'c9e06a78-dfe6-49eb-a069-5a3bf2aa1ad7'::uuid,
      1,
      'Streaming Service Preference by Age Group: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A media company surveyed 200 randomly selected adults about their preferred streaming service (A, B, or C) and recorded each respondent''s age group.

Table 1: Streaming Preference by Age Group
 | Under 30 | 30 and Over | Total
Service A | 48 | 32 | 80
Service B | 24 | 56 | 80
Service C | 8 | 32 | 40
Total | 80 | 120 | 200',
      '{"content_key":"apstats-frq-u12-006","subject":"ap_statistics","unit":2,"topic":"2.1 Tabular and Graphical Representations for the Distributions of Two Categorical Variables","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the marginal distribution of streaming service preference (overall proportions for A, B, and C).","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Calculate the conditional distribution of streaming preference for adults Under 30, and separately for adults 30 and Over.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Compare the two conditional distributions from part B, and use them to determine whether streaming preference and age group appear to be associated.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Calculate the probability that a randomly selected survey respondent is Under 30 and prefers Service C.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Streaming Service Preference by Age Group: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('d17d793a-8e7b-426b-a408-9a4da8f05aeb'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-a-criterion-01', 'States the correct three proportions.', 1, 'Service A = 0.40, Service B = 0.40, Service C = 0.20.', 'Recompute each row total divided by 200.', '[]'::jsonb),
      ('e2342c8f-cd8b-400c-ae82-e34c76330c89'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-a-criterion-02', 'Shows the correct method (each row total divided by 200).', 1, 'Work such as 80/200 is shown.', 'Show the division of each service''s total count by the grand total of 200.', '[]'::jsonb),
      ('2fc15423-aba3-4ae2-afbd-9379c1556eec'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-b-criterion-01', 'Calculates the correct conditional distribution for Under 30.', 1, 'Service A = 0.60, Service B = 0.30, Service C = 0.10.', 'Divide each Under-30 cell by the Under-30 column total of 80.', '[]'::jsonb),
      ('21eb42c7-a4b2-4554-a247-b18adcefe44b'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-b-criterion-02', 'Calculates the correct conditional distribution for 30 and Over.', 1, 'Service A ≈ 0.267, Service B ≈ 0.467, Service C ≈ 0.267.', 'Divide each 30-and-Over cell by the column total of 120.', '[]'::jsonb),
      ('0c56bb32-dc87-461c-a10d-bf2510823cc8'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-b-criterion-03', 'Shows the correct conditioning method (dividing by the relevant column total for each group).', 1, 'Work shows division by 80 for Under 30 and by 120 for 30 and Over.', 'Show the division step using the correct column total for each age group.', '[]'::jsonb),
      ('2e4a3f8a-e0a7-4324-aa32-67838460e5c6'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-c-criterion-01', 'Notes that the Under-30 group strongly favors Service A (60%), while the 30-and-Over group favors Service B (about 47%).', 1, 'Response cites both conditional percentages in the comparison.', 'Compare the leading service in each conditional distribution using the computed percentages.', '[]'::jsonb),
      ('ef5f7299-dd26-43fa-acde-a9820c63dac6'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-c-criterion-02', 'Concludes there does appear to be an association between age group and streaming preference.', 1, 'Response explicitly states an association exists.', 'State the conclusion that age group and preference appear associated.', '[]'::jsonb),
      ('5b615e7d-9f1b-4dc9-a44c-17394a7df93b'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-c-criterion-03', 'Bases the comparison on the conditional distributions (not just the raw marginal totals).', 1, 'Reasoning explicitly references the differing conditional percentages between groups, not just row/column totals.', 'Ground the comparison in the conditional distributions computed in part B rather than raw counts.', '[]'::jsonb),
      ('7dd14f0c-31ec-490c-a84d-6e4a62bbf2fa'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-d-criterion-01', 'Uses the correct approach: joint probability equals the cell count divided by the grand total.', 1, 'Work shows 8/200 rather than a conditional probability calculation.', 'Use the joint cell count for Under 30 and Service C, divided by 200.', '[]'::jsonb),
      ('4959f525-307e-4138-a2d8-f258b4a77e57'::uuid, '5a68fcbc-4c45-4bdc-ae2a-4acbcfaf79ac'::uuid, 'part-d-criterion-02', 'Calculates the correct value.', 1, 'Final answer is 0.04.', 'Recompute 8 ÷ 200.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-007'
      and id <> 'fd23b590-846f-49cc-a45d-16ff3d187c67'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-007';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'fd23b590-846f-49cc-a45d-16ff3d187c67'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'fd23b590-846f-49cc-a45d-16ff3d187c67'::uuid,
      v_epv_id,
      'apstats-frq-u12-007',
      'frq',
      'Allergy Test Accuracy',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid,
      'fd23b590-846f-49cc-a45d-16ff3d187c67'::uuid,
      1,
      'Allergy Test Accuracy: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A clinic uses a screening test for a particular allergy. In the population the clinic serves, 15% of people actually have the allergy. Given that a person has the allergy, the test returns a positive result 92% of the time. Given that a person does not have the allergy, the test incorrectly returns a positive result (false positive) 6% of the time.',
      '{"content_key":"apstats-frq-u12-007","subject":"ap_statistics","unit":2,"topic":"2.6 Conditional Probability","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Using a hypothetical group of 1000 people, fill in a table showing the four possible outcomes (allergy/no allergy crossed with positive/negative test result), with expected counts.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Calculate the probability that a randomly selected person actually has the allergy, given that their test result is positive.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Explain why the probability calculated in part B is much lower than 92%, the test''s accuracy rate for people who have the allergy, referencing the context.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Allergy Test Accuracy: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('e8022ae9-74cf-4854-a4d2-dd87f4b333eb'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-a-criterion-01', 'Correctly fills in the allergy row.', 1, '150 people have the allergy: 138 test positive, 12 test negative (0.92 × 150 = 138).', 'Recompute 92% and 8% of the 150 people with the allergy.', '[]'::jsonb),
      ('42d447bd-b9e3-43fc-a5a7-635cdeaecd7d'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-a-criterion-02', 'Correctly fills in the no-allergy row.', 1, '850 people do not have the allergy: 51 test positive, 799 test negative (0.06 × 850 = 51).', 'Recompute 6% and 94% of the 850 people without the allergy.', '[]'::jsonb),
      ('a4141d72-7d18-4484-a47b-c6717147b659'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-a-criterion-03', 'Correctly fills in the totals.', 1, '189 total positive, 811 total negative, 1000 grand total.', 'Sum each column (positive and negative) across both rows.', '[]'::jsonb),
      ('55f575e7-e9f3-4728-ad75-ca4a7ac67ca7'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-b-criterion-01', 'Correctly identifies this as the conditional probability P(allergy | positive).', 1, 'Response frames the calculation as a conditional probability with positive result as the given condition.', 'Set up P(allergy | positive) using the table from part A.', '[]'::jsonb),
      ('3715cec7-9ee7-4235-abee-77669589df43'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-b-criterion-02', 'Uses the correct numerator (positive AND allergy).', 1, 'Numerator of 138 is used.', 'Use the allergy-and-positive count of 138 as the numerator.', '[]'::jsonb),
      ('911e884e-1743-4b9f-a1ca-f64ffb4901e3'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-b-criterion-03', 'Uses the correct denominator (total positive).', 1, 'Denominator of 189 is used.', 'Use the total positive count of 189 as the denominator.', '[]'::jsonb),
      ('b6fff2cc-6d2d-4d43-ab2b-1a0d1451df01'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-b-criterion-04', 'Calculates the correct final value.', 1, 'P(allergy | positive) = 138/189 ≈ 0.730 (73.0%).', 'Recompute 138 ÷ 189.', '[]'::jsonb),
      ('0c7cf485-cb4d-42eb-a29a-574d9b0f7d57'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-c-criterion-01', 'Notes that 92% is P(positive | allergy), a different conditional probability than P(allergy | positive) since the order of conditioning matters.', 1, 'Response explicitly distinguishes the two conditional probabilities.', 'State that 92% conditions on having the allergy, while part B conditions on testing positive — these are different quantities.', '[]'::jsonb),
      ('6ba1df2d-909b-49cf-a427-f64bfb8ded00'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-c-criterion-02', 'Explains that because the allergy is relatively rare (15% prevalence) and the false positive rate is not zero, many positive results come from the much larger no-allergy group.', 1, 'Explanation references the low prevalence combined with a nonzero false-positive rate.', 'Explain that the small allergy group combined with a nonzero false positive rate produces many false positives among all positives.', '[]'::jsonb),
      ('46f41f21-a5c3-4097-aa4a-70ef7076da19'::uuid, '09c01266-44ef-4639-af6e-b9f8016b8211'::uuid, 'part-c-criterion-03', 'Ties the conclusion to specific counts (51 false positives vs. 138 true positives) to justify the lower value.', 1, 'Response cites the 51 vs. 138 counts from part A.', 'Reference the specific counts of false positives and true positives from the table.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-008'
      and id <> 'ee476290-e8fa-491d-ad5f-49a9e4a51f25'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-008';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'ee476290-e8fa-491d-ad5f-49a9e4a51f25'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'ee476290-e8fa-491d-ad5f-49a9e4a51f25'::uuid,
      v_epv_id,
      'apstats-frq-u12-008',
      'frq',
      'Carnival Game Payout',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid,
      'ee476290-e8fa-491d-ad5f-49a9e4a51f25'::uuid,
      1,
      'Carnival Game Payout: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'In a carnival game, a player pays $5 to play. The player draws one ball from a bag of 20 numbered balls and wins a prize based on the type of ball drawn.

Table 1: Prize Winnings
Outcome | Number of balls | Winnings (X)
Grand prize | 1 | $50
Medium prize | 4 | $10
Small prize | 5 | $2
No prize | 10 | $0',
      '{"content_key":"apstats-frq-u12-008","subject":"ap_statistics","unit":2,"topic":"2.9 Parameters of Random Variables","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the expected value of the winnings X for one play of the game.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Interpret the value found in part A in the context of whether the game is fair, given that it costs $5 to play.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Calculate the standard deviation of the winnings X.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Explain what the standard deviation found in part C indicates about the variability of outcomes in this game, compared to a hypothetical game with SD = $2.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Carnival Game Payout: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('7d5e9391-b335-42f7-a785-151bf38f0c31'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-a-criterion-01', 'Uses the correct probabilities for each outcome.', 1, 'P(50)=0.05, P(10)=0.20, P(2)=0.25, P(0)=0.50, based on the ball counts out of 20.', 'Recompute each outcome''s probability as its ball count divided by 20.', '[]'::jsonb),
      ('d31615ef-c050-4c45-a421-290080f28daa'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-a-criterion-02', 'Uses the correct expected value expression.', 1, 'Sum of x·P(x) across all four outcomes is shown.', 'Set up E(X) as the sum of each winnings value times its probability.', '[]'::jsonb),
      ('32f25fba-88cb-4d8b-a556-aaccca06247e'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-a-criterion-03', 'Calculates the correct final value.', 1, 'E(X) = 50(0.05)+10(0.20)+2(0.25)+0(0.50) = $5.00.', 'Recompute the weighted sum of the four products.', '[]'::jsonb),
      ('0b0871d5-694f-4cec-a5a3-0444a98c2225'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-b-criterion-01', 'States that since E(X) = $5 equals the cost to play, the game is fair on average (expected net gain of $0 in the long run).', 1, 'Response explicitly compares E(X) to the $5 cost and concludes fairness.', 'Compare the expected winnings to the $5 cost and state whether the game is fair.', '[]'::jsonb),
      ('46775ed9-b15b-471b-acb3-237f8ad3d7ba'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-b-criterion-02', 'Correctly frames this as a long-run average across many plays, not a guarantee for any single play.', 1, 'Response notes any individual play could win $0 or $50, but the average over many plays approaches $5.', 'Clarify that E(X) describes long-run average behavior, not a single play''s outcome.', '[]'::jsonb),
      ('2155e039-8e78-413c-acf7-b5c5d312589b'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-c-criterion-01', 'Calculates the correct E(X²).', 1, 'E(X²) = 2500(0.05)+100(0.20)+4(0.25)+0(0.50) = 146.', 'Recompute the weighted sum of the squared winnings values.', '[]'::jsonb),
      ('e0d004e3-f434-4a0c-ad6e-9cd3f345560c'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-c-criterion-02', 'Calculates the correct variance.', 1, 'Var(X) = 146 − 5² = 121.', 'Subtract [E(X)]² from E(X²).', '[]'::jsonb),
      ('3abee7d7-5fb7-415a-a9f6-1f7f5b656f26'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-c-criterion-03', 'Calculates the correct standard deviation.', 1, 'SD(X) = √121 = $11.00.', 'Take the square root of the variance.', '[]'::jsonb),
      ('04945478-33dd-4726-ae05-59710c8ac545'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-d-criterion-01', 'Notes that SD = $11 indicates high variability in winnings relative to the $5 average, since outcomes range from $0 to $50.', 1, 'Response connects the large SD to the wide range of possible winnings.', 'Explain that an SD of $11 reflects large swings between possible outcomes relative to the mean of $5.', '[]'::jsonb),
      ('d7821311-2bbb-4d63-a23e-320ae006e4f0'::uuid, 'ff256908-1a1d-4138-a396-0f24d1e0a8e4'::uuid, 'part-d-criterion-02', 'Correctly compares to a game with SD = $2, noting its outcomes would cluster much more tightly around its expected value (less risky/more predictable).', 1, 'Response explicitly contrasts the two SDs in terms of spread/predictability.', 'State that a smaller SD (like $2) means outcomes are more consistent and less risky than this game.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-009'
      and id <> 'd96694c3-cce5-407b-ae36-1656d7ce1164'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-009';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'd96694c3-cce5-407b-ae36-1656d7ce1164'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'd96694c3-cce5-407b-ae36-1656d7ce1164'::uuid,
      v_epv_id,
      'apstats-frq-u12-009',
      'frq',
      'Free Throw Shooting',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '350a6f19-505d-476e-a513-f7cc14473966'::uuid,
      'd96694c3-cce5-407b-ae36-1656d7ce1164'::uuid,
      1,
      'Free Throw Shooting: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A basketball player makes 75% of her free throws, and each attempt can be considered independent of the others. During a game, she attempts 6 free throws. Let X represent the number of free throws she makes.',
      '{"content_key":"apstats-frq-u12-009","subject":"ap_statistics","unit":2,"topic":"2.10 The Binomial Distribution","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Justify why X, the number of free throws made out of 6 attempts, can be modeled by a binomial random variable.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Calculate the probability that she makes exactly 4 of the 6 free throws.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Calculate the mean and standard deviation of X, the number of free throws made out of 6.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Free Throw Shooting: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3cd09a07-4ada-492c-a195-b80d516f4d4f'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-a-criterion-01', 'States there is a fixed number of trials (n = 6), each with two possible outcomes (make or miss).', 1, 'Response identifies fixed n and binary outcomes per trial.', 'State that there are a fixed number of attempts (6), each resulting in make or miss.', '[]'::jsonb),
      ('b5ce8667-5ac2-401b-a7f1-4281f4349d42'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-a-criterion-02', 'States the trials are independent with a constant probability of success (p = 0.75) on each attempt.', 1, 'Response references independence and constant p across attempts.', 'State that each attempt is independent with the same 0.75 probability of success.', '[]'::jsonb),
      ('6d90fbaf-9831-4bff-a86d-eb67fd6b6143'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-b-criterion-01', 'Sets up the correct binomial probability expression.', 1, 'Expression C(6,4)(0.75)^4(0.25)^2 is shown.', 'Set up P(X=4) using the binomial formula with n=6, p=0.75.', '[]'::jsonb),
      ('3496b0be-1078-4fb0-a867-81238a63466a'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-b-criterion-02', 'Calculates the correct combination value.', 1, 'C(6,4) = 15.', 'Recompute the number of ways to choose 4 successes out of 6 trials.', '[]'::jsonb),
      ('9af2dfd5-0691-4990-af35-e4061b87831e'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-b-criterion-03', 'Calculates the probability portion correctly.', 1, '(0.75)^4 × (0.25)^2 ≈ 0.019775.', 'Recompute (0.75)^4 times (0.25)^2.', '[]'::jsonb),
      ('7ca02a40-c942-4902-accd-d8e41bc26f92'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-b-criterion-04', 'Calculates the correct final probability.', 1, 'P(X=4) ≈ 0.297 (29.7%).', 'Multiply 15 by the probability portion to get the final answer.', '[]'::jsonb),
      ('bc4d7c4b-73d0-4a1d-a580-fa3fdb988727'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-c-criterion-01', 'Uses the correct mean formula.', 1, 'Mean = np is used.', 'Use the binomial mean formula μ = np.', '[]'::jsonb),
      ('abca21cc-ef51-49f8-ab70-f6a1d826f3a3'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-c-criterion-02', 'Calculates the correct mean value.', 1, 'Mean = 6 × 0.75 = 4.5.', 'Recompute 6 × 0.75.', '[]'::jsonb),
      ('52bff162-7aa3-453a-adac-eaf9ef1928ba'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-c-criterion-03', 'Uses the correct standard deviation formula.', 1, 'SD = √(np(1−p)) is used.', 'Use the binomial SD formula σ = √(np(1−p)).', '[]'::jsonb),
      ('0b7e841e-a84d-4983-a3f4-fddc0e271509'::uuid, '350a6f19-505d-476e-a513-f7cc14473966'::uuid, 'part-c-criterion-04', 'Calculates the correct standard deviation value.', 1, 'SD = √(6 × 0.75 × 0.25) = √1.125 ≈ 1.06.', 'Recompute √(6 × 0.75 × 0.25).', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-010'
      and id <> '8a42ff98-03a4-4ba2-ac27-296c1932def9'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-010';
  end if;

  if not exists (
    select 1 from app.content_items where id = '8a42ff98-03a4-4ba2-ac27-296c1932def9'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '8a42ff98-03a4-4ba2-ac27-296c1932def9'::uuid,
      v_epv_id,
      'apstats-frq-u12-010',
      'frq',
      'Fertilizer Experiment on Bean Plants',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 1 and 2'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid,
      '8a42ff98-03a4-4ba2-ac27-296c1932def9'::uuid,
      1,
      'Fertilizer Experiment on Bean Plants: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A researcher wants to determine whether a new fertilizer increases bean plant yield compared to the standard fertilizer. She has 40 bean plants of the same variety, all similar in initial size, arranged on 4 shelves (10 plants per shelf) at different distances from the greenhouse''s light source.',
      '{"content_key":"apstats-frq-u12-010","subject":"ap_statistics","unit":1,"topic":"1.13 Experimental Design","archetype":"Multi-Focus on Practices 1 and 2","difficulty":"Medium","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Explain how the researcher should use random assignment in this experiment and why it is important.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Describe how the researcher could incorporate blocking into the experimental design using the 4 shelves, and explain the potential benefit of doing so.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Identify the explanatory variable and the response variable in this experiment.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]},{"part_key":"part-d","prompt":"Explain why this study is an experiment rather than an observational study.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Fertilizer Experiment on Bean Plants: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('a8f28233-9a28-40dd-a20d-9536f1e39e8f'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-a-criterion-01', 'Describes randomly assigning plants to treatment groups (e.g., 20 plants to new fertilizer, 20 to standard fertilizer) using a chance mechanism such as random numbers.', 1, 'Procedure specifies a random method (e.g., random number generator) to split plants into the two fertilizer groups.', 'Describe a specific random mechanism for assigning plants to the two fertilizer groups.', '[]'::jsonb),
      ('aa1121d9-3629-4ef7-af55-e4614a495034'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-a-criterion-02', 'States that random assignment balances out other variables (lurking variables like plant vigor or position) between groups on average.', 1, 'Explanation references balancing unmeasured differences between plants across groups.', 'Explain that randomization tends to balance lurking variables between the two groups.', '[]'::jsonb),
      ('28786219-736a-4424-af55-ddccb081398c'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-a-criterion-03', 'Connects this to the purpose: allows any yield difference to be attributed to fertilizer type rather than confounding factors.', 1, 'Response ties random assignment to supporting a cause-and-effect conclusion about fertilizer.', 'State that this allows differences in yield to be attributed to the fertilizer rather than other factors.', '[]'::jsonb),
      ('cf73bb8f-f9a3-40fa-a3ee-bc64f04e0e62'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-b-criterion-01', 'Describes blocking by shelf (grouping the 10 plants on each shelf together before assigning fertilizer within each shelf).', 1, 'Procedure groups plants by shelf as blocks prior to treatment assignment.', 'Describe treating each of the 4 shelves as a block.', '[]'::jsonb),
      ('46f15415-66c6-4566-a309-4371902e7a7c'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-b-criterion-02', 'States the benefit: reduces variability due to the blocking variable (light exposure) so it does not obscure the treatment effect.', 1, 'Explanation references reducing extraneous variability from differing light exposure across shelves.', 'Explain that blocking reduces variability caused by differing light exposure between shelves.', '[]'::jsonb),
      ('6c50dade-49fa-4ea4-a30f-6946a866d8ce'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-b-criterion-03', 'Notes that random assignment of fertilizer still occurs within each block.', 1, 'Response specifies plants within each shelf are randomly split between the two fertilizers.', 'State that randomization of fertilizer type still happens within each shelf/block.', '[]'::jsonb),
      ('b663451b-5009-4766-a3ea-205b76b255d7'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-c-criterion-01', 'Correctly identifies the explanatory variable as fertilizer type (new vs. standard).', 1, 'Response names fertilizer type as the explanatory variable.', 'Identify fertilizer type as the explanatory variable.', '[]'::jsonb),
      ('cbca8a6f-2c47-402e-a54a-668b1b376525'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-c-criterion-02', 'Correctly identifies the response variable as plant yield (e.g., amount or weight of beans produced).', 1, 'Response names bean yield as the response variable.', 'Identify bean yield as the response variable.', '[]'::jsonb),
      ('665b5cea-5e40-4f2d-ab36-e32511c403a3'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-d-criterion-01', 'States that the researcher actively assigns/imposes the treatment (fertilizer type) rather than simply observing existing groups.', 1, 'Response notes the researcher controls which fertilizer each plant receives.', 'State that the researcher imposes the fertilizer treatment rather than observing pre-existing groups.', '[]'::jsonb),
      ('630446de-aba2-495a-abd0-979d2c2d5dcb'::uuid, '22897ba4-5b51-473d-a7dc-ea9012892f99'::uuid, 'part-d-criterion-02', 'Ties this to the ability to establish cause-and-effect, unlike observational studies which can only show association.', 1, 'Response contrasts experiments (causation) with observational studies (association only).', 'Explain that imposing treatment allows for a cause-and-effect conclusion, unlike an observational study.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-011'
      and id <> 'a4913da2-8e3b-4524-af90-74a5eb559735'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-011';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'a4913da2-8e3b-4524-af90-74a5eb559735'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'a4913da2-8e3b-4524-af90-74a5eb559735'::uuid,
      v_epv_id,
      'apstats-frq-u12-011',
      'frq',
      'Standardized Test Scores',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid,
      'a4913da2-8e3b-4524-af90-74a5eb559735'::uuid,
      1,
      'Standardized Test Scores: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'Scores on a national standardized test are approximately normally distributed with a mean of 500 and a standard deviation of 90.',
      '{"content_key":"apstats-frq-u12-011","subject":"ap_statistics","unit":2,"topic":"2.11 The Normal Distribution","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the probability that a randomly selected test-taker scores above 650.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Determine the test score that separates the top 10% of test-takers from the rest.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"A random sample of 36 test-takers is selected. Calculate the probability that the sample mean score is above 520.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Standardized Test Scores: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('16195d53-cf2f-4b7e-a1bd-cc7831abc0a8'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-a-criterion-01', 'Calculates the correct z-score.', 1, 'z = (650 − 500)/90 ≈ 1.67.', 'Recompute (650 − 500) ÷ 90.', '[]'::jsonb),
      ('e29a241f-26d7-46f2-a806-e4249d93ead5'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-a-criterion-02', 'Uses the correct upper-tail normal probability approach.', 1, 'Response computes 1 − P(Z < 1.67) rather than P(Z < 1.67).', 'Find the area to the right of z = 1.67 under the standard normal curve.', '[]'::jsonb),
      ('20e879de-1f1f-4843-a1ac-fcb4f1b0be63'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-a-criterion-03', 'Calculates the correct final probability.', 1, 'P(score > 650) ≈ 0.048 (4.8%).', 'Recompute 1 minus the cumulative probability at z ≈ 1.67.', '[]'::jsonb),
      ('880572c8-b9a5-456c-a891-e893aaca87c0'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-b-criterion-01', 'Correctly identifies the z-score for the 90th percentile.', 1, 'z ≈ 1.28 is used.', 'Find the z-score corresponding to the 90th percentile of the standard normal distribution.', '[]'::jsonb),
      ('6a15e265-3015-433f-af19-d4014055d49b'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-b-criterion-02', 'Sets up the correct inverse-normal equation.', 1, 'Equation score = mean + z × SD is shown.', 'Use score = μ + zσ to convert the z-score to a raw score.', '[]'::jsonb),
      ('6f8f4341-1cd6-49f2-a8ae-2a71c2a40836'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-b-criterion-03', 'Calculates the correct final score.', 1, 'Score ≈ 615 (500 + 1.28 × 90 = 615.2; accept 613–617).', 'Recompute 500 + 1.28 × 90.', '[]'::jsonb),
      ('fc97d091-87ee-4465-af18-ef9bc9ce8694'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-c-criterion-01', 'Recognizes that the sampling distribution of the sample mean applies (population is normal, or n = 36 is large enough for the CLT).', 1, 'Response explicitly references the sampling distribution of x̄ rather than the distribution of individual scores.', 'State that the distribution of the sample mean is used, since the population is normal and/or n is reasonably large.', '[]'::jsonb),
      ('8c331d3f-a06b-4820-a9a9-800b34eb1a93'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-c-criterion-02', 'Calculates the correct standard error.', 1, 'SE = 90/√36 = 15.', 'Recompute 90 divided by the square root of 36.', '[]'::jsonb),
      ('47d8898b-5dd4-428b-a75b-2ed42f894ba9'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-c-criterion-03', 'Calculates the correct z-score for the sample mean.', 1, 'z = (520 − 500)/15 ≈ 1.33.', 'Recompute (520 − 500) ÷ 15.', '[]'::jsonb),
      ('b96c727a-97f4-4245-a358-ed119784bd69'::uuid, '9a053602-a9d5-4a4a-a641-afb2d8fc9f11'::uuid, 'part-c-criterion-04', 'Calculates the correct final probability.', 1, 'P(x̄ > 520) ≈ 0.091 (9.1%).', 'Recompute 1 minus the cumulative probability at z ≈ 1.33.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-012'
      and id <> '4621efff-f4e8-4fd8-ac47-0c5600406d6c'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-012';
  end if;

  if not exists (
    select 1 from app.content_items where id = '4621efff-f4e8-4fd8-ac47-0c5600406d6c'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '4621efff-f4e8-4fd8-ac47-0c5600406d6c'::uuid,
      v_epv_id,
      'apstats-frq-u12-012',
      'frq',
      'Comparing Commute Times at Two Offices',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid,
      '4621efff-f4e8-4fd8-ac47-0c5600406d6c'::uuid,
      1,
      'Comparing Commute Times at Two Offices: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A company measured one-way commute times (in minutes) for random samples of employees at its Downtown office and its Suburban office.

Downtown (n=9): 12, 15, 18, 20, 22, 25, 28, 30, 55
Suburban (n=9): 25, 27, 29, 30, 31, 33, 34, 36, 38',
      '{"content_key":"apstats-frq-u12-012","subject":"ap_statistics","unit":1,"topic":"1.9 Comparisons of the Distributions for One Quantitative Variable","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the mean and median commute time for each office.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Compare the distributions of commute times at the two offices in context, addressing shape, center, and spread.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Determine whether the value of 55 minutes in the Downtown data is an outlier, using the 1.5×IQR rule.","points":2,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1}]},{"part_key":"part-d","prompt":"Explain why the median is a more appropriate measure to use when comparing \"typical\" commute time between the two offices than the mean.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Comparing Commute Times at Two Offices: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('5e69c1e0-34cd-445b-a9ca-d7f3aeec0ad3'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-a-criterion-01', 'Calculates the correct Downtown mean and median.', 1, 'Downtown mean = 225/9 = 25; median = 22 (5th of 9 sorted values).', 'Recompute the Downtown sum divided by 9, and the middle value of the sorted Downtown data.', '[]'::jsonb),
      ('3550d104-5077-49c1-a9f0-ca954781d6c9'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-a-criterion-02', 'Calculates the correct Suburban mean and median.', 1, 'Suburban mean = 283/9 ≈ 31.4; median = 31 (5th of 9 sorted values).', 'Recompute the Suburban sum divided by 9, and the middle value of the sorted Suburban data.', '[]'::jsonb),
      ('b860dc2d-2a8d-4c79-ad09-e5cbbe1fcdc3'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-b-criterion-01', 'Correctly notes Downtown is right-skewed (due to the 55-minute value) while Suburban is fairly symmetric.', 1, 'Response identifies the shape difference tied to the Downtown outlier.', 'Describe Downtown''s shape as right-skewed (due to 55) and Suburban''s as roughly symmetric.', '[]'::jsonb),
      ('b697ce26-3a6d-41ff-a433-2f61b1b336b8'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-b-criterion-02', 'Compares center, noting Suburban has a higher typical commute time.', 1, 'Response compares medians (31 vs. 22) or means (31.4 vs. 25) with correct direction.', 'Compare the medians or means of the two offices and state which is higher.', '[]'::jsonb),
      ('343ee925-9cd7-48f6-ae5b-28ea1b26aac9'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-b-criterion-03', 'Compares spread, noting Downtown has greater spread/range, largely driven by the outlier.', 1, 'Response compares ranges: Downtown 55−12=43 vs. Suburban 38−25=13.', 'Compute and compare the ranges (or IQRs) of the two data sets.', '[]'::jsonb),
      ('ecc241ee-df0a-443b-a8ff-ccd1e8386a7f'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-b-criterion-04', 'States all comparisons using explicit comparative language (e.g., "greater than," "less than") in context, rather than listing two separate descriptions.', 1, 'Response directly compares the two offices side-by-side rather than describing each independently.', 'Rewrite the comparisons using direct comparative language between the two offices.', '[]'::jsonb),
      ('6c8f4ab2-1ea8-4ec9-ab50-5f16bbc904d8'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-c-criterion-01', 'Calculates the correct Q1, Q3, IQR, and upper fence for the Downtown data.', 1, 'Q1 = 16.5, Q3 = 29, IQR = 12.5, upper fence = 29 + 1.5(12.5) = 47.75.', 'Split the Downtown data into lower and upper halves (excluding the median) to find Q1 and Q3, then compute the upper fence.', '[]'::jsonb),
      ('1e4b93ea-1f30-418b-aca4-b84ebc7409b6'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-c-criterion-02', 'States the correct conclusion.', 1, '55 > 47.75, so 55 is an outlier.', 'Compare 55 to the computed upper fence and state the conclusion.', '[]'::jsonb),
      ('ef6880ea-53ce-4386-ace7-18e263d6c125'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-d-criterion-01', 'States that the median is resistant to outliers/skew, unlike the mean.', 1, 'Response explicitly references resistance of the median compared to the mean.', 'State that the median is not affected as strongly by outliers or skewed data as the mean is.', '[]'::jsonb),
      ('3b4b927c-2bc1-4c40-aeb7-bdcf42406f33'::uuid, '3ffe16de-35ff-46ed-ad96-6709fc159cd4'::uuid, 'part-d-criterion-02', 'Ties this to context: Downtown''s outlier (55) inflates its mean, making a mean-based comparison misleading regarding typical commute experience.', 1, 'Response connects the Downtown outlier to a distorted mean-based comparison.', 'Explain that the 55-minute outlier inflates the Downtown mean, distorting a comparison based on means.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-013'
      and id <> 'f7dbe26b-eb58-4ae1-a30a-c31b65767ee3'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-013';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f7dbe26b-eb58-4ae1-a30a-c31b65767ee3'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f7dbe26b-eb58-4ae1-a30a-c31b65767ee3'::uuid,
      v_epv_id,
      'apstats-frq-u12-013',
      'frq',
      'Mall Survey Bias',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 1 and 2'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid,
      'f7dbe26b-eb58-4ae1-a30a-c31b65767ee3'::uuid,
      1,
      'Mall Survey Bias: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A shopping mall manager wants to estimate the proportion of all adults in the city who shop online at least once per week. She stands outside a department store on a Tuesday afternoon and surveys the first 100 adults who walk by.',
      '{"content_key":"apstats-frq-u12-013","subject":"ap_statistics","unit":1,"topic":"1.12 Potential Problems with Sampling","archetype":"Multi-Focus on Practices 1 and 2","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Identify the sampling method used in this study.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Explain two distinct ways this sampling method could lead to bias in estimating the proportion of all city adults who shop online weekly, and describe the likely direction of each bias.","points":4,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1},{"criterion_key":"part-b-criterion-04","points":1}]},{"part_key":"part-c","prompt":"Describe a sampling procedure the manager could use instead to obtain a more representative sample, and explain how it addresses the problems identified in part B.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Mall Survey Bias: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('ff72a537-6b0d-4b01-abba-101f9e8497a2'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-a-criterion-01', 'Correctly identifies this as a convenience sample.', 1, 'Response explicitly names convenience sampling.', 'Identify the method as a convenience sample.', '[]'::jsonb),
      ('84e23cc9-d1b5-4cdc-a98a-ba6e7be5dc05'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-a-criterion-02', 'Notes the sample was not randomly selected, distinguishing it from an SRS.', 1, 'Response states adults were not chosen using a chance mechanism.', 'State that the adults were selected based on availability/location, not by random selection.', '[]'::jsonb),
      ('38de2cff-e3e6-4cba-a7df-22588add0934'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-b-criterion-01', 'Identifies a plausible source of bias tied to location.', 1, 'Reasoning notes that surveying at a mall/department store selects for people who prefer in-person shopping, likely underrepresenting frequent online shoppers.', 'Explain how sampling at a physical store location could underrepresent frequent online shoppers.', '[]'::jsonb),
      ('7bd0dbf3-9dcf-4ed1-a80b-be0f5ac30f4a'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-b-criterion-02', 'States the likely direction for this location-based bias.', 1, 'Response states this would tend to underestimate the true proportion who shop online weekly.', 'State that this bias would likely cause an underestimate of the online-shopping proportion.', '[]'::jsonb),
      ('acef2fff-c696-497b-abe6-0c4f5e822e00'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-b-criterion-03', 'Identifies a plausible, distinct source of bias tied to timing.', 1, 'Reasoning notes a Tuesday afternoon excludes many working adults, biasing the sample toward retirees or others not employed full-time.', 'Explain how sampling on a weekday afternoon excludes many employed adults.', '[]'::jsonb),
      ('3c5b217b-b108-438c-ae20-0954d78d3ac3'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-b-criterion-04', 'States a likely direction/effect for this time-based bias, distinct from the first reason.', 1, 'Response describes how the excluded group (employed adults) may have different online shopping habits than those sampled, without simply repeating reason 1.', 'State a distinct effect of the time-based bias on the estimate, different from the location-based reasoning.', '[]'::jsonb),
      ('d1a2ed24-049a-4f6c-aea3-02b79b30ee75'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-c-criterion-01', 'Proposes a specific improved method, such as a random sample of city residents drawn from a citywide list, or a stratified sample across multiple locations and times.', 1, 'A concrete alternative method is named, not just "survey more people."', 'Propose a specific alternative sampling method, such as a random sample from a citywide resident list.', '[]'::jsonb),
      ('a9044e0f-65f8-4ec8-a3d6-977aaa91ebef'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-c-criterion-02', 'The method includes an explicit random selection mechanism.', 1, 'Procedure specifies a chance-based selection process (e.g., random number generator applied to a resident list).', 'Add a random selection mechanism to the proposed method.', '[]'::jsonb),
      ('22634c24-a3f1-4937-a7f8-5eee9e8e0f3b'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-c-criterion-03', 'Explains how the new method reduces the location-based bias identified in part B.', 1, 'Explanation shows the new method reaches adults who are not mall shoppers.', 'Explain how the proposed method includes adults who would not be captured at the mall.', '[]'::jsonb),
      ('a2527613-33b9-4820-a47d-99d46e6af019'::uuid, '4b713cd8-0e04-477c-ac93-1cc73faf2315'::uuid, 'part-c-criterion-04', 'Explains how the new method reduces the time-based bias identified in part B.', 1, 'Explanation shows the new method reaches adults with varied schedules/employment status.', 'Explain how the proposed method includes adults unavailable on a weekday afternoon.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-014'
      and id <> 'f4ca034a-6b6b-4a24-ae04-4ffb82eef35f'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-014';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f4ca034a-6b6b-4a24-ae04-4ffb82eef35f'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f4ca034a-6b6b-4a24-ae04-4ffb82eef35f'::uuid,
      v_epv_id,
      'apstats-frq-u12-014',
      'frq',
      'Simulating Free Kick Success',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid,
      'f4ca034a-6b6b-4a24-ae04-4ffb82eef35f'::uuid,
      1,
      'Simulating Free Kick Success: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A soccer player makes a successful free kick 40% of the time. A coach wants to estimate, via simulation, the probability that the player makes at least 2 of her next 5 free kicks.',
      '{"content_key":"apstats-frq-u12-014","subject":"ap_statistics","unit":2,"topic":"2.3 Estimating Probabilities Using Simulation","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Describe a complete simulation process using random digits to estimate this probability, including how digits are assigned to represent \"made\" and \"missed\" outcomes.","points":4,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1},{"criterion_key":"part-a-criterion-04","points":1}]},{"part_key":"part-b","prompt":"Using the digit assignment from part A (0–3 = made, 4–9 = missed), determine the outcome (number of makes and whether it counts as a success) for each of the following three simulated trials.\n\nTrial 1: 3 8 1 4 6\nTrial 2: 7 2 0 9 5\nTrial 3: 4 4 2 1 3","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Given that 27 out of 50 total simulated trials resulted in at least 2 makes, estimate the probability that the player makes at least 2 of her next 5 free kicks, and interpret this estimate in context.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]}]}'::jsonb,
      md5('Simulating Free Kick Success: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('bd57bc50-a88c-4615-a578-18bd827fa036'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-a-criterion-01', 'Assigns digits correctly for a 40% probability.', 1, 'Procedure assigns digits 0–3 to "made" and 4–9 to "missed" (or an equivalent valid assignment).', 'Assign 4 of the 10 single digits to represent a made kick, matching the 40% probability.', '[]'::jsonb),
      ('7ab69bab-7a5e-4484-a4a9-db90b25c8a47'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-a-criterion-02', 'States each trial uses 5 random digits to represent the 5 free-kick attempts.', 1, 'Procedure specifies reading a group of 5 digits per trial.', 'State that each simulated trial consists of 5 digits, one per attempt.', '[]'::jsonb),
      ('c0692ff6-b338-4389-a43d-77586f113f65'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-a-criterion-03', 'Describes counting the number of "made" digits in each group of 5 and recording whether the count is at least 2.', 1, 'Procedure explains tallying made-outcomes per trial and comparing to the threshold of 2.', 'Describe counting made-digits per trial and checking whether the count is 2 or more.', '[]'::jsonb),
      ('084c1f73-668d-4e92-a873-b03622958fbb'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-a-criterion-04', 'States the process is repeated for many trials, and the estimated probability is the proportion of trials with at least 2 makes.', 1, 'Procedure specifies repeating for many trials (e.g., at least 50) and computing (successful trials)/(total trials).', 'Add that the simulation is repeated many times and the probability is estimated as the fraction of trials with at least 2 makes.', '[]'::jsonb),
      ('7ea9363c-7ca6-433a-acc8-2c9a3cc546c1'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-b-criterion-01', 'Correctly determines Trial 1.', 1, 'Digits 3,8,1,4,6 give makes at 3 and 1 (2 makes total); a success since 2 ≥ 2.', 'Recount which digits in Trial 1 fall in the 0–3 range.', '[]'::jsonb),
      ('14b5d242-ea2e-4ff4-a1eb-91fea15f7906'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-b-criterion-02', 'Correctly determines Trial 2.', 1, 'Digits 7,2,0,9,5 give makes at 2 and 0 (2 makes total); a success since 2 ≥ 2.', 'Recount which digits in Trial 2 fall in the 0–3 range.', '[]'::jsonb),
      ('1f659db2-7d77-45d4-a512-9c964e951a8e'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-b-criterion-03', 'Correctly determines Trial 3.', 1, 'Digits 4,4,2,1,3 give makes at 2,1,3 (3 makes total); a success since 3 ≥ 2.', 'Recount which digits in Trial 3 fall in the 0–3 range.', '[]'::jsonb),
      ('bd876ede-fd99-48cf-af5f-dd19555b9c4d'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-c-criterion-01', 'Calculates the correct estimate.', 1, '27/50 = 0.54.', 'Recompute 27 divided by 50.', '[]'::jsonb),
      ('97080e71-8761-4a74-ac5f-d4b4c7ed971f'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-c-criterion-02', 'Interprets this as an estimated probability of about 54%.', 1, 'Response expresses 0.54 as approximately a 54% chance.', 'State the estimate as a probability/percentage in context.', '[]'::jsonb),
      ('f3071d52-c379-4a77-aa0d-ced2c61d12f6'::uuid, 'f3b2730e-2ea9-4ab9-ad22-01566fa117e3'::uuid, 'part-c-criterion-03', 'Notes this is a simulation-based estimate that would vary with more trials, not an exact theoretical probability.', 1, 'Response acknowledges the estimate''s variability and connects it to the free-kick context.', 'Add that this estimate is approximate and could change with additional simulated trials.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-015'
      and id <> 'c15d8495-3926-4af0-a56d-b0ebd3901957'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-015';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'c15d8495-3926-4af0-a56d-b0ebd3901957'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'c15d8495-3926-4af0-a56d-b0ebd3901957'::uuid,
      v_epv_id,
      'apstats-frq-u12-015',
      'frq',
      'Warranty Claims Independence',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '0838c759-dc87-4acf-ac86-06057344b531'::uuid,
      'c15d8495-3926-4af0-a56d-b0ebd3901957'::uuid,
      1,
      'Warranty Claims Independence: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'For a certain model of laptop, 20% of laptops sold require a warranty repair for the screen, and 15% require a warranty repair for the battery. Records show that 5% of laptops require warranty repairs for both the screen and the battery. Let S = event that a laptop needs a screen repair, and B = event that a laptop needs a battery repair.',
      '{"content_key":"apstats-frq-u12-015","subject":"ap_statistics","unit":2,"topic":"2.5 Mutually Exclusive Events","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the probability that a randomly selected laptop needs a warranty repair for the screen or the battery (or both).","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Determine whether events S and B are mutually exclusive. Justify your answer.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Determine whether events S and B are independent. Justify your answer using probability calculations.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Calculate the probability that a laptop needs a battery repair, given that it needs a screen repair.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Warranty Claims Independence: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('f8bbc004-bce4-40b4-a55e-cdc0ba44dcea'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-a-criterion-01', 'Uses the general addition rule, subtracting the overlap.', 1, 'Expression P(S) + P(B) − P(S and B) is shown.', 'Apply the general addition rule: P(S or B) = P(S) + P(B) − P(S and B).', '[]'::jsonb),
      ('b3d1b415-644d-410f-a4f9-b011e5749f69'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-a-criterion-02', 'Calculates the correct value.', 1, 'P(S or B) = 0.20 + 0.15 − 0.05 = 0.30.', 'Recompute 0.20 + 0.15 − 0.05.', '[]'::jsonb),
      ('d3e5a1e4-5f6e-44ff-a943-fcecdc1e4031'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-b-criterion-01', 'States that S and B are not mutually exclusive.', 1, 'Response explicitly classifies the events as not mutually exclusive.', 'State the classification: not mutually exclusive.', '[]'::jsonb),
      ('7cbc41d6-120f-4ca6-acbe-6eddb6cb3bba'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-b-criterion-02', 'Justifies using P(S and B) = 0.05 ≠ 0.', 1, 'Response notes that mutually exclusive events would require P(S and B) = 0.', 'State that mutually exclusive events require P(S and B) = 0, but here it is 0.05.', '[]'::jsonb),
      ('ea7c32f5-4880-423a-aeb0-6a2655a2745a'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-b-criterion-03', 'Connects to context: some laptops need both repairs, so the events can occur together.', 1, 'Response explains that a laptop can need both a screen and battery repair simultaneously.', 'Explain that laptops needing both repairs exist, so the events are not mutually exclusive.', '[]'::jsonb),
      ('e664a7c2-fd00-49f6-a9e6-0070ecb1b1b1'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-c-criterion-01', 'States that S and B are not independent.', 1, 'Response explicitly classifies the events as not independent.', 'State the classification: not independent.', '[]'::jsonb),
      ('8ffe4bd0-dea8-4166-a9cb-124f313f1ad8'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-c-criterion-02', 'Correctly computes P(S) × P(B) and compares it to the actual P(S and B).', 1, 'P(S) × P(B) = 0.20 × 0.15 = 0.03, compared with the given P(S and B) = 0.05.', 'Compute P(S) × P(B) and compare it to the given joint probability of 0.05.', '[]'::jsonb),
      ('dd42f682-d35e-423f-aeef-a11589ff8d50'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-c-criterion-03', 'Justifies that since these values are unequal (0.03 ≠ 0.05), the events are not independent.', 1, 'Response states that this inequality is the basis for the independence conclusion, and ties it to the context of associated repair needs.', 'Explain that unequal values (0.03 vs. 0.05) indicate the two repair needs are associated, not independent.', '[]'::jsonb),
      ('0f65b8e7-9507-44e3-ad01-e8ad69355e3b'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-d-criterion-01', 'Uses the correct conditional probability formula.', 1, 'P(B|S) = P(B and S)/P(S) is shown.', 'Set up the conditional probability formula P(B|S) = P(S and B) / P(S).', '[]'::jsonb),
      ('60ce6a48-e893-4abc-a21f-edb9f027ab52'::uuid, '0838c759-dc87-4acf-ac86-06057344b531'::uuid, 'part-d-criterion-02', 'Calculates the correct value.', 1, 'P(B|S) = 0.05/0.20 = 0.25.', 'Recompute 0.05 divided by 0.20.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-016'
      and id <> '81508254-a2e0-4906-ae6f-e7a63e0ad431'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-016';
  end if;

  if not exists (
    select 1 from app.content_items where id = '81508254-a2e0-4906-ae6f-e7a63e0ad431'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '81508254-a2e0-4906-ae6f-e7a63e0ad431'::uuid,
      v_epv_id,
      'apstats-frq-u12-016',
      'frq',
      'Insurance Policy Payout',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid,
      '81508254-a2e0-4906-ae6f-e7a63e0ad431'::uuid,
      1,
      'Insurance Policy Payout: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'An insurance company sells a 1-year policy that pays out $20,000 if the policyholder files a covered claim, and $0 otherwise. Based on historical data, the probability that a given policyholder files a covered claim in a year is 0.02. Each policy costs the customer $500 per year.',
      '{"content_key":"apstats-frq-u12-016","subject":"ap_statistics","unit":2,"topic":"2.8 Introduction to Random Variables and Probability Distributions","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Construct the probability distribution table for Y, the amount the insurance company pays out to a single policyholder in a year.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Calculate the expected payout E(Y) for a single policyholder, and use it to determine the company''s expected profit per policy.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Calculate the standard deviation of Y.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Explain why the insurance company, unlike an individual policyholder, can rely on the expected value calculated in part B to reliably predict its overall profit.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Insurance Policy Payout: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('a569b1de-ee4c-4448-a411-6450e8629ae4'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-a-criterion-01', 'Correctly lists both possible payout values.', 1, 'Y = 0 and Y = 20,000 are the two listed outcomes.', 'List both possible payout amounts: $0 and $20,000.', '[]'::jsonb),
      ('64e61dc5-56b0-46bb-a964-4ea44cb5cdd5'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-a-criterion-02', 'Correctly lists the corresponding probabilities.', 1, 'P(Y=0) = 0.98 and P(Y=20000) = 0.02.', 'Pair each payout with its correct probability (0.98 and 0.02).', '[]'::jsonb),
      ('69dd88c6-4e11-4203-af50-5a4340ce028c'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-b-criterion-01', 'Calculates the correct E(Y).', 1, 'E(Y) = 20000(0.02) + 0(0.98) = $400.', 'Recompute 20000 × 0.02.', '[]'::jsonb),
      ('9668a93d-8f0d-4ab7-acd2-59e4e6bcc95d'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-b-criterion-02', 'Uses the correct profit calculation (revenue minus expected payout).', 1, 'Profit = 500 − 400 is shown.', 'Subtract the expected payout from the $500 revenue per policy.', '[]'::jsonb),
      ('4412a759-7ec3-40a7-a57f-2cfe877b9a0a'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-b-criterion-03', 'Calculates the correct final expected profit.', 1, 'Expected profit = $100 per policy.', 'Recompute 500 − 400.', '[]'::jsonb),
      ('86efda1e-ac5b-4d43-a486-048f29681b81'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-c-criterion-01', 'Calculates the correct E(Y²).', 1, 'E(Y²) = 20000² (0.02) = 8,000,000.', 'Recompute 20000 squared times 0.02.', '[]'::jsonb),
      ('922a8a82-aa68-453b-a20b-dda647d20e89'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-c-criterion-02', 'Calculates the correct variance.', 1, 'Var(Y) = 8,000,000 − 400² = 7,840,000.', 'Subtract [E(Y)]² from E(Y²).', '[]'::jsonb),
      ('d2cb47da-0ceb-42e9-a266-2c4d7ffeb9fb'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-c-criterion-03', 'Calculates the correct standard deviation.', 1, 'SD(Y) = √7,840,000 = $2,800.', 'Take the square root of the variance.', '[]'::jsonb),
      ('712f09fa-9ebc-479d-a764-fec0a0c1ee54'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-d-criterion-01', 'Notes the company sells many policies (a large number of independent policyholders), so the average payout per policy will be close to the expected value.', 1, 'Response references the law of large numbers or averaging over many independent policies.', 'Explain that with many independent policies, the average outcome converges toward the expected value.', '[]'::jsonb),
      ('0302a9d7-cb37-4b95-a7ab-74a986a4a749'::uuid, 'c41a14bc-0ecb-42a3-ac92-4837389d9ac5'::uuid, 'part-d-criterion-02', 'Contrasts with a single policyholder, for whom the actual outcome could differ greatly from the expected value.', 1, 'Response notes a single policyholder either pays $0 or $20,000, far from the $400 expected value.', 'Contrast the high relative variability for one policyholder with the stability across many policies.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-017'
      and id <> 'dcedcb2b-3c9d-4e14-a931-79ab0e8f47dc'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-017';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'dcedcb2b-3c9d-4e14-a931-79ab0e8f47dc'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'dcedcb2b-3c9d-4e14-a931-79ab0e8f47dc'::uuid,
      v_epv_id,
      'apstats-frq-u12-017',
      'frq',
      'Commuter Transportation Mode Survey',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid,
      'dcedcb2b-3c9d-4e14-a931-79ab0e8f47dc'::uuid,
      1,
      'Commuter Transportation Mode Survey: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A city transportation department surveyed 250 randomly selected commuters about their primary mode of transportation to work (Car, Bus, Bike, or Walk) and whether they live within 3 miles of downtown or farther than 3 miles.

Table 1: Transportation Mode by Distance from Downtown
 | Within 3 miles | Farther than 3 miles | Total
Car | 40 | 110 | 150
Bus | 20 | 30 | 50
Bike | 25 | 5 | 30
Walk | 15 | 5 | 20
Total | 100 | 150 | 250',
      '{"content_key":"apstats-frq-u12-017","subject":"ap_statistics","unit":1,"topic":"1.3 Tabular Representation and Summary Statistics for One Categorical Variable","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Classify each of the two recorded variables (transportation mode and distance-from-downtown group) as categorical or quantitative.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Calculate the conditional distribution of transportation mode for commuters who live within 3 miles of downtown.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Construct a segmented (stacked) bar graph comparing the conditional distributions of transportation mode for the two distance groups.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Compare the conditional distributions of transportation mode between the two distance groups, and state whether there appears to be an association between distance from downtown and transportation mode.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Commuter Transportation Mode Survey: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('4e48c82a-f832-49c3-a2af-e2956e9401f3'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-a-criterion-01', 'Correctly classifies transportation mode as categorical.', 1, 'Response labels transportation mode as categorical.', 'Classify transportation mode as categorical, since its values are named groups.', '[]'::jsonb),
      ('4474b7f8-7771-4c39-afb3-ef0d34f35178'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-a-criterion-02', 'Correctly classifies the distance-from-downtown grouping as categorical, as it is recorded here.', 1, 'Response labels the within/farther grouping as categorical since it is presented as two named groups in this table.', 'Classify the distance grouping as categorical since it is recorded as two labeled groups (within 3 miles / farther than 3 miles).', '[]'::jsonb),
      ('8784dd28-eaaf-435c-a993-1eda5484d25e'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-b-criterion-01', 'Calculates the correct proportions for all four categories.', 1, 'Car = 0.40, Bus = 0.20, Bike = 0.25, Walk = 0.15.', 'Recompute each Within-3-miles cell divided by the column total of 100.', '[]'::jsonb),
      ('81b7f549-8917-4efc-a726-e8a4fd9a2926'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-b-criterion-02', 'Uses the correct method (each cell divided by the column total of 100).', 1, 'Work such as 40/100 is shown for at least one category.', 'Show the division of each cell by the Within-3-miles column total.', '[]'::jsonb),
      ('41d3aecb-6e3e-4730-a3d4-25f3e642f7e8'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-b-criterion-03', 'The reported proportions are internally consistent, summing to 1.', 1, '0.40+0.20+0.25+0.15 = 1.00.', 'Check that the four proportions sum to 1 and correct any arithmetic error.', '[]'::jsonb),
      ('57a6d8fa-5254-4f9d-a274-818cc7558eb4'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-c-criterion-01', 'Draws two bars (one per distance group), each with total height 1 (or 100%), segmented by mode in correct relative proportions.', 1, 'Within-3 bar segmented roughly 40/20/25/15; farther bar segmented roughly 73/20/3/3.', 'Redraw the two full-height bars with segment sizes matching each group''s conditional distribution.', '[]'::jsonb),
      ('20f149c7-5531-4f2a-a334-7c91903c67fb'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-c-criterion-02', 'Uses consistent segment ordering and a legend identifying each transportation mode.', 1, 'Segments appear in the same order in both bars, with a legend mapping colors/patterns to modes.', 'Add a legend and keep segment order consistent across both bars.', '[]'::jsonb),
      ('4ef50433-da50-4a5a-adb7-8acf020e6d3e'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-c-criterion-03', 'Labels both axes and includes a title.', 1, 'Distance group is labeled on one axis, percent/proportion on the other, with a graph title.', 'Add axis labels (distance group; percent or proportion) and a title.', '[]'::jsonb),
      ('65e2571b-d4c7-4387-a95b-f05324370fc3'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-d-criterion-01', 'Notes the substantial contrast between groups, such as car use being much higher farther from downtown (about 73.3%) versus within 3 miles (40%), while bike/walk usage is much higher within 3 miles (40% combined) than farther away (about 6.7% combined).', 1, 'Response cites specific conditional percentages in the comparison.', 'Compare the conditional percentages for car and bike/walk use between the two groups.', '[]'::jsonb),
      ('2673b4ee-805b-4d90-a877-a553b8c0ce33'::uuid, '3de3974f-38ba-408d-abe6-69de5d0eff8c'::uuid, 'part-d-criterion-02', 'Concludes there is an association between distance and transportation mode.', 1, 'Response explicitly states the conditional distributions differ substantially, indicating association.', 'State the conclusion that distance and transportation mode appear associated.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-018'
      and id <> 'b97d6604-1b56-4a08-a462-9a5b0e4af145'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-018';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'b97d6604-1b56-4a08-a462-9a5b0e4af145'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'b97d6604-1b56-4a08-a462-9a5b0e4af145'::uuid,
      v_epv_id,
      'apstats-frq-u12-018',
      'frq',
      'Manufacturing Defect Tree Diagram',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid,
      'b97d6604-1b56-4a08-a462-9a5b0e4af145'::uuid,
      1,
      'Manufacturing Defect Tree Diagram: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A factory produces circuit boards using three machines: Machine A produces 50% of all boards, Machine B produces 30%, and Machine C produces 20%. Historical defect rates are: 2% of Machine A''s boards are defective, 5% of Machine B''s boards are defective, and 8% of Machine C''s boards are defective. A board is selected at random from the factory''s total output.',
      '{"content_key":"apstats-frq-u12-018","subject":"ap_statistics","unit":2,"topic":"2.6 Conditional Probability","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Very Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Construct a tree diagram (or equivalent table) showing all machine and defect-status branches with their associated probabilities.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Calculate the overall probability that a randomly selected board is defective.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Given that a randomly selected board is defective, calculate the probability that it was produced by Machine C.","points":3,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1}]},{"part_key":"part-d","prompt":"Determine whether the event \"the board was produced by Machine C\" and the event \"the board is defective\" are independent, based on your calculations.","points":1,"criteria":[{"criterion_key":"part-d-criterion-01","points":1}]}]}'::jsonb,
      md5('Manufacturing Defect Tree Diagram: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('75267b98-2481-4927-a749-2abd38d72265'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-a-criterion-01', 'Shows correct first-level branch probabilities for the three machines.', 1, 'P(A)=0.50, P(B)=0.30, P(C)=0.20.', 'Set the first-level branches to the given machine production percentages.', '[]'::jsonb),
      ('7c638781-7dbc-4033-ad59-07065bb0a02f'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-a-criterion-02', 'Shows correct second-level conditional defect probabilities from each machine.', 1, 'From A: 0.02 defective/0.98 not; from B: 0.05/0.95; from C: 0.08/0.92.', 'Attach the correct conditional defect and non-defect probabilities under each machine branch.', '[]'::jsonb),
      ('2b7525c4-e90a-49a4-aef7-d9a4b5518456'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-a-criterion-03', 'Shows all six joint outcome paths (each machine crossed with defective or not).', 1, 'Diagram/table includes six distinct branch endpoints.', 'Ensure the diagram or table displays all six machine-by-defect-status combinations.', '[]'::jsonb),
      ('d94008e3-09e4-4133-abc5-110f5ae18adf'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-b-criterion-01', 'Uses the law of total probability, summing joint probabilities across machines.', 1, 'Expression P(A)P(D|A)+P(B)P(D|B)+P(C)P(D|C) is shown.', 'Sum the joint defective probabilities from each machine branch.', '[]'::jsonb),
      ('dbe7f4ca-0508-40d6-a1d7-4e7b6b2518d1'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-b-criterion-02', 'Calculates the correct individual joint probabilities.', 1, '0.5×0.02=0.01, 0.3×0.05=0.015, 0.2×0.08=0.016.', 'Recompute each machine''s probability times its defect rate.', '[]'::jsonb),
      ('614e3ca6-0443-4e0e-a6b2-97e06e043a42'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-b-criterion-03', 'Calculates the correct total.', 1, 'P(defective) = 0.01+0.015+0.016 = 0.041.', 'Sum the three joint probabilities.', '[]'::jsonb),
      ('e9d9cba4-dd8d-4653-a394-7a0cbee6ea35'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-c-criterion-01', 'Sets up the correct Bayes''-type ratio.', 1, 'P(C|D) = P(C and D)/P(D) is shown.', 'Set up the conditional probability as the joint probability for C divided by the total defective probability.', '[]'::jsonb),
      ('d597298a-2d4a-4d84-a97b-4595c4b62643'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-c-criterion-02', 'Uses the correct values from parts A and B.', 1, '0.016/0.041 is used.', 'Use the joint probability for Machine C (0.016) and the total defective probability (0.041) from earlier parts.', '[]'::jsonb),
      ('d394404f-bcfb-4c07-a808-88969e4544dd'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-c-criterion-03', 'Calculates the correct final probability.', 1, 'P(C|D) ≈ 0.390 (39.0%).', 'Recompute 0.016 divided by 0.041.', '[]'::jsonb),
      ('834e26e9-8e41-4935-acbb-dcf0e19efc98'::uuid, 'a115bde8-0657-4607-aa4a-4a46ed141af3'::uuid, 'part-d-criterion-01', 'Correctly states the events are not independent, referencing that P(defective|C) = 0.08 differs from the overall P(defective) = 0.041 found in part B.', 1, 'Response compares 0.08 to 0.041 and concludes non-independence, consistent with earlier work.', 'Compare P(defective|C) = 0.08 to the overall P(defective) = 0.041 from part B and state that their inequality shows the events are not independent.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-019'
      and id <> 'f90a9e1b-6fd9-4158-a668-f4ed22e3f8c6'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-019';
  end if;

  if not exists (
    select 1 from app.content_items where id = 'f90a9e1b-6fd9-4158-a668-f4ed22e3f8c6'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      'f90a9e1b-6fd9-4158-a668-f4ed22e3f8c6'::uuid,
      v_epv_id,
      'apstats-frq-u12-019',
      'frq',
      'Quality Control Sampling of LED Bulbs',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid,
      'f90a9e1b-6fd9-4158-a668-f4ed22e3f8c6'::uuid,
      1,
      'Quality Control Sampling of LED Bulbs: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A manufacturer states that 6% of the LED bulbs it produces are defective. Quality control inspects random samples of 200 bulbs from the production line each day. Let X represent the number of defective bulbs found in a sample of 200.',
      '{"content_key":"apstats-frq-u12-019","subject":"ap_statistics","unit":2,"topic":"2.12 Sampling Distributions and the Central Limit Theorem","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Very Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Calculate the mean and standard deviation of X, assuming the manufacturer''s claim of 6% is correct.","points":2,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1}]},{"part_key":"part-b","prompt":"Justify why a Normal distribution can be used to approximate the distribution of X, the number of defective bulbs.","points":2,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1}]},{"part_key":"part-c","prompt":"Using the Normal approximation, calculate the probability that a random sample of 200 bulbs contains more than 18 defective bulbs.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]},{"part_key":"part-d","prompt":"The quality control manager observes 22 defective bulbs in one day''s sample of 200. Interpret whether this result provides evidence that the true defect rate might be higher than the manufacturer''s claimed 6%.","points":2,"criteria":[{"criterion_key":"part-d-criterion-01","points":1},{"criterion_key":"part-d-criterion-02","points":1}]}]}'::jsonb,
      md5('Quality Control Sampling of LED Bulbs: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('3071b9f9-488b-4a7a-a2ce-84210d04a8e5'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-a-criterion-01', 'Calculates the correct mean.', 1, 'Mean = np = 200 × 0.06 = 12.', 'Recompute 200 × 0.06.', '[]'::jsonb),
      ('b7f42550-9f50-464f-a664-11d4910d965a'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-a-criterion-02', 'Calculates the correct standard deviation.', 1, 'SD = √(200 × 0.06 × 0.94) = √11.28 ≈ 3.36.', 'Recompute √(200 × 0.06 × 0.94).', '[]'::jsonb),
      ('3876cf5f-7283-425b-a2ce-79ef5d1365b5'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-b-criterion-01', 'States the large counts condition values.', 1, 'np = 12 and n(1−p) = 188 are both computed.', 'Compute np and n(1−p) for this sample size and defect rate.', '[]'::jsonb),
      ('7f0c5c0c-0746-4ba8-a8b1-ca3ab8eea619'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-b-criterion-02', 'Concludes that since both values are at least 10, the distribution of X is approximately Normal.', 1, 'Response explicitly states both conditions (np ≥ 10 and n(1−p) ≥ 10) are satisfied and draws the conclusion.', 'Compare both values to the threshold of 10 and state the Normal approximation is justified.', '[]'::jsonb),
      ('ad11e914-b952-4d94-a9c4-13fb0aed0762'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-c-criterion-01', 'Sets up the Normal approximation using the mean and SD from part A.', 1, 'Mean = 12, SD ≈ 3.36 are used as the Normal parameters.', 'Use the mean (12) and SD (≈3.36) from part A as the Normal model''s parameters.', '[]'::jsonb),
      ('d9ad419e-956b-4220-ae91-ca28efac3545'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-c-criterion-02', 'Applies a continuity correction, using 18.5 as the boundary for "more than 18."', 1, 'Calculation uses 18.5 rather than 18 as the cutoff value.', 'Adjust the boundary to 18.5 to account for approximating a discrete distribution with a continuous one.', '[]'::jsonb),
      ('0c77701f-8550-4664-a56a-b6a8a873a0f4'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-c-criterion-03', 'Calculates the correct z-score.', 1, 'z = (18.5 − 12)/3.36 ≈ 1.94.', 'Recompute (18.5 − 12) ÷ 3.36.', '[]'::jsonb),
      ('cad82bd2-ba8b-4458-acb5-b81745f69fd4'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-c-criterion-04', 'Calculates the correct final probability.', 1, 'P(X > 18) ≈ 0.026 (2.6%).', 'Recompute 1 minus the cumulative probability at z ≈ 1.94.', '[]'::jsonb),
      ('0ffd570f-9fac-4f28-a801-cef82c67d48b'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-d-criterion-01', 'Recognizes that 22 defective bulbs is far above the mean of 12 (roughly 3 standard deviations away), corresponding to a very small probability under the claimed rate.', 1, 'Response computes or references a z-score around 2.8–3.0 for 22 and notes the resulting probability is very small.', 'Compute how many standard deviations 22 is from the mean of 12 and note this is an unusually large deviation.', '[]'::jsonb),
      ('eaf1e302-d558-4f0d-a2fb-324d09149b8f'::uuid, '1147fd77-60f7-4fb4-a485-e0100e05c21f'::uuid, 'part-d-criterion-02', 'Concludes this provides evidence the true defect rate may be higher than 6%, reasoning informally from the rarity of such an outcome under the stated model (without invoking formal hypothesis-test procedure).', 1, 'Response states that because 22 would be a very unusual result if the true rate were 6%, it suggests the true rate could be higher, using informal reasoning only.', 'State that because this outcome would be very unlikely under the 6% claim, it suggests the true defect rate may be higher, using informal (non-hypothesis-test) reasoning.', '[]'::jsonb);
  end if;

  if exists (
    select 1
    from app.content_items
    where content_key = 'apstats-frq-u12-020'
      and id <> '995aa8dd-b257-4228-a066-a045d75fcb58'::uuid
  ) then
    raise exception 'material_content_key_collision:apstats-frq-u12-020';
  end if;

  if not exists (
    select 1 from app.content_items where id = '995aa8dd-b257-4228-a066-a045d75fcb58'::uuid
  ) then
    insert into app.content_items (
      id, exam_pack_version_id, content_key, item_type, title, status,
      frq_form, practice_format, frq_archetype
    ) values (
      '995aa8dd-b257-4228-a066-a045d75fcb58'::uuid,
      v_epv_id,
      'apstats-frq-u12-020',
      'frq',
      'Shipping Package Weight Comparison',
      'draft',
      'short',
      'targeted_drill',
      'Multi-Focus on Practices 3 and 4'
    );

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, review_status, rubric_type, evaluator_strategy
    ) values (
      'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid,
      '995aa8dd-b257-4228-a066-a045d75fcb58'::uuid,
      1,
      'Shipping Package Weight Comparison: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.',
      'A distribution center recorded the weights (in pounds) of packages shipped from two of its facilities on the same day. Summary statistics are shown in Table 1. After shipment, the center discovered that one South facility package was mistakenly recorded as 40 pounds when its actual weight was 8.0 pounds (a data entry error).

Table 1: Package Weight Summary Statistics
Facility | n | Mean | SD | Min | Q1 | Median | Q3 | Max
North | 40 | 12.4 | 3.1 | 4.0 | 10.2 | 12.0 | 14.5 | 22.0
South | 40 | 12.4 | 3.1 | 2.0 | 10.5 | 12.5 | 14.0 | 40.0',
      '{"content_key":"apstats-frq-u12-020","subject":"ap_statistics","unit":1,"topic":"1.7 Summary Statistics for One Quantitative Variable","archetype":"Multi-Focus on Practices 3 and 4","difficulty":"Very Hard","source_policy":"Original Cramapple authorship; CED structure and scope only.","modules":["stats-precalc-units1-2-frq-2026-08-03"],"parts":[{"part_key":"part-a","prompt":"Using the South facility''s five-number summary, determine whether the recorded maximum value of 40 pounds is an outlier, using the 1.5×IQR rule.","points":3,"criteria":[{"criterion_key":"part-a-criterion-01","points":1},{"criterion_key":"part-a-criterion-02","points":1},{"criterion_key":"part-a-criterion-03","points":1}]},{"part_key":"part-b","prompt":"Explain, without recalculating, whether correcting the error (changing 40 to 8.0 pounds) would increase, decrease, or not change each of the following for the South facility: (i) the mean, (ii) the median, (iii) the standard deviation.","points":3,"criteria":[{"criterion_key":"part-b-criterion-01","points":1},{"criterion_key":"part-b-criterion-02","points":1},{"criterion_key":"part-b-criterion-03","points":1}]},{"part_key":"part-c","prompt":"Assuming the correction described in part B is made, compare the shapes and spreads of the North and South weight distributions, and evaluate whether the two facilities'' package weights are now more or less similar than the original (uncorrected) summary statistics suggested.","points":4,"criteria":[{"criterion_key":"part-c-criterion-01","points":1},{"criterion_key":"part-c-criterion-02","points":1},{"criterion_key":"part-c-criterion-03","points":1},{"criterion_key":"part-c-criterion-04","points":1}]}]}'::jsonb,
      md5('Shipping Package Weight Comparison: Answer all parts. Show your reasoning and calculations clearly, using standard AP notation and justifying any qualitative claims.'),
      'draft',
      'tutor_review_pending',
      'discrete_text',
      'llm_discrete_text'
    );

    insert into app.frq_criteria (
      id, content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    ) values
      ('a9e9b7e1-9a42-4622-a2ed-11056fa0d5c1'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-a-criterion-01', 'Calculates the correct IQR.', 1, 'IQR = 14.0 − 10.5 = 3.5.', 'Recompute Q3 minus Q1 for the South facility.', '[]'::jsonb),
      ('d1ccb8c8-3e88-4e6a-a057-296b2e648e6c'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-a-criterion-02', 'Calculates the correct upper fence.', 1, 'Upper fence = 14.0 + 1.5(3.5) = 19.25.', 'Recompute Q3 + 1.5 × IQR.', '[]'::jsonb),
      ('04a69e57-8854-4f19-ada1-919e4f066992'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-a-criterion-03', 'States the correct conclusion.', 1, '40 > 19.25, so 40 is an outlier.', 'Compare 40 to the computed upper fence and state the conclusion.', '[]'::jsonb),
      ('22080c94-1bf6-4e26-a978-a8e3dd2cd83a'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-b-criterion-01', 'Correctly states the mean would decrease, with reasoning that the mean is affected by every value, and replacing a very high value (40) with a much smaller one (8.0) reduces the sum and thus the mean.', 1, 'Response states "decrease" for the mean and explains via sensitivity to every data value.', 'State that the mean would decrease because it uses every value, and 8.0 is much smaller than the recorded 40.', '[]'::jsonb),
      ('154d55e9-7759-437b-ad47-fc95503eacab'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-b-criterion-02', 'Correctly states the median would stay the same or change very little, reasoning that the median depends only on the position/rank of the middle value(s), and this correction does not change which values occupy the middle of the ordered list.', 1, 'Response states "no change" or "little change" for the median and explains via the median''s dependence on rank rather than magnitude of extreme values.', 'Explain that the median depends on which values are in the middle of the ordered data, not on the size of the extreme value being corrected.', '[]'::jsonb),
      ('f0bd9ef1-3e18-41df-a196-f62cd060ece5'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-b-criterion-03', 'Correctly states the standard deviation would decrease, reasoning that removing the extreme deviation caused by the 40-pound value reduces the overall variability from the mean.', 1, 'Response states "decrease" for the SD and explains via reduced squared deviations from the mean.', 'State that the standard deviation would decrease because the extreme deviation contributed by the 40-pound value is removed.', '[]'::jsonb),
      ('ecd44e58-b65a-4ec4-ad61-a38c12e760d3'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-c-criterion-01', 'Recognizes that after correcting 40 to 8.0, this value is no longer the maximum of the South data (since 8.0 is below the South median of 12.5), so the true corrected maximum is some other, unknown-from-summary value no greater than the prior second-largest observation.', 1, 'Response explicitly notes 8.0 would fall below the median rather than remaining the maximum.', 'Note that after correction, 8.0 lands below the median, so it is not the new maximum; the true maximum is unknown from the summary alone.', '[]'::jsonb),
      ('8ca94d7c-79f0-42de-a4f6-d15d5b04b6d6'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-c-criterion-02', 'Concludes the corrected South distribution is likely much more symmetric (no extreme high outlier), in contrast to North''s shape, which was roughly symmetric already since its mean and median are close.', 1, 'Response compares corrected South shape to North''s shape using the given mean/median values.', 'Compare the corrected South shape (more symmetric without the outlier) to North''s already-symmetric shape.', '[]'::jsonb),
      ('89d16c94-cf3d-45dd-a192-1a63e5a3c40c'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-c-criterion-03', 'Concludes the corrected South spread (SD) would be smaller than North''s SD, so despite the identical originally reported SDs (3.1 each), the facilities are actually less similar in spread than the original statistics suggested.', 1, 'Response explains that the original SD match was an artifact of the data error, and correction reveals a real difference in spread.', 'Explain that the equal original SDs were misleading due to the data error, and the corrected SDs would differ.', '[]'::jsonb),
      ('32e5dce8-7c8a-4c54-a78b-2892a6e2253b'::uuid, 'bf8930cb-0297-4d26-ade7-472b796c88fe'::uuid, 'part-c-criterion-04', 'Notes that the centers (mean/median) of North and South remain fairly similar even after correction, so the facilities remain comparable in typical package weight despite the differing spread/shape.', 1, 'Response distinguishes that center comparability is preserved even though spread comparability is not.', 'State that centers remain similar between facilities even though spread comparisons change after correction.', '[]'::jsonb);
  end if;
end
$stats_precalc_units1_2$;
commit;
