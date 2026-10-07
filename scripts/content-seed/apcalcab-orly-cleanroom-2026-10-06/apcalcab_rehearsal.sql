begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-orly-cleanroom-publish-20261006'));
do $$ begin
  if exists (select 1 from app.content_items where content_key = any (array['apcalcab-mcq-orly-c1-v1','apcalcab-mcq-orly-c1-v2','apcalcab-mcq-orly-c1-v3','apcalcab-mcq-orly-c2-v1','apcalcab-mcq-orly-c2-v2','apcalcab-mcq-orly-c2-v3'])) then raise exception 'already loaded'; end if;
end $$;
-- apcalcab-mcq-orly-c1-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-orly-c1-v1', 'mcq', 'Average rate of a sine function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = sin(2x). What is the average rate of change of f on the interval [0, π/4]?', null, '{}'::jsonb, md5('apcalcab-mcq-orly-c1-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '2√2/π', false, 'Dropped the coefficient inside the argument: using sin(π/4) - sin(0) = √2/2 instead of sin(2·π/4) - sin(0), then dividing by π/4, gives 2√2/π.' from version_ins
union all select gen_random_uuid(), id, 'B', '4/π', true, 'Average rate of change = (f(π/4) - f(0))/(π/4 - 0) = (sin(π/2) - sin(0))/(π/4) = (1 - 0)/(π/4) = 4/π.' from version_ins
union all select gen_random_uuid(), id, 'C', '1', false, 'Did not divide by the interval length: f(π/4) - f(0) = 1 - 0 = 1 is the change in f, not its average rate of change.' from version_ins
union all select gen_random_uuid(), id, 'D', '-4/π', false, 'Sign reversed: computing (f(0) - f(π/4))/(π/4) = (0 - 1)/(π/4) gives -4/π. The earlier value must be subtracted from the later value.' from version_ins;
-- apcalcab-mcq-orly-c1-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-orly-c1-v2', 'mcq', 'Zero average rate of a cosine', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let g(x) = 3cos(2x) + 1. What is the average rate of change of g on the interval [π/6, 5π/6]?', null, '{}'::jsonb, md5('apcalcab-mcq-orly-c1-v2'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '0', true, 'g(π/6) = 3cos(π/3) + 1 = 5/2 and g(5π/6) = 3cos(5π/3) + 1 = 5/2. So (g(5π/6) - g(π/6))/(5π/6 - π/6) = 0/(2π/3) = 0. The function is not constant on the interval; its values at the two endpoints are equal.' from version_ins
union all select gen_random_uuid(), id, 'B', '3√3', false, 'Used an instantaneous rate at the right endpoint: the derivative -6sin(2x) at x = 5π/6 is -6sin(5π/3) = 3√3, which is not the average rate of change.' from version_ins
union all select gen_random_uuid(), id, 'C', '-3√3', false, 'Used an instantaneous rate at the left endpoint: the derivative -6sin(2x) at x = π/6 is -6sin(π/3) = -3√3, which is not the average rate of change.' from version_ins
union all select gen_random_uuid(), id, 'D', '-9√3/(2π)', false, 'Dropped the coefficient inside the argument: using 3cos(x) + 1 gives (3cos(5π/6) - 3cos(π/6))/(2π/3) = (-3√3)/(2π/3) = -9√3/(2π).' from version_ins;
-- apcalcab-mcq-orly-c1-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-orly-c1-v3', 'mcq', 'Average rate of a spring model', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The height of a weight bouncing on a spring is modeled by h(t) = 12 + 5sin(2t) centimeters, where t is the time in seconds. What is the average rate of change of h over the time interval π/6 ≤ t ≤ π/2?', null, '{}'::jsonb, md5('apcalcab-mcq-orly-c1-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '15√3/(2π) cm per second', false, 'Sign reversed: computing (h(π/6) - h(π/2))/(π/3) = (5√3/2)/(π/3) gives 15√3/(2π) cm per second. The later value must be subtracted first.' from version_ins
union all select gen_random_uuid(), id, 'B', '-5√3/2 cm per second', false, 'Did not divide by the interval length: h(π/2) - h(π/6) = -5√3/2 is the change in height in centimeters, so -5√3/2 cm per second is not the average rate of change.' from version_ins
union all select gen_random_uuid(), id, 'C', '-15√3/(2π) cm per second', true, 'h(π/6) = 12 + 5sin(π/3) = 12 + 5√3/2 and h(π/2) = 12 + 5sin(π) = 12. Average rate of change = (12 - (12 + 5√3/2))/(π/2 - π/6) = (-5√3/2)/(π/3) = -15√3/(2π) cm per second.' from version_ins
union all select gen_random_uuid(), id, 'D', '-5 cm per second', false, 'Used an instantaneous rate at the midpoint: the derivative 10cos(2t) at t = π/3 is 10cos(2π/3) = -5, giving -5 cm per second, which is the rate at one instant, not the average over the interval.' from version_ins;
-- apcalcab-mcq-orly-c2-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-orly-c2-v1', 'mcq', 'Greatest average rate from a table', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The table gives selected values of a function f.

x: 0, 2, 3, 5, 7, 9
f(x): 1, 10, 16, 28, 24, 26

On which of the following intervals is the average rate of change of f greatest?', null, '{}'::jsonb, md5('apcalcab-mcq-orly-c2-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[2, 3]', true, 'Average rates of change: [0, 2]: (10 - 1)/2 = 9/2; [2, 3]: (16 - 10)/1 = 6; [5, 7]: (24 - 28)/2 = -2; [7, 9]: (26 - 24)/2 = 1. The greatest is 6, on [2, 3].' from version_ins
union all select gen_random_uuid(), id, 'B', '[5, 7]', false, 'Used the mean of the endpoint values: (28 + 24)/2 = 26 on [5, 7] is the largest mean, so [5, 7] was chosen, but its average rate of change is (24 - 28)/2 = -2.' from version_ins
union all select gen_random_uuid(), id, 'C', '[7, 9]', false, 'Compared function values at the right endpoints: f(9) = 26 is the largest right-endpoint value, so [7, 9] was chosen, but its average rate of change is only (26 - 24)/2 = 1.' from version_ins
union all select gen_random_uuid(), id, 'D', '[0, 2]', false, 'Divided by the right endpoint instead of the interval length: (10 - 1)/2 = 9/2 on [0, 2] beats (16 - 10)/3 = 2 on [2, 3], so [0, 2] looks greatest. The divisor must be b - a.' from version_ins;
-- apcalcab-mcq-orly-c2-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-orly-c2-v2', 'mcq', 'Greatest average rate of a cubic', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Let f(x) = x³ - 6x. On which of the following intervals is the average rate of change of f greatest?', null, '{}'::jsonb, md5('apcalcab-mcq-orly-c2-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 5]', false, 'Used the mean of the endpoint values: (0 + 95)/2 = 95/2 on [0, 5] is the largest mean, so [0, 5] was chosen, but its average rate of change is only 19.' from version_ins
union all select gen_random_uuid(), id, 'B', '[2, 5]', true, 'f(0) = 0, f(1) = -5, f(2) = -4, f(3) = 9, f(4) = 40, f(5) = 95. Average rates: [2, 5]: (95 - (-4))/3 = 33; [3, 4]: (40 - 9)/1 = 31; [1, 5]: (95 - (-5))/4 = 25; [0, 5]: (95 - 0)/5 = 19. The greatest is 33, on [2, 5].' from version_ins
union all select gen_random_uuid(), id, 'C', '[1, 5]', false, 'Divided by the right endpoint instead of the interval length: (95 - (-5))/5 = 20 on [1, 5] beats 99/5 on [2, 5], 19 on [0, 5], and 31/4 on [3, 4], so [1, 5] was chosen.' from version_ins
union all select gen_random_uuid(), id, 'D', '[3, 4]', false, 'Mishandled the negative value f(2) = -4: computing 95 - 4 instead of 95 - (-4) gives 91/3 on [2, 5] (and 90/4 on [1, 5]), so [3, 4] with 31 appears greatest.' from version_ins;
-- apcalcab-mcq-orly-c2-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), '826c8cf1-bc1b-4f2a-bd33-61a758e1487d', 'apcalcab-mcq-orly-c2-v3', 'mcq', 'Least average rate of a reservoir', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The volume of water in a reservoir is modeled by V(t) = 40√(t + 1) - 4t thousand cubic meters, where t is the time in days, 0 ≤ t ≤ 35. On which of the following intervals is the average rate of change of V least?', null, '{}'::jsonb, md5('apcalcab-mcq-orly-c2-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[0, 15]', false, 'Used the mean of the endpoint values: (40 + 100)/2 = 70 on [0, 15] is the smallest mean, so [0, 15] was chosen, but its average rate of change is 4 thousand cubic meters per day.' from version_ins
union all select gen_random_uuid(), id, 'B', '[3, 8]', false, 'Compared function values at the right endpoints: V(8) = 88 is the smallest right-endpoint value, so [3, 8] was chosen, but its average rate of change is 4 thousand cubic meters per day.' from version_ins
union all select gen_random_uuid(), id, 'C', '[8, 15]', false, 'Divided by the right endpoint instead of the interval length: (100 - 88)/15 = 4/5 on [8, 15] is smaller than (100 - 68)/35 = 32/35 on [3, 35], so [8, 15] was chosen, but its average rate of change is 12/7 thousand cubic meters per day.' from version_ins
union all select gen_random_uuid(), id, 'D', '[3, 35]', true, 'V(0) = 40, V(3) = 68, V(8) = 88, V(15) = 100, V(35) = 100. Average rates (thousand cubic meters per day): [3, 35]: (100 - 68)/32 = 1; [3, 8]: (88 - 68)/5 = 4; [8, 15]: (100 - 88)/7 = 12/7; [0, 15]: (100 - 40)/15 = 4. The least is 1, on [3, 35].' from version_ins;

create temporary table lab (content_key text primary key, topic text, req int[], pu int, difficulty text, skill text, skill_status text, tier text, po_topic boolean, family text) on commit drop;
insert into lab values

('apcalcab-mcq-orly-c1-v1','2.1',array[2]::int[],2,'Easy','2.B','validated','4of4',false,'C1'),
('apcalcab-mcq-orly-c1-v2','2.1',array[2]::int[],2,'Medium','2.B','validated','4of4',false,'C1'),
('apcalcab-mcq-orly-c1-v3','2.1',array[2]::int[],2,'Hard','2.B','validated','4of4',false,'C1'),
('apcalcab-mcq-orly-c2-v1','2.1',array[2]::int[],2,'Easy','2.B','validated','4of4',false,'C2'),
('apcalcab-mcq-orly-c2-v2','2.1',array[2]::int[],2,'Medium','2.B','validated','4of4',false,'C2'),
('apcalcab-mcq-orly-c2-v3','2.1',array[2]::int[],2,'Hard','2.B','validated','4of4',false,'C2');
create temporary table expd (content_key text primary key, h text) on commit drop;
insert into expd values ('apcalcab-mcq-orly-c1-v1','ad49e2327ca44d00ab2b5a48c8609aab'),('apcalcab-mcq-orly-c1-v2','edb79adf492c42fbbc93f19aa72b1348'),('apcalcab-mcq-orly-c1-v3','f70b145de47757670280fc3b533c56f5'),('apcalcab-mcq-orly-c2-v1','c1e1801b480404c661f1f8d9cb77c25c'),('apcalcab-mcq-orly-c2-v2','5e81f298df70ee009ea93fd6a797c1cf'),('apcalcab-mcq-orly-c2-v3','1282815d9f92c3a5f892a8122379ac0d');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id, gen_random_uuid() skill_vd
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.status='draft'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1 and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>6 then raise exception 'expected 6 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version='33b4408b-0ecc-4c7a-b0b1-612db81164a1' and tt.topic_code=tgt.topic)) then raise exception 'unknown topic'; end if;
 if exists (select 1 from tgt where skill is not null and not exists (select 1 from app.taxonomy_cells c where c.taxonomy_source_version='33b4408b-0ecc-4c7a-b0b1-612db81164a1' and c.topic_code=tgt.topic and c.skill_code=tgt.skill)) then raise exception 'skill not in grid'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id join expd e on e.content_key=t.content_key
     group by t.content_key, civ.stem, e.h having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=e.h) z)<>6 then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=civ.id),'')) from tgt where civ.id=tgt.version_id;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'Orly pooled-practice clean-room items (DECISION-0098), published on Product Owner chat approval 2026-10-06 (APPROVAL-0126). Clean-room authoring from scrubbed family specs; author verify scripts; independent re-derivation of every key; two-model blind solve + rationale audit (gpt-5.6-sol, deepseek-v4-pro-0813) with patch rounds re-checked in full; CED scope check; topic probe. Batch: scripts/content-seed/apchem-orly-cleanroom-2026-10-06/README.md',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','approval_0126_po_chat','qa_date','2026-10-06','content_key',content_key,'family',family),
 md5(jsonb_build_object('approval','APPROVAL-0126','content_key',content_key,'version',version_id)::text), 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 when civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct) then 'canonical letter mismatch'
 when civ.stem ~ E'\n\\s*A[\\.\\)]\\s' then 'embedded choice list'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, rationale, confidence, proposal_run)
select version_id, difficulty, 'calibrated_judgement', 'Authored band from the clean-room family spec (v1 easy, v2 medium, v3 hard); DECISION-0096 requires a band on every published MCQ.', 'medium', 'orly-cleanroom-2026-10-06' from tgt;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req, (select max(u) from unnest(req) u), pu, array[]::text[], '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, 'provisional', 'provisional_model', 'apcalcab_orly_cleanroom_2026_10_06',
 jsonb_build_object('origin','clean_room_original','topic',topic,'family',family,'units_source', case when po_topic then 'Product Owner chat 2026-10-06 set topic 3.7 (checkers split 3.7/4.5)' else 'blind topic probe gpt-5.6-sol + deepseek-v4-pro-0813, 2 samples each; unit agreement' end,'report','scripts/content-seed/apchem-orly-cleanroom-2026-10-06'),
 'orly-cleanroom-labeling-2026-10-06', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', case when po_topic then 'chat_review' else 'automated_spot_check' end, pu, req,
 case when po_topic then 'Product Owner chat 2026-10-06 (APPROVAL-0126): "Approve 3.7".' else 'Product Owner chat approval 2026-10-06 (APPROVAL-0126). Two blind checkers (gpt-5.6-sol, deepseek-v4-pro-0813) placed the item in this unit (DECISION-0066).' end from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, topic, null, true, 'validated', 'apcalcab_orly_cleanroom_2026_10_06_topic',
 case when po_topic then 'Product Owner chat 2026-10-06 (topic 3.7)' else 'orly-cleanroom topic probe 2026-10-06 (gpt-5.6-sol + deepseek-v4-pro-0813, 2 samples each)' end, case when po_topic then 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid end, now(), gen_random_uuid() from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, topic, skill, false, skill_status, 'skill_orly_cleanroom_4voter_2026_10_06:'||tier,
 'orly-cleanroom skills 2026-10-06 (4 voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash; validated at >=3 of 4)', null,
 case when skill_status='validated' then now() end, case when skill_status='validated' then skill_vd end from tgt where skill is not null;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' and content_item_id in (select item_id from tgt) group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions'; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>6 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>6 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary and c.superseded_by is null and c.assignment_status='validated'; if n<>6 then raise exception 'topic cell count %', n; end if;
  select count(*) into n from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id; if n<>6 then raise exception 'difficulty count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%, skill_cells=%, difficulty=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcab_orly_cleanroom_2026_10_06' and label_status='validated'), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where c.is_primary), (select count(*) from app.content_item_cells c join tgt t on t.version_id=c.content_item_version_id where not c.is_primary), (select count(*) from app.content_item_difficulty d join tgt t on t.version_id=d.content_item_version_id); end $$;
rollback;
