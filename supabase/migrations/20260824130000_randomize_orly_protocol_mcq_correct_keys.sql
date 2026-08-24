-- Fix: the 8 items published in
-- 20260824120000_orly_protocol_calc_unit1_unit2_items.sql all had their
-- correct answer at choice_key 'A' -- a predictable, badly-designed pattern
-- (David caught it). This randomly reassigns each item's four choices to
-- A/B/C/D (preserving choice text/rationale/correctness, just relabeling
-- which letter each sits at), then rebuilds prompt_json's lettered prompt
-- text, mcq_choices array, canonical_answers, and the publish-gate
-- deterministic_checks.correct_key / required_evidence[0] to match.
--
-- Two-phase rename (via a 'tmp_' prefix) avoids colliding with the
-- (content_item_version_id, choice_key) unique constraint mid-shuffle.

do $body$
declare
  v_content_key text;
  v_item uuid;
  v_version uuid;
  v_keys text[] := array['A','B','C','D'];
  v_perm text[];
  i int;
  v_new_correct text;
  v_choices_json jsonb;
  v_prompt_lines text;
  v_stem text;
begin
  foreach v_content_key in array array[
    'apcalcab-mcq-060','apcalcab-mcq-070','apcalcab-mcq-080','apcalcab-mcq-090',
    'apcalcbc-mcq-060','apcalcbc-mcq-070','apcalcbc-mcq-080','apcalcbc-mcq-090'
  ] loop
    select ci.id, civ.id into v_item, v_version
    from app.content_items ci
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ci.content_key = v_content_key;

    continue when v_version is null; -- skip if this item doesn't exist in this environment

    select array_agg(k order by random()) into v_perm from unnest(v_keys) k;

    for i in 1..4 loop
      update app.mcq_choices
        set choice_key = 'tmp_' || v_perm[i]
        where content_item_version_id = v_version and choice_key = v_keys[i];
    end loop;

    update app.mcq_choices
      set choice_key = substring(choice_key from 5)
      where content_item_version_id = v_version and choice_key like 'tmp_%';

    select string_agg(choice_key || '. ' || choice_text, E'\n' order by choice_key)
      into v_prompt_lines
      from app.mcq_choices where content_item_version_id = v_version;

    select choice_key into v_new_correct
      from app.mcq_choices where content_item_version_id = v_version and is_correct;

    select jsonb_agg(jsonb_build_object(
        'choice_key', choice_key, 'choice_text', choice_text,
        'is_correct', is_correct, 'rationale', rationale
      ) order by choice_key)
      into v_choices_json
      from app.mcq_choices where content_item_version_id = v_version;

    select stem into v_stem from app.content_item_versions where id = v_version;

    update app.content_item_versions civ
    set canonical_answer_1 = v_new_correct,
        prompt_json =
          jsonb_set(
            jsonb_set(
              jsonb_set(
                jsonb_set(civ.prompt_json,
                  '{canonical_answers}', to_jsonb(array[v_new_correct])
                ),
                '{mcq_choices}', v_choices_json
              ),
              '{parts,0,prompt}', to_jsonb(v_stem || E'\n\n' || v_prompt_lines)
            ),
            '{parts,0,criteria,0,deterministic_checks,0,parameters,correct_key}', to_jsonb(v_new_correct)
          )
    where civ.id = v_version;

    update app.content_item_versions civ
    set prompt_json = jsonb_set(civ.prompt_json, '{parts,0,criteria,0,required_evidence,0}', to_jsonb(v_new_correct))
    where civ.id = v_version;
  end loop;
end
$body$;
