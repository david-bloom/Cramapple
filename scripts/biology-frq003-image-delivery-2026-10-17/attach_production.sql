-- APPROVAL-0184: exact two-version image availability repair, Production.
begin;
set local lock_timeout='3s';
set local statement_timeout='20s';
create temporary table bio003_targets on commit drop as
select * from jsonb_to_recordset($bio003$[{"content_key": "APBIO-FRQ-S-003", "version_id": "c4da3229-8d7a-4cf9-8738-68b62af20372", "old_path": "Biology/FRQ/APBIO-FRQ-S-003.png", "path": "questions/apbio-frq-s-003/v2/f36f0e3337f393e1652e4d547eda5f2ac651fc740d56b13cc685aec8d73f8100.png", "full_version_hash": "2506aee360ccd92554fa12be5bf39857", "content_hash": "c483265f621a9bce4ac400d84d987531", "taxonomy_hash": "5a2e32068b6b7c0a593059b12ee41efd7d7a36a94e9c1b554deee2fe9be4e6dc", "criteria_hash": "38adaa3a10960f127dc3acaf479995b6", "label_hash": "6cb8a9a3efc20a6e458f3548206f9658", "alt": "Light-dependent photosynthesis schematic across a thylakoid membrane. Photosystem II, an electron transport chain, photosystem I and ATP synthase are shown. Lumen and stroma are labeled.", "description": "The thylakoid membrane is a vertical band, with lumen on the left and stroma on the right. Light reaches photosystem II and photosystem I. Electron arrows connect photosystem II to the electron transport chain, then to photosystem I and onward to NADP plus on the stroma side, where NADPH is formed. A proton arrow at the electron transport chain runs from stroma to lumen. A proton arrow through ATP synthase runs from lumen to stroma. ADP plus inorganic phosphate and ATP are shown on the stroma side. The diagram is schematic and does not specify molecule counts.", "expected_bytes": 80199, "sha256": "f36f0e3337f393e1652e4d547eda5f2ac651fc740d56b13cc685aec8d73f8100"}, {"content_key": "APBIO-FRQ-L-003", "version_id": "0c9b6720-639f-4dc4-8fab-c66e65271b1d", "old_path": "Biology/FRQ/APBIO-FRQ-L-003.png", "path": "Biology/FRQ/APBIO-FRQ-L-003.png", "full_version_hash": "09254a67722c70fa6014977cac8d5a44", "content_hash": "dbb4825e5f3b5f00335ebbc937bd3d9e", "taxonomy_hash": "d73b5c12d9688e216bc3c88b68b62533a5b43c8687e21fa394de3a60401f08ea", "criteria_hash": "01f72fc6130758ff6fc7a747cbdd82f4", "label_hash": "3efa8d0518dbc4191db81c16bdfbe2ee", "alt": "Three-generation pedigree for Syndrome X. Squares represent males, circles females, and filled symbols affected individuals.", "description": "Generation I: I-1 is an affected female and I-2 an unaffected male; they are connected to the six Generation II individuals. II-1 is an affected male, II-2 an unaffected female, II-3 an affected female, II-4 an unaffected male, II-5 an unaffected male, and II-6 an unaffected female. II-3 and II-4 are connected as a couple, with four Generation III children: III-1 unaffected male, III-2 affected female, III-3 unaffected male, III-4 unaffected female. The legend explains sex and affected status. The question text separately states that II-4 is a known carrier; carrier status is not shaded in this diagram.", "expected_bytes": 50281, "sha256": "6cf98d6964144ae0946c729176917120efe1a0925454eb443ff5b88a02f8553c"}]$bio003$::jsonb)
as t(content_key text,version_id uuid,old_path text,path text,full_version_hash text,content_hash text,taxonomy_hash text,criteria_hash text,label_hash text,alt text,description text,expected_bytes int,sha256 text);
do $guard$ begin
if (select count(*) from bio003_targets)<>2 then raise exception 'Expected exactly two targets'; end if;
if not exists(select 1 from app.profiles where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564' and role='admin') then raise exception 'Recorded owner approver unavailable'; end if;
perform v.id from app.content_item_versions v join bio003_targets t on t.version_id=v.id order by v.id for update of v;
if (select count(*) from bio003_targets t join app.content_item_versions v on v.id=t.version_id join app.content_items ci on ci.id=v.content_item_id where ci.content_key=t.content_key and ci.status='published' and v.status='published' and v.stimulus_image_path=t.old_path and md5(to_jsonb(v)::text)=t.full_version_hash)<>2 then raise exception 'Reviewed version/path/source drift'; end if;
if exists(select 1 from app.content_asset_metadata a join bio003_targets t on t.version_id=a.content_item_version_id) then raise exception 'Unexpected existing metadata; do not overwrite'; end if;
if exists(select 1 from app.content_visual_requirements r join bio003_targets t on t.version_id=r.content_item_version_id) then raise exception 'Unexpected visual decision; do not overwrite'; end if;
if exists(select 1 from bio003_targets t left join storage.objects o on o.bucket_id='content-assets' and o.name=t.path left join storage.buckets b on b.id=o.bucket_id where o.id is null or b.public is distinct from false or (o.metadata->>'size')::bigint<>t.expected_bytes or o.metadata->>'mimetype'<>'image/png') then raise exception 'Reviewed private object absent or changed'; end if;
end $guard$;
create temporary table bio003_before on commit drop as
select v.id,v.content_item_id,md5(to_jsonb(ci)::text) item_hash,
md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text) content_hash,
app.taxonomy_relevant_hash(v.id) taxonomy_hash,
(select md5(coalesce(jsonb_agg(to_jsonb(f) order by to_jsonb(f)::text),'[]'::jsonb)::text) from app.frq_criteria f where f.content_item_version_id=v.id) criteria_hash,
(select md5(coalesce(jsonb_agg(to_jsonb(l) order by to_jsonb(l)::text),'[]'::jsonb)::text) from app.content_taxonomy_labels l where l.content_item_id=ci.id) label_hash
from app.content_item_versions v join app.content_items ci on ci.id=v.content_item_id join bio003_targets t on t.version_id=v.id;
create temporary table bio003_retired_control on commit drop as
select md5(to_jsonb(v)::text) version_hash,
(select md5(to_jsonb(r)::text) from app.content_visual_requirements r where r.content_item_version_id=v.id) requirement_hash,
(select md5(coalesce(jsonb_agg(to_jsonb(a) order by to_jsonb(a)::text),'[]'::jsonb)::text) from app.content_asset_metadata a where a.content_item_version_id=v.id) metadata_hash
from app.content_item_versions v where v.id='71162c8c-3abe-44be-b98e-abbf88422ea1';
do $baseline$ begin
if exists(select 1 from bio003_before b join bio003_targets t on t.version_id=b.id where b.content_hash<>t.content_hash or b.taxonomy_hash<>t.taxonomy_hash or b.criteria_hash<>t.criteria_hash or b.label_hash<>t.label_hash) then raise exception 'Reviewed scoring/taxonomy/labels drift'; end if;
end $baseline$;
update app.content_item_versions v set stimulus_image_path=t.path from bio003_targets t where v.id=t.version_id and v.stimulus_image_path is distinct from t.path;
insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
select version_id,'content-assets',path,alt,description,'f5a26c6b-3566-4d58-9e97-979fbb947564',now() from bio003_targets;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at)
select version_id,'yes','approved','f5a26c6b-3566-4d58-9e97-979fbb947564',now() from bio003_targets;
do $verify$ begin
if (select count(*) from bio003_targets t join app.content_item_versions v on v.id=t.version_id join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_bucket='content-assets' and a.storage_path=t.path join app.content_visual_requirements r on r.content_item_version_id=v.id where v.stimulus_image_path=t.path and a.alt_text=t.alt and a.long_description=t.description and a.approved_at is not null and a.approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564' and r.image_needed='yes' and r.image_approval='approved')<>2 then raise exception 'Servable metadata incomplete'; end if;
if exists(select 1 from bio003_before b join app.content_item_versions v on v.id=b.id join app.content_items ci on ci.id=v.content_item_id
where md5(to_jsonb(ci)::text)<>b.item_hash or md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)<>b.content_hash or app.taxonomy_relevant_hash(v.id)<>b.taxonomy_hash
or (select md5(coalesce(jsonb_agg(to_jsonb(f) order by to_jsonb(f)::text),'[]'::jsonb)::text) from app.frq_criteria f where f.content_item_version_id=v.id)<>b.criteria_hash
or (select md5(coalesce(jsonb_agg(to_jsonb(l) order by to_jsonb(l)::text),'[]'::jsonb)::text) from app.content_taxonomy_labels l where l.content_item_id=ci.id)<>b.label_hash) then raise exception 'Question/scoring/taxonomy/label mutation'; end if;
if exists(select 1 from bio003_retired_control b cross join app.content_item_versions v where v.id='71162c8c-3abe-44be-b98e-abbf88422ea1' and
(md5(to_jsonb(v)::text)<>b.version_hash or (select md5(to_jsonb(r)::text) from app.content_visual_requirements r where r.content_item_version_id=v.id) is distinct from b.requirement_hash
or (select md5(coalesce(jsonb_agg(to_jsonb(a) order by to_jsonb(a)::text),'[]'::jsonb)::text) from app.content_asset_metadata a where a.content_item_version_id=v.id)<>b.metadata_hash)) then raise exception 'Retired review/control changed'; end if;
end $verify$;
select jsonb_build_object('checked_at',now(),'project_ref','pcntajvbdfqhbeewmdry','versions',2,'approved_metadata',2,'required_approved_visuals',2,'content_scoring_taxonomy_labels_unchanged',true,'retired_control_unchanged',true) as result;
commit;
