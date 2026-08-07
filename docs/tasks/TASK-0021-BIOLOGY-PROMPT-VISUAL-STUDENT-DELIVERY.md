# TASK-0021 — Biology Prompt-Visual Student Delivery

**Task ID:** TASK-0021
**Title:** Deliver Approved Prompt Visuals to Students for the AP Biology Launch Slice
**Owner:** Technical Owner (assign)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Implemented (Repository Only); Deployment + Independent QA Pending
**Priority:** Critical
**Created Date:** 2026-08-05
**Approved Date:** Pending

## Product Goal

TASK-0020 found that Program A (question-visual delivery) is launch-blocked
for the entire 89-item slice (`APPROVAL-0042`): the sole stored image
(`APBIO-FRQ-S-009`) is not deliverable through any student-authorized path,
and the deployed student `/session` route does not render canonical
`stimulus`, `stimulus_image_path`, or structured prompt data at all — it
generates placeholder content locally, for every item, not just Biology's.
This task is the bounded remediation TASK-0020 explicitly scoped as
"next approval only" (`TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md`,
Program A remediation handoff), narrowed to what's needed to ship Biology's
now-built image candidates plus the structured/text stimulus items already
in the launch slice.

This task does **not** cover Program B (hand-drawn response capture) or
Program C (grading/repair) — those remain separately blocked per TASK-0020
and are out of scope here.

## Current state (2026-08-05)

- **8 construct-sensitive Biology items identified**, re-derived and
  documented in `docs/research/APBIO_SYNTHETIC_IMAGE_SURVEY_2026_08_04.md`
  §1: `APBIO-FRQ-L-003, 009, 011, 019, 020, 021, 027, 028`.
- **7 of 8 have code-drawn candidate images** built and QA'd for data
  fidelity against Production `stimulus` text (same doc, §4) — uploaded to
  `content-assets/Biology/FRQ/<content_key>.png` and wired via
  `stimulus_image_path` on 2026-08-05, confirmed live-verified. These are
  visible to reviewer roles now; they have **not** had Learning Quality
  construct-equivalence or scientific-accuracy review by anyone but the
  preparer.
- `APBIO-FRQ-L-028` (Mount St. Helens succession photographs) has no
  candidate yet — needs licensable archival photography or a separately
  reviewed synthesis approach, not covered by the matplotlib generator.
- `APBIO-FRQ-S-009` still has its own unresolved release-candidacy gates
  from the 2026-07-12/08-03 work (visual-layout rejected, scientific/
  grading/accessibility/rights/construct-equivalence/answer-leakage all
  pending) — this task must not treat S-009 as done by association.
- **Confirmed live and unchanged since TASK-0020, re-checked against
  repository code 2026-08-05:**
  - `storage-sign-url`'s `canAccessBucket` grants `content-assets` access to
    `admin`/`content_author` only (`supabase/functions/storage-sign-url/index.ts:56`)
    — not `tutor`/`reader`/`validator` as an earlier draft of this task
    claimed. Reviewers never call `storage-sign-url` for `content-assets`;
    `review-queue` signs stimulus images on their behalf with its own
    service-role client, scoped to exactly the images that reviewer's queue
    needs (`supabase/functions/review-queue/index.ts:338`). No `student`
    grant exists in either path.
  - **Live verified 2026-08-05 (SELECT-only, Production
    `pcntajvbdfqhbeewmdry`):** exactly 36 published `APBIO-FRQ-*` items
    (33 `frq_form = long`, 3 `short`), **all with `practice_format IS
    NULL`** and `frq_archetype IS NULL`. `select_practice_frqs` requires an
    exact non-null `practice_format` match with no NULL fallback
    (schema_baseline.sql:1445), so the Biology slice is not reachable
    through the practice-session selector. The same query confirmed images
    present on exactly `L-003, L-009, L-011, L-019, L-020, L-021, L-027`
    plus `S-009`, and absent on `L-028` — matching this doc's § Current
    state with no drift.
  - **Correction to TASK-0020's framing — a second student-facing Biology
    path exists.** "Not student-reachable at all" is true only of the
    practice-session selector. `app.start_free_score_check` (SECURITY
    DEFINER) serves a single Biology FRQ pinned by the
    `growth.free_score_check.v1` config row, creates a real
    `learning_session` + `attempt`, and **never consults `practice_format`
    or `select_practice_frqs`** — so the `practice_format IS NULL` blocker
    does not protect it. Reached from the `free-score-check` Edge Function,
    which is hardcoded to `subject_key = 'biology'`. **Live verified
    2026-08-05:** that config is currently `enabled = false` with no
    `content_item_version_id` set, so there is no live exposure today. But
    whenever it is enabled and pointed at an item, it becomes a student
    delivery path for Biology content that bypasses every gate this task
    otherwise installs. It must therefore be covered by the
    QA-visible/student-visible gate below, and re-checked before launch.
    (The 2026-08-01 bypass analysis in
    `20260802015030_scope_reclassification_guard_null_practice_format_backfill.sql`
    correctly concluded this function cannot reach an *AP Statistics* row;
    it is hardcoded to Biology, so for *this* task it is in scope, not out.)
- **Authoritative frontend — resolved 2026-08-05, and not what an earlier
  draft of this task assumed.** The worktree is `task0018-frontend`
  (`.worktrees/task0018-frontend`), but the canonical student FRQ surface is
  **`src/routes/_ux.session.frq.tsx`**, driven by
  `src/lib/use-published-frq.ts` (`select_practice_frqs` RPC, published and
  version-pinned). That route already rendered `stem`, `stimulus`, `parts`,
  and `stimulus_image_path` against real content.

  `src/hooks/use-session.ts` — whose `makePlaceholderQuestion`
  (`use-session.ts:120`) fabricates every item client-side — is a **separate,
  older path**, not the FRQ route. It also writes a `public.sessions` /
  `public.attempts` shape (`exam`, `goal`, `planned_minutes`, `raw_answer`)
  that does not match canonical `app.learning_sessions` / `app.attempts`. It
  is untouched by this task and should not be mistaken for a working student
  path.

  This distinction matters because it changes the defect: the live problem
  was never "no image renders." It was that the image render **failed open**
  — see § Implementation Summary, "Deployed verified".

  All three worktrees (`task0018-frontend`, `task0019-frontend`,
  `consolidate-apstats-ui`) carry both the canonical plumbing and the
  placeholder. Which one, or which Lovable build, is actually deployed still
  needs confirming before this ships.

## Proposed Architecture

```
select/create learning session (existing)
        │
        ▼
server selects eligible item versions
  (select_practice_frqs RPC or successor, practice_format-scoped)
        │
        ▼
server signs/proxies required visual assets for exactly those versions
  (new student-session-items function; see below)
        │
        ▼
frontend receives one render-ready session payload
  (stem, stimulus, media[] with alt/long_description, parts, practice_format)
        │
        ▼
student renders and answers
        │
        ▼
attempt-response revalidates exact session/content/practice_format
  match at submission (existing — attempt-response/index.ts:286)
```

Two authorization checks matter and must not be conflated: (1) the student
is eligible to see this item *version* in this *session* — enforced today at
submission by `attempt-response`, but for delivery this must be enforced
*before* the asset is signed, not just at submit time; (2) the asset itself
is scoped to that version, not general `content-assets` bucket access.

## Technical Scope

- Add a new Edge Function (working name `student-session-items`) rather than
  widening `storage-sign-url`. It accepts a `learning_session_id` (+ item/
  version identifiers already resolved by session selection), independently
  re-derives that the requesting student's active session is actually
  serving that exact `content_item_version_id` (reusing or factoring out the
  same session/content/practice_format checks `attempt-response` already
  performs at `attempt-response/index.ts:286-310`, run *before* delivery
  instead of only at submission), and only then signs or proxies the
  specific `stimulus_image_path` for that version — mirroring the
  service-role, per-request scoping pattern `review-queue` already uses
  (`review-queue/index.ts:338`), not a new bucket-wide role grant. It must
  never accept an arbitrary bucket/path from the client. **Decision: David
  Bloom, 2026-08-05 — short-TTL signed URLs, not a same-origin proxy.**
  Accepted trade-off: the student's browser sees that item version's own
  storage path (signed URLs are not path-secret); other items' assets stay
  unreachable, per § Data / Security / Integration Impact.
- Define one render payload contract returned by this path (or its
  session-selection counterpart):
  `content_item_version_id`, `content_key`, `stem`, `stimulus_blocks`,
  `media[] { kind, url_or_proxy_url, alt, long_description, required,
  asset_version_or_hash }`, `parts[]`, `practice_format`. Internal
  grading-only fields (e.g. `expected_graph_spec`, rubric data) are **not**
  included — this is the student-facing prompt contract, not the grading
  contract. If a grading field needs a student-facing equivalent (e.g. axis
  labels a student must reproduce), it must be deliberately transformed into
  a named `stimulus_blocks`/`media` entry, not passed through wholesale.
- Wire the `/session` runtime (`task0018-frontend`'s `use-session.ts`) to
  this real payload instead of `makePlaceholderQuestion`, reusing or
  replacing `use-published-frq.ts`'s existing `select_practice_frqs` call
  rather than inventing a second content-fetch path.
- Store approved accessible alt/long-description text in a new
  `app.content_asset_metadata` table keyed by `content_item_version_id` +
  storage path, carrying `alt_text`, `long_description`, `approved_by`, and
  `approved_at`. **Decision: David Bloom, 2026-08-05.** Chosen over a
  `prompt_json` key and over new `content_item_versions` columns because the
  Acceptance Criteria require *approved* accessibility text and neither
  alternative can record who approved it — and because
  `content_item_versions` is marked a deprecated compatibility projection in
  the schema baseline. Cost accepted: the serving path must join this table
  rather than reading a column that `select_practice_frqs` already returns.
- Fail-closed has one authoritative definition for this task: the server
  omits or replaces an item **at session-selection time** if its required
  visual/media payload cannot be resolved or signed — the student never sees
  a broken item to begin with. A client-side guard is defense-in-depth only,
  for the narrower case of a signed URL expiring or an asset erroring
  *after* it was already delivered into an active session: in that case the
  client disables answer submission for that item and surfaces a retry/
  reload affordance, but does not silently accept a response against
  content it couldn't actually render.
- Cover the `free-score-check` path (§ Current state correction). Either it
  renders visuals through the same `student-session-items` contract, or its
  config must be constrained so it can only ever be pointed at an item with
  no required visual. Whichever is chosen, the choice must be enforced in
  code or by a check — not left to whoever next edits the
  `growth.free_score_check.v1` config row. Its pinned item must also be
  subject to the same student-visible gate as the practice path.
- Define separate visibility gates and apply them explicitly: **QA-visible**
  (an authenticated staff/QA identity, or a student account explicitly
  flagged for pre-approval testing, can exercise the full render path before
  Learning Quality sign-off) versus **student-visible** (a real student
  session can select and be served the item). The 7 built Biology images
  must be QA-visible now so this task's own render/QA checks can run, but
  must not become student-visible until the construct-equivalence review in
  Acceptance Criteria is recorded. Implement this as an explicit gate
  (e.g. a version-level flag or environment scoping), not an informal "we
  just won't publish it yet."
- Resolve the Biology `practice_format IS NULL` blocker as a named
  **prerequisite** to this task, not a loose acceptance-criteria line: it
  needs its own small approval record before Biology items can be exercised
  end-to-end by a real student selector, because without it there is no way
  to student-QA the render path against real Biology content at all. This
  task may implement it in the same PR, but it gets its own review/approval
  entry, not silent inclusion.

## Out of Scope

- Program B (drawn-response capture/preservation) and Program C (grading/
  repair) — both remain independently blocked per TASK-0020.
- Building `APBIO-FRQ-L-028`'s photographic asset.
- Merging or adopting `codex/image-workflows-design-sketch` (still
  quarantined; any design here must be independently derived and compared
  against it, not built from it).
- AP Statistics's 32 construction items (Program B territory, not this
  task).
- Automated or AI-assisted grading of any drawn/image response.

## Routes / Components / Systems Affected

- New `student-session-items` Edge Function (or equivalently named) —
  session/version-scoped asset signing, factored from or alongside
  `attempt-response`'s existing eligibility checks. `storage-sign-url`
  itself is not modified or role-widened.
- `task0018-frontend`'s `/session` runtime (`use-session.ts`,
  `use-published-frq.ts`) — rendering path for canonical stimulus content.
  Confirm before implementation whether this worktree, `task0019-frontend`,
  `consolidate-apstats-ui`, or a Lovable deployment is what's actually
  live, and update this section with the confirmed answer.
- `select_practice_frqs` RPC / content-serving selector — Biology
  `practice_format` resolution.
- `app.start_free_score_check` RPC + `free-score-check` Edge Function —
  second student-facing Biology delivery path, bypasses `practice_format`
  (§ Current state correction). In scope for the visibility gate.
- Accessibility metadata storage for prompt visuals (new column/key —
  location decided under this task per § Technical Scope, not assumed).

## Data / Security / Integration Impact

- New student-facing read path into content that today is authoring/
  reviewer-only. The signed URL itself will necessarily reveal that item
  version's own storage path to the student's browser (signed URLs are not
  path-secret) — that is accepted as long as: the path is scoped to exactly
  the version being served, is not enumerable/guessable to reach other
  items' assets, carries a short TTL, and is re-derived per session rather
  than reused. If any reviewer requires the path itself to stay hidden (not
  just other items' assets), this task must use a same-origin proxy instead
  of a signed URL, and that decision needs to be made explicitly during
  Hard-Gate approval, not discovered after ship.
- No learner PII or response data is touched by this task — it is entirely
  about serving already-published prompt content.
- Any new signed-URL or proxy path needs the same idempotency/expiry
  discipline the existing `storage-sign-url` function already has, plus the
  pre-delivery eligibility check described in § Proposed Architecture
  (stricter than `attempt-response`'s submission-time check, since it runs
  earlier in the flow).

## Acceptance Criteria

- [x] Re-verify the deployed student session's current rendering behavior
      live (do not assume TASK-0020's snapshot is still accurate) before
      designing the fix, and confirm which frontend/deployment is actually
      live (§ Current state, Routes/Components). **Done — and it corrected
      the premise; see § Implementation Summary, "Deployed verified".**
- [ ] `practice_format IS NULL` prerequisite is resolved and independently
      re-confirmed with a live SELECT-only query, with its own approval
      record — before the render-path checks below are attempted against
      real Biology content (they depend on it).
- [ ] A representative item from each Biology representation type in the
      launch slice — the raster image, a text/JSON-encoded stimulus, and a
      construction (`HDG-GRAPH`) item — renders correctly and legibly on
      supported desktop/mobile sizes and at required zoom/reflow (375px
      mobile, standard desktop, 200% browser zoom), for an authenticated
      student session, using the render payload contract defined in
      § Technical Scope (no `expected_graph_spec` or other grading-only
      field present in the student-facing payload).
- [ ] Approved accessible alt/long-description text renders alongside each
      visual and is reachable via a keyboard/screen-reader path, not only
      visually adjacent.
- [ ] Fail-closed behaves per the single authoritative definition in
      § Technical Scope: a forced missing/unresolvable asset at
      selection time results in the item never being offered to the
      student (verified by an actual forced-failure test, not code review
      alone); a forced mid-session expiry/error results in submission being
      disabled for that item with a retry/reload affordance, not a silently
      accepted response.
- [ ] Negative-authorization tests pass: an authenticated student cannot
      fetch another student's session's asset, an unpublished version's
      asset, a reviewer-only path, an asset for an item not in their
      current session, or reuse an expired signed URL to bypass
      revalidation.
- [ ] The QA-visible/student-visible gate (§ Technical Scope) is
      implemented and verified: staff/QA can exercise the full render path
      today; no real student session can select or be served any of the 8
      construct-sensitive items until the criterion below is recorded.
- [ ] The `free-score-check` path is covered by that same gate, and
      `growth.free_score_check.v1` is re-checked live immediately before
      launch to confirm it is still either disabled or pointed only at an
      item cleared to ship — this path bypasses `practice_format`, so the
      prerequisite above does not protect it.
- [ ] Learning Quality construct-equivalence review is complete and
      recorded for all 8 construct-sensitive items (§ current state above)
      before any of them ships to a real student — this task delivers the
      pipe, not the content approval; do not let "the pipe works" become an
      implicit content sign-off.
- [ ] `APBIO-FRQ-S-009`'s own outstanding release gates (visual-layout,
      scientific, grading, accessibility, rights, construct-equivalence,
      answer-leakage) are closed before it ships through this path.
- [ ] Independent QA (fresh context, live production checks) confirms the
      above, following the same evidence discipline TASK-0020 used (Live
      verified / Deployed verified / Repository only / Not verified —
      labeled, not asserted).

## QA Plan

- Manual QA: authenticated student walk-through at 375px mobile, standard
  desktop, and 200% browser zoom, for each representation type; a
  keyboard-only and screen-reader pass over alt/long-description text; a
  reviewer walk-through confirming nothing regressed on the existing
  reviewer-portal render path (`review-queue`'s signing is untouched).
- Automated tests: contract test that `student-session-items` rejects/omits
  an item at selection time when its visual payload 404s or times out
  (pre-delivery fail-closed); a separate test for the client-side
  submit-disable guard when a signed URL expires mid-session
  (post-delivery fail-closed); negative-authorization tests — cross-student
  session asset, unpublished version, reviewer-only path, item outside the
  current session, expired-URL replay — each expected to fail closed;
  regression test that `storage-sign-url`'s existing role grants
  (`admin`/`content_author` for `content-assets`) are unchanged.
- Regression areas: reviewer portal rendering (already working — must not
  break it while adding the student path); other subjects' `/session`
  rendering (this touches the shared renderer, per § Technical Scope); AP
  Statistics's HDG items, which share the structured-stimulus rendering
  path; `attempt-response`'s existing submission-time practice_format check
  (must remain consistent with the new pre-delivery check, not diverge).
- Failure cases: missing asset, expired signed URL, wrong content-item
  version served, enumerable/guessable asset path, unanswerable item
  accepting a response, accessible-text missing or mismatched, item
  reachable in a student session before its QA-visible/student-visible gate
  allows it.
- Security/data/integration checks: no `content-assets` bucket-wide grant
  added for `student`; asset access requires the same or a stricter
  eligibility check than `attempt-response` performs at submission,
  executed before delivery; signed URLs scoped to the exact item version
  being served with short TTL and no reuse across sessions; no other
  students'/items' assets reachable through the new path.

## Implementation Summary

Implemented 2026-08-05 under the Product Owner's plan approval. Evidence
labels below follow TASK-0020's discipline.

**Live verified (SELECT-only, Production `pcntajvbdfqhbeewmdry`):**

- Exactly 36 published `APBIO-FRQ-*` items, all `practice_format IS NULL`,
  all `frq_archetype IS NULL`. 33 `long` (4 criteria, 9–10 pts), 3 `short`
  (2 criteria, 4 pts). TASK-0020's blocker is unchanged.
- Images present on exactly `L-003, L-009, L-011, L-019, L-020, L-021,
  L-027` + `S-009`; absent on `L-028`. Matches § Current state, no drift.
- `growth.free_score_check.v1` is `enabled = false` with no
  `content_item_version_id` — the second delivery path is not live today.
- Biology `prompt_json` has **no `parts` array**; it carries `criteria`,
  `total_points`, `qa_remediation`, `modules`, `subtopics`. Student-facing
  part text comes from `app.frq_criteria.learner_facing_text`, whose row
  also holds `evidence_requirements`, `minimum_fix`, and
  `accepted_variants`. Forwarding `prompt_json` or selecting `frq_criteria`
  with `*` would leak grading data to students; the serving path uses a
  strict column whitelist and is tested for it.

**Repository only (written, typechecked, unit-tested; not deployed):**

- `supabase/migrations/20260805100000_content_asset_metadata.sql` — the
  approved accessibility-metadata table, service-role only, RLS forced. It
  doubles as the student-visibility gate: `approved_at IS NULL` means
  QA-visible but not student-visible. No row is seeded approved, so this
  migration grants no item student visibility on its own.
- `supabase/migrations/20260805110000_backfill_practice_format_biology_frqs.sql`
  — the prerequisite backfill, all 36 → `targeted_drill`. Guards on an
  expected count of 36 and raises on drift rather than reclassifying a
  changed corpus through a one-way door.
- `supabase/functions/student-session-items/index.ts` + the pure rule module
  `_shared/student-item-delivery.ts` — session-scoped delivery. Never
  accepts a bucket/path from the client; re-derives eligibility before
  signing; signs with the service role at a 900s TTL.
- `_shared/storage-access.ts` — `canAccessBucket` extracted from
  `storage-sign-url` so its grants are regression-testable. Behavior
  unchanged; `content-assets` remains `admin`/`content_author` only.
- `task0018-frontend`: `src/lib/use-session-items.ts` and the reworked
  `src/routes/_ux.session.frq.tsx`.

**CORRECTION 2026-08-05 — the label below was originally written as
"Deployed verified" and was not earned.** It was derived from
`.worktrees/task0018-frontend`, which is a checkout of a *different* repo
(`david-bloom/exam-buddy-wireframe`, Vercel-deployed) on a branch **72
commits behind `origin/main`**. That is not the deployed code. The finding
was subsequently re-checked directly against `origin/main` and **does hold** —
`alt="Stimulus"`, `useSignedAssetUrl`, and an enabled submit button are all
present there. But it held by luck, not method, and any other conclusion
drawn from that worktree needs the same re-check before being trusted.
Re-labelled **Repository verified against `origin/main`**.

**Repository verified against `origin/main` — corrects this task's own
premise.** The canonical
student FRQ route is `_ux.session.frq.tsx` driven by `use-published-frq.ts`,
not `use-session.ts`'s `makePlaceholderQuestion` (which belongs to a
separate, older path that also writes a non-canonical `public.sessions` /
`public.attempts` shape). That route **already** rendered stimulus images —
through `useSignedAssetUrl` → `storage-sign-url`, which returns 403 for a
`student` role. So the live pre-fix defect was not "no image renders"; it
was **fail-open**: the student saw "Couldn't load stimulus image", the
generic `alt="Stimulus"`, and *could still submit an answer* to a question
they could not read. That is the "unanswerable item accepting a response"
failure case, live, today.

**Not verified (blocked in this session, by design):** no end-to-end
authenticated-student render, no forced-failure run against a deployed
function, no zoom/reflow or screen-reader pass. All of that requires the
migrations applied and the function deployed. The migrations were
deliberately **not** applied — one is a one-way-door data change on
Production content and both belong to the Hard-Gate approval, not to a
build session.

## Deployment Record — 2026-08-05

Deployed to Production (`pcntajvbdfqhbeewmdry`) under the Product Owner's
instruction, in the safe order below. The local Supabase CLI is linked to
**Development** (`wmgjsdkphcyhngaffbqf`), so every command passed
`--project-ref` explicitly; `--workdir` was also required because the CLI
otherwise resolves a stray `~/supabase` directory as the project root.

**Live verified — applied and confirmed:**

- `app.content_asset_metadata` — 10 columns, 3 check constraints.
- `app.content_visual_requirements` — 7 columns, 3 check constraints.
- `student-session-items` Edge Function (6 files incl. `_shared`). Confirmed
  executing this task's code, not merely uploaded: no body → `invalid_json`;
  malformed id → `missing_required_fields`; `GET` → `method_not_allowed`;
  anon JWT + valid uuid → `unauthorized`; no JWT → platform
  `UNAUTHORIZED_NO_AUTH_HEADER` (confirms `verify_jwt` is on).
- `review-decision` Edge Function, **soft mode** — boots, returns `forbidden`
  to an unauthorized caller.

**Deliberately NOT deployed:**

- The `practice_format` backfill. It is the one-way door, and running it
  before the student frontend ships would make 36 Biology items reachable
  through the currently-deployed fail-open render path — newly exposing the
  8 image-bearing items to real students. It must run last.

**Expand/contract on `review-decision`.** `REQUIRE_IMAGE_NEEDED = false`
ships first because the deployed reviewer client does not yet send
`image_needed`; enforcing it immediately would 400 every `tutor_question`
submission (37 today, ~150/day, 3–9 reviewers). A value that *is* sent is
fully validated either way, so the soft window cannot admit bad data. Flip to
`true` and redeploy only after the reviewer frontend is live and confirmed
sending the field.

**Not verified — stated plainly.** Reviewer traffic stopped at 12:10 UTC,
~57 minutes before this deploy, so **no real reviewer submission has yet
exercised the new `review-decision`**. Backward compatibility is established
by code-path analysis and a boot probe, not by observed production traffic.
The first `tutor_question` submission is the real test; watch it. The
edge-function log endpoint returned `FetchException` during this session, so
log-based confirmation was unavailable.

**Consequence to expect once serving is live:** `content_asset_metadata` has
zero rows, so all 8 Biology image items will be withheld with
`asset_metadata_missing`. That is correct fail-closed behavior, not a bug —
the images become deliverable only once approved alt/long-description text is
recorded.

## Frontend PR — 2026-08-05

**The frontend is a separate repository.** `david-bloom/exam-buddy-wireframe`,
deployed by Vercel (project `bloom-llc/cramapple`) from its `main` branch —
not this repo, and not Lovable-only as the `.lovable` marker suggests. The
three `.worktrees/*` directories are branches of that repo, none of which is
`main`. This was unresolved through most of this task and should have been
established first.

`https://github.com/david-bloom/exam-buddy-wireframe/pull/3` — open,
mergeable, 8 files, +842/-101. Built on a fresh branch off `origin/main`.

An earlier attempt was based on `codex/task0018-recognized-home`, which is 72
commits behind `origin/main` and carries 5 unshipped TASK-0018 commits.
Merging it would have reverted unrelated work in the two route files and
released TASK-0018 by accident. That base was discarded and both changes
rebuilt.

**Design change forced by working against the real `main`:** the FRQ route
has no `sessionId` search param in production, so the client now reads the
learning session id from `useRuntimeContext()` — the same
`app.learning_sessions.id` that `session-event` returns. The earlier design,
which read it from `Route.useSearch()`, would not have functioned in
production at all.

Excluded from the PR: `src/routeTree.gen.ts` (generated; no routes added).
Disclosed in the PR: some hunks are prettier conformance rather than logic —
`main` had drifted from the repo's own `printWidth: 100`, so `main` fails
`prettier --check` where this branch passes.

## Post-merge state — 2026-08-05

- PR #3 **merged** (`9e2c471`, squashed) and **deployed to Production by
  Vercel** — deployment status `success` on the merge commit.
- **Accessibility metadata authored for all 8 image-bearing Biology items**
  and inserted into `app.content_asset_metadata` with `approved_at` **NULL**.
  Each `alt_text`/`long_description` is derived from that item's own
  Production `stimulus` text — the same traceability property that makes the
  deterministic image generator checkable — and describes structure and data
  values only, never the conclusion the item asks the student to reach.
  `L-003`/`L-019` describe pedigree topology without naming the inheritance
  mode; `L-021` describes the packing contrast without naming the regulatory
  mechanism.
- Effect of that insert: those 8 items move from `asset_metadata_missing` to
  `asset_not_approved_for_students`. Staff/QA can now render them through the
  authorized path; **no student can**. Setting `approved_at` is the Learning
  Quality decision and is deliberately left un-set — this task does not
  self-approve its own content.

**`REQUIRE_IMAGE_NEEDED` deliberately still `false`.** The reviewer frontend
is deployed, but no reviewer submission has yet been observed carrying
`image_needed` (traffic stopped 12:10 UTC, before the merge). Enforcing
against an unverified client is the same class of error this task has already
made twice; the flip should follow an observed successful submission, not
precede it.

## Resume here — session ended 2026-08-05

Two human actions unblock everything remaining. Neither is a code change.

1. **One reviewer submits any question review.** Then check:
   `select decision_payload->>'image_needed' from app.content_review_decisions
   where review_stage='tutor_question' order by submitted_at desc limit 1;`
   - Non-null → set `REQUIRE_IMAGE_NEEDED = true` in
     `supabase/functions/review-decision/index.ts` and redeploy
     (`supabase functions deploy review-decision --project-ref
     pcntajvbdfqhbeewmdry --workdir <repo>`).
   - NULL → the deployed reviewer client is not sending the field. Do **not**
     flip; investigate the Vercel build first.
2. **One authenticated student opens an FRQ practice session.** Confirms the
   delivery path end to end. Only after that is the `practice_format`
   backfill (`20260805110000`) safe to run — it is the one-way door, and it is
   the last step, not the first.

Also open, independent of the above:

- **Approve the 8 accessibility descriptions** in
  `app.content_asset_metadata` (set `approved_at`/`approved_by`) after
  reading them. Until then those items are correctly withheld from students.
- **`APBIO-FRQ-L-028`** still has no image and needs licensable archival
  photography, not the matplotlib generator.
- **The 73 non-Biology published FRQ stems** have never had the §1
  stem-instruction read. A keyword pass scored 0/44 and missed the one true
  positive, so this needs the reviewer checkbox or a careful human pass — not
  another regex.

A monitor watching for (1) was armed and then stopped at session end; it was
never triggered, so no post-deploy reviewer submission has been observed.

## Test Results

- `deno test supabase/functions/_shared/` — **102 passed, 0 failed** (83
  pre-existing + 19 new). New: 15 delivery-rule tests, 4 `storage-sign-url`
  grant-regression tests.
- `deno check` clean on `student-session-items` and `storage-sign-url`.
- `task0018-frontend`: `npx vitest run` — **165 passed, 0 failed** (159
  pre-existing + 6 new contract tests). `tsc --noEmit` and `eslint` clean.
- Covered by test: student withheld from unapproved visual; staff QA
  allowed; student allowed once approved; `student` is not a QA role;
  missing metadata withheld from everyone; unsignable visual yields no item;
  wrong-version and wrong-bucket metadata rejected; mixed batch withholds
  only ineligible items; grading-only criteria never become parts; payload
  contains none of `prompt_json`/`criteria`/`evidence_requirements`/
  `minimum_fix`/`accepted_variants`/`expected_graph_spec`; `content-assets`
  still `admin`/`content_author` only.

## Risks / Issues

- **5 published Biology HDG items stay unreachable on purpose.**
  `APBIO-HDG-2026-GRAPH-{004,006,008,011,012}` are published, have published
  versions, and have `practice_format IS NULL` — but they are hand-drawn
  construction items (Program B, still blocked). The backfill's
  `APBIO-FRQ-%` filter excludes them deliberately; backfilling them would
  make drawn-response items selectable with no capture path. Anyone
  "completing" the Biology backfill later must not sweep these in.
- **The `practice_format` backfill is a one-way door.** The guard's
  carve-out permits `NULL → non-null` only; `targeted_drill →
  full_exam_frq` later raises and requires the retire/re-review cycle
  rejected as Phase 2b. If the Biology short-FRQ corpus grows enough to
  assemble a real exam section, that is a content decision with a
  retirement cost, not a migration.
- **Deployment ordering matters.** The frontend now routes session items
  through `student-session-items`. Shipping the frontend before the
  function and the metadata migration would leave image items withheld
  (fail-closed, so safe — but Biology would look empty).
- The 8 construct-sensitive items remain content-unapproved. Nothing here
  changes that, and no `approved_at` is seeded.
- `use-session.ts`'s placeholder path is untouched and still fabricates
  items. It was out of this task's real scope once the canonical route was
  identified, but it should not be mistaken for a working student path.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate — Product Owner, Technical Owner, Accessibility
reviewer, and Content/Learning Quality Owner sign-off before implementation
begins, per TASK-0020's named remediation-handoff owners.
**Decision:** Pending

## Implementation Notes

Reuse TASK-0020's evidence-discipline labels (Live verified / Deployed
verified / Repository only / Prototype only / Proposed / Not verified) in
whatever findings or PR description comes out of this task — this repo's
governance conventions expect that, not a plain summary.

Reviewer-capacity note carried over from TASK-0020: Program A's own
estimated review load (7 construct-equivalence reviews + S-009's scientific/
grading/accessibility/visual-layout/rights reviews, ~4–7 specialist-hours)
and Program C's manual-review-path load draw on the same qualified-reviewer
pool. Sequence this task's Learning Quality review against that shared
capacity plan, not as an independent budget.

## QA Review

**QA Verdict:** Pending — `Hard-Gate` tier requires independent QA before
Done Decision.

## Done Decision

**Decision:** Pending
**Date:** Pending
