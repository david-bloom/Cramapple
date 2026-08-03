-- Fix: admins could not see draft/assigned/reviewed_* content in the admin
-- dashboard ("no question in draft?"). app.content_items and
-- app.content_item_versions only had two SELECT policies for `authenticated`:
--   - see items YOU are personally assigned to review
--   - see published items (with a published exam pack version)
-- There was no "admin sees everything regardless of status" policy at all,
-- despite src/lib/dashboard.functions.ts's comment claiming one existed.
-- David's admin session could therefore only see published content plus
-- whatever he personally happened to be assigned to review — every other
-- draft/assigned/reviewed_approved/reviewed_disapproved row was invisible.
--
-- Adds the same admin-role SELECT policy already used elsewhere in this
-- schema (see e.g. artifact_label_assignments_staff_select).

begin;

create policy content_items_admin_select
  on app.content_items
  for select
  to authenticated
  using (
    exists (
      select 1 from app.profiles p
      where p.user_id = auth.uid() and p.role = 'admin'
    )
  );

create policy content_item_versions_admin_select
  on app.content_item_versions
  for select
  to authenticated
  using (
    exists (
      select 1 from app.profiles p
      where p.user_id = auth.uid() and p.role = 'admin'
    )
  );

commit;
