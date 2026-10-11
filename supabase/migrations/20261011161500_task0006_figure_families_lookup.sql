-- TASK-0006 Lane A: make a renderer family data, not a schema decision.
--
-- `app.figures.family` was constrained by a hard-coded CHECK over the six
-- families the AP Chemistry pilot happened to need. Nothing recorded why: the
-- constraint carries no comment, and neither the pilot results, the display
-- design, the Figure Production Protocol nor the architecture doc mentions it.
-- It was written alongside `status in (...)` and the jsonb type checks as house
-- style for an enumerable text column, which closed a list that was always
-- going to grow.
--
-- The effect was that every new renderer family needed a migration. The next
-- Lane A batch alone needs seven (AP Statistics' bars, pie, dotplot,
-- stem-and-leaf and boxplot; a generic xy series; stacked kinematic panels), so
-- the constraint would have turned a content load into a Hard Gate schema
-- deploy, repeatedly, forever.
--
-- What the CHECK was really protecting is worth keeping. `family` is a dispatch
-- key, not a value: the renderer looks it up directly, so a figure whose family
-- nobody implements does not draw a slightly wrong chart, it draws nothing. A
-- published row that passes RLS and renders nothing is precisely the silent
-- absence failure this project keeps meeting. So the enforcement stays and only
-- its shape changes: a lookup table plus a foreign key, where adding a family is
-- a one-row insert and an unknown family still fails loudly at insert time
-- rather than quietly in a student's reference pane.
--
-- What neither form can promise is that a family is actually *renderable*. The
-- renderer lives in the app's TypeScript and in scripts/lane-a-pilot/render.py;
-- the enforcement lives here. Seeding a family whose renderer does not exist
-- still fails at render time. That is why `renderer_note` below records where
-- each family is implemented, and why a figure's `alt` is mandatory at >= 80
-- characters: the prose description is the fallback when the drawing cannot
-- arrive.
--
-- Scope: one table, its seed of the six existing families, and swapping the
-- CHECK for a foreign key. No figure row, policy, grant, view or function
-- changes. Idempotent: safe to re-apply.

begin;

-- ---------------------------------------------------------------------------
-- 1. app.figure_families — the renderer families a figure may declare
-- ---------------------------------------------------------------------------

create table if not exists app.figure_families (
  family_key text primary key,
  title text not null,
  summary text not null,
  renderer_note text,
  created_at timestamptz not null default now(),

  constraint figure_families_key_check check (family_key ~ '^[a-z][a-z0-9_]{2,47}$')
);

comment on table app.figure_families is
  'The renderer families an app.figures row may declare, as data rather than as a CHECK constraint '
  '(TASK-0006, 2026-10-11). Adding a family is an insert, not a migration. The foreign key keeps the '
  'guarantee the old CHECK gave: an unknown family fails at insert time, not silently at render time. '
  'It cannot promise the family is implemented -- see renderer_note.';
comment on column app.figure_families.family_key is
  'The value app.figures.family carries, and the key the client and the pilot renderer dispatch on. '
  'Snake case, because it is an identifier in two codebases, not prose.';
comment on column app.figure_families.renderer_note is
  'Where this family is implemented, so a seeded family with no renderer is findable. Enforcement of '
  'the name lives in the database; the drawing does not.';

-- ---------------------------------------------------------------------------
-- 2. Seed the six families the AP Chemistry pilot established
-- ---------------------------------------------------------------------------

insert into app.figure_families (family_key, title, summary, renderer_note) values
  ('mb_distribution', 'Maxwell-Boltzmann distribution',
   'Particle-energy distribution curves, optionally at more than one temperature, with an activation-energy marker and the area beyond it.',
   'scripts/lane-a-pilot/render.py; the app''s figure renderer'),
  ('energy_profile', 'Reaction energy profile',
   'Energy against reaction coordinate: reactants, transition states, intermediates, products, per-step activation energies and the overall change. Single-step and multistep.',
   'scripts/lane-a-pilot/render.py; the app''s figure renderer'),
  ('stick_spectrum', 'Stick spectrum',
   'Discrete peaks at positions on a continuous axis with heights carrying a second quantity. Mass spectra and photoelectron spectra.',
   'scripts/lane-a-pilot/render.py; the app''s figure renderer'),
  ('pe_vs_distance', 'Potential energy vs. internuclear distance',
   'A well curve per bond order, with the equilibrium bond length at the minimum and the well depth as the bond energy.',
   'scripts/lane-a-pilot/render.py; the app''s figure renderer'),
  ('approach_equilibrium', 'Approach to equilibrium',
   'Concentration-or-pressure against time, or forward and reverse rate against time, levelling off into a constant region.',
   'scripts/lane-a-pilot/render.py; the app''s figure renderer'),
  ('titration_curve', 'Titration curve',
   'pH against volume of titrant, with the equivalence point and, for a weak acid, the half-equivalence point where pH equals pKa.',
   'scripts/lane-a-pilot/render.py; the app''s figure renderer')
on conflict (family_key) do nothing;

-- ---------------------------------------------------------------------------
-- 3. Swap the CHECK for a foreign key
-- ---------------------------------------------------------------------------

-- Guard: every family already on a figure must exist in the lookup, or the
-- foreign key would fail and take the whole migration with it. Raise with the
-- offending values rather than leaving a constraint error to be deciphered.
do $$
declare
  v_missing text;
begin
  select string_agg(distinct f.family, ', ')
    into v_missing
  from app.figures f
  left join app.figure_families ff on ff.family_key = f.family
  where ff.family_key is null;

  if v_missing is not null then
    raise exception 'figure families not seeded, refusing to add the foreign key: %', v_missing;
  end if;
end $$;

alter table app.figures drop constraint if exists figures_family_check;

do $$
begin
  if not exists (
    select 1 from pg_constraint c
    join pg_class t on t.oid = c.conrelid
    join pg_namespace n on n.oid = t.relnamespace
    where n.nspname = 'app' and t.relname = 'figures'
      and c.conname = 'figures_family_fkey'
  ) then
    alter table app.figures
      add constraint figures_family_fkey foreign key (family)
      references app.figure_families (family_key)
      on update cascade on delete restrict;
  end if;
end $$;

-- A family in use cannot be deleted (on delete restrict), so the lookup cannot
-- be emptied out from under published figures. Renaming one propagates
-- (on update cascade), which is the only safe way to rename a dispatch key that
-- figure rows already carry -- the renderers still have to be renamed to match.

-- ---------------------------------------------------------------------------
-- 4. Policies and grants — locked down, like app.subject_reference_aliases
-- ---------------------------------------------------------------------------

-- Nothing student-facing reads this table: the figure views already expose
-- `family` as text, so the client never joins to it. Foreign-key checks are run
-- by the system and are not subject to RLS, so service_role can still insert
-- figures without any select grant here.
alter table app.figure_families enable row level security;
alter table app.figure_families force row level security;
revoke all on app.figure_families from public, anon, authenticated;
grant select, insert, update, delete on app.figure_families to service_role;

commit;
