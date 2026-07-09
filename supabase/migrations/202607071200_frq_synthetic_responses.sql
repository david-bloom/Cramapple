-- Synthetic student responses for real (non-bootstrap) FRQ content items.
--
-- Distinct from app.bootstrap_frq_synthetic_responses (which backs the fully
-- synthetic AP Statistics bootstrap calibration corpus that has no
-- app.content_items rows of its own). This table links directly to
-- app.content_item_versions for FRQ items that already live in the real
-- content pipeline (e.g. AP Biology's 142 FRQ items), so calibration
-- responses can be authored against production content without a mirror
-- table.

begin
create table if not exists app.frq_synthetic_responses (
  id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete cascade,
  response_type text not null,
  student_response text not null,
  created_at timestamptz not null default now(),
  constraint frq_synthetic_responses_type_check
    check (response_type in ('fully_correct', 'borderline', 'partially_correct', 'subtly_wrong', 'incorrect'))
)
create index frq_synthetic_responses_civ_id_idx on app.frq_synthetic_responses(content_item_version_id)
create index frq_synthetic_responses_type_idx on app.frq_synthetic_responses(response_type)
alter table app.frq_synthetic_responses enable row level security
create policy "frq_synthetic_responses_service_all"
on app.frq_synthetic_responses
for all
to service_role
using (true)
with check (true)
grant select, insert, update, delete on app.frq_synthetic_responses to service_role
comment on table app.frq_synthetic_responses is
  'Synthetic student responses for real FRQ content_item_versions (e.g. AP Biology FRQ bootstrap calibration). Long-form items typically have 4 responses (fully_correct, borderline, partially_correct, subtly_wrong); short-form items typically have 2 (fully_correct, incorrect).'
commit
