md5(jsonb_build_object('stem',v.stem,'stimulus',v.stimulus,
 'choices',coalesce((select jsonb_agg(jsonb_build_object('key',c.choice_key,'text',c.choice_text) order by c.choice_key) from app.mcq_choices c where c.content_item_version_id=v.id),'[]'::jsonb),
 'parts',coalesce((select jsonb_agg(jsonb_build_object('key',coalesce(p.part->>'part_key',p.part->>'part_id',p.ordinality::text),'text',coalesce(nullif(p.part->>'prompt',''),p.part->>'prompt_text')) order by p.ordinality)
 from jsonb_array_elements(case when jsonb_typeof(v.prompt_json->'parts')='array' then v.prompt_json->'parts' when jsonb_typeof(v.item_package_payload->'parts')='array' then v.item_package_payload->'parts' else '[]'::jsonb end) with ordinality as p(part,ordinality)
 where jsonb_typeof(p.part)='object' and (jsonb_typeof(p.part->'prompt')='string' or jsonb_typeof(p.part->'prompt_text')='string') and nullif(btrim(coalesce(nullif(p.part->>'prompt',''),p.part->>'prompt_text')),'') is not null),'[]'::jsonb),
 'prompt',v.prompt_json,'package',v.item_package_payload,'image_path',v.stimulus_image_path)::text)
