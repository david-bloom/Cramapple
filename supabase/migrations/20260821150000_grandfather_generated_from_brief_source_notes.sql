-- Backfill row-level provenance for topic explainers that were derived from
-- their paired point briefs on 2026-08-21. Under the revised Topic Briefs and
-- Learn More Production Protocol
-- (docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md), a
-- generated-from-brief explainer must carry a source_note that says so; the
-- original seed migration left them as the default `cramapple-authored`.
--
-- This migration does NOT change any student-facing field. It only relabels
-- source_note so the debt is visible at the row level. Content re-authoring
-- against the CED fact packs is a separate future batch.
--
-- Grandfather signal: an explainer is considered generated-from-brief if its
-- core_idea is byte-identical to the paired point brief's what_it_is. This is
-- the same signal used by acceptance criterion C7.
--
-- Before-state captured at:
--   docs/research/topic_guide_source_note_grandfather_2026_08_21/before_state.{csv,json}
--
-- Expected row-count effect (matches Prod and Dev on 2026-08-21):
--   plain 'cramapple-authored'                     -> 286 rows relabeled
--   'cramapple-authored Duplicated ...'            -> 59 rows appended
--   'cramapple-authored Moved ...'                 -> 4 rows appended
-- Total: 349 rows. Every other explainer is left untouched, including the 16
-- hand-authored AP Calculus AB Unit 1 explainers (core_idea differs from
-- what_it_is).

begin;

with generated as (
  select e.topic_explainer_id, e.source_note as expl_note
  from app.topic_explainers e
  join app.topic_point_briefs b
    on b.subject_key = e.subject_key
   and b.topic_code = e.topic_code
  where e.status = 'published'
    and e.core_idea = b.what_it_is
), updates as (
  update app.topic_explainers e
     set source_note = case
       when g.expl_note = 'cramapple-authored'
         then 'generated-from-brief:legacy; grandfathered-2026-08-21'
       else g.expl_note || '; upstream-generated-from-brief; grandfathered-2026-08-21'
     end
    from generated g
   where e.topic_explainer_id = g.topic_explainer_id
   returning e.topic_explainer_id
)
select count(*) as rows_updated from updates;

do $$
declare
  v_plain integer;
  v_dup integer;
  v_moved integer;
begin
  select
    count(*) filter (where source_note = 'generated-from-brief:legacy; grandfathered-2026-08-21'),
    count(*) filter (where source_note like '%Duplicated%upstream-generated-from-brief%'),
    count(*) filter (where source_note like '%Moved%upstream-generated-from-brief%')
  into v_plain, v_dup, v_moved
  from app.topic_explainers
  where status = 'published';

  if v_plain <> 286 then
    raise exception 'expected 286 plain grandfathered rows, got %', v_plain;
  end if;
  if v_dup <> 59 then
    raise exception 'expected 59 duplicated grandfathered rows, got %', v_dup;
  end if;
  if v_moved <> 4 then
    raise exception 'expected 4 moved grandfathered rows, got %', v_moved;
  end if;

  raise notice 'grandfather backfill: plain=%, duplicated=%, moved=%, total=%',
    v_plain, v_dup, v_moved, v_plain + v_dup + v_moved;
end;
$$;

commit;
