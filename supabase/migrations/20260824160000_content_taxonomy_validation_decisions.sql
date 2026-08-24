-- TASK-0028: a real decision-record table backing
-- app.content_taxonomy_labels.validation_decision_id, which has existed
-- since 20260804170000_taxonomy_label_layer.sql as a bare uuid column with
-- no foreign key. docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md
-- §T6 requires every validated label to represent an actual human decision;
-- this table is where that decision now lives instead of being implied by
-- an opaque UUID.

create table if not exists app.content_taxonomy_validation_decisions (
  validation_decision_id uuid primary key default gen_random_uuid(),
  content_taxonomy_label_id uuid not null
    references app.content_taxonomy_labels(content_taxonomy_label_id)
    on delete cascade,
  decided_by uuid not null references app.profiles(user_id),
  decided_at timestamptz not null default now(),
  decision text not null
    check (decision = any (array['confirmed', 'corrected', 'rejected'])),
  decision_source text not null default 'ui_review'
    check (decision_source = any (array['chat_review', 'ui_review', 'automated_spot_check'])),
  reviewed_primary_unit integer,
  reviewed_required_units integer[],
  notes text,
  created_at timestamptz not null default now()
);

create index if not exists content_taxonomy_validation_decisions_label_idx
  on app.content_taxonomy_validation_decisions (content_taxonomy_label_id);

alter table app.content_taxonomy_validation_decisions enable row level security;

drop policy if exists "content_taxonomy_validation_decisions_service_all"
  on app.content_taxonomy_validation_decisions;
create policy "content_taxonomy_validation_decisions_service_all"
on app.content_taxonomy_validation_decisions
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete
  on app.content_taxonomy_validation_decisions to service_role;
grant select on app.content_taxonomy_validation_decisions to content_reviewer;

-- Backfill: the 8 rows validated 2026-08-24 for the Orly-protocol Calc
-- items (see docs/research/orly_source_log/SOURCE_LOG.md) already carry a
-- generated placeholder validation_decision_id. Insert matching decision
-- rows reusing those exact IDs so the FK below validates against real data
-- instead of orphaning them.
insert into app.content_taxonomy_validation_decisions (
  validation_decision_id, content_taxonomy_label_id, decided_by, decided_at,
  decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes
)
select
  ctl.validation_decision_id,
  ctl.content_taxonomy_label_id,
  ctl.validated_by,
  ctl.validated_at,
  'confirmed',
  'chat_review',
  ctl.primary_unit,
  ctl.required_units,
  'Backfilled by TASK-0028. Product Owner reviewed the primary_unit/required_units table for all 8 Orly-protocol Calc items directly in chat and confirmed them explicitly before the original validation write.'
from app.content_taxonomy_labels ctl
where ctl.validation_decision_id is not null
  and not exists (
    select 1 from app.content_taxonomy_validation_decisions d
    where d.validation_decision_id = ctl.validation_decision_id
  );

alter table app.content_taxonomy_labels
  drop constraint if exists content_taxonomy_labels_validation_decision_id_fkey;
alter table app.content_taxonomy_labels
  add constraint content_taxonomy_labels_validation_decision_id_fkey
  foreign key (validation_decision_id)
  references app.content_taxonomy_validation_decisions(validation_decision_id)
  on delete restrict;
