# TASK-0039 — BYOQ: Production-Operational Intake, Home Entry, and Practice

**Task ID:** TASK-0039
**Title:** Make BYOQ (bring-your-own-question) operational in production —
Home entry point, Practice FRQ/MCQ serving of a student's own item, QR
photo capture, and worksheet upload with multi-question parsing
**Owner:** Claude (implementation), Technical Owner (review)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** High
**Created Date:** 2026-09-25
**Approved Date:** Pending

## Why this task exists

BYOQ has real design decisions on record but **no production backend at all**:
no table, no RPC, no edge function (confirmed live against Production — see
`docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`,
`DECISION-0057`). Separately, this session built a frontend-only reference
implementation in `web/` (the standalone design-system prototype, zero
backend, `localStorage` only) proving out the UX contract: BYOQ items are
Practice-only, never Open Hand, and never carry a canonical answer/rubric in
any mode. This task is what turns that contract into a real, backend-wired
feature reachable from the actual production app.

Two things changed the ground under this task since the design docs were
written, both confirmed live against Production this session:

1. **Practice MCQ and Practice FRQ already exist in production** — the
   CramApple Design System screens were imported into a Lovable-managed
   frontend ("New Cramapple App") and wired to live Supabase data and real
   server-side grading on 2026-09-24 (see the Activity Log entry of that
   date; see "Pre-flight verification" below for what's still unconfirmed
   about this). BYOQ's job is to reuse those screens' *shared UI components*
   for a new, separate, unscored BYOQ Practice screen — not to branch inside
   the graded screens themselves (see Phase 1) and not to build the whole
   visual layer from scratch either.
2. **The QR-based photo capture mechanism is real, deployed, and working** —
   `app.capture_pairing_tokens`, `app.response_attachments`, the
   `capture-pairing` edge function, and the `learner-uploads` storage bucket
   (all confirmed directly against Production). But it is tightly bound to
   the graded-attempt pipeline: `capture_pairing_tokens.content_item_version_id`,
   `.response_version_id`, and `.attempt_id` are all `NOT NULL` foreign keys
   into *existing library content*, and `upload_purpose` is hard-check-constrained
   to the single literal `'DRAWN_RESPONSE'`. A BYOQ photo has no library
   content_item_version to bind to — the student is submitting the question
   itself, not a response to one CramApple already wrote. See "Decision
   needed #1" below.

Worksheet upload (a document containing multiple questions, parsed apart into
separate BYOQ items) has **no precedent anywhere in this codebase** — not in
the BYOQ design docs (which assume one question per submission), not in any
OCR/vendor research to date (all of which was about *grading* hand-drawn
responses, not splitting a document into questions), and not in the content
authoring pipeline (which segments an *already-known* FRQ's answer into
rubric spans, a different problem). See "Decision needed #2" below.

### Corrections from adversarial review (2026-09-25)

A model-based adversarial review of this plan's first draft (prompted:
"identify gaps, misunderstandings, inefficiencies, untested assumptions, and
safety risks") found 25 findings, most of them real. This revision folds in
the ones confirmed against live systems and marks the rest inline. Summary of
what changed from the first draft:

- **Which frontend BYOQ actually ships in is unverified and must be checked
  first, before Phase 1 code starts** — see "Pre-flight verification" below.
  The first draft assumed "the New Cramapple App (Lovable)" is simply *the*
  production frontend; `exam-buddy-wireframe` is the repo this repo's own
  memory records as what actually serves `cramapple.com` via Lovable publish,
  and "New Cramapple App" is a separate, more recently-touched Lovable
  project whose publish status was never checked this session.
- **Phase 1 now builds a separate BYOQ Practice screen, not a branch inside
  the live graded screen** — the first draft's "extend the already-wired
  screens" instruction risked exactly what DECISION-0057 exists to prevent:
  a missed branch in the graded data path (`student-session-items` →
  `attempt-response` → `evaluate-attempt`) sending a BYOQ id somewhere it can
  be scored. The `web/` prototype already made the right call here
  (`PracticeByoqMcqScreen.jsx`'s own comment: "Deliberately not the library
  PracticeMcqScreen") — production should follow it, not diverge from it.
- **Storage path prefix corrected** — confirmed live against Production,
  `learner_uploads_owner_select`/`insert`/`update`/`delete` all key on
  `split_part(name, '/', 1) = auth.uid()`. A `byoq/...` prefix silently fails
  every owner check; it must be `<user_id>/byoq/...`.
- **BYOQ storage objects should NOT inherit `response_attachments`'
  immutability** — confirmed live: the owner-update/delete storage policies
  only exclude objects bound in `app.response_attachments`, so a
  `byoq_attachments`-bound object stays owner-mutable by default. That's
  correct for BYOQ (ungraded, undisputed, and the most likely place in the
  system to hold third-party or personal material a student may want to
  remove) — Phase 2 should deliberately not add an immutability trigger, not
  copy one.
- **"Reference material is answer-free" was imprecise** — confirmed live,
  `app.topic_explainers` (the actual production reference/explainer table)
  has `mini_example_question`/`weak_answer`/`point_attaining_answer` columns:
  it is CramApple-authored library content (permitted under DECISION-0057),
  but it does contain a worked answer to its own mini example, which could
  answer a BYOQ item that happens to match a standard textbook problem. Noted
  as an accepted, disclosed edge case below, not a rule violation.
- **New gaps section added** below for entitlement/quota, retention/deletion,
  consent copy, the private/moderated boundary before any future promotion,
  subject/taxonomy scoping, and the stuck-BYOQ routing DECISION-0057 already
  names — all real omissions the first draft didn't address.
- **Phase 2 defaults to a minimal QR variant**, not a full clone of the
  1,733-line `capture-pairing` function, since Phase 2 (per the first draft's
  own reasoning) does not do OCR yet — cloning the quality-check model call,
  provenance-event stream, and expiry sweep buys nothing until a photo is
  actually read by something. A third architecture option (extract shared
  token/upload logic into `_shared/`, parameterize purpose, keep one edge
  function) is now listed alongside the original two.
- **One review finding not adopted, flagged as uncertain rather than
  accepted or dismissed:** whether a stale reference to
  `docs/product/BYOQ_UPLOAD_POLICY_AND_DATA_LIFECYCLE_DISCUSSION_2026_09_23.md`
  matters beyond the citation fix already made below — the review called this
  a "name collision risk" with the unrelated `content-intake` admin function;
  plausible but not verified against a real confusion incident, left as a
  note rather than a scope item.

## Product Goal

A student can, from the real production app:

1. Type or paste their own MCQ or FRQ question on Home ("Bring a question"),
   or photograph one via the same QR phone-pairing flow already used for
   hand-drawn capture, or upload a worksheet that gets split into several
   candidate questions for the student to confirm one at a time.
2. Practice that question through the same Practice MCQ/FRQ screens real
   students already use for library content, with an honest "not scored, no
   answer key exists for a question CramApple didn't write" experience —
   never Open Hand, per DECISION-0057.
3. Reference material for the matching CED unit/topic is still available,
   since that's CramApple-authored library content, permitted under
   DECISION-0057. (One disclosed edge case: `app.topic_explainers`, the real
   production reference table, carries a worked `mini_example_question`/
   `point_attaining_answer` — if a student's BYOQ item happens to match that
   mini example closely, the reference pane can effectively answer it. This
   is not a rule violation — the content is CramApple's own — but it's worth
   the Product Owner knowing rather than assuming reference content is
   strictly answer-free in all cases.)

## Technical Scope, phased

Each phase is independently shippable and separately gated — do not start
phase *N+1* until phase *N*'s acceptance criteria are checked off and, for
any phase touching a Decision-needed item below, the Product Owner has
picked an option.

### Pre-flight verification (before any Phase 1 code)

This repo's own memory records `exam-buddy-wireframe` as the Lovable project
that actually publishes to `cramapple.com`. The 2026-09-24 activity log entry
this task's "Why" section leans on names a *different* project, "New Cramapple
App," as where Practice MCQ/FRQ were wired up — and that entry's own text
notes true in-browser verification was blocked by CORS, so even that work was
never confirmed rendering on a real, loaded page. Before writing any Phase 1
code: confirm (a) which Lovable project is actually published and serving
`cramapple.com` today, (b) whether "New Cramapple App" is that same project
under a new name, a staged replacement not yet published, or something else
entirely, and (c) load the live Practice MCQ/FRQ screens in a real browser
against production data before extending them. Do not assume the activity
log entry's description of "production" still matches by the time this task
executes — re-verify, per `feedback_verify_before_characterising`.

### Phase 1 — Data model and typed/pasted intake (no photo, no worksheet)

- New migration: `app.byoq_items` — `id`, `user_id` (FK `app.profiles`),
  `item_type` (`mcq`/`frq`), `title`, `stem`, `choices` (jsonb array of
  `{choice_key, choice_text}` for MCQ — **no `is_correct` column exists on
  this table at all**, so there is no column to ever mis-grant; this is the
  "structurally impossible, not policy-dependent" approach
  `BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md` recommends), a
  taxonomy reference (join to the existing `app.taxonomy_topics`/
  `app.taxonomy_cells` the same way library content does, so a promoted BYOQ
  item can sit in the real CED structure later), `difficulty`, `status`
  (`draft`/`ready`/`archived`), `source_kind` (`typed`/`photo_single`/
  `worksheet_split`, for later phases), timestamps. RLS: owner-scoped
  select/insert/update only, no anon/public grant, no service-role-only
  answer columns to protect because none exist.
- New, much lighter table `app.byoq_responses` (student's own draft/submitted
  answer text or picked choice key, tied to `byoq_item_id` + `user_id`) —
  deliberately **not** the full `attempts`/`response_versions` pipeline,
  because nothing here is graded, disputed, or audited the way library
  attempts are.
- New edge function (or an existing resource-style function extended) to
  create/list/get a BYOQ item and record a response — follow the existing
  per-resource function pattern (`attempt-response`, `student-session-items`).
- **Build a separate BYOQ Practice screen/component, not a branch inside the
  live graded Practice MCQ/FRQ screen.** The live screen's data path
  (`student-session-items` → `attempt-response` → `evaluate-attempt`) is
  exactly what DECISION-0057 must never let a BYOQ id reach — a missed branch
  anywhere in that chain (there is already one precedent for an
  easy-to-miss client-side fallback around this same code, the `item_type`
  workaround noted in the 2026-09-24 activity log entry) is how an answer
  key gets computed for a question that never had one. Mirror `web/`'s
  `PracticeByoqMcqScreen.jsx`/`PracticeByoqFrqScreen.jsx` structurally: same
  shared UI atoms (option rows, answer field, feedback card, reference pane)
  as the library screen, but its own component with no code path to a
  verdict — all choices always shown, no elimination/answer-key reveal, an
  honest not-scored feedback message. `QuestionRoute`'s dispatch-by-source
  pattern (`web/src/screens/QuestionRoute.jsx`) is the model: route by
  `question.source`, not by branching inside one component.
- Add the Home entry point ("Bring a question") to the real production Home
  screen, matching the pattern already added to `web/`'s `HomeScreen.jsx`
  this session. Confirm the current Home screen's actual name/path per the
  Pre-flight verification step above before editing — the 2026-08-17 activity
  log records a "HomeV2" restyle, but that may not be the current name.
- Read the live frontend source and replay the backend contract directly
  before writing any Lovable prompt for either of the above — do not guess
  from the `web/` prototype's shape alone (see
  `feedback_diagnose_before_lovable_prompt`).
- **Decision needed: none** — Phase 1 has no open architecture fork, it's
  ready to execute once approved and the Pre-flight verification above is
  done.

### Phase 2 — QR photo capture for a single BYOQ question

- **Decision needed #1 (Product Owner):** how does BYOQ reuse the QR
  capture-pairing mechanism?
  - **Option A — parallel tables (recommended):** new
    `app.byoq_capture_pairing_tokens` and `app.byoq_attachments`, structurally
    similar to `capture_pairing_tokens`/`response_attachments` (same state
    machine shape, same `learner-uploads` bucket, same
    `_shared/capture-attachment.ts` server-side validation), but FK'd to
    `byoq_item_id` instead of `attempt_id`/`response_version_id`/
    `content_item_version_id`, under storage path
    `<user_id>/byoq/<byoq_item_id>/...` — **not** a bare `byoq/` prefix; every
    owner-scoped storage policy on `learner-uploads` (confirmed live)
    keys on `split_part(name, '/', 1) = auth.uid()`, so the user id must be
    the first path segment. Deliberately **do not** add an immutability
    trigger or exclude these objects from the existing owner
    update/delete storage policies the way `response_attachments` does —
    BYOQ photos are ungraded and undisputed, and are the most likely object
    in the system to contain third-party or personal material a student may
    later want to remove (see "New gaps" below). Since there's no OCR yet
    (below), start with the minimal slice of the pattern — pairing token,
    signed upload, attachment row — and skip the quality-check model call and
    append-only provenance-event stream `capture-pairing` also has; those
    exist there to support automated spatial grading, which BYOQ has no
    analog of. A new edge function (`byoq-capture-pairing`) mirrors
    `capture-pairing/index.ts`'s split between authenticated (`mint_pairing`)
    and token-authenticated (`describe_capture`/`create_capture_upload`/
    `submit_capture`) operations, minus that extra machinery. Zero risk to
    the live, working DRAWN_RESPONSE pipeline — nothing about it changes.
  - **Option B — extend the existing tables:** relax
    `capture_pairing_tokens_upload_purpose_check` to also allow a new
    `'BYOQ_QUESTION_PHOTO'` literal, and make `content_item_version_id`/
    `response_version_id`/`attempt_id` nullable with a check that exactly one
    of "the DRAWN_RESPONSE triad" or "a byoq_item_id" is set. Less new schema,
    but it's a migration against a live, audited, immutability-triggered
    production table that has real graded-response data flowing through it
    today — higher blast radius for a bug.
  - **Option C — shared code, separate tables:** Option A's tables, but
    extract the token/claim/upload logic in `capture-pairing/index.ts` into
    `_shared/` and parameterize it by purpose, so one edge function serves
    both DRAWN_RESPONSE and BYOQ_QUESTION_PHOTO instead of two near-duplicate
    functions. Gets Option A's zero-blast-radius-on-data but requires a
    refactor-and-redeploy of the *live* `capture-pairing` function — weigh
    that redeploy risk honestly against the code-duplication cost of Option A
    before picking this over A.
  - This task defaults to Option A pending Product Owner sign-off.
- Once uploaded, the photo needs to become a usable `byoq_items` row. No OCR
  vendor is decided or tested for this (the OCR research on record is entirely
  about *grading* hand-drawn responses, not transcribing a fresh question; the
  one open thread — a direct LlamaParse pilot for hand-drawn content — was
  never run to conclusion, per `docs/research/` and the 2026-08-18 vendor
  notes). **Recommended default for this phase: no blind OCR.** The student
  photographs the question, then types/pastes the transcription themselves
  (Phase 1's intake form), with the photo attached to the `byoq_items` row
  purely for their own/a reviewing teacher's reference. Treat OCR-assisted
  auto-fill as a fast-follow once a vendor is actually chosen and tested
  against real hand-drawn/photographed source material — not a Phase 2
  dependency. Note this means the photo itself does no work yet (nothing
  reads it) — if that trade-off isn't worth Phase 2's cost on its own, it can
  wait and ship alongside the OCR fast-follow instead of before it.
- A BYOQ item must exist (in `draft` status) before a pairing token can be
  minted, since the token needs a `byoq_item_id` to bind to — decide and
  document this ordering explicitly in the edge function's contract, and add
  a sweep for abandoned drafts (minted, never scanned; scanned, never
  uploaded) — see "New gaps" below.

### Phase 3 — Worksheet upload, split into multiple questions

- **This phase needs its own design pass before any schema or code is
  written — it is undesigned today, not just unbuilt.** Every existing BYOQ
  doc (`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`, UX-004) assumes exactly
  one question per submission. Open questions a design doc must answer before
  Phase 3 starts:
  - **Decision needed #2 (Product Owner):** what parsing approach and vendor?
    (candidates surfaced this session: a VLM-based split-and-transcribe pass,
    similar in kind to the already-tested-for-grading chart/handwriting
    models but applied to layout segmentation instead of judgment; or a
    document-structure tool like LlamaParse, whose only prior evaluation here
    was for bounding boxes on grading images, not question-splitting.) No
    vendor has been tested against a real multi-question worksheet.
  - How many candidate questions is a worksheet allowed to yield, and does
    the student confirm/edit each one individually before it becomes a real
    `byoq_items` row (recommended — matches the "extraction confirmation"
    stage `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` already specifies for
    the single-question case) or can mis-splits silently become bad items?
  - Copyright/rights exposure is larger here than for a single typed question
    — a worksheet is more likely to be a teacher's or publisher's original
    material photographed wholesale. This needs its own privacy/rights read,
    not an assumption that Phase 1/2's typed-question posture (student's own
    words) still applies.
- Out of scope for this task until that design doc exists and is approved.

### New gaps surfaced by review (need a Product Owner call before Phase 1 ships)

None of these block writing Phase 1's schema, but all of them should be
decided before Phase 1 ships to real students, not discovered after:

- **Entitlement/trial gating.** The library `attempt-response` function
  enforces an entitlement check at submit time; the new BYOQ function has
  none specified. Decide whether BYOQ requires an active entitlement/trial
  (recommended, to match the rest of the product) and which existing check
  it reuses.
- **Rate limits/quotas.** Nothing in this plan caps items per student per
  day, stem/choice length, or stored-photo count. Undecided volume on a new
  write/storage path is exactly the kind of gap the reverted 2026-08-18
  capture-quality-check budget leak came from — pick a concrete cap before
  Phase 1 ships, even a generous one.
- **Retention/deletion.** No `ON DELETE` behavior is specified for
  `byoq_items.user_id`, and account deletion has no existing flow anywhere in
  this codebase to hook into. At minimum, specify cascade-on-delete for
  `byoq_items`/`byoq_responses`/`byoq_attachments`, and note explicitly that
  full account-deletion support is a pre-existing gap this task does not
  solve, not a BYOQ-specific one.
- **Consent copy.** The Product Owner directed a Terms/Privacy + PII
  reminder be shown on the existing hand-drawn capture surface
  (`CaptureItem.tsx`, 2026-09-23). The BYOQ intake form should carry the same
  notice, plus the "where is this question from?" prompt
  `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` already specifies — add both
  to Phase 1's intake screen, not as a later addition.
- **Private-until-promoted boundary.** Out of Scope already excludes content
  moderation beyond upload validation; that's only acceptable while BYOQ
  items are strictly private to their owner. State explicitly that no future
  SEO/AEO promotion path may read `byoq_items` without a moderation/content-
  review step first — this task creates the table, it must not also create
  an unreviewed path to a public page.
- **Subject/taxonomy scoping.** `web/`'s prototype hardcodes AP Statistics
  Unit 2; production must derive available subjects/topics from the
  student's actual enrollment and `app.taxonomy_topics` (mind the
  hyphen/underscore subject-key mismatch noted elsewhere in this repo's
  conventions), and decide what a topic with no published
  `topic_explainers` row for that subject renders instead of nothing (a
  silent absence is a known anti-pattern in this codebase — name it, don't
  let it happen quietly).
- **Stuck-BYOQ routing.** DECISION-0057 already names the intended behavior
  (recommend a related Open Hand library question, then return the student
  to their BYOQ item) but this plan neither implements nor formally defers
  it. Explicitly defer it here if that's the call, rather than leaving it
  unaddressed — it also affects whether a BYOQ item needs topic granularity
  fine enough to find a related library item.
- **Hints/deep-dive floor.** DECISION-0057 permits rubric-derived hints, deep
  dive, and points-strategy guidance for BYOQ; Phase 1 ships none of that (an
  empty hint set, matching the `web/` prototype). That's a reasonable v1
  floor, but say so explicitly as a deliberate scope choice for this task
  rather than a silent omission, since the decision anticipates a "distinct,
  smaller" hint contract eventually being designed.

## Out of Scope

- Selecting/testing an OCR or document-parsing vendor (Decision needed #2
  blocks this; it is its own follow-up task).
- Hint-throttling for repeat BYOQ use — explicitly deferred by DECISION-0057.
- Any SEO/AEO public-page promotion of a BYOQ item — DECISION-0057 names this
  as a future direction, not this task.
- Any auto-grading of a BYOQ response. Nothing here is ever scored, in any
  phase — that is the DECISION-0057 rule, not a gap to fill later.
- Relaxing `app.response_attachments`' or `app.capture_pairing_tokens`'
  immutability/DRAWN_RESPONSE constraints for any reason other than the
  Option A/B choice above.
- Malware/content moderation policy beyond the existing
  `_shared/capture-attachment.ts` server-side byte/dimension/digest
  validation boundary.

## Routes / Components / Systems Affected

- This repo: new migrations (`app.byoq_items`, `app.byoq_responses`, and
  Phase 2's `app.byoq_capture_pairing_tokens`/`app.byoq_attachments` if
  Option A), new edge function(s), RLS policies.
- The Lovable-managed frontend that turns out to be the one actually serving
  `cramapple.com` (verify per "Pre-flight verification" — do not assume it is
  "New Cramapple App" without checking): Home screen (`HomeV2` or its current
  equivalent — verify current name/path before editing), a new BYOQ Practice
  screen sharing components with (but not branching inside) the already-wired
  library Practice MCQ/FRQ screens, a new intake screen, and (Phase 2) the
  existing `CaptureItem.tsx` QR component extended or paralleled for a BYOQ
  pairing purpose.
- Not affected: the `web/` prototype in this repo (already complete, frontend
  reference only, not itself a production target — see its own README).

## Data / Security / Integration Impact

- New tables carry a student's own submitted academic content (potentially
  including personal information within the question text itself, per
  `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`'s personal-information state)
  and, from Phase 2, photographs. RLS must be owner-scoped from the first
  migration, not added later.
- No answer-bearing column exists on `byoq_items` at all (see Phase 1) — the
  DECISION-0057 rule is enforced structurally, matching how
  `app.mcq_choices`/`app.frq_criteria` are locked down for library content
  today, rather than relying on a grant getting written correctly on every
  future query.
- Phase 2's storage additions must reuse the existing `learner-uploads`
  bucket and `_shared/capture-attachment.ts` validation (media-type/size/
  dimension/digest re-derived server-side from actual bytes, never trusted
  from the client) rather than inventing a new validation boundary.
- Any Lovable-side change follows the existing convention: read the live
  frontend source and replay the backend contract directly before writing a
  Lovable prompt, never guess from this repo's mirrors/prototypes alone.

## Acceptance Criteria

- [ ] Phase 1: `app.byoq_items`/`app.byoq_responses` migrated to Dev, then
      Production, with RLS verified owner-scoped (test with a non-owner
      session, confirm zero rows returned).
- [ ] Phase 1: a real (or QA) student can type/paste an MCQ or FRQ on Home,
      land in the new BYOQ Practice screen (sharing components with, but
      separate from, the library screens used for library content), get the
      honest not-scored experience, and never reach an Open Hand route for
      that item (verify by hand-editing the URL, same check performed in the
      `web/` prototype).
- [ ] Phase 1: reference material for the chosen unit/topic renders from real
      library content, not fabricated.
- [ ] Phase 2 (after Decision needed #1 is resolved): a student can mint a QR
      pairing, photograph their own question on a second device, and see the
      photo attached to the resulting `byoq_items` row; the existing
      DRAWN_RESPONSE pipeline's row counts and behavior are unchanged by this
      work (regression check).
- [ ] Phase 3: blocked on its own design doc + Product Owner approval; no
      acceptance criteria written until that doc exists.

## QA Plan

- Manual QA: walk typed intake, photo intake (Phase 2), and the Open-Hand-
  redirect check, in both Dev and Production, per phase.
- Automated tests: RLS policy tests (SQL, mirroring the pattern used for
  other owner-scoped tables), edge function unit tests mirroring
  `capture-pairing/index_test.ts`'s split between authenticated and
  token-authenticated operations (Phase 2).
- Regression areas: the live DRAWN_RESPONSE capture pipeline
  (`app.capture_pairing_tokens`, `app.response_attachments`) must show zero
  behavioral change — re-run its existing checks after Phase 2 ships.
- Failure cases: empty/missing question text, a photo upload that fails
  validation, a student attempting to reach `/open-hand/<byoq-id>` directly.
- Security/data/integration checks: confirm no query path can ever return an
  `is_correct`-shaped field for a BYOQ item (there is no such column to leak,
  but confirm no phase adds one); confirm storage RLS blocks a non-owner from
  reading another student's BYOQ photo.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Pending — needs Product Owner sign-off on scope (including the
"New gaps" list under Phase 3), plus explicit answers to Decision needed #1
(Phase 2 architecture) and, before Phase 3 starts, a separate approved design
doc resolving Decision needed #2. This draft has already been through one
adversarial review pass (see "Corrections from adversarial review" above) —
that is not a substitute for Product Owner approval.

## Implementation Notes

Primary records this task builds on:

- `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`,
  `docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`,
  `docs/tasks/UX-004-STUDENT-PROVIDED-QUESTION-INTAKE.md`, `DECISION-0057`.
- `web/src/content/byoq.js`, `web/src/screens/BringQuestionScreen.jsx`,
  `web/src/screens/PracticeByoqFrqScreen.jsx`,
  `web/src/screens/PracticeByoqMcqScreen.jsx` — the frontend-only reference
  implementation this task's production version should match in UX contract
  (not in code — that code is `web/`'s prototype, not shared with the Lovable
  frontend).
- `supabase/migrations/20260819120000_capture_pairing.sql`,
  `supabase/functions/capture-pairing/index.ts`,
  `supabase/functions/_shared/capture-attachment.ts` — the QR/upload pattern
  Phase 2 reuses.
- Note: the activity log (2026-09-23) references
  `docs/product/BYOQ_UPLOAD_POLICY_AND_DATA_LIFECYCLE_DISCUSSION_2026_09_23.md`
  as a Codex discussion draft; that file is **not present in the repo** as of
  this task's creation (confirmed by direct search) — treat its content as
  summarized secondhand in that activity log entry and in DECISION-0057, not
  as a file to open directly. `BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`
  itself is also stale on one point: it states "no `content-intake` ... edge
  function exists," but `supabase/functions/content-intake/` does exist —
  it's an unrelated admin library-content-intake tool, not a BYOQ intake
  function, and its name is a plausible grep-confusion risk for whoever picks
  this task up. Don't cite that doc's system-state claims as still current;
  its *decision* (DECISION-0057) is what's authoritative, not its scan of
  what existed on 2026-09-23.

## QA Review

**QA Verdict:** Pending (Pass / Fail)

## Done Decision

**Decision:** Pending
**Date:** Pending
