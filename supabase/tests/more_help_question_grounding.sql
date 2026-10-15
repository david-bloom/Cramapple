-- Run AFTER staging the migration in a rollback transaction, under the owned
-- synthetic QA session's auth claim. Caller sets test.help_session_id/ordinal.
-- No fixtures, attempts, content, receipts or images are written by this check.
do $test$
declare
  payload jsonb;
  version_id uuid;
  authored jsonb;
  part jsonb;
  i integer := 0;
  expected_prompt text;
begin
  payload := public.get_question_experience(
    current_setting('test.help_session_id')::uuid,
    current_setting('test.help_ordinal')::integer);
  version_id := (payload#>>'{item,contentItemVersionId}')::uuid;
  select case when v.prompt_json ? 'parts' and v.prompt_json->'parts' <> 'null'::jsonb
    then v.prompt_json->'parts' when v.item_package_payload ? 'parts'
    then v.item_package_payload->'parts' else '[]'::jsonb end
  into authored from app.content_item_versions v where v.id=version_id;
  if payload#>>'{item,questionPartsComplete}' <> 'true' then
    raise exception 'QA fixture has incomplete authored instructions';
  end if;
  if jsonb_array_length(payload#>'{item,questionParts}') <> jsonb_array_length(authored) then
    raise exception 'Question RPC omitted authored instructions';
  end if;
  for part in select value from jsonb_array_elements(authored) loop
    expected_prompt := case when jsonb_typeof(part->'prompt')='string'
      and nullif(btrim(part->>'prompt'),'') is not null then part->>'prompt'
      else part->>'prompt_text' end;
    if payload#>>array['item','questionParts',i::text,'prompt'] is distinct from expected_prompt then
      raise exception 'Question RPC altered authored instruction at index %',i;
    end if;
    if (payload#>array['item','questionParts',i::text]) - 'key' - 'prompt' <> '{}'::jsonb then
      raise exception 'Question RPC copied unapproved authored fields';
    end if;
    i := i+1;
  end loop;
  if payload#>'{item,questionVisual}' <> 'null'::jsonb and
    (payload#>'{item,questionVisual}') - 'alt' - 'description' - 'completeReviewedDescription' <> '{}'::jsonb then
    raise exception 'Visual grounding includes unapproved metadata';
  end if;
  if jsonb_typeof(payload->'figures') <> 'array' then
    raise exception 'Scoped figure array missing';
  end if;
end;
$test$;
