"""Prepare the owner-requested horizontal revision; never replay the v2 release."""
import json
from pathlib import Path
p=Path(__file__).parent
before=json.loads((p/'horizontal-before.json').read_text())
m=json.loads((p/'horizontal-manifest.json').read_text())
s=next(x for x in before if x['version_id']==m['version_id'])
assert s['status']=='published' and s['version_num']==2
q=lambda x:"'"+x.replace("'","''")+"'"
new=q(m['path']);old=q(s['stimulus_image_path']);vid=q(m['version_id'])
alt=q(m['alt_text']);desc=q(m['long_description'])
setup=f'''-- APPROVAL-0190 horizontal extension. Current published S-003 v2 only.
begin;
set local lock_timeout='3s';
set local statement_timeout='20s';
create temporary table horizontal_baseline on commit drop as
select * from jsonb_to_recordset($baseline${json.dumps(before)}$baseline$::jsonb)
as t(content_key text,version_id uuid,version_num int,status text,stimulus_image_path text,full_version_hash text,item_hash text,content_hash text,taxonomy_hash text,criteria_hash text,label_hash text,assets_hash text,requirement_hash text);
'''
common=f'''
if (select count(*) from horizontal_baseline b join app.content_item_versions v on v.id=b.version_id)<>4 then raise exception 'Expected four bounded source/control versions'; end if;
if not exists(select 1 from app.profiles where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564' and role='admin') then raise exception 'Owner profile guard'; end if;
if (select count(*) from app.content_item_versions v join app.content_items ci on ci.id=v.content_item_id where v.id={vid} and ci.content_key='APBIO-FRQ-S-003' and ci.status='published' and v.status='published')<>1 then raise exception 'Current published target drift'; end if;
if exists(select 1 from horizontal_baseline b join app.content_item_versions v on v.id=b.version_id join app.content_items ci on ci.id=v.content_item_id where
md5(to_jsonb(ci)::text)<>b.item_hash or md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)<>b.content_hash or app.taxonomy_relevant_hash(v.id)<>b.taxonomy_hash
or (select md5(coalesce(jsonb_agg(to_jsonb(f) order by to_jsonb(f)::text),'[]'::jsonb)::text) from app.frq_criteria f where f.content_item_version_id=v.id)<>b.criteria_hash
or (select md5(coalesce(jsonb_agg(to_jsonb(l) order by to_jsonb(l)::text),'[]'::jsonb)::text) from app.content_taxonomy_labels l where l.content_item_id=ci.id)<>b.label_hash
or (v.id<>{vid}::uuid and md5(to_jsonb(v)::text)<>b.full_version_hash)
or (select md5(coalesce(jsonb_agg(to_jsonb(a) order by to_jsonb(a)::text),'[]'::jsonb)::text) from app.content_asset_metadata a where a.content_item_version_id=v.id and a.storage_path<>{new})<>b.assets_hash
or (select md5(to_jsonb(r)::text) from app.content_visual_requirements r where r.content_item_version_id=v.id) is distinct from b.requirement_hash) then raise exception 'Source/scoring/taxonomy/labels/history/decisions drift'; end if;
'''
lock='''perform v.id from app.content_item_versions v join horizontal_baseline b on b.version_id=v.id order by v.id for update of v;
perform a.content_asset_metadata_id from app.content_asset_metadata a join horizontal_baseline b on b.version_id=a.content_item_version_id order by a.content_asset_metadata_id for update of a;
perform r.content_item_version_id from app.content_visual_requirements r join horizontal_baseline b on b.version_id=r.content_item_version_id order by r.content_item_version_id for update of r;
'''
guard=f'''do $guard$ begin
{lock}{common}
if exists(select 1 from horizontal_baseline b join app.content_item_versions v on v.id=b.version_id where md5(to_jsonb(v)::text)<>b.full_version_hash) then raise exception 'Fresh full-version pin drift'; end if;
if exists(select 1 from app.content_asset_metadata where content_item_version_id={vid} and storage_path={new}) then raise exception 'Horizontal metadata already exists'; end if;
if not exists(select 1 from storage.objects o join storage.buckets b on b.id=o.bucket_id where o.bucket_id='content-assets' and o.name={new} and b.public=false and (o.metadata->>'size')::bigint={m['bytes']} and o.metadata->>'mimetype'='image/png') then raise exception 'Exact private horizontal object absent'; end if;
end $guard$;
'''
write=f'''insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
values({vid},'content-assets',{new},{alt},{desc},'f5a26c6b-3566-4d58-9e97-979fbb947564',now());
update app.content_item_versions set stimulus_image_path={new} where id={vid} and stimulus_image_path={old};
'''
verify=f'''do $verify$ begin
{common}
if not exists(select 1 from app.content_item_versions v join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_path=v.stimulus_image_path join app.content_visual_requirements r on r.content_item_version_id=v.id where v.id={vid} and v.stimulus_image_path={new} and a.storage_bucket='content-assets' and a.alt_text={alt} and a.long_description={desc} and a.approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564' and a.approved_at is not null and r.image_needed='yes' and r.image_approval='approved') then raise exception 'Horizontal delivery contract incomplete'; end if;
end $verify$;
'''
receipt="select jsonb_build_object('checked_at',now(),'operation','horizontal S-003 published v2 path swap','versions_changed',1,'approved_metadata_added',1,'existing_metadata_and_decisions_unchanged',true,'source_scoring_taxonomy_labels_controls_unchanged',true,'retired_s003_and_all_l003_unchanged',true) as result;\n"
(p/'horizontal-attach-production.sql').write_text(setup+guard+write+verify+receipt+'commit;\n')
restore=f"update app.content_item_versions set stimulus_image_path={old} where id={vid} and stimulus_image_path={new};\n"
restorecheck=f'''do $recovery$ begin
{common}
if not exists(select 1 from app.content_item_versions v join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_path=v.stimulus_image_path where v.id={vid} and v.stimulus_image_path={old} and a.approved_at is not null) then raise exception 'Prior tall image recovery failed'; end if;
end $recovery$;
'''
(p/'horizontal-rehearse.sql').write_text(setup+guard+write+verify+restore+restorecheck+receipt.replace("'operation','horizontal S-003 published v2 path swap'","'operation','horizontal attach and path recovery rehearsal ROLLBACK'")+'rollback;\n')
(p/'horizontal-recovery.sql').write_text(setup+'do $guard$ begin\n'+lock+common+f"if not exists(select 1 from app.content_item_versions where id={vid} and stimulus_image_path={new}) then raise exception 'Recovery exact-path guard'; end if;\nend $guard$;\n"+restore+restorecheck+"-- Retain both approved immutable assets and all approval history.\ncommit;\n")
print('Prepared current-v2-only horizontal attach, rehearsal and additive-history recovery.')
