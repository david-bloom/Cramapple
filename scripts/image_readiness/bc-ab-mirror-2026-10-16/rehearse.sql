-- Owner authorization: 2026-10-16, mirror existing AB images to exact BC counterparts.
-- One source-provenance-confirmed mirror; no new objects, questions or diagrams.
begin;
set local lock_timeout='3s';
set local statement_timeout='20s';
do $guard$
declare a app.content_item_versions; b app.content_item_versions;
begin
perform v.id from app.content_item_versions v where v.id in ('f492bfbf-5434-434f-a4d8-50b058477139','fdeb1925-dcae-4331-935b-890751635487') order by v.id for update;
perform c.choice_key from app.mcq_choices c where c.content_item_version_id in ('f492bfbf-5434-434f-a4d8-50b058477139','fdeb1925-dcae-4331-935b-890751635487') order by c.content_item_version_id,c.choice_key for update;
select * into strict a from app.content_item_versions where id='f492bfbf-5434-434f-a4d8-50b058477139';
select * into strict b from app.content_item_versions where id='fdeb1925-dcae-4331-935b-890751635487';
if a.status<>'published' or b.status<>'published' or a.stimulus_image_path is distinct from 'questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' or b.stimulus_image_path is not null then raise exception 'Publication/path drift'; end if;
if md5((to_jsonb(a)-'stimulus_image_path'-'updated_at')::text)<>'d7918b228cbcdde932b61ac3f945040f' or md5((to_jsonb(b)-'stimulus_image_path'-'updated_at')::text)<>'4f4c13419a81fc81fbf0b0b95114a9b2' then raise exception 'Reviewed source/scoring drift'; end if;
if a.stem is distinct from b.stem or a.stimulus is distinct from b.stimulus or b.prompt_json->>'mirrored_from_version_id'<>'f492bfbf-5434-434f-a4d8-50b058477139' then raise exception 'Not the reviewed mirror'; end if;
if (select jsonb_agg(jsonb_build_object('key',choice_key,'text',choice_text) order by choice_key) from app.mcq_choices where content_item_version_id='f492bfbf-5434-434f-a4d8-50b058477139') is distinct from (select jsonb_agg(jsonb_build_object('key',choice_key,'text',choice_text) order by choice_key) from app.mcq_choices where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487') then raise exception 'Choice text mismatch'; end if;
if (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id='fdeb1925-dcae-4331-935b-890751635487') is distinct from 'a170224c569faf4f0f25d7514ba33328' then raise exception 'Choice/scoring drift'; end if;
if app.taxonomy_relevant_hash(b.id)<>'2558ae5f6c0ead26719443274cea56c048dc9b747063276e817121cc10e933d1' or (select md5(jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id)::text) from app.content_taxonomy_labels l where l.content_item_id=b.content_item_id) is distinct from '56ccb76ea786fa862fe25167dafe6e61' then raise exception 'Taxonomy/labels drift'; end if;
if not exists(select 1 from app.content_asset_metadata m join storage.objects o on o.bucket_id=m.storage_bucket and o.name=m.storage_path join storage.buckets k on k.id=o.bucket_id where m.content_item_version_id='f492bfbf-5434-434f-a4d8-50b058477139' and m.storage_path='questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' and m.storage_bucket='content-assets' and m.approved_at is not null and not k.public) then raise exception 'Approved private source asset absent'; end if;
if exists(select 1 from app.content_asset_metadata where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487') or exists(select 1 from app.content_visual_requirements where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487') then raise exception 'Unexpected prior BC metadata/decision'; end if;
end $guard$;
create temporary table mirror_before on commit drop as
select id,md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text) content_digest,app.taxonomy_relevant_hash(v.id) taxonomy_hash from app.content_item_versions v where id in ('f492bfbf-5434-434f-a4d8-50b058477139','fdeb1925-dcae-4331-935b-890751635487');
update app.content_item_versions set stimulus_image_path='questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' where id='fdeb1925-dcae-4331-935b-890751635487';
insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
select 'fdeb1925-dcae-4331-935b-890751635487',storage_bucket,storage_path,alt_text,long_description,'f5a26c6b-3566-4d58-9e97-979fbb947564',now() from app.content_asset_metadata where content_item_version_id='f492bfbf-5434-434f-a4d8-50b058477139' and storage_bucket='content-assets' and storage_path='questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' and approved_at is not null;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at)
values ('fdeb1925-dcae-4331-935b-890751635487','yes','approved','f5a26c6b-3566-4d58-9e97-979fbb947564',now());
do $verify$ begin
if exists(select 1 from mirror_before h join app.content_item_versions v using(id) where md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)<>h.content_digest or app.taxonomy_relevant_hash(v.id)<>h.taxonomy_hash) then raise exception 'Content/scoring/taxonomy changed'; end if;
if (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id='fdeb1925-dcae-4331-935b-890751635487') is distinct from 'a170224c569faf4f0f25d7514ba33328' or (select md5(jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id)::text) from app.content_taxonomy_labels l where l.content_item_id='dc0ed036-6a8f-48ca-818c-7dbc38d43a52') is distinct from '56ccb76ea786fa862fe25167dafe6e61' then raise exception 'Choice/scoring/labels changed'; end if;
if (select count(*) from app.content_asset_metadata where content_item_version_id='fdeb1925-dcae-4331-935b-890751635487' and storage_bucket='content-assets' and storage_path='questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' and approved_at is not null)<>1 then raise exception 'BC approved metadata incomplete'; end if;
end $verify$;
select now() as attached_at,'apcalcbc-mcq-ab-060' as content_key,'fdeb1925-dcae-4331-935b-890751635487' as version_id,'questions/apcalcab-mcq-060/v2/9c8307b50c0c5c345f016df04cb96f8cca7bf5f88ebcf3645700f53c567e4669.png' as path,true as source_scoring_taxonomy_unchanged;
rollback;
