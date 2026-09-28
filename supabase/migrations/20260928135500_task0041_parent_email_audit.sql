begin;

create table if not exists app.parent_payment_email_requests (
  id uuid primary key default gen_random_uuid(),
  checkout_session_id text not null,
  parent_email_hash text not null,
  status text not null,
  created_at timestamptz not null default now()
);
create index if not exists parent_payment_email_requests_session_created_idx
  on app.parent_payment_email_requests (checkout_session_id, created_at desc);
alter table app.parent_payment_email_requests enable row level security;
drop policy if exists "parent_payment_email_requests_service_all"
  on app.parent_payment_email_requests;
create policy "parent_payment_email_requests_service_all"
on app.parent_payment_email_requests for all to service_role
using (true) with check (true);
grant select, insert, update, delete on app.parent_payment_email_requests to service_role;

commit;
