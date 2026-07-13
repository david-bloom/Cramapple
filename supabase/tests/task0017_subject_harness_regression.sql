-- Run after applying the generated Stats plan. All checks are read-only.
do $$
declare v_old uuid; v_new uuid; v_count integer;
begin
  select epv.id into v_old from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id
    where ep.exam_code='ap_statistics' and epv.school_year='2025-26';
  select epv.id into v_new from app.exam_pack_versions epv join app.exam_packs ep on ep.id=epv.exam_pack_id
    where ep.exam_code='ap_statistics' and epv.school_year='2026-27';
  if v_old is null or v_new is null or v_old=v_new then raise exception 'AC3:annual_pack_coexistence_failed'; end if;
  select count(*) into v_count from app.taxonomy_node_versions tnv
    join app.taxonomy_scheme_versions tsv on tsv.taxonomy_scheme_version_id=tnv.taxonomy_scheme_version_id
    join app.taxonomy_schemes ts on ts.taxonomy_scheme_id=tsv.taxonomy_scheme_id
    where ts.exam_pack_version_id=v_old and tnv.node_type='unit';
  if v_count<>9 then raise exception 'AC3:prior_nine_unit_taxonomy_not_preserved_%',v_count; end if;
  select count(*) into v_count from app.taxonomy_node_versions tnv
    join app.taxonomy_scheme_versions tsv on tsv.taxonomy_scheme_version_id=tnv.taxonomy_scheme_version_id
    join app.taxonomy_schemes ts on ts.taxonomy_scheme_id=tsv.taxonomy_scheme_id
    where ts.exam_pack_version_id=v_new;
  if v_count <> 9 then raise exception 'AC3:expected_5_units_plus_4_practices_got_%',v_count; end if;
  select count(*) into v_count from app.content_item_versions civ join app.content_items ci on ci.id=civ.content_item_id
    where ci.exam_pack_version_id=v_new and civ.item_package_payload is not null;
  if v_count <> 4 then raise exception 'H1:expected_4_roundtrip_items_got_%',v_count; end if;
  if exists(select 1 from app.content_item_versions where item_package_payload is not null
    and item_package_payload#>>'{provenance,content_sha256}' <> item_package_sha256) then
    raise exception 'H1:item_roundtrip_hash_mismatch';
  end if;
  if (select jsonb_agg(jsonb_build_object('exam_code',ep.exam_code,'school_year',epv.school_year,
      'content_key',ci.content_key,'stem',civ.stem,'prompt',civ.prompt_json,'hash',civ.content_hash)
      order by ep.exam_code)
    from app.exam_packs ep join app.exam_pack_versions epv on epv.exam_pack_id=ep.id
    join app.content_items ci on ci.exam_pack_version_id=epv.id
    join app.content_item_versions civ on civ.content_item_id=ci.id
    where ci.content_key in ('bio-golden','stats-golden')) is distinct from
    '[{"exam_code":"ap_biology","school_year":"2025-26","content_key":"bio-golden","stem":"Bio payload","prompt":{"answer":"B"},"hash":"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"},
      {"exam_code":"ap_statistics","school_year":"2025-26","content_key":"stats-golden","stem":"Stats payload","prompt":{"answer":"A"},"hash":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}]'::jsonb
  then raise exception 'AC6:golden_semantic_snapshot_changed'; end if;
end $$;

select 'TASK0017_SUBJECT_HARNESS_REGRESSION_PASS' as result;
