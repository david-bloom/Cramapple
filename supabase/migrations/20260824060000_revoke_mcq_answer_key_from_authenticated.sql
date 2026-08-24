-- Coordinated answer-key-exposure fix — PART 3 of 3 (close the leak).
--
-- APPLIED + VERIFIED on Dev (wmgjsdkphcyhngaffbqf) and Prod (pcntajvbdfqhbeewmdry)
-- on 2026-08-24 (session 3). Promoted to a migration only AFTER PART 2 (the reviewer
-- front-end repointed at public.get_review_mcq_choices) was published, so it can no
-- longer blind the reviewer UI.
--
-- Why not a column-level revoke: `authenticated` held a TABLE-level SELECT grant on
-- app.mcq_choices (ACL `authenticated=r`), which confers every column. A
-- `revoke select (is_correct, rationale) ... from authenticated` is a NO-OP against a
-- table-wide grant (proven live on Dev). The correct fix drops the table-wide SELECT
-- and re-grants ONLY the non-secret columns. Reviewers read is_correct/rationale via
-- the SECURITY DEFINER RPC public.get_review_mcq_choices (PART 1,
-- 20260824040000_reviewer_mcq_answer_key_rpc.sql), so they are not blinded.
--
-- app.mcq_choices columns: id, content_item_version_id, choice_key, choice_text,
--   is_correct, rationale, created_at.  Secret = is_correct, rationale.
-- `anon` holds no grant here (no-op). On Prod a separate `content_reviewer` role also
--   holds table-level SELECT (a reviewer/back-office role, NOT student-assumable); it is
--   intentionally left untouched.
--
-- Idempotent: re-running is harmless (revoke of an absent grant / grant of an existing
-- one are no-ops).

begin;

revoke select on app.mcq_choices from authenticated;

grant select (id, content_item_version_id, choice_key, choice_text, created_at)
  on app.mcq_choices to authenticated;

commit;
