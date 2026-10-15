-- Owner-requested Units 1–3 certification: two follow-up attachments.
-- PREPARED ONLY. Independent review and release checks must pass before execution.
begin;
set local lock_timeout='3s';
set local statement_timeout='15s';
create temporary table question_image_targets on commit drop as
select * from jsonb_to_recordset($visuals$[{"content_key":"apcalcab-mcq-060","version_id":"f492bfbf-5434-434f-a4d8-50b058477139","stem_md5":"b13447b15aa816e88bb6ded6064dd7ba","stimulus_md5":"d41d8cd98f00b204e9800998ecf8427e","audit_content_digest":"d3e3e7b8e7861a67230f3fb4182ecf9e","path":"questions/apcalcab-mcq-060/v1/aeebaee24dc1fbea1b833ac7e165bf3750c18905daea509843b434d51feec81d.png","alt":"Coordinate graph of g showing a straight left branch, a curved right branch, an open point at (3, 4), and an isolated filled point at (3, 6).","long_description":"For x < 3 the graph follows y = x + 1. For x > 3 it follows y = −(x − 3)² + 4. The point (3, 4) is open and (3, 6) is filled. Arrows indicate continuation beyond the displayed window.","metadata_md5":"f788712771f66d54e24d08b59eec122e","requirement_md5":"cd05018fd0e748fe1c1538a057eadbf1"},{"content_key":"apchem-frq-u13g-3-8","version_id":"959822a0-5cd4-4e1f-813e-58241c6c66cf","stem_md5":"728cf327e2da656a33f3fdd70e3b5835","stimulus_md5":"1ce2709184c5c754406c3476cb948cbb","audit_content_digest":"61632ec722ec128b424e8741210e062e","path":"questions/apchem-frq-u13g-3-8/v1/04f69c1149733ea80a002f1704dca6b81c1f02f4a9e008bea36d13796794827b.png","alt":"Equal-volume solution models P and Q show separated ions. P is labelled 0.30 M NaCl and Q is labelled CaCl₂. Water molecules are omitted.","long_description":"Model P contains six Na⁺ ions and six Cl⁻ ions. Model Q contains four Ca²⁺ ions and eight Cl⁻ ions. The equal-size boxes represent the same small volume of solution. Each ion is separate; no water molecules, water orientations, or calculated concentrations are shown.","metadata_md5":"a04df0fe601fba46f10fd20cd70a33af","requirement_md5":"6b940926020640139269bcca2681bb9a"}]$visuals$::jsonb)
as r(content_key text,version_id uuid,stem_md5 text,stimulus_md5 text,audit_content_digest text,path text,alt text,long_description text,metadata_md5 text,requirement_md5 text);
do $guard$
begin
 if (select count(*) from question_image_targets)<>2 then raise exception 'Expected two recovery targets'; end if;
 perform v.id from app.content_item_versions v join question_image_targets t on v.id=t.version_id order by v.id for update of v;
 perform c.choice_key from app.mcq_choices c join question_image_targets t on t.version_id=c.content_item_version_id order by c.choice_key for update of c;
 perform m.content_item_version_id from app.content_asset_metadata m join question_image_targets t on t.version_id=m.content_item_version_id order by m.content_item_version_id for update of m;
 perform r.content_item_version_id from app.content_visual_requirements r join question_image_targets t on t.version_id=r.content_item_version_id order by r.content_item_version_id for update of r;
 if (select count(*) from question_image_targets t join app.content_item_versions v on v.id=t.version_id join app.content_items c on c.id=v.content_item_id
 join app.content_asset_metadata m on m.content_item_version_id=v.id and m.storage_bucket='content-assets' and m.storage_path=t.path
 join app.content_visual_requirements r on r.content_item_version_id=v.id
 where c.content_key=t.content_key and v.stimulus_image_path=t.path and md5(jsonb_build_object('stem',v.stem,'stimulus',v.stimulus,
 'choices',coalesce((select jsonb_agg(jsonb_build_object('key',c.choice_key,'text',c.choice_text) order by c.choice_key) from app.mcq_choices c where c.content_item_version_id=v.id),'[]'::jsonb),
 'parts',coalesce((select jsonb_agg(jsonb_build_object('key',coalesce(p.part->>'part_key',p.part->>'part_id',p.ordinality::text),'text',coalesce(nullif(p.part->>'prompt',''),p.part->>'prompt_text')) order by p.ordinality)
 from jsonb_array_elements(case when jsonb_typeof(v.prompt_json->'parts')='array' then v.prompt_json->'parts' when jsonb_typeof(v.item_package_payload->'parts')='array' then v.item_package_payload->'parts' else '[]'::jsonb end) with ordinality as p(part,ordinality)
 where jsonb_typeof(p.part)='object' and (jsonb_typeof(p.part->'prompt')='string' or jsonb_typeof(p.part->'prompt_text')='string') and nullif(btrim(coalesce(nullif(p.part->>'prompt',''),p.part->>'prompt_text')),'') is not null),'[]'::jsonb),
 'prompt',v.prompt_json,'package',v.item_package_payload,'image_path',null::text)::text)=t.audit_content_digest and md5(to_jsonb(m)::text)=t.metadata_md5 and md5(to_jsonb(r)::text)=t.requirement_md5)<>2
 then raise exception 'Recovery source/metadata/decision ownership drift: no changes committed'; end if;
end $guard$;
update app.content_item_versions v set stimulus_image_path=null from question_image_targets t where t.version_id=v.id;
delete from app.content_asset_metadata m using question_image_targets t where m.content_item_version_id=t.version_id and m.storage_bucket='content-assets' and m.storage_path=t.path;
delete from app.content_visual_requirements r using question_image_targets t where r.content_item_version_id=t.version_id;
commit;
