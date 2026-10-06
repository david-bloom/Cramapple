# TASK-0048 — `/home` Redesign: Stage A (New) + Stage B (Building Evidence)

**Task ID:** TASK-0048
**Title:** Build the New-student and Building-evidence states of the redesigned `/home` against the
Design artifact `https://claude.ai/artifact/HoaRcFFv8GoiV9VeyDcgYh` ("CramApple — Student Hub")
**Owner:** unassigned (backend workstreams: Claude/Codex; frontend: Lovable, "New Cramapple App" `56cae479`)
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Published 2026-10-05 (Stage A/B mount `08a042ca` rode along with the `450e107d` publish under `APPROVAL-0121`). Stage A/B show only for `new` and `building_signal` students; `personalized` students keep `TopicHome`. Signed-in visual QA still owed; findings below remain open
**Priority:** High — closes `O17` (`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`), the largest open gap
in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`
**Created Date:** 2026-09-27
**Branch:** Not yet created — backend workstreams follow repo convention
(`<agent>/task-0048-<slug>`); frontend lands as Lovable commits on `56cae479`
**PR:** None yet

## Origin

David shared a Design-canvas artifact (`https://claude.ai/artifact/HoaRcFFv8GoiV9VeyDcgYh`) with four
artboards — Desktop/Mobile Personalized, Stage A (new recognized student), Stage B (building evidence) —
as the answer to `O17` ("`/home` was never structurally redesigned"). Reviewed for technical viability
2026-09-27 (see `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s design-review entry for the full per-element
audit against the real schema). Verdict: the design is correctly grounded in the canonical system
(`project/ds/cramapple/tokens.json` is a byte-identical copy of `docs/new_design/`'s tokens — verified,
not assumed) and correctly diagnoses the fix ("Home is a page, not a plate" — drop the no-scroll rule,
keep everything else). Stage A and Stage B are buildable now or after small, well-scoped backend work.
The Personalized/Main state depends on things that don't exist yet (see Out of Scope) and is
deliberately excluded from this task.

## Product Goal

Ship real, structurally-rebuilt `/home` states for the two evidence stages Cramapple can honestly
support today: a student with no practice history yet (Stage A), and a student with some but not yet
enough for personalization (Stage B). Both states already have a server-computed selector —
`StudentHomeSnapshot.experienceStage` (`"new" | "building_signal" | "personalized"`,
`home-snapshot.ts`) — this task wires real UI to states the backend already distinguishes, it does not
invent new state logic.

## Non-negotiables carried from the design review

- Every color, spacing, radius, and font value comes from `project/ds/cramapple/tokens.json` /
  `docs/new_design/`. No inventing values, no drifting from the canonical system on this pass.
- No fabricated data, ever — an element with no real data source either doesn't ship this pass or
  renders an honest "not enough evidence yet" state. This is the same rule this repo has applied
  everywhere else (`home-snapshot.ts`'s own comments, `session.setup.tsx`'s fix earlier this session).
- Preserve `SessionFrame`/session-route behavior. This task touches only the `/home` route and its data
  layer, never `/session`, `SessionFrame.tsx`, or the plate/pane system Session already uses correctly.

## Technical Scope

### Workstream 1 — Deploy `get_home_start_queue` (backend, prerequisite, near-zero risk)

`supabase/migrations/20260828120000_home_start_queue_rpc.sql` is fully written, reads from
`app.student_cell_state` (populated with real data since this week's mastery-capture build), and has
never been applied to Dev or Production — confirmed via `pg_proc`, absent from both. This single gap
is why the **current live** Home's "Start here" queue silently renders a hardcoded placeholder today,
and it directly backs Stage B's "Worth revisiting" panel and the curriculum rail's due-signal in Stage
B. Apply to Dev, verify with a real `student_cell_state` row, then Production. No frontend change
required for this step alone — it starts fixing the *current* Home immediately.

### Workstream 2 — Topic-level course position (backend, schema change)

`app.student_course_positions` only carries `unit_id` (confirmed via `information_schema.columns`) —
no topic granularity. Stage A's "Set my position" (unit **and** topic selects) and Stage B's topic
display/confirm-or-change both need this. Add a nullable `topic_code text` column (additive, no
migration risk to existing rows), extend `setCoursePosition`'s input validator and upsert to accept it,
and extend `loadStudentHome`'s `coursePosition` snapshot field to carry it through. Decide and document
whether a topic-level source (`confirmed`/`estimated`) tracks independently from the existing
unit-level `source`, or shares it — recommend independent, since a student can confirm their unit while
leaving topic estimated.

### Workstream 3 — Pulse / Independence aggregation (backend)

Stage B's "Pulse" (minutes/questions this week, "no trend yet" honesty gate) and "Independence" bar
(guided→independent split) need a new aggregation over recent `attempts` (`assistance_state`,
`pre_submit_hint_count`, `created_at`) scoped to the active subject, added as new fields on
`StudentHomeSnapshot`. Reuse `isQualifyingAttempt`/the existing evidence-threshold constants in
`home-snapshot.ts` rather than inventing new thresholds — the design's own copy ("ask again at about
25") should cite the real `RECOMMEND_MIN_ATTEMPTS`-style constants, not a hardcoded number in JSX.

### Workstream 4 — Stage A frontend (Lovable)

Build the New-student layout against `project/Stage-A-New.dc.html` exactly (1440×1180, fluid per the
page-not-plate note — verify against real viewport widths, the artboard is a fixed-size mock).
Position-not-set orientation strip, the "Tell us where your class is" hero with unit+topic selects
(wired to Workstream 2), the empty curriculum grid (`getUnitsForSubject`/taxonomy — already available),
and the generic explainer cards (`fetchTopicGuides` — already available). **Cut from v1, flag instead:**
the "6-question check" diagnostic path — it's a real, unbuilt feature (item selection + a unit-estimate
algorithm), not a UI wiring task. Ship the "I know my position" path only; the diagnostic becomes its
own follow-up task if David wants it.

### Workstream 5 — Stage B frontend (Lovable)

Build the Building-evidence layout against `project/Stage-B-Building.dc.html`. Orientation strip with
estimated-position confirm/change (Workstream 2), the honest-NBA hero, the provisional curriculum map,
"Worth revisiting" (Workstream 1), "Pulse"/"Independence" (Workstream 3), deep-dive shelf (existing
topic-guides data). **Cut from v1, flag instead:** the "Your subjects" cross-subject panel — today's
`loadStudentHome` is scoped to one active subject only; a real multi-subject rollup is new query scope,
not in either workstream above. Ship Stage B for the active subject only; cross-subject summary is a
follow-up.

### Workstream 6 — Wire `experienceStage` to actual state selection

`TopicHome.tsx` currently computes `isNew` but renders one layout with minor text swaps. Replace with a
real switch on `snapshot.experienceStage`: `"new"` → Stage A component, `"building_signal"` → Stage B
component, `"personalized"` → today's existing layout unchanged (Main/Personalized is explicitly out of
scope for this task, see below — don't touch it, don't redesign it here).

## Out of Scope (explicitly, per the design review)

- **The Main/Personalized state** (`project/Main.dc.html`, `Mobile-Personalized.dc.html`). Depends on
  three things that don't exist yet: topic-level mastery heat-map (gated on `GAP-10`, the Biology
  `taxonomy_cells` content-authoring pass), per-criterion partial-FRQ resume (`lastAttempt` is
  hardcoded `null` today, no schema for it), and a streak/trend computation layer (zero backend exists
  for "days in a row" or a session-by-session point-rate series — `stats: []` is hardcoded empty).
  Revisit as its own task once those land.
- **Mobile.** The canvas's own note says it wasn't reworked yet ("still the earlier boxy version") —
  nothing to build against.
- **The 6-question diagnostic** (Stage A) and **cross-subject rollup** (Stage B) — flagged above as
  real, separately-scoped features, not wiring tasks.
- **Any change to `/session`, `SessionFrame.tsx`, or session-route retirement** (`O10` — separate,
  still-open question, unrelated to this task).

## Suggested sequencing

1. Workstream 1 (deploy the RPC) — do this first, independently, regardless of anything else; it also
   fixes a silently-broken feature on the *current* live Home.
2. Workstream 2 (topic position schema) — small, additive, unblocks both frontend workstreams.
3. Workstreams 3 and 4/5 can run in parallel once 1–2 land (3 is backend-only, 4/5 are frontend).
4. Workstream 6 last, once both stage components exist and Workstream 3's fields are live.

## Acceptance Criteria

- A real account with zero attempts sees Stage A, with no fabricated data anywhere on the page.
- A real account with some but not enough evidence (`experienceStage: "building_signal"`) sees Stage B,
  including a real "Worth revisiting" list sourced from `get_home_start_queue`, not a placeholder.
- A `personalized`-stage account's Home is byte-for-byte unchanged from today (this task must not touch
  that path).
- Every color/spacing/type value traces to `project/ds/cramapple/tokens.json`.
- `deno check` / typecheck and full test suites clean on every touched file, same bar as every other
  workstream this repo has shipped this week.


## Progress — 2026-10-04 (Claude session)

**Workstreams 1–3 (backend): live.** Verified read-only on Dev (`wmgjsdkphcyhngaffbqf`) and Production
(`pcntajvbdfqhbeewmdry`): `public.get_home_start_queue(uuid, int)` exists in both;
`app.student_course_positions.topic_code` / `topic_source` exist in both. Pulse/independence are computed
in `home-snapshot.ts` (frontend server function), not in SQL. **One gap found and closed:** Dev's
`public.student_course_positions` view still listed six columns (Production had been fixed by
`APPROVAL-0120`), so the Dev preview's Home would have returned HTTP 400. Applied the identical
`20261004223205_refresh_student_course_positions_view.sql` SQL to **Dev only** (idempotent
`create or replace view`; verified 8 columns, `security_invoker`/`security_barrier` on, `authenticated`
has SELECT). No Production change.

**Workstreams 4–6 (frontend, Lovable `56cae479`, commit `08a042ca`, Dev preview, not published):**
`HomeStageANew` / `HomeStageBBuilding` were built but unmounted; `HomeSnapshotView` rendered legacy
`TopicHome` for everyone. Now `selectHomeStage` routes `new` -> Stage A, `building_signal` -> Stage B,
`personalized` -> `TopicHome` unchanged (verified: no diff). New-stage wrapper keeps the top context bar,
welcome banner, live-session Resume strip and Log out. Gaps fixed against the artboards: Stage A hardcoded
"about 8 questions" replaced with `RECOMMEND_MIN_ATTEMPTS`/`RECOMMEND_MIN_ITEMS`; Stage A "Start practice"
once a position is saved (it previously dead-ended: stage stays `new` until an attempt); Stage A
"While you're here" explainers; Stage B "Your best N minutes" hero with Start practice; Stage B queue shows
topic titles when resolvable; curriculum legend. Lovable reported 545/545 tests, typecheck and build pass.

**QA so far: code-level only.** I could not sign in, so no authenticated visual/viewport QA was done.
Open findings for review:
1. Stage A's exam gauge is a decorative SVG with a hardcoded arc (not data-driven) — looks like progress
   but is not; consider a plain countdown or removing the arc.
2. Stage selection means the redesign is only seen with 0–2 graded attempts; at 3 attempts across 2 items
   the student gets the legacy `TopicHome` (Personalized/`Main.dc.html` is out of scope). Product call.
3. Stage B "Start practice" is disabled with no explanation when no course position is saved.
4. Stage B shows two "Next best action" eyebrows (hero and Worth revisiting); legend text "Evidence label
   shown when supported" is awkward.
5. Stage B queue titles only resolve for topics in the saved unit's guides; others fall back to "Topic x.y".
6. Not built (by design): 6-question diagnostic, cross-subject panel, mobile board.

**Next:** David signs in to the Lovable Dev preview, walks Stage A (new account) and Stage B (account with
1–2 graded attempts) at desktop and 390px, then decides on publish (Production publish remains a hard gate).
