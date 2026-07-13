-- Seed the actual prior nine-unit AP Statistics taxonomy after H1 creates the
-- versioned taxonomy tables and before the 2026-27 package is applied.
do $$
declare v_scheme uuid; v_version uuid; v_unit integer;
begin
  insert into app.taxonomy_schemes(exam_pack_version_id,scheme_key,created_by)
  values('30000000-0000-0000-0000-000000000001','ap-statistics-nine-unit','00000000-0000-0000-0000-000000000001')
  returning taxonomy_scheme_id into v_scheme;
  insert into app.taxonomy_scheme_versions(taxonomy_scheme_id,semantic_version,schema_version,definition_sha256,created_by)
  values(v_scheme,'1.0.0','legacy-1.0',repeat('9',64),'00000000-0000-0000-0000-000000000001')
  returning taxonomy_scheme_version_id into v_version;
  for v_unit in 1..9 loop
    insert into app.taxonomy_node_versions(taxonomy_scheme_version_id,node_key,node_type,label,ordinal,node_sha256,created_by)
    values(v_version,'unit-'||v_unit,'unit','Legacy AP Statistics Unit '||v_unit,v_unit,
      encode(extensions.digest('legacy-unit-'||v_unit,'sha256'),'hex'),'00000000-0000-0000-0000-000000000001');
  end loop;
end $$;
