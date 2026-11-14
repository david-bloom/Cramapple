-- Cheat Sheet digestibility #2 phase 2: authored "In 30 seconds" text.
-- Nullable; the app falls back to its derived block when null. Additive only.
alter table app.topic_explainers add column if not exists quick_take text;

alter table app.topic_explainers drop constraint if exists topic_explainers_quick_take_check;
alter table app.topic_explainers add constraint topic_explainers_quick_take_check
  check (quick_take is null or (btrim(quick_take) <> '' and char_length(quick_take) <= 400));

comment on column app.topic_explainers.quick_take is
  'Newline-separated "Label: sentence" lines (answer move / how points are lost / remember it), max 25 words each. Null = app derives the block.';

-- Appending a column at the end of a view keeps its grants.
create or replace view public.topic_explainers
with (security_invoker = true, security_barrier = true) as
SELECT te.topic_explainer_id AS id,
    COALESCE(registry_subject.subject_key, te.subject_key) AS subject_key,
    te.unit_number,
    ('unit-'::text || (te.unit_number)::text) AS unit_id,
    te.topic_code AS topic_id,
    te.title,
    te.core_idea,
    te.what_students_need_to_understand,
    te.how_this_becomes_points,
    te.answer_move,
    te.mini_example_question,
    te.weak_answer,
    te.point_attaining_answer,
    te.common_point_loss,
    te.practice_bridge,
    jsonb_build_object('question', te.mini_example_question, 'weakAnswer', te.weak_answer, 'pointAttainingAnswer', te.point_attaining_answer) AS mini_example,
    te.created_at,
    te.updated_at,
    te.published_at,
    (split_part(te.topic_code, '.'::text, 1))::integer AS topic_sort_major,
    (split_part(te.topic_code, '.'::text, 2))::integer AS topic_sort_minor,
    (((split_part(te.topic_code, '.'::text, 1))::integer * 1000) + (split_part(te.topic_code, '.'::text, 2))::integer) AS topic_sort_key,
    te.subject_key AS canonical_subject_key,
    te.quick_take
   FROM (app.topic_explainers te
     LEFT JOIN LATERAL ( SELECT s.subject_key
           FROM app.subjects s
          WHERE ((app.normalize_student_subject_key(s.subject_key) = te.subject_key) AND (s.status = 'active'::text))
          ORDER BY s.created_at, s.subject_key
         LIMIT 1) registry_subject ON (true))
  WHERE (te.status = 'published'::text);

-- Body = Dev's live definition plus 'quickTake' in the explainers object.
CREATE OR REPLACE FUNCTION public.get_topic_point_guides(_subject_key text, _unit_number integer DEFAULT NULL::integer, _topic_code text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_subject_key text := nullif(app.normalize_student_subject_key(_subject_key), '');
  v_topic_code text := nullif(btrim(_topic_code), '');
  v_payload jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if v_subject_key is null then
    raise exception 'topic_guides:subject_required' using errcode = '22023';
  end if;
  if v_subject_key !~ '^[a-z0-9][a-z0-9_]*$' then
    raise exception 'topic_guides:invalid_subject_key' using errcode = '22023';
  end if;
  if _unit_number is not null and _unit_number <= 0 then
    raise exception 'topic_guides:invalid_unit' using errcode = '22023';
  end if;
  if v_topic_code is not null and v_topic_code !~ '^[0-9]+\.[0-9]+$' then
    raise exception 'topic_guides:invalid_topic_code' using errcode = '22023';
  end if;

  with published_briefs as (
    select *
    from app.topic_point_briefs tpb
    where tpb.subject_key = v_subject_key
      and tpb.status = 'published'
      and (_unit_number is null or tpb.unit_number = _unit_number)
      and (v_topic_code is null or tpb.topic_code = v_topic_code)
  ), published_explainers as (
    select *
    from app.topic_explainers te
    where te.subject_key = v_subject_key
      and te.status = 'published'
      and (_unit_number is null or te.unit_number = _unit_number)
      and (v_topic_code is null or te.topic_code = v_topic_code)
  ), alias_source as (
    -- TASK-0070: a sibling subject may read another subject's reference entries for a unit range.
    select a.source_subject_key, a.unit_from, a.unit_to
    from app.subject_reference_aliases a
    where a.subject_key = v_subject_key
  ), own_taxonomy_version as (
    select tsv.taxonomy_source_version as version_id
    from app.taxonomy_source_versions tsv
    where tsv.subject_key = v_subject_key
    order by tsv.verified_at desc nulls last, tsv.created_at desc
    limit 1
  ), published_reference as (
    select ure.*, null::text as shared_from_subject_key
    from app.unit_reference_entries ure
    where ure.subject_key = v_subject_key
      and ure.status = 'published'
      and (
        (v_topic_code is not null and v_topic_code = any (ure.topic_codes))
        or (v_topic_code is null and (_unit_number is null or ure.unit_number = _unit_number))
      )
    union all
    select src.*, src.subject_key as shared_from_subject_key
    from alias_source a
    join app.unit_reference_entries src
      on src.subject_key = a.source_subject_key
     and src.unit_number between a.unit_from and a.unit_to
    where src.status = 'published'
      and (
        (v_topic_code is not null and v_topic_code = any (src.topic_codes))
        or (v_topic_code is null and (_unit_number is null or src.unit_number = _unit_number))
      )
      -- the requesting subject's own entry always wins over a shared one
      and not exists (
        select 1
        from app.unit_reference_entries own
        where own.subject_key = v_subject_key
          and own.status = 'published'
          and own.owner_topic_code = src.owner_topic_code
          and own.kind = src.kind
          and own.title = src.title
      )
      -- never serve an entry for a topic the requesting subject's own taxonomy does not contain
      and exists (
        select 1
        from app.taxonomy_topics tt
        where tt.topic_code = src.owner_topic_code
          and tt.taxonomy_source_version = (select version_id from own_taxonomy_version)
      )
  ), published_hooks as (
    select h.*, pr.owner_topic_code, pr.unit_number, pr.title as reference_title, pr.kind as reference_kind
    from app.topic_memory_hooks h
    join published_reference pr on pr.reference_entry_id = h.reference_entry_id
    where h.status = 'published'
  )
  select jsonb_build_object(
    'subjectKey', v_subject_key,
    'unitNumber', _unit_number,
    'topicCode', v_topic_code,
    'briefs', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'subjectKey', tpb.subject_key,
          'unitId', 'unit-' || tpb.unit_number::text,
          'unitNumber', tpb.unit_number,
          'topicId', tpb.topic_code,
          'topicCode', tpb.topic_code,
          'title', tpb.title,
          'classImportance', tpb.class_importance,
          'examImportance', tpb.exam_importance,
          'whatItIs', tpb.what_it_is,
          'whyItMatters', tpb.why_it_matters,
          'howPointsAreEarned', tpb.how_points_are_earned,
          'answerMove', tpb.answer_move,
          'commonPointLoss', tpb.common_point_loss,
          'learnMorePath', tpb.learn_more_path,
          'practiceParams', jsonb_build_object(
            'subject', tpb.practice_subject_key,
            'unit', tpb.practice_unit_number::text,
            'topic', tpb.practice_topic_code
          )
        )
        order by
          tpb.unit_number,
          split_part(tpb.topic_code, '.', 1)::integer,
          split_part(tpb.topic_code, '.', 2)::integer
      )
      from published_briefs tpb
    ), '[]'::jsonb),
    'explainers', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'subject', te.subject_key,
          'subjectKey', te.subject_key,
          'unitId', 'unit-' || te.unit_number::text,
          'unitNumber', te.unit_number,
          'topicId', te.topic_code,
          'topicCode', te.topic_code,
          'title', te.title,
          'coreIdea', te.core_idea,
          'whatStudentsNeedToUnderstand', te.what_students_need_to_understand,
          'howThisBecomesPoints', te.how_this_becomes_points,
          'answerMove', te.answer_move,
          'miniExample', jsonb_build_object(
            'question', te.mini_example_question,
            'weakAnswer', te.weak_answer,
            'pointAttainingAnswer', te.point_attaining_answer
          ),
          'commonPointLoss', te.common_point_loss,
          'practiceBridge', te.practice_bridge,
          'quickTake', te.quick_take
        )
        order by
          te.unit_number,
          split_part(te.topic_code, '.', 1)::integer,
          split_part(te.topic_code, '.', 2)::integer
      )
      from published_explainers te
    ), '[]'::jsonb),
    'reference', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', pr.reference_entry_id,
          'subjectKey', pr.subject_key,
          'sharedFromSubjectKey', pr.shared_from_subject_key,
          'unitNumber', pr.unit_number,
          'ownerTopicCode', pr.owner_topic_code,
          'topicCodes', to_jsonb(pr.topic_codes),
          'kind', pr.kind,
          'title', pr.title,
          'body', pr.body,
          'items', pr.items,
          'visualAssetRef', pr.visual_asset_ref,
          'caution', pr.caution,
          'sourceNote', pr.source_note,
          'memoryHooks', coalesce((
            select jsonb_agg(
              jsonb_build_object(
                'id', ph.memory_hook_id,
                'kind', ph.kind,
                'hookText', ph.hook_text,
                'expandsTo', ph.expands_to,
                'whenToUse', ph.when_to_use,
                'caution', ph.caution,
                'sourceNote', ph.source_note
              )
              order by ph.created_at
            )
            from published_hooks ph
            where ph.reference_entry_id = pr.reference_entry_id
          ), '[]'::jsonb)
        )
        order by
          array_position(array['formula', 'vocabulary', 'list_sequence', 'convention', 'diagram'], pr.kind),
          pr.unit_number,
          split_part(pr.owner_topic_code, '.', 1)::integer,
          split_part(pr.owner_topic_code, '.', 2)::integer,
          pr.title
      )
      from published_reference pr
    ), '[]'::jsonb),
    'memoryHooks', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'id', ph.memory_hook_id,
          'referenceEntryId', ph.reference_entry_id,
          'referenceTitle', ph.reference_title,
          'referenceKind', ph.reference_kind,
          'ownerTopicCode', ph.owner_topic_code,
          'unitNumber', ph.unit_number,
          'kind', ph.kind,
          'hookText', ph.hook_text,
          'expandsTo', ph.expands_to,
          'whenToUse', ph.when_to_use,
          'caution', ph.caution,
          'sourceNote', ph.source_note
        )
        order by
          ph.unit_number,
          split_part(ph.owner_topic_code, '.', 1)::integer,
          split_part(ph.owner_topic_code, '.', 2)::integer,
          ph.created_at
      )
      from published_hooks ph
    ), '[]'::jsonb),
    -- TASK-0006 Lane A. Figures join through published_reference, so they
    -- inherit its scoping for free -- including TASK-0070's shared entries, which
    -- means a sibling subject reading another's reference content gets that
    -- content's figures too, without a second rule to keep in step.
    -- SECURITY DEFINER bypasses RLS, so published status is asserted here.
    'figures', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'figureId', f.figure_id,
          'family', f.family,
          'title', f.title,
          'shortTitle', f.short_title,
          'subtitle', f.subtitle,
          'caption', f.caption,
          'alt', f.alt,
          'xLabel', f.x_label,
          'yLabel', f.y_label,
          'note', f.note,
          'synthetic', f.synthetic,
          'valuesNote', f.values_note,
          'labels', f.labels,
          'params', f.params,
          'yTickFmt', f.y_tick_fmt,
          'xTickFmt', f.x_tick_fmt,
          -- A list, because one figure may be shown beside more than one entry.
          -- Scoped to entries in this payload: a student is not told about uses
          -- they cannot see.
          'usedBy', coalesce((
            select jsonb_agg(
              jsonb_build_object(
                'kind', 'reference_entry',
                'id', u2.reference_entry_id,
                'role', u2.role
              )
              order by u2.created_at
            )
            from app.figure_uses u2
            join published_reference pr2 on pr2.reference_entry_id = u2.reference_entry_id
            where u2.figure_id = f.figure_id
          ), '[]'::jsonb)
        )
        order by f.figure_id
      )
      from app.figures f
      where f.status = 'published'
        and exists (
          select 1
          from app.figure_uses u
          join published_reference pr on pr.reference_entry_id = u.reference_entry_id
          where u.figure_id = f.figure_id
        )
    ), '[]'::jsonb)
  )
  into v_payload;

  return v_payload;
end;
$function$;
