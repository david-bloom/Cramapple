-- Prevent an FRQ content_item_version from having zero frq_criteria rows.
--
-- The INSERT side is enforced by the admin-content edge function, which
-- validates that frq_criteria is non-empty before writing the version.
-- This trigger covers the DELETE side: it fires after any criterion is
-- removed and raises an exception if the version now has no criteria left
-- and its parent content_item is still item_type = 'frq'.

create or replace function app.prevent_empty_frq_criteria()
returns trigger
language plpgsql
as $$
declare
  remaining  integer;
  item_type  text;
begin
  select count(*) into remaining
  from app.frq_criteria
  where content_item_version_id = old.content_item_version_id;

  if remaining = 0 then
    select ci.item_type into item_type
    from app.content_item_versions civ
    join app.content_items ci on ci.id = civ.content_item_id
    where civ.id = old.content_item_version_id;

    if item_type = 'frq' then
      raise exception
        'cannot remove the last frq_criterion from an FRQ content_item_version (id: %)',
        old.content_item_version_id;
    end if;
  end if;

  return old;
end;
$$;

create trigger frq_criteria_prevent_empty
after delete on app.frq_criteria
for each row execute function app.prevent_empty_frq_criteria();
