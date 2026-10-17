-- Non-destructive path recovery. Retain approved metadata and immutable source bytes.
begin;
set local lock_timeout='3s';
do $recover$ begin
perform id from app.content_item_versions where id='fdeb1925-dcae-4331-935b-890751635487' for update;
if not exists(select 1 from app.content_item_versions v where id='fdeb1925-dcae-4331-935b-890751635487' and stimulus_image_path='questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' and md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)='4f4c13419a81fc81fbf0b0b95114a9b2') then raise exception 'Recovery source/path drift'; end if;
if not exists(select 1 from app.content_visual_requirements where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487' and image_needed='yes' and image_approval='approved' and decided_by='f5a26c6b-3566-4d58-9e97-979fbb947564') then raise exception 'Unexpected decision owner'; end if;
update app.content_item_versions set stimulus_image_path=null where id='fdeb1925-dcae-4331-935b-890751635487';
delete from app.content_visual_requirements where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487';
end $recover$;
select 'fdeb1925-dcae-4331-935b-890751635487' as version_id,stimulus_image_path,not exists(select 1 from app.content_visual_requirements where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487') as prior_decision_restored from app.content_item_versions where id='fdeb1925-dcae-4331-935b-890751635487';
commit;
