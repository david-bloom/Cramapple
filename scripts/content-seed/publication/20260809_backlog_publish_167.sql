-- Publish the reviewed_approved backlog, 2026-08-09.
--
-- Context: docs/research/QA_PROTOCOL_SECTION9_POOL1_POOL2_RUN_2026_08_09.md
-- follow-up. Owner flagged the reviewer dashboard showing >200 items in
-- "review approved" -- 228 content_items were sitting at
-- status='reviewed_approved', never published. Root cause: the P0-B publish
-- gate (2026-08-08) correctly requires an explicit review_status before
-- publish, but no code path auto-publishes on approval, so approved content
-- has been accumulating (earliest: 2026-07-27) with nobody running an
-- explicit publish step.
--
-- Of the 228, 167 had review_status='question_review_approved' (the other
-- 61 are a separate, not-yet-addressed track: 55 legacy items with
-- review_status IS NULL that never went through review-decision's workflow,
-- and 6 with status/review_status in contradictory states -- neither
-- touched by this script). All 167 passed structural checks (correct
-- choice/criteria counts, no stem/mcq_choices desync, no competing
-- published version) and, as of this session, a full protocol §9
-- independent re-derivation pass (13 parallel QA agents, every answer
-- key/rubric criterion re-solved from scratch): 162 clean outright, 2
-- confirmed defects and 1 internally-inconsistent stimulus value repaired
-- via 20260809_backlog_defects_repair.sql (new versions, already at
-- reviewed_approved), and 6 items with a non-blocking null
-- canonical_answer_1/2 metadata gap (real answer key is intact via
-- mcq_choices.is_correct / frq_criteria; left as a known follow-up, same
-- precedent as apphy1-mcq-021's earlier-session finding).
--
-- This script publishes the current reviewed_approved+question_review_approved
-- version of all 167 content_items (which, for the 3 repaired above, is
-- their new version, not the original).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-backlog-publish-167-20260809'));

create temporary table to_publish as
select v.id as version_id, v.content_item_id
from app.content_item_versions v
where v.status='reviewed_approved' and v.review_status='question_review_approved';

update app.content_item_versions civ
set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now()
from to_publish p
where civ.id=p.version_id;

update app.content_items ci
set status='published', updated_at=now()
from to_publish p
where ci.id=p.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from to_publish;
  if n<>167 then raise exception 'expected 167 items to publish, got %', n; end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after backlog publish: %', n; end if;

  select count(*) into n from app.content_item_versions v
  join app.content_items ci on ci.id=v.content_item_id
  where v.status='published' and ci.item_type='mcq'
    and array_length(app.mcq_stem_choice_desync(v.id, v.stem),1) > 0;
  if n<>0 then raise exception 'published MCQ with stem/choice desync after backlog publish: %', n; end if;
end $$;

select 'published' metric, count(*)::text value from to_publish;

commit;
