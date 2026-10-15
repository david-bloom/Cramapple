-- Restore the canonical helper missing in Development; existing environments remain unchanged.
-- Source: 20260804170000_taxonomy_label_layer.sql; matches current Production body.
begin;
do $restore_missing$
begin
  if to_regprocedure('app.taxonomy_relevant_hash(uuid)') is null then
    execute $helper$
create or replace function app.taxonomy_relevant_hash(
  _content_item_version_id uuid
)
returns text
language sql
stable
security definer
set search_path = pg_catalog
as $$
  select encode(
    extensions.digest(
      jsonb_build_object(
        'stem', civ.stem,
        'stimulus', civ.stimulus,
        'prompt_json', coalesce(civ.prompt_json, '{}'::jsonb)
          - 'modules'
          - 'subtopics',
        'canonical_answer_1', civ.canonical_answer_1,
        'canonical_answer_2', civ.canonical_answer_2,
        'mcq_choices', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'choice_key', mc.choice_key,
              'choice_text', mc.choice_text,
              'is_correct', mc.is_correct,
              'rationale', mc.rationale
            )
            order by mc.choice_key
          )
          from app.mcq_choices mc
          where mc.content_item_version_id = civ.id
        ), '[]'::jsonb),
        'frq_criteria', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'criterion_key', fc.criterion_key,
              'learner_facing_text', fc.learner_facing_text,
              'points_possible', fc.points_possible,
              'evidence_requirements', fc.evidence_requirements,
              'minimum_fix', fc.minimum_fix
            )
            order by fc.criterion_key
          )
          from app.frq_criteria fc
          where fc.content_item_version_id = civ.id
        ), '[]'::jsonb)
      )::text,
      'sha256'
    ),
    'hex'
  )
  from app.content_item_versions civ
  where civ.id = _content_item_version_id;
$$;

revoke all on function app.taxonomy_relevant_hash(uuid)
  from public, anon, authenticated;
grant execute on function app.taxonomy_relevant_hash(uuid) to service_role;
$helper$;
  end if;
end;
$restore_missing$;
commit;
