-- TASK-0056b (DECISION-0089, follow-on): close the answer key's second copy.
--
-- Why this exists: 20260930120100/120200 revoked canonical_answer_1/2,
-- explanation, item_package_payload and the frq_criteria rubric columns, and
-- those revokes are real. But the same answer material is duplicated inside
-- app.content_item_versions.prompt_json, which 20260930120200 GRANTS to
-- `authenticated` in its own safe-column list and 20260930120100 PROJECTS into
-- public.content_item_versions.
--
-- Measured on Production 2026-09-30, over 1,506 published versions:
--   212 rows whose prompt_json contains the exact string of the revoked
--       canonical_answer_1
--    46 rows containing the revoked explanation
--   106 rows with a `canonical_answers` key; 74 with an "is_correct" token
-- Read as a real student, public.content_item_versions returned 106 rows with
-- canonical_answers, and public.select_practice_frqs -- the live student FRQ
-- path -- returned 12 of 50 served items carrying answer or rubric content.
--
-- This is the condition TASK-0051's independent QA blocked on (F1): a key
-- readable with no entitlement check and no open_hand_scoring_exclusions row,
-- so a student can read the answer and still be scored. Evidence:
-- docs/qa/TASK-0056_INDEPENDENT_QA_2026_09_30.md.
--
-- Apply AFTER 20260930120200, on every environment.
--
-- Blast radius checked before writing (Production, 2026-09-30):
--   * supabase/functions/student-session-items reads prompt_json with the
--     SERVICE ROLE and discards it (withHandDrawnFlag keeps only hand_drawn
--     and the authored question_parts). Unaffected.
--   * supabase/functions/review-queue reads it with the service role. Unaffected.
--   * The Lovable client's only direct read of content_item_versions is
--     buildPublishedMcqQuery, whose select list is explicit
--     (id, content_item_id, content_key, stem, stimulus + embedded parents)
--     and does not include prompt_json. Its ServedItem type has no such field.
--   * 24h of Production edge_logs show ZERO PostgREST requests to
--     content_item_versions or to any of the three select_* RPCs.
--
-- The three select_* functions return prompt_json in their RETURNS TABLE.
-- select_unit_gated_practice_items is SECURITY DEFINER, so a column revoke
-- alone does NOT stop it handing prompt_json to a student. Rather than change
-- three function signatures two days before launch, EXECUTE is revoked from
-- anon/authenticated; service_role keeps it, which is all student-session-items
-- needs. Changing the signatures to return a whitelisted presentation
-- projection is the durable fix and belongs to its own task.
--
-- ROLLBACK:
--   grant select (prompt_json) on app.content_item_versions to authenticated;
--   -- recreate the view with civ.prompt_json restored after civ.stimulus_image_path:
--   -- see this file's create view below and re-add that one line.
--   grant execute on function public.select_practice_frqs(uuid, text, integer) to authenticated;
--   grant execute on function public.select_unit_gated_practice_items(uuid, integer, text, text, integer) to authenticated;
--   grant execute on function public.select_hand_drawn_pilot_items(uuid, integer) to anon, authenticated;
--
-- Trap 1: record this as version 20260930190000 on every environment (file name = ledger version).

begin;

-- 1. The column. 20260930120200 replaced the table-level grant with an explicit
--    column list, so a column-level revoke is effective here (it was not before
--    that migration -- that is the no-op this pattern exists to avoid).
revoke select (prompt_json) on app.content_item_versions from authenticated, anon;

-- 2. The public view. Supabase re-grants ALL on a recreated view in `public`
--    (pg_default_acl), so the revoke/grant below is required, not decorative.
drop view if exists public.content_item_versions;
create view public.content_item_versions
with (security_invoker = true) as
 SELECT civ.id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.title,
    civ.version_num,
    civ.stem,
    civ.stimulus,
    civ.stimulus_image_path,
    civ.help_text,
    civ.content_hash,
    civ.review_status,
    civ.status,
    civ.approved_at,
    civ.approved_by,
    civ.published_at,
    civ.created_by,
    civ.created_at,
    civ.updated_at
   FROM app.content_item_versions civ
     JOIN app.content_items ci ON ci.id = civ.content_item_id
     JOIN app.exam_pack_versions epv ON epv.id = ci.exam_pack_version_id
     JOIN app.exam_packs ep ON ep.id = epv.exam_pack_id
     JOIN app.subjects s ON s.id = ep.subject_id;

revoke all on public.content_item_versions from anon, authenticated;
grant select on public.content_item_versions to authenticated;

-- 3. The selector RPCs. service_role keeps EXECUTE; the edge function calls
--    them with it. SECURITY DEFINER on select_unit_gated_practice_items means
--    this revoke, not the column revoke above, is what closes that route.
revoke execute on function public.select_practice_frqs(uuid, text, integer)
  from anon, authenticated;
revoke execute on function public.select_unit_gated_practice_items(uuid, integer, text, text, integer)
  from anon, authenticated;
revoke execute on function public.select_hand_drawn_pilot_items(uuid, integer)
  from anon, authenticated;

commit;
