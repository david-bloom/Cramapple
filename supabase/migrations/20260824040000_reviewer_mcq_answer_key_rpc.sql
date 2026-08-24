-- Coordinated answer-key-exposure fix — PART 1 of 3 (additive, safe to deploy
-- anytime; changes no existing behaviour).
--
-- Problem: app.mcq_choices grants column SELECT on is_correct/rationale to the
-- `authenticated` role, and RLS policy mcq_choices_select_published returns any
-- published item's choices to any logged-in user — so a student can read the
-- answer key for every published MCQ (proven live on Prod 2026-08-24). We cannot
-- simply REVOKE those columns from `authenticated`, because the reviewer UI reads
-- them through the SAME authenticated grant (review.functions.ts, via the
-- publishable key + the reviewer's Bearer token) to show the key of items under
-- review (RLS policy mcq_choices_select_assigned_reviewer). Column grants can't
-- tell a reviewer-on-assigned from a student-on-published.
--
-- Fix: this SECURITY DEFINER RPC returns the answer key ONLY to a caller who is
-- an assigned reviewer (pending/in_progress/submitted) for that version, or an
-- admin. The reviewer front-end is then repointed at this RPC (PART 2), after
-- which the broad column grant is revoked (PART 3). Because this function is
-- SECURITY DEFINER it keeps working after the revoke.
--
-- Sequencing (do NOT reorder):
--   PART 1  this migration                              -> apply now / anytime
--   PART 2  repoint exam-buddy-wireframe reviewer read  -> Lovable, then publish
--   PART 3  REVOKE SELECT (is_correct, rationale)       -> apply LAST
-- See docs/security/MCQ_ANSWER_KEY_COORDINATED_FIX.md for PART 2 + PART 3.

begin;

create or replace function public.get_review_mcq_choices(p_content_item_version_id uuid)
returns table (
  choice_key text,
  choice_text text,
  is_correct boolean,
  rationale text
)
language sql
stable
security definer
set search_path to 'app', 'pg_temp'
as $$
  select mc.choice_key, mc.choice_text, mc.is_correct, mc.rationale
  from app.mcq_choices mc
  where mc.content_item_version_id = p_content_item_version_id
    and (
      exists (
        select 1
        from app.content_review_assignments cra
        where cra.content_item_version_id = p_content_item_version_id
          and cra.reviewer_id = auth.uid()
          and cra.status = any (array['pending', 'in_progress', 'submitted'])
      )
      or exists (
        select 1
        from app.profiles p
        where p.user_id = auth.uid()
          and p.role = 'admin'
      )
    )
  order by mc.choice_key;
$$;

revoke all on function public.get_review_mcq_choices(uuid) from public, anon;
grant execute on function public.get_review_mcq_choices(uuid) to authenticated, service_role;

comment on function public.get_review_mcq_choices(uuid) is
  'Reviewer/admin-only MCQ answer key (is_correct/rationale) for an assigned content_item_version. SECURITY DEFINER so is_correct/rationale can be revoked from the broad authenticated grant (see docs/security/MCQ_ANSWER_KEY_COORDINATED_FIX.md) without blinding the reviewer UI.';

commit;
