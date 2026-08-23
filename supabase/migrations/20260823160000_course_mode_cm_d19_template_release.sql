-- Course Mode — CM-D19 template-release stamping (fail-closed, reversible, auditable).
--
-- CM-D19 (LEARNING_MODEL §6, APPROVED 2026-08-23): for generated content to be
-- servable, an approved *template* must be able to machine-stamp its *instances'*
-- review status + serving state, instead of a human approving every instance.
-- This encodes the D8 release bars David approved 2026-08-23 as a fail-closed gate:
-- a release is only stamped if the template's validation attestation clears every
-- bar. Everything is reversible per template (revoke un-stamps) and recorded for audit.
--
-- What "released" means (verified against the publish + serving gates):
--   * publish gate (20260808201500 / 20260809150000): content_item_versions may be
--     status='published' only when review_status is in the approved allowlist, so a
--     release stamps BOTH review_status='question_review_approved' AND status='published'
--     in one update (the NEW row satisfies the gate).
--   * serving selector (server_issued_session_targets): requires ci.status='published'
--     AND civ.status='published' (+ a published exam_pack_version + an active
--     subject_entitlement, which are separate governance switches — see NOTE below).
--
-- NOTE (not stamped here, by design): this stamps the ITEMS. Actually serving them to
-- a student additionally requires the exam_pack_version to be status='published' and the
-- student to hold an active subject_entitlement. Those are broader cycle-level governance
-- flips, deliberately left out of per-template stamping.

-- 1. The approved D8 release bars (versioned + auditable).
create table if not exists app.template_release_bars (
  bars_version              text primary key,
  sme_sample_min            int  not null,
  sme_defects_max           int  not null,
  property_instances_min    int  not null,
  property_rejects_max      int  not null,
  verifier_disagreements_max int not null,
  spot_audit_per_month      int  not null,
  approved_by               text,
  approved_at               timestamptz not null default now(),
  note                      text
);

insert into app.template_release_bars
  (bars_version, sme_sample_min, sme_defects_max, property_instances_min,
   property_rejects_max, verifier_disagreements_max, spot_audit_per_month, approved_by, note)
values
  ('cm-d19-phase1-2026-08-23', 20, 0, 100, 0, 0, 5, 'David',
   'Phase-1 pilot D8 bars, approved by David 2026-08-23: SME sample 20 instances/0 defects; '
   || '>=100 property instances/0 rejects; 0 verifier disagreements; 5 served instances/template/month spot-audit.')
on conflict (bars_version) do nothing;

-- 2. Release ledger — one row per (template_id, exam_pack_version), with the attestation.
create table if not exists app.template_releases (
  id                       uuid primary key default gen_random_uuid(),
  template_id              text not null,
  exam_pack_version_id     uuid not null references app.exam_pack_versions(id),
  taxonomy_source_version  uuid,
  bars_version             text not null references app.template_release_bars(bars_version),
  attestation              jsonb not null,
  spot_audit_per_month     int  not null,
  instances_stamped        int  not null default 0,
  released_by              uuid,
  released_at              timestamptz not null default now(),
  revoked_by               uuid,
  revoked_at               timestamptz,
  unique (template_id, exam_pack_version_id)
);
alter table app.template_release_bars enable row level security;
alter table app.template_releases     enable row level security;
-- service_role only: no policies -> only service_role / definer access (matches the
-- rest of the course-mode governance tables).

-- 3. Release a template: fail-closed D8 gate, then stamp its instances.
create or replace function app.cm_d19_release_template(
  p_template_id           text,
  p_exam_pack_version_id  uuid,
  p_attestation           jsonb,
  p_released_by           uuid  default null,
  p_bars_version          text  default 'cm-d19-phase1-2026-08-23'
) returns jsonb
language plpgsql
as $$
declare
  v_bars       app.template_release_bars;
  v_release_id uuid;
  v_stamped    int;
  v_tsv        uuid;
  v_sme_n int; v_sme_def int; v_prop_n int; v_prop_rej int; v_ver_dis int;
begin
  select * into strict v_bars from app.template_release_bars where bars_version = p_bars_version;

  -- Parse the attestation (all five bars must be present).
  v_sme_n    := (p_attestation->>'sme_sample_n')::int;
  v_sme_def  := (p_attestation->>'sme_defects')::int;
  v_prop_n   := (p_attestation->>'property_instances')::int;
  v_prop_rej := (p_attestation->>'property_rejects')::int;
  v_ver_dis  := (p_attestation->>'verifier_disagreements')::int;
  if v_sme_n is null or v_sme_def is null or v_prop_n is null
     or v_prop_rej is null or v_ver_dis is null then
    raise exception 'cm_d19: attestation missing a required field (need sme_sample_n, sme_defects, property_instances, property_rejects, verifier_disagreements); got %', p_attestation;
  end if;

  -- FAIL-CLOSED gate on the approved D8 bars.
  if v_sme_n    < v_bars.sme_sample_min            then raise exception 'cm_d19 D8 gate FAILED: sme_sample_n % < required %',            v_sme_n,   v_bars.sme_sample_min; end if;
  if v_sme_def  > v_bars.sme_defects_max           then raise exception 'cm_d19 D8 gate FAILED: sme_defects % > allowed %',              v_sme_def, v_bars.sme_defects_max; end if;
  if v_prop_n   < v_bars.property_instances_min    then raise exception 'cm_d19 D8 gate FAILED: property_instances % < required %',       v_prop_n,  v_bars.property_instances_min; end if;
  if v_prop_rej > v_bars.property_rejects_max      then raise exception 'cm_d19 D8 gate FAILED: property_rejects % > allowed %',          v_prop_rej,v_bars.property_rejects_max; end if;
  if v_ver_dis  > v_bars.verifier_disagreements_max then raise exception 'cm_d19 D8 gate FAILED: verifier_disagreements % > allowed %',    v_ver_dis, v_bars.verifier_disagreements_max; end if;

  -- Guard: the template must actually have instances in this pack.
  if not exists (
    select 1 from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ci.exam_pack_version_id = p_exam_pack_version_id
      and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
  ) then
    raise exception 'cm_d19: no instances of template % found in exam_pack_version %', p_template_id, p_exam_pack_version_id;
  end if;

  select distinct tc.taxonomy_source_version into v_tsv
  from app.content_item_cells tc
  join app.content_items ci on ci.id = tc.content_item_id
  where ci.exam_pack_version_id = p_exam_pack_version_id
  limit 1;

  insert into app.template_releases
    (template_id, exam_pack_version_id, taxonomy_source_version, bars_version,
     attestation, spot_audit_per_month, released_by)
  values
    (p_template_id, p_exam_pack_version_id, v_tsv, p_bars_version,
     p_attestation, v_bars.spot_audit_per_month, p_released_by)
  on conflict (template_id, exam_pack_version_id) do update
    set attestation = excluded.attestation,
        bars_version = excluded.bars_version,
        spot_audit_per_month = excluded.spot_audit_per_month,
        released_by = excluded.released_by,
        released_at = now(),
        revoked_at = null,
        revoked_by = null
  returning id into v_release_id;

  -- Stamp every instance of this template in this pack (only those still unreleased).
  with tgt as (
    select civ.id as civ_id, ci.id as ci_id
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ci.exam_pack_version_id = p_exam_pack_version_id
      and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
      and civ.review_status is distinct from 'question_review_approved'
  ),
  up_civ as (
    update app.content_item_versions civ
       set review_status = 'question_review_approved',
           approved_by   = p_released_by,
           approved_at   = now(),
           status        = 'published',
           published_at  = coalesce(civ.published_at, now())
      from tgt where civ.id = tgt.civ_id
    returning civ.id
  ),
  up_ci as (
    update app.content_items ci
       set status = 'published'
      from tgt where ci.id = tgt.ci_id
    returning ci.id
  )
  select count(*) into v_stamped from up_civ;

  update app.template_releases set instances_stamped = v_stamped where id = v_release_id;

  return jsonb_build_object(
    'ok', true, 'release_id', v_release_id, 'template_id', p_template_id,
    'exam_pack_version_id', p_exam_pack_version_id, 'instances_stamped', v_stamped,
    'bars_version', p_bars_version);
end;
$$;

-- 4. Revoke a template release: un-stamp its instances (reversible per template).
create or replace function app.cm_d19_revoke_template_release(
  p_template_id          text,
  p_exam_pack_version_id uuid,
  p_revoked_by           uuid default null
) returns jsonb
language plpgsql
as $$
declare
  v_unstamped int;
begin
  update app.template_releases
     set revoked_at = now(), revoked_by = p_revoked_by
   where template_id = p_template_id and exam_pack_version_id = p_exam_pack_version_id;

  with tgt as (
    select civ.id as civ_id, ci.id as ci_id
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ci.exam_pack_version_id = p_exam_pack_version_id
      and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
  ),
  up_civ as (
    update app.content_item_versions civ
       set status = 'draft', review_status = null, approved_at = null, approved_by = null
      from tgt where civ.id = tgt.civ_id
    returning civ.id
  ),
  up_ci as (
    update app.content_items ci set status = 'draft'
      from tgt where ci.id = tgt.ci_id
    returning ci.id
  )
  select count(*) into v_unstamped from up_civ;

  return jsonb_build_object('ok', true, 'template_id', p_template_id, 'instances_unstamped', v_unstamped);
end;
$$;

grant execute on function app.cm_d19_release_template(text, uuid, jsonb, uuid, text) to service_role;
grant execute on function app.cm_d19_revoke_template_release(text, uuid, uuid) to service_role;
