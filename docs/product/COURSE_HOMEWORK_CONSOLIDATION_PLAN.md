# Course + Homework Mode Consolidation Plan

STATUS: plan, nothing built | DATE: 2026-09-17 (rev. 2 of 2026-09-17, after a
second round of external review) | AUDIENCE: David, LLM-first entry point for
any session picking this up.

This is a **plan**, not an implementation. Nothing described here is built. It
supersedes the "which mode ships first" framing in
`USE_MODES_STRATEGIC_RECONCILIATION.md` §3.3–§4 with a direct answer from
student feedback: **Course Mode and Homework Mode are not two modes to
sequence — they're one experience students already see as the same thing.**
Where a point is a firm product direction from this session it's tagged
**DECIDED**; where it's this session's recommendation awaiting sign-off it's
**PROPOSED**; unresolved calls are **OPEN**.

**Revision note (rev. 1, 2026-09-17):** this draft went to an independent
second reviewer (Codex) before David sign-off. The review confirmed the core
direction — one engine, BYOQ as the entry wedge, open-hand teaching as the
shared mechanism, no separate cram backend — but found the first draft had
promoted several open questions into settled conclusions without resolving
the commercial, governance, and content-operations dependencies those
conclusions create. That revision downgraded those points from DECIDED/
PROPOSED-as-if-settled back to explicitly OPEN, named the specific documents
and decisions each one needs to clear, and added what the first draft
understated or missed.

**Revision note (rev. 2, 2026-09-17):** the same reviewer verified rev. 1 and
confirmed the substantive gaps closed, with five remaining issues: BYOQ-
primary needed to be scoped to the year-round path rather than asserted
universal (§1); the quarantine-pool mechanism needed explicit private/
opted-in/canonical data states rather than one undifferentiated pool, plus
source-attestation and lifecycle requirements (§4); the throughput
experiment needed a two-stage design because synthetic/owned material can't
measure real-world rights-rejection cost (§4); §10's open-decisions list
needed evidence-basis moved to the top, an academic-integrity decision
added, and its GOV/build-sequencing items sharpened; and the gating list
needed `DESIGN-002`/`DESIGN-004`/`DESIGN-005`/`CONTENT-001` added with a
staged (not uniform) gate table, plus a handful of stale cross-references
fixed. This revision makes all five changes. Section-by-section changes are
noted inline.

## 0. The signal driving this

Student feedback, reported by David (2026-09-17):

- Homework Mode and Course Mode read as the same thing to students. They
  don't experience "bring a question" and "work through my mastery queue" as
  different products.
- Cram Mode (the original urgent, 10-day framing) is something they'd use
  sporadically, or only in the final run-up to the exam — not a mode they
  live in day to day.
- Students want to teach *from their own work first* — their actual
  homework, worksheets, class questions — and have Cramapple's own bank
  available as extra practice, or for the specific topics/skills Cramapple
  recommends they spend more time on.
- Camera-photo capture and worksheet upload are both wanted, not just one.
- Students want worksheet uploads to also grow Cramapple's own content
  library, not just serve that one session.
- Multiple students asked, unprompted, whether they could link accounts into
  study groups.

**OPEN, flagged by review:** this plan is built entirely on that feedback
summary. It doesn't document sample size, how students were asked, or
whether these are stated preferences versus observed behavior. Before this
plan becomes an execution commitment, record that evidence basis (§10 item
9) — a strategic pivot this size shouldn't rest on an undocumented sample.

This lines up with, and resolves, the open sequencing question in
`USE_MODES_STRATEGIC_RECONCILIATION.md`: the "one engine, three entry points"
thesis in that document was correct, but the entry points aren't Cram/Course/
Homework — they're **bring-your-own-work** (the everyday default) and
**Cramapple-directed practice** (the supplement). What exam-window urgency
becomes is addressed separately in §7, not assumed here.

## 1. DECIDED — the consolidated engine shape

**One mode, working name "Learn"** (naming itself is open, §10). It replaces
the Course Mode / Homework Mode split entirely; there is no longer a reason
to build or document them as separate surfaces.

- **Default entry for the consolidated year-round experience:
  bring-your-own-question (BYOQ).** A student's actual homework, worksheet,
  or class question is the default way into a session, not an alternate path
  bolted onto guided roaming. **Revised per second review:** this is decided
  for the year-round experience specifically, not asserted as universal.
  Entry priority for any retained cram/exam-season offer is explicitly part
  of §7 — if David keeps a distinct Cram/Points offer, BYOQ may not be the
  right primary entry for that segment's customer (someone arriving days
  before an exam is looking for guided, prioritized practice, not
  necessarily "bring your homework"). Treat "BYOQ is primary" as decided for
  the default/year-round path and open pending §10 items 1, 2, 4, and 9 for
  any cram-specific path.
- **Secondary entry: Cramapple-directed practice.** The existing cell-based
  mastery queue (Course Mode's `student_cell_state` engine, due-review
  surfacing, the `/home` skills rail) doesn't go away — it becomes what fills
  the gaps BYOQ doesn't cover: extra reps on a skill the student just
  learned, and the specific topics/skills Cramapple's recommendation logic
  flags as worth extra time (`LEARN-006`, not yet built).

**What does not change:** the mastery unit (cell = topic × skill), the
grading pipeline, the taxonomy/cell registry, INV-1 through INV-6, and CM-D20
("no freelance pedagogy at response time — teach only from
principles/content already codified"). This plan reuses that substrate; it
doesn't reopen it.

**Changed in this revision:** the first draft also declared "Cram Mode is
retired as a mode" DECIDED here. Review correctly separated two different
claims bundled into that sentence — that Cramapple doesn't need a *separate
backend* for cram behavior (true, and stays DECIDED, folded into this
section) versus whether Cramapple *retires cram as a customer-facing
proposition* (a commercial/positioning question, not decided by an
engineering observation). That second claim now lives in §7 as OPEN.

## 2. DECIDED — open-hand teaching is the hinge, not a Homework Mode feature

The "open hand" learn-first flow (`COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md`
§11.2: skill explainer → worked example shown open-hand → student's own cold
attempt) was scoped as part of Course Mode's skill-entry UX and, separately,
as Homework Mode's answer to "teach, don't solve." Under consolidation it's
not a feature of either — it's **the one teaching mechanism both entry
points route into**:

- BYOQ path: classify the uploaded/typed question to a cell → **open-hand**
  on a vetted parallel problem for that cell → hand the student's real
  question back unsolved, now-armed.
- Cramapple-directed path: student clicks a recommended skill → same
  **open-hand** sequence, already spec'd.

This is why the merge is coherent and not just a UI relabeling: both entry
points were always going to converge on the same explainer + worked-example +
cold-attempt loop. Consolidating the modes just makes that convergence the
architecture instead of an implementation coincidence. Review confirmed this
holds up against CM-D20 without qualification — nothing here freelances
pedagogy at response time.

## 3. PROPOSED — a new content family: skill scaffolds

The feedback asks for more than the explainer + worked example §11.2 already
scoped. Specifically: **key vocabulary, a skill description, diagrams, and
memory aids** (the example given — a mnemonic for Kingdom-Phylum-Class-Order-
Family-Genus-Species). This is a genuinely new content type, not a variant of
the existing item bank (MCQ/FRQ), and needs to be scoped as such rather than
folded silently into the §11.2 explainer.

**Proposed shape — the "skill scaffold" package**, extending the §11.2
explainer rather than replacing it:

- Skill description (plain-language, already implied by §11.2/§11.1's hover
  card — formalize it as a first-class field, not UI copy).
- Key vocabulary: term + definition, scoped to what's load-bearing for the
  skill (not a glossary dump).
- A diagram or visual, where one materially helps — reuses the existing
  visual-stimulus architecture (`VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`)
  rather than inventing new rendering.
- A memory aid / mnemonic, where a genuinely useful one exists. Not
  manufactured for every skill — most skills won't have one, and a forced
  mnemonic is worse than none.

**OPEN, flagged by review — grain is unresolved.** The first draft said "one
per skill" but its own example (a taxonomy mnemonic) is content knowledge
tied to a specific topic, not a general cross-topic skill. Cramapple's
mastery atom is the cell (topic × skill, INV-1); the same skill can recur
across topics, but not every piece of scaffold content is skill-grain. Before
authoring starts, `CONTENT-001` needs to fix which of these a given scaffold
element is:

- reusable, skill-level (applies wherever the skill appears);
- topic-level (vocabulary/diagram specific to one topic's content);
- cell-specific;
- subject-wide reference material.

Getting this wrong either duplicates authoring effort across every topic a
skill touches, or attaches the wrong scaffold to a student's classified need.

**Governance:** this is new authored content, so it falls under the same rule
everything else in the bank does — INV-3 (no unvetted generation), the
paid-tutor-author + independent-validator pipeline (`CONTENT-001`), and
rights/originality review before it ships (mnemonics in particular are often
pre-existing public phrases — a narrower version of the sourcing question in
§4). Scope as a new line item under `CONTENT-001`, not a side project.

## 4. PROPOSED — intake and the library-growth path

**DECIDED (per direction), clarified per second review:** both camera-photo
capture and worksheet upload are **target scope** — worksheet upload is not
cut from the plan in favor of photo-only. Whether they **launch
simultaneously** is a separate, open build-sequencing question (§10 item
12), not part of this decision — the former is defensible as stated; the
latter isn't yet supported by evidence (next paragraph).

**OPEN, flagged by review — the "both, simultaneously" reading would
reverse a deliberate prior sequencing decision without addressing why it
existed.** `HOMEWORK_MODE_DESIGN_2026_08_28.md`
sequenced text-interview first, then photo, then worksheet upload, so the
teach-not-solve guardrail loop could be proven before the harder inputs were
added. Worksheet support specifically adds segmentation (multiple questions
per page/packet), shared-stimulus handling, mixed subjects on one page,
missing pages, and a materially larger PII surface. The only feasibility
evidence on record — one rotated trigonometry photo, two readable questions,
analyzed directly by a model with no intake/persistence/security plumbing
(`HOMEWORK_IMAGE_CLASSIFICATION_EXPERIMENT_2026_08_25.md`) — supports
"classification generalizes broadly, worth building toward," not "multi-
question worksheet parsing is de-risked for simultaneous launch with photo."
Shipping both together stays the direction, but the build plan (§10 item 12)
should treat worksheet multi-question parsing as the harder of the two and
scope its own validation pass rather than assume photo's feasibility result
covers it.

**Library growth — revised twice now, most recently to fix a governance gap
the first revision still had.** The first draft proposed every parsed
question auto-staging as a draft candidate; the first revision replaced that
with a "quarantine pool" but treated entry into quarantine as itself
governance-neutral. Second review is right that it isn't: retaining an
upload-derived question anywhere Cramapple can later use it is already an
improvement use, whatever the pool is named, and calling it "quarantine"
doesn't make that retention private-session processing.

This plan now defines **three explicit data states**, not one pool:

1. **Private session artifact** — the extracted question as used to serve
   *that* student in *that* session. Short, approved retention window; not
   visible to content reviewers; this is the state the existing photo-
   discard promise (§11.3) actually governs, and stays consistent with it
   once "discard" is understood to mean this artifact, not necessarily every
   derived byte (see the retention-promise note below).
2. **Opted-in improvement candidate** — copied into the quarantine pool
   **only** under an approved consent/data-use basis (a student — or
   parent-purchaser, per whatever GOV-002 settles — opts in to Cramapple
   using their submission to improve the product), and only after an
   initial PII/source screening. This is new retention beyond serving the
   session, so it needs its own disclosure, not a re-use of the private-
   session promise.
3. **Canonical candidate** — promoted out of the quarantine pool per item,
   after rights/provenance and Learning Quality review, into the same
   pipeline every other authored item goes through.

A student consenting to state 2 does not by itself establish Cramapple's
right to retain or reuse a textbook's or teacher's copyrighted material that
happens to appear in their upload — consent covers the student's own
submission, not necessarily its source content. So entry into state 2 needs,
at minimum: an approved retention/consent basis, and source attestation or
source-type capture sufficient to decide whether retaining the full
extracted text is even permitted for that item. The quarantine lifecycle
(state 2 onward) also needs deletion, consent-withdrawal, takedown,
access-control, retention-limit, and contamination-handling procedures —
this plan names them as required properties rather than designing them here;
they belong to the governing designs (`DESIGN-002`/`DESIGN-003`, below).

- **Framing, corrected from the first revision:** this is best described as
  an **operationalization of `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
  §6.5's isolation principle, plus a proposed new opt-in retention path**
  (state 2) — not a wholesale supersession of §6.5. The per-item,
  human-decided promotion rule §6.5 establishes actually survives intact
  (it's exactly what governs the state 2 → state 3 transition); what's new
  is the opt-in mechanism that lets an item reach the quarantine pool at all
  before a human has looked at it. Needs Product Owner + Learning Quality
  sign-off as that addition, not as a wholesale rule change.
- **Every promoted item still needs its own path to release, not a shared
  "CM-D19-equivalent" label.** The first draft's phrase understated this.
  CM-D19 exists for instances generated from an already-approved Cramapple
  template with known parameters, provenance, and property-test coverage
  (`CM-D17`–`CM-D19`). A worksheet-extracted item has none of that by
  construction. A promoted candidate needs, per item: a rights/provenance
  determination, a completeness and curriculum-fit check, key/rubric
  construction (verified independently, not assumed from the source), an
  originality-or-licensed-reuse decision, independent validation, and only
  then a release decision. If counsel's rights determination requires
  independently rewriting rather than reusing a third-party question
  verbatim, this path has **not** skipped human authoring — it has moved
  where in the pipeline the human effort lands, which is exactly the
  throughput question below.
- **The "faster" claim is unproven and needs a two-stage test, not a single
  25-vs-25 pilot.** Second review correctly points out that a single pilot
  run against synthetic/owned worksheets can't measure the dominant real-
  world cost (rights rejection), because synthetic/owned material is
  deliberately rights-clean — its rejection rate would be zero or
  artificial by construction. Two stages:
  - **Stage A — pre-policy experiment** (can run now, no GOV gate): ~25
    parsed candidates from synthetic/owned worksheets against ~25
    conventionally authored candidates. Measures extraction, completeness,
    classification accuracy, rubric-construction effort, reviewer minutes,
    remediation rounds, and quality — everything *except* real-world rights
    exposure.
  - **Stage B — post-policy shadow study** (blocked per the staged gating
    table below): consented real uploads under approved governance,
    routed only as far as state 2 (the three-state model above) — **nothing released to
    students during this study.** Measures source eligibility, PII
    incidence, rights-rejection rate, duplication, missing-context rate,
    and full state-1-through-3 yield — the numbers Stage A structurally
    cannot produce.
  - **Design improvements for both stages:** match or stratify the 25-per-
    arm groups by subject/cell, MCQ vs. constructed response,
    diagram/shared-stimulus dependency, conceptual vs. deterministic item,
    and expected rubric size. Track expert minutes *per ingested candidate*
    (not only per released item), stage-by-stage survival (extracted →
    eligible → promoted → validated → released), whether each promoted item
    fills a prioritized coverage gap, total cost per released item
    (including processing/ops, not just review time), time-to-first-
    rejection alongside time-to-release, a blind final-quality pass, and
    confidence intervals rather than point estimates given n≈25 per arm.
  - **Predeclare a success threshold before running either stage** — e.g.,
    "proceed to build the production pipeline only if parsed sourcing
    reduces median expert time per quality-adjusted released item by ≥25%,
    without a higher defect rate" — and treat a result whose interval
    overlaps that threshold as inconclusive, requiring a larger sample,
    rather than a pass. Parsed candidates plausibly *accelerate discovery
    and classification* and still be *no faster to release* than authored
    content, because reviewers must first determine whether the source item
    is even usable — a real possible outcome, not a foregone one.
- **The photo-discard promise needs an explicit update, not a silent
  change.** `COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` §11.3 states the
  photo is read then discarded, no retention. That promise still holds for
  the **private session artifact** (state 1 above) — nothing changes there.
  What's new is state 2: an opted-in student's extracted text and
  provenance persisting beyond the session. That is a materially different
  data-use promise than "nothing is kept," applies only on opt-in, and
  needs its own disclosure and consent language rather than an assumption
  that the original promise already covers it.
- **This does not resolve the rights/privacy question, and can't yet, and
  the gate list is broader than either prior draft named.** `MASTER_TODO.md`
  GOV-001 (official-materials/rights) and GOV-002 (minor privacy/consent/
  upload handling) are both still `Proposed`, Product Owner hard gates, with
  counsel's related action (`NOW-006`) still `P0 / Expert Review Required`.
  **GOV-003** (provider retention/training terms, academic-integrity
  boundaries for teach/hint/check/solve modes) and **DESIGN-003** (upload
  validation, malware controls, retention architecture) are equally
  load-bearing and were named in the first revision but not enough — second
  review correctly adds that the quarantine-pool design (states 2-3 above)
  also depends on **`DESIGN-002`** (provenance, retention hooks, deletion,
  RLS, audit/event contracts — the actual mechanics states 2/3 need),
  **`DESIGN-004`** (reviewer entitlement, assignment, promotion,
  adjudication, release workflow — who does the per-item review in §4's
  promotion path), **`DESIGN-005`** (provider routing, failure behavior,
  observability, cost controls), and **`TASK-0005`/`CONTENT-001`** (source
  plans, reviewer qualifications, governed release requirements). The gate
  differs by stage, not uniformly "everything before anything":

  | Stage | Principal gates |
  | --- | --- |
  | Policy-neutral synthetic/owned parsing (Stage A above) | A bounded research protocol; no GOV/DESIGN gate |
  | Private real-upload intake (state 1) | GOV-001/002/003, DESIGN-003, relevant DESIGN-005 controls |
  | Opted-in quarantine retention (state 2) | Above, plus DESIGN-002 and an approved consent/retention/source policy |
  | Human promotion/review (state 2→3) | Above, plus DESIGN-004 and `CONTENT-001`/`TASK-0005` content-governance rules |
  | Student-facing release (state 3, served) | Full existing content-validation and release gates (`CONTENT-001`, D8/CM-D19-equivalent per-item path above) |

  Policy-neutral work can proceed now: page/question segmentation,
  extraction confidence and fail-closed behavior, synthetic PII/redaction
  testing, classification and coverage lookup, ephemeral processing
  interfaces, and Stage A's evaluation sets. Everything from state 1 onward
  against real data waits on the table above, staged rather than blocked
  uniformly. This is the same fail-closed posture the rest of the content
  system already uses.

## 5. PROPOSED — Cramapple-directed practice becomes explicitly a recommendation surface

Once BYOQ is primary, "Cramapple's own questions" need a clearer job than
"the rest of the bank." Two roles, both already implied by the feedback:

1. **Extra practice** on a skill the student just learned via BYOQ or
   open-hand entry — more reps on the same cell, pulled from the existing
   bank/generator content.
2. **Recommended focus** — when Cramapple's mastery/recommendation logic
   (`LEARN-006`, not yet built) identifies a weak or stale cell the student
   hasn't brought a question about, it's surfaced as a suggestion, not a
   forced detour. This is the existing `/home` skills-rail due-queue
   behavior, reframed as a recommendation rather than the default path.

This doesn't require new engine capability beyond what Course Mode already
built (`student_cell_state`, tier ladder, due-review surfacing) — it
requires `LEARN-006`'s recommendation logic, still `Proposed`, and a UI
reframe so it reads as "extra practice / recommended" rather than "the main
menu." See §7 for what happens before `LEARN-006`/`LEARN-007` exist.

## 6. What this does and doesn't require in new engineering

**Doesn't need new engineering:** the grading pipeline, the cell mastery
model, the taxonomy/cell registry, the deterministic + LLM grading split,
RLS/security posture, and the open-hand flow's core mechanics — all already
built (Course Mode) or spec'd (§11.2).

**Does need new engineering — corrected and expanded from the first draft,**
which understated this to "parsing, staging, and a content type." The real
surface, once §4's quarantine-pool design is accounted for:

- Multi-question worksheet parsing/segmentation (§4).
- Upload handling: file security, malware/format validation, extraction,
  PII/name redaction, retention and deletion enforcement, and provider-side
  data-handling controls (`DESIGN-003`, `GOV-003`) — not incidental to the
  parsing feature, a prerequisite to it touching real data at all.
- The quarantine-candidate pool itself: schema, promotion workflow,
  provenance tracking, and its own reviewer queue distinct from the existing
  content-authoring queue.
- The skill-scaffold content type (§3) and its authoring/rendering path.
- Observability and cost limits on the new upload/parsing surface, matching
  the operational rigor already required of the rest of the platform
  (`DESIGN-005`).

## 7. OPEN — Cram Mode's commercial fate, separate from its engineering fate

**This section did not exist in the first draft; it replaces the earlier
"Cram Mode is retired" claim in §1.** Review is right that retiring a
separate backend is not the same decision as retiring cram as a
customer-facing proposition, and the plan shouldn't imply the second follows
from the first.

What's still live and unresolved:

- `CRAMAPPLE_VISION.md` currently defines the entire commercial model around
  the cram case: a ten-day design center, "score optimization, not tutoring"
  positioning (§11.1), one-time purchase pricing (§12.1), and an exam-season
  commercial push (§12.2). Making everyday homework help the primary entry
  point changes usage cadence, acquisition message, support burden, and
  plausibly the pricing model (year-round use points toward subscription or
  term-length access; cram use supports the existing one-time purchase). It
  also risks moving Cramapple's category from the deliberately narrow "score
  optimization" position toward the much more crowded "AI homework help"
  category the vision doc explicitly positioned against.
- `COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` §2/§11.5 already has a
  student-facing Learn/Points distinction, with Points as a fast-follow and
  a near-exam nudge. This plan doesn't say whether Points survives as-is,
  gets replaced by an automatic pacing shift, or is effectively what "Cram
  Mode" was always going to become. That needs to be decided explicitly, not
  left implicit.
- `LEARN-007` (year-aware readiness, decay, pacing prior) is still
  `Proposed` and can't yet carry an "exam-proximate pacing setting" claim on
  its own — its readiness/decay/queue-competition model is unresolved. It
  also doesn't solve the cold-start case on its own: a student arriving
  three days before their exam has little or no mastery history, so urgency
  handling needs a fallback (time-budget capture, fast calibration,
  exam-blueprint-weighted prioritization) independent of accumulated cell
  state, not just "a different decay prior." Until `LEARN-006`/`LEARN-007`
  exist, this plan has no answer for that student — see §10 item 10.

This is explicitly Product Owner + Micah territory (positioning, pricing,
launch sequencing), not something an engineering-consolidation plan should
settle by implication.

## 8. Deferred, separate from this plan — Study Buddy groups

Multiple students asked about linking accounts into study groups. This is
explicitly **not** part of the consolidation work above — it's a distinct
future-version idea with its own product, privacy, and social-design
questions (who sees what across linked accounts, whether it's opt-in per
student or per parent-purchased account, whether it changes the minor-privacy
posture in GOV-002, abuse/moderation surface). Recorded as `SOCIAL-001` in
`MASTER_TODO.md`'s deferred backlog (added in the same commit as this plan,
alongside `PARENT-001`/`EXPAND-001`) — not developed further here.

## 9. Backlog corrections from this revision

- `NOW-015` (added when `USE_MODES_STRATEGIC_RECONCILIATION.md` was written)
  asked David to resolve "Cram Mode vs. Course Mode positioning" and
  first-mode sequencing. This plan answers the engineering-sequencing half of
  that (§1) but **not** the positioning half — §7 shows that's still open
  and arguably harder than originally framed. `NOW-015` needs rewording, not
  closing, to point at §7's commercial questions specifically rather than
  the now-resolved "which mode ships first" framing. Done in this revision's
  commit alongside the plan text.
- `SOCIAL-001` was added correctly in the first draft's commit — no change
  needed there; it wasn't part of the "not done in this pass" note below,
  which refers only to promoting this plan's own execution items.

## 10. Open decisions (David's call)

Reordered twice now per two rounds of review. Evidence basis moves to the
top this round — second review correctly flagged it as upstream of treating
BYOQ-primary as decided at all, not merely upstream of a launch commitment.
An academic-integrity/value-boundary decision is added (previously
missing), and item 7 (GOV urgency) is replaced with a concrete decision —
asking whether an already-P0-hard-gated item is "urgent" wasn't actionable.
In priority order:

1. **Evidence basis**: document the student feedback behind §0 (sample
   size, how students were asked, stated preference vs. observed behavior)
   before *any* of the decisions below — including BYOQ-primary itself
   (§1) — are treated as resting on solid ground rather than a working
   hypothesis.
2. **Category and promise**: does Cramapple lead with score optimization,
   homework-powered year-round learning, or an explicitly staged
   combination (§7)?
3. **Points/Cram's fate**: does a named cram-proximate commercial offer and
   student-selectable state survive consolidation, or does urgency become
   purely an automatic backend behavior with no user-facing equivalent (§7)?
4. **Pricing and access model**: does year-round BYOQ use require a
   different access model than the current one-time-purchase hypothesis
   (§7, `CRAMAPPLE_VISION.md` §12.1)?
5. **Launch subject**: Cram/vision's canonical launch is AP Biology; Course
   Mode's proven pilot is AP Statistics. Which subject carries the
   consolidated product, and what minimum BYOQ coverage rate is required
   before launch?
6. **§6.5 operationalization approval**: does Product Owner + Learning
   Quality approve the three-state (private/opted-in/canonical) mechanism
   in §4 as an operationalization of `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
   §6.5 plus a new opt-in retention path — not a rule change to §6.5's
   per-item promotion principle itself, which the mechanism keeps intact?
7. **Reuse boundary**: may a quarantined item ever be used verbatim (once
   rights-cleared), or must promoted content always be independently
   rewritten from the parsed source?
8. **Academic-integrity / value boundary** (new): what exactly can a
   student receive on their own submitted question (teach/hint/check/solve,
   per the existing UX-004 modes and CM-D20); when does Check My Work
   unlock relative to the parallel open-hand item; and does the
   teach-not-solve product still hold up as valuable once BYOQ is the
   *primary* job rather than an occasional feature — worth testing, not
   assuming, given how central BYOQ becomes under this plan.
9. **Data posture for intake/retention/promotion** (replaces "GOV urgency"):
   GOV-001/002/003 are already P0 hard gates, so the open question isn't
   whether to escalate them — it's which specific data posture applies at
   each of the three states in §4 (private session / opted-in quarantine /
   canonical promotion), and who owns a **dated** counsel deliverable
   resolving it. Without a named owner and date this stays open
   indefinitely by default.
10. **Skill-scaffold authoring ownership and grain**: Orly's
    Learning-Quality-Owner scope under `CONTENT-001` (recommended, matches
    every other content type), and resolution of the skill/topic/cell grain
    question in §3.
11. **Cold-start / pre-`LEARN-006`-`007` behavior**: what does a student
    arriving days before their exam get, given the recommendation and
    pacing logic this plan leans on isn't built yet (§7)?
12. **Naming**: does the consolidated mode get a new name ("Learn"), or does
    an existing name absorb the other's scope?
13. **Build sequencing** (corrected — "none strictly blocks another" was
    wrong): policy-neutral prototyping (BYOQ-primary UI reframe using
    what's already built; Stage A of the parsing experiment; skill-scaffold
    authoring) can proceed independently and in parallel. Production paths
    cannot: any real-upload persistence is blocked on item 9's data-posture
    decision clearing (§4's staged gating table), and worksheet
    multi-question parsing specifically needs its own validation pass
    (Stage A, then Stage B) before it's treated as launch-ready — it is not
    de-risked by the photo path's feasibility result. `LEARN-006`'s
    recommendation logic has no such external gate; it's purely a build-
    time competition with the rest.

**Backlog follow-through once directions are confirmed:** promote this plan
into `MASTER_TODO.md` as a real tracked item (working ID `LEARN-008`) with
the engineering sub-scopes from §6 as its execution items. Not done in this
pass because the plan's scope is still moving under the decisions above;
recording it as a tracked backlog item before that would fix a scope that
hasn't settled. `SOCIAL-001` is unaffected by this — it was already added as
a placeholder, not a scoped item.
