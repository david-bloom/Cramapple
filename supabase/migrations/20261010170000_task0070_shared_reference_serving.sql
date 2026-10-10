-- TASK-0070: serve shared reference content across sibling subjects (Calculus BC reads Calculus AB).
--
-- Why: AP Calculus AB and BC share one CED, and BC's units 1-5 topic sets are identical to AB's while
-- units 6-8 are a superset (ab_only = 0 for every unit 1-8, measured 2026-10-10). `unit_reference_entries`
-- is keyed by subject_key and `get_topic_point_guides` filters on it, so BC students got reference[] = []
-- for topics where AB students got entries. Duplicating the rows was the alternative; it was rejected
-- because the same duplication in `topic_explainers` has already drifted (all 81 shared AB/BC explainers
-- differ, and BC's are the repaired ones), and because every future correction to an AB row would need
-- mirroring.
--
-- No content row is created, copied or modified by this migration. Serving only.
--
-- Rollback without a migration: `delete from app.subject_reference_aliases;` — the unioned branch then
-- matches nothing and the function returns exactly its previous payload. The previous function body is
-- preserved in `docs/tasks/TASK-0070-...md` and in git history for a full restore.

begin;

create table if not exists app.subject_reference_aliases (
  subject_key        text    not null,
  source_subject_key text    not null,
  unit_from          integer not null,
  unit_to            integer not null,
  note               text,
  created_at         timestamptz not null default now(),
  primary key (subject_key, source_subject_key),
  constraint subject_reference_aliases_unit_range check (unit_from >= 1 and unit_to >= unit_from),
  constraint subject_reference_aliases_not_self   check (subject_key <> source_subject_key),
  constraint subject_reference_aliases_subject_fmt check (subject_key ~ '^[a-z0-9][a-z0-9_]*$'),
  constraint subject_reference_aliases_source_fmt  check (source_subject_key ~ '^[a-z0-9][a-z0-9_]*$')
);

comment on table app.subject_reference_aliases is
  'TASK-0070. A subject may serve another subject''s published unit_reference_entries for a unit range, '
  'instead of duplicating the rows. Read only by the SECURITY DEFINER RPC get_topic_point_guides; the '
  'requesting subject''s own entry always wins, and an alias entry is served only when its owner topic '
  'exists in the requesting subject''s latest verified taxonomy.';

alter table app.subject_reference_aliases enable row level security;
alter table app.subject_reference_aliases force row level security;
-- No policies and no grants: only the definer function reads this table.
revoke all on app.subject_reference_aliases from public;

insert into app.subject_reference_aliases (subject_key, source_subject_key, unit_from, unit_to, note)
values ('ap_calculus_bc', 'ap_calculus_ab', 1, 8,
        'AB and BC share one CED. Units 1-5 topic sets are identical and units 6-8 BC is a superset of AB '
        '(measured 2026-10-10). BC-only units 9-10 are excluded. TASK-0070.')
on conflict (subject_key, source_subject_key) do nothing;

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
          'practiceBridge', te.practice_bridge
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
    ), '[]'::jsonb)
  )
  into v_payload;

  return v_payload;
end;
$function$;

commit;
