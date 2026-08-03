-- Cross-subject QA of tutor_question decisions submitted in the rolling
-- 72-hour window ending 2026-07-27 13:19:11.888384+00.
--
-- Corrections are immutable forks. Submitted decisions and superseded
-- versions remain available as audit evidence.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-72h-reviewer-qa-20260727'));

create temporary table qa_targets (
  content_key text primary key,
  reviewer_id uuid not null
) on commit drop;

insert into qa_targets values
  ('APBIO-FRQ-L-001','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-003','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-005','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-007','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-009','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-025','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-031','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-038','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-FRQ-L-041','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-HDG-2026-GRAPH-004','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-HDG-2026-GRAPH-008','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-HDG-2026-GRAPH-011','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APBIO-HDG-2026-GRAPH-012','af36ebd6-ba8f-48bd-ad58-b3e0fd4914a8'),
  ('APSTAT-MOD4-M004','0a5909f7-f50b-486a-a31f-4fc3cc47e039'),
  ('APSTATS-SFRQ-008','0a5909f7-f50b-486a-a31f-4fc3cc47e039'),
  ('apchem-frq-l-003','806b0a0e-8431-4aa5-ad71-b803a1792145');

do $$
declare
  t qa_targets%rowtype;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new_id uuid;
  v_prompt jsonb;
begin
  for t in select * from qa_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(t.content_key);

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc
    limit 1
    for update;

    if v_old.prompt_json->>'qa_remediation'='2026-07-27 rolling 72h reviewer QA' then
      continue;
    end if;

    v_prompt := coalesce(v_old.prompt_json,'{}'::jsonb) ||
      jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-07-27 rolling 72h reviewer QA'
      );

    update app.content_item_versions
    set status='retired'
    where id=v_old.id and status<>'retired';

    update app.content_items
    set status='draft'
    where id=v_item.id;

    insert into app.content_item_versions (
      content_item_id, version_num, stem, stimulus, prompt_json,
      explanation, help_text, content_hash, status, created_by,
      canonical_answer_1, canonical_answer_2, review_status,
      rubric_type, evaluator_strategy, stimulus_image_path
    ) values (
      v_item.id, v_old.version_num+1, v_old.stem, v_old.stimulus, v_prompt,
      v_old.explanation, v_old.help_text, md5(v_old.stem), 'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      v_old.canonical_answer_1, v_old.canonical_answer_2, null,
      v_old.rubric_type, v_old.evaluator_strategy, v_old.stimulus_image_path
    ) returning id into v_new_id;

    insert into app.mcq_choices (
      content_item_version_id, choice_key, choice_text, is_correct, rationale
    )
    select v_new_id, choice_key, choice_text, is_correct, rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into app.frq_criteria (
      content_item_version_id, criterion_key, learner_facing_text,
      points_possible, evidence_requirements, minimum_fix, accepted_variants
    )
    select v_new_id, criterion_key, learner_facing_text,
           points_possible, evidence_requirements, minimum_fix, accepted_variants
    from app.frq_criteria
    where content_item_version_id=v_old.id;

    if lower(t.content_key)='apbio-frq-l-001' then
      update app.frq_criteria
      set points_possible=case criterion_key
        when 'a' then 2 when 'b' then 3 when 'c' then 2 when 'd' then 2 end
      where content_item_version_id=v_new_id;

    elsif lower(t.content_key)='apbio-frq-l-003' then
      update app.content_item_versions
      set canonical_answer_1=replace(
        replace(canonical_answer_1,
          'Evidence: two unaffected individuals (I-2 unaffected, and II-4 unaffected) each produce affected offspring (II-1/II-3 from I-1×I-2; III-2 from II-3×II-4), which can only occur if the trait is recessive and the unaffected parent is a heterozygous carrier.',
          'Evidence: the affected mother I-1 and unaffected father I-2 have both affected and unaffected children, consistent with aa × Aa; affected II-3 and unaffected known-carrier II-4 likewise produce both phenotypes.'),
        'I-2 (unaffected, must be a carrier since she and affected I-1 produced affected children)',
        'I-2 (unaffected father, must be a carrier because he and affected I-1 produced affected children)')
      where id=v_new_id;

      update app.frq_criteria
      set evidence_requirements=
        'Mode: autosomal recessive. I-1 is affected (aa) and I-2 is unaffected but must be a carrier (Aa), producing both affected and unaffected children of both sexes. X-linked recessive is excluded because an affected mother and unaffected father would produce all affected sons, yet II-4 and II-5 are unaffected. Genotypes: I-1=aa, I-2=Aa, II-3=aa, II-4=Aa.',
          minimum_fix=
        'Autosomal recessive; I-1=aa, I-2=Aa, II-3=aa, II-4=Aa, with pedigree evidence and exclusion of X-linked recessive.'
      where content_item_version_id=v_new_id and criterion_key='a';

    elsif lower(t.content_key)='apbio-frq-l-005' then
      update app.frq_criteria
      set points_possible=case criterion_key
        when 'a' then 2 when 'b' then 2 when 'c' then 3 when 'd' then 2 end
      where content_item_version_id=v_new_id;

    elsif lower(t.content_key)='apbio-frq-l-007' then
      update app.content_item_versions
      set stem=replace(stem,'In 1975, a survey','In 1976, a survey'),
          content_hash=md5(replace(stem,'In 1975, a survey','In 1976, a survey'))
      where id=v_new_id;

    elsif lower(t.content_key)='apbio-frq-l-009' then
      update app.content_item_versions
      set stem=replace(stem,'Using the food web diagram and biomass data provided:',
                            'Using the food web diagram and annual net production data provided:'),
          content_hash=md5(replace(stem,'Using the food web diagram and biomass data provided:',
                                        'Using the food web diagram and annual net production data provided:'))
      where id=v_new_id;

      update app.frq_criteria
      set points_possible=case criterion_key
        when 'a' then 3 when 'b' then 2 when 'c' then 2 when 'd' then 2 end
      where content_item_version_id=v_new_id;

      update app.frq_criteria
      set evidence_requirements=
        'Trace atmospheric N2 through nitrogen fixation by nitrogen-fixing bacteria to NH3/NH4+, nitrification by nitrifying bacteria to NO2- and then NO3-, root uptake and nitrate reduction/assimilation to NH4+, and incorporation into amino acids and plant protein.'
      where content_item_version_id=v_new_id and criterion_key='b';

    elsif lower(t.content_key)='apbio-frq-l-025' then
      update app.content_item_versions
      set stimulus=replace(stimulus,'Human–Gorilla        |       2.1%',
                                    'Human–Gorilla        |       4.0%'),
          canonical_answer_1=replace(
            replace(canonical_answer_1,
              'Human-Gorilla divergence of 2.1% times 2 Mya per percent equals approximately 4.2 million years ago.',
              'Human-Gorilla divergence of 4.0% times 2 Mya per percent equals approximately 8.0 million years ago.'),
            '2.1% × 2 Mya/% = 4.2 Mya','4.0% × 2 Mya/% = 8.0 Mya')
      where id=v_new_id;

      update app.frq_criteria
      set evidence_requirements=replace(
        replace(evidence_requirements,'2.1%','4.0%'),'4.2 Mya','8.0 Mya')
      where content_item_version_id=v_new_id and criterion_key='b';

    elsif lower(t.content_key)='apbio-frq-l-031' then
      update app.frq_criteria
      set points_possible=case criterion_key
        when 'a' then 2 when 'b' then 2 when 'c' then 2 when 'd' then 3 end
      where content_item_version_id=v_new_id;

    elsif lower(t.content_key)='apbio-frq-l-038' then
      update app.content_item_versions
      set stimulus=replace(stimulus,'1 vs 2             | 45',
                                    '1 vs 2             | 47'),
          canonical_answer_1=replace(
            replace(canonical_answer_1,'(45, 48, 50)','(47, 48, 50)'),
            '(45,48)','(47,48)')
      where id=v_new_id;

      update app.frq_criteria
      set evidence_requirements=replace(
        replace(evidence_requirements,'(45,48)','(47,48)'),'45,48','47,48')
      where content_item_version_id=v_new_id;

    elsif lower(t.content_key)='apbio-frq-l-041' then
      update app.content_item_versions
      set canonical_answer_1 =
        '(a)' || split_part(v_old.canonical_answer_1,E'\n\n(d)',2) ||
        E'\n\n(b)' || split_part(split_part(v_old.canonical_answer_1,E'\n\n(b)',1),'(a)',2) ||
        E'\n\n(c)' || split_part(split_part(v_old.canonical_answer_1,E'\n\n(c)',1),E'\n\n(b)',2) ||
        E'\n\n(d)' || split_part(split_part(v_old.canonical_answer_1,E'\n\n(d)',1),E'\n\n(c)',2)
      where id=v_new_id;

      update app.frq_criteria set
        learner_facing_text=case criterion_key
          when 'a' then 'Propose a mechanism for early dominance by a few species and explain their later replacement.'
          when 'b' then 'Calculate Simpson''s Diversity Index for at least one plot and identify the most diverse plot.'
          when 'c' then 'Describe the diversity trend from Plot A to Plot C and explain it using succession.'
          when 'd' then 'Explain why species richness alone can be misleading, using the plot data.'
        end,
        evidence_requirements=case criterion_key
          when 'a' then 'Early dominance is explained by rapid colonization, growth, dispersal, or priority effects. Later replacement is explained by environmental modification, facilitation/inhibition, shading, resource competition, or establishment of later-successional species.'
          when 'b' then 'Correctly applies D=1-sum(pi^2) to at least one plot (for example, Plot A=0.265 or Plot C=0.8736) and identifies Plot C as having the highest diversity.'
          when 'c' then 'Diversity and evenness increase from Plot A to Plot C as succession proceeds; explanation connects community assembly and changing habitat or species interactions to the trend.'
          when 'd' then 'Richness ignores evenness. Uses the strong dominance in Plot A (85/10/5) versus the even distribution in Plot C to explain why richness alone is incomplete.'
        end,
        minimum_fix=case criterion_key
          when 'a' then 'Explain both early dominance and later replacement with a biologically valid succession mechanism.'
          when 'b' then 'Show a correct Simpson''s-index calculation and identify Plot C as highest.'
          when 'c' then 'State the increasing-diversity trend and connect it to ecological succession.'
          when 'd' then 'Explain that richness omits evenness and use the supplied data.'
        end
      where content_item_version_id=v_new_id;

    elsif lower(t.content_key)='apbio-hdg-2026-graph-004' then
      update app.content_item_versions
      set prompt_json=jsonb_set(
            jsonb_set(prompt_json,'{stimulus}',to_jsonb(stimulus),true),
            '{stimulus_table}',
            '[{"Habitat":"Woodland","Banded":15,"Unbanded":85},{"Habitat":"Grassland","Banded":70,"Unbanded":30}]'::jsonb,
            true)
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text='Banded/unbanded segments and habitats are identifiable.',
          evidence_requirements=replace(evidence_requirements,'Shell-color segments','Banded/unbanded segments'),
          minimum_fix=replace(minimum_fix,'shell-color segments','banded/unbanded segments')
      where content_item_version_id=v_new_id and criterion_key='CATEGORY_LABELS';

    elsif lower(t.content_key)='apbio-hdg-2026-graph-008' then
      update app.content_item_versions
      set stimulus=replace(stimulus,'and describe the shape of the distribution.',
                                    'and describe the shape and noteworthy features of the distribution.'),
          prompt_json=jsonb_set(
            jsonb_set(prompt_json,'{stimulus}',
              to_jsonb(replace(stimulus,'and describe the shape of the distribution.',
                                       'and describe the shape and noteworthy features of the distribution.')),true),
            '{stimulus_table}',
            '[{"Days to germinate":2,"Number of seeds":3},{"Days to germinate":3,"Number of seeds":5},{"Days to germinate":4,"Number of seeds":6},{"Days to germinate":5,"Number of seeds":4},{"Days to germinate":6,"Number of seeds":2},{"Days to germinate":7,"Number of seeds":1},{"Days to germinate":8,"Number of seeds":1},{"Days to germinate":9,"Number of seeds":1}]'::jsonb,
            true)
      where id=v_new_id;

      update app.frq_criteria
      set criterion_key='TAIL_DESCRIPTION',
          learner_facing_text='Notes the sparse right tail from 7 through 9 days without requiring 9 days to be classified as an outlier.',
          evidence_requirements='Earns for recognizing that the low-frequency values from 7 through 9 days form a sparse right tail. Do not require or reward an unsupported formal outlier claim.',
          minimum_fix='Describe the sparse right tail from 7 through 9 days.'
      where content_item_version_id=v_new_id and criterion_key='OUTLIER_NOTE';

    elsif lower(t.content_key)='apbio-hdg-2026-graph-011' then
      update app.content_item_versions
      set prompt_json=jsonb_set(
            jsonb_set(prompt_json,'{stimulus}',to_jsonb(stimulus),true),
            '{stimulus_table}',
            '[{"Week":0,"Population (thousands)":8},{"Week":2,"Population (thousands)":20},{"Week":4,"Population (thousands)":55},{"Week":5,"Population (thousands)":78},{"Week":6,"Population (thousands)":100},{"Week":8,"Population (thousands)":135},{"Week":10,"Population (thousands)":150},{"Week":12,"Population (thousands)":155},{"Week":14,"Population (thousands)":156}]'::jsonb,
            true)
      where id=v_new_id;

      update app.frq_criteria
      set criterion_key='VALUE_ESTIMATE'
      where content_item_version_id=v_new_id and criterion_key='PROBABILITY_ESTIMATE';

    elsif lower(t.content_key)='apbio-hdg-2026-graph-012' then
      update app.content_item_versions
      set stimulus=prompt_json->>'stimulus'
      where id=v_new_id;

      update app.frq_criteria
      set criterion_key='PEAK_ACTIVITY_ESTIMATE'
      where content_item_version_id=v_new_id and criterion_key='PROBABILITY_ESTIMATE';

    elsif lower(t.content_key)='apstat-mod4-m004' then
      update app.content_item_versions
      set stem=replace(stem,'moderately close to a line','moderately close to a linear trend'),
          content_hash=md5(replace(stem,'moderately close to a line','moderately close to a linear trend'))
      where id=v_new_id;

    elsif lower(t.content_key)='apstats-sfrq-008' then
      update app.content_item_versions
      set stimulus=
        'A school fundraiser sells a raffle ticket with the following payoff X: with probability 0.10 the buyer wins 10 dollars, with probability 0.20 the buyer wins 2 dollars, and with probability 0.70 the buyer loses 4 dollars. The payoff is the buyer''s net gain in dollars.',
          canonical_answer_1=
        'a1) Computes the expected value as -1.40 dollars. b1) Computes the standard deviation as about 4.48 dollars. c1) Explains that the long-run average net gain per ticket is -1.40 dollars for the buyer (equivalently, an average gain of 1.40 dollars for the fundraiser). d1) Explains that expected value describes many repetitions, not the outcome of one ticket purchase.',
          prompt_json=jsonb_set(
            jsonb_set(prompt_json,'{stimulus}',
              to_jsonb('A school fundraiser sells a raffle ticket with the following payoff X: with probability 0.10 the buyer wins 10 dollars, with probability 0.20 the buyer wins 2 dollars, and with probability 0.70 the buyer loses 4 dollars. The payoff is the buyer''s net gain in dollars.'::text),true),
            '{notes}',
            to_jsonb('QA fix 2026-07-27: probabilities revised so the fundraiser has positive expected proceeds. Buyer E[X]=-1.40 and SD≈4.48.'::text),
            true)
      where id=v_new_id;

      update app.frq_criteria set
        learner_facing_text=case criterion_key
          when 'a1' then 'Computes the expected value as -1.40 dollars.'
          when 'b1' then 'Computes the standard deviation as about 4.48 dollars.'
          when 'c1' then 'Explains that the long-run average net gain is -1.40 dollars per ticket for the buyer.'
          else learner_facing_text end,
        evidence_requirements=case criterion_key
          when 'a1' then 'E[X]=0.10(10)+0.20(2)+0.70(-4)=-1.40 dollars.'
          when 'b1' then 'SD=sqrt(0.10(10+1.4)^2+0.20(2+1.4)^2+0.70(-4+1.4)^2)≈4.48 dollars.'
          when 'c1' then 'Interprets -1.40 dollars as the buyer''s long-run mean net gain per ticket, or equivalently a 1.40-dollar mean gain for the fundraiser.'
          else evidence_requirements end,
        minimum_fix=case criterion_key
          when 'a1' then 'Compute E[X]=-1.40 dollars.'
          when 'b1' then 'Compute SD≈4.48 dollars.'
          when 'c1' then 'Interpret -1.40 dollars as the buyer''s long-run average net gain per ticket.'
          else minimum_fix end
      where content_item_version_id=v_new_id;

    elsif lower(t.content_key)='apchem-frq-l-003' then
      update app.content_item_versions
      set canonical_answer_1=
        'n=PV/RT=(0.950 atm)(1.80 L)/[(0.08206 L·atm·mol^-1·K^-1)(298 K)]=0.0699 mol. At high pressure, intermolecular attractions can make the measured pressure lower than the ideal-gas prediction (Z<1), so using n=PV/RT gives a value that is too low compared with the true amount.',
          stem=replace(stem,
            'State one boundary case (e.g., high pressure where attractive forces dominate) and predict whether the moles calculated from the ideal gas law would be too high or too low compared to the true value.',
            'State one boundary case (e.g., a pressure range where attractive forces dominate) and predict whether the moles calculated from the ideal gas law would be too high or too low compared with the true value.')
      where id=v_new_id;

      update app.frq_criteria
      set learner_facing_text='When attractive forces dominate (Z<1), the ideal-gas calculation gives too few moles compared with the true amount.',
          evidence_requirements='1pt: states a boundary case where attractions dominate. 1pt: correctly predicts calculated moles are too low. 1pt: justifies that attractions reduce measured pressure relative to the ideal prediction, so n_ideal=PV/RT<n_true.',
          minimum_fix='State that when attractions dominate (Z<1), using PV/RT makes the calculated moles too low.'
      where content_item_version_id=v_new_id and criterion_key='part-d';
    end if;

    -- Keep duplicated prompt criteria synchronized with the authoritative
    -- relational rubric after every correction.
    if exists (
      select 1 from app.frq_criteria where content_item_version_id=v_new_id
    ) then
      select jsonb_set(
        coalesce(prompt_json,'{}'::jsonb),
        '{criteria}',
        coalesce((
          select jsonb_agg(jsonb_build_object(
            'criterion_key',criterion_key,
            'points_possible',points_possible,
            'learner_facing_text',learner_facing_text
          ) order by criterion_key)
          from app.frq_criteria where content_item_version_id=v_new_id
        ),'[]'::jsonb),
        true
      ) into v_prompt
      from app.content_item_versions where id=v_new_id;

      update app.content_item_versions
      set prompt_json=v_prompt
      where id=v_new_id;
    end if;

    insert into app.content_review_assignments (
      content_item_version_id, reviewer_id, review_stage, review_kind,
      status, created_by
    ) values (
      v_new_id, t.reviewer_id, 'tutor_question', v_item.item_type,
      'pending', 'f5a26c6b-3566-4d58-9e97-979fbb947564'
    );
  end loop;
end
$$;

-- APBIO-FRQ-L-018 is a confirmed three-way splice and cannot be answered or
-- scored coherently. Retire it rather than manufacturing a new question.
update app.content_review_assignments a
set status='skipped'
from app.content_item_versions civ
join app.content_items ci on ci.id=civ.content_item_id
where a.content_item_version_id=civ.id
  and lower(ci.content_key)='apbio-frq-l-018'
  and a.status in ('pending','in_progress');

update app.content_item_versions civ
set status='retired', review_status=null
from app.content_items ci
where ci.id=civ.content_item_id
  and lower(ci.content_key)='apbio-frq-l-018'
  and civ.status<>'retired';

update app.content_items
set status='retired'
where lower(content_key)='apbio-frq-l-018'
  and status<>'retired';

commit;
