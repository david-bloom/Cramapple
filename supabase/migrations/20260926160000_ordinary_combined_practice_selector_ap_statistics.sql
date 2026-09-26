-- TASK-0044 follow-up -- AP Statistics' flat-path MCQ practice has no
-- backend selector: select_practice_frqs hard-filters item_type = 'frq',
-- and app.select_biology_practice_items (the only existing combined
-- FRQ+MCQ selector) is Biology-only by design (`ep.exam_code = 'ap_biology'`
-- in its own WHERE clause, per its migration comment: "all other subjects
-- and formats continue to use public.select_practice_frqs unchanged").
-- Confirmed live against Production 2026-09-26: 101/101 published AP
-- Statistics MCQ have a correct mcq_choices row (content-ready), but zero
-- are reachable through any backend RPC on the ordinary/flat practice path.
--
-- This adds a second, generically-named combined selector rather than
-- editing app.select_biology_practice_items, so AP Biology's already-
-- verified serving path is untouched. Identical selection logic
-- (published/version-status/hand-drawn exclusion, proportional per-type
-- quota, session-stable seeded ordering); the only behavioral difference
-- is dropping the exam_code = 'ap_biology' filter, which was redundant
-- given the query already scopes on the caller-supplied
-- _exam_pack_version_id (a version belongs to exactly one subject).
--
-- Applied to Dev 2026-09-26 and verified against Dev's real AP Statistics
-- content (203 MCQ / 0 FRQ pack): returns 20 MCQ at limit 20, as expected.
-- The same query body was also dry-run (inline, no function created) against
-- Production's real AP Statistics pack (49 FRQ / 101 MCQ): quota logic
-- produced 7 FRQ + 13 MCQ at limit 20, a sensible proportional mix.
--
-- Applied to Production 2026-09-26 with David's explicit approval, alongside
-- the corresponding student-session-items deploy (routes AP Statistics
-- targeted-drill sessions here). Verified live post-deploy: this function
-- returns 7 FRQ + 13 MCQ against the same real Statistics pack, matching the
-- dry run exactly; select_biology_practice_items re-verified unaffected
-- (12 FRQ + 8 MCQ, unchanged).

create or replace function app.select_ordinary_combined_practice_items(
  _exam_pack_version_id uuid,
  _practice_format text,
  _selection_seed uuid,
  _limit integer default 20
)
returns table (
  content_item_version_id uuid,
  content_item_id uuid,
  content_key text,
  title text,
  item_type text,
  stem text,
  stimulus text,
  stimulus_image_path text,
  prompt_json jsonb,
  frq_form text,
  practice_format text,
  frq_archetype text,
  published_at timestamptz
)
language sql
stable
security invoker
set search_path = 'pg_catalog'
as $function$
  with eligible as (
    select
      civ.id as content_item_version_id,
      ci.id as content_item_id,
      ci.content_key,
      ci.title,
      ci.item_type,
      civ.stem,
      civ.stimulus,
      civ.stimulus_image_path,
      civ.prompt_json,
      ci.frq_form,
      ci.practice_format,
      ci.frq_archetype,
      civ.published_at
    from app.content_items ci
    join app.content_item_versions civ
      on civ.content_item_id = ci.id
    where ci.exam_pack_version_id = _exam_pack_version_id
      and _practice_format = 'targeted_drill'
      and _selection_seed is not null
      and ci.status = 'published'
      and civ.status = 'published'
      and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true
      and (
        (
          ci.item_type = 'frq'
          and ci.practice_format = 'targeted_drill'
        )
        or ci.item_type = 'mcq'
      )
  ), requested as (
    select greatest(1, least(coalesce(_limit, 20), 50))::integer as item_limit
  ), pool_sizes as (
    select e.item_type, count(*)::integer as pool_size
    from eligible e
    group by e.item_type
  ), quota_inputs as (
    select
      p.item_type,
      p.pool_size,
      least(r.item_limit, sum(p.pool_size) over ())::integer as target_size,
      sum(p.pool_size) over ()::integer as total_size
    from pool_sizes p
    cross join requested r
  ), quota_floors as (
    select
      q.item_type,
      floor(q.target_size * q.pool_size::numeric / q.total_size)::integer
        as base_quota,
      (q.target_size * q.pool_size::numeric / q.total_size)
        - floor(q.target_size * q.pool_size::numeric / q.total_size)
        as fractional_remainder,
      q.target_size
    from quota_inputs q
  ), quotas as (
    select
      q.item_type,
      q.base_quota
        + case
            when row_number() over (
              order by q.fractional_remainder desc, q.item_type
            ) <= q.target_size - sum(q.base_quota) over ()
              then 1
            else 0
          end as item_quota
    from quota_floors q
  ), ranked as (
    select
      e.content_item_version_id,
      e.content_item_id,
      e.content_key,
      e.title,
      e.item_type,
      e.stem,
      e.stimulus,
      e.stimulus_image_path,
      e.prompt_json,
      e.frq_form,
      e.practice_format,
      e.frq_archetype,
      e.published_at,
      row_number() over (
        partition by e.item_type
        order by
          md5(_selection_seed::text || ':' || e.content_item_version_id::text),
          e.published_at,
          e.content_key
      ) as type_rank
    from eligible e
  ), selected as (
    select r.*, q.item_quota
    from ranked r
    join quotas q on q.item_type = r.item_type
    where r.type_rank <= q.item_quota
  )
  select
    s.content_item_version_id,
    s.content_item_id,
    s.content_key,
    s.title,
    s.item_type,
    s.stem,
    s.stimulus,
    s.stimulus_image_path,
    s.prompt_json,
    s.frq_form,
    s.practice_format,
    s.frq_archetype,
    s.published_at
  from selected s
  order by
    (s.type_rank::numeric - 0.5) / nullif(s.item_quota, 0),
    s.item_type,
    s.type_rank
  limit greatest(1, least(coalesce(_limit, 20), 50));
$function$;

comment on function app.select_ordinary_combined_practice_items(uuid, text, uuid, integer) is
  'TASK-0044 follow-up: subject-agnostic targeted-drill selector, proportional session-stable published FRQ/MCQ mix with an answer-free projection. Used for subjects (currently AP Statistics) whose ordinary-mode flat practice needs both item types; AP Biology keeps its own dedicated select_biology_practice_items unchanged.';

revoke execute on function app.select_ordinary_combined_practice_items(uuid, text, uuid, integer)
  from public, anon, authenticated;

grant execute on function app.select_ordinary_combined_practice_items(uuid, text, uuid, integer)
  to service_role;
