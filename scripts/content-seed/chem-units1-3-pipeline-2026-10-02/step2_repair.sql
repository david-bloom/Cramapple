-- AP Chemistry Units 1-3 audit repair, 2026-10-02 (pipeline step 2). 6 published MCQs: 5 wrong-answer rationales rewritten, apchem-mcq-037 choice D (a second correct answer) and apchem-mcq-039 choice D (value not producible from its rationale) replaced. Keys unchanged. New version per item, never in place. Serving labels are rewritten in step 4.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u13-repair-20261002'));

-- (content_key, old choice_text, new choice_text, new rationale). Matched by choice TEXT so letters never have to be assumed.
create temporary table edits (content_key text, old_text text, new_text text, new_rationale text) on commit drop;
insert into edits values
('apchem-mcq-001','0.250 mol','0.250 mol','Uses 36.0 g mol⁻¹, twice the molar mass of water (for example by counting the whole H₂O formula twice), before dividing, giving 9.00/36.0 = 0.250 mol.'),
('apchem-mcq-008','4.0 L','4.0 L','Reads the 4.0 given in the problem (the final pressure in atm) as the final volume. Boyle''s law gives V2 = P1V1/P2 = (1.0)(2.0)/4.0 = 0.50 L, not 4.0 L.'),
('apchem-mcq-022','[Ar]3d^3 4s^2','[Ar]3d^3 4s^2','Reflects the misconception that electrons are removed from the subshell filled most recently (the reverse of the filling order). 3d fills after 4s, so this removes three 3d electrons first and leaves 4s², but transition-metal cations lose their 4s electrons before their 3d electrons.'),
('apchem-mcq-031','A covalent network solid, such as silicon dioxide','A covalent network solid, such as silicon dioxide','Incorrect: network solids such as silicon dioxide have all atoms held in a rigid lattice of directional covalent bonds with no mobile charge carriers, so they do not conduct electricity as solids or as liquids (graphite is a network solid with delocalized electrons, but it is not malleable). They are also extremely hard and brittle, not malleable, and typically have very high (not moderate) melting points.'),
('apchem-mcq-037','UV photons have more energy because they have higher frequency, even though all electromagnetic radiation travels at the same speed in vacuum.','UV photons have more energy because they have a shorter wavelength, and photon energy is directly proportional to wavelength.','Incorrect. The ranking is right, but the justification is wrong: E = hc/λ, so photon energy is inversely proportional to wavelength. A shorter wavelength means a higher frequency and a higher energy.'),
('apchem-mcq-039','0.167 M','0.286 M','Incorrect. This divides the original moles (0.0500 mol) by only the volume of water added (175.0 mL = 0.175 L) instead of by the final total volume, giving 0.286 M.');

create temporary table key_fix (content_key text primary key, new_canonical text) on commit drop;
-- no key fixes in this batch

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
        'qa_remediation','2026-10-02 Chemistry Units 1-3 audit repair (APPROVAL-0074)','qa_source_version_id',v_old.id),
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
  'Owner-approved repair 2026-10-02 (Chemistry Units 1-3 audit): keys verified correct; distractor rationales corrected; 037 choice D and 039 choice D replaced. ' || r.content_key,
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','seed_audit_rationale_repair','content_key',r.content_key,'qa_date','2026-10-02'),
  md5(r.new_version_id::text||'f5a26c6b-3566-4d58-9e97-979fbb947564'||'apchem-u13-audit-20261002'),
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
  if n<>6 then raise exception 'expected 6 repaired items, got %', n; end if;
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
