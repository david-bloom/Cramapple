-- Free Score Check must fail closed for prompt-visual gated content.
--
-- TASK-0021 allows the free-score-check bypass path only if it either renders
-- visuals through student-session-items or is constrained to no-required-visual
-- content. The current frontend does not render signed prompt media, so the
-- configured item for the requested subject must be explicitly classified as
-- no prompt visual required.

begin;

create or replace function app.start_free_score_check(
  p_user_id uuid,
  p_first_touch jsonb,
  p_last_touch jsonb,
  p_marketing_email_opt_in boolean,
  p_privacy_notice_version text,
  p_subject_key text default null
)
returns jsonb
language plpgsql
security definer
set search_path = app, public
as $$
declare
  v_config jsonb;
  v_subject_config jsonb;
  v_requested_subject_key text;
  v_content_version_id uuid;
  v_rubric_version_id uuid;
  v_minutes integer;
  v_subject_id uuid;
  v_subject_key text;
  v_subject_name text;
  v_exam_pack_version_id uuid;
  v_stimulus_image_path text;
  v_image_needed text;
  v_check app.free_score_checks%rowtype;
  v_session_id uuid;
  v_attempt_id uuid;
  v_response_version_id uuid;
begin
  select config_value into v_config
  from app.config
  where config_key = 'growth.free_score_check.v1';

  if v_config is null or coalesce((v_config->>'enabled')::boolean, false) = false then
    raise exception 'free_score_check:not_available';
  end if;

  v_requested_subject_key := lower(nullif(btrim(coalesce(p_subject_key, v_config->>'subject_key')), ''));

  if v_requested_subject_key is null then
    raise exception 'free_score_check:subject_required';
  end if;

  v_subject_config := case
    when jsonb_typeof(v_config->'subjects') = 'object'
      then v_config->'subjects'->v_requested_subject_key
    else null
  end;

  v_content_version_id := nullif(coalesce(
    v_subject_config->>'content_item_version_id',
    case
      when v_config->>'subject_key' = v_requested_subject_key
        then v_config->>'content_item_version_id'
      else null
    end
  ), '')::uuid;
  v_rubric_version_id := nullif(coalesce(
    v_subject_config->>'rubric_version_id',
    case
      when v_config->>'subject_key' = v_requested_subject_key
        then v_config->>'rubric_version_id'
      else null
    end
  ), '')::uuid;
  v_minutes := greatest(5, least(60, coalesce(
    (v_subject_config->>'available_minutes')::integer,
    (v_config->>'available_minutes')::integer,
    12
  )));

  if v_content_version_id is null or v_rubric_version_id is null then
    raise exception 'free_score_check:not_configured';
  end if;

  select
    s.id,
    s.subject_key,
    s.display_name,
    ci.exam_pack_version_id,
    civ.stimulus_image_path,
    cvr.image_needed
  into
    v_subject_id,
    v_subject_key,
    v_subject_name,
    v_exam_pack_version_id,
    v_stimulus_image_path,
    v_image_needed
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  left join app.content_visual_requirements cvr
    on cvr.content_item_version_id = civ.id
  where civ.id = v_content_version_id
    and civ.status = 'published'
    and ci.status = 'published'
    and ci.item_type = 'frq'
    and epv.status = 'published'
    and s.status = 'active'
    and s.subject_key = v_requested_subject_key;

  if v_subject_id is null then
    raise exception 'free_score_check:content_not_published';
  end if;

  if v_stimulus_image_path is not null
     or coalesce(v_image_needed, '') <> 'no_not_needed' then
    raise exception 'free_score_check:content_not_student_visible';
  end if;

  perform pg_advisory_xact_lock(hashtextextended(p_user_id::text || ':' || v_subject_id::text, 0));

  insert into app.acquisition_profiles (
    user_id, marketing_email_opt_in, privacy_notice_version, consented_at,
    first_touch, last_touch
  ) values (
    p_user_id,
    p_marketing_email_opt_in,
    p_privacy_notice_version,
    case when p_marketing_email_opt_in then now() else null end,
    coalesce(p_first_touch, '{}'::jsonb),
    coalesce(p_last_touch, '{}'::jsonb)
  )
  on conflict (user_id) do update set
    marketing_email_opt_in = excluded.marketing_email_opt_in,
    privacy_notice_version = excluded.privacy_notice_version,
    consented_at = case
      when excluded.marketing_email_opt_in then coalesce(app.acquisition_profiles.consented_at, now())
      else null
    end,
    last_touch = excluded.last_touch;

  select * into v_check
  from app.free_score_checks
  where user_id = p_user_id and subject_id = v_subject_id
  for update;

  if found then
    return jsonb_build_object(
      'free_score_check_id', v_check.id,
      'state', v_check.state,
      'subject_id', v_check.subject_id,
      'subject_key', v_subject_key,
      'subject_name', v_subject_name,
      'exam_pack_version_id', v_check.exam_pack_version_id,
      'content_item_version_id', v_check.content_item_version_id,
      'rubric_version_id', v_check.rubric_version_id,
      'learning_session_id', v_check.learning_session_id,
      'attempt_id', v_check.attempt_id,
      'repair_attempt_id', v_check.repair_attempt_id,
      'initial_response_version_id', v_check.initial_response_version_id,
      'repair_response_version_id', v_check.repair_response_version_id
    );
  end if;

  insert into app.learning_sessions (
    user_id, exam_pack_version_id, entry_path, session_mode, available_minutes
  ) values (
    p_user_id, v_exam_pack_version_id, 'check_work', 'quick', v_minutes
  ) returning id into v_session_id;

  insert into app.attempts (
    user_id, learning_session_id, exam_pack_version_id,
    content_item_version_id, attempt_mode, assistance_state
  ) values (
    p_user_id, v_session_id, v_exam_pack_version_id,
    v_content_version_id, 'frq', 'independent'
  ) returning id into v_attempt_id;

  insert into app.response_versions (
    attempt_id, response_text, response_parts, version_number, created_by
  ) values (
    v_attempt_id, null, '{}'::jsonb, 1, p_user_id
  ) returning id into v_response_version_id;

  insert into app.free_score_checks (
    user_id, subject_id, exam_pack_version_id, content_item_version_id,
    rubric_version_id, learning_session_id, attempt_id,
    initial_response_version_id
  ) values (
    p_user_id, v_subject_id, v_exam_pack_version_id, v_content_version_id,
    v_rubric_version_id, v_session_id, v_attempt_id, v_response_version_id
  ) returning * into v_check;

  return jsonb_build_object(
    'free_score_check_id', v_check.id,
    'state', v_check.state,
    'subject_id', v_check.subject_id,
    'subject_key', v_subject_key,
    'subject_name', v_subject_name,
    'exam_pack_version_id', v_check.exam_pack_version_id,
    'content_item_version_id', v_check.content_item_version_id,
    'rubric_version_id', v_check.rubric_version_id,
    'learning_session_id', v_check.learning_session_id,
    'attempt_id', v_check.attempt_id,
    'repair_attempt_id', null,
    'initial_response_version_id', v_check.initial_response_version_id,
    'repair_response_version_id', null
  );
end;
$$;

revoke all on function app.start_free_score_check(uuid, jsonb, jsonb, boolean, text, text) from public, anon, authenticated;
grant execute on function app.start_free_score_check(uuid, jsonb, jsonb, boolean, text, text) to service_role;

commit;
