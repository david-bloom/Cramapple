-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: the 20 app-schema functions whose live text differed between the projects.
-- Source of truth: Production's live definitions (pg_get_functiondef, 2026-10-22). Seventeen differ from
-- Development only in whitespace or comments. Three differ in substance, and on each one main's
-- 20260731160000_schema_baseline.sql agrees with Production, so Development lagged:
--   enforce_content_items_frq_form: Development carried a harness-plan branch
--     (app.subject_harness_plan) that exists in no migration on main and never on Production.
--   prevent_profile_role_change: Development lacked the current_user <> 'service_role' guard.
--   tg_content_pipeline_on_decision: Development ran the early single-score version without the
--     blind-group tally and review_status writes.
-- CREATE OR REPLACE keeps ownership, grants and trigger bindings. Re-running is a no-op.

CREATE OR REPLACE FUNCTION app.check_content_review_invariants()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_found integer;
  v_resolved integer;
begin
  create temporary table _cri_current (
    check_key text not null,
    subject_id uuid not null,
    detail jsonb not null
  ) on commit drop;

  -- The recurring class: an open assignment that already carries a decision.
  -- The trigger above should keep this empty; a hit means something reached the
  -- state by a path the trigger does not cover.
  insert into _cri_current
  select 'open_assignment_with_decision', a.content_review_assignment_id,
         jsonb_build_object('reviewer_id', a.reviewer_id, 'status', a.status,
                            'content_item_version_id', a.content_item_version_id)
  from app.content_review_assignments a
  where a.status in ('pending', 'in_progress')
    and exists (
      select 1 from app.content_review_decisions d
      where d.content_review_assignment_id = a.content_review_assignment_id
    );

  -- The inverse: a closed assignment with no decision backing it.
  insert into _cri_current
  select 'submitted_assignment_without_decision', a.content_review_assignment_id,
         jsonb_build_object('reviewer_id', a.reviewer_id,
                            'content_item_version_id', a.content_item_version_id)
  from app.content_review_assignments a
  where a.status = 'submitted'
    and not exists (
      select 1 from app.content_review_decisions d
      where d.content_review_assignment_id = a.content_review_assignment_id
    );

  -- A decision attributed to someone other than the assignee. Blocked on insert
  -- since the atomic-lock fix; historical rows predate it. Baseline 3 rows at
  -- 2026-08-03.
  insert into _cri_current
  select 'decision_reviewer_mismatch', d.content_review_decision_id,
         jsonb_build_object('decision_reviewer', d.reviewer_id,
                            'assignment_reviewer', a.reviewer_id,
                            'assignment_id', a.content_review_assignment_id)
  from app.content_review_decisions d
  join app.content_review_assignments a
    on a.content_review_assignment_id = d.content_review_assignment_id
  where d.reviewer_id is distinct from a.reviewer_id;

  -- Work queued against content that has since been retired. The 2026-08-02
  -- withdrawal migration was meant to drain these. Baseline 3 rows at 2026-08-03.
  insert into _cri_current
  select 'open_assignment_on_retired_content', a.content_review_assignment_id,
         jsonb_build_object('reviewer_id', a.reviewer_id, 'content_key', ci.content_key)
  from app.content_review_assignments a
  join app.content_item_versions civ on civ.id = a.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  where a.status in ('pending', 'in_progress')
    and ci.status = 'retired';

  insert into app.content_review_invariant_violations (check_key, subject_id, detail)
  select c.check_key, c.subject_id, c.detail from _cri_current c
  on conflict (check_key, subject_id) do update
    set last_seen_at = pg_catalog.now(),
        detail = excluded.detail,
        resolved_at = null;

  get diagnostics v_found = row_count;

  update app.content_review_invariant_violations v
  set resolved_at = pg_catalog.now()
  where v.resolved_at is null
    and not exists (
      select 1 from _cri_current c
      where c.check_key = v.check_key and c.subject_id = v.subject_id
    );

  get diagnostics v_resolved = row_count;

  return jsonb_build_object(
    'checked_at', pg_catalog.now(),
    'open_violations', (
      select coalesce(jsonb_object_agg(check_key, n), '{}'::jsonb) from (
        select check_key, count(*) n
        from app.content_review_invariant_violations
        where resolved_at is null group by 1
      ) s
    ),
    'seen_this_run', v_found,
    'newly_resolved', v_resolved
  );
end;
$function$;

CREATE OR REPLACE FUNCTION app.claim_capture_pairing_upload(p_handle_sha256 text, p_max_attempts integer, p_access_path text DEFAULT NULL::text)
 RETURNS app.capture_pairing_tokens
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'public'
AS $function$
declare
  v_row app.capture_pairing_tokens;
begin
  select * into v_row
  from app.capture_pairing_tokens
  where handle_sha256 = p_handle_sha256
  for update;

  if v_row.id is null then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:not_found';
  end if;

  -- Already-terminal capabilities: nothing to record, so raise directly.
  if v_row.state = 'consumed' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:already_used';
  end if;
  if v_row.state = 'cancelled' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:cancelled';
  end if;
  if v_row.state = 'rejected' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:rejected';
  end if;
  if v_row.state = 'expired' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:expired';
  end if;

  -- Just-now-terminal transitions COMMIT their bookkeeping by RETURNING the
  -- updated row rather than raising. A `RAISE` here would abort the function's
  -- own transaction and roll the UPDATE back -- the original defect, which
  -- made `state = 'rejected'` unreachable dead code and the "record the
  -- expiry" comment false. The caller distinguishes these from a live claim by
  -- inspecting the returned `state` (a live claim returns 'paired'/'uploaded').
  if v_row.expires_at <= now() then
    update app.capture_pairing_tokens
      set state = 'expired', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;
  if v_row.redemption_attempts >= p_max_attempts then
    update app.capture_pairing_tokens
      set state = 'rejected', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;

  update app.capture_pairing_tokens
    set redemption_attempts = redemption_attempts + 1,
        state = case when state = 'issued' then 'paired' else state end,
        paired_at = coalesce(paired_at, now()),
        access_path = coalesce(p_access_path, access_path)
    where id = v_row.id
    returning * into v_row;

  return v_row;
end;
$function$;

CREATE OR REPLACE FUNCTION app.complete_model_usage(p_request_id text, p_request_hash text, p_status text, p_actual_cost_usd numeric, p_input_tokens integer, p_output_tokens integer)
 RETURNS app.model_usage_ledger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'public'
AS $function$
declare
  existing app.model_usage_ledger%rowtype;
  prior_reserved numeric(10,4);
  burn_cost numeric(10,4);
begin
  select * into existing from app.model_usage_ledger
  where request_id = p_request_id and request_hash = p_request_hash for update;

  if not found then raise exception 'usage request not found'; end if;
  if existing.status not in ('reserved', 'running') then return existing; end if;

  prior_reserved := existing.reserved_cost_usd;
  burn_cost := case
    when p_status = 'completed' then coalesce(p_actual_cost_usd, 0)
    when p_actual_cost_usd is not null then p_actual_cost_usd
    else 0
  end;

  update app.model_usage_ledger set
    status = p_status, actual_cost_usd = p_actual_cost_usd,
    input_tokens = p_input_tokens, output_tokens = p_output_tokens, completed_at = now()
  where request_id = p_request_id and request_hash = p_request_hash
  returning * into existing;

  update app.daily_budgets set
    reserved_cost_usd = greatest(0, reserved_cost_usd - prior_reserved),
    actual_cost_usd = actual_cost_usd + burn_cost
  where usage_date_utc = existing.usage_date_utc;

  return existing;
end;
$function$;

CREATE OR REPLACE FUNCTION app.enforce_content_items_frq_form()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'app', 'pg_catalog'
AS $function$
begin
  if new.item_type = 'frq' and new.frq_form is null then
    raise exception
      'frq_form is required when item_type is ''frq'' (content_key: %)',
      new.content_key;
  end if;
  if new.item_type <> 'frq' and new.frq_form is not null then
    raise exception
      'frq_form must be null when item_type is not ''frq'' (content_key: %)',
      new.content_key;
  end if;
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.enforce_session_target_home_eligibility()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
begin
  if not exists (
    select 1
    from app.profiles p
    where p.user_id = new.user_id
      and p.active_exam_pack_version_id = new.exam_pack_version_id
  ) then
    raise exception 'session_target:active_subject_mismatch'
      using errcode = '22023';
  end if;

  if not app.home_exam_pack_is_eligible(new.exam_pack_version_id) then
    raise exception 'session_target:home_subject_not_eligible'
      using errcode = '22023';
  end if;
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.home_exam_pack_is_eligible(_exam_pack_version_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is not null
     and not exists (
       select 1
       from app.profiles p
       where p.user_id = v_user_id
         and p.active_exam_pack_version_id = _exam_pack_version_id
     ) then
    return false;
  end if;

  return exists (
    select 1
    from app.home_release_manifest m
    join app.exam_pack_versions epv
      on epv.id = m.exam_pack_version_id
    join app.exam_packs ep
      on ep.id = epv.exam_pack_id
    join app.subjects s
      on s.id = ep.subject_id
    where m.exam_pack_version_id = _exam_pack_version_id
      and m.quick_start_enabled
      and epv.status = 'published'
      and epv.retired_at is null
      and s.status = 'active'
      and (
        select count(distinct ci.id)
        from app.content_items ci
        join app.content_item_versions civ
          on civ.content_item_id = ci.id
        where ci.exam_pack_version_id = epv.id
          and ci.status = 'published'
          and ci.item_type = 'mcq'
          and civ.status = 'published'
          and exists (
            select 1
            from app.mcq_choices choice
            where choice.content_item_version_id = civ.id
          )
      ) >= m.minimum_published_items
  );
end;
$function$;

CREATE OR REPLACE FUNCTION app.invoke_trial_worker(p_url_secret text, p_token_secret text)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_url text;
  v_token text;
begin
  select decrypted_secret into v_url from vault.decrypted_secrets where name = p_url_secret limit 1;
  select decrypted_secret into v_token from vault.decrypted_secrets where name = p_token_secret limit 1;
  if v_url is null or v_token is null then
    -- Missing configuration shows up as a stale heartbeat, not a crash.
    return null;
  end if;
  return net.http_post(
    url := v_url,
    headers := jsonb_build_object('Content-Type', 'application/json', 'Authorization', 'Bearer ' || v_token),
    body := '{}'::jsonb,
    timeout_milliseconds := 55000
  );
end;
$function$;

CREATE OR REPLACE FUNCTION app.prevent_profile_role_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'app', 'pg_catalog'
AS $function$
begin
  if current_user <> 'service_role'
     and coalesce(current_setting('request.jwt.claim.role', true), '') <> 'service_role'
     and new.role <> old.role then
    raise exception 'role changes are server-side only';
  end if;
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.prevent_review_decision_mutation()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'app', 'pg_catalog'
AS $function$
begin
  raise exception
    'content_review_decisions rows are immutable after insert (id: %). '
    'To supersede a decision, insert a new row with supersedes_id referencing this row.',
    old.id;
end;
$function$;

CREATE OR REPLACE FUNCTION app.progress_estimated_ap_score(_earned integer, _possible integer)
 RETURNS integer
 LANGUAGE sql
 IMMUTABLE
 SET search_path TO 'pg_catalog'
AS $function$
  select case
    when _possible is null or _possible <= 0 then null
    when coalesce(_earned,0)::numeric / _possible >= 0.75 then 5
    when coalesce(_earned,0)::numeric / _possible >= 0.60 then 4
    when coalesce(_earned,0)::numeric / _possible >= 0.45 then 3
    when coalesce(_earned,0)::numeric / _possible >= 0.30 then 2
    else 1
  end;
$function$;

CREATE OR REPLACE FUNCTION app.progress_status_token(_graded_items integer, _earned integer, _possible integer)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
 SET search_path TO 'pg_catalog'
AS $function$
  select case
    when coalesce(_graded_items,0) = 0 then 'no_evidence'
    when coalesce(_graded_items,0) < 3 then 'insufficient_evidence'
    when coalesce(_possible,0) <= 0 then 'insufficient_evidence'
    when coalesce(_earned,0)::numeric / _possible >= 0.70 then 'strong'
    else 'developing'
  end;
$function$;

CREATE OR REPLACE FUNCTION app.reserve_artifact_version_sequence(p_artifact_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SET search_path TO 'app', 'public'
AS $function$
declare
  next_sequence integer;
begin
  perform pg_advisory_xact_lock(hashtextextended(p_artifact_id::text, 0));
  select coalesce(max(version_sequence), 0) + 1
    into next_sequence
  from app.artifact_versions
  where artifact_id = p_artifact_id;
  return next_sequence;
end;
$function$;

CREATE OR REPLACE FUNCTION app.reserve_model_usage(p_request_id text, p_request_hash text, p_model_id text, p_reserved_cost_usd numeric, p_cap_usd numeric)
 RETURNS app.model_usage_ledger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'public'
AS $function$
declare
  existing app.model_usage_ledger%rowtype;
  budget app.daily_budgets%rowtype;
  projected_total numeric(12,4);
begin
  if p_reserved_cost_usd is null or p_reserved_cost_usd <= 0 then
    raise exception 'invalid reservation amount';
  end if;

  -- Fast-path replay check before lock acquisition
  select * into existing from app.model_usage_ledger where request_id = p_request_id limit 1;
  if found then
    if existing.request_hash <> p_request_hash then raise exception 'idempotency key conflict'; end if;
    return existing;
  end if;

  insert into app.daily_budgets (usage_date_utc, cap_usd)
  values (current_date, p_cap_usd)
  on conflict (usage_date_utc) do update
    set cap_usd = coalesce(app.daily_budgets.cap_usd, excluded.cap_usd);

  select * into budget from app.daily_budgets where usage_date_utc = current_date for update;

  -- Post-lock re-check to handle concurrent duplicate requests
  select * into existing from app.model_usage_ledger where request_id = p_request_id limit 1;
  if found then
    if existing.request_hash <> p_request_hash then raise exception 'idempotency key conflict'; end if;
    return existing;
  end if;

  projected_total := budget.reserved_cost_usd + budget.actual_cost_usd + p_reserved_cost_usd;
  if projected_total > p_cap_usd then raise exception 'daily cap exceeded'; end if;

  update app.daily_budgets set reserved_cost_usd = reserved_cost_usd + p_reserved_cost_usd where usage_date_utc = current_date;

  insert into app.model_usage_ledger (request_id, request_hash, usage_date_utc, reserved_cost_usd, status, model_id)
  values (p_request_id, p_request_hash, current_date, p_reserved_cost_usd, 'reserved', p_model_id)
  returning * into existing;

  return existing;
end;
$function$;

CREATE OR REPLACE FUNCTION app.response_versions_guard_reserved_parts()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'app', 'pg_catalog'
AS $function$
begin
  -- The edge functions write with the service role; everyone else (owner
  -- through PostgREST, a reviewer role, an admin's own client) may not touch
  -- the transcript/confirmation bookkeeping.
  if current_user = 'service_role'
     or coalesce(current_setting('request.jwt.claim.role', true), '') = 'service_role' then
    return new;
  end if;
  if tg_op = 'INSERT' then
    if app.reserved_response_parts(new.response_parts) <> '{}'::jsonb then
      raise exception 'response_versions:reserved_keys_are_server_only' using errcode = '42501';
    end if;
    return new;
  end if;
  if app.reserved_response_parts(new.response_parts) is distinct from app.reserved_response_parts(old.response_parts) then
    raise exception 'response_versions:reserved_keys_are_server_only' using errcode = '42501';
  end if;
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.revalidate_session_target_before_consumption()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_item_count integer;
  v_valid_count integer;
begin
  if new.status <> 'consumed' or old.status = 'consumed' then
    return new;
  end if;

  if not exists (
    select 1
    from app.profiles p
    where p.user_id = new.user_id
      and p.active_exam_pack_version_id = new.exam_pack_version_id
  ) then
    raise exception 'session_target:active_subject_mismatch'
      using errcode = '22023';
  end if;

  if not app.home_exam_pack_is_eligible(new.exam_pack_version_id) then
    raise exception 'session_target:home_subject_not_eligible'
      using errcode = '22023';
  end if;

  select count(*)::integer
    into v_item_count
  from app.session_target_items sti
  where sti.target_id = new.id;

  select count(*)::integer
    into v_valid_count
  from app.session_target_items sti
  join app.content_item_versions civ
    on civ.id = sti.content_item_version_id
  join app.content_items ci
    on ci.id = civ.content_item_id
  where sti.target_id = new.id
    and ci.exam_pack_version_id = new.exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published'
    and (
      (
        ci.item_type = 'mcq'
        and exists (
          select 1
          from app.mcq_choices choice
          where choice.content_item_version_id = civ.id
        )
      )
      or ci.item_type = 'quantitative'
      or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long'))
    );

  if v_item_count = 0 or v_valid_count <> v_item_count then
    raise exception 'session_target:content_not_published_or_compatible'
      using errcode = '22023';
  end if;

  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.select_confirm_transfer_item(_exam_pack_version_id uuid, _source_content_item_version_id uuid)
 RETURNS TABLE(content_item_version_id uuid, content_item_id uuid, content_key text, title text, stem text, stimulus text, stimulus_image_path text, prompt_json jsonb, frq_form text, practice_format text, frq_archetype text, published_at timestamp with time zone)
 LANGUAGE sql
 STABLE
 SET search_path TO 'pg_catalog'
AS $function$
  with source_cells as (
    select cic.taxonomy_source_version, cic.topic_code, cic.skill_code
    from app.content_item_cells cic
    where cic.content_item_version_id = _source_content_item_version_id
  ),
  source_item as (
    select civ.content_item_id from app.content_item_versions civ
    where civ.id = _source_content_item_version_id
  ),
  excluded_numeric_cells(topic_code, skill_code) as ( values ('1.7', '3.B'), ('1.9', '3.B') ),
  eligible_cells as (
    select sc.taxonomy_source_version, sc.topic_code, sc.skill_code
    from source_cells sc
    where not exists (select 1 from excluded_numeric_cells e
      where e.topic_code = sc.topic_code and e.skill_code = sc.skill_code)
  ),
  candidates as (
    select distinct
      civ.id as content_item_version_id, ci.id as content_item_id, ci.content_key as content_key,
      ci.title as title, civ.stem as stem, civ.stimulus as stimulus,
      civ.stimulus_image_path as stimulus_image_path, civ.prompt_json as prompt_json,
      ci.frq_form as frq_form, ci.practice_format as practice_format,
      ci.frq_archetype as frq_archetype, civ.published_at as published_at
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    join app.content_item_cells cic on cic.content_item_version_id = civ.id
    join eligible_cells ec on ec.taxonomy_source_version = cic.taxonomy_source_version
     and ec.topic_code = cic.topic_code and ec.skill_code = cic.skill_code
    where ci.exam_pack_version_id = _exam_pack_version_id
      and ci.item_type = 'mcq' and ci.status = 'published' and civ.status = 'published'
      and civ.id <> _source_content_item_version_id
      and not app.content_item_is_teaching(ci.id)
      and ci.id  <> (select content_item_id from source_item)
  )
  select content_item_version_id, content_item_id, content_key, title, stem, stimulus,
    stimulus_image_path, prompt_json, frq_form, practice_format, frq_archetype, published_at
  from candidates
  order by md5(content_item_version_id::text || _source_content_item_version_id::text), published_at, content_key
  limit 1;
$function$;

CREATE OR REPLACE FUNCTION app.set_content_taxonomy_label_derived_fields()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_max integer;
begin
  if new.label_scope = 'serving' then
    select max(unit_number)
      into v_max
    from unnest(new.required_units) as units(unit_number);
    new.max_required_unit := v_max;
  else
    new.required_units := '{}'::integer[];
    new.max_required_unit := null;
    new.primary_unit := null;
    new.required_units_by_criterion := null;
  end if;

  if new.label_status <> 'validated' then
    new.validated_by := null;
    new.validated_at := null;
    new.validation_decision_id := null;
  end if;

  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.tg_content_pipeline_on_decision()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'pg_temp'
AS $function$
declare
  v_item_id uuid;
  v_outcome text;
  v_review_status text;
  v_blind_group_id uuid;
  v_assignment_count integer;
  v_submitted_count integer;
  v_group_score integer;
  v_is_latest boolean;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.review_stage = 'tutor_question' then
    select blind_group_id
      into v_blind_group_id
      from app.content_review_assignments
     where content_review_assignment_id = new.content_review_assignment_id;

    if v_blind_group_id is not null then
      select count(*), count(*) filter (where status = 'submitted')
        into v_assignment_count, v_submitted_count
        from app.content_review_assignments
       where blind_group_id = v_blind_group_id
         and review_stage = 'tutor_question';
    else
      v_assignment_count := 1;
      v_submitted_count := 1;
    end if;

    if v_assignment_count = 1 then
      if new.tutor_score = 1 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'question_review_approved';
      elsif new.tutor_score = 2 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif new.tutor_score = 3 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    elsif v_assignment_count = 2 then
      if v_submitted_count <> 2 then
        return new;
      end if;

      select sum(d.tutor_score)
        into v_group_score
        from app.content_review_assignments a
        join app.content_review_decisions d
          on d.content_review_assignment_id = a.content_review_assignment_id
       where a.blind_group_id = v_blind_group_id
         and a.review_stage = 'tutor_question'
         and not exists (
           select 1
             from app.content_review_decisions newer
            where newer.supersedes_id = d.content_review_decision_id
         );

      if v_group_score = 2 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'ap_reader_pending';
      elsif v_group_score = 3 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif v_group_score between 4 and 6 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    else
      return new;
    end if;
  elsif new.review_stage = 'reader_question' then
    if new.reader_decision = 'agree' or new.tutor_score = 1 then
      v_outcome := 'reviewed_approved';
      v_review_status := 'question_review_approved';
    elsif new.tutor_score = 2 then
      v_outcome := 'changes_requested';
      v_review_status := 'modification_reserved';
    elsif new.reader_decision = 'disagree' or new.tutor_score = 3 then
      v_outcome := 'reviewed_disapproved';
      v_review_status := 'excluded';
    else
      return new;
    end if;
  else
    return new;
  end if;

  update app.content_item_versions
     set status = case
           when status in (
             'draft', 'assigned', 'changes_requested',
             'reviewed_approved', 'reviewed_disapproved'
           ) then v_outcome
           else status
         end,
         review_status = v_review_status
   where id = new.content_item_version_id;

  select civ.content_item_id,
         not exists (
           select 1
             from app.content_item_versions newer
            where newer.content_item_id = civ.content_item_id
              and (
                newer.version_num > civ.version_num
                or (
                  newer.version_num = civ.version_num
                  and newer.created_at > civ.created_at
                )
              )
         )
    into v_item_id, v_is_latest
    from app.content_item_versions civ
   where civ.id = new.content_item_version_id;

  if v_item_id is not null and v_is_latest then
    update app.content_items
       set status = case
             when status in (
               'draft', 'assigned', 'changes_requested',
               'reviewed_approved', 'reviewed_disapproved'
             ) then v_outcome
             else status
           end
     where id = v_item_id;
  end if;

  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.tg_require_practice_format_at_publish()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'pg_temp'
AS $function$
declare
  v_hand_drawn boolean;
begin
  if new.status = 'published'
     and old.status is distinct from 'published'
     and new.item_type = 'frq'
  then
    select coalesce((civ.prompt_json ->> 'hand_drawn')::boolean, false)
      into v_hand_drawn
    from app.content_item_versions civ
    where civ.content_item_id = new.id
      and civ.status = 'published'
    order by civ.version_num desc
    limit 1;

    if new.practice_format is null and not coalesce(v_hand_drawn, false) then
      raise exception
        'practice_format_required_at_publish: FRQ % (content_key %) cannot publish with practice_format IS NULL — set targeted_drill or full_exam_frq before publishing, or confirm it is a hand-drawn item (prompt_json.hand_drawn = true) if it should stay unreachable via select_practice_frqs',
        new.id, new.content_key;
    end if;

    -- A constructed-visual item always requires a photo, whatever the row says.
    if coalesce(v_hand_drawn, false) then
      new.response_policy := 'photo_required';
    end if;

    if new.response_policy is null then
      raise exception
        'response_policy_required_at_publish: FRQ % (content_key %) cannot publish with response_policy IS NULL — photo_allowed, photo_required, or typed_only (HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09 §3)',
        new.id, new.content_key;
    end if;
  end if;
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.trial_record_attempt(p_order_id uuid, p_lease_token uuid, p_outcome text, p_error_code text DEFAULT NULL::text, p_decline_code text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  o app.trial_orders;
  v_grace timestamptz;
  v_first boolean;
begin
  select * into o from app.trial_orders
  where id = p_order_id and lease_token = p_lease_token and status = 'charging'
  for update;
  if not found then return 'stale_lease'; end if;

  if p_outcome in ('declined_retryable', 'declined_hard', 'requires_action') then
    v_first := o.first_failure_at is null;
    -- Grace is the original trial end + 24 h (DECISION-0126 item 5). Only a
    -- charge we delayed ourselves starts grace from the actual attempt.
    v_grace := coalesce(o.grace_ends_at,
      case when o.charge_phase = 'delayed' then now() else o.trial_ends_at end
        + interval '24 hours');
    update app.trial_orders
    set status = case when p_outcome = 'requires_action' then 'requires_action' else 'payment_failed' end,
        first_failure_at = coalesce(first_failure_at, now()),
        grace_ends_at = v_grace,
        -- One automatic retry, only after a first retryable decline.
        next_attempt_at = case
          when v_first and p_outcome = 'declined_retryable' and o.attempt_count < 2
            then v_grace - interval '1 hour'
          else null end,
        last_error_code = p_error_code,
        last_decline_code = p_decline_code,
        lease_token = null, lease_expires_at = null,
        updated_at = now()
    where id = o.id returning * into o;
    if v_first then
      -- Grace is applied once (DECISION-0126 item 5).
      perform app.trial_set_trial_access(o, 'active', v_grace);
      perform app.trial_enqueue_notice(o,
        case when p_outcome = 'requires_action' then 'requires_action' else 'payment_failed' end);
    end if;
    return o.status;
  elsif p_outcome = 'transport_error' then
    update app.trial_orders
    set status = 'reconciling', reconcile_reason = 'transport_error',
        last_error_code = p_error_code, lease_token = null, lease_expires_at = null,
        updated_at = now()
    where id = o.id;
    return 'reconciling';
  elsif p_outcome in ('succeeded_observed', 'processing') then
    -- The webhook converts. Keep the order claimed for a while so a missing
    -- webhook is reconciled on a later run.
    update app.trial_orders
    set lease_expires_at = now() + interval '30 minutes', updated_at = now()
    where id = o.id;
    return 'charging';
  elsif p_outcome = 'canceled_observed' then
    update app.trial_orders
    set status = 'reconciling', reconcile_reason = 'payment_intent_canceled',
        lease_token = null, lease_expires_at = null, updated_at = now()
    where id = o.id;
    return 'reconciling';
  end if;
  raise exception 'unknown trial attempt outcome %', p_outcome;
end $function$;
