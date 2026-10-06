-- Parent request recipients and their optional, verified student recovery context.
-- No client role can read either table. A worker must be explicitly enabled.
create table app.parent_email_lifecycle_context (
  id uuid primary key default gen_random_uuid(),
  checkout_session_id text not null references app.parent_payment_links(checkout_session_id),
  parent_email text not null,
  parent_email_hash text not null check (parent_email_hash ~ '^[0-9a-f]{64}$'),
  short_code text not null references app.parent_payment_links(code),
  stripe_expires_at timestamptz not null,
  request_sent_at timestamptz not null default now(),
  student_user_id uuid,
  student_email text,
  new_request_url text,
  pay_yourself_url text,
  unique (checkout_session_id, parent_email_hash),
  check (
    (student_user_id is null and student_email is null and new_request_url is null and pay_yourself_url is null)
    or
    (student_user_id is not null and student_email is not null and new_request_url is not null and pay_yourself_url is not null)
  )
);

create table app.parent_email_lifecycle_jobs (
  id uuid primary key default gen_random_uuid(),
  dedupe_key text not null unique,
  context_id uuid not null references app.parent_email_lifecycle_context(id),
  kind text not null check (kind in ('reminder', 'expired')),
  reminder_lead_seconds integer,
  due_at timestamptz not null,
  next_attempt_at timestamptz not null,
  created_at timestamptz not null default now(),
  delivered_at timestamptz,
  cancelled_at timestamptz,
  attempt_count integer not null default 0 check (attempt_count >= 0),
  lease_id uuid,
  leased_until timestamptz,
  last_error text,
  needs_review boolean not null default false,
  check (
    (kind = 'reminder' and reminder_lead_seconds > 0)
    or (kind = 'expired' and reminder_lead_seconds is null)
  )
);

create index parent_email_lifecycle_jobs_pending_idx
  on app.parent_email_lifecycle_jobs (next_attempt_at, due_at)
  where delivered_at is null and cancelled_at is null and not needs_review;
create index parent_email_lifecycle_jobs_context_idx
  on app.parent_email_lifecycle_jobs (context_id);

alter table app.parent_email_lifecycle_context enable row level security;
alter table app.parent_email_lifecycle_context force row level security;
alter table app.parent_email_lifecycle_jobs enable row level security;
alter table app.parent_email_lifecycle_jobs force row level security;
revoke all on app.parent_email_lifecycle_context from public, anon, authenticated;
revoke all on app.parent_email_lifecycle_jobs from public, anon, authenticated;
grant select, insert, update on app.parent_email_lifecycle_context to service_role;
grant select, insert, update on app.parent_email_lifecycle_jobs to service_role;
create policy parent_email_lifecycle_context_service
  on app.parent_email_lifecycle_context for all to service_role
  using (true) with check (true);
create policy parent_email_lifecycle_jobs_service
  on app.parent_email_lifecycle_jobs for all to service_role
  using (true) with check (true);

create function app.claim_parent_email_lifecycle_jobs(p_limit integer default 10)
returns setof app.parent_email_lifecycle_jobs
language sql security invoker set search_path = '' as $$
  update app.parent_email_lifecycle_jobs j
  set lease_id = gen_random_uuid(),
      leased_until = now() + interval '2 minutes',
      attempt_count = j.attempt_count + 1
  where j.id in (
    select q.id from app.parent_email_lifecycle_jobs q
    where q.delivered_at is null and q.cancelled_at is null
      and not q.needs_review
      and q.due_at <= now() and q.next_attempt_at <= now()
      and (q.leased_until is null or q.leased_until < now())
    order by q.due_at, q.created_at
    limit greatest(1, least(p_limit, 10))
    for update skip locked
  ) returning j.*;
$$;
revoke all on function app.claim_parent_email_lifecycle_jobs(integer)
  from public, anon, authenticated;
grant execute on function app.claim_parent_email_lifecycle_jobs(integer)
  to service_role;
