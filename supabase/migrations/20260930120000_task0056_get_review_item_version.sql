-- TASK-0056 step 2 (DECISION-0089): reviewer read of an item version, without the
-- broad authenticated grant. Additive; changes no existing behaviour.
--
-- Why: the reviewer portal's getReviewTask (Lovable app 56cae479 and
-- exam-buddy-wireframe, src/lib/review.functions.ts) selects `explanation` from
-- public.content_item_versions with the reviewer's own token. Step 3 revokes
-- `explanation` (and the answer keys) from `authenticated`, which would fail that
-- whole select. This function returns the same columns to an assigned reviewer
-- or an admin only, gated exactly like public.get_review_mcq_choices
-- (20260824040000). SECURITY DEFINER, so it keeps working after the revoke.
--
-- Sequencing (do NOT reorder):
--   1. this migration                                   -> Dev, then Prod
--   2. switch getReviewTask to this RPC                 -> Lovable edit
--   3. 20260930120100_task0056_revoke_answer_key_reads  -> Dev, then Prod, LAST
--
-- Rollback: drop function public.get_review_item_version(uuid);
--
-- Trap 1: record this as version 20260930120000 on every environment (file name = ledger version).

begin;

create or replace function public.get_review_item_version(p_content_item_version_id uuid)
returns table (
  id uuid,
  version_num integer,
  stem text,
  stimulus text,
  stimulus_image_path text,
  explanation text,
  item_type text,
  frq_form text,
  review_status text,
  content_key text
)
language sql
stable
security definer
set search_path to 'app', 'pg_temp'
as $$
  select civ.id, civ.version_num, civ.stem, civ.stimulus, civ.stimulus_image_path,
         civ.explanation, ci.item_type, ci.frq_form, civ.review_status, ci.content_key
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  where civ.id = p_content_item_version_id
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
    );
$$;

revoke all on function public.get_review_item_version(uuid) from public, anon;
grant execute on function public.get_review_item_version(uuid) to authenticated, service_role;

comment on function public.get_review_item_version(uuid) is
  'Reviewer/admin-only read of one content_item_version, including explanation. SECURITY DEFINER so explanation and the answer keys can be revoked from the broad authenticated grant (TASK-0056, DECISION-0089) without blinding the reviewer portal.';

commit;
