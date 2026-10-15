-- Owner-requested Units 1–3 certification: two follow-up attachments.
-- PREPARED ONLY. Independent review and release checks must pass before execution.
begin;
set local lock_timeout='3s';
set local statement_timeout='15s';
create temporary table question_image_targets on commit drop as
select * from jsonb_to_recordset($visuals$[{"content_key": "apcalcab-mcq-060", "version_id": "f492bfbf-5434-434f-a4d8-50b058477139", "stem_md5": "b13447b15aa816e88bb6ded6064dd7ba", "stimulus_md5": "d41d8cd98f00b204e9800998ecf8427e", "path": "questions/apcalcab-mcq-060/v1/aeebaee24dc1fbea1b833ac7e165bf3750c18905daea509843b434d51feec81d.png", "alt": "Coordinate graph of g showing a straight left branch, a curved right branch, an open point at (3, 4), and an isolated filled point at (3, 6).", "long_description": "For x < 3 the graph follows y = x + 1. For x > 3 it follows y = −(x − 3)² + 4. The point (3, 4) is open and (3, 6) is filled. Arrows indicate continuation beyond the displayed window."}, {"content_key": "apchem-frq-u13g-3-8", "version_id": "959822a0-5cd4-4e1f-813e-58241c6c66cf", "stem_md5": "728cf327e2da656a33f3fdd70e3b5835", "stimulus_md5": "1ce2709184c5c754406c3476cb948cbb", "path": "questions/apchem-frq-u13g-3-8/v1/04f69c1149733ea80a002f1704dca6b81c1f02f4a9e008bea36d13796794827b.png", "alt": "Equal-volume solution models P and Q show separated ions. P is labelled 0.30 M NaCl and Q is labelled CaCl₂. Water molecules are omitted.", "long_description": "Model P contains six Na⁺ ions and six Cl⁻ ions. Model Q contains four Ca²⁺ ions and eight Cl⁻ ions. The equal-size boxes represent the same small volume of solution. Each ion is separate; no water molecules, water orientations, or calculated concentrations are shown."}]$visuals$::jsonb)
as r(content_key text,version_id uuid,stem_md5 text,stimulus_md5 text,path text,alt text,long_description text);
do $guard$
begin
  if (select count(*) from question_image_targets) <> 2 then raise exception 'Expected exactly two targets'; end if;
  perform v.id from app.content_item_versions v join question_image_targets t on t.version_id=v.id order by v.id for update of v;
  if (select count(*) from question_image_targets t join app.content_item_versions v on v.id=t.version_id join app.content_items c on c.id=v.content_item_id
      where c.content_key=t.content_key and c.status='published' and v.status='published' and v.stimulus_image_path is null
      and md5(v.stem)=t.stem_md5 and md5(coalesce(v.stimulus,''))=t.stimulus_md5) <> 2
    then raise exception 'Question source/status/path drift: no changes committed'; end if;
  if exists(select 1 from question_image_targets t left join storage.objects o on o.bucket_id='content-assets' and o.name=t.path where o.id is null)
    then raise exception 'Required uploaded object absent'; end if;
  if exists(select 1 from app.content_asset_metadata a join question_image_targets t on t.version_id=a.content_item_version_id)
    then raise exception 'Unexpected pre-existing asset metadata'; end if;
  if exists(select 1 from app.content_visual_requirements r join question_image_targets t on t.version_id=r.content_item_version_id) then raise exception 'Unexpected pre-existing image decision'; end if;
  if not exists(select 1 from app.profiles where user_id='f5a26c6b-3566-4d58-9e97-979fbb947564' and role='admin')
    then raise exception 'Approved owner account unavailable'; end if;
end $guard$;
create temporary table question_image_content_before on commit drop as
select v.id,v.content_item_id,md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text) as content_hash,
 app.taxonomy_relevant_hash(v.id) as taxonomy_hash
from app.content_item_versions v join question_image_targets t on t.version_id=v.id;
create temporary table question_image_labels_before on commit drop as
select l.content_item_id,jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id) as label_rows
from app.content_taxonomy_labels l
where l.content_item_id in (select content_item_id from question_image_content_before)
group by l.content_item_id;
update app.content_item_versions v set stimulus_image_path=t.path
from question_image_targets t where v.id=t.version_id;
insert into app.content_asset_metadata(content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
select version_id,'content-assets',path,alt,long_description,'f5a26c6b-3566-4d58-9e97-979fbb947564',now()
from question_image_targets;
insert into app.content_visual_requirements(content_item_version_id,image_needed,image_approval,decided_by,decided_at)
select version_id,'yes','approved','f5a26c6b-3566-4d58-9e97-979fbb947564',now() from question_image_targets
on conflict(content_item_version_id) do update set image_needed=excluded.image_needed,image_approval=excluded.image_approval,
 decided_by=excluded.decided_by,decided_at=excluded.decided_at;
do $verify$
begin
  if (select count(*) from question_image_targets t join app.content_item_versions v on v.id=t.version_id
    join app.content_asset_metadata a on a.content_item_version_id=v.id and a.storage_bucket='content-assets' and a.storage_path=t.path
    join app.content_visual_requirements r on r.content_item_version_id=v.id
    where v.stimulus_image_path=t.path and a.approved_at is not null and a.approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'
      and a.alt_text=t.alt and a.long_description=t.long_description and r.image_needed='yes' and r.image_approval='approved') <> 2
    then raise exception 'Attachment/approval verification failed'; end if;
  if exists(select 1 from question_image_content_before b join app.content_item_versions v on v.id=b.id
    where md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)<>b.content_hash or app.taxonomy_relevant_hash(v.id)<>b.taxonomy_hash)
    then raise exception 'Question/scoring/taxonomy content changed'; end if;
  if exists(select 1 from question_image_labels_before b where
    (select jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id) from app.content_taxonomy_labels l where l.content_item_id=b.content_item_id)
     is distinct from b.label_rows) then raise exception 'Taxonomy labels changed'; end if;
end $verify$;
rollback;
