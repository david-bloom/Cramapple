-- Paywall sample access: fixes for the two Codex QA findings (2026-11-09).
-- Spec: docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md §12 (P4), §7 (P2).
-- Development only; Production needs its own APPROVAL.
--
-- QA finding 1: app.sample_supersede_on_entitlement required starts_at <= now(),
-- so a regular entitlement inserted or updated with a future start never
-- superseded the sample. While that row was active the regular path won, but
-- when it ended the sample grant was still 'active' and revived. P4 says any
-- regular entitlement supersedes the sample permanently: a scheduled start is
-- still a purchase or trial, so the start date no longer matters. Only rows
-- that have already ended are ignored.
--
-- QA finding 2 is an edge-function change (attempt-response propose_transcript
-- now fails closed when app.sample_take_photo_run errors unexpectedly); it has
-- no SQL component. The down script for 20261108201632 already drops the
-- trigger function, so no separate down step is needed for this file.

begin;

create or replace function app.sample_supersede_on_entitlement()
returns trigger language plpgsql security definer set search_path = pg_catalog as $$
begin
  if new.status = 'active' and (new.ends_at is null or new.ends_at > now())
     and new.access_tier in ('trial', 'paid', 'beta') then
    update app.sample_grants g
    set status = 'superseded', superseded_at = now(), superseded_by = new.access_tier
    where g.user_id = new.user_id and g.status = 'active';
  end if;
  return new;
end;
$$;
revoke all on function app.sample_supersede_on_entitlement() from public, anon, authenticated;

-- Backfill: any sample grant still 'active' beside a not-yet-ended regular
-- entitlement row (Development has none today; this keeps the rule true
-- wherever the migration is applied).
update app.sample_grants g
set status = 'superseded', superseded_at = now(),
    superseded_by = (select e.access_tier from app.subject_entitlements e
                     where e.user_id = g.user_id and e.status = 'active'
                       and (e.ends_at is null or e.ends_at > now())
                       and e.access_tier in ('trial', 'paid', 'beta')
                     order by e.starts_at limit 1)
where g.status = 'active'
  and exists (select 1 from app.subject_entitlements e
              where e.user_id = g.user_id and e.status = 'active'
                and (e.ends_at is null or e.ends_at > now())
                and e.access_tier in ('trial', 'paid', 'beta'));

commit;
