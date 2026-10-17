-- Legacy Biology FRQ question-instruction repair (units 1-3): STEP 2, PUBLISH. OWNER-RUN, NOT BY AN AGENT. APPROVAL-0189.
-- Drafted 2026-10-17; NOT YET EXECUTED.
--
-- Step 1 (20261017_apbio_legacy_frq_instructions_drafts.sql, executed) created a v+1 DRAFT for each of the 14 FRQs with
-- authored parts; the live versions kept serving. This step retires each live version, records the owner approval and
-- publishes the draft, the same sequence as 20260812_apbio_shortfrq_1pt_repair.sql. It writes approval records and
-- approved_by in the owner's name, which is why it is owner-run.
--
-- Before running: S-003's draft needs its image metadata approved (APPROVAL-0191 part 2, already done). Any draft that has
-- a stimulus image must have approved metadata AND an approved visual decision for the NEW version, or this script stops.
-- Rehearse first: replace the final `commit;` with `rollback;` (the assertions still fire).
-- Rollback after running: retire the new versions and republish the old ones (the old version id is each draft's
-- prompt_json->>'qa_source_version_id'); or ask the agent to prepare that script.

begin;
set local lock_timeout='3s';
set local statement_timeout='60s';
select pg_advisory_xact_lock(hashtext('cramapple-bio-frq-instructions-publish-20261017'));

create temporary table pub_targets (content_key text primary key) on commit drop;
insert into pub_targets values
('APBIO-FRQ-S-003'),('APBIO-FRQ-S-019'),('APBIO-FRQ-S-021'),('APBIO-FRQ-S-023'),('APBIO-FRQ-S-025'),
('APBIO-FRQ-S-026'),('APBIO-FRQ-S-028'),('APBIO-FRQ-S-029'),('APBIO-FRQ-S-032'),('APBIO-FRQ-S-033'),
('APBIO-FRQ-S-036'),('APBIO-FRQ-S-038'),('APBIO-FRQ-S-071'),('APBIO-FRQ-S-080');

create temporary table pub (
  content_key text primary key,
  item_id uuid not null,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $guard$
declare
  t record; v_item app.content_items%rowtype; v_old app.content_item_versions%rowtype; v_new app.content_item_versions%rowtype;
  n int;
begin
  if not exists(select 1 from app.profiles where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564' and role='admin') then
    raise exception 'owner approver unavailable';
  end if;
  for t in select * from pub_targets order by content_key loop
    select * into strict v_item from app.content_items where content_key=t.content_key and item_type='frq' for update;
    select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' for update;
    select count(*) into n from app.content_item_versions
      where content_item_id=v_item.id and status='draft' and prompt_json->>'qa_remediation' like '%APPROVAL-0189%';
    if n<>1 then raise exception '% expected exactly one APPROVAL-0189 draft, found %', t.content_key, n; end if;
    select * into strict v_new from app.content_item_versions
      where content_item_id=v_item.id and status='draft' and prompt_json->>'qa_remediation' like '%APPROVAL-0189%' for update;
    if v_new.prompt_json->>'qa_source_version_id' <> v_old.id::text then
      raise exception '% draft was built from a different live version than the one now published', t.content_key; end if;
    if v_new.version_num <> v_old.version_num+1 then raise exception '% version numbers out of sequence', t.content_key; end if;
    if jsonb_array_length(v_new.prompt_json->'parts') <> 2
       or exists(select 1 from jsonb_array_elements(v_new.prompt_json->'parts') p where nullif(btrim(p->>'prompt_text'),'') is null)
      then raise exception '% draft parts missing or blank', t.content_key; end if;
    if (select count(*) from app.frq_criteria where content_item_version_id=v_new.id)
       <> (select count(*) from app.frq_criteria where content_item_version_id=v_old.id)
       or (select md5(coalesce(string_agg(criterion_key||'|'||learner_facing_text||'|'||points_possible::text,E'\n' order by criterion_key),'')) from app.frq_criteria where content_item_version_id=v_new.id)
        <> (select md5(coalesce(string_agg(criterion_key||'|'||learner_facing_text||'|'||points_possible::text,E'\n' order by criterion_key),'')) from app.frq_criteria where content_item_version_id=v_old.id)
      then raise exception '% scoring criteria differ between live version and draft', t.content_key; end if;
    if v_new.stimulus_image_path is not null and not exists(
         select 1 from app.content_asset_metadata a join app.content_visual_requirements r on r.content_item_version_id=a.content_item_version_id
         where a.content_item_version_id=v_new.id and a.storage_path=v_new.stimulus_image_path and a.approved_at is not null and a.approved_by is not null
           and r.image_needed='yes' and r.image_approval='approved')
      then raise exception '% draft has an image without approved metadata and visual decision for the new version', t.content_key; end if;
    insert into pub values (t.content_key, v_item.id, v_old.id, v_new.id);
  end loop;
end $guard$;

-- retire the live versions (pending subject-review assignments skipped, as in the August repair)
update app.content_review_assignments set status='skipped'
where content_item_version_id in (select old_version_id from pub) and assignment_purpose='subject_review' and status in ('pending','in_progress');
update app.content_item_versions set status='retired', updated_at=now() where id in (select old_version_id from pub);
update app.content_items set status='draft', updated_at=now() where id in (select item_id from pub);

-- owner approval of the drafts
insert into app.content_review_assignments (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,review_kind,status,assignment_purpose,created_by)
select gen_random_uuid(), new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from pub;

insert into app.content_review_decisions (content_review_assignment_id,content_item_version_id,reviewer_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,concern_codes,note,tutor_decision,decision_payload,decision_hash,created_by)
select cra.content_review_assignment_id, p.new_version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, 'Medium', false, array[]::text[],
  'Owner-directed legacy Biology FRQ question-instruction repair, 2026-10-17 (APPROVAL-0189): authored part prompts added; scoring criteria unchanged.',
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','bio_frq_instruction_repair','content_key',p.content_key,'qa_date','2026-10-17'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','bio_frq_instruction_repair','content_key',p.content_key,'qa_date','2026-10-17')::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from pub p join app.content_review_assignments cra on cra.content_item_version_id=p.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved',
  approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from pub p where civ.id=p.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from pub p where ci.id=p.item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from pub p where civ.id=p.new_version_id;
update app.content_items ci set status='published', updated_at=now() from pub p where ci.id=p.item_id;

do $verify$
declare n int;
begin
  select count(*) into n from pub; if n<>14 then raise exception 'expected 14 items, got %', n; end if;
  select count(*) into n from pub p join app.content_item_versions v on v.id=p.new_version_id join app.content_items i on i.id=p.item_id
    where v.status='published' and i.status='published' and v.approved_by is not null; if n<>14 then raise exception 'expected 14 published, got %', n; end if;
  select count(*) into n from pub p join app.content_item_versions v on v.id=p.old_version_id where v.status='retired'; if n<>14 then raise exception 'expected 14 retired, got %', n; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by content_item_id having count(*)>1) d;
  if n<>0 then raise exception 'duplicate published versions: %', n; end if;
end $verify$;

select 'published' metric, count(*)::text value from pub
union all select 'keys', string_agg(content_key, ', ' order by content_key) from pub;

commit;
