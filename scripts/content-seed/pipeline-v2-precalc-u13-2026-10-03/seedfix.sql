begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u13-seedfix-20261003'));
create temporary table fixes (content_key text, choice_key text, new_rationale text) on commit drop;
insert into fixes values
('apprecalc-mcq-004','A','A graph cannot cross the x-axis at a zero of even multiplicity. At −1 (multiplicity 2) it touches the axis and turns around, so crossing at both zeros is impossible; only the odd-multiplicity zero at 3 produces a crossing.'),
('apprecalc-mcq-006','A','2x²+2 comes from substituting f into g correctly but then squaring only part of the input: (2x−1)² is written as 2x²−1 (the exponent applied to x alone, not to 2x−1), and adding 3 gives 2x²−1+3 = 2x²+2. The correct square is (2x−1)² = 4x²−4x+1.'),
('apprecalc-mcq-007','B','A horizontal end behavior of 1 would come from the equal-degree rule (ratio of leading coefficients 1/1), but that rule applies only when numerator and denominator have the same degree. Here the numerator (x−1)²(x+2) = x³−3x+2 has degree 3 and the denominator x²+1 has degree 2, and Q(x) = x + (−4x+2)/(x²+1), so the outputs grow like x rather than leveling off at 1.'),
('apprecalc-mcq-026','C','C swaps the roles of the constants: g shifts right 3 and up 5, but C shifts right 5 and down 3. It also uses a vertical shrink by 1/2 instead of the stretch by 2 and leaves out the reflection across the x-axis that the negative sign in −2 produces.'),
('apprecalc-mcq-026','D','D keeps the vertical stretch by 2, which is correct, but gets the rest wrong: x−3 shifts right 3 (not left 5), +5 shifts up 5 (not up 3), and the negative sign in −2 reflects across the x-axis (a reflection across the y-axis would require f(−x)).'),
('apprecalc-mcq-029','B','(−∞,−2)∪[1,∞) is the solution of (x−1)/(x+2) ≥ 0, not ≤ 0. For x<−2 and x>1 the numerator and denominator have the same sign, so the quotient is positive, and at x=1 it equals 0. This answer comes from choosing the wrong sign intervals for the inequality.'),
('apprecalc-mcq-030','A','0.64 is not the predicted change. The change is y(3.1) − y(2.4) = 4.32922 − 4.09808 = 0.23114 ≈ 0.23, and 0.64 also does not match the average rate of change over the interval (0.330 per unit of x).'),
('apprecalc-mcq-030','C','1.29 is not y(3.1) − y(2.4). The outputs are y(2.4) ≈ 4.098 and y(3.1) ≈ 4.329, and even after rounding them to 4.10 and 4.33 the difference is 0.23, so no subtraction of these outputs gives 1.29.'),
('apprecalc-mcq-030','D','3.43 is not a combination of the two outputs: their sum is 4.098 + 4.329 ≈ 8.43 and their difference is ≈ 0.23. The question asks for the difference (the change in y), which is 0.23.'),
('apprecalc-mcq-031','B','24.0 comes from multiplying the output change by the interval length instead of dividing: f(2.7) − f(1.2) = 15.9705 and 15.9705 × 1.5 ≈ 23.96 ≈ 24.0. The average rate of change divides by Δx = 1.5, giving 15.9705/1.5 ≈ 10.6.'),
('apprecalc-mcq-034','A','x=3 comes from setting x² equal to 3² = 9, losing the −1 from (x−1)(x+1) = x²−1. The correct equation is x²−1 = 9, so x²=10. Check: log₃(2)+log₃(4) = log₃(8), not 2.'),
('apprecalc-mcq-034','D','The equation correctly reduces to x²−1 = 9, so x²=10, but x=10 drops the square instead of taking the square root. Check: log₃(9)+log₃(11) = log₃(99), not 2.'),
('apprecalc-mcq-035','B','4^(x+2)−1 is f with the signs of both shifts reversed, but it is still an exponential function, so it is not the inverse of f (the inverse of an exponential is a logarithm). Check: f(2) = 2 but 4^(2+2)−1 = 255, so applying it to f''s output does not return 2.'),
('apprecalc-mcq-035','D','log_(1/4)(x−1)+2 uses the reciprocal base, and log_(1/4)(u) = −log₄(u), so D equals −log₄(x−1)+2, which reflects the correct inverse about y=2. Check: f(3) = 5, but D(5) = log_(1/4)(4)+2 = 1, not 3.'),
('apprecalc-mcq-036','A','(x²+1)²−5 mixes the two functions rather than composing them: it squares g(x) = x²+1 itself and then subtracts 5 as f does. It is neither (g∘f)(x) = (2x−5)²+1 nor (f∘g)(x) = 2(x²+1)−5 = 2x²−3.'),
('apprecalc-mcq-036','B','In (2x−4)²+1 the expression inside the square is 2x−4 = (2x−5)+1, so g''s constant +1 has been added to f(x) before squaring as well as after. The correct inside is just f(x) = 2x−5.'),
('apprecalc-mcq-040','A','8.4 does not solve the equation: ln(x) = (12−4.8)/2.3 ≈ 3.13, and substituting x=8.4 gives y = 4.8+2.3ln(8.4) ≈ 9.69, not 12. Taking 3.13 itself as x would also be wrong; x = e^3.13.'),
('apprecalc-mcq-040','B','15.2 does not solve the equation: substituting x=15.2 gives y = 4.8+2.3ln(15.2) ≈ 11.06, not 12. Undoing ln with base 10 is also wrong (10^3.13 ≈ 1350); the inverse of ln is e^(·).'),
('apprecalc-mcq-040','C','31.7 does not solve the equation: substituting x=31.7 gives y = 4.8+2.3ln(31.7) ≈ 12.75, not 12. Exponentiating 12/2.3 before isolating ln(x) is also wrong (e^(12/2.3) ≈ 184); the constant 4.8 must be subtracted first.'),
('apprecalc-mcq-041','B','−1/2 has the right sign (cosine is negative in quadrant II) but the wrong magnitude: it uses the sine reference value 1/2 for the reference angle π/6 instead of the cosine reference value √3/2.'),
('apprecalc-mcq-041','C','1/2 is exactly sin(5π/6), so this is the value of the wrong function (sine, which is positive in quadrant II). Cosine of 5π/6 is negative and has magnitude √3/2.'),
('apprecalc-mcq-047','A','cos x is a different function from the result. The Pythagorean identity gives 1−cos²x = sin²x, so the quotient is sin²x/sin x = sin x. For example at x = π/6 the expression equals 1/2, while cos(π/6) = √3/2.'),
('apprecalc-mcq-049','B','B describes the circle r = 4cosθ, i.e. (x−2)²+y² = 4, which passes through the pole and touches the line θ = π/2 there. It is not the graph of r = 2+2cosθ: at θ = π/2 that curve gives the point (0,2), which is not on the circle (and r = 2+2cosθ is a cardioid, not a circle).'),
('apprecalc-mcq-049','D','D has a cardioid, but the symmetry and cusp are wrong for r = 2+2cosθ. Because cos(−θ) = cosθ, the graph is symmetric about the polar axis, not about θ = π/2 (that symmetry belongs to r = 2+2sinθ). Either cardioid has its cusp at the pole (here r = 0 at θ = π), so a cusp ''above the pole'' is not correct.'),
('apprecalc-mcq-np2-009','B','A degree-2 polynomial has constant second differences at equally spaced inputs. The second differences here are not constant, so the data cannot come from a quadratic, which rules out degree 2.');
create temporary table prov (content_key text primary key, mu int, req int[]) on commit drop;
insert into prov values ('apprecalc-mcq-014',2,'{1,2}'::int[]),('apprecalc-mcq-022',1,'{1}'::int[]),('apprecalc-mcq-023',1,'{1}'::int[]),('apprecalc-mcq-024',1,'{1}'::int[]),('apprecalc-mcq-025',1,'{1}'::int[]),('apprecalc-mcq-027',1,'{1}'::int[]),('apprecalc-mcq-029',1,'{1}'::int[]),('apprecalc-mcq-032',2,'{2}'::int[]),('apprecalc-mcq-034',2,'{2}'::int[]),('apprecalc-mcq-035',2,'{2}'::int[]),('apprecalc-mcq-037',2,'{1,2}'::int[]),('apprecalc-mcq-041',3,'{3}'::int[]),('apprecalc-mcq-043',3,'{3}'::int[]),('apprecalc-mcq-047',3,'{3}'::int[]),('apprecalc-mcq-049',3,'{3}'::int[]),('apprecalc-mcq-np2-001',1,'{1}'::int[]),('apprecalc-mcq-np2-002',1,'{1}'::int[]),('apprecalc-mcq-np2-005',2,'{2}'::int[]),('apprecalc-mcq-np2-006',3,'{3}'::int[]),('apprecalc-mcq-np2-007',3,'{3}'::int[]),('apprecalc-mcq-np2-008',3,'{3}'::int[]),('apprecalc-mcq-np2-009',1,'{1}'::int[]),('apprecalc-mcq-np2-010',3,'{3}'::int[]);
create temporary table tcv (content_key text primary key, topic text) on commit drop;
insert into tcv values ('apprecalc-mcq-001','1.2'),('apprecalc-mcq-002','1.6'),('apprecalc-mcq-003','1.10'),('apprecalc-mcq-004','1.5'),('apprecalc-mcq-005','1.13'),('apprecalc-mcq-006','2.7'),('apprecalc-mcq-007','1.7'),('apprecalc-mcq-008','2.5'),('apprecalc-mcq-009','2.13'),('apprecalc-mcq-010','2.10'),('apprecalc-mcq-011','2.13'),('apprecalc-mcq-012','2.6'),('apprecalc-mcq-013','2.5'),('apprecalc-mcq-014','2.11'),('apprecalc-mcq-016','3.5'),('apprecalc-mcq-017','3.10'),('apprecalc-mcq-018','3.9'),('apprecalc-mcq-019','3.13'),('apprecalc-mcq-020','3.14'),('apprecalc-mcq-022','1.5'),('apprecalc-mcq-023','1.6'),('apprecalc-mcq-024','1.9'),('apprecalc-mcq-025','1.10'),('apprecalc-mcq-026','1.12'),('apprecalc-mcq-028','1.5'),('apprecalc-mcq-029','1.8'),('apprecalc-mcq-030','1.14'),('apprecalc-mcq-032','2.3'),('apprecalc-mcq-034','2.13'),('apprecalc-mcq-035','2.10'),('apprecalc-mcq-036','2.7'),('apprecalc-mcq-038','2.15'),('apprecalc-mcq-041','3.3'),('apprecalc-mcq-043','3.6'),('apprecalc-mcq-045','3.7'),('apprecalc-mcq-047','3.12'),('apprecalc-mcq-049','3.14'),('apprecalc-mcq-np2-001','1.6'),('apprecalc-mcq-np2-002','1.10'),('apprecalc-mcq-np2-005','2.13'),('apprecalc-mcq-np2-006','3.5'),('apprecalc-mcq-np2-007','3.3'),('apprecalc-mcq-np2-008','3.13'),('apprecalc-mcq-np2-009','1.4'),('apprecalc-mcq-np2-010','3.11');
create temporary table mod on commit drop as
select ci.content_key from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.item_type='mcq' and ci.status='published'
and ci.content_key not in ('apprecalc-mcq-033','apprecalc-mcq-np2-003','apprecalc-mcq-np2-004')
and (civ.stem ~ E'\\n\\s*A[\\.\\)]\\s' or ci.content_key in (select content_key from fixes));
do $$ begin if (select count(*) from mod)<>26 then raise exception 'expected 26 items to modify, got %',(select count(*) from mod); end if; end $$;
create temporary table changed (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null, was_validated boolean not null) on commit drop;
do $$
declare t record; v_item app.content_items%rowtype; v_old app.content_item_versions%rowtype; v_new uuid; v_stem text; v_lab text; bad int; v_hits int; e record;
begin
  for t in select * from mod order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='mcq' and exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and status='published' for update;
    select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;
    v_stem := v_old.stem;
    if v_old.stem ~ E'\\n\\s*A[\\.\\)]\\s' then
      select count(*) into bad from app.mcq_choices m where m.content_item_version_id=v_old.id and position(m.choice_text in v_old.stem)=0;
      if bad<>0 then raise exception '% has choices not in the stem', t.content_key; end if;
      v_stem := rtrim(regexp_replace(v_old.stem, E'\\n\\s*A[\\.\\)]\\s[\\s\\S]*$', ''));
      if length(v_stem)<12 then raise exception '% stem too short after strip: %', t.content_key, v_stem; end if;
    end if;
    select label_status into v_lab from app.content_taxonomy_labels where content_item_id=v_item.id and label_scope='serving' and superseded_by is null limit 1;
    v_new := gen_random_uuid();
    update app.content_review_assignments set status='skipped' where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;
    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,v_item.id,v_old.version_num+1,v_stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,'qa_remediation','2026-10-03 Precalculus Units 1-3 audit: wrong-answer rationales corrected and/or duplicated A-D list removed from the stem (APPROVAL-0091)','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(v_stem),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);
    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale) select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;
    for e in select * from fixes where content_key=t.content_key loop
      update app.mcq_choices set rationale=e.new_rationale where content_item_version_id=v_new and choice_key=e.choice_key;
      get diagnostics v_hits = row_count;
      if v_hits<>1 then raise exception 'fix for % choice % matched % rows', t.content_key, e.choice_key, v_hits; end if;
    end loop;
    insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
      select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
    insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
      select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by from app.content_item_difficulty where content_item_version_id=v_old.id;
    insert into changed values (t.content_key,v_old.id,v_new,coalesce(v_lab='validated',false));
  end loop;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) from changed r where civ.id=r.new_version_id;
insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from changed;
insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
  'Owner-approved repair 2026-10-03 (Precalculus Units 1-3 audit): wrong-answer rationales corrected (two-checker re-audit clean) and/or the duplicated A-D list removed from the stem; keys and choice texts unchanged. ' || r.content_key,'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_and_stem_repair','content_key',r.content_key,'qa_date','2026-10-03'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apprecalc-u13-seedfix-20261003'),'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from changed r join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from changed r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now() from changed r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
-- new validated serving labels: (a) changed items that were validated (carry forward), (b) provisional items validated by the three-family consensus
create temporary table tgt on commit drop as
select ci.content_key, ci.id item_id, civ.id version_id, l.content_taxonomy_label_id old_label, l.label_version old_ver, l.label_status old_status, l.taxonomy_source_version tsv,
  coalesce(p.req, l.required_units) req, coalesce(p.mu, l.max_required_unit) mu, coalesce(p.mu, l.primary_unit) pu, l.assessed_topics, gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
left join prov p on p.content_key=ci.content_key
where ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.item_type='mcq' and ci.status='published'
and (p.content_key is not null or (ci.content_key in (select content_key from changed where was_validated)));
do $$ begin if (select count(*) from tgt)<>(select count(*) from (select content_key from prov union select content_key from changed where was_validated) u) then raise exception 'label target count mismatch: %', (select count(*) from tgt); end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id,content_item_id,label_version,label_scope,required_units,max_required_unit,primary_unit,assessed_topics,taxonomy_source_version,taxonomy_confidence,label_status,source,source_payload,model_run_id,created_by)
select new_label_id,item_id,old_ver+1,'serving',req,(select max(u) from unnest(req) u),pu,coalesce(assessed_topics,array[]::text[]),tsv,'provisional','provisional_model','apprecalc_u13_pipeline_2026_10_03',
 jsonb_build_object('origin','three_family_blind_probe_or_carry_forward','note','unit from the three-family consensus (>= 5 of 6 on the max unit) or carried forward after a rationale/stem repair','supersedes_status',old_status),'apprecalc-u13-pipeline-2026-10-03','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id,content_taxonomy_label_id,decided_by,decision,decision_source,reviewed_primary_unit,reviewed_required_units,notes)
select vd_id,new_label_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'confirmed','automated_spot_check',pu,req,'Product Owner chat instruction 2026-10-03 (continue: Precalculus Units 1-3; APPROVAL-0091). Three-family blind consensus or carry-forward after repair.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
-- primary topic cells (three-family consensus >= 5 of 6) on the published versions
create temporary table tc on commit drop as
select v.*, ci.id item_id, civ.id version_id from tcv v join app.content_items ci on ci.content_key=v.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published';
do $$ begin
 if (select count(*) from tc)<>45 then raise exception 'expected 45 topic targets, got %', (select count(*) from tc);end if;
 if exists (select 1 from tc join app.content_item_cells c on c.content_item_version_id=tc.version_id and c.is_primary and c.superseded_by is null) then raise exception 'a topic target already has a primary cell'; end if;
end $$;
insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
select version_id,item_id,'16383753-6775-430d-960a-544cd6ee0972'::uuid,topic,null,true,'validated','apprecalc_topic_probe_2026_10_03','apprecalc-topic-probe-2026-10-03 (gemini-3.8-flash + deepseek-v4-pro + gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6)',null,now(),gen_random_uuid() from tc;
do $$ declare n int; begin
  select count(*) into n from changed; if n<>26 then raise exception 'expected 26 changed, got %', n; end if;
  select count(*) into n from changed r join app.mcq_choices o on o.content_item_version_id=r.old_version_id join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key where w.is_correct<>o.is_correct or w.choice_text<>o.choice_text; if n<>0 then raise exception 'a choice text or key changed'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>(select count(*) from tgt) then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_versions v join changed r on r.new_version_id=v.id where v.stem ~ E'\\n\\s*A[\\.\\)]\\s'; if n<>0 then raise exception 'a stem still has a list'; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
end $$;
select (select count(*) from changed) versions_changed, (select count(*) from tgt) labels_written, (select count(*) from tgt where old_status<>'validated') provisional_validated, (select count(*) from tc) topic_cells;
ROLLBACK_OR_COMMIT;
