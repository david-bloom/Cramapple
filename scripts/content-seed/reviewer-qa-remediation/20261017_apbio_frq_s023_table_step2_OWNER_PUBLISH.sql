-- Biology FRQ S-023 data-table repair: STEP 2, PUBLISH + RESTORE SERVING in one transaction. OWNER-RUN, NOT BY AN AGENT. APPROVAL-0193.
-- Run only after step 1 (20261017_apbio_frq_s023_table_step1_draft.sql) created the v4 draft. Retires live v3, records the
-- owner approval, publishes v4 (stimulus as a rendered table; numbers, stem, parts, criteria unchanged), then copies the topic cells
-- and re-validates the serving label so the item is never unserved. Ends by asserting the student selector returns S-023; else rolls back.
-- Rehearse first: replace the final `commit;` with `rollback;` (the assertions still fire).
-- Rollback after running: retire v4 and republish v3 (v3 id = v4 prompt_json->>'qa_source_version_id'), re-validate the label.

begin;
set local lock_timeout='3s';
set local statement_timeout='60s';
select pg_advisory_xact_lock(hashtext('cramapple-bio-s023-table-publish-20261017'));

create temporary table pub_targets (content_key text primary key) on commit drop;
insert into pub_targets values ('APBIO-FRQ-S-023');

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
      where content_item_id=v_item.id and status='draft' and prompt_json->>'qa_remediation' like '%APPROVAL-0193%';
    if n<>1 then raise exception '% expected exactly one APPROVAL-0193 draft, found %', t.content_key, n; end if;
    select * into strict v_new from app.content_item_versions
      where content_item_id=v_item.id and status='draft' and prompt_json->>'qa_remediation' like '%APPROVAL-0193%' for update;
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
  'Owner-directed S-023 data-table repair, 2026-10-17 (APPROVAL-0193): stimulus data shown as a table; numbers, parts and scoring criteria unchanged.',
  'approve',
  jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','bio_frq_s023_table','content_key',p.content_key,'qa_date','2026-10-17'),
  encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','bio_frq_s023_table','content_key',p.content_key,'qa_date','2026-10-17')::text,'sha256'),'hex'),
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from pub p join app.content_review_assignments cra on cra.content_item_version_id=p.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved',
  approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now()
from pub p where civ.id=p.new_version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from pub p where ci.id=p.item_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from pub p where civ.id=p.new_version_id;
update app.content_items ci set status='published', updated_at=now() from pub p where ci.id=p.item_id;


-- serving restore (APPROVAL-0189 step 3 lesson): copy the retired version's live cells onto the new live version and re-validate
-- the existing serving label, in this same transaction, so the item is never unserved.
create temporary table rl (
  content_key text primary key, item_id uuid, new_version_id uuid, old_version_id uuid, label_id uuid, decision_id uuid default gen_random_uuid()
) on commit drop;
insert into rl (content_key,item_id,new_version_id,old_version_id,label_id)
select p.content_key,p.item_id,p.new_version_id,p.old_version_id,l.content_taxonomy_label_id
from pub p join app.content_taxonomy_labels l on l.content_item_id=p.item_id and l.label_scope='serving' and l.superseded_by is null;
do $g$ begin
  if (select count(*) from rl)<>1 then raise exception 'expected exactly one serving label'; end if;
  if not exists (select 1 from rl join app.content_item_cells c on c.content_item_version_id=rl.old_version_id and c.superseded_by is null and c.is_primary) then raise exception 'predecessor has no live primary cell'; end if;
  if exists (select 1 from rl join app.content_item_cells c on c.content_item_version_id=rl.new_version_id and c.superseded_by is null) then raise exception 'new version already has cells'; end if;
end $g$;

-- 1. copy the predecessor's live cells onto the new live version, unchanged
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary,
  assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select rl.new_version_id, c.content_item_id, c.taxonomy_source_version, c.topic_code, c.skill_code, c.is_primary,
  c.assignment_status, c.source, c.model_run_id, c.validated_by, c.validated_at, c.validation_decision_id
from rl join app.content_item_cells c on c.content_item_version_id=rl.old_version_id and c.superseded_by is null;

-- 2. owner validation decision for each existing serving label, then re-validate it against the new live version
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source,
  reviewed_primary_unit, reviewed_required_units, notes)
select rl.decision_id, rl.label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', l.primary_unit, l.required_units,
  'APPROVAL-0193: content-preserving republish (stimulus table format; scoring and topic cells unchanged); serving label re-validated against the new live version.'
from rl join app.content_taxonomy_labels l on l.content_taxonomy_label_id=rl.label_id;

update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(),
  validation_decision_id=rl.decision_id, validated_against_version_id=rl.new_version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(rl.new_version_id)
from rl where l.content_taxonomy_label_id=rl.label_id;


do $verify$
declare n int; served int;
begin
  select count(*) into n from pub p join app.content_item_versions v on v.id=p.new_version_id join app.content_items i on i.id=p.item_id
    where v.status='published' and i.status='published' and v.approved_by is not null and v.version_num=4; if n<>1 then raise exception 'not published as v4'; end if;
  select count(*) into n from pub p join app.content_item_versions v on v.id=p.old_version_id where v.status='retired'; if n<>1 then raise exception 'old version not retired'; end if;
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by content_item_id having count(*)>1) d;
  if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  select count(*) into n from rl join app.content_taxonomy_labels l on l.content_taxonomy_label_id=rl.label_id
    where l.label_status='validated' and l.validated_against_version_id=rl.new_version_id and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(rl.new_version_id);
  if n<>1 then raise exception 'label not re-validated'; end if;
  select count(*) into n from rl where (select count(*) from app.content_item_cells c where c.content_item_version_id=rl.new_version_id and c.superseded_by is null)
     = (select count(*) from app.content_item_cells c where c.content_item_version_id=rl.old_version_id and c.superseded_by is null) ;
  if n<>1 then raise exception 'cell copy incomplete'; end if;
  select count(distinct q.content_key) into served
  from (values (1),(2),(3)) un(u) cross join generate_series(0,255,51) off
  cross join lateral public.select_student_practice_items('2d88ba5e-a6a3-43b8-bfae-9e5505a178a7', un.u, '00000000-0000-4000-8000-000000000000', null, null, null, 51, off) q
  where q.content_key='APBIO-FRQ-S-023';
  if served<>1 then raise exception 'practice selector does not return S-023; rolling back'; end if;
end $verify$;

select 'published_v4_and_served' metric, 'S-023 (asserted)' value;

commit;
