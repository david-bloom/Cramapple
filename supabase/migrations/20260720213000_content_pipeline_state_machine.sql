-- Content pipeline state machine.
--
-- Problem: "pending review" was never a real state. content_items.status /
-- content_item_versions.status only ever held draft|published|retired.
-- Whether something was "assigned" or "reviewed" had to be inferred by
-- separately joining content_review_assignments and content_review_decisions
-- — nothing enforced that publish only happens after a positive review, which
-- is exactly how disapproved-and-never-reviewed content ended up published
-- (see docs/activity_log/ACTIVITY_LOG.md, 2026-07-20 entry).
--
-- This migration makes the real pipeline an explicit, enforced state machine:
--
--   draft -> assigned -> reviewed_approved -> published
--                      -> reviewed_disapproved -> retired
--
-- Transitions:
--   draft -> assigned              : trigger on content_review_assignments insert
--   assigned -> reviewed_(dis)approved : trigger on content_review_decisions insert
--   reviewed_approved -> published : allowed by the publish-guard trigger
--   * -> retired                   : always allowed (safe direction)
--   * -> published (not from reviewed_approved) : BLOCKED, raises an exception
--
-- Backfill policy: already-published/retired rows are left untouched (no
-- retroactive unpublish of live content). Only draft rows are reclassified
-- into the richer sub-states, based on what already exists in
-- content_review_assignments/content_review_decisions.

begin;

-- ── 1. Expand the status enum on both tables ────────────────────────────────

alter table app.content_items drop constraint content_items_status_check;
alter table app.content_items add constraint content_items_status_check
  check (status = any (array[
    'draft', 'assigned', 'reviewed_approved', 'reviewed_disapproved',
    'published', 'retired'
  ]));

alter table app.content_item_versions drop constraint content_item_versions_status_check;
alter table app.content_item_versions add constraint content_item_versions_status_check
  check (status = any (array[
    'draft', 'assigned', 'reviewed_approved', 'reviewed_disapproved',
    'published', 'retired'
  ]));

-- ── 2. Backfill existing draft rows into the richer sub-states ─────────────
-- Priority when both exist: an active pending assignment (re-review in
-- progress) wins over a prior decision, since it's the more current truth.

with latest_version as (
  select distinct on (ci.id) ci.id as content_item_id, civ.id as civ_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  order by ci.id, civ.created_at desc
),
decision_summary as (
  select content_item_version_id,
    bool_or(tutor_decision in ('approve', 'approve_with_edits')
            or tutor_score in (1, 2)) as has_approve,
    bool_or(tutor_decision = 'disapprove' or tutor_score = 3) as has_disapprove
  from app.content_review_decisions
  where review_stage in ('tutor_question', 'reader_question')
  group by 1
),
classified as (
  select
    lv.content_item_id,
    lv.civ_id,
    case
      when exists (
        select 1 from app.content_review_assignments cra
        where cra.content_item_version_id = lv.civ_id and cra.status = 'pending'
      ) then 'assigned'
      when ds.has_disapprove then 'reviewed_disapproved'
      when ds.has_approve then 'reviewed_approved'
      else 'draft'
    end as new_status
  from latest_version lv
  left join decision_summary ds on ds.content_item_version_id = lv.civ_id
)
update app.content_item_versions civ
set status = c.new_status
from classified c
where civ.id = c.civ_id
  and civ.status = 'draft'
  and c.new_status <> 'draft';

with latest_version as (
  select distinct on (ci.id) ci.id as content_item_id, civ.id as civ_id
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id
  order by ci.id, civ.created_at desc
)
update app.content_items ci
set status = civ.status
from latest_version lv
join app.content_item_versions civ on civ.id = lv.civ_id
where ci.id = lv.content_item_id
  and ci.status = 'draft'
  and civ.status <> 'draft';

-- ── 3. Trigger: draft -> assigned on new pending assignment ────────────────

create or replace function app.tg_content_pipeline_on_assignment() returns trigger as $$
declare
  v_item_id uuid;
begin
  if new.content_item_version_id is null or new.status <> 'pending' then
    return new;
  end if;

  update app.content_item_versions
  set status = 'assigned'
  where id = new.content_item_version_id
    and status = 'draft';

  select content_item_id into v_item_id
  from app.content_item_versions
  where id = new.content_item_version_id;

  if v_item_id is not null then
    update app.content_items
    set status = 'assigned'
    where id = v_item_id
      and status = 'draft';
  end if;

  return new;
end;
$$ language plpgsql security definer set search_path = app, pg_temp;

drop trigger if exists content_pipeline_on_assignment on app.content_review_assignments;
create trigger content_pipeline_on_assignment
  after insert on app.content_review_assignments
  for each row execute function app.tg_content_pipeline_on_assignment();

-- ── 4. Trigger: assigned -> reviewed_approved / reviewed_disapproved ───────
-- Handles both the tutor_decision field (how real tutor reviews have
-- actually been recorded to date) and tutor_score (the 1/2/3 aggregate model
-- the review-decision edge function's prototype flow writes), so this stays
-- correct regardless of which path a given submission came through. Only
-- tutor_question/reader_question decisions drive item-level status — answer-
-- key stages (tutor_answer, tutor_frq_canonical) are a separate concern.
-- Never touches an item that's already published/retired.

create or replace function app.tg_content_pipeline_on_decision() returns trigger as $$
declare
  v_item_id uuid;
  v_outcome text;
begin
  if new.content_item_version_id is null then
    return new;
  end if;
  if new.review_stage not in ('tutor_question', 'reader_question') then
    return new;
  end if;

  if new.tutor_decision = 'disapprove' or new.tutor_score = 3 then
    v_outcome := 'reviewed_disapproved';
  elsif new.tutor_decision in ('approve', 'approve_with_edits') or new.tutor_score in (1, 2) then
    v_outcome := 'reviewed_approved';
  else
    return new;
  end if;

  update app.content_item_versions
  set status = v_outcome
  where id = new.content_item_version_id
    and status in ('draft', 'assigned');

  select content_item_id into v_item_id
  from app.content_item_versions
  where id = new.content_item_version_id;

  if v_item_id is not null then
    update app.content_items
    set status = v_outcome
    where id = v_item_id
      and status in ('draft', 'assigned');
  end if;

  return new;
end;
$$ language plpgsql security definer set search_path = app, pg_temp;

drop trigger if exists content_pipeline_on_decision on app.content_review_decisions;
create trigger content_pipeline_on_decision
  after insert on app.content_review_decisions
  for each row execute function app.tg_content_pipeline_on_decision();

-- ── 5. Guard: publish only allowed from reviewed_approved ──────────────────
-- Retiring is always allowed (safe direction) from any state. Any other
-- transition INTO 'published' that isn't from 'reviewed_approved' is
-- rejected outright — this is the hard block on the exact failure mode
-- found 2026-07-20 (disapproved/never-reviewed content published anyway).
-- Does not touch rows that are already published (re-saving is a no-op here).

create or replace function app.tg_content_pipeline_guard_publish() returns trigger as $$
begin
  if new.status = 'published' and old.status is distinct from 'published' then
    if old.status is distinct from 'reviewed_approved' then
      raise exception
        'content_pipeline_guard: cannot publish from status % (must be reviewed_approved)',
        old.status;
    end if;
  end if;
  return new;
end;
$$ language plpgsql security definer set search_path = app, pg_temp;

drop trigger if exists content_pipeline_guard_publish on app.content_items;
create trigger content_pipeline_guard_publish
  before update on app.content_items
  for each row execute function app.tg_content_pipeline_guard_publish();

drop trigger if exists content_pipeline_guard_publish on app.content_item_versions;
create trigger content_pipeline_guard_publish
  before update on app.content_item_versions
  for each row execute function app.tg_content_pipeline_guard_publish();

commit;
