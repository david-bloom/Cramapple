begin;

-- Per-IP and global rate limiting for the three unauthenticated payment
-- endpoints (create-parent-payment-link, resolve-parent-link,
-- get-checkout-status). Only the HMAC of the caller's IP is stored, never the
-- raw address. Service-role only; no client grants.
--
-- Only ALLOWED requests are recorded. A flood of denied requests therefore
-- cannot inflate the global counter and lock real parents out.

create table app.public_endpoint_hits (
  id bigint generated always as identity primary key,
  endpoint text not null,
  key_hmac text not null,
  created_at timestamptz not null default now()
);

create index public_endpoint_hits_key_idx
  on app.public_endpoint_hits (endpoint, key_hmac, created_at desc);
create index public_endpoint_hits_endpoint_idx
  on app.public_endpoint_hits (endpoint, created_at desc);

alter table app.public_endpoint_hits enable row level security;

create policy "public_endpoint_hits_service_all"
on app.public_endpoint_hits
for all to service_role
using (true)
with check (true);

revoke all on app.public_endpoint_hits from public, anon, authenticated;
grant select, insert, delete on app.public_endpoint_hits to service_role;

create or replace function app.record_public_endpoint_hit(
  p_endpoint text,
  p_key_hmac text,
  p_per_key_limit integer,
  p_global_limit integer,
  p_window_seconds integer
) returns jsonb
language plpgsql
set search_path = pg_catalog, app
as $$
declare
  v_since timestamptz := now() - make_interval(secs => p_window_seconds);
  v_key_count integer;
  v_global_count integer;
  v_oldest timestamptz;
begin
  if p_endpoint is null or p_key_hmac is null
     or p_per_key_limit < 1 or p_global_limit < 1 or p_window_seconds < 1 then
    raise exception 'invalid_rate_limit_arguments' using errcode = '22023';
  end if;

  -- Serialise concurrent hits for one caller so a burst cannot overshoot.
  perform pg_advisory_xact_lock(hashtextextended(p_endpoint || ':' || p_key_hmac, 0));

  select count(*), min(created_at) into v_key_count, v_oldest
  from app.public_endpoint_hits
  where endpoint = p_endpoint and key_hmac = p_key_hmac and created_at >= v_since;

  if v_key_count >= p_per_key_limit then
    return jsonb_build_object(
      'allowed', false,
      'scope', 'key',
      'retry_after_seconds',
      greatest(1, ceil(extract(epoch from (v_oldest + make_interval(secs => p_window_seconds) - now())))::integer)
    );
  end if;

  select count(*) into v_global_count
  from app.public_endpoint_hits
  where endpoint = p_endpoint and created_at >= v_since;

  if v_global_count >= p_global_limit then
    return jsonb_build_object('allowed', false, 'scope', 'global', 'retry_after_seconds', 60);
  end if;

  insert into app.public_endpoint_hits (endpoint, key_hmac) values (p_endpoint, p_key_hmac);

  -- Opportunistic cleanup keeps the table small without a cron job.
  if random() < 0.02 then
    delete from app.public_endpoint_hits where created_at < now() - interval '1 day';
  end if;

  return jsonb_build_object('allowed', true);
end;
$$;

revoke execute on function app.record_public_endpoint_hit(text, text, integer, integer, integer)
  from public, anon, authenticated;
grant execute on function app.record_public_endpoint_hit(text, text, integer, integer, integer)
  to service_role;

commit;
