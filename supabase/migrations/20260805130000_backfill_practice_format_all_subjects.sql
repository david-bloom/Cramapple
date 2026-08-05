-- General practice_format backfill — all subjects.
-- Decision: David Bloom, 2026-08-05 — generalize the Biology-only backfill
-- (20260805110000) to every subject in one migration, rather than repeating
-- a hand-authored per-subject script each time a new gap is found.
--
-- Why this was still a live problem after 20260805110000: that migration
-- only fixed Biology. Independent per-item image-requirement audits run
-- across all 8 subjects on 2026-08-05 surfaced the same practice_format IS
-- NULL blocker on Chemistry, Precalculus, and Calculus AB/BC FRQs too — the
-- underlying bug (select_practice_frqs requires an exact, non-null
-- practice_format match, schema_baseline.sql:1445) was never subject-scoped;
-- only the fixes were.
--
-- Live verified 2026-08-05 (SELECT-only, Production pcntajvbdfqhbeewmdry):
-- 100 published FRQs across 5 subjects have practice_format IS NULL and are
-- NOT hand-drawn construction items:
--   AP Biology 36, AP Chemistry 42, AP Precalculus 14, AP Calculus AB 6,
--   AP Calculus BC 2.
-- AP Physics (all 4 courses) already has 0 nulls. AP Statistics has 0
-- eligible rows remaining — its non-drawn FRQs were already backfilled by
-- 20260802014901/20260802015050; only its hand-drawn items are still null,
-- and those are correctly excluded below, same as Biology's.
--
-- Exclusion rule, generalized from the Biology migration's explicit
-- HDG-key filter: content_item_versions.prompt_json->>'hand_drawn' = 'true'
-- reliably identifies every construction/drawn-response item independent of
-- content_key naming convention (verified across both AP Biology's
-- APBIO-HDG-2026-GRAPH-* keys, which carry rubric_type='discrete_text', and
-- AP Statistics's APSTATS-HDG-2026-GRAPH-*/apstats-frq-u12-005-style items,
-- which carry rubric_type='spatial' — the key pattern differs, the
-- hand_drawn flag does not). These items require Program B (drawn-response
-- capture), which remains launch-blocked per TASK-0020; backfilling them
-- would make construction items selectable into student practice sessions
-- with no way to answer them, exactly the failure mode the Biology
-- migration's comment already called out.
--
-- ONE-WAY DOOR — same as 20260805110000. The prevent_live_frq_reclassification
-- guard permits NULL -> non-null only. Once these rows are non-null, moving
-- them to 'full_exam_frq' raises published_frq_reclassification_requires_retirement.
-- 'targeted_drill' is used uniformly, matching every existing precedent
-- (20260801 AP Statistics, 20260802 AP Statistics remainder, 20260805 AP
-- Biology) — none of these five subjects' non-drawn published FRQ corpora is
-- large/complete enough to assemble a real full_exam_frq section yet.
--
-- Recurrence note — NOT fixed by this migration. This backfill only clears
-- the *current* gap; any FRQ published after this migration runs will again
-- have practice_format IS NULL until someone re-runs a backfill like this
-- one. A preventive fix (e.g. requiring practice_format to be set at publish
-- time for non-drawn FRQs) is a separate, larger change to the publish path
-- and is intentionally out of scope here — flagged for follow-up, not
-- silently deferred.
--
-- This does NOT make any item student-visible beyond what serving already
-- allows for each subject; it only clears the practice_format blocker so
-- select_practice_frqs can consider these items. Biology's images remain
-- separately gated by app.content_asset_metadata.approved_at.

begin;

do $$
declare
  v_expected constant integer := 100;
  v_eligible integer;
  v_updated integer;
begin
  select count(*) into v_eligible
  from app.content_items ci
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and ci.practice_format is null
    and not exists (
      select 1 from app.content_item_versions civ
      where civ.content_item_id = ci.id
        and civ.status = 'published'
        and civ.prompt_json->>'hand_drawn' = 'true'
    );

  -- Fail closed on drift. If the published corpus changed since the
  -- 2026-08-05 verification, stop rather than silently reclassifying a
  -- different set of items through a one-way door.
  if v_eligible <> v_expected then
    raise exception
      'practice_format_backfill_count_drift: expected % eligible items, found %',
      v_expected, v_eligible;
  end if;

  update app.content_items ci
  set practice_format = 'targeted_drill'
  where ci.item_type = 'frq'
    and ci.status = 'published'
    and ci.practice_format is null
    and not exists (
      select 1 from app.content_item_versions civ
      where civ.content_item_id = ci.id
        and civ.status = 'published'
        and civ.prompt_json->>'hand_drawn' = 'true'
    );

  get diagnostics v_updated = row_count;

  if v_updated <> v_expected then
    raise exception
      'practice_format_backfill_update_mismatch: expected %, updated %',
      v_expected, v_updated;
  end if;
end;
$$;

commit;
