-- Unpublish seven AP Statistics items that carry a reviewer disapproval.
--
-- Context: each of these was published while the ONLY review decision on record
-- is a `disapprove` from Jill Schmidlkofer. Their `review_status` was already
-- 'excluded'; only `content_items.status` and `content_item_versions.status`
-- remained 'published', which is the field `evaluate-attempt` gates serving on.
-- This is the "disapproval does not demote" half of the publication-trust P0.
--
-- Owner instruction (David Bloom, 2026-07-31): unpublish and label
-- `reviewed_disapproved`. No students are active, so there is no live exposure.
--
-- This repair:
--   1. moves item + current version from 'published' to 'reviewed_disapproved';
--   2. clears `published_at`, matching admin-content's own convention of
--      nulling it whenever target state is not 'published'; and
--   3. leaves `review_status='excluded'` and every reviewer decision untouched.
--
-- Reviewer decisions are NOT modified or deleted.

begin;

select pg_advisory_xact_lock(
  hashtext('cramapple-unpublish-disapproved-statistics-20260731')
);

create temporary table target_keys(content_key text primary key) on commit drop;
insert into target_keys(content_key) values
  ('APSTATS-HDG-2026-GRAPH-012'),
  ('APSTATS-HDG-2026-GRAPH-037'),
  ('APSTATS-HDG-2026-GRAPH-038'),
  ('APSTATS-HDG-2026-GRAPH-040'),
  ('APSTATS-MCQ-018'),
  ('APSTATS-SFRQ-015'),
  ('APSTATS-SFRQ-017');

-- Resolve only currently-published versions that genuinely carry a disapproval
-- and no offsetting approval. Anything failing these guards is left alone.
create temporary table targets on commit drop as
select ci.id as item_id, civ.id as version_id, ci.content_key
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id = ci.id
join target_keys tk on tk.content_key = ci.content_key
where ci.status = 'published'
  and civ.status = 'published'
  and exists (
    select 1 from app.content_review_decisions d
    where d.content_item_version_id = civ.id
      and coalesce(d.tutor_decision, d.canonical_decision, d.reader_decision) = 'disapprove'
  )
  and not exists (
    select 1 from app.content_review_decisions d
    where d.content_item_version_id = civ.id
      and coalesce(d.tutor_decision, d.canonical_decision, d.reader_decision)
          in ('approve', 'approve_with_edits')
  );

-- Fail loudly rather than silently under-applying.
do $$
declare n int;
begin
  select count(*) into n from targets;
  if n <> 7 then
    raise exception 'expected 7 guarded targets, found %', n;
  end if;
end $$;

update app.content_item_versions civ
set status = 'reviewed_disapproved',
    published_at = null,
    updated_at = now()
from targets t
where civ.id = t.version_id;

update app.content_items ci
set status = 'reviewed_disapproved',
    updated_at = now()
from targets t
where ci.id = t.item_id;

-- Verification: all seven disapproved, none serving, decisions intact.
select ci.content_key,
       ci.status  as item_status,
       civ.status as ver_status,
       civ.review_status,
       (civ.published_at is null) as published_at_cleared,
       (select count(*) from app.content_review_decisions d
         where d.content_item_version_id = civ.id) as decisions_preserved
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id = ci.id
join target_keys tk on tk.content_key = ci.content_key
order by ci.content_key;

commit;
