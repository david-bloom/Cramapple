-- AP Calc AB: apcalcab-mcq-037 key desync + 10 distractor-rationale repairs, 2026-09-30.   DRAFT -- NOT APPLIED.
--
-- Evidence: scripts/content-seed/calc-ab-pilot-2026-09-30/PILOT_REPORT.md, .../calc-ab-seed-audit-2026-09-30/AUDIT_REPORT.md,
-- docs/handoffs/SESSION_CLOSE_2026_09_30_SEEDED_GENERATION.md section 4 items 1-2. Plan approved by the Product Owner 2026-09-30.
-- Every keyed answer was independently recomputed; only distractor rationales (and 037's canonical_answer_1) change,
-- with ONE exception flagged for the Product Owner: apcalcab-mcq-031 choices A and B have no derivation
-- (no error pattern reproduces -5.34 or -3.81), so their numbers are replaced by the values two real errors produce:
--   7.62  = 3t^2 - 4.7t + 2.1 at t=2.35 (forgot the power-rule factor 2 on -4.7t^2)
--   -2.04 = s(2.35), the position instead of the velocity.
-- The key (-3.42 m/s) and choice C/D are unchanged. The stem's embedded option lines are resynced by app.mcq_stem_choice_resync().
--
-- Pattern: owner_remediation_approval (protocol section 9.4): new version (version_num+1), never an in-place edit; choices copied with
-- only the listed edits; review assignment + decision; approve; publish. Serving-label carry-forward is NOT in this file
-- (20260930_apcalcab_label_carry_forward.sql, run right after this file) because re-pointing a 'validated' label is a human validation act.
-- TESTED 2026-09-30: rolled-back run on Production (repair + carry-forward together): 11/11 repaired, keys and is_correct unchanged, 031 stem resynced, labels restored and hash-fresh.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-037-rationale-repair-20260930'));

-- (content_key, old choice_text, new choice_text, new rationale). Matched by choice TEXT so letters never have to be assumed.
create temporary table edits (content_key text, old_text text, new_text text, new_rationale text) on commit drop;
insert into edits values
('apcalcab-mcq-005','2e^(2x) cos x','2e^(2x) cos x','Multiplies the two derivatives, (2e^(2x))(cos x), instead of applying the product rule.'),
('apcalcab-mcq-007','3x²√(1+x³)','3x²√(1+x³)','Multiplies 3x² by √(1+x³) instead of dividing by 2√(1+x³); the derivative of the outer square root is 1/(2√u), not √u.'),
('apcalcab-mcq-008','−5/4','−5/4','This is the reciprocal of the correct slope (−4/5), not the slope itself.'),
('apcalcab-mcq-016','6','6','Dividing the integral 9 by 1.5 uses the wrong divisor; the interval length is 3, so the average value is (1/3)(9)=3. (6 is also f′(3), the slope at x=3, which is not an average value.)'),
('apcalcab-mcq-016','27','27','Evaluates x³ at x=3 and omits both the 1/3 from the antiderivative x³/3 and the 1/(b−a) factor of 1/3.'),
('apcalcab-mcq-026','e','e','Differentiates only the exponential factor and leaves x² unchanged, giving x²e^x, which equals e at x=1.'),
('apcalcab-mcq-030','−4/3','−4/3','Interchanges x and y, giving −y/x = −4/3 instead of the correct −x/y = −3/4.'),
('apcalcab-mcq-031','−5.34 m/s','7.62 m/s','Uses −4.7t instead of −9.4t in the derivative (forgets the power-rule factor 2 on −4.7t²), so v = 3t²−4.7t+2.1 ≈ 7.62 m/s.'),
('apcalcab-mcq-031','−3.81 m/s','−2.04 m/s','Evaluates the position s(2.35) ≈ −2.04 instead of the velocity s′(2.35).'),
('apcalcab-mcq-038','x<0','x<0','Reads the sign of x rather than solving 6x−12>0; for x<0, f″(x) is negative, so f is concave down there.'),
('apcalcab-mcq-038','0<x<2','0<x<2','On 0<x<2, f″(x)=6x−12 is negative, so f is concave down, not concave up.'),
('apcalcab-mcq-np2-006','3e^2','3e^2','Integrates 2x as 2x² instead of x², giving y=3e^(2x²) and y(1)=3e².'),
('apcalcab-mcq-np2-006','6','6','Treats y as the constant 3 while integrating, so dy/dx=6x, y=3x²+3 and y(1)=6; this ignores that y changes with x (the actual solution is exponential).'),
('apcalcab-mcq-080','Does not exist, because the denominator equals 0 at x = -2','Does not exist, because the denominator equals 0 at x = -2','Stops at the 0 in the denominator; the numerator is also 0 at x=−2, so the quotient is 0/0, and cancelling the common factor x+2 shows the limit exists.');

-- 037: only the stored letter changes (choice B, 0.796, is the local maximum; verified independently).
create temporary table key_fix (content_key text primary key, new_canonical text) on commit drop;
insert into key_fix values ('apcalcab-mcq-037','B');

create temporary table targets (content_key text primary key) on commit drop;
insert into targets select distinct content_key from edits union select content_key from key_fix;

create temporary table repaired (content_key text primary key, old_version_id uuid not null, new_version_id uuid not null) on commit drop;

do $$
declare
  t record; e record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid; v_ca1 text; v_hits int;
begin
  for t in select * from targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='mcq' for update;
    select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' order by version_num desc limit 1 for update;

    v_ca1 := coalesce((select new_canonical from key_fix where content_key=t.content_key), v_old.canonical_answer_1);
    v_new := gen_random_uuid();

    update app.content_review_assignments set status='skipped'
      where content_item_version_id=v_old.id and assignment_purpose='subject_review' and status in ('pending','in_progress');
    update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;
    update app.content_items set status='draft', updated_at=now() where id=v_item.id;

    insert into app.content_item_versions (id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path)
    values (v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object('content_version',v_old.version_num+1,
        'qa_remediation','2026-09-30 distractor-rationale / key repair (seed audit)','qa_source_version_id',v_old.id),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_ca1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);

    insert into app.mcq_choices (content_item_version_id,choice_key,choice_text,is_correct,rationale)
      select v_new,choice_key,choice_text,is_correct,rationale from app.mcq_choices where content_item_version_id=v_old.id;

    for e in select * from edits where content_key=t.content_key loop
      update app.mcq_choices set choice_text=e.new_text, rationale=e.new_rationale
        where content_item_version_id=v_new and choice_text=e.old_text;
      get diagnostics v_hits = row_count;
      if v_hits<>1 then raise exception 'edit for % (%) matched % choices, expected 1', t.content_key, e.old_text, v_hits; end if;
    end loop;

    -- resync the stem's embedded option lines only where a choice text changed (031); a no-op elsewhere is asserted below
    if exists (select 1 from edits where content_key=t.content_key and old_text<>new_text) then
      update app.content_item_versions set stem=app.mcq_stem_choice_resync(v_new, v_old.stem) where id=v_new;
    end if;

    -- carry the non-label, version-keyed children forward unchanged
    insert into app.content_item_cells (content_item_version_id,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id)
      select v_new,content_item_id,taxonomy_source_version,topic_code,skill_code,is_primary,assignment_status,source,model_run_id,validated_by,validated_at,validation_decision_id
      from app.content_item_cells where content_item_version_id=v_old.id and superseded_by is null;
    insert into app.content_item_difficulty (content_item_version_id,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by)
      select v_new,difficulty,basis,attainment_ratio,ratio_source,subject_cut_points,source_value,rationale,confidence,proposal_run,created_by
      from app.content_item_difficulty where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,'tutor_question',1,'Medium',false,array[]::text[],
  'Owner-approved repair 2026-09-30 from the seed audit (PILOT_REPORT / AUDIT_REPORT): keys verified correct; distractor rationales corrected (037: canonical_answer_1 A->B). ' || r.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_repair','content_key',r.content_key,'qa_date','2026-09-30'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apcalcab-seed-audit-20260930'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved',
  approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from repaired r where civ.id=r.new_version_id;
update app.content_items ci set status='published', updated_at=now()
from repaired r join app.content_item_versions civ on civ.id=r.new_version_id where ci.id=civ.content_item_id;

do $$
declare n int;
begin
  select count(*) into n from repaired;
  if n<>11 then raise exception 'expected 11 repaired items, got %', n; end if;
  -- every repaired item: exactly one correct choice and canonical_answer_1 equals its letter
  select count(*) into n from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
   where (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1
      or civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct);
  if n<>0 then raise exception 'key/letter mismatch after repair: %', n; end if;
  -- no stem/choice desync
  select count(*) into n from repaired r join app.content_item_versions civ on civ.id=r.new_version_id
   where array_length(app.mcq_stem_choice_desync(civ.id, civ.stem),1) > 0;
  if n<>0 then raise exception 'stem/choice desync after repair: %', n; end if;
  -- isCorrect flags unchanged vs the retired version
  select count(*) into n from repaired r join app.mcq_choices o on o.content_item_version_id=r.old_version_id
   join app.mcq_choices w on w.content_item_version_id=r.new_version_id and w.choice_key=o.choice_key
   where w.is_correct<>o.is_correct;
  if n<>0 then raise exception 'is_correct changed on % choices', n; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d;
  if n<>0 then raise exception 'duplicate published versions: %', n; end if;
end $$;

select 'repaired' metric, count(*)::text value from repaired;
commit;
