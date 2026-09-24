-- M4 of the AP Biology completion plan (docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md).
-- D4, approved 2026-09-24: remove prompt_json.total_points from the 9 Biology
-- items where it disagrees with the rubric.
--
-- NOT YET APPLIED. Production is a hard gate under
-- docs/team_charter/CRAMAPPLE_SESSION_START.md; this file is the reviewable
-- artifact, and it is applied only on explicit Product Owner go.
--
-- ---------------------------------------------------------------------------
-- Why removal rather than correction
--
-- Work order I established, and QA confirmed, that nothing reads this field:
-- evaluate-attempt sums frq_criteria.points_possible instead. So the question
-- was never "which number is right" but "should this field exist at all".
-- All 9 declare 8 against a rubric summing to 9, and all 9 share the identical
-- rubric shape a=1;b=3;c=3;d=2 -- one bad authoring template, not nine
-- independent errors.
--
-- ---------------------------------------------------------------------------
-- Rollback data, recorded here because the migration destroys it
--
-- Every one of the 9 rows currently holds total_points = 8. To reverse:
--   update app.content_item_versions
--   set prompt_json = jsonb_set(prompt_json, '{total_points}', '8'::jsonb)
--   where id in (<the 9 ids below>);
--
-- ---------------------------------------------------------------------------
-- Two caveats a reviewer should see before approving
--
-- 1. content_hash goes stale, and cannot be maintained. It is computed as
--    sha256Hex(JSON.stringify(artifact)) over the original intake payload
--    (supabase/functions/admin-content/index.ts:273), which is not stored. No
--    in-place data migration can recompute it. Prior in-place prompt_json
--    migrations in this repo's history already left it stale, and nothing
--    verifies it at grade time -- evaluate-attempt selects the column but never
--    checks it. So this adds one more stale hash to a set already unreliable,
--    rather than breaking something that currently works. Recorded as a finding
--    in its own right.
--
-- 2. It edits a published version in place. CONTENT_GOVERNANCE_AND_VALIDATION
--    governing principle 1 holds canonical content immutable and versioned. The
--    strict alternative -- bump 9 items to a new version_num -- would orphan the
--    taxonomy label layer's validated_against_version_id references and force
--    M2/M3 rework, for the sake of deleting an unread field. In-place is the
--    lower-risk option here, but it is a departure from principle 1 and is
--    named rather than hidden.
--
-- ---------------------------------------------------------------------------
-- Idempotent: the `? 'total_points'` guard makes re-running a no-op.

update app.content_item_versions
set prompt_json = prompt_json - 'total_points'
where id in (
  'c721f9eb-1f78-4fa0-b035-15701b663bde',  -- APBIO-FRQ-L-004 v2
  '9aaacb20-9b11-4867-aaff-57ec9dbb07cf',  -- APBIO-FRQ-L-006 v2
  '1514c2ee-7cc6-4173-b547-b1f5535a4e95',  -- APBIO-FRQ-L-012 v2
  '3f39e127-2862-4a16-9805-c8ad8251a224',  -- APBIO-FRQ-L-013 v2
  'f9ab1b6b-ec52-479b-9c31-fbad9dcc62e8',  -- APBIO-FRQ-L-015 v2
  '2fea6947-66ba-4080-9bcb-863c35adeb1b',  -- APBIO-FRQ-L-016 v3
  '1840ca34-d29d-45f2-b0c1-831759df1d46',  -- APBIO-FRQ-L-017 v2
  '0d8bb422-95ef-4e50-884e-38f83cb4cf6a',  -- APBIO-FRQ-L-019 v2
  '072da3bc-ba23-4a52-8ef5-f1bb9a8ae49a'   -- APBIO-FRQ-L-021 v1
)
and prompt_json ? 'total_points';

-- ---------------------------------------------------------------------------
-- Verification. Run after applying; all three must hold.
--
--   -- 1. the 9 no longer carry the field
--   select count(*) from app.content_item_versions
--   where id in (<the 9 ids>) and prompt_json ? 'total_points';        -- expect 0
--
--   -- 2. no Biology item has a total_points that disagrees with its rubric
--   select count(*) from public.content_items ci
--   join public.content_item_versions civ on civ.content_item_id = ci.id
--   where ci.subject_key = 'biology' and civ.status = 'published'
--     and (civ.prompt_json->>'total_points')::numeric
--         <> (select coalesce(sum(f.points_possible),0) from public.frq_criteria f
--             where f.content_item_version_id = civ.id);                -- expect 0
--
--   -- 3. nothing else in prompt_json changed: key counts drop by exactly 1
--   --    on these 9 and are unchanged everywhere else in Biology.
