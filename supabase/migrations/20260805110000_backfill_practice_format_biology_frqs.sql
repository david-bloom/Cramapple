-- TASK-0021 prerequisite — Biology FRQ practice_format backfill.
-- Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
-- Decision: David Bloom, 2026-08-05 — all 36 published APBIO-FRQ-* items to
-- 'targeted_drill'.
--
-- Why this is a prerequisite and not a side task: select_practice_frqs
-- requires an exact, non-null practice_format match with no NULL fallback
-- (schema_baseline.sql:1445). With practice_format IS NULL on every published
-- Biology FRQ, the Biology slice is unreachable through the practice-session
-- selector, so the visual-delivery work cannot be student-QA'd against real
-- Biology content at all until this lands.
--
-- Live verified 2026-08-05 (SELECT-only, Production pcntajvbdfqhbeewmdry):
-- exactly 36 published APBIO-FRQ-* items -- 33 frq_form = 'long' (4 criteria,
-- 9-10 points) and 3 frq_form = 'short' (2 criteria, 4 points) -- all with
-- practice_format IS NULL and frq_archetype IS NULL.
--
-- Why 'targeted_drill' for all 36 rather than routing the 33 long items to
-- 'full_exam_frq': a representative AP Biology exam section needs 2 long plus
-- 4 short FRQs, and only 3 short items are published. Classifying the long
-- items as exam-representative would make them selectable only into a format
-- that cannot currently be assembled. 'targeted_drill' claims nothing this
-- corpus cannot support, and matches the AP Statistics precedent
-- (20260802014901) where 4-point multi-part items were classified as drills.
--
-- ONE-WAY DOOR -- read before extending this pattern. The
-- prevent_live_frq_reclassification guard permits NULL -> non-null only
-- (carve-out added 2026-08-01, 20260802015030). Once these rows are non-null,
-- moving them to 'full_exam_frq' raises
-- published_frq_reclassification_requires_retirement, whose only escape is the
-- full retire/re-review cycle rejected as Phase 2b. If the Biology short-FRQ
-- corpus later grows enough to assemble a real exam section, that reclassify
-- is NOT a migration -- it is a content decision with a retirement cost.
--
-- This migration satisfies the guard's carve-out exactly: practice_format is
-- the only column changed; frq_archetype and frq_form are untouched and remain
-- fully guarded.
--
-- DELIBERATE EXCLUSION -- do not "fix" the content_key filter. Biology also has
-- 5 published, published-versioned FRQ items with practice_format IS NULL whose
-- keys are APBIO-HDG-2026-GRAPH-{004,006,008,011,012} (verified 2026-08-05).
-- HDG = hand-drawn graph: these are construction items that require a drawn
-- response, which is Program B and remains launch-blocked per TASK-0020. The
-- 'APBIO-FRQ-%' filter excludes them, and that is the point -- backfilling them
-- would make drawn-response items selectable into student practice sessions
-- with no capture path to answer them. They stay unreachable on purpose until
-- Program B ships. The assertion below counts only 'APBIO-FRQ-%' items for the
-- same reason.
--
-- This does NOT make any Biology item student-visible on its own. The 8
-- construct-sensitive image items remain gated by
-- app.content_asset_metadata.approved_at (20260805100000), which no row sets.

begin;

do $$
declare
  v_expected constant integer := 36;
  v_eligible integer;
  v_updated integer;
begin
  select count(*) into v_eligible
  from app.content_items ci
  where ci.item_type = 'frq'
    and ci.content_key like 'APBIO-FRQ-%'
    and ci.status = 'published'
    and ci.practice_format is null;

  -- Fail closed on drift. If the published Biology corpus changed since the
  -- 2026-08-05 verification, stop rather than silently reclassifying a
  -- different set of items through a one-way door.
  if v_eligible <> v_expected then
    raise exception
      'apbio_practice_format_backfill_count_drift: expected % eligible items, found %',
      v_expected, v_eligible;
  end if;

  update app.content_items ci
  set practice_format = 'targeted_drill'
  where ci.item_type = 'frq'
    and ci.content_key like 'APBIO-FRQ-%'
    and ci.status = 'published'
    and ci.practice_format is null;

  get diagnostics v_updated = row_count;

  if v_updated <> v_expected then
    raise exception
      'apbio_practice_format_backfill_update_mismatch: expected %, updated %',
      v_expected, v_updated;
  end if;
end;
$$;

commit;
