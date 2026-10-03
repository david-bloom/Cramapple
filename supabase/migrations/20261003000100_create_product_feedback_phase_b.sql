-- TASK-0061 Phase B: general product/UX feedback.
-- Applied to Development first on 2026-10-03.
-- Deliberately separate from per-question content reports and grading disputes.

create table if not exists app.product_feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  category text not null check (category in ('not_working','confusing','idea','other')),
  note text null check (note is null or char_length(note) <= 2000),
  route text null check (route is null or char_length(route) <= 200),
  subject_key text null check (subject_key is null or char_length(subject_key) <= 100),
  created_at timestamptz not null default now()
);

alter table app.product_feedback enable row level security;

create policy "product_feedback_insert_own"
on app.product_feedback for insert
to authenticated
with check (user_id = auth.uid());

create policy "product_feedback_select_own"
on app.product_feedback for select
to authenticated
using (user_id = auth.uid());

revoke all on app.product_feedback from anon;
grant select, insert on app.product_feedback to authenticated;

comment on table app.product_feedback is
  'General Cramapple product/UX feedback. Separate from per-question content reports and grading disputes.';
