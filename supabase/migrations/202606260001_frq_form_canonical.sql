-- Canonicalize frq_form on app.content_items.
--
-- Adds a frq_form column that carries the short/long FRQ distinction
-- from the content generation prompts and upload parser into the canonical
-- production content record.
--
-- The prototype student schema (public.questions.type) already encodes
-- this distinction as 'short_frq' / 'long_frq'. This migration makes the
-- production content pipeline (app.content_items) consistent without
-- touching the prototype tables.
--
-- Enforcement rule:
--   item_type = 'frq'                   → frq_form not null ('short' | 'long')
--   item_type in ('mcq','quantitative') → frq_form must be null

begin;

alter table app.content_items
  add column frq_form text
  constraint content_items_frq_form_check
    check (frq_form in ('short', 'long'));

-- Enforce the null / not-null coupling at the database layer.
-- A CHECK constraint alone cannot reference other columns conditionally
-- in a way that is clear, so a trigger is used instead.
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

-- Backfill existing FRQ rows using total points from frq_criteria:
--   sum(points_possible) = 4  → 'short'  (one point per sub-question, 4 parts)
--   sum(points_possible) > 4  → 'long'   (multi-point parts, 8–10 total)
--
-- No rows are expected in the production project at migration time.
-- This update is a safety net for manually inserted or imported test content.
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

-- Any FRQ row that still has frq_form null after the backfill has no
-- criteria rows and cannot be classified automatically. Flag it so the
-- content team can resolve before the trigger blocks further writes.
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
