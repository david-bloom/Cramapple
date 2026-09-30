-- TASK-0056 step 3 (DECISION-0089): close direct reads of answer keys.
--
-- Before this, any signed-in student could read every published item's answer
-- key through PostgREST: column grants to `authenticated` on the base tables,
-- plus the public views re-projecting the same columns (Production also granted
-- the public view to `anon`).
--
-- After this, those fields reach students only through intended paths:
--   canonical_answer_1/2        public.get_open_hand_item (records an exclusion);
--                               grading (service role)
--   item_package_payload        none (served shape comes from student-session-items)
--   explanation                 grading response (service role); reviewers via
--                               public.get_review_item_version
--   evidence_requirements,
--   accepted_variants,
--   minimum_fix                 hint flow / Open Hand RPC (recorded use)
-- Edge functions read these with the service-role client and are unaffected.
--
-- PRECONDITIONS (do NOT apply before both are true on the target environment):
--   * 20260930120000_task0056_get_review_item_version is applied.
--   * The reviewer portal's getReviewTask calls get_review_item_version instead
--     of selecting `explanation` from public.content_item_versions.
--
-- Verify after apply: scripts/qa/answer_key_exposure_guard.sql returns no rows.
--
-- Views are dropped and recreated (a view cannot drop a column in place). No
-- other view depends on them (checked on Dev and Prod, 2026-09-30). Supabase's
-- default privileges grant ALL on new public relations to anon/authenticated,
-- so grants are reset explicitly below.
--
-- ROLLBACK: re-grant the revoked columns and restore the prior views:
--   grant select (canonical_answer_1, canonical_answer_2, explanation, item_package_payload)
--     on app.content_item_versions to authenticated;
--   grant select (evidence_requirements, accepted_variants, minimum_fix)
--     on app.frq_criteria to authenticated;
--   then recreate both views with the prior column lists: the current list plus
--   civ.explanation and civ.canonical_answer_1/2 (after help_text/content_hash,
--   in that order) and fc.evidence_requirements, fc.minimum_fix,
--   fc.accepted_variants (after points_possible), and restore the prior grants
--   (Prod: anon + authenticated SELECT on public.content_item_versions;
--   authenticated SELECT on public.frq_criteria).
--
-- Trap 1: rename this file to the version each environment records on apply.

begin;

-- Base tables ---------------------------------------------------------------

revoke select (canonical_answer_1, canonical_answer_2, explanation, item_package_payload)
  on app.content_item_versions from authenticated, anon;

revoke select (evidence_requirements, accepted_variants, minimum_fix)
  on app.frq_criteria from authenticated, anon;

-- public.content_item_versions ---------------------------------------------

drop view public.content_item_versions;

create view public.content_item_versions
with (security_invoker = true) as
select civ.id,
       civ.content_item_id,
       ci.exam_pack_version_id,
       epv.exam_pack_id,
       ep.exam_code,
       ep.exam_name,
       ep.subject_id,
       s.subject_key,
       s.display_name as subject_name,
       ci.content_key,
       ci.item_type,
       ci.frq_form,
       ci.title,
       civ.version_num,
       civ.stem,
       civ.stimulus,
       civ.stimulus_image_path,
       civ.prompt_json,
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
from app.content_item_versions civ
join app.content_items ci on ci.id = civ.content_item_id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id;

revoke all on public.content_item_versions from anon, authenticated;
grant select on public.content_item_versions to authenticated;
grant all on public.content_item_versions to service_role;

-- public.frq_criteria -------------------------------------------------------

drop view public.frq_criteria;

create view public.frq_criteria
with (security_invoker = true) as
select fc.id,
       fc.content_item_version_id,
       civ.content_item_id,
       ci.exam_pack_version_id,
       epv.exam_pack_id,
       ep.exam_code,
       ep.exam_name,
       ep.subject_id,
       s.subject_key,
       s.display_name as subject_name,
       ci.content_key,
       ci.item_type,
       ci.title,
       fc.criterion_key,
       fc.learner_facing_text,
       fc.points_possible,
       fc.created_at
from app.frq_criteria fc
join app.content_item_versions civ on civ.id = fc.content_item_version_id
join app.content_items ci on ci.id = civ.content_item_id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id;

revoke all on public.frq_criteria from anon, authenticated;
grant select on public.frq_criteria to authenticated;
grant all on public.frq_criteria to service_role;

commit;
