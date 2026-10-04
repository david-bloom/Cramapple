-- TASK-0060: short links for "Ask a parent to pay".
--
-- The parent payment link is Stripe's hosted-checkout URL, which carries a
-- long encrypted fragment and is too long for SMS. A short code
-- (cramapple.com/p/<code>) maps to the Stripe Checkout Session id; a function
-- looks the session up at click time and returns its live URL, so the long URL
-- is never stored here and an expired or paid session is detected correctly.
--
-- Codes are 8 characters from a 31-character alphabet (no i, l, o, 0, 1), about
-- 39.6 bits. The code names only a Checkout Session that is already payable by
-- anyone holding its Stripe URL. Service role only: no anon or authenticated
-- access, so the only way in is the resolve-parent-link function.

begin;

create table if not exists app.parent_payment_links (
  code text primary key
    check (code ~ '^[a-hjkmnp-z2-9]{8}$'),
  checkout_session_id text not null unique,
  created_at timestamptz not null default now()
);

alter table app.parent_payment_links enable row level security;
alter table app.parent_payment_links force row level security;

drop policy if exists "parent_payment_links_service_all" on app.parent_payment_links;
create policy "parent_payment_links_service_all"
on app.parent_payment_links for all to service_role
using (true) with check (true);

revoke all on app.parent_payment_links from anon, authenticated;
grant select, insert, update, delete on app.parent_payment_links to service_role;

comment on table app.parent_payment_links is
  'Short code to Stripe Checkout Session id for parent payment links (TASK-0060). Service role only; resolved by the resolve-parent-link function.';

commit;
