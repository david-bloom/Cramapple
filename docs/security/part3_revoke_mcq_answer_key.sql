-- Coordinated answer-key-exposure fix — PART 3 of 3 (the REVOKE). STAGED, NOT APPLIED.
--
-- ⚠️  This file is DELIBERATELY kept OUT of supabase/migrations/ so it cannot be
--     db-pushed to Prod before PART 2 (the repointed reviewer front-end) is live.
--     Applying this while the reviewer UI still reads app.mcq_choices directly would
--     BLIND reviewers to the answer key of items under review.
--
-- Apply order (do NOT reorder — see docs/security/MCQ_ANSWER_KEY_COORDINATED_FIX.md):
--   PART 1  migrations/20260824040000_reviewer_mcq_answer_key_rpc.sql   -> apply first
--   PART 2  exam-buddy-wireframe review.functions.ts -> get_review_mcq_choices RPC, PUBLISH
--   PART 3  THIS FILE                                                    -> apply LAST
--
-- To apply: only AFTER PART 2 is published and verified (an assigned reviewer still
-- sees the keyed-correct choice + rationales via the RPC), promote this to a migration
-- (e.g. supabase/migrations/20260824060000_revoke_mcq_answer_key_from_authenticated.sql)
-- OR run it directly, on Dev first, then Prod.
--
-- Verified live 2026-08-24 (session 3): the ONLY authenticated client read of
-- app.mcq_choices.is_correct/rationale is exam-buddy-wireframe
-- review.functions.ts:221 (the PART 2 target). The student serving path
-- (use-published-mcq.ts) selects only (id, choice_key, choice_text) and is
-- unaffected. `anon` holds no grant on these columns, so revoking from it is a
-- harmless no-op included for completeness.

begin;

-- Close the student answer-key leak. Reviewers now read is_correct/rationale via
-- public.get_review_mcq_choices (SECURITY DEFINER), so this no longer blinds them.
revoke select (is_correct, rationale) on app.mcq_choices from authenticated, anon;

commit;

-- Post-check (should return NO rows — no authenticated/anon grant on the two columns):
--   select grantee, string_agg(privilege_type||':'||column_name, ', ')
--   from information_schema.column_privileges
--   where table_schema='app' and table_name='mcq_choices'
--     and grantee in ('authenticated','anon') and column_name in ('is_correct','rationale')
--   group by grantee;
