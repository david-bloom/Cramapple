-- APPROVAL-0168: four exact-version question-image attachments, no schema change.
begin;
set local lock_timeout='3s';
set local statement_timeout='15s';
create temporary table question_image_targets on commit drop as
select * from jsonb_to_recordset($visuals$[{"content_key":"apcalcab-frq-u13-002","version_id":"d0f2974c-bac9-498d-8173-8a1c88b3d8eb","stem_md5":"8069b23c1c433bdde1511dad8465b4b1","stimulus_md5":"4b79f9f4b3315ca3133a49723ff0d330","path":"questions/apcalcab-frq-u13-002/v1/63000031e6860d5fd51bf8f10c6fafa9d64bf3fcda059933414c712c69eec674.png","alt":"Coordinate graph of g on the interval from −4 to 4. Three line segments and open and filled endpoint markers are shown.","long_description":"The graph contains a segment from the filled point (−4, −2) to an open point at (−1, 4); a filled point at (−1, 1); a horizontal segment for −1 < x < 2 at height 1 with an open point at (2, 1); and a segment from the filled point (2, 3) to the filled point (4, −1)."},{"content_key":"apcalcab-frq-u13g-1-3","version_id":"a59eb1ed-b96e-4d89-94ee-a4a32b309744","stem_md5":"0381de1bc706fd29cf05cfca853f251a","stimulus_md5":"51a4215de1a2b9accad5acdfcae4616e","path":"questions/apcalcab-frq-u13g-1-3/v1/c49e3a59682394ec52b3b72b4186c86ab7f46ab1bc9e00d1f6c0fce8a6f3f257.png","alt":"Coordinate graph of g from −4 to 6, with two line segments, isolated filled points, two curved branches and a dashed vertical line at x = 4.","long_description":"A segment runs from filled (−4, 0) to open (−1, 3), with an isolated filled point at (−1, 1). Another segment runs from open (−1, −2) to open (2, 4); (2, 0) is filled. On 2 < x < 4 a continuous increasing curve starts near (2, 4) and continues upward beside x = 4. On 4 < x ≤ 6 a continuous decreasing curve continues upward beside x = 4 and ends at filled (6, 1). There is no point at x = 4."},{"content_key":"apcalcab-oht-1.3","version_id":"f1548706-2043-4f7b-9941-c1c6e2724174","stem_md5":"1a07979333221f2263d29b40f0093127","stimulus_md5":"d41d8cd98f00b204e9800998ecf8427e","path":"questions/apcalcab-oht-1.3/v1/76c37ed79953f2a2dbad6a958275ef7f817edd7e0d62039f121c9563427a6fbe.png","alt":"Coordinate graph of p showing a straight left branch, a filled point at (3, 5), and a curved right branch beginning at an open point at (3, 2).","long_description":"For x < 3, the graph follows y = x + 2. The point (3, 5) is filled. For x > 3, the graph follows y = x² − 7 and has an open point at (3, 2). Arrows indicate continuation beyond the displayed window."},{"content_key":"apchem-oht-3.8","version_id":"b7b068cb-0610-4da7-8565-4290621d402f","stem_md5":"61a10efaee486e2ef9b314b93163375b","stimulus_md5":"d41d8cd98f00b204e9800998ecf8427e","path":"questions/apchem-oht-3.8/v1/61f844d30f28abd72d1293e09f543d25be8a9e8b2bcd00305c983d27d7b30c45.png","alt":"Two solution diagrams use identical dots for the same solute. Diagram 1 is labelled 100 mL and contains eight dots; diagram 2 is labelled 200 mL and contains sixteen dots.","long_description":"Diagram 1 contains eight solute particles in a box representing 100 mL of solution. Diagram 2 contains sixteen particles of the same solute in a box representing 200 mL. Dots have the same size in both diagrams. The boxes are schematic; the printed volumes are the stated solution volumes. No concentration comparison is labelled."}]$visuals$::jsonb)
as r(content_key text,version_id uuid,stem_md5 text,stimulus_md5 text,path text,alt text,long_description text);
do $guard$
begin
  if (select count(*) from question_image_targets) <> 4 then raise exception 'Expected exactly four targets'; end if;
  perform v.id from app.content_item_versions v join question_image_targets t on t.version_id=v.id order by v.id for update of v;
  if (select count(*) from question_image_targets t join app.content_item_versions v on v.id=t.version_id join app.content_items c on c.id=v.content_item_id
      where c.content_key=t.content_key and c.status='published' and v.status='published' and v.stimulus_image_path is null
      and md5(v.stem)=t.stem_md5 and md5(coalesce(v.stimulus,''))=t.stimulus_md5) <> 4
    then raise exception 'Question source/status/path drift: no changes committed'; end if;
  if exists(select 1 from question_image_targets t left join storage.objects o on o.bucket_id='content-assets' and o.name=t.path where o.id is null)
    then raise exception 'Required uploaded object absent'; end if;
  if exists(select 1 from app.content_asset_metadata a join question_image_targets t on t.version_id=a.content_item_version_id)
    then raise exception 'Unexpected pre-existing asset metadata'; end if;
  if (select count(*) from app.content_visual_requirements r join question_image_targets t on t.version_id=r.content_item_version_id) <> 1
    or not exists(select 1 from app.content_visual_requirements where content_item_version_id='d0f2974c-bac9-498d-8173-8a1c88b3d8eb'
      and image_needed='no_not_needed' and image_approval is null)
    then raise exception 'Visual requirement decision drift'; end if;
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
      and a.alt_text=t.alt and a.long_description=t.long_description and r.image_needed='yes' and r.image_approval='approved') <> 4
    then raise exception 'Attachment/approval verification failed'; end if;
  if exists(select 1 from question_image_content_before b join app.content_item_versions v on v.id=b.id
    where md5((to_jsonb(v)-'stimulus_image_path'-'updated_at')::text)<>b.content_hash or app.taxonomy_relevant_hash(v.id)<>b.taxonomy_hash)
    then raise exception 'Question/scoring/taxonomy content changed'; end if;
  if exists(select 1 from question_image_labels_before b where
    (select jsonb_agg(to_jsonb(l) order by l.content_taxonomy_label_id) from app.content_taxonomy_labels l where l.content_item_id=b.content_item_id)
     is distinct from b.label_rows) then raise exception 'Taxonomy labels changed'; end if;
end $verify$;
commit;
