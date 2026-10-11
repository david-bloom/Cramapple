-- TASK-0006 Lane A: figures as first-class rows.
--
-- A figure is NOT a property of one reference entry. The Product Owner's
-- 2026-10-10 direction was that the same figure may be shown beside a different
-- entry or a different question, so a `visual_spec` column on
-- app.unit_reference_entries would re-create the single-owner problem that
-- blocks exactly that. Hence a figures table plus a uses join.
--
-- A Lane A figure carries no binary: `params` is a small spec that the client
-- renders deterministically, so there is no bucket, no signed URL, and nothing
-- to re-verify when a renderer changes. app.unit_reference_entries.visual_asset_ref
-- stays reserved for Lane B, where a stored asset is the right shape.
--
-- Scope: tables, policies, grants, student-readable views and seed data for the
-- nine published AP Chemistry Lane A figures. The serving RPC is extended in a
-- separate migration so this one can be reviewed on its own.

begin;

-- ---------------------------------------------------------------------------
-- 1. app.figures
-- ---------------------------------------------------------------------------

create table app.figures (
  figure_id text primary key,
  subject_key text not null,
  family text not null,
  title text not null,
  short_title text,
  subtitle text not null default '',
  caption text,
  alt text not null,
  x_label text not null,
  y_label text not null,
  note text,
  synthetic boolean not null default true,
  values_note text,
  labels jsonb not null default '[]'::jsonb,
  params jsonb not null,
  y_tick_fmt text,
  x_tick_fmt text,
  status text not null default 'draft',
  source_note text not null default 'cramapple-authored',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint figures_figure_id_check check (figure_id ~ '^[a-z0-9][a-z0-9-]{2,63}$'),
  constraint figures_family_check check (family in (
    'mb_distribution', 'energy_profile', 'stick_spectrum',
    'pe_vs_distance', 'approach_equilibrium', 'titration_curve')),
  constraint figures_status_check check (status in ('draft', 'published', 'retired')),
  constraint figures_labels_check check (jsonb_typeof(labels) = 'array'),
  constraint figures_params_check check (jsonb_typeof(params) = 'object'),
  -- The accessible description is the figure when the picture does not arrive:
  -- it is what Copy notes carries into a document, so it is never a stub.
  constraint figures_alt_check check (length(btrim(alt)) >= 80),
  constraint figures_title_check check (length(btrim(title)) >= 1),
  -- A measured figure must say where its numbers come from.
  constraint figures_values_note_check check (synthetic or values_note is not null)
);

comment on table app.figures is
  'Lane A figures (TASK-0006): a deterministic chart spec, not a stored image. One row per figure, '
  'addressed by figure_id, so the same figure can be shown beside more than one reference entry or '
  'question via app.figure_uses. The client renders `params`; no binary is stored and no model runs '
  'at render time.';
comment on column app.figures.params is
  'The chart spec its family renders: series, ranges, markers. Small structured data, not a drawing.';
comment on column app.figures.labels is
  'The labelled parts THIS figure draws, as a string array. Named on the figure rather than inherited '
  'from whichever entry links to it, so a second consumer gets them without re-deriving.';
comment on column app.figures.alt is
  'Accessible description. Always exported as text alongside the picture, because a paste target may '
  'drop the image; at least 80 characters by constraint.';
comment on column app.figures.synthetic is
  'True when the numbers are pedagogically illustrative rather than measured. Rendered on the figure '
  'as ILLUSTRATIVE / FROM DATA, so a student is never misled about which they are reading.';
comment on column app.figures.values_note is
  'For a measured figure, what is and is not sourced. Required when synthetic is false.';

create index figures_subject_status_idx on app.figures (subject_key, status);

-- ---------------------------------------------------------------------------
-- 2. app.figure_uses — where a figure is shown. A LIST, not an owner.
-- ---------------------------------------------------------------------------

create table app.figure_uses (
  figure_id text not null references app.figures (figure_id) on delete cascade,
  reference_entry_id uuid references app.unit_reference_entries (reference_entry_id) on delete cascade,
  question_version_id uuid,
  role text not null default 'primary',
  created_at timestamptz not null default now(),

  -- Polymorphic by discriminated columns rather than a bare target id, so the
  -- reference-entry case keeps real referential integrity.
  constraint figure_uses_one_target check (
    num_nonnulls(reference_entry_id, question_version_id) = 1)
);

comment on table app.figure_uses is
  'Where each figure is shown. Deliberately many-to-many: one figure may serve several reference '
  'entries or questions, and one entry may need more than one figure — the approach-to-equilibrium '
  'entry needs two, because one chart cannot be both concentration-vs-time and rate-vs-time.';
comment on column app.figure_uses.question_version_id is
  'Reserved for figures attached to a question. No FK yet: the question target is not settled, and a '
  'wrong FK is harder to remove than a missing one.';

create unique index figure_uses_entry_unique
  on app.figure_uses (figure_id, reference_entry_id)
  where reference_entry_id is not null;
create unique index figure_uses_question_unique
  on app.figure_uses (figure_id, question_version_id)
  where question_version_id is not null;
create index figure_uses_entry_idx on app.figure_uses (reference_entry_id)
  where reference_entry_id is not null;

-- ---------------------------------------------------------------------------
-- 3. Policies and grants, matching app.unit_reference_entries
-- ---------------------------------------------------------------------------

alter table app.figures enable row level security;
alter table app.figures force row level security;
revoke all on app.figures from public, anon, authenticated;
grant select, insert, update, delete on app.figures to service_role;
grant select on app.figures to authenticated;

create policy figures_select_published
on app.figures
for select
to authenticated
using (
  status = 'published'
  and exists (
    select 1
    from app.subjects s
    where app.normalize_student_subject_key(s.subject_key) = figures.subject_key
  )
);

alter table app.figure_uses enable row level security;
alter table app.figure_uses force row level security;
revoke all on app.figure_uses from public, anon, authenticated;
grant select, insert, update, delete on app.figure_uses to service_role;
grant select on app.figure_uses to authenticated;

-- A use is visible only when its figure is.
create policy figure_uses_select_published
on app.figure_uses
for select
to authenticated
using (
  exists (select 1 from app.figures f
          where f.figure_id = figure_uses.figure_id and f.status = 'published')
);

-- ---------------------------------------------------------------------------
-- 4. Student-readable views
-- ---------------------------------------------------------------------------

create view public.figures
with (security_invoker = true) as
select
  f.figure_id,
  f.subject_key,
  f.family,
  f.title,
  f.short_title,
  f.subtitle,
  f.caption,
  f.alt,
  f.x_label,
  f.y_label,
  f.note,
  f.synthetic,
  f.values_note,
  f.labels,
  f.params,
  f.y_tick_fmt,
  f.x_tick_fmt
from app.figures f
where f.status = 'published';

create view public.figure_uses
with (security_invoker = true) as
select u.figure_id, u.reference_entry_id, u.question_version_id, u.role
from app.figure_uses u
join app.figures f on f.figure_id = u.figure_id and f.status = 'published';

comment on view public.figures is
  'Published Lane A figures. security_invoker, so the figures RLS policy above decides what a student '
  'sees. Status, source_note and timestamps are withheld: authoring state is not student content.';

revoke all on public.figures from public, anon, authenticated, service_role;
revoke all on public.figure_uses from public, anon, authenticated, service_role;
grant select on public.figures to authenticated, service_role;
grant select on public.figure_uses to authenticated, service_role;

commit;
