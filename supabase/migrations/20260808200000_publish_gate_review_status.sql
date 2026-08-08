-- P0-B fix (docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md §7.2):
-- status='published' was not gated on review_status at all. This trigger
-- implements the allowlist the protocol specifies: status may only be set to
-- 'published' when review_status is a terminal-approved value. Allowlist, not
-- denylist, so a future new review_status value fails closed by default
-- instead of silently sailing through.
--
-- Confirmed against a live count on Production (2026-08-08): 130 currently-
-- published rows have a non-terminal-approved review_status (8 excluded, 78
-- modification_reserved, 17 ap_reader_pending, 6 difficulty_discussion, 10
-- tutor_review_pending, 11 null). This trigger does not retroactively touch
-- existing rows -- it only blocks new INSERT/UPDATE statements from creating
-- or perpetuating that state. The existing 130 remain a separate, tracked
-- backfill/adjudication decision (protocol Phase 7(a)), not something this
-- migration silently fixes.
--
-- Known gap this trigger does NOT paper over: there is currently no code path
-- in supabase/functions/review-decision/index.ts that ever advances an MCQ
-- item's review_status past 'answer_tutor_review_pending' once the
-- tutor_answer fan-out (4 choices x 2 tutors) is submitted -- so no MCQ has a
-- code-driven terminal-approved review_status today. Until that aggregation
-- is implemented, any future attempt to publish a properly-reviewed MCQ via
-- this gate must explicitly set review_status='question_review_approved' as
-- part of the same operation. Flagged, not silently worked around.

create or replace function app.enforce_publish_gate()
returns trigger
language plpgsql
as $$
begin
  if new.status = 'published'
     and (new.review_status is null or new.review_status not in ('question_review_approved'))
  then
    raise exception
      'publish_gate: status=published requires review_status in the approved allowlist (question_review_approved); got %',
      coalesce(new.review_status, 'NULL')
      using errcode = 'P0001';
  end if;
  return new;
end;
$$;

drop trigger if exists content_item_versions_publish_gate on app.content_item_versions;

create trigger content_item_versions_publish_gate
  before insert or update of status, review_status on app.content_item_versions
  for each row
  execute function app.enforce_publish_gate();
