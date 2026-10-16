-- Recovery for model_run_id serving-units-mcp-2026-09-25-20261016122734: restores the 10 held labels, removes the 10 provisional ones.
-- Aborts unless exactly 10 rows exist for the run and none has been superseded or human-validated since.
begin;
do $g$ declare v_n int; v_bad int; begin
  select count(*), count(*) filter (where superseded_by is not null or validated_by is not null or label_status<>'provisional_model')
    into v_n, v_bad from app.content_taxonomy_labels where model_run_id='serving-units-mcp-2026-09-25-20261016122734' and content_item_id in ('f795ad55-b692-4cbc-b411-265a1ba48e87','617ef4a6-c0d1-45a6-ba66-0dbe08193faa','85bd28ea-8781-4da1-b454-c431e9815e10','18e6f11e-30eb-4a83-ae6e-d685b1a2483a','5d81791d-bc12-41ef-9c61-8beb8c7706e0','b1a4c94d-646f-4ed3-bd8b-15fdceb21b1c','8bf1125a-f389-4f80-8b86-f245822aa17f','6e169389-a30a-4cd4-92f4-d947387103be','678c4049-218c-42b7-8b14-3ca850779da0','9bc8d593-3dfd-4bef-adac-3c22c208c531');
  if v_n <> 10 or v_bad <> 0 then raise exception 'Recovery refused: rows=%, changed=%', v_n, v_bad; end if;
end $g$;
update app.content_taxonomy_labels old set superseded_by = null
 where old.superseded_by in (select content_taxonomy_label_id from app.content_taxonomy_labels where model_run_id='serving-units-mcp-2026-09-25-20261016122734');
delete from app.content_taxonomy_labels where model_run_id='serving-units-mcp-2026-09-25-20261016122734';
commit;
