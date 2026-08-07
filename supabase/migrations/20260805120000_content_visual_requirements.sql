-- Reviewer-captured prompt-visual requirement.
-- Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
--
-- Closes a gap that app.content_asset_metadata (20260805100000) does not:
-- that table gates items which HAVE an image but lack approved accessibility
-- text. It cannot see an item that NEEDS a visual and has no
-- stimulus_image_path at all -- such an item is indistinguishable from a
-- legitimately text-only one, so it is served to students with a construct
-- gap. APBIO-FRQ-L-028 is exactly that case.
--
-- The judgment cannot be derived mechanically. A keyword pass over all
-- published stems on 2026-08-05 scored 0 correct out of 44 flags and missed
-- the one true positive: it cannot separate "the student must READ a visual
-- that isn't here" from "the student CONSTRUCTS the visual" or from data that
-- is inherently tabular (a table is not degraded by being stored as text).
-- Reviewers already make this call while reading the item; this records it.
--
-- WHY image_needed IS NOT A BOOLEAN. 39 published items in the corpus -- 32
-- APSTATS-HDG-2026-GRAPH-*, 5 APBIO-HDG-2026-GRAPH-*, and 2 AP Physics C
-- "translate ... into a labeled diagram" items -- ask the student to CONSTRUCT
-- the visual. Their stems read "Submit one photograph showing your constructed
-- graph". Under a yes/no control a reviewer would reasonably answer "yes",
-- and generating a prompt image for those items would hand the student the
-- answer. Splitting "no" into its two reasons makes that mistake unavailable
-- while keeping the serving gate a simple image_needed = 'yes' test.

begin;

create table if not exists app.content_visual_requirements (
  content_item_version_id uuid primary key
    references app.content_item_versions(id) on delete cascade,

  -- 'yes'            -> the student must read a visual that is not present as
  --                     a visual; needs one built, and gates serving.
  -- 'no_constructs'  -> the visual IS the student's answer (Program B). Must
  --                     never receive a prompt image.
  -- 'no_not_needed'  -> no visual required; includes inherently tabular data.
  image_needed text not null,

  -- Only meaningful when image_needed = 'yes'. 'missing' is a real state: the
  -- reviewer confirms a visual is required and none exists to review.
  image_approval text,

  decided_by uuid,
  decided_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint cvr_image_needed_check
    check (image_needed = any (array['yes', 'no_constructs', 'no_not_needed'])),

  constraint cvr_image_approval_check
    check (
      image_approval is null
      or image_approval = any (
        array['approved', 'approved_with_edits', 'disapproved', 'missing']
      )
    ),

  -- Enforce the conditional requirement in the database, not only in the UI:
  -- an approval is required exactly when a visual is required, and must be
  -- absent otherwise. A client that skips the second radio cannot persist a
  -- half-answered record.
  constraint cvr_approval_required_iff_needed
    check (
      (image_needed = 'yes' and image_approval is not null)
      or (image_needed <> 'yes' and image_approval is null)
    )
);

comment on table app.content_visual_requirements is
  'Reviewer judgment on whether an item requires a prompt visual, and whether the visual is approved. Current state per content item version; the immutable capture lives on the originating content_review_decisions row.';

comment on column app.content_visual_requirements.image_needed is
  'yes = student must read a visual that is not present. no_constructs = the visual is the student answer (Program B); never give these a prompt image. no_not_needed = none required.';

-- Serving lookups ask "is this version cleared to serve?", which is only ever
-- about the 'yes' rows.
create index if not exists content_visual_requirements_needed_idx
  on app.content_visual_requirements (image_needed, image_approval)
  where image_needed = 'yes';

alter table app.content_visual_requirements enable row level security;
alter table app.content_visual_requirements force row level security;
revoke all on app.content_visual_requirements from public, anon, authenticated;
grant select, insert, update, delete on app.content_visual_requirements to service_role;

create or replace function app.touch_content_visual_requirements()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists content_visual_requirements_touch
  on app.content_visual_requirements;
create trigger content_visual_requirements_touch
  before update on app.content_visual_requirements
  for each row execute function app.touch_content_visual_requirements();

commit;
