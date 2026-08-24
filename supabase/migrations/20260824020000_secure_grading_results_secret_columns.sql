-- Security: deny client read of the grading answer-key / model-reasoning columns.
--
-- app.grading_results.shadow_result and .raw_model_response hold the deterministic
-- verdict detail (which embeds the correct answer) and the raw LLM grading response.
-- The curated public.grading_results view (security_invoker=true) is the student read
-- surface and already excludes both columns. But `authenticated` held a TABLE-level
-- SELECT grant on the raw app.grading_results, and the owner-RLS policy
-- (grading_results_owner_select) lets a user read their own rows — so if the `app`
-- schema is REST-exposed, a student could query their own shadow_result / raw model
-- response and read the answer key (Fable re-QA finding 1).
--
-- Fix: drop the table-level grant and re-grant SELECT on every column EXCEPT the two
-- secret ones. The security_invoker view selects only safe columns, so it keeps
-- working as the calling user; service_role is untouched (edge functions still read
-- everything). Column list is computed dynamically so it stays correct as columns
-- are added. Idempotent.

do $$
declare
  v_cols text;
begin
  select string_agg(quote_ident(column_name), ', ' order by ordinal_position)
    into v_cols
  from information_schema.columns
  where table_schema = 'app'
    and table_name = 'grading_results'
    and column_name not in ('shadow_result', 'raw_model_response');

  execute 'revoke select on app.grading_results from authenticated';
  execute 'revoke select on app.grading_results from anon';
  execute 'grant select (' || v_cols || ') on app.grading_results to authenticated';
end $$;
