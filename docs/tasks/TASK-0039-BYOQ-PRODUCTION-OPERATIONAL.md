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

### Question identity, answer capture, and image linking — unified schema

This section supersedes the original Decision needed #1 framing below (kept
for its still-relevant options, now reframed as one axis of a bigger choice).
Written up 2026-09-26 after a design conversation surfaced that CramApple
already has exactly the "code that allows lookup" pattern BYOQ needs
(`content_items.content_key`), that a BYOQ session needs a **second** image
type this plan hadn't named (a hand-drawn *response* photo, not just the
question photo), and that the live system has a real, pre-existing gap in
"whole vs. part of an answer" that BYOQ inherits and should fix rather than
copy. Confirmed live against Production before writing this:
`content_items.content_key` is the human-readable lookup code library content
already has; `app.response_attachments` has no part/slot column at all (an
image binds to a whole `response_version`, one "current" at a time); and
`app.capture_pairing_tokens.submission_slot_id` — the one column that
anticipates a "which part" concept — has never held any value but `slot-1`
in any of the 3 real rows in Production, i.e. this was designed for and never
actually exercised.

**1. One binary-typed reference to "the question," used everywhere a question
needs naming.** Every table that points at "the question" (attempts, the
image table, eventually anything else) carries the same three columns instead
of one untyped id:
- `question_source` — `'cramapple' | 'byoq'`
- `content_item_version_id` — nullable, FK to `app.content_item_versions`
- `byoq_item_id` — nullable, FK to new `app.byoq_items`
- a check constraint: exactly one of the two FKs is set, matching
  `question_source`.

This is the standard safe way to do a polymorphic reference in Postgres —
two real foreign keys instead of one loosely-typed id, so referential
integrity holds on both branches, matching this schema's existing taste for
explicit check constraints over implicit convention (see
`capture_pairing_tokens_access_path_check` for the same pattern already in
use).

**2. Lookup codes, same shape on both sides.** CramApple already has this:
`content_items.content_key` (e.g. `apstats-2-2-mcq-001`) is the stable,
human-readable code; `content_item_versions.id` is the specific version
underneath it. New: `app.byoq_items.code` — short, unique, human-typeable,
same role. `select * from byoq_items where code = '...'` works the same way
`content_key` lookups already do.

**3. (Option D's approach, described here for the Decision below — the
answer/response layer would reuse `app.attempts`/`app.response_versions`
instead of a parallel `byoq_responses` table.)** `app.response_versions` is
already fully generic — it only points at `attempt_id`, never at the
question directly, and already has `version_number`/
`parent_response_version_id` for "multiple attempts, same or different
session, multiple saved versions." Zero changes needed there. `app.attempts`
needs #1's treatment (relax `content_item_version_id` to nullable, add
`byoq_item_id`); for a BYOQ attempt, `score_points`/`result_state` simply
stay null forever (never populated, per DECISION-0057) — no new branching
logic to write at the schema level, only a guarantee that no grading code
path is ever invoked for one (see the Decision below).

**4. `app.response_attachments` gets #1's treatment plus a real fix: a
`part_key` column and a `page_sequence` column.** Corrected after review:
**both must be `NOT NULL` with defaults** (`part_key DEFAULT 'whole'`,
`page_sequence DEFAULT 1`, existing rows backfilled at migration time) —
**not nullable**, because the live uniqueness rule
(`response_attachments_one_current_original`, confirmed: a partial unique
index on `response_version_id` alone today) treats NULL as distinct from
every other NULL. A nullable `part_key` would let a null-keyed row and a
`'whole'`-keyed row both be "current" at once, silently defeating the rule
it's meant to enforce. The corrected index is a **triple**:
`(response_version_id, part_key, page_sequence) WHERE kind='original' AND
is_current` — not a pair — because pages 1, 2, and 3 of one `'whole'` answer
must all be current simultaneously; only `page_sequence` distinguishes them.
`part_key` is `'whole'` for a single image or a multi-page continuous answer,
or a value matching the keys already used in `response_versions.response_parts`
(e.g. `'part_a'`) when an answer is split across distinct rubric parts.
Retake lineage (`replaces_attachment_id`/`is_current`) must scope "current"
per the full triple. This is a real rewrite of `bind_response_attachment`
(its `select … where response_version_id = … and is_current for update` and
`replaces_attachment_id` target check both need the triple) and of
`capture-pairing/index.ts`'s auto-supersede logic — not an additive column
add. Nothing today validates that `part_key` values agree with
`response_parts`' keys, or that `page_sequence` has no gaps, or tells a
reader whether all of an answer's expected parts are present — this plan
leaves "an answer's parts are complete" as a UI-level notion, not a DB
invariant, since BYOQ items have no rubric to check part completeness
against in the first place. **This fixes a gap that exists today for
library content too** (AP Biology FRQs are already noted elsewhere as
longer, multi-part, and this table has never supported that) — it isn't
BYOQ-specific, and should land as one shared migration regardless of which
Decision option below is chosen. Also update `response_attachments_guard_immutable_fields`
to protect the two new columns, the same as every other column recorded at
capture time.

**Note on future long-form content (e.g. AP Literature):** an extended essay
response is exactly the case `page_sequence` is for — several photographed
pages of one continuous answer, not a rubric-part split — so the schema
above already generalizes to it without further change. Item authoring/rubric
model differences for holistic long-form scoring (`rubric_type`,
`evaluator_strategy` already exist as columns on `content_item_versions`) are
a grading-pipeline concern, not a BYOQ-schema one, and don't block this task.

**Decision needed #1 (Product Owner), reframed, then reversed after a second
review pass (2026-09-26):** generalize the live tables in place, or keep
BYOQ on fully parallel tables? A same-day adversarial review of this exact
schema, checked line-by-line against the live migrations/functions rather
than taken on the plan's word, found Option D's "additive-only, one guard"
premise does not hold. Confirmed directly against Production before writing
this:

- `app.attempts.exam_pack_version_id` is **also** `NOT NULL` — a BYOQ item
  has no exam pack, so this needs relaxing too, not just
  `content_item_version_id`. Both `public.attempts` and `public.response_versions`
  (the PostgREST views a frontend would actually read) inner-join
  `exam_pack_versions → exam_packs → subjects`, so a BYOQ row with a null or
  fabricated pack reference either silently disappears from those views or
  pollutes pack-attempt counts, depending which way it's relaxed.
- **A concrete leak path exists today, confirmed by reading the actual
  function bodies:** `app.record_manual_grade` (the RPC the human-grading
  queue calls) checks only `status = 'submitted'` — no content check, no
  BYOQ awareness, nothing to stop it. `app.prevent_client_grading_truth_update`
  (the trigger that otherwise blocks grading-truth columns from being written)
  **explicitly exempts `service_role`** — the role every grading path,
  including this one, runs as — so it provides zero protection here. And
  `app.attempts_status_check` has no terminal "ungraded by design" status; a
  BYOQ attempt that reaches `submitted` sits in exactly the state the human
  grading queue (`attempt-response`'s `list_pending` operation) scopes on.
  Put together: under Option D, a BYOQ response photo reaching `submitted`
  status puts it in the real human-grading queue, with the student's name
  attached, one RPC call away from being graded — which is exactly what
  DECISION-0057 must never allow. Making Option D's "one guard" claim true
  would require a **new BEFORE UPDATE trigger on `attempts`, with no
  service_role exemption**, refusing any grading-truth write or `submitted`→
  `graded`/`uncertain` transition when `byoq_item_id IS NOT NULL` — not the
  single per-function guard the first draft of this section proposed.
- The question-photo role doesn't fit `response_attachments` cleanly under
  Option D either: it has no `attempt_id`/`response_version_id` to bind to,
  so it needs those two columns relaxed as well (plus `capture_pairing_tokens`
  relaxed on four columns, its single-literal `upload_purpose` check rewritten,
  and its `one_live_per_slot` uniqueness — keyed on `attempt_id` — redesigned)
  — meaning Option D still ends up needing a separate table for the
  question-photo role regardless, eroding most of its "reuse, don't
  duplicate" benefit.
- Two more concrete costs found: both `response_attachments_guard_immutable_fields`
  and `capture_pairing_tokens_guard_immutable_fields` would need updating to
  protect the new columns (else a bound attachment could be re-pointed to a
  different BYOQ item after capture), and this plan's own requirement that
  BYOQ photos stay owner-deletable (see #4 above) directly conflicts with
  `response_attachments`' storage policies and its BEFORE DELETE immutability
  trigger, which apply to every row in that table — Option D would need
  carve-outs in the exact policies that protect the graded path's integrity.

Given this, **the recommendation reverses: Option A (fully parallel tables)
is now the default**, not Option D:
- **Option A — fully parallel tables (recommended):** `byoq_items`,
  `byoq_responses`/`byoq_attempts` (an attempt/version/retake structure
  scoped to BYOQ only, sized to what BYOQ actually needs — nothing here is
  ever graded, disputed, or reviewed by a human queue, so it does not need
  to reach the full `attempts`/`response_versions` state machine, only the
  parts of it that give "multiple attempts, multiple saved versions, retake
  lineage"), and `byoq_attachments` (with `part_key`/`page_sequence` built
  in from the start, correctly as the triple described in #4). No shared
  code path exists for a guard to fail on, because there is no shared code
  path — the human-grading queue, `evaluate-attempt`, and `record_manual_grade`
  structurally cannot see a `byoq_*` row, full stop, rather than being
  trusted not to.
- **Option D — generalize in place (kept as a documented alternative, not
  recommended):** still possible, but the real cost is now named: relax
  `content_item_version_id`/`exam_pack_version_id` on `attempts`, relax
  `response_version_id`/`attempt_id` on `response_attachments` for the
  question-photo role, relax four columns plus rewrite one check constraint
  on `capture_pairing_tokens`, redesign `one_live_per_slot`'s uniqueness,
  rewrite `bind_response_attachment` and `capture-pairing`'s supersede logic
  for the new triple index, add a new non-`submitted` terminal attempt
  status, update two immutability triggers, carve BYOQ exemptions into the
  storage policies that currently protect every row uniformly, and add the
  new service-role-inclusive guard trigger described above. That is a large,
  multi-migration surface against live, real-student-data tables, not "a few
  additive columns."
- This task now defaults to **Option A**. If the Product Owner still prefers
  Option D's unified shape after weighing the above, treat
  `record_manual_grade`/`list_pending` exclusion of any BYOQ-sourced attempt
  as a required, tested blocking acceptance criterion before Phase 1 ships —
  not an assumption.

**Two smaller fixes from the same review pass, applicable under either
option:** (a) `byoq_items.code` needs an explicit uniqueness scope decided —
global uniqueness (matching `content_key`) makes another student's code
guessable as a "does this exist" oracle even though RLS hides the row
contents; per-student uniqueness avoids that at the cost of needing the
owner id to look one up. (b) wherever an attachment row's question reference
(`question_source`/`content_item_version_id`/`byoq_item_id`) is written, derive
it server-side from the attempt/response it's attached to rather than
accepting it as a caller-supplied parameter the way `bind_response_attachment`
currently accepts `p_content_item_version_id` — otherwise the two copies of
the reference (on the attempt and on the attachment) can disagree with
nothing enforcing they match.

### Phase 1 — Data model and typed/pasted intake (no photo, no worksheet)

- New migration: `app.byoq_items` — `id`, `user_id` (FK `app.profiles`),
  `code` (per the schema above), `item_type` (`mcq`/`frq`), `title`, `stem`,
  `choices` (jsonb array of `{choice_key, choice_text}` for MCQ — **no
  `is_correct` column exists on this table at all**, so there is no column to
  ever mis-grant; this is the "structurally impossible, not policy-dependent"
  approach `BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md` recommends),
  a taxonomy reference (join to the existing `app.taxonomy_topics`/
  `app.taxonomy_cells` the same way library content does, so a promoted BYOQ
  item can sit in the real CED structure later), `difficulty`, `status`
  (`draft`/`ready`/`archived`), `source_kind` (`typed`/`photo_single`/
  `worksheet_split`, for later phases), timestamps. RLS: owner-scoped
  select/insert/update only, no anon/public grant, no service-role-only
  answer columns to protect because none exist.
- **Apply the same free-text answer-leak heuristic and masking-by-default
  that `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md` §6 designs for
  worksheet-derived text to typed/pasted `stem`/`choices` text here too.** A
  student can paste "Answer: B" into a typed question exactly as a worksheet
  can print one, and no `is_correct`-style column protects against that
  channel — this was flagged during that document's review as a gap in this
  Phase 1 section specifically, not just a worksheet concern.
- Per Decision needed #1's default (Option A): a parallel `app.byoq_responses`
  (or `byoq_attempts`/`byoq_responses` as a pair, if retake lineage needs its
  own version history) — deliberately lighter than the full
  `attempts`/`response_versions` pipeline, since nothing here is graded,
  disputed, or reviewed by a human queue the way library attempts are. If the
  Product Owner instead chooses Option D, this becomes the generalized
  `app.attempts`/`app.response_versions` per the schema section above, with
  the additional guard trigger and terminal status named there as required,
  not optional, acceptance criteria.
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

### Phase 2 — QR photo capture: the question photo, and the hand-drawn answer photo

Two distinct capture roles, both needed, both durably linked to the same
`byoq_item_id` per the unified schema above:
- **`question` role** — the original photographed problem, captured at
  intake (what earlier drafts of this plan called Phase 2).
- **`response` role** — the student's hand-drawn work solving their own BYOQ
  item, captured later during Practice, structurally the same idea as the
  existing DRAWN_RESPONSE capture but for a BYOQ item instead of a library
  question. Additionally carries `response_version_id` (which specific
  attempt's work this documents) and, per the schema above, `part_key`/
  `page_sequence`.

Per Decision needed #1's default (**Option A**, parallel tables), both roles
share one new `app.byoq_capture_pairing_tokens`/`app.byoq_attachments` pair
with a `capture_role` discriminator column, under storage path
`<user_id>/byoq/<byoq_item_id>/...` — **not** a bare `byoq/` prefix; every
owner-scoped storage policy on `learner-uploads` (confirmed live) keys on
`split_part(name, '/', 1) = auth.uid()`, so the user id must be the first path
segment. Either way: deliberately **do not** add an immutability trigger or
exclude these objects from the existing owner update/delete storage policies
the way `response_attachments` does for DRAWN_RESPONSE — BYOQ photos are
ungraded and undisputed, and are the most likely object in the system to
contain third-party or personal material a student may later want to remove
(see "New gaps" below).

Since there's no OCR yet (below), start with the minimal slice of the QR
pattern for both roles — pairing token, signed upload, attachment row — and
skip the quality-check model call and append-only provenance-event stream
`capture-pairing` also has; those exist to support automated spatial grading,
which BYOQ has no analog of (a response photo is never graded, same as
everything else BYOQ).

- Once a question photo is uploaded, it needs to become a usable `byoq_items`
  row. No OCR vendor is decided or tested for this (the OCR research on
  record is entirely about *grading* hand-drawn responses, not transcribing a
  fresh question; the one open thread — a direct LlamaParse pilot for
  hand-drawn content — was never run to conclusion, per `docs/research/` and
  the 2026-08-18 vendor notes). **Recommended default for this phase: no
  blind OCR.** The student photographs the question, then types/pastes the
  transcription themselves (Phase 1's intake form), with the photo attached
  purely for their own/a reviewing teacher's reference. Treat OCR-assisted
  auto-fill as a fast-follow once a vendor is actually chosen and tested
  against real hand-drawn/photographed source material — not a Phase 2
  dependency. Note this means the question photo itself does no work yet
  (nothing reads it) — if that trade-off isn't worth this role's cost on its
  own, it can wait and ship alongside the OCR fast-follow instead of before
  it. The response-photo role has no equivalent OCR dependency — it's a
  reference image for the student (and, if promoted, a future human
  reviewer), not something anything needs to read automatically.
- A BYOQ item must exist (in `draft` status) before a question-role pairing
  token can be minted, since the token needs a `byoq_item_id` to bind to; a
  response-role token additionally needs a `response_version_id` to exist
  first. Decide and document this ordering explicitly in the edge function's
  contract, and add a sweep for abandoned drafts (minted, never scanned;
  scanned, never uploaded) — see "New gaps" below.

### Phase 3 — Worksheet upload, split into multiple questions

- **This phase's required design pass is now written:**
  `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md` (2026-09-26, Status:
  Proposed for review — not yet approved). It defines the split → candidate
  review → per-candidate confirmation flow (every candidate still goes
  through the existing single-question Confirm Capture/Confirm Match stages
  individually — a worksheet changes how a candidate is *proposed*, never how
  it's *accepted*), a staging data model (`byoq_intake_batches`/
  `byoq_intake_candidates`, holding parser output that is never itself a
  practice-ready `byoq_items` row), and — the risk that document specifically
  treats as more severe than anything in the single-question design — that a
  worksheet's embedded answer key can leak into a candidate's `stem` as free
  text, a channel the "no `is_correct` column" structural protection doesn't
  cover. Phase 3 does not start until that document is approved and its
  Decision needed #2 (parsing vendor) and remaining Open Decisions are
  resolved.
- Copyright/rights exposure is larger here than for a single typed question
  — a worksheet is more likely to be a teacher's or publisher's original
  material photographed wholesale; the design doc's §8 covers this.
- Out of scope for this task until that design doc is approved.

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
(now reframed as Option D — generalize `attempts`/`response_versions`/
`response_attachments` in place — vs. Option A — parallel `byoq_*` tables;
see "Question identity, answer capture, and image linking" above) and, before
Phase 3 starts, a separate approved design doc resolving Decision needed #2.
This draft has been through two adversarial review passes (see "Corrections
from adversarial review" above, and the 2026-09-26 schema addition, itself
pending its own review) — neither is a substitute for Product Owner approval.

## Implementation Notes

Primary records this task builds on:

- `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`,
  `docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`,
  `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md` (Phase 3's required design
  pass), `docs/tasks/UX-004-STUDENT-PROVIDED-QUESTION-INTAKE.md`,
  `DECISION-0057`.
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
