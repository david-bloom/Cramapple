-- Repair the monitoring mirror after TASK-0064 excluded teaching items from
-- public.select_unit_gated_practice_items. Preserve live function bodies/ACLs;
-- change only the unit-gated predicate, never the practice counters/selectors.
-- Owner authorized implementation and verification on 2026-11-01.
do $migration$
declare
  r record;
  body text;
  anchor text;
  replacement text;
  hits integer;
begin
  for r in select * from (values
    ('app.servable_items_census()', E'or (ci.item_type = ''frq'' and ci.frq_form in (''short'',''long'')))\n        and coalesce((civ.prompt_json->>''hand_drawn'')::boolean, false) is not true),'),
    ('app.servable_items_census_selftest()', E'or (ci.item_type = ''frq'' and ci.frq_form in (''short'',''long'')))\n          and coalesce((civ.prompt_json->>''hand_drawn'')::boolean, false) is not true;')
  ) t(signature, anchor) loop
    body := pg_get_functiondef(r.signature::regprocedure);
    anchor := r.anchor;
    replacement := replace(anchor, ' is not true',
      ' is not true and not app.content_item_is_teaching(ci.id)');
    if position(replacement in body) > 0 then
      continue; -- idempotent: this exact predicate is already repaired
    end if;
    hits := (length(body) - length(replace(body, anchor, ''))) / length(anchor);
    if hits <> 1 then
      raise exception 'Census repair: expected one anchor in %, found %', r.signature, hits;
    end if;
    execute replace(body, anchor, replacement);
  end loop;
end
$migration$;
