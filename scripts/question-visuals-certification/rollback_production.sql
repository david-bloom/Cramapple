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
 if (select count(*) from question_image_targets t join app.content_item_versions v on v.id=t.version_id where v.stimulus_image_path=t.path) <> 2 then raise exception 'Recovery paths drifted'; end if;
end $guard$;
update app.content_item_versions v set stimulus_image_path=null from question_image_targets t where t.version_id=v.id;
delete from app.content_asset_metadata m using question_image_targets t where m.content_item_version_id=t.version_id and m.storage_bucket='content-assets' and m.storage_path=t.path;
delete from app.content_visual_requirements r using question_image_targets t where r.content_item_version_id=t.version_id and r.image_needed='yes' and r.image_approval='approved';
commit;
