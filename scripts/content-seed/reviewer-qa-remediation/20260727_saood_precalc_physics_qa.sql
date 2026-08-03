-- Apply confirmed content corrections from Muhammad Saood's completed
-- AP Precalculus and Physics review, while preserving every submitted
-- decision and prior content version.
--
-- Production project: pcntajvbdfqhbeewmdry
-- Idempotency: a matching latest stem plus qa_remediation marker is a no-op.

begin;

select pg_advisory_xact_lock(hashtext('cramapple-saood-qa-20260727'));

create temporary table qa_specs (
  content_key text primary key,
  new_stem text not null,
  new_stimulus text,
  new_canonical_answer_1 text,
  prompt_updates jsonb not null default '[]'::jsonb
) on commit drop;

insert into qa_specs
  (content_key, new_stem, new_stimulus, new_canonical_answer_1, prompt_updates)
values
(
  'apprecalc-frq-001',
  $stem$Part A: Find and interpret the average rate of change from x=0 to x=2.

Part B: Find a quadratic matching all four values and verify it by substitution.

Part C: Describe the vertex and symmetry in context of the table.$stem$,
  null, null,
  '[{"index":"0","prompt":"Find and interpret the average rate of change from x=0 to x=2."},{"index":"1","prompt":"Find a quadratic matching all four values and verify it by substitution."}]'
),
(
  'apprecalc-frq-005',
  $stem$Part A: Find the production level that maximizes modeled profit and justify that it is a maximum.

Part B: Find and interpret the maximum profit.

Part C: Identify why using the model at x=30 is an extrapolation, and explain one limitation of that extrapolation.$stem$,
  null, null,
  '[{"index":"0","prompt":"Find the production level that maximizes modeled profit and justify that it is a maximum."},{"index":"2","prompt":"Identify why using the model at x=30 is an extrapolation, and explain one limitation of that extrapolation."}]'
),
(
  'apprecalc-frq-007',
  $stem$Part A: Find D(5) and interpret it.

Part B: Find the boundary time when the excess temperature equals 10°C, and state the interval of times for which it is below 10°C.

Part C: Explain why a linear decrease of 18% of the original 48 each minute would be a different model.$stem$,
  null, null,
  '[{"index":"1","prompt":"Find the boundary time when the excess temperature equals 10°C, and state the interval of times for which it is below 10°C."}]'
),
(
  'apprecalc-frq-008',
  $stem$Part A: Find S(3) and interpret the result in context.

Part B: Solve S(d)=18 and interpret the solution in context.

Part C: Determine the largest distance for which the model remains nonnegative.$stem$,
  null, null,
  '[{"index":"0","prompt":"Find S(3) and interpret the result in context."},{"index":"1","prompt":"Solve S(d)=18 and interpret the solution in context."}]'
),
(
  'apprecalc-frq-009',
  $stem$Part A: Find the amplitude and midline.

Part B: Write a cosine model with its maximum at t=15, and explain how the angular coefficient gives the model's period.

Part C: Find T(9) and interpret.$stem$,
  null, null,
  '[{"index":"1","prompt":"Write a cosine model with its maximum at t=15, and explain how the angular coefficient gives the model''s period."}]'
),
(
  'apprecalc-frq-010',
  $stem$Part A: Write a height model and verify that it has the stated initial height and period.

Part B: Find the first time the rider reaches height 14 meters.

Part C: State the rider's maximum and minimum heights.$stem$,
  null, null,
  '[{"index":"0","prompt":"Write a height model and verify that it has the stated initial height and period."}]'
),
(
  'apprecalc-frq-013',
  $stem$Part A: Factor P completely and state its zeros.

Part B: Solve P(x)≥0 and justify the solution with a sign chart.

Part C: State the y-intercept and end behavior.$stem$,
  null, null,
  '[{"index":"0","prompt":"Factor P completely and state its zeros."},{"index":"1","prompt":"Solve P(x)≥0 and justify the solution with a sign chart."}]'
),
(
  'apprecalc-frq-014',
  $stem$Part A: Solve exactly for x.

Part B: Give a decimal approximation and verify it by substitution in the original equation.

Part C: Explain why there is at most one solution.$stem$,
  null, null,
  '[{"index":"1","prompt":"Give a decimal approximation and verify it by substitution in the original equation."}]'
),
(
  'apprecalc-frq-016',
  $stem$Part A: Convert the equation to Cartesian form.

Part B: Write the Cartesian equation in center-radius form and identify the center and radius.

Part C: Explain why negative r values are not needed to trace this circle once.$stem$,
  null, null,
  '[{"index":"1","prompt":"Write the Cartesian equation in center-radius form and identify the center and radius."}]'
),
(
  'apprecalc-mcq-010',
  $stem$The inverse of f(x)=3e^(2x) is$stem$,
  null, null, '[]'
),
(
  'apphycem-frq-013',
  $stem$Answer all parts of the following question.

(a) At a radius r that lies inside both the original sphere and the enlarged sphere (r<R), predict how the electric field changes when the sphere's radius is doubled from R to 2R while ρ₀ and r are held fixed. Justify the prediction quantitatively.

(b) Use Gauss's law and spherical symmetry to derive the field at the fixed interior radius and explain the scaling found in part (a).$stem$,
  $stimulus$A nonconducting sphere of radius R has volume charge density ρ(r)=ρ₀r/R.$stimulus$,
  $answer$For r<R, Qenc=∫₀ʳ(ρ₀r'/R)4πr'²dr'=πρ₀r⁴/R. Gauss's law gives E(r)=ρ₀r²/(4ε₀R). At the same fixed r, replacing R by 2R gives E'=E/2.$answer$,
  '[]'
),
(
  'apphycem-frq-022',
  $stem$Answer all parts of the following question.

(a) Sketch V(x), U(x), and E_x(x).

(b) Determine the charge's speed at x=L after it is released from rest at x=L/2, and describe the equilibrium at x=0.$stem$,
  $stimulus$Along x, the potential is V(x)=V₀[1−(x/L)²] for |x|≤L, where V₀>0. A positive charge q of mass m is released from rest at x=L/2 and is acted on only by the electric force.$stimulus$,
  $answer$E_x=−dV/dx=2V₀x/L², and U=qV. Energy conservation from x=L/2 to x=L gives (1/2)mv²=q[V(L/2)−V(L)]=3qV₀/4, so v(L)=sqrt(3qV₀/(2m)). Since U has a local maximum at x=0, the equilibrium there is unstable.$answer$,
  '[]'
);

do $$
declare
  s qa_specs%rowtype;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new_id uuid;
  v_prompt jsonb;
  v_update jsonb;
begin
  for s in select * from qa_specs order by content_key loop
    select * into strict v_item
    from app.content_items
    where lower(content_key)=lower(s.content_key);

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
    order by version_num desc
    limit 1
    for update;

    if v_old.stem=s.new_stem
       and v_old.prompt_json->>'qa_remediation'='2026-07-27 Saood QA' then
      continue;
    end if;

    v_prompt := coalesce(v_old.prompt_json,'{}'::jsonb);
    for v_update in select value from jsonb_array_elements(s.prompt_updates) loop
      v_prompt := jsonb_set(
        v_prompt,
        array['parts',v_update->>'index','prompt'],
        to_jsonb(v_update->>'prompt'),
        true
      );
    end loop;
    v_prompt := v_prompt || jsonb_build_object(
      'content_version',v_old.version_num+1,
      'qa_remediation','2026-07-27 Saood QA'
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
      v_item.id,
      v_old.version_num+1,
      s.new_stem,
      coalesce(s.new_stimulus,v_old.stimulus),
      v_prompt,
      v_old.explanation,
      v_old.help_text,
      md5(s.new_stem),
      'draft',
      'f5a26c6b-3566-4d58-9e97-979fbb947564',
      coalesce(s.new_canonical_answer_1,v_old.canonical_answer_1),
      v_old.canonical_answer_2,
      null,
      v_old.rubric_type,
      v_old.evaluator_strategy,
      v_old.stimulus_image_path
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

    -- Correct the two substantive Physics C rubrics.
    if s.content_key='apphycem-frq-013' then
      update app.frq_criteria
      set learner_facing_text='At the same fixed interior radius, derives E(r)=ρ₀r²/(4ε₀R) and concludes that doubling R halves the field.',
          evidence_requirements='E(r)=ρ₀r²/(4ε₀R); fixed r inside both spheres; E''/E=1/2.',
          minimum_fix='Apply Gauss''s law at the same fixed interior radius and compare R with 2R.'
      where content_item_version_id=v_new_id and criterion_key='part-a';

      update app.frq_criteria
      set learner_facing_text='Uses Gauss''s law and spherical symmetry to derive the interior field and explain its inverse dependence on R.',
          evidence_requirements='Qenc=πρ₀r⁴/R and E=ρ₀r²/(4ε₀R), with spherical symmetry.',
          minimum_fix='Integrate the enclosed charge, apply E(4πr²)=Qenc/ε₀, and state the scaling.'
      where content_item_version_id=v_new_id and criterion_key='part-b';
    elsif s.content_key='apphycem-frq-022' then
      update app.frq_criteria
      set learner_facing_text='Uses energy conservation from x=L/2 to x=L to obtain v=sqrt(3qV₀/(2m)).',
          evidence_requirements='(1/2)mv²=q[V(L/2)−V(L)]=3qV₀/4.',
          minimum_fix='Evaluate the potential at both stated endpoints and solve the energy equation for v.'
      where content_item_version_id=v_new_id and criterion_key='b-speed';
    elsif s.content_key='apprecalc-mcq-010' then
      update app.mcq_choices
      set rationale='From y=3e^(2x), divide by 3, take ln, and divide by 2. Because the original exponential has range y>0, the inverse has domain x>0.'
      where content_item_version_id=v_new_id and choice_key='A';

      v_prompt := jsonb_set(
        v_prompt,
        '{parts,0,criteria,0,required_evidence}',
        '["A","From y=3e^(2x), divide by 3, take ln, and divide by 2; the inverse domain is x>0."]'::jsonb,
        true
      );
      update app.content_item_versions
      set prompt_json=v_prompt
      where id=v_new_id;
    end if;

    insert into app.content_review_assignments (
      content_item_version_id, reviewer_id, review_stage, review_kind,
      status, created_by
    ) values (
      v_new_id,
      'cee0cee4-fc59-4084-9a83-b24ccca940b9',
      'tutor_question',
      v_item.item_type,
      'pending',
      'f5a26c6b-3566-4d58-9e97-979fbb947564'
    );
  end loop;
end
$$;

-- Saood's disapprovals of the 16 full-scale Physics FRQs were based on the
-- reviewer UI omitting prompt_json.parts. Preserve those decisions as audit
-- evidence, but undo the automatic "excluded" state. Keep the questions in
-- draft until the reviewer UI renders the complete prompt and a valid human
-- review is performed.
with affected as (
  select v.id,v.content_item_id
  from app.content_item_versions v
  join app.content_items i on i.id=v.content_item_id
  where i.content_key in (
    'apphy1-frq-035','apphy1-frq-036','apphy1-frq-037','apphy1-frq-038',
    'apphy2-frq-035','apphy2-frq-036','apphy2-frq-037','apphy2-frq-038',
    'apphycm-frq-035','apphycm-frq-036','apphycm-frq-037','apphycm-frq-038',
    'apphycem-frq-035','apphycem-frq-036','apphycem-frq-037','apphycem-frq-038'
  )
  and v.version_num=1
)
update app.content_item_versions v
set status='draft', review_status=null
from affected a
where v.id=a.id
  and v.status='reviewed_disapproved';

update app.content_items
set status='draft'
where content_key in (
  'apphy1-frq-035','apphy1-frq-036','apphy1-frq-037','apphy1-frq-038',
  'apphy2-frq-035','apphy2-frq-036','apphy2-frq-037','apphy2-frq-038',
  'apphycm-frq-035','apphycm-frq-036','apphycm-frq-037','apphycm-frq-038',
  'apphycem-frq-035','apphycem-frq-036','apphycem-frq-037','apphycem-frq-038'
)
and status='reviewed_disapproved';

commit;
