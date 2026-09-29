-- Move three published items off AP Calculus AB onto AP Calculus BC.
-- David's decision, 2026-09-29, after the TASK-0050 topic pass found that each
-- assesses a topic the CED marks BC-only, which is why no AB topic fits:
--
--   apcalcab-mcq-045  Euler's method        -> BC topic 7.5
--   apcalcab-mcq-046  Logistic model        -> BC topic 7.9
--   apcalcab-mcq-050  Arc length            -> BC topic 8.13
--
-- Safe to move: zero attempts reference any of them (checked), and content_key
-- is unique per (exam_pack_version_id, content_key), so no collision. BC already
-- has DIFFERENT Euler/logistic/arc-length items (apcalcbc-mcq-038, -012, -039,
-- -013), so this adds coverage rather than duplicating.
--
-- Keys are renamed apcalcab-* -> apcalcbc-*: the prefix encodes the subject, and
-- the fact pack's own guidance is written as "do not author or approve an
-- apcalcab-* item on arc length". Leaving an apcalcab-* key in the BC pack would
-- make a future audit of that exact string misread the situation. Old keys are
-- recorded here and in the task record:
--   apcalcab-mcq-045 -> apcalcbc-mcq-mv045
--   apcalcab-mcq-046 -> apcalcbc-mcq-mv046
--   apcalcab-mcq-050 -> apcalcbc-mcq-mv050

begin;

update app.content_items ci
set exam_pack_version_id = '3778d753-273a-403d-8f02-55dc64ec6a27',
    content_key = 'apcalcbc-mcq-mv' || right(ci.content_key, 3),
    updated_at = now()
where ci.content_key in ('apcalcab-mcq-045','apcalcab-mcq-046','apcalcab-mcq-050')
  and ci.exam_pack_version_id = '826c8cf1-bc1b-4f2a-bd33-61a758e1487d';

-- True CED topics, not the run's forced fits. mcq-045 was held by the pass (no
-- AB topic existed); -046 and -050 were pushed onto 7.1 and 8.3 at 0.40 and 0.35
-- confidence and were deliberately excluded from the AB apply.
-- assignment_status 'authored': these come from the CED's own BC-only tagging,
-- not from a classifier guess.
insert into app.content_item_cells (
  content_item_id, content_item_version_id, taxonomy_source_version,
  topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select civ.content_item_id, civ.id, tsv.taxonomy_source_version,
       v.topic, null, true, 'authored', 'ced_bc_only_reassignment',
       'topics-ap_calculus_ab-20260929100918:bc_reassignment'
from (values
  ('apcalcbc-mcq-mv045','7.5'),
  ('apcalcbc-mcq-mv046','7.9'),
  ('apcalcbc-mcq-mv050','8.13')
) as v(key, topic)
join app.content_items ci on ci.content_key = v.key
join app.content_item_versions civ
  on civ.content_item_id = ci.id and civ.status = 'published'
cross join app.taxonomy_source_versions tsv
where tsv.subject_key = 'ap_calculus_bc'
on conflict do nothing;

commit;
