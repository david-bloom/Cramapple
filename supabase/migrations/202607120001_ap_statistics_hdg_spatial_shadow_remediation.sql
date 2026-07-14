-- Remediate the AP Statistics HDG compatibility projection so the 40 published
-- HDG FRQs route to spatial / human_shadow consistently in both typed columns
-- and prompt_json.

begin;

do $$
declare
  v_matching_items integer;
  v_matching_versions integer;
  v_matching_rubric integer;
  v_matching_strategy integer;
  v_matching_criteria integer;
  v_unexpected_prompt_routing integer;
begin
  select
    count(distinct ci.id),
    count(distinct civ.id)
  into v_matching_items, v_matching_versions
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%';

  select count(*)
  into v_matching_rubric
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    and civ.rubric_type = 'discrete_text';

  select count(*)
  into v_matching_strategy
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    and civ.evaluator_strategy = 'llm_discrete_text';

  select count(*)
  into v_matching_criteria
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  join app.frq_criteria fc
    on fc.content_item_version_id = civ.id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%';

  select count(*)
  into v_unexpected_prompt_routing
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    and not (
      (
        civ.prompt_json is null
        or not (civ.prompt_json ? 'rubric_type')
        or civ.prompt_json->>'rubric_type' = 'discrete_text'
      )
      and (
        civ.prompt_json is null
        or not (civ.prompt_json ? 'evaluator_strategy')
        or civ.prompt_json->>'evaluator_strategy' = 'llm_discrete_text'
      )
    );

  if v_matching_items <> 40 or v_matching_versions <> 40 then
    raise exception
      'Expected exactly 40 published APSTATS-HDG items/versions, found items=%, versions=%',
      v_matching_items,
      v_matching_versions;
  end if;

  if v_matching_rubric <> 40 then
    raise exception
      'Expected 40 published APSTATS-HDG versions with rubric_type=discrete_text, found %',
      v_matching_rubric;
  end if;

  if v_matching_strategy <> 40 then
    raise exception
      'Expected 40 published APSTATS-HDG versions with evaluator_strategy=llm_discrete_text, found %',
      v_matching_strategy;
  end if;

  if v_matching_criteria <> 0 then
    raise exception
      'Expected zero frq_criteria rows for APSTATS-HDG published versions, found %',
      v_matching_criteria;
  end if;

  if v_unexpected_prompt_routing <> 0 then
    raise exception
      'Unexpected preexisting APSTATS-HDG prompt_json routing values found in % published versions',
      v_unexpected_prompt_routing;
  end if;
end;
$$;

create temporary table ap_stats_frq_snapshot on commit drop as
select
  civ.id as content_version_id,
  ci.id as content_item_id,
  ci.content_key,
  case
    when ci.content_key like 'APSTATS-HDG-2026-GRAPH-%' then 'APSTATS-HDG'
    when ci.content_key like 'APSTATS-SFRQ-%' then 'APSTATS-SFRQ'
  end as family,
  ci.title as item_title,
  ci.frq_form as item_frq_form,
  ci.status as item_status,
  civ.status as version_status,
  civ.approved_at,
  civ.approved_by,
  civ.stem,
  civ.stimulus,
  civ.explanation,
  civ.help_text,
  civ.content_hash,
  civ.canonical_answer_1,
  civ.canonical_answer_2,
  civ.review_status,
  civ.rubric_type,
  civ.evaluator_strategy,
  coalesce(civ.prompt_json, '{}'::jsonb) - 'rubric_type' - 'evaluator_strategy' as prompt_json_base,
  coalesce((
    select count(*)
    from app.frq_criteria fc
    where fc.content_item_version_id = civ.id
  ), 0) as criteria_count_before
from app.content_items ci
join app.content_item_versions civ
  on civ.content_item_id = ci.id
join app.exam_pack_versions epv
  on epv.id = ci.exam_pack_version_id
join app.exam_packs ep
  on ep.id = epv.exam_pack_id
where ci.item_type = 'frq'
  and ci.status = 'published'
  and civ.status = 'published'
  and ep.exam_code = 'ap_statistics'
  and (
    ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    or ci.content_key like 'APSTATS-SFRQ-%'
  );

do $$
declare
  v_updated_rows integer;
begin
  update app.content_item_versions civ
  set rubric_type = 'spatial',
      evaluator_strategy = 'human_shadow',
      prompt_json = jsonb_set(
        jsonb_set(
          coalesce(civ.prompt_json, '{}'::jsonb),
          '{rubric_type}',
          to_jsonb('spatial'::text),
          true
        ),
        '{evaluator_strategy}',
        to_jsonb('human_shadow'::text),
        true
      )
  from app.content_items ci
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where civ.content_item_id = ci.id
    and ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    and civ.rubric_type = 'discrete_text'
    and civ.evaluator_strategy = 'llm_discrete_text'
    and (
      civ.prompt_json is null
      or not (civ.prompt_json ? 'rubric_type')
      or civ.prompt_json->>'rubric_type' = 'discrete_text'
    )
    and (
      civ.prompt_json is null
      or not (civ.prompt_json ? 'evaluator_strategy')
      or civ.prompt_json->>'evaluator_strategy' = 'llm_discrete_text'
    )
    and not exists (
      select 1
      from app.frq_criteria fc
      where fc.content_item_version_id = civ.id
    );

  get diagnostics v_updated_rows = row_count;

  if v_updated_rows <> 40 then
    raise exception
      'Expected exactly 40 HDG rows to be updated, found %',
      v_updated_rows;
  end if;
end;
$$;

do $$
declare
  v_hdg_ok integer;
  v_hdg_criteria_ok integer;
  v_sfrq_ok integer;
  v_sfrq_criteria_ok integer;
  v_snapshot_mismatches integer;
begin
  select
    count(*)
  into v_hdg_ok
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    and civ.rubric_type = 'spatial'
    and civ.evaluator_strategy = 'human_shadow'
    and civ.prompt_json ? 'rubric_type'
    and civ.prompt_json->>'rubric_type' = 'spatial'
    and civ.prompt_json ? 'evaluator_strategy'
    and civ.prompt_json->>'evaluator_strategy' = 'human_shadow';

  select
    count(*)
  into v_hdg_criteria_ok
  from (
    select civ.id
    from app.content_items ci
    join app.content_item_versions civ
      on civ.content_item_id = ci.id
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep
      on ep.id = epv.exam_pack_id
    left join app.frq_criteria fc
      on fc.content_item_version_id = civ.id
    where ci.item_type = 'frq'
      and ci.status = 'published'
      and civ.status = 'published'
      and ep.exam_code = 'ap_statistics'
      and ci.content_key like 'APSTATS-HDG-2026-GRAPH-%'
    group by civ.id
    having count(fc.*) = 0
  ) as hdg_zero_criteria;

  select count(*)
  into v_sfrq_ok
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  join app.exam_pack_versions epv
    on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep
    on ep.id = epv.exam_pack_id
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ep.exam_code = 'ap_statistics'
    and ci.content_key like 'APSTATS-SFRQ-%'
    and civ.rubric_type = 'discrete_text'
    and civ.evaluator_strategy = 'llm_discrete_text';

  select count(*)
  into v_sfrq_criteria_ok
  from (
    select civ.id
    from app.content_items ci
    join app.content_item_versions civ
      on civ.content_item_id = ci.id
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep
      on ep.id = epv.exam_pack_id
    left join app.frq_criteria fc
      on fc.content_item_version_id = civ.id
    where ci.item_type = 'frq'
      and ci.status = 'published'
      and civ.status = 'published'
      and ep.exam_code = 'ap_statistics'
      and ci.content_key like 'APSTATS-SFRQ-%'
    group by civ.id
    having count(fc.*) = 4
  ) as sfrq_four_criteria;

  select count(*)
  into v_snapshot_mismatches
  from ap_stats_frq_snapshot s
  join app.content_items ci
    on ci.id = s.content_item_id
  join app.content_item_versions civ
    on civ.id = s.content_version_id
  where (
    ci.status is distinct from s.item_status
    or ci.title is distinct from s.item_title
    or ci.frq_form is distinct from s.item_frq_form
    or civ.status is distinct from s.version_status
    or civ.approved_at is distinct from s.approved_at
    or civ.approved_by is distinct from s.approved_by
    or civ.stem is distinct from s.stem
    or civ.stimulus is distinct from s.stimulus
    or civ.explanation is distinct from s.explanation
    or civ.help_text is distinct from s.help_text
    or civ.content_hash is distinct from s.content_hash
    or civ.canonical_answer_1 is distinct from s.canonical_answer_1
    or civ.canonical_answer_2 is distinct from s.canonical_answer_2
    or civ.review_status is distinct from s.review_status
    or (
      coalesce(civ.prompt_json, '{}'::jsonb) - 'rubric_type' - 'evaluator_strategy'
    ) is distinct from s.prompt_json_base
  );

  if v_hdg_ok <> 40 then
    raise exception 'Expected 40 HDG rows to be spatial/human_shadow after update, found %', v_hdg_ok;
  end if;

  if v_hdg_criteria_ok <> 40 then
    raise exception 'Expected 40 HDG rows with zero criteria after update, found %', v_hdg_criteria_ok;
  end if;

  if v_sfrq_ok <> 18 then
    raise exception 'Expected 18 SFRQ rows to remain discrete_text/llm_discrete_text, found %', v_sfrq_ok;
  end if;

  if v_sfrq_criteria_ok <> 18 then
    raise exception 'Expected 18 SFRQ rows to retain exactly four criteria, found %', v_sfrq_criteria_ok;
  end if;

  if v_snapshot_mismatches <> 0 then
    raise exception
      'Non-routing fields changed unexpectedly for % rows',
      v_snapshot_mismatches;
  end if;
end;
$$;

commit;

-- Regression query to run after the migration is applied:
--
-- with frq as (
--   select
--     case
--       when ci.content_key like 'APSTATS-HDG-2026-GRAPH-%' then 'APSTATS-HDG'
--       when ci.content_key like 'APSTATS-SFRQ-%' then 'APSTATS-SFRQ'
--       else 'OTHER'
--     end as family,
--     ci.content_key,
--     ci.frq_form,
--     civ.rubric_type,
--     civ.evaluator_strategy,
--     count(fc.*) as frq_criteria_count
--   from app.content_items ci
--   join app.content_item_versions civ
--     on civ.content_item_id = ci.id
--   left join app.frq_criteria fc
--     on fc.content_item_version_id = civ.id
--   where ci.item_type = 'frq'
--     and ci.status = 'published'
--     and civ.status = 'published'
--     and ci.exam_pack_version_id = (
--       select id
--       from app.exam_pack_versions
--       where exam_pack_id = (
--         select id
--         from app.exam_packs
--         where exam_code = 'ap_statistics'
--       )
--     )
--   group by family, ci.content_key, ci.frq_form, civ.rubric_type, civ.evaluator_strategy
-- )
-- select
--   count(*) filter (
--     where family = 'APSTATS-HDG'
--       and rubric_type = 'spatial'
--       and evaluator_strategy = 'human_shadow'
--       and frq_criteria_count = 0
--   ) as hdg_ok,
--   count(*) filter (
--     where family = 'APSTATS-SFRQ'
--       and rubric_type = 'discrete_text'
--       and evaluator_strategy = 'llm_discrete_text'
--       and frq_criteria_count = 4
--   ) as sfrq_ok,
--   count(*) filter (
--     where family = 'APSTATS-HDG'
--       and (
--         rubric_type <> 'spatial'
--         or evaluator_strategy <> 'human_shadow'
--         or frq_criteria_count <> 0
--       )
--   ) as hdg_fail,
--   count(*) filter (
--     where family = 'APSTATS-SFRQ'
--       and (
--         rubric_type <> 'discrete_text'
--         or evaluator_strategy <> 'llm_discrete_text'
--         or frq_criteria_count <> 4
--       )
--   ) as sfrq_fail
-- from frq;
