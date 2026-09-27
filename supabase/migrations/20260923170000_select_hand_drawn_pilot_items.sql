-- TASK-0038 Phase 3 — dedicated, explicitly-requested selector for the
-- human-graded hand-drawn pilot.
--
-- Deliberately its own function rather than a filter added to
-- select_practice_frqs/select_unit_gated_practice_items: those two exist to
-- serve the ordinary random/gated queue and, per TASK-0038 Phase 1, now
-- actively EXCLUDE hand-drawn items. Hand-drawn pilot items must only ever
-- be reachable when a caller explicitly asks for this mode -- never blended
-- into the ordinary queue a real student draws from at random. Belt-and-
-- suspenders double filter (hand_drawn=true AND label_status=
-- 'human_graded_pilot_approved') so a future item that is merely hand_drawn
-- but not yet promoted (DECISION-0058/APPROVAL-0048) can never leak through
-- here either.

create or replace function public.select_hand_drawn_pilot_items(
  _exam_pack_version_id uuid,
  _limit integer default 5
)
returns table (
  content_item_version_id uuid,
  content_item_id uuid,
  content_key text,
  title text,
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
set search_path to 'pg_catalog'
as $function$
  select
    civ.id,
    ci.id,
    ci.content_key,
    ci.title,
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
    and ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is true
    and civ.prompt_json->>'label_status' = 'human_graded_pilot_approved'
  order by civ.published_at, ci.content_key
  limit greatest(1, least(coalesce(_limit, 5), 20));
$function$;
