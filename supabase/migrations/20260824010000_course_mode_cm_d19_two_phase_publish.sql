-- Course Mode CM-D19 fix: stamp releases through the real content pipeline.
--
-- The first live CM-D19 release (lsrl_predict) surfaced that the original
-- cm_d19_release_template stamped review_status + status='published' in a
-- single UPDATE, jumping content_item_versions/content_items straight from
-- 'draft' to 'published'. That path is blocked by the standing content pipeline
-- guards, which the fail-closed unit test never exercised (it only tested the
-- gate REJECTION path, never a successful stamp):
--
--   * app.tg_content_pipeline_guard_publish (on BOTH content_items and
--     content_item_versions): a row may enter 'published' only from
--     'reviewed_approved'  ->  the transition must be two-step.
--   * app.enforce_publish_gate (content_item_versions): status='published'
--     requires review_status in the approved allowlist (we use
--     'question_review_approved').
--   * app.tg_require_practice_format_at_publish (content_items): FRQ-only; the
--     generated MCQ/quantitative items are exempt.
--   * app.enforce_mcq_stem_choice_sync (content_item_versions): only flags a
--     stem that embeds "A. <text>" option lines mismatching mcq_choices; the
--     generated single-paragraph stems embed none, so they pass.
--
-- Fix: machine-stamp in phases so every guard is satisfied, and keep the D8
-- gate, the release ledger, idempotency, and template scoping exactly as before.
-- Reversal (app.cm_d19_revoke_template_release) is unchanged.

create or replace function app.cm_d19_release_template(
  p_template_id text,
  p_exam_pack_version_id uuid,
  p_attestation jsonb,
  p_released_by uuid default null,
  p_bars_version text default 'cm-d19-phase1-2026-08-23'
) returns jsonb
language plpgsql
as $function$
declare
  v_bars       app.template_release_bars;
  v_release_id uuid;
  v_stamped    int;
  v_tsv        uuid;
  v_sme_n int; v_sme_def int; v_prop_n int; v_prop_rej int; v_ver_dis int;
begin
  select * into strict v_bars from app.template_release_bars where bars_version = p_bars_version;

  v_sme_n    := (p_attestation->>'sme_sample_n')::int;
  v_sme_def  := (p_attestation->>'sme_defects')::int;
  v_prop_n   := (p_attestation->>'property_instances')::int;
  v_prop_rej := (p_attestation->>'property_rejects')::int;
  v_ver_dis  := (p_attestation->>'verifier_disagreements')::int;
  if v_sme_n is null or v_sme_def is null or v_prop_n is null
     or v_prop_rej is null or v_ver_dis is null then
    raise exception 'cm_d19: attestation missing a required field (need sme_sample_n, sme_defects, property_instances, property_rejects, verifier_disagreements); got %', p_attestation;
  end if;

  if v_sme_n    < v_bars.sme_sample_min            then raise exception 'cm_d19 D8 gate FAILED: sme_sample_n % < required %',            v_sme_n,   v_bars.sme_sample_min; end if;
  if v_sme_def  > v_bars.sme_defects_max           then raise exception 'cm_d19 D8 gate FAILED: sme_defects % > allowed %',              v_sme_def, v_bars.sme_defects_max; end if;
  if v_prop_n   < v_bars.property_instances_min    then raise exception 'cm_d19 D8 gate FAILED: property_instances % < required %',       v_prop_n,  v_bars.property_instances_min; end if;
  if v_prop_rej > v_bars.property_rejects_max      then raise exception 'cm_d19 D8 gate FAILED: property_rejects % > allowed %',          v_prop_rej,v_bars.property_rejects_max; end if;
  if v_ver_dis  > v_bars.verifier_disagreements_max then raise exception 'cm_d19 D8 gate FAILED: verifier_disagreements % > allowed %',    v_ver_dis, v_bars.verifier_disagreements_max; end if;

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

  -- Two-phase machine stamp (draft -> reviewed_approved -> published) so the
  -- pipeline guards on both tables pass. Idempotent: a re-run picks up any row
  -- left mid-transition and finishes it; already-published rows are untouched.

  -- Phase 1a: versions draft -> reviewed_approved, carrying the review approval.
  update app.content_item_versions civ
     set review_status = 'question_review_approved',
         approved_by   = p_released_by,
         approved_at   = now(),
         status        = 'reviewed_approved'
    from app.content_items ci
   where civ.content_item_id = ci.id
     and ci.exam_pack_version_id = p_exam_pack_version_id
     and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
     and civ.status = 'draft';

  -- Phase 1b: items draft -> reviewed_approved.
  update app.content_items ci
     set status = 'reviewed_approved'
   where ci.exam_pack_version_id = p_exam_pack_version_id
     and ci.status = 'draft'
     and exists (
       select 1 from app.content_item_versions civ
       where civ.content_item_id = ci.id
         and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
     );

  -- Phase 2a: versions reviewed_approved -> published (guards satisfied).
  with pub as (
    update app.content_item_versions civ
       set status = 'published',
           published_at = coalesce(civ.published_at, now())
      from app.content_items ci
     where civ.content_item_id = ci.id
       and ci.exam_pack_version_id = p_exam_pack_version_id
       and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
       and civ.status = 'reviewed_approved'
    returning civ.id
  )
  select count(*) into v_stamped from pub;

  -- Phase 2b: items reviewed_approved -> published (guards satisfied).
  update app.content_items ci
     set status = 'published'
   where ci.exam_pack_version_id = p_exam_pack_version_id
     and ci.status = 'reviewed_approved'
     and exists (
       select 1 from app.content_item_versions civ
       where civ.content_item_id = ci.id
         and civ.item_package_payload->'provenance'->>'template_id' = p_template_id
     );

  update app.template_releases set instances_stamped = v_stamped where id = v_release_id;

  return jsonb_build_object(
    'ok', true, 'release_id', v_release_id, 'template_id', p_template_id,
    'exam_pack_version_id', p_exam_pack_version_id, 'instances_stamped', v_stamped,
    'bars_version', p_bars_version);
end;
$function$;
