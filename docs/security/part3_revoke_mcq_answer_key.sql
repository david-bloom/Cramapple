-- Coordinated answer-key-exposure fix — PART 3 of 3 (close the leak). CORRECTED.
--
-- ✅ PROMOTED + APPLIED: this is now the canonical migration
--    supabase/migrations/20260824060000_revoke_mcq_answer_key_from_authenticated.sql,
--    APPLIED + VERIFIED on Dev AND Prod on 2026-08-24. This copy is kept as reference.
--
-- ⚠️  CORRECTION (2026-08-24, session 3): the original PART 3 was
--       revoke select (is_correct, rationale) on app.mcq_choices from authenticated, anon;
--     That is a NO-OP here. `authenticated` holds a TABLE-LEVEL SELECT grant
--     (ACL `authenticated=r`, confirmed on both Dev and Prod), and a COLUMN-level
--     revoke cannot subtract a column from a whole-table grant — the column stays
--     readable. (Proven live on Dev: after the column revoke, an `authenticated`
--     read of is_correct still succeeded.) The correct fix drops the table-wide
--     SELECT and re-grants ONLY the non-secret columns.
--
-- ⚠️  Still DELIBERATELY kept OUT of supabase/migrations/ so it cannot be
--     db-pushed to Prod before PART 2 (the repointed reviewer front-end) is live.
--     Applying this while the published (Prod-pointed) reviewer UI still reads
--     app.mcq_choices directly would BLIND reviewers to the answer key.
--
-- Apply order (do NOT reorder — see docs/security/MCQ_ANSWER_KEY_COORDINATED_FIX.md):
--   PART 1  migrations/20260824040000_reviewer_mcq_answer_key_rpc.sql   -> apply first
--   PART 2  exam-buddy-wireframe review.functions.ts -> get_review_mcq_choices RPC, PUBLISH
--   PART 3  THIS FILE                                                    -> apply LAST
--
-- APPLIED + VERIFIED on Dev (wmgjsdkphcyhngaffbqf) 2026-08-24: after this, an
-- `authenticated` read of is_correct/rationale is denied, while choice_key/choice_text
-- (the student serving path, use-published-mcq.ts) still read. NOT yet applied to Prod.
--
-- app.mcq_choices columns: id, content_item_version_id, choice_key, choice_text,
--   is_correct, rationale, created_at. Secret = is_correct, rationale.
-- `anon` holds no grant on this table (no-op there). On PROD an additional role
--   `content_reviewer` also holds table-level SELECT; it is a reviewer/back-office
--   role (NOT student-assumable — app reviewers authenticate as `authenticated`), so
--   it is intentionally left as-is. Confirm that role's purpose before assuming.

begin;

-- Drop the table-wide SELECT that confers every column (the actual leak vector)...
revoke select on app.mcq_choices from authenticated;

-- ...and re-grant ONLY the non-secret columns (everything except is_correct/rationale).
-- Reviewers now read the answer key via public.get_review_mcq_choices (SECURITY
-- DEFINER), so they are not blinded by losing the table grant.
grant select (id, content_item_version_id, choice_key, choice_text, created_at)
  on app.mcq_choices to authenticated;

commit;

-- Post-check A — table-level SELECT for authenticated should now be NONE:
--   select privilege_type from information_schema.role_table_grants
--   where table_schema='app' and table_name='mcq_choices' and grantee='authenticated';
--
-- Post-check B — authenticated column SELECT should list the 5 non-secret columns
-- and NOT is_correct/rationale:
--   select column_name from information_schema.column_privileges
--   where table_schema='app' and table_name='mcq_choices'
--     and grantee='authenticated' and privilege_type='SELECT' order by column_name;
--
-- Post-check C — functional, as the authenticated role:
--   set local role authenticated;
--   select is_correct from app.mcq_choices limit 1;   -- expect: permission denied
--   select choice_key from app.mcq_choices limit 1;   -- expect: OK (RLS-filtered rows)
--   reset role;
