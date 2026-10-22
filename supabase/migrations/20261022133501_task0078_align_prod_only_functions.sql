-- TASK-0078 ruling 6 (David, 2026-10-22): align Development to Production.
-- Bucket: the 19 Production-only functions, the 4 triggers that bind four of them, and the
-- content-review-invariants cron job, all taken from Production's live catalogs on 2026-10-22
-- (pg_get_functiondef, pg_get_triggerdef, cron.job, proacl, obj_description).
-- One deliberate deviation: app.qa_grade_frq hard-codes the project URL it posts to; the Development
-- copy posts to Development's own evaluate-attempt (wmgjsdkphcyhngaffbqf), not Production's. Its two
-- vault secrets (qa_grader_rpc_secret_v1, qa_grader_anon_jwt_v1) are environment config and are not
-- copied; until they exist on Development the function raises 'QA bridge secrets are not configured'.
-- Function grants mirror Production's ACLs. Re-running is a no-op.

CREATE OR REPLACE FUNCTION app.gold_set_marks_are_immutable()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
begin
  raise exception 'gold_set_marks_immutable'
    using errcode = '0A000',
          detail = 'Element marks are write-once; corrections are not permitted.';
end;
$function$;

CREATE OR REPLACE FUNCTION app.gold_set_reader_is_eligible(p_user_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
  select exists (
    select 1 from app.profiles p
    where p.user_id = p_user_id and p.role = 'admin'
  ) or exists (
    select 1 from app.feature_flag_assignments f
    join app.profiles p on p.user_id = f.user_id
    where f.user_id = p_user_id
      and f.feature_key = 'gold-set-review'
      and f.enabled
      and (f.expires_at is null or f.expires_at > pg_catalog.now())
      and p.role in ('admin', 'tutor', 'reader')
  );
$function$;

CREATE OR REPLACE FUNCTION app.mark_content_taxonomy_labels_stale_for_version(_content_item_version_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_content_item_id uuid;
  v_taxo_hash text;
begin
  select civ.content_item_id, app.taxonomy_relevant_hash(civ.id)
    into v_content_item_id, v_taxo_hash
  from app.content_item_versions civ
  where civ.id = _content_item_version_id;

  if v_content_item_id is null or v_taxo_hash is null then
    return;
  end if;

  update app.content_taxonomy_labels ctl
  set label_status = 'stale'
  where ctl.content_item_id = v_content_item_id
    and ctl.superseded_by is null
    and ctl.label_status in ('validated', 'provisional_model')
    and ctl.validated_against_taxo_hash is distinct from v_taxo_hash;
end;
$function$;

CREATE OR REPLACE FUNCTION app.mark_content_taxonomy_labels_stale_from_child_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_content_item_version_id uuid;
begin
  if tg_op = 'DELETE' then
    v_content_item_version_id := old.content_item_version_id;
  else
    v_content_item_version_id := new.content_item_version_id;
  end if;

  perform app.mark_content_taxonomy_labels_stale_for_version(v_content_item_version_id);
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.mark_content_taxonomy_labels_stale_from_version_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
begin
  perform app.mark_content_taxonomy_labels_stale_for_version(new.id);
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION app.qa_grade_frq(p_content_item_version_id uuid, p_answer_text text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'app', 'extensions', 'vault'
 SET statement_timeout TO '115s'
AS $function$
declare
  v_qa_token text;
  v_anon_jwt text;
  v_response extensions.http_response;
  v_payload jsonb;
begin
  if p_content_item_version_id is null then
    raise exception using
      errcode = '22004',
      message = 'qa_grade_frq: content_item_version_id is required';
  end if;

  if nullif(btrim(p_answer_text), '') is null then
    raise exception using
      errcode = '22023',
      message = 'qa_grade_frq: answer_text is required';
  end if;

  if length(p_answer_text) > 50000 then
    raise exception using
      errcode = '22001',
      message = 'qa_grade_frq: answer_text exceeds 50000 characters';
  end if;

  select decrypted_secret
  into v_qa_token
  from vault.decrypted_secrets
  where name = 'qa_grader_rpc_secret_v1'
  limit 1;

  select decrypted_secret
  into v_anon_jwt
  from vault.decrypted_secrets
  where name = 'qa_grader_anon_jwt_v1'
  limit 1;

  if nullif(v_qa_token, '') is null or nullif(v_anon_jwt, '') is null then
    raise exception using
      errcode = '55000',
      message = 'qa_grade_frq: QA bridge secrets are not configured';
  end if;

  v_payload := jsonb_build_object(
    'qa_no_persist', true,
    'content_item_version_id', p_content_item_version_id,
    'answer_text', p_answer_text
  );

  perform extensions.http_set_curlopt('CURLOPT_CONNECTTIMEOUT_MS', '15000');
  perform extensions.http_set_curlopt('CURLOPT_TIMEOUT_MS', '110000');

  begin
    select *
    into v_response
    from extensions.http((
      'POST'::extensions.http_method,
      'https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/evaluate-attempt',
      array[
        row('Authorization', 'Bearer ' || v_anon_jwt)::extensions.http_header,
        row('apikey', v_anon_jwt)::extensions.http_header,
        row('Content-Type', 'application/json')::extensions.http_header,
        row('x-qa-grader-token', v_qa_token)::extensions.http_header
      ],
      'application/json',
      v_payload::text
    )::extensions.http_request);
  exception when others then
    perform extensions.http_reset_curlopt();
    raise;
  end;

  perform extensions.http_reset_curlopt();

  if v_response.status < 200 or v_response.status >= 300 then
    raise exception using
      errcode = '58000',
      message = format(
        'qa_grade_frq: evaluate-attempt returned HTTP %s: %s',
        v_response.status,
        left(coalesce(v_response.content, ''), 2000)
      );
  end if;

  return v_response.content::jsonb;
end;
$function$;

CREATE OR REPLACE FUNCTION app.seed_gold_set_elements_single_point(p_content_item_version_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_inserted integer;
begin
  if exists (
    select 1 from app.frq_criteria
    where content_item_version_id = p_content_item_version_id
      and points_possible > 1
  ) then
    raise exception 'multi_point_criterion_requires_decomposition'
      using errcode = '23514',
            detail = 'Use the Set A decomposition path; do not auto-map multi-point criteria.';
  end if;

  insert into app.gold_set_elements (
    frq_criterion_id, content_item_version_id, element_index, element_label
  )
  select fc.id, fc.content_item_version_id, 1, fc.learner_facing_text
  from app.frq_criteria fc
  where fc.content_item_version_id = p_content_item_version_id
  on conflict (frq_criterion_id, element_index) do nothing;

  get diagnostics v_inserted = row_count;
  return v_inserted;
end;
$function$;

CREATE OR REPLACE FUNCTION app.seed_gold_set_verification_assignments(p_reviewer_id uuid, p_answer_ids uuid[], p_min_sibling_gap integer DEFAULT 3)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_total integer;
  v_max_per_item integer;
  v_seq_offset integer;
  v_inserted integer;
  v_placed uuid[] := '{}';
  v_recent uuid[] := '{}';
  v_pick record;
  v_i integer;
  v_achieved integer;
begin
  if not app.gold_set_reader_is_eligible(p_reviewer_id) then
    raise exception 'reviewer_not_eligible' using errcode = '42501';
  end if;

  create temporary table _gs_pool on commit drop as
  select ans.gold_set_answer_id, ans.content_item_version_id
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = any(p_answer_ids)
    and not exists (
      select 1 from app.gold_set_verification_assignments a
      where a.reviewer_id = p_reviewer_id
        and a.gold_set_answer_id = ans.gold_set_answer_id
    );

  select count(*) into v_total from _gs_pool;
  if v_total = 0 then return 0; end if;

  -- Feasibility: an item holding more than ceil(total / gap) answers cannot be
  -- spaced that widely no matter how the rest are arranged.
  select max(c) into v_max_per_item
  from (select count(*) c from _gs_pool group by content_item_version_id) s;

  if v_max_per_item > ceil(v_total::numeric / p_min_sibling_gap) then
    raise exception 'sibling_gap_infeasible'
      using errcode = '23514',
            detail = format(
              'one item has %s of %s answers; a gap of %s needs no more than %s',
              v_max_per_item, v_total, p_min_sibling_gap,
              ceil(v_total::numeric / p_min_sibling_gap)
            );
  end if;

  -- Greedy max-spread.
  for v_i in 1..v_total loop
    select p.gold_set_answer_id, p.content_item_version_id
      into v_pick
    from _gs_pool p
    where p.gold_set_answer_id <> all(v_placed)
      and (array_length(v_recent, 1) is null
           or p.content_item_version_id <> all(v_recent))
    group by p.gold_set_answer_id, p.content_item_version_id
    order by (select count(*) from _gs_pool q
              where q.content_item_version_id = p.content_item_version_id
                and q.gold_set_answer_id <> all(v_placed)) desc,
             p.gold_set_answer_id
    limit 1;

    if not found then
      raise exception 'sibling_gap_unsatisfiable'
        using errcode = '23514',
              detail = format('stalled after %s of %s placements', v_i - 1, v_total);
    end if;

    v_placed := v_placed || v_pick.gold_set_answer_id;
    v_recent := (v_recent || v_pick.content_item_version_id);
    if array_length(v_recent, 1) > p_min_sibling_gap - 1 then
      v_recent := v_recent[2:array_length(v_recent, 1)];
    end if;
  end loop;

  select coalesce(max(seq), 0) into v_seq_offset
  from app.gold_set_verification_assignments
  where reviewer_id = p_reviewer_id;

  insert into app.gold_set_verification_assignments (
    gold_set_answer_id, reviewer_id, seq
  )
  select id, p_reviewer_id, v_seq_offset + ord
  from unnest(v_placed) with ordinality as t(id, ord)
  on conflict (reviewer_id, gold_set_answer_id) do nothing;

  get diagnostics v_inserted = row_count;

  -- Verify the RESULT, not the input. The original function's failure was
  -- precisely that it checked a precondition and reported success regardless.
  select min(gap) into v_achieved from (
    select a.seq - lag(a.seq) over (
             partition by ans.content_item_version_id order by a.seq) as gap
    from app.gold_set_verification_assignments a
    join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
    where a.reviewer_id = p_reviewer_id
  ) g where gap is not null;

  if v_achieved is not null and v_achieved < p_min_sibling_gap then
    raise exception 'sibling_gap_not_achieved'
      using errcode = '23514',
            detail = format('achieved gap %s, required %s', v_achieved, p_min_sibling_gap);
  end if;

  return v_inserted;
end;
$function$;

CREATE OR REPLACE FUNCTION app.seed_taxonomy_units(_subject_key text, _school_year text, _source_title text, _source_citation text, _source_uri text, _verified_at timestamp with time zone, _units jsonb)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_source_version uuid;
begin
  if jsonb_typeof(_units) <> 'array' then
    raise exception 'taxonomy_units:units_must_be_array' using errcode = '22023';
  end if;

  insert into app.taxonomy_source_versions (
    subject_key,
    school_year,
    source_title,
    taxonomy_confidence,
    source_citation,
    source_uri,
    verified_at
  ) values (
    _subject_key,
    _school_year,
    _source_title,
    'verified',
    _source_citation,
    _source_uri,
    _verified_at
  )
  on conflict (subject_key, school_year, source_title) do update
    set taxonomy_confidence = 'verified',
        source_citation = excluded.source_citation,
        source_uri = excluded.source_uri,
        verified_at = excluded.verified_at
  returning taxonomy_source_version into v_source_version;

  insert into app.taxonomy_units (
    taxonomy_source_version,
    unit_number,
    unit_title,
    is_exam_assessed
  )
  select
    v_source_version,
    (unit_row.value ->> 'unit_number')::integer,
    unit_row.value ->> 'unit_title',
    coalesce((unit_row.value ->> 'is_exam_assessed')::boolean, true)
  from jsonb_array_elements(_units) as unit_row(value)
  on conflict (taxonomy_source_version, unit_number) do update
    set unit_title = excluded.unit_title,
        is_exam_assessed = excluded.is_exam_assessed;

  return v_source_version;
end;
$function$;

CREATE OR REPLACE FUNCTION app.servable_items_census()
 RETURNS TABLE(exam_code text, exam_pack_version_id uuid, published_items integer, unit_gated_servable integer, practice_targeted_drill integer, practice_full_exam_frq integer, serving_labels_total integer, serving_labels_validated integer, serving_label_hash_mismatch integer, items_with_no_serving_label integer, latest_version_not_published integer, topic_known integer, topic_known_skill_level integer)
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
  with latest as (
    select distinct on (civ.content_item_id) civ.*
    from app.content_item_versions civ
    order by civ.content_item_id, civ.version_num desc
  ), active_labels as (
    select distinct on (ctl.content_item_id) ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.label_scope = 'serving'
      and ctl.label_status = 'validated'
      and ctl.superseded_by is null
    order by ctl.content_item_id, ctl.label_version desc
  ), any_label as (
    select distinct on (ctl.content_item_id) ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.label_scope = 'serving' and ctl.superseded_by is null
    order by ctl.content_item_id, ctl.label_version desc
  ), packs as (
    select ep.exam_code, epv.id as epv,
           coalesce((select max(u) from unnest(m.allowed_unit_numbers) u), 0) as top_unit
    from app.exam_packs ep
    join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
    left join app.home_release_manifest m on m.exam_pack_version_id = epv.id
  )
  select
    p.exam_code,
    p.epv,
    (select count(*)::int from app.content_items ci join latest civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'),
    (select count(*)::int
       from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join active_labels label on label.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv
        and ci.status = 'published' and civ.status = 'published'
        and label.max_required_unit <= p.top_unit
        and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
        and (ci.item_type in ('mcq','quantitative')
             or (ci.item_type = 'frq' and ci.frq_form in ('short','long')))
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true),
    (select count(*)::int from app.content_items ci
       join app.content_item_versions civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.item_type = 'frq'
        and ci.status = 'published' and civ.status = 'published'
        and ci.practice_format = 'targeted_drill'
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true),
    (select count(*)::int from app.content_items ci
       join app.content_item_versions civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.item_type = 'frq'
        and ci.status = 'published' and civ.status = 'published'
        and ci.practice_format = 'full_exam_frq'
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true),
    (select count(*)::int from app.content_items ci join any_label l on l.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published'),
    (select count(*)::int from app.content_items ci join active_labels l on l.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published'),
    (select count(*)::int from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join any_label l on l.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'
        and l.validated_against_taxo_hash is distinct from app.taxonomy_relevant_hash(civ.id)),
    (select count(*)::int from app.content_items ci join latest civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'
        and not exists (select 1 from any_label l where l.content_item_id = ci.id)),
    (select count(*)::int from app.content_items ci join latest civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status <> 'published'),
    (select count(*)::int from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join app.content_item_cells cic
         on cic.content_item_version_id = civ.id and cic.is_primary
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'),
    (select count(*)::int from app.content_items ci
       join latest civ on civ.content_item_id = ci.id
       join app.content_item_cells cic
         on cic.content_item_version_id = civ.id and cic.is_primary
      where ci.exam_pack_version_id = p.epv and ci.status = 'published' and civ.status = 'published'
        and cic.skill_code is not null)
  from packs p
  order by p.exam_code, p.epv;
$function$;

CREATE OR REPLACE FUNCTION app.servable_items_census_selftest()
 RETURNS TABLE(exam_code text, path text, probe text, rpc_rows integer, mirrored integer, status text)
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  r record;
  u integer;
  v_rpc integer;
  v_mirror integer;
begin
  for r in
    select ep.exam_code as code, epv.id as epv, m.allowed_unit_numbers as units
    from app.exam_packs ep
    join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
    left join app.home_release_manifest m on m.exam_pack_version_id = epv.id
    order by ep.exam_code, epv.id
  loop
    -- unit-gated path, one probe per allowed unit
    if r.units is not null then
      foreach u in array r.units loop
        select count(*) into v_rpc
        from public.select_unit_gated_practice_items(r.epv, u, null, null, 50);

        with latest as (
          select distinct on (civ.content_item_id) civ.*
          from app.content_item_versions civ
          order by civ.content_item_id, civ.version_num desc
        ), active_labels as (
          select distinct on (ctl.content_item_id) ctl.*
          from app.content_taxonomy_labels ctl
          where ctl.label_scope = 'serving' and ctl.label_status = 'validated'
            and ctl.superseded_by is null
          order by ctl.content_item_id, ctl.label_version desc
        )
        select count(*) into v_mirror
        from app.content_items ci
        join latest civ on civ.content_item_id = ci.id
        join active_labels label on label.content_item_id = ci.id
        where ci.exam_pack_version_id = r.epv
          and ci.status = 'published' and civ.status = 'published'
          and label.max_required_unit <= u
          and label.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
          and (ci.item_type in ('mcq','quantitative')
               or (ci.item_type = 'frq' and ci.frq_form in ('short','long')))
          and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true;

        exam_code := r.code; path := 'unit_gated'; probe := 'unit=' || u;
        rpc_rows := v_rpc; mirrored := v_mirror;
        status := case when v_mirror >= 50 then 'skipped_capped'
                       when v_rpc = v_mirror then 'ok' else 'MISMATCH' end;
        return next;
      end loop;
    end if;

    -- practice path, one probe per accepted format
    foreach probe in array array['targeted_drill', 'full_exam_frq'] loop
      select count(*) into v_rpc from public.select_practice_frqs(r.epv, probe, 50);

      select count(*) into v_mirror
      from app.content_items ci
      join app.content_item_versions civ on civ.content_item_id = ci.id
      where ci.exam_pack_version_id = r.epv and ci.item_type = 'frq'
        and ci.status = 'published' and civ.status = 'published'
        and ci.practice_format = probe
        and coalesce((civ.prompt_json->>'hand_drawn')::boolean, false) is not true;

      exam_code := r.code; path := 'practice';
      rpc_rows := v_rpc; mirrored := v_mirror;
      status := case when v_mirror >= 50 then 'skipped_capped'
                     when v_rpc = v_mirror then 'ok' else 'MISMATCH' end;
      return next;
    end loop;
  end loop;
end;
$function$;

CREATE OR REPLACE FUNCTION app.taxonomy_scope_selftest()
 RETURNS TABLE(check_name text, exam_code text, content_key text, detail text)
 LANGUAGE sql
 STABLE
 SET search_path TO 'pg_catalog'
AS $function$
  -- 1. A cell tag must use the taxonomy source version of the item's OWN
  --    subject. The composite FK to taxonomy_cells does not enforce this: it
  --    only requires the (source_version, topic, skill) triple to exist
  --    somewhere, so an AB item tagged with a BC source version would pass it.
  select 'cell_uses_foreign_subject_taxonomy'::text,
         ep.exam_code::text,
         ci.content_key::text,
         format('cell row uses taxonomy_source_version %s but the item''s subject resolves to %s',
                cic.taxonomy_source_version, own.taxonomy_source_version)::text
  from app.content_item_cells cic
  join app.content_items ci on ci.id = cic.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  left join app.taxonomy_source_versions own on own.subject_key = ep.exam_code
  where own.taxonomy_source_version is null
     or cic.taxonomy_source_version <> own.taxonomy_source_version

  union all

  -- 2. The assigned topic must be registered for the item's own subject. This
  --    is the direct statement of the rule the Calculus defect broke: an AB
  --    item can only carry an AB topic.
  select 'topic_not_in_subject_taxonomy'::text,
         ep.exam_code::text,
         ci.content_key::text,
         format('topic %s is not registered for subject %s', cic.topic_code, ep.exam_code)::text
  from app.content_item_cells cic
  join app.content_items ci on ci.id = cic.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.taxonomy_source_versions own on own.subject_key = ep.exam_code
  where cic.topic_code is not null
    and not exists (
      select 1 from app.taxonomy_topics t
      where t.taxonomy_source_version = own.taxonomy_source_version
        and t.topic_code = cic.topic_code
    )

  union all

  -- 3. Same rule for the unit-level serving labels, which are where the
  --    Calculus items first showed trouble. A required unit that no topic in
  --    the subject belongs to means the label points outside the course.
  select 'serving_label_unit_not_in_subject'::text,
         ep.exam_code::text,
         ci.content_key::text,
         format('serving label claims unit %s, which has no registered topic in %s', u, ep.exam_code)::text
  from app.content_taxonomy_labels ctl
  cross join lateral unnest(coalesce(ctl.required_units, '{}')) as u
  join app.content_items ci on ci.id = ctl.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.taxonomy_source_versions own on own.subject_key = ep.exam_code
  where ctl.superseded_by is null
    and ctl.label_scope = 'serving'
    and not exists (
      select 1 from app.taxonomy_topics t
      where t.taxonomy_source_version = own.taxonomy_source_version
        and t.unit_number = u
    );
$function$;

CREATE OR REPLACE FUNCTION app.verify_qa_grader_token(p_token text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog', 'app', 'extensions', 'vault'
AS $function$
  select coalesce(
    nullif(p_token, '') is not null
    and extensions.digest(p_token, 'sha256') = extensions.digest(
      (
        select decrypted_secret
        from vault.decrypted_secrets
        where name = 'qa_grader_rpc_secret_v1'
        limit 1
      ),
      'sha256'
    ),
    false
  );
$function$;

CREATE OR REPLACE FUNCTION public._epv_is_selectable(_version_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
  SELECT EXISTS (
    SELECT 1
      FROM app.exam_pack_versions v
      JOIN app.exam_packs         p ON p.id = v.exam_pack_id
      JOIN app.subjects           s ON s.id = p.subject_id
     WHERE v.id     = _version_id
       AND v.status = 'published'
       AND s.status = 'active'
  );
$function$;

CREATE OR REPLACE FUNCTION public.gold_set_access()
 RETURNS boolean
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    return false;
  end if;
  return app.gold_set_reader_is_eligible(v_user_id);
end;
$function$;

CREATE OR REPLACE FUNCTION public.gold_set_admin_overview()
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if not exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  return jsonb_build_object(
    'by_reviewer', coalesce((
      select jsonb_agg(x order by x->>'reviewer_name')
      from (
        select jsonb_build_object(
          'reviewer_name', p.full_name,
          'total', count(*),
          'pending', count(*) filter (where a.status = 'pending'),
          'submitted', count(*) filter (where a.status = 'submitted'),
          'flagged', count(*) filter (where a.status = 'flagged_contaminated'),
          'last_submitted_at', max(a.submitted_at)
        ) as x
        from app.gold_set_verification_assignments a
        join app.profiles p on p.user_id = a.reviewer_id
        group by p.full_name
      ) s), '[]'::jsonb),
    'assignments', coalesce((
      select jsonb_agg(y order by y->>'reviewer_name', (y->>'seq')::int)
      from (
        select jsonb_build_object(
          'reviewer_name', p.full_name,
          'content_key', ci.content_key,
          'seq', a.seq,
          'status', a.status,
          'submitted_at', a.submitted_at,
          'completed_by_name', cb.full_name,
          'marks_recorded', (
            select count(*) from app.gold_set_element_marks m
            where m.gold_set_verification_assignment_id
                = a.gold_set_verification_assignment_id)
        ) as y
        from app.gold_set_verification_assignments a
        join app.profiles p on p.user_id = a.reviewer_id
        left join app.profiles cb on cb.user_id = a.completed_by
        join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
        join app.content_item_versions civ on civ.id = ans.content_item_version_id
        join app.content_items ci on ci.id = civ.content_item_id
      ) t), '[]'::jsonb)
  );
end;
$function$;

CREATE OR REPLACE FUNCTION public.gold_set_verification_next(p_exclude_ids uuid[] DEFAULT '{}'::uuid[])
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_is_admin boolean;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if not app.gold_set_reader_is_eligible(v_user_id) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  select exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) into v_is_admin;

  select jsonb_build_object(
    'assignment_id', a.gold_set_verification_assignment_id,
    'seq', a.seq,
    'stem', civ.stem,
    'stimulus', civ.stimulus,
    'stimulus_image_path', civ.stimulus_image_path,
    'parts', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'part_key', p.part ->> 'part_key',
            'prompt_text', p.part ->> 'prompt_text'
          )
          order by p.ord
        )
        from jsonb_array_elements(civ.prompt_json -> 'parts') with ordinality as p(part, ord)
      ),
      '[]'::jsonb
    ),
    'answer_text', ans.answer_text,
    'elements', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'element_id', e.gold_set_element_id,
            'criterion_key', fc.criterion_key,
            'element_label', e.element_label,
            'element_index', e.element_index
          )
          order by fc.criterion_key, e.element_index
        )
        from app.gold_set_elements e
        join app.frq_criteria fc on fc.id = e.frq_criterion_id
        where e.content_item_version_id = ans.content_item_version_id
      ),
      '[]'::jsonb
    )
  )
  into v_result
  from app.gold_set_verification_assignments a
  join app.gold_set_answers ans
    on ans.gold_set_answer_id = a.gold_set_answer_id
  join app.content_item_versions civ
    on civ.id = ans.content_item_version_id
  where a.status = 'pending'
    and (v_is_admin or a.reviewer_id = v_user_id)
    and not (a.gold_set_verification_assignment_id
      = any(coalesce(p_exclude_ids, '{}'::uuid[])))
  order by
    (a.reviewer_id <> v_user_id),
    a.assigned_at,
    a.seq
  limit 1;

  return v_result;
end;
$function$;

CREATE OR REPLACE FUNCTION public.gold_set_verification_progress(p_all_reviewers boolean DEFAULT false)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_is_admin boolean;
  v_all boolean;
  v_done integer;
  v_total integer;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) into v_is_admin;

  v_all := coalesce(p_all_reviewers, false) and v_is_admin;

  select count(*) filter (where a.status <> 'pending'), count(*)
  into v_done, v_total
  from app.gold_set_verification_assignments a
  join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
  where (
    -- Own queue: everything, fixtures included, so a QA tester sees their own work.
    a.reviewer_id = v_user_id
    -- Aggregate: real corpus only.
    or (v_all and not ans.is_fixture)
  );

  return jsonb_build_object(
    'done', coalesce(v_done, 0),
    'total', coalesce(v_total, 0),
    'scope', case when v_all then 'all' else 'mine' end
  );
end;
$function$;

CREATE OR REPLACE FUNCTION public.submit_gold_set_verification(p_assignment_id uuid, p_marks jsonb, p_flagged_contaminated boolean DEFAULT false)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_is_admin boolean;
  v_assignment app.gold_set_verification_assignments%rowtype;
  v_version_id uuid;
  v_expected_elements integer;
  v_supplied_elements integer;
  v_status text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) into v_is_admin;

  select * into v_assignment
  from app.gold_set_verification_assignments
  where gold_set_verification_assignment_id = p_assignment_id
  for update;

  if not found then
    raise exception 'assignment_not_found' using errcode = 'P0002';
  end if;

  if v_assignment.reviewer_id <> v_user_id and not v_is_admin then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  if v_assignment.status <> 'pending' then
    return jsonb_build_object(
      'status', 'already_submitted',
      'assignment_id', p_assignment_id
    );
  end if;

  if jsonb_typeof(p_marks) <> 'array' then
    raise exception 'invalid_marks' using errcode = '22023';
  end if;

  select ans.content_item_version_id into v_version_id
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = v_assignment.gold_set_answer_id;

  v_status := case
    when p_flagged_contaminated then 'flagged_contaminated'
    else 'submitted'
  end;

  if not p_flagged_contaminated then
    select count(*) into v_expected_elements
    from app.gold_set_elements
    where content_item_version_id = v_version_id;

    if v_expected_elements = 0 then
      raise exception 'no_elements_seeded'
        using errcode = '23514',
              detail = 'This item has no gold_set_elements; seed them before verification.';
    end if;

    select count(*) into v_supplied_elements
    from jsonb_array_elements(p_marks) m
    where (m ->> 'element_id') is not null;

    if v_supplied_elements <> v_expected_elements then
      raise exception 'incomplete_marks'
        using errcode = '23514',
              detail = format(
                'expected %s element marks, received %s',
                v_expected_elements, v_supplied_elements
              );
    end if;
  end if;

  insert into app.gold_set_element_marks (
    gold_set_verification_assignment_id,
    gold_set_element_id,
    present,
    evidence_quote
  )
  select
    p_assignment_id,
    (m ->> 'element_id')::uuid,
    (m ->> 'present')::boolean,
    nullif(btrim(coalesce(m ->> 'evidence_quote', '')), '')
  from jsonb_array_elements(p_marks) m
  where (m ->> 'element_id') is not null;

  if exists (
    select 1
    from app.gold_set_element_marks mk
    join app.gold_set_elements e
      on e.gold_set_element_id = mk.gold_set_element_id
    where mk.gold_set_verification_assignment_id = p_assignment_id
      and e.content_item_version_id is distinct from v_version_id
  ) then
    raise exception 'element_item_mismatch' using errcode = '23514';
  end if;

  update app.gold_set_verification_assignments
  set status = v_status,
      submitted_at = pg_catalog.now(),
      completed_by = v_user_id
  where gold_set_verification_assignment_id = p_assignment_id;

  return jsonb_build_object(
    'status', v_status,
    'assignment_id', p_assignment_id
  );
end;
$function$;

-- grants (Production proacl)
revoke execute on function app.gold_set_reader_is_eligible(uuid) from public;
grant execute on function app.gold_set_reader_is_eligible(uuid) to service_role;
revoke execute on function app.mark_content_taxonomy_labels_stale_for_version(uuid) from public;
grant execute on function app.mark_content_taxonomy_labels_stale_for_version(uuid) to service_role;
revoke execute on function app.qa_grade_frq(uuid, text) from public;
grant execute on function app.qa_grade_frq(uuid, text) to service_role;
revoke execute on function app.seed_gold_set_elements_single_point(uuid) from public;
grant execute on function app.seed_gold_set_elements_single_point(uuid) to service_role;
revoke execute on function app.seed_gold_set_verification_assignments(uuid, uuid[], integer) from public;
grant execute on function app.seed_gold_set_verification_assignments(uuid, uuid[], integer) to service_role;
revoke execute on function app.seed_taxonomy_units(text, text, text, text, text, timestamp with time zone, jsonb) from public;
grant execute on function app.seed_taxonomy_units(text, text, text, text, text, timestamp with time zone, jsonb) to service_role;
grant execute on function app.servable_items_census() to public, service_role, ci_servable_items_reader;
revoke execute on function app.servable_items_census_selftest() from public;
grant execute on function app.servable_items_census_selftest() to service_role, ci_servable_items_reader;
revoke execute on function app.taxonomy_scope_selftest() from public;
grant execute on function app.taxonomy_scope_selftest() to service_role;
revoke execute on function app.verify_qa_grader_token(text) from public;
grant execute on function app.verify_qa_grader_token(text) to service_role;
revoke execute on function public._epv_is_selectable(uuid) from public;
grant execute on function public._epv_is_selectable(uuid) to service_role;
revoke execute on function public.gold_set_access() from public;
grant execute on function public.gold_set_access() to authenticated, service_role;
revoke execute on function public.gold_set_admin_overview() from public;
grant execute on function public.gold_set_admin_overview() to authenticated, service_role;
revoke execute on function public.gold_set_verification_next(uuid[]) from public;
grant execute on function public.gold_set_verification_next(uuid[]) to authenticated, service_role;
revoke execute on function public.gold_set_verification_progress(boolean) from public;
grant execute on function public.gold_set_verification_progress(boolean) to authenticated, service_role;
revoke execute on function public.submit_gold_set_verification(uuid, jsonb, boolean) from public;
grant execute on function public.submit_gold_set_verification(uuid, jsonb, boolean) to authenticated, service_role;

-- comments (Production obj_description)
comment on function app.gold_set_reader_is_eligible(uuid) is 'Gold-set access: admin by role, or an unexpired gold-set-review flag on a reviewer profile. Gates both the reader RPCs and queue seeding.';
comment on function app.qa_grade_frq(uuid, text) is 'Privileged AP Biology canonical-answer QA bridge. Calls evaluate-attempt in no-persist mode and returns criterion-level and raw grader output. Never expose to student roles.';
comment on function app.servable_items_census_selftest() is 'Checks app.servable_items_census()''s mirrored predicates against the real serving RPCs, per subject and unit. Any MISMATCH means the census has drifted from production and its numbers must not be trusted until fixed. Capped comparisons are reported as skipped_capped rather than passed.';
comment on function app.taxonomy_scope_selftest() is 'TASK-0050. Returns one row per taxonomy-scope violation; zero rows is healthy. Checks that every content_item_cells tag uses its own subject''s taxonomy source version, that every assigned topic is registered for that subject, and that no serving label claims a unit the subject has no topics in. Added after three published apcalcab-* items were found assessing BC-only topics, a defect two labelling passes detected and had no way to report.';

-- triggers (Production pg_get_triggerdef)
drop trigger if exists tg_content_versions_taxonomy_stale on app.content_item_versions;
create trigger tg_content_versions_taxonomy_stale after insert or update of stem, stimulus, prompt_json, canonical_answer_1, canonical_answer_2 on app.content_item_versions for each row execute function app.mark_content_taxonomy_labels_stale_from_version_trigger();
drop trigger if exists tg_frq_criteria_taxonomy_stale on app.frq_criteria;
create trigger tg_frq_criteria_taxonomy_stale after insert or delete or update on app.frq_criteria for each row execute function app.mark_content_taxonomy_labels_stale_from_child_trigger();
drop trigger if exists tg_mcq_choices_taxonomy_stale on app.mcq_choices;
create trigger tg_mcq_choices_taxonomy_stale after insert or delete or update on app.mcq_choices for each row execute function app.mark_content_taxonomy_labels_stale_from_child_trigger();
drop trigger if exists tg_gold_set_element_marks_immutable on app.gold_set_element_marks;
create trigger tg_gold_set_element_marks_immutable before update on app.gold_set_element_marks for each row execute function app.gold_set_marks_are_immutable();

-- cron (Production cron.job; cron.schedule upserts by name)
select cron.schedule('content-review-invariants', '5 6 * * *', 'select app.check_content_review_invariants();');
