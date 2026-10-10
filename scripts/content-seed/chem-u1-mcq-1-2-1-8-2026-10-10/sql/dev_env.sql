select
 (select json_agg(distinct c.taxonomy_source_version) from app.content_item_cells c join app.content_items ci on ci.id = c.content_item_id
   where ci.exam_pack_version_id = '1f2d6d5b-1d90-4d08-b323-93fddd773bcd' and c.superseded_by is null) tsvs,
 exists(select 1 from app.profiles where user_id = 'f5a26c6b-3566-4d58-9e97-979fbb947564') owner_ok,
 (select json_agg(m.allowed_unit_numbers) from app.home_release_manifest m where m.exam_pack_version_id = '1f2d6d5b-1d90-4d08-b323-93fddd773bcd') manifest,
 (select json_agg(json_build_object('tsv', tc.taxonomy_source_version, 'topic', tc.topic_code, 'skill', tc.skill_code))
   from app.taxonomy_cells tc where tc.topic_code in ('1.2', '1.8')) grid
