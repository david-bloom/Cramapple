-- Biology FRQ S-023 data-table repair: STEP 1, DRAFT VERSION ONLY (APPROVAL-0193).
-- Live v3 stores the pH data as plain lines; the student screen shows it as one run-on paragraph. This inserts a v4 DRAFT
-- whose stimulus is a caption + pipe table (the format the app renders as a real table). Same numbers, stem, parts and
-- scoring criteria. It does NOT retire, approve or publish anything; the live version keeps serving.
-- Rehearse first: replace the final `commit;` with `rollback;`; the assertions still fire.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-bio-s023-table-20261017'));

do $$
declare
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid := gen_random_uuid();
  v_stim text := E'Relative enzyme activity (% of that enzyme''s maximum measured)\npH | Pepsin | Trypsin\n2 | 100 | 2\n7 | 8 | 100\n11 | 0 | 35';
begin
  select * into strict v_item from app.content_items where content_key='APBIO-FRQ-S-023' and item_type='frq' for update;
  select * into strict v_old from app.content_item_versions where content_item_id=v_item.id and status='published' for update;
  if v_old.version_num<>3 or v_old.stimulus <> E'Relative enzyme activity (% of that enzyme''s maximum measured)\npH 2: pepsin 100, trypsin 2\npH 7: pepsin 8, trypsin 100\npH 11: pepsin 0, trypsin 35'
    then raise exception 'live version is not the expected v3'; end if;
  if exists (select 1 from app.content_item_versions o where o.content_item_id=v_item.id and o.status<>'published' and o.version_num>v_old.version_num)
    then raise exception 'already has a newer non-published version'; end if;

  insert into app.content_item_versions (
    id,content_item_id,version_num,stem,stimulus,prompt_json,explanation,help_text,content_hash,status,created_by,
    canonical_answer_1,canonical_answer_2,review_status,rubric_type,evaluator_strategy,stimulus_image_path
  ) values (
    v_new,v_item.id,v_old.version_num+1,v_old.stem,v_stim,
    v_old.prompt_json || jsonb_build_object('content_version',v_old.version_num+1,
      'qa_remediation','2026-10-17 S-023 data table as a rendered table (APPROVAL-0193)','qa_source_version_id',v_old.id),
    v_old.explanation,v_old.help_text,v_old.content_hash,'draft',v_old.created_by,
    v_old.canonical_answer_1,v_old.canonical_answer_2,null,v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path);

  insert into app.frq_criteria (content_item_version_id,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants,judgement_kind)
  select v_new,criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix,accepted_variants,judgement_kind
  from app.frq_criteria where content_item_version_id=v_old.id;

  update app.content_item_versions civ set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
    coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
              from app.frq_criteria fc where fc.content_item_version_id=civ.id),'')) where civ.id=v_new;

  if (select count(*) from app.frq_criteria where content_item_version_id=v_new)<>(select count(*) from app.frq_criteria where content_item_version_id=v_old.id)
    then raise exception 'criteria count changed'; end if;
  if (select md5(string_agg(criterion_key||'|'||learner_facing_text||'|'||points_possible::text,E'\n' order by criterion_key)) from app.frq_criteria where content_item_version_id=v_new)
   <> (select md5(string_agg(criterion_key||'|'||learner_facing_text||'|'||points_possible::text,E'\n' order by criterion_key)) from app.frq_criteria where content_item_version_id=v_old.id)
    then raise exception 'criteria differ'; end if;
  if (select prompt_json->'parts' from app.content_item_versions where id=v_new) <> v_old.prompt_json->'parts' then raise exception 'parts changed'; end if;
end $$;

select 'drafted' metric, v.version_num::text value from app.content_item_versions v join app.content_items i on i.id=v.content_item_id
where i.content_key='APBIO-FRQ-S-023' and v.status='draft';

commit;
