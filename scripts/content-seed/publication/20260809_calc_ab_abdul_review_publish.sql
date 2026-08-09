-- Publishes the 14 AP Calculus AB items Abdul Hanan approved today out of
-- his newly-assigned, §9-verified 23-item draft batch (7 FRQ + 7 MCQ; the
-- remaining 9 items were still mid-review at publish time).
--
-- apchem-frq-l-012 was investigated as a candidate (showed up at
-- content_items.status='reviewed_approved') and excluded: both of its
-- content_item_versions rows are status='retired', so the item-level status
-- is stale/contradictory -- not part of Abdul's batch and not safe to
-- publish. Flagged as another instance of the "contradictory-state" bucket
-- from the 2026-08-09 backlog investigation
-- (docs/research/REVIEWED_APPROVED_BACKLOG_PUBLISH_2026_08_09.md §6).

begin;

with to_publish as (
  select ci.id as content_item_id, v.id as version_id
  from app.content_items ci
  join app.content_item_versions v on v.content_item_id = ci.id
  where ci.content_key in (
    'apcalcab-frq-030','apcalcab-frq-031','apcalcab-frq-032','apcalcab-frq-033',
    'apcalcab-frq-034','apcalcab-frq-035','apcalcab-frq-036',
    'apcalcab-mcq-037','apcalcab-mcq-038','apcalcab-mcq-039','apcalcab-mcq-041',
    'apcalcab-mcq-042','apcalcab-mcq-043','apcalcab-mcq-046'
  )
  and ci.status='reviewed_approved' and v.status='reviewed_approved'
  and v.review_status='question_review_approved'
  and not exists (select 1 from app.content_item_versions other where other.content_item_id=ci.id and other.status='published')
)
update app.content_item_versions v
set status='published', updated_at=now()
from to_publish tp
where v.id = tp.version_id;

with to_publish_items as (
  select ci.id as content_item_id
  from app.content_items ci
  where ci.content_key in (
    'apcalcab-frq-030','apcalcab-frq-031','apcalcab-frq-032','apcalcab-frq-033',
    'apcalcab-frq-034','apcalcab-frq-035','apcalcab-frq-036',
    'apcalcab-mcq-037','apcalcab-mcq-038','apcalcab-mcq-039','apcalcab-mcq-041',
    'apcalcab-mcq-042','apcalcab-mcq-043','apcalcab-mcq-046'
  )
)
update app.content_items ci
set status='published', updated_at=now()
from to_publish_items tpi
where ci.id = tpi.content_item_id;

do $$
declare
  v_count int;
begin
  select count(*) into v_count
  from app.content_items ci
  where ci.content_key in (
    'apcalcab-frq-030','apcalcab-frq-031','apcalcab-frq-032','apcalcab-frq-033',
    'apcalcab-frq-034','apcalcab-frq-035','apcalcab-frq-036',
    'apcalcab-mcq-037','apcalcab-mcq-038','apcalcab-mcq-039','apcalcab-mcq-041',
    'apcalcab-mcq-042','apcalcab-mcq-043','apcalcab-mcq-046'
  ) and ci.status='published';
  if v_count <> 14 then
    raise exception 'expected 14 published, got %', v_count;
  end if;
end $$;

commit;
