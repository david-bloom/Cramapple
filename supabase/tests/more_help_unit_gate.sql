-- Unit-gate regression for app.more_help_subject_policy (owner rule 2026-10-15:
-- one subject at a time, units 1-3 only). Run as SQL admin on Development.
-- Replace placeholders with a synthetic user's Statistics session/version
-- (version must have a primary topic cell) and its sessions in other subjects.
-- Everything is forced to roll back via the final RAISE; no model calls.
-- Expected: units 1 and 3 => reserved; 4, 5 and no primary cell => subject_not_supported;
-- ap-calculus-ab => reserved; biology/precalc/all physics => subject_not_supported.
-- Verified 2026-10-15 on Development (see QA_MORE_HELP_STATISTICS_U13 record).
do $t$
declare u uuid:='__QA_USER__'; res jsonb:='[]'; r jsonb; rec record; tc record;
  vid uuid:='__STATS_VERSION__'; sess uuid:='__STATS_SESSION__'; tsv uuid; unit int;
begin
 select taxonomy_source_version into tsv from app.content_item_cells
  where content_item_version_id=vid and is_primary and superseded_by is null;
 foreach unit in array array[1,4,5,3] loop
   select topic_code,skill_code into tc from app.taxonomy_cells
    where taxonomy_source_version=tsv and topic_code like unit||'.%' order by topic_code limit 1;
   update app.content_item_cells set topic_code=tc.topic_code, skill_code=tc.skill_code
    where content_item_version_id=vid and is_primary and superseded_by is null;
   r:=public.reserve_question_help_delivery(u,gen_random_uuid(),sess,vid,repeat('a',64));
   res:=res||jsonb_build_object('case','stats_topic_'||tc.topic_code,'out',coalesce(r->>'error',r->>'state'));
 end loop;
 update app.content_item_cells set is_primary=false where content_item_version_id=vid;
 r:=public.reserve_question_help_delivery(u,gen_random_uuid(),sess,vid,repeat('a',64));
 res:=res||jsonb_build_object('case','stats_no_primary_cell','out',coalesce(r->>'error',r->>'state'));
 for rec in select s.subject_key sk, ls.id sid, lsi.content_item_version_id v
   from app.learning_sessions ls join app.learning_session_items lsi on lsi.learning_session_id=ls.id
   join app.exam_pack_versions epv on epv.id=ls.exam_pack_version_id
   join app.exam_packs ep on ep.id=epv.exam_pack_id join app.subjects s on s.id=ep.subject_id
   where ls.user_id=u and ls.status='active'
     and s.subject_key in ('ap-calculus-ab','biology','ap-precalculus','ap-physics-1','ap-physics-2','ap-physics-c-mechanics','ap-physics-c-em')
   order by s.subject_key loop
  r:=public.reserve_question_help_delivery(u,gen_random_uuid(),rec.sid,rec.v,repeat('b',64));
  res:=res||jsonb_build_object('case',rec.sk,'out',coalesce(r->>'error',r->>'state'));
 end loop;
 raise exception 'RESULTS %', res;
end $t$;
