-- APBIO-FRQ-S-003 v2 image metadata, PART 2 of 2: OWNER APPROVAL. RUN BY THE OWNER, NOT BY AN AGENT.
-- Run only after PART 1 has been executed and you have looked at the v2 question and its image
-- (same corrected photosynthesis diagram that APPROVAL-0190 approved for v1).
-- Approves the copied v2 metadata and records the required visual decision, as APPROVAL-0190 did for v1.
-- Does not publish v2 and changes no question, scoring, taxonomy or label data.
begin;
set local lock_timeout='3s';
set local statement_timeout='20s';
do $guard$ begin
  if not exists(select 1 from app.profiles where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564' and role='admin') then raise exception 'owner approver unavailable'; end if;
  if (select count(*) from app.content_asset_metadata where content_item_version_id='bf317c96-1289-4803-b71f-b0aff4620844' and approved_by is null and approved_at is null)<>1 then raise exception 'PART 1 rows not in the expected unapproved state'; end if;
  if exists(select 1 from app.content_visual_requirements where content_item_version_id='bf317c96-1289-4803-b71f-b0aff4620844') then raise exception 'visual decision already exists'; end if;
end $guard$;
update app.content_asset_metadata set approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564', approved_at=now(), updated_at=now()
where content_item_version_id='bf317c96-1289-4803-b71f-b0aff4620844' and approved_by is null;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at)
values ('bf317c96-1289-4803-b71f-b0aff4620844','yes','approved','f5a26c6b-3566-4d58-9e97-979fbb947564',now());
do $verify$ begin
  if (select count(*) from app.content_item_versions v join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_path=v.stimulus_image_path and a.approved_at is not null join app.content_visual_requirements r on r.content_item_version_id=v.id and r.image_needed='yes' and r.image_approval='approved' where v.id='bf317c96-1289-4803-b71f-b0aff4620844')<>1 then raise exception 'v2 not servable after approval'; end if;
end $verify$;
commit;
