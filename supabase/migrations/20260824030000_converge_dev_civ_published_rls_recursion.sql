-- Converge Dev's content_item_versions "published" SELECT policy to Prod's
-- known-good, non-recursive form.
--
-- Bug (Dev only): app.content_item_versions_select_published used an INLINE
-- subquery into app.content_items. Because content_items also has RLS whose
-- ci_select_assigned_reviewer policy subqueries back into content_item_versions,
-- any authenticated SELECT of published content hit
--   ERROR 42P17: infinite recursion detected in policy for relation ...
-- This broke the entire student content-read path on Dev (the front-end serves
-- home MCQs via a direct RLS read: content_item_versions ⨝ content_items!inner
-- ⨝ mcq_choices!inner). Prod was unaffected: Prod's policy delegates the
-- published check to the SECURITY DEFINER helper app.content_item_is_published(),
-- which reads content_items WITHOUT re-triggering RLS, breaking the cycle.
--
-- Fix: replace the inline predicate with the same helper call Prod uses. The
-- helper already exists on Dev (STABLE, SECURITY DEFINER, search_path pinned).
-- No behavioural change vs Prod; no security regression (the function returns
-- true only when both the content_item and its exam_pack_version are published).
--
-- Idempotent + Prod-safe: DROP ... IF EXISTS then CREATE. On Prod this recreates
-- the identical policy (no-op effect).

begin;

drop policy if exists content_item_versions_select_published
  on app.content_item_versions;

create policy content_item_versions_select_published
  on app.content_item_versions
  for select
  to authenticated
  using (
    status = 'published'
    and app.content_item_is_published(content_item_id)
  );

commit;
