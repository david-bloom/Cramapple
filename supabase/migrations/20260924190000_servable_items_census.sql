-- A standing census of what each subject can actually serve, and why.
-- APPLIED TO PRODUCTION 2026-09-24. Self-test passed: 93 ok, 0 mismatch, 3 skipped (RPC caps at 50).
--
-- ---------------------------------------------------------------------------
-- WHY THIS EXISTS
--
-- On 2026-09-24 three separate silent serving failures were found by hand:
--   * 20 AP Biology MCQ were republished in August. Every serving label stopped matching its
--     content hash and nothing noticed for six weeks.
--   * M1 rewrote 67 canonical answers and instantly dropped 28 more items out of serving.
--   * The unit-gated path had never served a single Biology item, because it requires
--     label_status = 'validated' and Biology has none.
--
-- None of these produced an error. Both serving functions treat every one of these conditions as
-- "no rows", which is indistinguishable from "this subject has no content". The first thing this
-- census found, on its first run, is that the unit-gated path serves EIGHT items across the entire
-- product -- 4 Calculus AB and 4 Calculus BC, and zero everywhere else.
--
-- ---------------------------------------------------------------------------
-- WHAT IT MIRRORS, AND HOW THE MIRROR IS KEPT HONEST
--
--   public.select_unit_gated_practice_items -- course mode. Needs a VALIDATED serving label whose
--                                              taxonomy hash matches current content, plus the unit
--                                              gate. This is the path that serves 8 items.
--   public.select_practice_frqs             -- practice. Needs NO taxonomy label at all, only
--                                              practice_format and not hand_drawn. This is the path
--                                              students actually receive content through today.
--
-- A mirror that is never checked against what it mirrors is worse than no check: it reports
-- confidently while drifting. app.servable_items_census_selftest() calls the real RPCs per subject
-- and unit and compares. Comparisons the RPC's 50-row cap would invalidate are reported as
-- 'skipped_capped', never as passes -- an unverifiable case must not look like a verified one.
--
-- Two subtleties the mirror preserves because the real functions have them:
--   1. `latest` picks the highest version_num REGARDLESS of status and only then requires
--      status='published'. An item whose newest version is a draft is unservable even if an older
--      published version exists. Biology has 42 items in that state.
--   2. select_practice_frqs ignores taxonomy entirely. Fixing labels does nothing for it, and
--      breaking labels does nothing to it either.
--
-- Runner: scripts/qa/servable_items_check.py, baseline: docs/research/servable_items_baseline.json.

create or replace function app.servable_items_census()
returns table (
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
  latest_version_not_published integer
)
language sql
stable
security definer
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
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status <> 'published')
  from packs p
  order by p.exam_code, p.epv;
$function$;

comment on function app.servable_items_census is
  'Per-subject census of what the two live serving functions can actually return, plus the diagnostics that explain a zero. Mirrors public.select_unit_gated_practice_items and public.select_practice_frqs; app.servable_items_census_selftest() verifies the mirror against them.';

revoke all on function app.servable_items_census() from public, anon, authenticated;
grant execute on function app.servable_items_census() to service_role;

-- ---------------------------------------------------------------------------

create or replace function app.servable_items_census_selftest()
returns table (
  exam_code text,
  path text,
  probe text,
  rpc_rows integer,
  mirrored integer,
  status text
)
language plpgsql
stable
security definer
set search_path to 'pg_catalog'
as $function$
declare
  r record;
  u integer;
  v_rpc integer;
  v_mirror integer;
begin
  for r in
    select ep.exam_code as code, epv.id as epv, m.allowed_unit_numbers as units
    from app.exam_packs ep
    join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
    left join app.home_release_manifest m on m.exam_pack_version_id = epv.id
    order by ep.exam_code, epv.id
  loop
    if r.units is not null then
      foreach u in array r.units loop
        select count(*) into v_rpc
        from public.select_unit_gated_practice_items(r.epv, u, null, null, 50);

        with latest as (
          select distinct on (civ.content_item_id) civ.*
          from app.content_item_versions civ
          order by civ.content_item_id, civ.version_num desc
        ), active_labels as (
          select distinct on (ctl.content_item_id) ctl.*
          from app.content_taxonomy_labels ctl
          where ctl.label_scope = 'serving' and ctl.label_status = 'validated'
            and ctl.superseded_by is null
          order by ctl.content_item_id, ctl.label_version desc
        )
        select count(*) into v_mirror
        from app.content_items ci
        join latest civ on civ.content_item_id = ci.id
        join active_labels label on label.content_item_id = ci.id
        where ci.exam_pack_version_id = r.epv
          and ci.status = 'published' and civ.status = 'published'
          and label.max_required_unit <= u
          and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
          and (ci.item_type in ('mcq','quantitative')
               or (ci.item_type = 'frq' and ci.frq_form in ('short','long')))
          and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true;

        exam_code := r.code; path := 'unit_gated'; probe := 'unit=' || u;
        rpc_rows := v_rpc; mirrored := v_mirror;
        status := case when v_mirror >= 50 then 'skipped_capped'
                       when v_rpc = v_mirror then 'ok' else 'MISMATCH' end;
        return next;
      end loop;
    end if;

    foreach probe in array array['targeted_drill', 'full_exam_frq'] loop
      select count(*) into v_rpc from public.select_practice_frqs(r.epv, probe, 50);

      select count(*) into v_mirror
      from app.content_items ci
      join app.content_item_versions civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = r.epv and ci.item_type = 'frq'
        and ci.status = 'published' and civ.status = 'published'
        and ci.practice_format = probe
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true;

      exam_code := r.code; path := 'practice';
      rpc_rows := v_rpc; mirrored := v_mirror;
      status := case when v_mirror >= 50 then 'skipped_capped'
                     when v_rpc = v_mirror then 'ok' else 'MISMATCH' end;
      return next;
    end loop;
  end loop;
end;
$function$;

comment on function app.servable_items_census_selftest is
  'Checks app.servable_items_census()''s mirrored predicates against the real serving RPCs, per subject and unit. Any MISMATCH means the census has drifted from production and its numbers must not be trusted until fixed. Capped comparisons are reported as skipped_capped rather than passed.';

revoke all on function app.servable_items_census_selftest() from public, anon, authenticated;
grant execute on function app.servable_items_census_selftest() to service_role;
