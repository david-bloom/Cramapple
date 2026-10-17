import json
from pathlib import Path
p=Path(__file__).parent
rows=json.loads((p/'reviewed-source.json').read_text())
a=next(r for r in rows if r['content_key']=='apcalcab-mcq-060')
b=next(r for r in rows if r['content_key']=='apcalcbc-mcq-ab-060')
assert all(a[k]==b[k] for k in ('stem','stimulus','choices'))
assert b['provenance']['mirrored_from_version_id']==a['version_id']
assert not b['stimulus_image_path'] and b['metadata'] is None and b['requirement'] is None
path=a['stimulus_image_path']; aid=a['version_id']; bid=b['version_id']
def lit(s): return "'"+s.replace("'","''")+"'" if s is not None else 'null'
sql=f"""-- Owner authorization: 2026-10-16, mirror existing AB images to exact BC counterparts.
-- One source-provenance-confirmed mirror; no new objects, questions or diagrams.
begin;
set local lock_timeout='3s';
set local statement_timeout='20s';
do $guard$
declare a app.content_item_versions; b app.content_item_versions;
begin
perform v.id from app.content_item_versions v where v.id in ('{aid}','{bid}') order by v.id for update;
perform c.choice_key from app.mcq_choices c where c.content_item_version_id in ('{aid}','{bid}') order by c.content_item_version_id,c.choice_key for update;
select * into strict a from app.content_item_versions where id='{aid}';
select * into strict b from app.content_item_versions where id='{bid}';
if a.status<>'published' or b.status<>'published' or a.stimulus_image_path is distinct from {lit(path)} or b.stimulus_image_path is not null then raise exception 'Publication/path drift'; end if;
if md5((to_jsonb(a)-'stimulus_image_path'-'updated_at')::text)<>{lit(a['unchanged_digest'])} or md5((to_jsonb(b)-'stimulus_image_path'-'updated_at')::text)<>{lit(b['unchanged_digest'])} then raise exception 'Reviewed source/scoring drift'; end if;
if a.stem is distinct from b.stem or a.stimulus is distinct from b.stimulus or b.prompt_json->>'mirrored_from_version_id'<>'{aid}' then raise exception 'Not the reviewed mirror'; end if;
if (select jsonb_agg(jsonb_build_object('key',choice_key,'text',choice_text) order by choice_key) from app.mcq_choices where content_item_version_id='{aid}') is distinct from (select jsonb_agg(jsonb_build_object('key',choice_key,'text',choice_text) order by choice_key) from app.mcq_choices where content_item_version_id='{bid}') then raise exception 'Choice text mismatch'; end if;
if (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id='{bid}') is distinct from {lit(b['choice_digest'])} then raise exception 'Choice/scoring drift'; end if;
if app.taxonomy_relevant_hash(b.id)<>{lit(b['taxonomy_hash'])} or (select md5(jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id)::text) from app.content_taxonomy_labels l where l.content_item_id=b.content_item_id) is distinct from {lit(b['labels_digest'])} then raise exception 'Taxonomy/labels drift'; end if;
if not exists(select 1 from app.content_asset_metadata m join storage.objects o on o.bucket_id=m.storage_bucket and o.name=m.storage_path join storage.buckets k on k.id=o.bucket_id where m.content_item_version_id='{aid}' and m.storage_path={lit(path)} and m.storage_bucket='content-assets' and m.approved_at is not null and not k.public) then raise exception 'Approved private source asset absent'; end if;
if exists(select 1 from app.content_asset_metadata where content_item_version_id='{bid}') or exists(select 1 from app.content_visual_requirements where content_item_version_id='{bid}') then raise exception 'Unexpected prior BC metadata/decision'; end if;
end $guard$;
create temporary table mirror_before on commit drop as
select id,md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text) content_digest,app.taxonomy_relevant_hash(v.id) taxonomy_hash from app.content_item_versions v where id in ('{aid}','{bid}');
update app.content_item_versions set stimulus_image_path={lit(path)} where id='{bid}';
insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
select '{bid}',storage_bucket,storage_path,alt_text,long_description,'f5a26c6b-3566-4d58-9e97-979fbb947564',now() from app.content_asset_metadata where content_item_version_id='{aid}' and storage_bucket='content-assets' and storage_path={lit(path)} and approved_at is not null;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at)
values ('{bid}','yes','approved','f5a26c6b-3566-4d58-9e97-979fbb947564',now());
do $verify$ begin
if exists(select 1 from mirror_before h join app.content_item_versions v using(id) where md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)<>h.content_digest or app.taxonomy_relevant_hash(v.id)<>h.taxonomy_hash) then raise exception 'Content/scoring/taxonomy changed'; end if;
if (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id='{bid}') is distinct from {lit(b['choice_digest'])} or (select md5(jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id)::text) from app.content_taxonomy_labels l where l.content_item_id='{b['content_item_id']}') is distinct from {lit(b['labels_digest'])} then raise exception 'Choice/scoring/labels changed'; end if;
if (select count(*) from app.content_asset_metadata where content_item_version_id='{bid}' and storage_bucket='content-assets' and storage_path={lit(path)} and approved_at is not null)<>1 then raise exception 'BC approved metadata incomplete'; end if;
end $verify$;
select now() as attached_at,'apcalcbc-mcq-ab-060' as content_key,'{bid}' as version_id,{lit(path)} as path,true as source_scoring_taxonomy_unchanged;
commit;
"""
(p/'attach.sql').write_text(sql)
(p/'rehearse.sql').write_text(sql.replace('\ncommit;','\nrollback;'))
recovery=f"""-- Non-destructive path recovery. Retain approved metadata and immutable source bytes.
begin;
set local lock_timeout='3s';
do $recover$ begin
perform id from app.content_item_versions where id='{bid}' for update;
if not exists(select 1 from app.content_item_versions v where id='{bid}' and stimulus_image_path={lit(path)} and md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)={lit(b['unchanged_digest'])}) then raise exception 'Recovery source/path drift'; end if;
if not exists(select 1 from app.content_visual_requirements where content_item_version_id='{bid}' and image_needed='yes' and image_approval='approved' and decided_by='f5a26c6b-3566-4d58-9e97-979fbb947564') then raise exception 'Unexpected decision owner'; end if;
update app.content_item_versions set stimulus_image_path=null where id='{bid}';
delete from app.content_visual_requirements where content_item_version_id='{bid}';
end $recover$;
select '{bid}' as version_id,stimulus_image_path,not exists(select 1 from app.content_visual_requirements where content_item_version_id='{bid}') as prior_decision_restored from app.content_item_versions where id='{bid}';
commit;
"""
(p/'recover.sql').write_text(recovery)
(p/'rehearse-recovery.sql').write_text(recovery.replace('\ncommit;','\nrollback;'))
# Freeze only the fields needed to audit the change; omit answer-bearing prompt objects.
for r in rows:
 r.pop('item_package_payload',None)
 r.pop('prompt_json',None)
(p/'reviewed-source.json').write_text(json.dumps(rows,indent=2,ensure_ascii=False)+'\n')
print('Prepared one guarded attachment and one guarded recovery; no database writes.')
