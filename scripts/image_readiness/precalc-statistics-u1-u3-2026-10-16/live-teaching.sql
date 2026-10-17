CREATE OR REPLACE FUNCTION public.get_open_hand_teaching_item(p_subject_key text, p_topic_code text)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_user_id uuid := auth.uid();
  v_role text;
  v_is_staff boolean;
  v_subject_id uuid;
  v_civ_id uuid;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_subject_key is null or p_topic_code is null then
    raise exception 'open_hand:missing_identity' using errcode = '22023';
  end if;
  select s.id into v_subject_id from app.subjects s where s.subject_key = p_subject_key and s.status = 'active';
  if v_subject_id is null then
    raise exception 'open_hand:item_not_accessible' using errcode = '42501';
  end if;
  select p.role into v_role from app.profiles p where p.user_id = v_user_id;
  v_is_staff := coalesce(v_role, '') = any (array['admin', 'content_author', 'tutor', 'reader', 'validator']);
  if not v_is_staff and not exists (
    select 1 from app.subject_entitlements se
    where se.user_id = v_user_id and se.status = 'active'
      and (se.all_subjects is true or se.subject_id = v_subject_id)
      and (se.starts_at is null or se.starts_at <= now())
      and (se.ends_at is null or se.ends_at > now())
  ) then
    raise exception 'open_hand:entitlement_required' using errcode = '42501';
  end if;

  select civ.id into v_civ_id
  from app.open_hand_teaching_items t
  join app.content_items ci on ci.id = t.content_item_id
  join app.content_item_versions civ on civ.content_item_id = ci.id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where t.released_at is null and t.topic_code = p_topic_code and ep.subject_id = v_subject_id
    and civ.status = 'published' and ci.status = 'published'
    and epv.status = 'published' and epv.retired_at is null
  order by t.source = 'generated' desc, t.designated_at
  limit 1;

  if v_civ_id is null then
    return null;
  end if;

  select jsonb_build_object(
    'content_item_version_id', civ.id,
    'content_item_id', ci.id,
    'item_type', ci.item_type,
    'subject_key', p_subject_key,
    'topic_code', p_topic_code,
    'topic_title', (select r.topic_title from app.content_item_topic_resolution r where r.content_item_version_id = civ.id and r.is_primary limit 1),
    'unit_number', (select r.unit_number from app.content_item_topic_resolution r where r.content_item_version_id = civ.id and r.is_primary limit 1),
    'stem', civ.stem,
    'stimulus', civ.stimulus,
    'stimulus_image_path', civ.stimulus_image_path,
    'scoring_eligible', false,
    'canonical_answers', jsonb_strip_nulls(jsonb_build_object('answer_1', civ.canonical_answer_1, 'answer_2', civ.canonical_answer_2)),
    'mcq_choices', coalesce((select jsonb_agg(jsonb_build_object(
        'choice_key', mc.choice_key, 'choice_text', mc.choice_text, 'is_correct', mc.is_correct,
        'rationale', mc.rationale, 'minimum_fix', mc.rationale) order by mc.choice_key)
      from app.mcq_choices mc where mc.content_item_version_id = civ.id), '[]'::jsonb),
    'frq_criteria', coalesce((select jsonb_agg(jsonb_build_object(
        'criterion_key', fc.criterion_key, 'learner_facing_text', fc.learner_facing_text,
        'points_possible', fc.points_possible, 'evidence_requirements', fc.evidence_requirements,
        'accepted_variants', fc.accepted_variants, 'minimum_fix', fc.minimum_fix) order by fc.criterion_key)
      from app.frq_criteria fc where fc.content_item_version_id = civ.id), '[]'::jsonb),
    'credited_response_spans', coalesce((select jsonb_agg(jsonb_build_object(
        'answer_field', cas.answer_field, 'span_ordinal', cas.span_ordinal,
        'span_text', cas.span_text, 'criterion_keys', cas.criterion_keys) order by cas.answer_field, cas.span_ordinal)
      from app.canonical_answer_spans cas where cas.content_item_version_id = civ.id), '[]'::jsonb)
  ) into v_result
  from app.content_item_versions civ join app.content_items ci on ci.id = civ.content_item_id
  where civ.id = v_civ_id;
  return v_result;
end;
$function$
