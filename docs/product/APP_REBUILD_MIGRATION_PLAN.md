# App Rebuild Migration Plan — exam-buddy-wireframe → Cramapple

STATUS: draft for Product Owner review | DATE: 2026-09-22 | OWNER: unassigned (see §9)

Companion to [`DESIGN_SYSTEM_CUTOVER_PLAN.md`](./DESIGN_SYSTEM_CUTOVER_PLAN.md).
That document compares the two design systems and asks what the cutover should
be. This one answers a narrower question David has since settled: **the app is
rebuilt new against the design system rather than reskinned in place**, and this
plan names what that costs — route by route, feature by feature, and against the
real content.

Everything below was read from the two repositories and the production database
on 2026-09-22, not from memory or from the earlier planning docs.

---

## 1. The decision this plan implements

David's sequence, in order. **The modes consolidate into one surface first —
see §3a, which reframes §4 and reorders §9.**

1. **Rebuild the app** against the new design system, wired to the existing
   backend. This plan's §4–§6 are the gap analysis for that phase.
2. **Reskin the marketing pages** to the design system **without breaking the
   URL structure.** Mostly a visual pass, not a rebuild.
3. **Update the Stripe flow** to the design system, then adjust on tester
   feedback.
4. **Design and deploy a new home page**, last.

The repo split is already underway: the Cramapple Lovable project was remixed
into `New Cramapple App` and `New Cramapple Marketing` (both created 2026-09-22,
code copied, no other changes).

### Why a rebuild rather than a reskin is defensible here

The usual objection to a rewrite — don't discard working software that has users
— does not apply. Production, read 2026-09-22:

| Measure | Value |
| --- | --- |
| Total accounts | 36 |
| Signed in, last 7 days | **0** |
| Distinct users who have ever submitted an attempt | **4** |
| Attempts, all time / last 30 days | 101 / 53 |
| Gradings, all time | 78 |
| **Purchased** entitlements | **0** (283 entitlements exist; all trial, grant or backfill) |
| Stripe checkout sessions, all time | 5 |

There is no revenue and no weekly active usage to protect. The cost of the
rebuild is engineering time, and that is the only cost.

**This is also the strongest argument for doing it now rather than later.** The
number that makes a rewrite cheap today is the number a launch is meant to
change.

---

## 2. What exists today

`david-bloom/exam-buddy-wireframe` at `053c37d`: TanStack Start + React +
TypeScript, shadcn/Radix UI, Tailwind, Supabase client. 242 `.tsx` and 160 `.ts`
files. **141 route files.**

| Route group | Count | Phase |
| --- | --- | --- |
| SEO subject content (`ap-biology/*`, `ap-statistics.*`, `ap-physics.*`, …) | 50 | 2 — reskin, URLs preserved |
| Student app (session, setup, progress, homework) | 22 | **1 — rebuild** |
| Beta / proto / dev (`beta.*`, `_authenticated/proto.*`, `dev.*`, `style-guide`) | 18 | Retire (§7) |
| Reviewer / admin (operational) | 13 | **Not migrating (§7)** |
| Marketing (`index`, `about`, `how-it-works`, `blog`, `compare/*`, legal) | 12 | 2 — reskin; `index` is phase 4 |
| Auth / account | 10 | 1 (login/account) + 2 (public-facing) |
| Internal dashboards (`prototype.dashboard.*`) | 6 | **Not migrating (§7)** |
| Hand-drawn capture | 4 | **1 — rebuild, undesigned (§5)** |
| Commerce (`checkout.*`, `plan`) | 4 | 3 |
| Framework (`__root`, layout routes) | 2 | n/a |
| **Total** | **141** | |

### The backend is not in scope and does not move

All 16 edge functions already live in this repo under `supabase/functions/`.
The current app calls six of them on the student path — `attempt-response`,
`evaluate-attempt`, `student-session-items`, `session-items`, `session-event`,
`capture-pairing` — plus four on the reviewer path. **The rebuild re-implements
callers against an unchanged contract.** Nothing in `supabase/`, the grading
engines, the content packages or the migrations is touched by any phase here.

That is what makes the rebuild bounded: the risky, security-sensitive half of
the product is already on the correct side of the line.

---

## 3. What the new design system actually covers

Extracted from four templates (Open Hand FRQ, FRQ, Open Hand MCQ, MCQ) plus an
invented Home. As implemented in `web/` (PR #152): 19 components, five screens.

**Covered:** the question plate — FRQ and MCQ, each in Practice and Open Hand —
and a home / study map. Rubric display, answer key, the hint economy, the
feedback card, verdict and score chips, the deep dive overlay, breadcrumb and
study map.

**That is five screens against 141 routes.** Everything in §4, §5 and §6 below
is a gap.

---

## 3a. The modes consolidate — and the plate is the consolidated surface

**Added 2026-09-22 after David reported the student finding.** This reframes
most of §4 and reorders §9, so it sits before the gap analysis rather than
inside it.

Students do not experience Homework Mode, Course Mode and Learning Mode as
different products. They read as the same thing. That signal is already on
record — `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §0, dated 2026-09-17 and
twice externally reviewed — and it is already **DECIDED** there (§1): one mode,
working name **"Learn"**, replacing the Course/Homework split entirely, with
**bring-your-own-question as the default entry** and Cramapple-directed
practice as the secondary one.

What is new here is the connection to the design: **the question plate is that
one surface.** Neither the design system nor the consolidation plan says so —
the plan predates the design work, and the design system was extracted from four
question templates with no knowledge of the mode question. Writing it down is
what stops someone building a third thing.

### 3a.1 The two plans already agree, under two different meanings of "open hand"

This is a naming collision worth catching before it becomes a bug.

| Term | Where | What it means |
| --- | --- | --- |
| "open-hand teaching" | `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §2 | a **pedagogical sequence**: skill explainer → worked example shown open-hand → the student's own cold attempt |
| "Open Hand" | the design system, and `web/` | a **plate mode**: the rubric or answer key is face-up and manipulable, nothing is scored |

They are not the same thing, and they fit together exactly:

- The **Open Hand plate is the worked-example step.** Rubric face-up,
  manipulable, nothing scored — a demonstration, which is what a worked example
  is.
- The **Practice plate is the cold-attempt step.** Scoring withheld behind a
  hint that costs something, one submission, then criterion-level feedback.

So the design system's two modes are not a third mode system competing with
consolidation — they are the two halves of the teaching sequence the
consolidation plan calls "the hinge." **Recommendation:** rename in the design
system's language rather than the plan's, or vice versa, but do not ship both
names. `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §10 item 12 already has naming
open.

### 3a.2 What the consolidation removes from this plan, and what it adds

**Removes.** Mode selection as an IA concept: no mode picker, no per-mode
routes, no "which mode am I in" chrome. §4.5's setup and topic-selection
surfaces shrink accordingly, and `_ux.setup.subject` in particular may not
survive at all.

**Adds — and this is the part that increases Phase 1 scope, not decreases it.**
If BYOQ is the *default* entry to the one surface, then BYOQ intake is core to
Phase 1, not a late item. The design system has **no design for it**: pasting or
photographing a question, the closed-form classification confirm ("is this
Topic 3.9?"), the coverage-gap response when no vetted parallel item exists, and
the hand-back of the student's own question unsolved. All of that is specified
in `HOMEWORK_MODE_DESIGN_2026_08_28.md` and none of it is drawn.

### 3a.3 Diagnostic and exam cram come after

David, 2026-09-22: the **diagnostic and exam-cram path is added only after the
homework/course path ships.**

This partially answers `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §10 item 3
(Points/Cram's fate): a cram-proximate path **survives** rather than dissolving
into automatic backend pacing, and it is sequenced second. It does not answer
the commercial half of §7 — category, promise, pricing — which stays Product
Owner and Micah territory.

"Diagnostic" is new vocabulary; it does not appear in the consolidation plan.
It reads as the answer to that plan's §10 item 11 — the cold-start problem,
where a student arriving days before an exam has no mastery history for
`LEARN-006`/`LEARN-007` to work from. If that is the intent, saying so closes a
decision that is currently open by default.

### 3a.4 One caveat, because the plan itself raises it

`COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §10 item **1** — the top-priority open
decision — asks that the evidence behind the student signal be documented
(sample size, how students were asked, stated preference vs. observed behavior)
**before any of the decisions resting on it are treated as settled**, BYOQ-primary
included. That is still open. This rebuild is about to be sequenced around that
finding, which raises the cost of it being wrong. Recording the evidence basis
is cheap now and expensive after Phase 1.

---

## 4. Functional gaps — Phase 1 (the app)

**Revised 2026-09-22 per §3a.** The gaps below are unchanged as *work*; what
changed is how several of them are framed.

These exist in the current app, are used, and have **no design treatment**.
Each needs a design decision before it can be rebuilt.

### 4.1 Course Mode session UI — 7 components, shipped, live pilot

`SkillRail`, `ConfirmTransferBeat`, `CourseModeRepairPanel`, `RepairBlock`,
`WorkedExample`, `LessonOpener`, `StreakBadge`.

This is the most recently hard-won work in the product — the Aug 27 pilot took a
five-fault chain to get serving. None of these concepts exist in the four
extracted templates. The learn-first door, the skill rail, the confirm-transfer
beat and the repair ladder are the pedagogy the design system was *not* shown.

**Largest single gap in this plan.** Rebuilding the plate without it ships a
worse product than the one being replaced.

**Consolidation does not shrink this gap — it re-homes it (§3a).** Merging the
modes is an information-architecture decision. It retires the *mode chrome*: the
picker, the per-mode routes, the "which mode am I in" framing. It does not
retire the *mechanics*, and the consolidation plan is explicit that it doesn't:
§1 keeps the cell-based mastery queue and the skills rail as the
Cramapple-directed entry, and §2 makes the worked-example sequence "the one
teaching mechanism both entry points route into."

So these seven components mostly survive — as parts of one surface rather than
one mode's furniture. The mapping to settle before building:

| Component | Under consolidation |
| --- | --- |
| `SkillRail` | Becomes the Cramapple-directed entry (plan §1, secondary entry) |
| `LessonOpener`, `WorkedExample` | Become the open-hand teaching step (plan §2) — see §3a.1 |
| `RepairBlock`, `CourseModeRepairPanel` | The repair ladder; survives, needs a design |
| `ConfirmTransferBeat` | Survives; where it fires in a BYOQ-first flow is undecided |
| `StreakBadge` | Survives or is dropped — a product call, not a design one |

**Reading "merge the modes" as "drop these" is the way this rebuild ships worse
pedagogy behind better visuals.** That is the risk in §10 item 2.

### 4.2 Hand-drawn capture — 4 routes, Engine 4 infrastructure

`CaptureItem`, `SameDeviceCapture`, `capture-phone`, `capture-demo`,
`hand-drawn-pilot`, `hand-drawn-responses`, and the `capture-pairing` edge
function.

The QR handoff shipped 2026-08-20 and is the *only* capture path (DECISION-0051
ruled out a direct-upload fallback). The design system has one camera icon and
an "attach hand-drawn work" affordance in `AnswerField` — a button, not a flow.
The phone-side capture screen is entirely undesigned, and it is inherently a
mobile surface, which collides with §8 decision 1.

### 4.3 Progress and dashboard

`_ux.progress` is 708 lines — the largest route in the app. Plus `dashboard`.
The design system has a study map with per-topic dots and nothing else.

### 4.4 Bring-your-own-question — no longer a mode, now the default entry

`bring-question`, `byoq`, `check-work`, `ask`, `ask-parent`, and the
`homework-help` components. Designed in `HOMEWORK_MODE_DESIGN_2026_08_28.md`,
governed by CM-D20 — and not visually designed at all.

**Re-prioritised 2026-09-22 (§3a.2).** This was the last item in the Phase 1
order. Under consolidation BYOQ is the *default* way into the one surface, so it
moves early — and it is the largest undesigned surface in Phase 1:

- verbatim paste intake (photo and worksheet upload are later per the design doc)
- the closed-form classification confirm — "are you talking about Topic 3.9?" —
  which is an anti-gaming mechanism, not a convenience
- the coverage-gap response: name the skill and defer, **never** generate a live
  substitute item (CM-D20)
- handing the student's own question back unsolved after the parallel open-hand
  item
- the Check My Work unlock gate, whose threshold is still open

None of that has a design. It needs one before it can be built, and it is on the
critical path in a way it was not when this document was first written.

### 4.5 Setup, onboarding and topic selection

`setup.index`, `setup.subject`, `setup-paused`, `onboard`, `topic`. Note
TASK-0029 already moved the home quick-start door to bypass `/session/setup`;
the rebuild should not reintroduce a setup page the product decided to drop.

**Shrinks under consolidation (§3a.2).** With no modes there is no mode
selection, and `setup.subject` may not survive at all. What remains is subject
and exam-date capture, which is smaller than these five routes suggest.

### 4.6 Session chrome and states

`SessionFrame`, `SessionShell`, `SessionHamburgerMenu`, `SessionParamsBar`,
`TopContextBar`, `RecheckDialog`, `ReportQuestionButton`, `session.complete`,
`session.uncertain`. The design system's `Masthead` + `Breadcrumb` replace part
of this; the rest — report a question, recheck, session completion, the
uncertain state — has no equivalent.

### 4.7 ConfettiBurst

The design system defines `--motion-duration: 0ms` and states "no transitions,
no fades, no bounces." The current product has a deliberate celebratory moment.
This is cutover plan §7 decision 3 and it is a real product question, not a
token value.

---

## 5. Content gaps — and the one that should change the sequence

This is the part most likely to be missed, because it does not show up in a
route inventory.

### 5.1 Every real FRQ is multi-part. The plate renders one part.

330 item packages on disk, profiled 2026-09-22:

| | |
| --- | --- |
| Items | 330 (190 MCQ, 140 FRQ) |
| FRQs with 1 part | **0** |
| FRQs with 2 / 3 / 4 parts | 74 / 25 / 41 |
| Response modalities | `choice` 190, `typed-text` 387, **`typed-math` 295** |
| Stimulus kinds | `text` 230 (no image stimulus in any package) |

**Every FRQ in the content library has between two and four parts.** The four
design templates were built from single-part AP Statistics questions, and the
`web/` implementation inherits that: one stem, one `AnswerField`, one flat
rubric. There is no design for part (a)/(b)/(c) navigation, per-part scoring, or
carrying a part's answer into the next part's prompt.

**295 response slots want typed math.** The design system reserves STIX Two Math
for *displaying* set mathematics; there is no math input component, and the
no-scroll plate is an unforgiving place to put an equation editor.

### 5.2 The design system has never been rendered against real content

The sample content throughout the design system and `web/` is **AP Statistics
Unit 2, hand-written.** There are **zero AP Statistics item packages** in the
repo, and **zero AP Biology ones** — the library is precalculus, calculus AB/BC,
physics ×4 and chemistry.

So the plate has been validated against content that does not exist, for two
subjects that have no items, while the 330 items that do exist are longer,
multi-part and math-heavy.

**Recommendation:** before building further screens, render the existing plate
against ten real item packages — a 4-part calculus FRQ and a physics MCQ are the
honest stress tests. This is a day of work and it will either validate the fixed
frame or kill it. Doing it after the app is rebuilt is the expensive order.

### 5.3 SEO URL inventory (Phase 2 prerequisite)

50 subject-content routes plus 12 marketing routes carry the public URL surface
that Phase 2 must preserve. Organic acquisition is not currently working (one
new account in 30 days), but the URLs have option value and re-earning an index
is slow. Before the reskin, export the full path list from `routeTree.gen.ts`
and treat it as a contract with a redirect map for anything that must change.

---

## 6. What transfers cleanly

Not everything is a gap.

- **The entire backend.** 16 edge functions, grading engines, entitlements,
  content packages, migrations — untouched (§2).
- **The data model.** `attempts`, `attempt_responses`, `grading_results`,
  `learning_sessions`, `subject_entitlements` and the item-package schema are
  the same on both sides. `web/src/content/` already mirrors the package shape.
- **Auth.** Supabase Auth; config is server-side. Login and reset screens are
  small and the design system's form treatment covers them.
- **Pedagogical copy posture.** Name the error, don't judge the student;
  one-word verdicts; second-person imperative. Compatible with, and more precise
  than, the current product's tone.
- **Marketing content.** The `src/content/` prose and the `marketing/`
  components are structure plus copy; Phase 2 restyles the shell, not the words.

---

## 7. What is not migrating

Deliberately left on the current app, to be retired or rehomed separately.

**Reviewer / admin — 13 routes plus 6 internal dashboards. Do not cut this
before a replacement exists.** The content pipeline's double-approve
publication rule runs through `reviewer.review.$assignmentId`,
`reviewer.gold-set.*`, `reviewer.submissions` and `admin.grade-response`.
Content authoring is the product's actual bottleneck; breaking the reviewer's
tool to ship a student-facing redesign is a bad trade. These are internal,
low-traffic and not student-facing, so they can stay on the old stack
indefinitely. **Keep `exam-buddy-wireframe` deployed for this reason alone
until it is rehomed.**

**Beta / proto / dev — 18 routes.** `beta.*`, `_authenticated/proto.*`,
`dev.celebrations`, `style-guide`. Confirm nothing live depends on them, then
delete rather than migrate. `style-guide` is superseded by
`.claude/skills/cramapple-design/guidelines/`.

---

## 8. Open decisions

Carried from `DESIGN_SYSTEM_CUTOVER_PLAN.md` §7, with status updated.

| # | Decision | Status |
| --- | --- | --- |
| 1 | **Fixed 1440×900 frame vs. responsive** | **OPEN — blocking.** See below. |
| 2 | Visual-identity brief v2 status | **Resolved.** Superseded; `docs/new_design/` is canonical (PR #152). |
| 3 | Motion — `ConfettiBurst` exception or not | OPEN (§4.7) |
| 4 | Scope for v1 | **Resolved.** App first, then marketing, Stripe, home page. |
| 5 | Logo | OPEN — ships with the type wordmark unless resolved |
| 6 | Dark mode | **Resolved.** Retired 2026-09-21, light only. |
| 7 | Owner / Task ID for this work | OPEN (§9) |
| 8 | Cross-subdomain auth handoff (`.cramapple.com` cookie scope) | OPEN — foundational to both projects |
| 9 | Route mapping, shared vs. duplicated code | Partly answered by §2's table; the auth-requirement audit is still owed |
| 10 | Repo-split vs. cutover sequencing | **Resolved.** Split first (remixes exist), then rebuild. |
| 11 | **Multi-part FRQ and typed-math treatment** | **NEW — OPEN, blocking Phase 1.** (§5.1) |
| 12 | Mode consolidation into one surface | **Resolved.** Already DECIDED in `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §1; the plate is that surface (§3a). |
| 13 | Diagnostic / exam-cram sequencing | **Resolved.** After the homework-course path (§3a.3). Partially answers consolidation §10 item 3; the commercial half stays open. |
| 14 | **"Open Hand" means two different things** | **NEW — OPEN, cheap.** Plate mode vs. teaching sequence (§3a.1). Pick one vocabulary before either ships. |
| 15 | **BYOQ intake has no design** | **NEW — OPEN, blocking Phase 1 step 3.** (§4.4) |
| 16 | **Student-signal evidence basis** | **OPEN — upstream of 12 and 13.** Consolidation §10 item 1 asks for it before these are treated as settled (§3a.4). |
| 17 | Which Course Mode mechanics survive the merge | **NEW — OPEN.** §4.1's mapping table needs confirming, component by component. |

### Decision 1 is still open and it is now urgent

The design system specifies a fixed 1440×900 plate with `overflow: hidden` that
must never scroll. `web/` implements that literally and enforces it —
`npm run verify:panes` fails if any pane overflows.

As a reference implementation that is correct. **As the product it means no
phone support**, and two things in this plan collide with it directly: the
hand-drawn capture flow is inherently a phone surface (§4.2), and multi-part
math FRQs are the content least likely to fit a non-scrolling frame (§5.1).

Every screen built against the fixed frame raises the cost of changing this.
**Settle it before Phase 1 proper, not during.** §5.2's ten-real-items test is
the cheapest way to inform it.

---

## 9. Sequence

Phases follow David's order. Each ends in a reviewable state.

### Phase 0 — Prerequisites (before Phase 1 proper)

1. Render the existing `web/` plate against **ten real item packages**,
   including a 4-part calculus FRQ (§5.2).
2. Settle decision 1 (fixed vs. responsive) and decision 11 (multi-part FRQ,
   typed math) on that evidence.
3. Export the public URL inventory as a Phase 2 contract (§5.3).
4. Delete the two stray empty Lovable projects (`CramApple Practice`,
   `CramApple Marketing Hub`) — only the two remixes are wanted.
5. Confirm in Lovable settings whether `New Cramapple App` can sync to a
   subdirectory of this repo. Published docs say one project, one repo, at the
   root — if that holds, the app leaves Lovable when it moves here, and that
   should be an explicit decision rather than a discovery.

### Phase 1 — The app

Build in `web/` against the unchanged edge-function contract.

**Order revised 2026-09-22 per §3a** — BYOQ moved from last to third, because it
is the default entry to the one surface rather than an alternate path:

1. Question plate on **real** content — multi-part FRQ, typed math (§5.1)
2. Session chrome and the auth/resume path
3. **BYOQ intake** (§4.4) — paste, classification confirm, coverage-gap response
4. The open-hand teaching sequence: explainer → worked example → cold attempt
   (§3a.1) — this is the Open Hand and Practice plates wired in order
5. Cramapple-directed entry: the skills rail and the mastery queue (§4.1)
6. The repair ladder (§4.1)
7. Progress (§4.3)
8. Hand-drawn capture (§4.2)

**Exit:** a student can sign in, bring their own question, be taught from a
vetted parallel item, attempt a real multi-part FRQ and a real MCQ, be graded by
the real engines, and see progress — at parity with the current app for those
paths, on one surface with no mode selection anywhere in it.

### Phase 1b — Diagnostic and exam cram

**After Phase 1 ships, not alongside it** (§3a.3). Sequenced here so it is not
mistaken for Phase 1 scope. The commercial half — category, promise, pricing —
is not an engineering question and is not resolved by this sequencing
(`COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §7).

### Phase 2 — Marketing reskin

Apply tokens, type and square corners to the 50 SEO routes and 11 marketing
routes (not `index`). **URLs unchanged**; any change carries a redirect.
Visual pass, not a rebuild — the prose and page structure stay.

### Phase 3 — Stripe flow

Restyle `checkout.start` / `success` / `cancel` and `plan`. Zero purchases have
ever completed, so treat this as a first implementation that happens to have
existing code, and put it in front of testers before trusting it.

### Phase 4 — New home page

Designed fresh, deployed last, once the system it advertises exists.

### Throughout

`exam-buddy-wireframe` stays deployed for the reviewer portal (§7) until that is
rehomed. It is not deleted at the end of Phase 4 — it is archived when §7 is
resolved, which is separate work.

---

## 10. Risks

1. **Decision 1 compounds.** Every screen built on the fixed frame makes
   reversing it more expensive. Mitigated by Phase 0.
2. **Course Mode regression (§4.1).** The rebuild can ship a visually better,
   pedagogically worse product. The seven Course Mode components are the
   product's differentiator, not chrome. **Consolidation raises this risk rather
   than lowering it:** "merge the modes" is easy to read as "drop the mode's
   components," and the two are different decisions (§3a.2, §4.1).
3. **Reviewer portal stall (§7).** Cutting it before a replacement stops content
   authoring — the actual bottleneck.
4. **Undesigned surfaces get designed ad hoc.** 141 routes, five designed
   screens. Without a rule, the design system erodes exactly where it is thinnest.
   Suggest: anything without a design gets one before it gets built, or gets
   explicitly marked provisional in the repo.
5. **The plate quietly starts scrolling.** Named in the earlier plan and still
   true. `npm run verify:panes` catches it mechanically; keep it in CI when
   Phase 1 begins.
6. **The consolidation rests on an undocumented sample (§3a.4).** The rebuild is
   being sequenced around a student finding whose evidence basis the
   consolidation plan itself lists as its top open item. Cheap to record now.

---

## 11. Housekeeping found while writing this

- `exam-buddy-wireframe` commits a `.env` at the repo root. It contains only
  `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` — both client-side by design, so
  this is **not** a credential leak. Still worth moving to `.env.example` so the
  pattern does not persist into the new app.
- Four Lovable projects now exist for two intended targets (§9 step 4).
- `DESIGN_SYSTEM_CUTOVER_PLAN.md` §1 and §8 cite the pre-PR#152 palette (red
  `#F5442E`, clay for incorrect, amber). Flagged on PR #152; not edited here
  because that document is David's draft and pending his review.

---

## 12. Not done

- No Task ID allocated and no owner assigned (decision 7) — per
  `TASK_WORKFLOW.md` that is David's to assign.
- No DECISION number allocated. The calls recorded here are David's, taken in
  conversation on 2026-09-22; allocating a number risked colliding with open-PR
  claims.
- The route-by-route auth-requirement audit (decision 9) is not done. §2's table
  buckets by route name and directory, which is a first pass, not a verified
  assignment.
