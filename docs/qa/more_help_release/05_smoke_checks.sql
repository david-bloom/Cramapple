-- READ-ONLY checks after any release step (run on the environment you just changed).
select subject_key, allowed_units, enabled_at from app.more_help_subject_policy order by subject_key;
select md5(pg_get_functiondef('public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)'::regprocedure)) as fn_md5,
  has_function_privilege('authenticated','public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)','EXECUTE') as authenticated_exec,
  has_function_privilege('anon','public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)','EXECUTE') as anon_exec,
  has_function_privilege('service_role','public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)','EXECUTE') as service_exec,
  has_table_privilege('authenticated','app.more_help_subject_policy','SELECT') as policy_client_readable;
-- Expected after step 1: fn_md5 582930f351d7fbd7b9ad01a2bc8adccb; authenticated/anon/policy false; service true.
-- Rows in the last 24h that were refused or delivered (counts only, no student content):
select request_state, count(*) from app.question_help_receipts where created_at > now() - interval '24 hours' group by 1 order by 1;
