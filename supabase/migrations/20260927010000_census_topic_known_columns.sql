-- CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md Phase 4, revised.
-- David's decision #4 (same session, corrected from an initial "hard gate"
-- answer): the publish gate is SOFT, validated through the existing
-- double-AI-model/second-source protocol, not a hard block. Phase 4's real
-- deliverable is therefore monitoring, not enforcement: risk #5 in the
-- plan's §8 named this exact gap -- "launch readiness is being reported from
-- a census that cannot see topics" -- so app.servable_items_census() gains
-- two columns:
--   topic_known           -- any primary content_item_cells row exists,
--                            regardless of assignment_status (a monitoring
--                            count -- deliberately NOT the same
--                            validated/authored filter the student-facing
--                            content_item_topic_resolution view uses, so
--                            provisional work-in-progress is visible here
--                            even though it isn't served to students yet).
--   topic_known_skill_level -- the same, narrowed to skill_code IS NOT NULL
--                            (today: only the AP Statistics pilot's 203
--                            authored cells).
--
-- Applied directly to Production only. app.taxonomy_relevant_hash() and
-- app.servable_items_census() itself do not exist on Dev at all (a
-- pre-existing Dev/Prod drift, not something this migration introduces or
-- attempts to fix) -- this is a read-only, purely additive function change
-- (no data mutation), so skipping the Dev rehearsal for this one step is a
-- deliberate, lower-risk call, not an oversight.
begin;

drop function app.servable_items_census();

create function app.servable_items_census()
returns table(
  exam_code text,
  exam_pack_version_id uuid,
  published_items integer,
  unit_gated_servable integer,
  practice_targeted_drill integer,
  practice_full_exam_frq integer,
  serving_labels_total integer,
  serving_labels_validated integer,
  serving_label_hash_mismatch integer,
  items_with_no_serving_label integer,
  latest_version_not_published integer,
  topic_known integer,
  topic_known_skill_level integer
)
language sql
stable security definer
set search_path to 'pg_catalog'
as $function$
  with latest as (
    select distinct on (civ.content_item_id) civ.*
    from app.content_item_versions civ
    order by civ.content_item_id, civ.version_num desc
  ), active_labels as (
    select distinct on (ctl.content_item_id) ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.label_scope = 'serving'
      and ctl.label_status = 'validated'
      and ctl.superseded_by is null
    order by ctl.content_item_id, ctl.label_version desc
  ), any_label as (
    select distinct on (ctl.content_item_id) ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.label_scope = 'serving' and ctl.superseded_by is null
    order by ctl.content_item_id, ctl.label_version desc
  ), packs as (
    select ep.exam_code, epv.id as epv,
           coalesce((select max(u) from unnest(m.allowed_unit_numbers) u), 0) as top_unit
    from app.exam_packs ep
    join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
    left join app.home_release_manifest m on m.exam_pack_version_id = epv.id
  )
  select
    p.exam_code,
    p.epv,
    (select count(*)::int from app.content_items ci join latest civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'),
    (select count(*)::int
       from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join active_labels label on label.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv
        and ci.status = 'published' and civ.status = 'published'
        and label.max_required_unit <= p.top_unit
        and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
        and (ci.item_type in ('mcq','quantitative')
             or (ci.item_type = 'frq' and ci.frq_form in ('short','long')))
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true),
    (select count(*)::int from app.content_items ci
       join app.content_item_versions civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.item_type = 'frq'
        and ci.status = 'published' and civ.status = 'published'
        and ci.practice_format = 'targeted_drill'
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true),
    (select count(*)::int from app.content_items ci
       join app.content_item_versions civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.item_type = 'frq'
        and ci.status = 'published' and civ.status = 'published'
        and ci.practice_format = 'full_exam_frq'
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true),
    (select count(*)::int from app.content_items ci join any_label l on l.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published'),
    (select count(*)::int from app.content_items ci join active_labels l on l.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published'),
    (select count(*)::int from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join any_label l on l.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'
        and l.validated_against_taxo_hash is distinct from app.taxonomy_relevant_hash(civ.id)),
    (select count(*)::int from app.content_items ci join latest civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'
        and not exists (select 1 from any_label l where l.content_item_id = ci.id)),
    (select count(*)::int from app.content_items ci join latest civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status <> 'published'),
    (select count(*)::int from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join app.content_item_cells cic
         on cic.content_item_version_id = civ.id and cic.is_primary
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'),
    (select count(*)::int from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join app.content_item_cells cic
         on cic.content_item_version_id = civ.id and cic.is_primary
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'
        and cic.skill_code is not null)
  from packs p
  order by p.exam_code, p.epv;
$function$;

grant execute on function app.servable_items_census() to ci_servable_items_reader, service_role, postgres;

commit;
