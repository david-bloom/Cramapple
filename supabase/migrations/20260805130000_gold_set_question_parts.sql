-- Gold-set reviewers were never shown the actual question. The reader
-- contract (public.gold_set_verification_next(), 20260803120000) projects
-- civ.stem, but content_item_versions.stem is a fixed placeholder
-- ("Answer all parts of the following question.") for every gold-set item —
-- the real per-part prompts live only in civ.prompt_json.parts[].prompt_text,
-- which the RPC never selected. Reported by Jill Schmidlkofer 2026-08-05:
-- she could not write marks without seeing the question that was actually
-- asked.
--
-- Fix: add a 'parts' array to the RPC payload, containing only part_key and
-- prompt_text per part. Deliberately excludes points_possible (rule 1 of
-- GOLD_SET_REVIEWER_INSTRUCTIONS.md: reviewers mark present/absent, never
-- points) and is_drawn (irrelevant to marking, and drawn-response parts have
-- no text answer to verify here). 'stem' is left in place for callers that
-- still read it; the frontend switches to rendering 'parts'.

begin;

create or replace function public.gold_set_verification_next()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if not app.gold_set_reader_is_eligible(v_user_id) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

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
  where a.reviewer_id = v_user_id
    and a.status = 'pending'
  order by a.seq
  limit 1;

  -- Null means the queue is drained, not an error.
  return v_result;
end;
$$;

revoke all on function public.gold_set_verification_next() from public, anon;
grant execute on function public.gold_set_verification_next() to authenticated;

commit;
