# App Rebuild Migration Plan

STATUS: draft for Product Owner review | DATE: 2026-09-22 | OWNER: unassigned (§16)

**This is the single plan for the redesign.** It consolidates the conversation of
2026-09-22 with the documents listed in §15, and supersedes the earlier revision
of this file. Where it contradicts a source document, the contradiction is named
rather than silently resolved — see §13.

Every number here was read from `david-bloom/exam-buddy-wireframe`, this
repository, or **Cramapple – Production** (`pcntajvbdfqhbeewmdry`) on
2026-09-22. Read-only, counts only. Nothing is quoted from memory or from the
earlier planning drafts.

---

## 1. The job

> "Before the redesign we were ready to release a beta version, so our job is not
> to build from scratch. Our job is to render, wire and close any gaps."
> — David, 2026-09-22

That framing is correct, and the database supports it more strongly than the
previous revision of this document did. The earlier draft read like a rewrite
plan with a content problem attached. It is not. It is:

1. **Render** — put the new design system in front of content that already exists.
2. **Wire** — connect the plates to serving contracts, most of which already exist.
3. **Close gaps** — and where there is a real gap, run an existing, validated
   content protocol over it rather than inventing a new one.

The rest of this document is organised around those three verbs, in that order.

### What changed from the previous revision

The previous revision reported "zero AP Biology and AP Statistics content" and
recommended a ten-item stress test as a prerequisite. Both are now resolved:
the content was in the database, not the repository, and the stress test has
been run (16 real plates, zero overflow, PR #152). Three further claims in that
revision were wrong and are corrected in §13.

---

## 2. Where the product actually stands

### 2.1 Usage — the case for doing this now

| Measure | Value |
| --- | --- |
| Total accounts | 36 |
| Signed in, last 7 days | **0** |
| Distinct users who have ever submitted an attempt | **4** |
| Attempts, all time / last 30 days | 101 / 53 |
| Gradings, all time | 78 |
| Users who have **purchased** | **1** (2 rows via `stripe_checkout_single`, 13–15 Aug) |
| Stripe checkout sessions | 5 — 2 completed, 3 expired |

One paying customer and zero sign-ins in seven days makes the rebuild cheap:
engineering time is the only cost. **It also creates an obligation.** There is a
paying customer, and whatever happens to the live app, that person's access has
to survive it.

This is the strongest argument for acting now rather than later. The number that
makes a rebuild cheap today is the number a launch is meant to change.

### 2.2 Content — the case that this is a rebuild, not a restart

The published library, counted across every subject on 2026-09-22:

| Subject | MCQ | FRQ | Items with `item_package_payload` | Items with a topic label |
| --- | ---: | ---: | ---: | ---: |
| AP Statistics | 304 | 80 | 203 | **0** |
| AP Calculus BC | 63 | 64 | 0 | **0** |
| AP Calculus AB | 60 | 62 | 0 | **0** |
| AP Chemistry | 68 | 51 | 0 | **0** |
| AP Biology | 43 | 75 | 0 | **0** |
| AP Precalculus | 53 | 64 | 0 | **0** |
| AP Physics 1 | 63 | 54 | 0 | **0** |
| AP Physics C E&M | 48 | 49 | 0 | **0** |
| AP Physics C Mechanics | 41 | 36 | 0 | **0** |
| AP Physics 2 | 40 | 28 | 0 | **0** |
| **Total** | **783** | **563** | **203** | **0** |

**1,346 published items across ten AP subjects.** And they are structurally
complete — this is the finding that should set the tone for the whole project:

| Check, across all 783 published MCQ | Failures |
| --- | ---: |
| Has choices at all | 0 |
| Exactly four choices | 0 |
| Exactly one correct choice | 0 |
| Any choice with a blank rationale | **0** |

| Check, across all 563 published FRQ | Failures |
| --- | ---: |
| Has criteria at all | 0 |
| Any criterion with blank `learner_facing_text` | **0** |
| Any criterion with blank `minimum_fix` | **0** |

Plus the topic layer: **170 topics** carry a published `topic_point_brief` and a
published `topic_explainer`, with `how_points_are_earned`, `common_point_loss`,
`mini_example_question`, `weak_answer` and `point_attaining_answer` populated on
every row. For AP Biology (60 topics) and AP Statistics (55 topics) that is 100%
of the taxonomy.

**Read that table again before planning any content work.** The library is not
thin. It is complete and disconnected — see §5.

### 2.3 The routes to be replaced

`david-bloom/exam-buddy-wireframe` at `053c37d`: TanStack Start + React +
TypeScript, shadcn/Radix, Tailwind, Supabase client. 242 `.tsx` and 160 `.ts`
files. **141 route files.**

| Route group | Count | Phase |
| --- | ---: | --- |
| SEO subject content (`ap-biology/*`, `ap-statistics.*`, …) | 50 | 2 — reskin, URLs preserved |
| Student app (session, setup, progress, homework) | 22 | **1 — rebuild** |
| Beta / proto / dev | 18 | Retire (§10) |
| Reviewer / admin (operational) | 13 | **Not migrating (§10)** |
| Marketing (`index`, `about`, `how-it-works`, `blog`, `compare/*`, legal) | 12 | 2 — reskin; `index` is phase 4 |
| Auth / account | 10 | 1 (login/account) + 2 (public-facing) |
| Internal dashboards (`prototype.dashboard.*`) | 6 | **Not migrating (§10)** |
| Hand-drawn capture | 4 | **1 — rebuild, undesigned (§9.2)** |
| Commerce (`checkout.*`, `plan`) | 4 | 3 |
| Framework (`__root`, layout routes) | 2 | n/a |
| **Total** | **141** | |

### 2.4 The backend does not move

All 16 edge functions already live in this repository under
`supabase/functions/`. The student path calls six — `attempt-response`,
`evaluate-attempt`, `student-session-items`, `session-event`, `capture-pairing`,
`submit-response` — plus the reviewer path's four. **The rebuild re-implements
callers, not contracts** (with one deliberate exception, §5.3). Nothing in
`supabase/`, the grading engines or the migrations is touched by any phase here.

That is what bounds the work: the risky, security-sensitive half of the product
is already on the correct side of the line.

---

## 3. The sequence David set

1. **Rebuild the app** against the new design system, wired to the existing
   backend. §4–§9 are the gap analysis for this phase.
2. **Reskin the marketing pages** to the design system **without breaking the
   URL structure.** A visual pass, not a rebuild.
3. **Update the Stripe flow** to the design system, then adjust on tester feedback.
4. **Design and deploy a new home page**, last.

The repo split is underway: the Cramapple Lovable project was remixed into
`New Cramapple App` and `New Cramapple Marketing` (both 2026-09-22, code copied,
no other changes).

Full phase detail is in §12. The rest of §4–§11 is what Phase 1 has to solve.

---

## 4. One surface, two plate modes

### 4.1 The modes consolidate

Students do not experience Homework Mode, Course Mode and Learning Mode as
different products. They read as the same thing. That finding is on record in
`COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §0 (2026-09-17, twice externally
reviewed) and already **DECIDED** in its §1: one mode, working name **"Learn"**,
replacing the Course/Homework split entirely.

What this plan adds is the connection to the design: **the question plate is
that one surface.** Neither document says so — the consolidation plan predates
the design work, and the design system was extracted from four question
templates with no knowledge of the mode question. Writing it down is what stops
someone building a third thing.

Consolidation retires the **mode chrome** — the picker, the per-mode routes, the
"which mode am I in" framing. It does not retire the **mechanics** (§9.1).
Reading "merge the modes" as "drop the components" is the way this rebuild ships
worse pedagogy behind better visuals.

**Diagnostic and exam cram come after** the homework/course path ships
(David, 2026-09-22). This partially answers consolidation §10 item 3: a
cram-proximate path survives rather than dissolving into backend pacing, and it
is sequenced second. The commercial half — category, promise, pricing — stays
Product Owner and Micah territory.

### 4.2 What the two plate modes are

**David, 2026-09-22.** This is the operative definition and it settles what each
mode is *for*.

**Open Hand** is an **example** question with the rubric, a **sample answer** and
the supporting content all exposed. The student changes the answer by selecting
and deselecting rubric elements, and watches what the answer loses. The student
is composing and decomposing the credited answer — not a teacher taking points
back. (`web/` currently reads "Click a criterion to take the point back. ✕ is
the teacher's hand": the mechanic is right, the voice is wrong. Copy pass owed.)

**Practice** is the same template with **no sample answer** and the support
content **hidden**. The student either answers cold, or exposes the helpful
content — rubric, deep dive — **before** submitting. One submission, then grade
and feedback.

**How much help the student takes, read against the score, is the mastery
signal.** That is what lets the product track progress without doing the
student's work, and it is the reason the hint economy exists at all. Two
consequences:

1. **All disclosed help must be gated help.** The deep dive was reachable only
   after submitting, so taking it cost nothing and recorded nothing. Fixed on
   PR #152: it now sits behind the same three-state gate as the rubric and lands
   on the feedback card's hints-used strip.
2. **Nothing yet derives mastery from help-taken plus score.** `web/` records
   both per attempt and stops. That derivation belongs with `student_cell_state`,
   is a pedagogy decision rather than a frontend one, and is unbuilt and
   unspecified. It is the half that makes the other half worth having.

Reference material stays ungated throughout: it is what a student may look up,
not help about this question.

### 4.3 "Open Hand" means two different things

A naming collision worth catching before it becomes a bug.

| Term | Where | What it means |
| --- | --- | --- |
| "open-hand teaching" | `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §2 | a **pedagogical sequence**: skill explainer → worked example shown open-hand → the student's own cold attempt |
| "Open Hand" | the design system, and `web/` | a **plate mode**: the rubric or answer key is face-up, nothing is scored |

They fit together exactly — the Open Hand plate is the worked-example step, the
Practice plate is the cold-attempt step — so the design system's two modes are
the two halves of the sequence the consolidation plan calls "the hinge." **Do
not ship both vocabularies.** Consolidation §10 item 12 already has naming open.

That mapping is an inference, not something either document states
(`UNCERTAINTY_LOG.md` §16).

---

## 5. Wiring — the section this plan was missing

This is where "render and wire" stops being simple, and it is the most important
new material in this revision. The content exists. The serving contracts mostly
exist. **They do not currently meet.**

### 5.1 What already works

| Plate element | Contract | State |
| --- | --- | --- |
| Question stem, MCQ choice text | `student-session-items` | **Works.** Serves `choice_key`, `choice_text`. |
| FRQ criteria, Practice pre-submit | `student-session-items` | **Works.** Serves `learner_facing_text`, `points_possible`. |
| Grading and verdict | `evaluate-attempt` | **Works.** Real engines, deterministic + LLM-assisted. |
| Criterion feedback post-submit | `evaluate-attempt` | **Works.** Returns `minimum_fix` and `decision_explanation` per criterion. |
| Reference pane, habits pair | `public.get_topic_point_guides` | **RPC exists, content complete** — but unreachable (§5.4). |
| Student-readable taxonomy | `public.get_student_taxonomy` | **RPC exists.** |
| Stimulus images | `content_asset_metadata` + signed URLs | Exists; six published Bio FRQ use it. No plate treatment (§8.3). |

### 5.2 The Open Hand answer key has no contract — and the current one forbids it

This is the single largest wiring finding, and it is not a bug. It is a
deliberate boundary that the new design crosses.

`student-session-items` reads **only** `choice_key, choice_text` from
`mcq_choices`. The code says why:

> Only `choice_key`/`choice_text` — `is_correct` and `rationale` are
> answer-bearing and must never reach a student.

The same rule applies to `frq_criteria`, where `evidence_requirements`,
`minimum_fix` and `accepted_variants` are withheld pre-submit. It is enforced
three ways: revoked column grants on `app.mcq_choices` (PR #106), a
`public.mcq_choices` view rebuilt without the answer-key columns (migration
`20260827010000`), and the service-role boundary in the edge function.

Migration `20260828170000` states the threat model in one sentence:

> rationale text on a distractor lets a student find the correct choice by
> elimination before ever answering.

**That is exactly what Open Hand does, on purpose.** It shows all four
rationales, face-up, before the student answers — because nothing in Open Hand
is scored. The existing model assumes every served item is an item the student
will be scored on. Open Hand breaks that assumption, and the protection is
correct for every case except this one.

**This needs a decision, not a patch** (decision 21). The shape that fits the
existing architecture: a `SECURITY DEFINER` RPC that serves the full key for an
item explicitly requested **as an example**, with that item then ineligible to
be scored for that student. There is precedent —
`public.get_review_mcq_choices` already serves the full key to an assigned
reviewer, and `public.get_chosen_distractor_rationale` already serves one
distractor's rationale post-grade under three server-side conditions. Open Hand
is a third such narrow, deliberate exception, and it should be written with the
same care.

Do not solve this by relaxing the view or restoring the column grants.

### 5.3 Practice feedback never emits the authored rationale

A smaller version of the same problem, and easy to miss.

When a student gets an MCQ wrong, `evaluate-attempt` returns:

> "The submitted choice does not match the published correct answer."

The authored rationale — the one that says *why that distractor tempts* — is
read server-side and not returned. The only path that emits it is
`public.get_chosen_distractor_rationale`, which is post-grade, one choice, and
was built for the Course Mode repair panel.

The new design's feedback card wants the specific line, not the generic one.
**The content exists on every one of 783 MCQ.** Wiring the feedback card to that
existing RPC is a small, well-bounded change and probably the cheapest real
improvement in Phase 1.

### 5.4 Nothing connects an item to its topic

**Zero of 1,346 published items carry a topic label.** Verified two ways:
`assessed_topics` is empty on every `content_taxonomy_labels` row of
`label_scope = 'coverage'`, and no published item resolves to a topic by any
other route.

This is the one blocking content gap, and it blocks more than it looks like:

- the **breadcrumb** names a topic
- the **habits pair** comes from `topic_point_briefs`, keyed by topic
- the **reference pane** comes from the same place
- the **deep dive** and the Open Hand worked example come from
  `topic_explainers`, keyed by topic
- **progress and the study map** aggregate by topic

So the topic layer is complete, published, already served by a working RPC, and
**unreachable from any item in the library.** Closing that one link turns four
panes on from a standing start. §6 is how.

### 5.5 Two schema-versus-template mismatches

Neither is a content gap; both need a template decision.

1. **`mcq_choices` has `rationale` but no `minimum_fix`.** The Open Hand answer
   key in `web/` renders a per-choice "fix" line. That column does not exist —
   the rationale says why a choice tempts, not how to correct it. Either the
   template drops the fix line, or the rationale is what fills it.
2. **Item-package payloads exist for 203 items and nothing else.** All 203 are
   AP Statistics MCQ. The other 1,143 published items serve from the relational
   columns. The plate's adapter was written against the package shape. It needs
   to read both, or the library needs backfilling — a decision, not an accident.

---

## 6. Closing the topic-label gap

### 6.1 The protocol exists

`docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md`, plus executed
serving-label runs for Biology, Statistics, Chemistry, Physics and Math in
`docs/research/`. This is not greenfield. David's instinct — "we probably need
to close gaps in that production" — is the right one.

The plan splits labels in two, and the split is why the gap exists:

- **Serving labels** need *units*. Measured at 89% two-model agreement →
  automatable. Ran at scale: 414 `provisional_model` rows exist.
- **Coverage labels** need *topics*. Measured at 44% agreement → the plan
  declared them not automatable and required human validation. They were
  therefore never produced.

### 6.2 David's decision, and the one caveat

> "Human validation I've found is slow and error prone. I'm more confident in AI
> for this task. I'll find a second source." — David, 2026-09-22

Recorded as the direction. One caveat worth testing before committing budget to
a second source:

**The 44% is probably not the number to plan against.** It measured *set
equality* on `required_topics` across 18 items, and the plan names the failure
mode itself — the models split on granularity (whether `3.3 Cellular Energy`
rides along with `3.5 Cellular Respiration`), not on what the question is about.

**The new design needs exactly one topic per item.** Breadcrumb, brief and
explainer are all singular. Agreement on a primary topic is a materially easier
target than agreement on a set, and the measured disagreement mode largely
disappears.

That re-score is nearly free: 15 model runs are already stored with raw
`source_payload` in `content_taxonomy_labels`. **Re-score them for
primary-topic agreement before buying a second source.** It tells you whether
you are rescuing a broken lane or confirming a working one.

### 6.3 Two second sources already in-house

A second *model* reading the same CED is not an independent source. Two things
in the database are:

1. **The author's own words.** Every published item carries
   `prompt_json->subtopics`, written at authoring time without the CED in hand.
   The topic *codes* are unreliable — the v3 plan measured 94% of Biology topic
   strings as matching no CED topic, and a spot check found one tagged
   `1.4 Enzymes` where the CED puts enzymes in Unit 3. But the *prose* is real
   signal: `Unit 1: Measures of Center and Spread (Resistance to Skew/Outliers)`
   is not a valid label and is a perfectly good hint. The `modules` unit number
   looks materially more trustworthy than the topic string.
2. **The explainers' worked examples.** 170 topics each carry a
   `mini_example_question`. Matching an item against those is **retrieval, not
   classification** — a different failure mode from a labelling model, which is
   the entire point of a second source.

### 6.4 What the CED uniquely provides

The **closed list**. It turns free-form classification into selection from 61
options (Biology) or 55 (Statistics). That is most of the accuracy, and it makes
an invented topic string structurally impossible — closing the root cause the v3
plan flagged as still open in its §11.6.

### 6.5 Humans off the happy path, not out of the loop

Sample enough to bound the error rate; route model disagreement to a person. The
v3 plan's triage logic (T6.b) already works this way for units. It needs a topic
threshold set from real numbers rather than from the 44%.

This also keeps the work inside the existing governance posture — INV-3, the
double-approve publication rule and `CONTENT_GOVERNANCE_AND_VALIDATION.md` —
rather than requiring an exception to it.

### 6.6 One deferral is now dead

v3 §11.7 offered deferring `assessed_topics` entirely, on the grounds that
unit-gated serving only needs units. That was right for the old design. **It is
off the table now** — topic is load-bearing on every plate (§5.4).

And the unit lane needs another pass regardless: of the published library, most
items carry no usable serving label either. If it is being re-run, run topics in
the same pass.

---

## 7. Content production — what to run, not what to write

David: *"we have already built and validated protocols for creating many types of
content. We may just need to close gaps in that production."* Correct. The
mapping from gap to existing protocol:

| Gap | Existing protocol | Action |
| --- | --- | --- |
| Topic labels (1,346 items) | `TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` + five subject run docs | Re-run with §6's amendments |
| Topic briefs / explainers | `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` | **Nothing owed** — 170 topics complete |
| MCQ choices and rationales | Content authoring + double-approve review | **Nothing owed** — 783 items complete |
| FRQ criteria | Same | **Nothing owed** — 563 items complete |
| `rubric_type` backfill | Schema-level, mechanical | 92 Stats MCQ, 14 Stats FRQ, 1 Bio FRQ (§8.2) |
| Item-package backfill | `CODEX_*` phase docs | Decision first (§5.5 item 2) |
| Validation status | `CONTENT_GOVERNANCE_AND_VALIDATION.md` | Nothing is `validated`; decide whether that gates launch |

**No new content protocol is required by this plan.** That is the single most
useful thing to know before scoping Phase 1.

---

## 8. Remaining content gaps, in priority order

### 8.1 Topic labels — blocking

§5.4 and §6. Everything else on this list is small by comparison.

### 8.2 `rubric_type` missing on a tail of items

92 AP Statistics MCQ, 14 AP Statistics FRQ, 1 AP Biology FRQ. Mechanical.

### 8.3 Six published Biology FRQ carry a `stimulus_image_path`

The first real image stimulus in the library. `content_asset_metadata` and the
signed-URL path exist; the plate has no treatment for an image stimulus, and the
fixed frame is an unforgiving place to put one. Ties to decision 1.

### 8.4 Multi-part FRQ is real, and inconsistently modelled

Of 563 published FRQ: **168 carry structured `prompt_json.parts`**, and **323
carry part markers `(a)`/`(b)` only as prose inside the stem.** Longest stem is
2,205 characters.

This sharpens decision 11 considerably. It is not only that the plate has no
design for part navigation and per-part scoring — it is that for most items the
parts are not data. You cannot render per-part scoring from a stem string. Any
multi-part design implies either a content migration or a parser, and that
choice should be made deliberately.

On disk, `content/item-packages/` holds 330 items in the package format, of
which 140 are FRQ and **none has fewer than two parts** (74 two, 25 three, 41
four), with 295 response slots marked `typed-math`. That set is a different,
newer authoring shape from most of the database; only the 203 AP Statistics MCQ
bridge the two today (§5.5).

### 8.5 Nothing in the library is `validated`

Every label and item sits at `provisional_model`, `legacy_unvalidated` or
`published` — not `validated`. Whether that state gates a beta launch is a
governance decision, not an engineering one.

---

## 9. Functional gaps — Phase 1

These exist in the current app, are used, and have **no design treatment**.

### 9.1 Course Mode session UI — 7 components, shipped, live pilot

`SkillRail`, `ConfirmTransferBeat`, `CourseModeRepairPanel`, `RepairBlock`,
`WorkedExample`, `LessonOpener`, `StreakBadge`.

The most recently hard-won work in the product — the Aug 27 pilot took a
five-fault chain to get serving. None of these concepts appears in the four
extracted templates. **Largest single functional gap in this plan.**

Consolidation re-homes this work; it does not remove it. Consolidation §1 keeps
the cell-based mastery queue and the skills rail as the Cramapple-directed
entry, and §2 makes the worked-example sequence "the one teaching mechanism both
entry points route into."

| Component | Under consolidation |
| --- | --- |
| `SkillRail` | The Cramapple-directed entry (plan §1, secondary entry) |
| `LessonOpener`, `WorkedExample` | The open-hand teaching step (plan §2) — see §4.3 |
| `RepairBlock`, `CourseModeRepairPanel` | The repair ladder; survives, needs a design. Already wired to `get_chosen_distractor_rationale` (§5.3) |
| `ConfirmTransferBeat` | Survives; where it fires in a BYOQ-first flow is undecided |
| `StreakBadge` | Survives or is dropped — a product call |

### 9.2 Hand-drawn capture — 4 routes, Engine 4 infrastructure

`CaptureItem`, `SameDeviceCapture`, `capture-phone`, `capture-demo`,
`hand-drawn-pilot`, `hand-drawn-responses`, and the `capture-pairing` edge
function. The QR handoff shipped 2026-08-20 and is the *only* capture path
(DECISION-0051 ruled out a direct-upload fallback). The design system has a
camera affordance in `AnswerField` — a button, not a flow. The phone-side screen
is entirely undesigned, and it is inherently mobile, which collides with
decision 1.

### 9.3 Progress and dashboard

`_ux.progress` is 708 lines — the largest route in the app, plus `dashboard`.
The design system has a study map with per-topic dots and nothing else. Note
that per-topic anything depends on §5.4.

### 9.4 Bring-your-own-question

`bring-question`, `byoq`, `check-work`, `ask`, `ask-parent`, and the
`homework-help` components. Designed in `HOMEWORK_MODE_DESIGN_2026_08_28.md`,
governed by CM-D20, **not visually designed at all**:

- verbatim paste intake
- the closed-form classification confirm — "are you talking about Topic 3.9?" —
  an anti-gaming mechanism, not a convenience
- the coverage-gap response: name the skill and defer, **never** generate a live
  substitute item (CM-D20)
- handing the student's own question back unsolved after the parallel open-hand item
- the Check My Work unlock gate, threshold still open

Its position in the Phase 1 order depends on decision 18.

### 9.5 Setup, onboarding and topic selection

`setup.index`, `setup.subject`, `setup-paused`, `onboard`, `topic`. TASK-0029
already moved the home quick-start door to bypass `/session/setup`; the rebuild
should not reintroduce a page the product decided to drop. Shrinks under
consolidation — with no modes there is no mode selection, and `setup.subject`
may not survive. What remains is subject and exam-date capture.

### 9.6 Session chrome and states

`SessionFrame`, `SessionShell`, `SessionHamburgerMenu`, `SessionParamsBar`,
`TopContextBar`, `RecheckDialog`, `ReportQuestionButton`, `session.complete`,
`session.uncertain`. `Masthead` + `Breadcrumb` replace part of this; report a
question, recheck, session completion and the uncertain state have no equivalent.

### 9.7 ConfettiBurst

The design system sets `--motion-duration: 0ms` and states "no transitions, no
fades, no bounces." The current product has a deliberate celebratory moment.
A real product question, not a token value.

---

## 10. What is not migrating

**Reviewer / admin — 13 routes plus 6 internal dashboards. Do not cut this
before a replacement exists.** The double-approve publication rule runs through
`reviewer.review.$assignmentId`, `reviewer.gold-set.*`, `reviewer.submissions`
and `admin.grade-response`. Content authoring is the product's actual
bottleneck; breaking the reviewer's tool to ship a student-facing redesign is a
bad trade. These are internal and low-traffic, so they can stay on the old stack
indefinitely. **Keep `exam-buddy-wireframe` deployed for this reason alone until
it is rehomed.**

**Beta / proto / dev — 18 routes.** `beta.*`, `_authenticated/proto.*`,
`dev.celebrations`, `style-guide`. Confirm nothing live depends on them, then
delete rather than migrate. `style-guide` is superseded by
`.claude/skills/cramapple-design/guidelines/`.

### What transfers cleanly

- **The entire backend** (§2.4), with the one deliberate addition in §5.2.
- **The data model.** `attempts`, `attempt_responses`, `grading_results`,
  `learning_sessions`, `subject_entitlements` are unchanged.
- **Auth.** Supabase Auth, server-side config; the design system's form
  treatment covers login and reset.
- **Pedagogical copy posture.** Name the error, don't judge the student;
  one-word verdicts; second-person imperative.
- **Marketing content.** Phase 2 restyles the shell, not the words.

---

## 11. Open decisions

| # | Decision | Status |
| --- | --- | --- |
| 1 | **Fixed 1440×900 frame vs. responsive** | **OPEN — blocking.** See below. |
| 2 | Visual-identity brief v2 status | **Resolved.** `docs/new_design/` is canonical. |
| 3 | Motion — `ConfettiBurst` exception | OPEN (§9.7) |
| 4 | Scope for v1 | **Resolved.** App, marketing, Stripe, home page (§3). |
| 5 | Logo | OPEN — ships with the type wordmark unless resolved |
| 6 | Dark mode | **Resolved.** Retired 2026-09-21, light only. |
| 7 | Owner / Task ID | OPEN (§16) |
| 8 | Cross-subdomain auth handoff (`.cramapple.com` cookie scope) | OPEN — foundational to both projects |
| 9 | Route-by-route auth-requirement audit | OPEN — §2.3 buckets by name, which is a first pass |
| 10 | Repo-split vs. cutover sequencing | **Resolved.** Split first, then rebuild. |
| 11 | **Multi-part FRQ and typed-math treatment** | **OPEN — blocking Phase 1.** Harder than it looked: parts are prose on 323 of 563 items (§8.4). |
| 12 | Mode consolidation into one surface | **Resolved.** The plate is that surface (§4.1). |
| 13 | Diagnostic / exam-cram sequencing | **Resolved.** After the homework/course path (§4.1). Commercial half open. |
| 14 | "Open Hand" means two things | **OPEN, cheap.** Pick one vocabulary (§4.3). |
| 15 | BYOQ intake has no design | **OPEN** (§9.4) |
| 16 | **Student-signal evidence basis** | **OPEN — upstream of 12, 13 and 18.** Consolidation §10 item 1. |
| 17 | Which Course Mode mechanics survive the merge | **OPEN.** §9.1's table needs confirming component by component. |
| 18 | **BYOQ: default entry or alternative?** | **OPEN — reorders Phase 1.** Consolidation §1 says default; David 2026-09-22 says Practice defaults to a Cramapple question (§13.3). |
| 19 | **Intake: paste-first or camera/upload-first?** | **OPEN.** `HOMEWORK_MODE_DESIGN_2026_08_28.md` §2 defers photo and makes verbatim paste an anti-gaming layer; David 2026-09-22 names camera and document upload (§13.3). |
| 20 | **What derives mastery from help-taken + score** | **OPEN — unbuilt and unspecified.** The signal both plate modes exist to produce (§4.2). |
| 21 | **How Open Hand gets the answer key** | **NEW — OPEN, blocking Open Hand.** The serving contract forbids it by design (§5.2). Needs a narrow RPC and a scored-ineligibility rule, not a relaxation. |
| 22 | **Topic labelling approach** | **Direction set** (§6.2): AI-led, second source being sourced. Open: whether to re-score the stored runs for primary-topic agreement first, and what the human-escalation threshold is. |
| 23 | **Item-package backfill or dual-read adapter** | **NEW — OPEN.** 203 of 1,346 items carry a package payload (§5.5). |
| 24 | **Does `validated` status gate launch?** | **NEW — OPEN.** Nothing in the library is `validated` (§8.5). |
| 25 | Per-choice "fix" line in the Open Hand key | **NEW — OPEN, cheap.** No such column exists (§5.5). |

### Decision 1 is still open and it is now urgent

The design system specifies a fixed 1440×900 plate with `overflow: hidden` that
must never scroll. `web/` implements that literally and enforces it —
`npm run verify:panes` fails if any pane overflows.

As a reference implementation that is correct. **As the product it means no
phone support**, and three things collide with it directly: hand-drawn capture
is inherently a phone surface (§9.2), multi-part math FRQs are the content least
likely to fit a non-scrolling frame (§8.4), and the six image-stimulus Biology
FRQs need vertical room the frame does not have (§8.3).

Every screen built against the fixed frame raises the cost of changing this.
**Settle it before Phase 1 proper, not during.**

The evidence is now available: 16 real plates render without overflow (PR #152).
That validates the frame for single-part MCQ on real content. It says nothing
about multi-part FRQ, math input or image stimulus, which are the hard cases.

---

## 12. Sequence

### Phase 0 — Prerequisites

1. **Settle decision 21** (Open Hand's answer-key contract). Open Hand cannot be
   wired without it, and it is a security boundary, so it should not be decided
   under build pressure.
2. **Settle decisions 1 and 11** (fixed frame; multi-part FRQ and typed math) —
   informed by the real-content evidence already on PR #152, extended to a
   multi-part FRQ and an image-stimulus Biology FRQ.
3. **Re-score the stored taxonomy runs for primary-topic agreement** (§6.2).
   Cheap, and it decides how much second-source work is actually needed.
4. Export the public URL inventory from `routeTree.gen.ts` as a Phase 2 contract.
5. Delete the two stray empty Lovable projects (`CramApple Practice`,
   `CramApple Marketing Hub`); keep the two remixes.
6. Confirm in Lovable settings whether `New Cramapple App` can sync to a
   subdirectory of this repository. If one-project-one-repo-at-root holds, the
   app leaves Lovable when it moves here — an explicit decision, not a discovery
   (`UNCERTAINTY_LOG.md` §6).

### Phase 1 — The app

Build in `web/` against the edge-function contract, unchanged except for
decision 21.

1. **Topic labelling run** (§6). It gates the breadcrumb, habits pair, reference
   pane, deep dive, progress and study map — six surfaces — so it goes first
   even though it is content work rather than frontend work.
2. **Question plate on real content** — the MCQ path end to end, including the
   feedback card wired to the authored rationale (§5.3).
3. **Open Hand** against the new answer-key contract (decision 21).
4. Session chrome and the auth/resume path.
5. Multi-part FRQ, per decisions 1 and 11.
6. **BYOQ intake** (§9.4) — position pending decision 18.
7. The open-hand teaching sequence: explainer → worked example → cold attempt.
8. Cramapple-directed entry: skills rail and mastery queue (§9.1).
9. The repair ladder (§9.1).
10. Progress (§9.3).
11. Hand-drawn capture (§9.2).

**Exit:** a student can sign in, be taught from a vetted item, attempt a real
multi-part FRQ and a real MCQ, be graded by the real engines, see criterion-level
feedback in the authored voice, and see progress — on one surface with no mode
selection anywhere in it.

### Phase 1b — Diagnostic and exam cram

After Phase 1 ships, not alongside it. The commercial half — category, promise,
pricing — is not resolved by this sequencing (consolidation §7).

### Phase 2 — Marketing reskin

Apply tokens, type and square corners to the 50 SEO routes and 11 marketing
routes (not `index`). **URLs unchanged**; any change carries a redirect. Visual
pass, not a rebuild.

### Phase 3 — Stripe flow

Restyle `checkout.start` / `success` / `cancel` and `plan`. Two purchases have
ever completed, so treat this as a first implementation that happens to have
existing code, and put it in front of testers before trusting it. **The existing
paying customer's access must survive the change** (§2.1).

### Phase 4 — New home page

Designed fresh, deployed last, once the system it advertises exists.

### Throughout

`exam-buddy-wireframe` stays deployed for the reviewer portal (§10) until that is
rehomed. It is archived when §10 is resolved, which is separate work.

---

## 13. Corrections and contradictions

### 13.1 Corrections to the record

Four claims in earlier drafts of this document, its PR comments, or the review
artifact were wrong.

| Claim | Status |
| --- | --- |
| "Purchased entitlements: 0 — there is no revenue" | **Wrong.** One user paid, 13–15 Aug. The filter used `source = 'purchase'`; the real source is `stripe_checkout_single`. |
| "Zero AP Biology and AP Statistics content" | **Wrong.** Only `content/item-packages/` was searched. Both subjects are in the database, and the library is 1,346 published items (§2.2). |
| "Missing canonical answers on 304 Stats MCQ / 40 Bio MCQ" | **Wrong.** MCQ correctness lives in `mcq_choices.is_correct` with a rationale on every choice. `canonical_answer_1` is the wrong field to read for MCQ. Nothing is owed. |
| "203 of 304 Stats MCQ carry no taxonomy label" | **Wrong in detail, worse in substance.** That count mixed drafts with published. The accurate statement is that **no published item in any subject carries a topic label** (§5.4). |

`UNCERTAINTY_LOG.md` carries the full list, including the items still unverified.
Three remain cheap to settle and change conclusions: Lovable's repo model,
whether the committed `.env` holds only publishable keys, and whether the default
copy written for real packages should stand.

### 13.2 The stress test the previous revision asked for has been run

It recommended rendering the plate against ten real item packages before
building further. Done: 16 real plates across eight subjects, zero overflow,
verified mechanically (`npm run verify:real`, PR #152). It also surfaced a crash
on the real-content navigation path that the walkthrough content had hidden.

### 13.3 Two contradictions still needing David's word

Both reverse something already written down.

**1. Is BYOQ the default, or the alternative?**

| Source | Says |
| --- | --- |
| `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §1 (**DECIDED**, twice reviewed) | "Default entry … is bring-your-own-question … **not an alternate path bolted onto guided roaming**." |
| David, 2026-09-22 | "**Practice defaults to one of our questions** but the student can upload their own question via camera or document upload." |

Possibly reconcilable — "default entry" may describe how a session is *initiated*
while "defaults to one of our questions" describes what *loads* when Practice
opens cold. The consolidation plan is emphatic, so treat this as a change until
David says otherwise. It reorders Phase 1: if BYOQ is the alternative, the
Cramapple-directed path comes first, which is also the cheaper build.

**2. Paste-first, or camera and upload?**

`HOMEWORK_MODE_DESIGN_2026_08_28.md` §2 carries an explicit scope-narrowing
decision by David: **paste first** (verbatim), **photo second**, **worksheet
upload third**, "photo capture is deferred." Paste-verbatim is one of the two
anti-gaming layers there, because a pasted real question is checkable against
the claimed topic in a way a description is not. David, 2026-09-22 names camera
and document upload and does not mention paste. If photo/upload is now first,
the anti-gaming argument needs a replacement and §9.4's classification confirm
carries more weight than it was designed to.

### 13.4 One caveat the consolidation plan raises about itself

Consolidation §10 item 1 — its top-priority open decision — asks that the
evidence behind the student signal be documented (sample size, how students were
asked, stated preference vs. observed behaviour) **before any of the decisions
resting on it are treated as settled.** That is still open, and this rebuild is
about to be sequenced around that finding. Recording the evidence basis is cheap
now and expensive after Phase 1.

---

## 14. Risks

1. **Decision 1 compounds.** Every screen built on the fixed frame makes
   reversing it more expensive. Mitigated by Phase 0.
2. **Course Mode regression (§9.1).** The rebuild can ship a visually better,
   pedagogically worse product. Consolidation *raises* this risk: "merge the
   modes" is easy to read as "drop the mode's components."
3. **Decision 21 gets solved by relaxing the boundary.** The fastest way to make
   Open Hand work is to restore the revoked column grants. That would undo
   PR #106's answer-key protection for every other surface at once.
4. **Reviewer portal stall (§10).** Cutting it before a replacement stops content
   authoring — the actual bottleneck.
5. **The topic-labelling run produces labels nobody trusts.** Nothing in the
   library is `validated` today (§8.5). Shipping AI labels without a stated
   error bound repeats the 147-invented-topic-strings problem in a new form.
6. **Undesigned surfaces get designed ad hoc.** 141 routes, five designed
   screens. Suggest: anything without a design gets one before it gets built, or
   is explicitly marked provisional in the repo.
7. **The plate quietly starts scrolling.** `npm run verify:panes` catches it
   mechanically; keep it in CI when Phase 1 begins.
8. **The mastery signal stays unbuilt while the help economy ships (§4.2).**
   Gating help is only worth its friction if something reads the result.

---

## 15. Sources consolidated here

This plan is intended to be read on its own. These are where its claims come
from, and where to go for detail it deliberately omits.

| Document | What it carries that this plan compresses |
| --- | --- |
| `DESIGN_SYSTEM_CUTOVER_PLAN.md` | The two-design-system comparison. **Note:** its §1 and §8 cite the superseded palette (red `#F5442E`, clay for incorrect, amber). Not edited here — it is David's draft. |
| `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` | The mode-consolidation decision, the quarantine-pool mechanism, and the 13 open decisions this plan's 16/18/19 point back to |
| `USE_MODES_STRATEGIC_RECONCILIATION.md` | Background on how three modes arose; §3.3–§4 superseded by the consolidation plan |
| `HOMEWORK_MODE_DESIGN_2026_08_28.md` | BYOQ intake design, CM-D20, the anti-gaming layers |
| `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` | The labelling protocol, the 89%/44% measurement, and the serving/coverage split |
| `docs/research/AP_*_TAXONOMY_SERVING_LABEL_RUN_2026_08_05.md` | The executed serving-label runs, five subjects |
| `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` | INV-3, the double-approve publication rule |
| `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` | How the 170 complete topic briefs and explainers were produced |
| `docs/product/UNCERTAINTY_LOG.md` | Everything asserted but unverified in this work, including what is still open |
| `web/README.md` | The product rules the implementation enforces mechanically |
| `docs/new_design/` | The canonical design system as landed on PR #152 |

---

## 16. Not done

- No Task ID allocated and no owner assigned (decision 7) — per `TASK_WORKFLOW.md`
  that is David's to assign.
- No DECISION number allocated. The calls recorded here are David's, taken in
  conversation on 2026-09-22; allocating a number risked colliding with open-PR
  claims.
- The route-by-route auth-requirement audit (decision 9).
- The primary-topic re-score of the stored model runs (§6.2) is recommended, not
  performed — it is Phase 0 work, not planning work.
- No estimate of effort or duration for any phase. The gaps are named; sizing
  them is a conversation with whoever owns the build.
