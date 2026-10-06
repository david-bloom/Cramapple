-- TASK-0064 — keep Open Hand teaching items out of every scored SQL selector.
--
-- Teaching items (app.open_hand_teaching_items, released_at is null) are shown
-- with their full key in Open Hand and are never scored. The live /session
-- path picks items through these four selectors, so excluding teaching items
-- here protects every path students can reach today without an edge-function
-- deploy. (student-session-items' cell_scoped mode, used only by the plate
-- loop, is covered by dropTeachingItems in _shared/student-item-delivery.ts;
-- the plate loop must stay OFF until that function is deployed.)
--
-- Same pattern as 20260923150000_exclude_hand_drawn_from_text_serving.sql,
-- but applied by editing each function's CURRENT definition in place: the
-- predicate is inserted after one anchor line that must occur exactly once,
-- so nothing else in the (environment-specific) bodies is retyped. Re-running
-- is a no-op: a function that already calls content_item_is_teaching is left
-- alone.

grant execute on function app.content_item_is_teaching(uuid) to authenticated;

do $migration$
declare
  r record;
  v_def text;
  v_new text;
  v_hits int;
begin
  for r in
    select * from (values
      ('public.select_unit_gated_practice_items(uuid,integer,text,text,integer)',
       'and coalesce((civ.prompt_json->>''hand_drawn'')::boolean, false) is not true'),
      ('app.select_ordinary_combined_practice_items(uuid,text,uuid,integer)',
       'and coalesce((civ.prompt_json->>''hand_drawn'')::boolean, false) is not true'),
      ('app.select_biology_practice_items(uuid,text,uuid,integer)',
       'and coalesce((civ.prompt_json->>''hand_drawn'')::boolean, false) is not true'),
      ('app.select_confirm_transfer_item(uuid,uuid)',
       'and civ.id <> _source_content_item_version_id')
    ) as t(sig, anchor)
  loop
    v_def := pg_get_functiondef(r.sig::regprocedure);
    if position('content_item_is_teaching' in v_def) > 0 then
      raise notice 'TASK-0064: % already excludes teaching items; skipped', r.sig;
      continue;
    end if;
    v_hits := (length(v_def) - length(replace(v_def, r.anchor, ''))) / length(r.anchor);
    if v_hits <> 1 then
      raise exception 'TASK-0064: anchor found % times in % (expected 1)', v_hits, r.sig;
    end if;
    v_new := replace(v_def, r.anchor,
      r.anchor || E'\n      and not app.content_item_is_teaching(ci.id)');
    execute v_new;
    raise notice 'TASK-0064: % now excludes teaching items', r.sig;
  end loop;
end
$migration$;
