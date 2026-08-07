-- Publish-time gate: require practice_format on non-drawn FRQs.
-- Decision: David Bloom, 2026-08-05 — preventive follow-up to
-- 20260805130000. That migration cleared the *existing* practice_format
-- gap across 5 subjects; nothing stopped it from recurring on the next FRQ
-- publish. This closes that gap at the source.
--
-- Root cause this fixes: content_items.practice_format has always been
-- optional at the database level (its own CHECK constraint only restricts
-- the value when non-null; it never required FRQs to set it). Every prior
-- fix (20260801, 20260802 x2, 20260805 x2) was a backfill *after* the gap
-- was noticed — there was no gate stopping a newly published FRQ from
-- landing with practice_format IS NULL and silently going unreachable via
-- select_practice_frqs (schema_baseline.sql:1445, no NULL fallback).
--
-- Rule: when app.content_items transitions to status='published' (mirrors
-- the existing content_pipeline_guard_publish trigger's transition check),
-- an item_type='frq' row must have practice_format set UNLESS its published
-- content_item_versions row is a hand-drawn construction item
-- (prompt_json->>'hand_drawn' = 'true') — those are legitimately servable
-- only once Program B (drawn-response capture) ships, and forcing a
-- practice_format on them would make them selectable with no way for a
-- student to answer, exactly the failure mode 20260805110000 and
-- 20260805130000 both guard against on the backfill side. This is the same
-- exclusion rule used there, applied going forward instead of retroactively.
--
-- Non-FRQ items (item_type <> 'frq') are exempt entirely — practice_format
-- doesn't apply to them (content_items_practice_format_check already
-- enforces NULL-only for non-FRQs).
--
-- Ordering: attached as a SEPARATE trigger from the existing
-- content_pipeline_guard_publish (not merged into it), so this can be
-- reviewed, tested, and rolled back independently of that trigger's
-- reviewed_approved->published pipeline check. Trigger name sorts after
-- 'content_pipeline_guard_publish' alphabetically, so the pipeline-stage
-- check still runs first.
--
-- Tested (rolled-back transaction, not committed) against synthetic rows
-- before this migration was written: FRQ + NULL practice_format + not
-- hand_drawn -> raises; FRQ + NULL practice_format + hand_drawn=true ->
-- succeeds; FRQ + practice_format set -> succeeds; MCQ + NULL
-- practice_format -> succeeds (exempt).

CREATE FUNCTION app.tg_require_practice_format_at_publish() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'pg_temp'
    AS $$
declare
  v_hand_drawn boolean;
begin
  if new.status = 'published'
     and old.status is distinct from 'published'
     and new.item_type = 'frq'
     and new.practice_format is null
  then
    select coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
      into v_hand_drawn
    from app.content_item_versions civ
    where civ.content_item_id = new.id
      and civ.status = 'published'
    order by civ.version_num desc
    limit 1;

    if not coalesce(v_hand_drawn, false) then
      raise exception
        'practice_format_required_at_publish: FRQ % (content_key %) cannot publish with practice_format IS NULL — set targeted_drill or full_exam_frq before publishing, or confirm it is a hand-drawn item (prompt_json.hand_drawn = true) if it should stay unreachable via select_practice_frqs',
        new.id, new.content_key;
    end if;
  end if;
  return new;
end;
$$;

COMMENT ON FUNCTION app.tg_require_practice_format_at_publish() IS
  'Blocks publishing an FRQ with practice_format IS NULL unless its published version is a hand-drawn construction item. Preventive follow-up to the 20260805130000 backfill.';

CREATE TRIGGER require_practice_format_at_publish
    BEFORE UPDATE ON app.content_items
    FOR EACH ROW EXECUTE FUNCTION app.tg_require_practice_format_at_publish();
