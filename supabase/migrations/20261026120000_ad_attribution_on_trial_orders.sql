-- Ad attribution on card-trial orders (design: docs/product/AD_ATTRIBUTION_DESIGN_2026_10_26.md).
-- Additive and nullable: trial_start stores a strict allow-listed object
-- (touch fields + PostHog anonymous id, or just {"ad_tracking_allowed": false}).
-- Nothing in charging, access or email reads it.
alter table app.trial_orders add column if not exists ad_attribution jsonb;

comment on column app.trial_orders.ad_attribution is
  'Allow-listed acquisition data from trial_start: ad_tracking_allowed, anon_id, first_touch, last_touch. Never contains email, name or ids of the student.';

-- Reporting view: one row per order with the channel fields flattened.
-- Last touch wins, first touch fills gaps. service_role only (see grants).
create or replace view app.v_trial_attribution as
select
  o.id as order_id,
  o.created_at,
  o.status,
  o.trial_started_at,
  o.offer,
  o.charge_amount,
  (o.ad_attribution ->> 'ad_tracking_allowed')::boolean as ad_tracking_allowed,
  o.ad_attribution ->> 'anon_id' as anon_id,
  coalesce(o.ad_attribution #>> '{last_touch,utm_medium}', o.ad_attribution #>> '{first_touch,utm_medium}') as utm_medium,
  coalesce(o.ad_attribution #>> '{last_touch,utm_source}', o.ad_attribution #>> '{first_touch,utm_source}') as utm_source,
  coalesce(o.ad_attribution #>> '{last_touch,utm_campaign}', o.ad_attribution #>> '{first_touch,utm_campaign}') as utm_campaign,
  coalesce(o.ad_attribution #>> '{last_touch,utm_content}', o.ad_attribution #>> '{first_touch,utm_content}') as utm_content,
  coalesce(o.ad_attribution #>> '{last_touch,referrer_host}', o.ad_attribution #>> '{first_touch,referrer_host}') as referrer_host,
  (o.status = 'converted') as converted
from app.trial_orders o;

revoke all on app.v_trial_attribution from public, anon, authenticated;
grant select on app.v_trial_attribution to service_role;
