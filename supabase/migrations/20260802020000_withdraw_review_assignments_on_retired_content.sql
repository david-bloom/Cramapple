-- Withdraw open review assignments whose content has been retired.
--
-- Context: retiring a content item does not touch its review assignments, and
-- `review-queue` filters only on assignment status (`pending` / `in_progress`),
-- never on `content_items.status`. Retired content therefore stays in reviewers'
-- queues indefinitely. Found 2026-08-01 after the AP Statistics FRQ remediation
-- retired 90 items: 4 of them were still pending in Jill Schmidlkofer's queue,
-- and 3 pre-existing AP Biology cases were sitting in Adil Abbasi's.
--
-- Why a new status rather than 'skipped': 'skipped' is a reviewer-initiated
-- action in this system. Reusing it here would record, against a named reviewer,
-- that they skipped work they were never shown — corrupting their review record.
-- 'withdrawn' says what actually happened: the content was pulled, not the
-- reviewer's choice. Assignments are preserved rather than deleted so the audit
-- trail of what was assigned survives.
--
-- This is the data cleanup only. The recurrence fix — excluding retired content
-- at the queue boundary — is a change to supabase/functions/review-queue and is
-- NOT included here.

alter table app.content_review_assignments
  drop constraint cra_status_check;

alter table app.content_review_assignments
  add constraint cra_status_check
  check (status = any (array['pending', 'in_progress', 'submitted', 'skipped', 'withdrawn']));

-- The base table links to content through the *version*, not the item.
update app.content_review_assignments a
set status = 'withdrawn'
from app.content_item_versions civ
join app.content_items ci on ci.id = civ.content_item_id
where civ.id = a.content_item_version_id
  and a.status in ('pending', 'in_progress')
  and ci.status = 'retired';
