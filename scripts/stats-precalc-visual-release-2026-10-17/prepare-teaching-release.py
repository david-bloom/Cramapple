import json
from pathlib import Path
p=Path(__file__).parent;plan=json.loads((p/'release-plan.json').read_text());t=[x for x in plan if x['kind']=='teaching_image'];assert len(t)==3
setup=f'''-- APPROVAL-0194: 3 teaching image attachments; no question re-authoring.
begin; set local lock_timeout='3s'; set local statement_timeout='30s';
create temporary table targets on commit drop as select * from jsonb_to_recordset($t${json.dumps(t)}$t$::jsonb) as t(content_key text,old_version_id uuid,version_hash text,item_hash text,choices_hash text,old_taxonomy_hash text,old_path text,storage_path text,sha256 text,bytes bigint,alt_text text,long_description text);
'''
guard='''do $g$ begin
perform v.id from app.content_item_versions v join targets t on t.old_version_id=v.id order by v.id for update of v;
if (select count(*) from targets t join app.content_item_versions v on v.id=t.old_version_id join app.content_items ci on ci.id=v.content_item_id where ci.content_key=t.content_key and ci.status='published' and v.status='published' and md5(to_jsonb(v)::text)=t.version_hash and md5(to_jsonb(ci)::text)=t.item_hash and (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id=v.id)=t.choices_hash)<>3 then raise exception 'Teaching source/key/item drift'; end if;
if exists(select 1 from targets t join app.content_asset_metadata a on a.content_item_version_id=t.old_version_id) or exists(select 1 from targets t join app.content_visual_requirements r on r.content_item_version_id=t.old_version_id) then raise exception 'Teaching visual decision drift'; end if;
if exists(select 1 from targets t left join storage.objects o on o.bucket_id='content-assets' and o.name=t.storage_path left join storage.buckets b on b.id=o.bucket_id where o.id is null or b.public is distinct from false or (o.metadata->>'size')::bigint<>t.bytes or o.metadata->>'mimetype'<>'image/png') then raise exception 'Teaching private asset drift'; end if;
end $g$;
create temporary table original on commit drop as select v.id,to_jsonb(v) data from app.content_item_versions v join targets t on t.old_version_id=v.id;
'''
write='''update app.content_item_versions v set stimulus_image_path=t.storage_path from targets t where v.id=t.old_version_id;
insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at) select old_version_id,'content-assets',storage_path,alt_text,long_description,'f5a26c6b-3566-4d58-9e97-979fbb947564',now() from targets;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at) select old_version_id,'yes','approved','f5a26c6b-3566-4d58-9e97-979fbb947564',now() from targets;
'''
verify='''do $v$ begin
if (select count(*) from targets t join app.content_item_versions v on v.id=t.old_version_id join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_path=v.stimulus_image_path join app.content_visual_requirements r on r.content_item_version_id=v.id where v.status='published' and v.stimulus_image_path=t.storage_path and a.approved_at is not null and a.alt_text=t.alt_text and r.image_needed='yes' and r.image_approval='approved')<>3 then raise exception 'Teaching image delivery contract incomplete'; end if;
if exists(select 1 from targets t join app.content_item_versions v on v.id=t.old_version_id join original o on o.id=v.id where (to_jsonb(v)-'stimulus_image_path'-'updated_at')<>(o.data-'stimulus_image_path'-'updated_at') or app.taxonomy_relevant_hash(v.id)<>t.old_taxonomy_hash or (select md5(jsonb_agg(to_jsonb(c) order by c.choice_key)::text) from app.mcq_choices c where c.content_item_version_id=v.id)<>t.choices_hash) then raise exception 'Teaching content/key/taxonomy changed'; end if;
end $v$;
'''
restore='''update app.content_item_versions v set stimulus_image_path=t.old_path from targets t where v.id=t.old_version_id and v.stimulus_image_path=t.storage_path;
delete from app.content_visual_requirements r using targets t where r.content_item_version_id=t.old_version_id and r.decided_by='f5a26c6b-3566-4d58-9e97-979fbb947564' and r.image_needed='yes' and r.image_approval='approved';
do $r$ begin if (select count(*) from targets t join app.content_item_versions v on v.id=t.old_version_id where v.stimulus_image_path is not distinct from t.old_path and v.status='published')<>3 then raise exception 'Teaching recovery incomplete'; end if; end $r$;
'''
receipt="select jsonb_build_object('checked_at',now(),'approval','APPROVAL-0194','teaching_images',3,'question_scoring_taxonomy_unchanged',true) as result;\n"
(p/'publish-teaching.sql').write_text(setup+guard+write+verify+receipt+'commit;\n')
(p/'rehearse-teaching.sql').write_text(setup+guard+write+verify+restore+receipt+'rollback;\n')
(p/'recover-teaching.sql').write_text(setup+"do $g$ begin if (select count(*) from targets t join app.content_item_versions v on v.id=t.old_version_id where v.status='published' and v.stimulus_image_path=t.storage_path and app.taxonomy_relevant_hash(v.id)=t.old_taxonomy_hash)<>3 then raise exception 'Exact teaching recovery guard'; end if; end $g$;\n"+restore+'commit;\n')
# Partition the already-rehearsed batch; keep complete source plan for combined verification.
for src,dst in [('publish-production.sql','publish-choices.sql'),('rehearse.sql','rehearse-choices.sql'),('recover-production.sql','recover-choices.sql')]:
 s=(p/src).read_text();old='$packet$'+json.dumps(plan,ensure_ascii=False)+'$packet$';new='$packet$'+json.dumps([x for x in plan if x['kind']=='choice_repair'],ensure_ascii=False)+'$packet$';assert old in s;s=s.replace(old,new).replace('<>23','<>20').replace("'approved_images',23","'approved_images',20").replace("'teaching_images',3","'teaching_images',0");(p/dst).write_text(s)
print('Prepared independent 3-teaching and 20-choice releases/recovery.')
