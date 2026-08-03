-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627020531
-- recorded name: frq_form_canonical
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Canonicalize frq_form on app.content_items.

begin;

alter table app.content_items
  add column frq_form text
  constraint content_items_frq_form_check
    check (frq_form in ('short', 'long'));

create or replace function app.enforce_content_items_frq_form()
returns trigger
language plpgsql
as $$
begin
  if new.item_type = 'frq' and new.frq_form is null then
    raise exception
      'frq_form is required when item_type is ''frq'' (content_key: %)',
      new.content_key;
  end if;
  if new.item_type <> 'frq' and new.frq_form is not null then
    raise exception
      'frq_form must be null when item_type is not ''frq'' (content_key: %)',
      new.content_key;
  end if;
  return new;
end;
$$;

create trigger content_items_enforce_frq_form
before insert or update on app.content_items
for each row execute function app.enforce_content_items_frq_form();

update app.content_items ci
set frq_form = (
  select
    case when sum(fc.points_possible) <= 4 then 'short' else 'long' end
  from app.content_item_versions civ
  join app.frq_criteria fc
    on fc.content_item_version_id = civ.id
  where civ.content_item_id = ci.id
)
where ci.item_type = 'frq'
  and ci.frq_form is null;

do $$
declare
  unresolved integer;
begin
  select count(*)
  into unresolved
  from app.content_items
  where item_type = 'frq'
    and frq_form is null;

  if unresolved > 0 then
    raise warning
      '% FRQ row(s) in app.content_items still have frq_form = null after '
      'backfill. These rows have no frq_criteria entries and must be resolved '
      'manually before further inserts or updates will succeed.',
      unresolved;
  end if;
end;
$$;

commit;
