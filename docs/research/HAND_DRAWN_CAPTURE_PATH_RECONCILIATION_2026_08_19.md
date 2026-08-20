# Hand-Drawn Capture Path Reconciliation — Scope Note

**Written:** 2026-08-19
**Status:** Proposed design note, not an approved plan. No DECISION or APPROVAL entry exists
for anything in this document.
**Trigger:** Engine 4 production-design work (`docs/research/ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`
§7/§8 item 7) names "unblock the QR capture → canonical content path" as a hard prerequisite
before Engine 4 can grade anything real. Investigating that surfaced two independently-built,
never-reconciled capture systems — this note exists to lay out the choice before anyone builds
on top of either one.

**Correction (same day, before this note was ever reviewed): this is not an open product
decision.** `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` (Hard-Gate, owner-approved
2026-07-08 via `APPROVAL-0033`) already resolved this — RESOLVED decision #10: **"Engine 4 MVP:
QR handoff capture. Direct upload and other capture options are post-MVP."** The Phase D
execution prompt (`prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md`, which names
Claude the accountable execution owner for exactly this work) states the sequence as
non-negotiable architecture ("Do not replace this sequence with a new plan") and Stage D2 is
titled, verbatim, "Implement and verify the QR capture MVP." The program ledger
(`docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md` line 289) independently restates the same
rule: "Continue Engine 4 only through its planned QR → observation → gold → abstention → shadow"
sequence, no shortcuts. §4/§5 below are corrected in place to reflect this — the earlier draft of
this section (which treated capture-method choice as unresolved, pending a "QR-materiality"
study) was wrong, and is left below only for its evidence, not its conclusion.

Evidence-class labels follow repo convention (Live verified / Deployed verified / Repository
only / Prototype-research only / Proposed / Not verified). All backend claims below are from
direct file reads of this repo plus `docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md`
(Deployed verified — that task's own acceptance criteria and QA record). All frontend claims are
from direct file reads of the `exam-buddy-wireframe` worktree at `.worktrees/task0019-frontend`
(2026-08-16 checkout; `origin/main` is newer as of 2026-08-18 — re-verify before relying on this
for anything beyond scoping).

---

## 1. Current verified state — two systems, not one

### System A — `CaptureItem.tsx` / `capture_sessions` (the deployed student path)

- Lives on the real, reachable `/session` route (`src/components/session/CaptureItem.tsx`,
  `src/lib/capture.functions.ts`, `src/lib/capture-schema.ts`).
- Built 2026-08-15, commit `64cf23ca3` ("Build QR-materiality Round 1: device-capability
  instrumentation") — genuinely functional, not a mock: mints a one-time pairing token, renders
  a QR code, the phone leg gets a real Supabase Storage signed upload URL (bucket
  `capture-research`, path `<user_id>/<token>/raw-<ts>.<ext>`), and a **real Gemini vision call**
  (`google/gemini-2.5-flash` via the Lovable AI gateway) judges capture quality
  (`looks_ready`/`retake`/`cannot_determine`) — this quality check is real and does not exist
  anywhere in System B.
- State lives in a `capture_sessions` table queried directly by the frontend's own Supabase
  client (`context.supabase`/`supabaseAdmin`) — no migration file for this table was found
  anywhere in either repo's `supabase/migrations/`; it was apparently created outside the normal
  migration flow (Not verified — could not confirm which project/schema it actually lives in
  without direct DB access).
- **On submit, `submitCapture` deletes the image bytes immediately** (`capture.functions.ts:333-356`)
  and `CaptureItem.tsx` hands the session runner a literal placeholder string —
  `[hand-drawn capture submitted — capture:${session.id}]` — which flows into the ordinary
  text-response pipeline. **No image is ever preserved for grading.** This is by explicit design,
  not a bug: `capture-schema.ts`'s own header comment says "This is a research surface: no graph
  grading, no production upload controls. Only capture-quality is real (Gemini vision);
  everything else is honest scaffolding for usability research."
- Never calls `attach_capture` or touches `app.response_attachments`.

### System B — `SameDeviceCapture.tsx` / `app.response_attachments` (the pilot path, TASK-0025)

- Built the same day (2026-08-15), same session, as an explicit answer to a narrower Product
  Owner goal: "get to the point where a real student can submit a hand-drawn answer and receive
  a real graded response." Deployed verified on both Development and Production as of 2026-08-18
  (migration `20260818011720_response_attachments_fixes.sql`, `attempt-response` v23 on
  Production).
- Backend is genuinely complete: `attach_capture` operation (`attempt-response/index.ts:604-833`)
  downloads the real uploaded bytes, re-derives media type/dimensions/SHA-256 (never trusts
  client-declared values), snapshots and re-checks a storage fingerprint immediately before an
  atomic `bind_response_attachment` RPC, and writes to `app.response_attachments` — a real,
  immutable, RLS-protected, retake-lineage-aware table. TASK-0025's independent 8-angle QA review
  found and fixed 8 real defects (retake-breaks-everything, a storage TOCTOU race, a manual/auto
  grading race, an unbounded PNG-dimension crash, an unguarded DELETE, dead code, a duplicated
  type) — all confirmed fixed and re-verified against Production with rolled-back SQL.
- Frontend is `SameDeviceCapture.tsx` — deliberately minimal: a plain
  `<input type="file" capture="environment">` with preview/retake, **no QR pairing, no separate
  device, no quality check of any kind**. Reachable only via an unlinked, admin-gated route
  (`/hand-drawn-pilot`), against exactly one content item
  (`APBIO-HDG-2026-GRAPH-002`, still `label_status: ai_provisional_unapproved`).
- Grading is manual-only through a second admin-only page (`/admin/grade-response/$attemptId`),
  not automated — this pilot slice is intentionally about proving the binding/preservation
  chain, not about Engine 4 accuracy.
- **Confirmed 0 rows ever written** to `app.response_attachments` or `grading_results` with
  `model_id = 'manual-review'` in Production as of the 2026-08-18 deploy — this pipeline has
  never been used by anyone, real or test, end to end with real credentials.

### Why they diverged

TASK-0025's own record makes this explicit, not a mystery: System A predates System B in the
same session, was scoped as instrumentation/research ("QR-materiality device matrix... this task
does not decide whether QR remains mandatory for the general (non-pilot) capture experience" —
TASK-0025 "Out of Scope"), and System B was built afterward, deliberately bypassing System A and
`/session` entirely, to get one honest vertical slice working end to end. Nobody has since gone
back to unify them — TASK-0025's own final "Not done" line names exactly this gap: "Product Owner
decision on sequencing the remaining Program B slices (QR-materiality matrix, capture-quality
mechanism, fixing the placeholder `/session` pipeline for real content)."

---

## 2. What each system has that the other lacks

| Capability | System A (`CaptureItem`/QR) | System B (`SameDeviceCapture`/pilot) |
|---|---|---|
| Reaches a real (if currently 0-traffic) student route | Yes — live on `/session` | No — unlinked, admin-gated |
| Preserves the image for grading | **No — deletes on submit** | Yes — immutable, RLS-protected, retake-lineage-tracked |
| Server-side validated bytes (digest/dimensions/type) | No | Yes, with an independently-QA'd fix history |
| Automated capture-quality check | Yes — real Gemini vision call | No |
| Cross-device (phone-photographs-paper) capture | Yes — QR pairing to a phone | No — same-device file input only |
| Retake handling | Partial (state machine exists; bytes are discarded regardless) | Yes, atomic, race-safe (post-QA-fix) |
| Grading path wired to the result | No (placeholder string, text pipeline) | Yes (manual-only, via `record_manual_grade`) |
| Multi-item / non-pilot content | Yes, in principle (any `/session` item) | No — hardcoded to one pilot item client-side |

Neither system alone is "the answer." System A solves capture *ergonomics* (a phone is a much
better camera than a laptop) and has the only real quality gate, but throws away its own output.
System B solves *preservation and grading integrity* but has no camera-quality story and no
route to real content or real students.

---

## 3. Reconciliation options

**(a) Merge: keep System A's QR/phone/quality-check UX, swap its terminal action from
"delete bytes, emit placeholder" to "call `attach_capture`."**
Concretely: after `checkCaptureQuality` returns `looks_ready` (or the student proceeds anyway
after a `retake` warning), `submitCapture` would upload/hand off to `attach_capture` instead of
`storage.remove()`, and `CaptureItem.tsx`'s `onSubmitted` callback would need to change from a
placeholder string to whatever the session runner needs to reference a real attachment (a
`response_attachments.id`, most likely, propagated the same way `save_response`/`submit_response`
already handle text). This keeps the only tested quality gate and the only cross-device flow,
and gets real preservation. Cost: two different storage buckets/paths (`capture-research` vs
`learner-uploads`) and two different tables (`capture_sessions` vs `response_attachments`) would
both need to stay alive during the merge, or `capture_sessions` gets retired and its
token/pairing/polling logic gets rebuilt against `response_attachments`-shaped state — the token
pairing and quality-check machinery has no equivalent in System B today. Genuinely more
engineering than it looks: the phone leg is unauthenticated (token-gated), so wiring it to
`attach_capture` (which is `attempt-response`, an authenticated-caller operation per TASK-0025)
needs either a new token-scoped variant of that operation or a bridge that verifies the token
server-side and calls it with a service-role/on-behalf-of pattern — TASK-0025's own QA found
finding #7 (dead admin-attach-on-behalf-of-student code) precisely because this kind of path
doesn't cleanly exist yet.

**(b) Retire System A, promote System B, add a quality check to System B later.**
Simplest to reason about: one storage location, one table, one validated code path, already
QA'd and deployed. Loses the QR/phone-camera ergonomics (`SameDeviceCapture` is same-device
file-input only — a laptop-only student would need to email/AirDrop a phone photo to themselves
first, which is a real usability regression the QR flow exists to avoid) and loses the only
built quality gate (a bad photo would reach `attach_capture`'s byte-validation, which checks
that bytes are a *valid image*, not that they're a *legible* one — completely different
concerns). Cheapest to build; likely the wrong tradeoff if cross-device capture matters for the
target student population (this is exactly the open "QR-materiality" question TASK-0025 deferred
— see §4 below).

**(c) Retire System B's frontend, keep its backend; rebuild System A's frontend to call it.**
A variant of (a) that's more honest about scope: don't try to preserve `capture_sessions` at
all. Rebuild the QR-pairing/phone-camera/quality-check UX from scratch against
`response_attachments`/`attach_capture` as the only backing store, using `SameDeviceCapture`'s
already-QA'd binding logic as the target contract instead of trying to bridge two schemas. More
work than (a) short-term (a real rewrite, not a splice) but avoids permanently running two
storage systems in parallel and avoids inheriting `capture_sessions`' unclear provenance (§1,
"Not verified" note on where that table actually lives).

**(d) Do nothing yet; make System A's placeholder-and-delete behavior an explicit, visible
"research only" gate instead of a silent no-op.**
Not a real reconciliation — a stopgap if the owner wants to defer this decision. Concretely:
show the student "this capture step is not yet connected to grading" rather than silently
discarding their photo behind a normal-looking "Submit" button. Buys time without misleading
current low/zero-traffic users, but doesn't move Engine 4 closer to gradeable real photos.

---

## 4. Corrected: QR is the approved architecture; System B is the deviation

The earlier draft of this note treated "does QR/cross-device capture matter" as an open,
unanswered product question and cited TASK-0025's own deferral of a "QR-materiality device
matrix" as evidence of that. That deferral is real (TASK-0025 explicitly declined to decide
whether QR stays mandatory for the *general, non-pilot* experience) but it does not reopen
TASK-0016's already-approved MVP decision — TASK-0025 deferred a *future refinement* of an
already-settled choice, it did not un-settle it. Nothing in TASK-0025, System A's build, or
this investigation carries the authority to override a Hard-Gate `APPROVAL-0033` decision;
that requires an explicit new owner decision, recorded the same way (a DECISIONS_LOG entry, as
`DECISION-0046` did when it retired TASK-0016's latency gate) — not a scope note treating the
prior decision as if it had lapsed.

That reframes what System B (`SameDeviceCapture`, TASK-0025's pilot) actually is: **a deviation
from the canonical Phase D sequence, not an alternative candidate for it.** It bypassed QR
capture entirely, was built without executing Stage D0 (state recovery/freeze — confirmed: the
required `docs/research/grading_phase_d_spatial_2026_07_27/` directory the Phase D prompt
mandates does not exist anywhere in this repo, meaning Phase D has never formally started per
its own process) or any of Stages D1-D6, and introduced a manual-grading side-mechanism
(`record_manual_grade`) that has no counterpart in the Phase D spec at all. TASK-0025 is honest
about this in its own text ("the pilot route deliberately bypasses `/session` rather than
repairing it") but does not connect that choice back to TASK-0016/Phase D's controlling
architecture — worth naming explicitly rather than letting the pilot quietly become a second
source of truth for capture design.

This does not mean System B's engineering is wasted — quite the opposite: its
`attach_capture`/`app.response_attachments` binding layer is real, deployed, QA'd infrastructure
that Stage D2 needs regardless of front-end (D2 requirement #6 is literally "server validates
and stores the immutable original privately," which is exactly what System A's `submitCapture`
currently fails to do). The deviation is in the *frontend capture UX* (same-device file input
instead of QR handoff) and in *sequencing* (skipping D0/D1 straight to a pilot), not in the
storage/validation backend, which is a legitimate asset for Stage D2 regardless.

---

## 5. Recommendation

1. **Do not treat capture-method choice as open.** QR handoff is the approved MVP (TASK-0016
   RESOLVED #10). If there's a real reason to reconsider it now (e.g. System A's Gemini quality
   check or System B's engineering effort changed the calculus), that is a new decision for the
   Product Owner to make explicitly and log — not something this note or any future session
   should infer from code evidence alone.
2. **The actual next step is Stage D0** (recover and freeze actual state) exactly as the Phase D
   execution prompt specifies — it has never been run. Its own deliverables
   (`CURRENT_STATE.md`, `ARTIFACT_INVENTORY.json`, `DECISIONS_AND_BLOCKERS.md`) would naturally
   absorb this note's System A/System B inventory, log System B's deviation from the canonical
   sequence explicitly (per D0 item 4's artifact classification and item 6's reconciliation
   step), and give the Product Owner a single place to see both efforts before Stage D2 work
   continues.
3. **Stage D2 itself, once resumed, needs to close System A's core defect**: it implements QR
   handoff but violates D2 requirement #6 by deleting the original instead of storing it. The
   fix is to bind System A's QR/quality-check flow to System B's already-built, already-QA'd
   `attach_capture`/`response_attachments` layer (reconciliation option (a) from §3 above) —
   not to retire QR (option (b), which contradicts the approved MVP) and not to promote System
   B's frontend to general use (it was never scoped as the general capture experience).
4. **Sequencing dependency, unchanged from the original draft:** the pilot item's
   `ai_provisional_unapproved` label still needs normal content review, and Program C's
   "operationalize manual grading" gap (TASK-0020) still needs its own sequencing decision — both
   independent of the capture-frontend question resolved above.

This does not require a new Product Owner decision on *whether* to use QR — that's already
decided. It does require: (i) explicit acknowledgment/logging of System B's deviation, (ii)
running Stage D0 before further capture engineering, and (iii) confirming there's no appetite to
formally revisit decision #10 given what's now known, before Stage D2 resumes.

---

**See also:** `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` (the controlling Hard-Gate task;
RESOLVED decision #10 settles QR-vs-direct-upload), `prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md`
(the non-negotiable Phase D execution sequence — QR MVP is Stage D2, state-freeze is Stage D0,
neither has been run), `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md` (controls phase
status when older docs conflict; line 289 restates "no shortcuts" for Engine 4),
`docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` (parent handoff doc),
`docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md` (source of record for System B,
built as a pilot outside the Phase D sequence), `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`
(research-gate status, still Pending), `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`
(the 13-state contract both systems partially implement), `docs/tasks/TASK-0020-IMAGE-AND-DRAWN-RESPONSE-LAUNCH-READINESS.md`
(Program B/C launch-blocker framing), `docs/research/ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`
§7/§8 (the Engine 4 sequencing that made this reconciliation a blocker worth surfacing now).
