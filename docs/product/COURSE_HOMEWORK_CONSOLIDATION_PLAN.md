# Course + Homework Mode Consolidation Plan

STATUS: plan, nothing built | DATE: 2026-09-17 | AUDIENCE: David, LLM-first entry
point for any session picking this up.

This is a **plan**, not an implementation. Nothing described here is built. It
supersedes the "which mode ships first" framing in
`USE_MODES_STRATEGIC_RECONCILIATION.md` §3.3–§4 with a direct answer from
student feedback: **Course Mode and Homework Mode are not two modes to
sequence — they're one experience students already see as the same thing.**
Cram Mode stops being a peer mode and becomes a behavior the same engine
adopts near the exam. Where a point is a firm product direction from this
session it's tagged **DECIDED**; where it's this session's recommendation
awaiting sign-off it's **PROPOSED**; unresolved calls are **OPEN**.

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

This lines up with, and resolves, the open sequencing question in
`USE_MODES_STRATEGIC_RECONCILIATION.md`: the "one engine, three entry points"
thesis in that document was correct, but the entry points aren't Cram/Course/
Homework — they're **bring-your-own-work** (the everyday default) and
**Cramapple-directed practice** (the supplement), with exam-window urgency as
a pacing behavior layered on top of whichever entry point the student is
already using.

## 1. DECIDED — the consolidated shape

**One mode, working name "Learn"** (naming itself is open, §8). It replaces
the Course Mode / Homework Mode split entirely; there is no longer a reason
to build or document them as separate surfaces.

- **Primary entry: bring-your-own-question (BYOQ).** A student's actual
  homework, worksheet, or class question is the default way into a session,
  not an alternate path bolted onto guided roaming.
- **Secondary entry: Cramapple-directed practice.** The existing cell-based
  mastery queue (Course Mode's `student_cell_state` engine, due-review
  surfacing, the `/home` skills rail) doesn't go away — it becomes what fills
  the gaps BYOQ doesn't cover: extra reps on a skill the student just
  learned, and the specific topics/skills Cramapple's recommendation logic
  flags as worth extra time (`LEARN-006`, not yet built).
- **Cram Mode is retired as a mode.** What it described — urgent framing,
  aggressive pacing, exam-proximate prioritization — becomes a *pacing
  setting* the same engine applies as the exam date approaches, already the
  intended shape of `LEARN-007` (year-aware readiness, decay, pacing prior).
  It is not a separate build, screen, or content path. A student who opens
  the app for the first time three days before their exam should get the
  same engine, tuned urgent; that's a parameter, not a fork.

**What does not change:** the mastery unit (cell = topic × skill), the
grading pipeline, the taxonomy/cell registry, INV-1 through INV-6, and CM-D20
("no freelance pedagogy at response time — teach only from
principles/content already codified"). This plan reuses that substrate; it
doesn't reopen it.

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
architecture instead of an implementation coincidence.

## 3. PROPOSED — a new content family: skill scaffolds

The feedback asks for more than the explainer + worked example §11.2 already
scoped. Specifically: **key vocabulary, a skill description, diagrams, and
memory aids** (the example given — "King Phillip Came Over For Good Soup" /
similar mnemonics for Kingdom-Phylum-Class-Order-Family-Genus-Species). This
is a genuinely new content type, not a variant of the existing item bank
(MCQ/FRQ), and needs to be scoped as such rather than folded silently into
the §11.2 explainer.

**Proposed shape — the "skill scaffold" package**, one per skill (same grain
as the §11.2 explainer, which this extends rather than replaces):

- Skill description (plain-language, already implied by §11.2/§11.1's hover
  card — formalize it as a first-class field, not UI copy).
- Key vocabulary: term + definition, scoped to what's load-bearing for the
  skill (not a glossary dump).
- A diagram or visual, where one materially helps (structural diagrams,
  process flow, relationship diagram) — reuses the existing visual-stimulus
  architecture (`VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md`) rather than
  inventing new rendering.
- A memory aid / mnemonic, where a genuinely useful one exists for that
  skill. Not manufactured for every skill — most skills won't have one, and
  a forced mnemonic is worse than none.

**Governance implication, not yet resolved:** this is new authored content,
so it falls under the same rule everything else in the bank does — INV-3
(no unvetted generation), the paid-tutor-author + independent-validator
pipeline (`CONTENT-001`), and rights/originality review before it ships
(mnemonics in particular are often pre-existing public phrases, which raises
a narrower and easier version of the same sourcing question already open for
Homework Mode's parsed content, §4). This should be scoped as a new line
item under `CONTENT-001`, not a side project — see §8.

## 4. PROPOSED — intake and the library-growth path

**DECIDED (per direction):** both camera-photo capture and worksheet upload
ship, not one gating the other. Worksheet upload additionally needs
**multi-question parsing** — extracting each individual question from one
uploaded page/packet, not just reading a single problem the way the photo
path does today. This is new scope beyond what the filed-away homework-image
experiment tested (`HOMEWORK_IMAGE_CLASSIFICATION_EXPERIMENT_2026_08_25.md`
tested one problem at a time); the two-gate finding from that experiment
still applies to every extracted question independently — classify
generalizes broadly, vetted-content coverage is what's actually scarce.

**Library growth (the part chosen to move fast on):** the direction taken
was the lighter-weight, faster candidate path over the full-rigor human
pipeline. Concretely, that means:

- A parsed question becomes a **draft candidate** automatically — classified
  to a cell, structurally checked (duplicate detection against the existing
  bank, basic completeness), and staged in the same `draft` /
  `unreleased_generated_pending_review` state the generator pipeline already
  produces content in. This skips the step of commissioning a human author
  to write it from scratch — parsing replaces authoring, not validating.
- It does **not** skip release: a parsed candidate still needs a rubric
  package, independent review, and a CM-D19-equivalent release stamp before
  it ever serves a student, exactly like every other bank item (INV-3 is not
  negotiable content-quality policy; the speed gain is in candidate
  *sourcing*, not in bypassing validation).
- **This does not resolve the rights/privacy question, and can't yet.**
  `MASTER_TODO.md` GOV-001 (official-materials and rights policy) and GOV-002
  (minor privacy/consent/upload handling) are both still `Proposed`,
  unowned by counsel sign-off. A worksheet photo may contain a teacher's or
  textbook's copyrighted material, another student's name or handwriting, or
  school-identifying information. "Move fast on library growth" is a product
  preference; it cannot override an unresolved legal gate. **This plan
  treats GOV-001/GOV-002 resolution as a hard prerequisite to turning on
  *any* parsed-candidate flow against real student uploads** — the parsing
  and classification technology can be built and tested against synthetic
  or internally-sourced worksheets in the meantime, but the pipeline stays
  off for real uploads until that gate clears. This is the same
  fail-closed posture the rest of the content system already uses; it isn't
  a new constraint invented for this plan.

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
menu."

## 6. What does NOT need new engineering

Worth naming explicitly, since it bounds the plan: the grading pipeline, the
cell mastery model, the taxonomy/cell registry, the deterministic + LLM
grading split, RLS/security posture, and the open-hand flow's core mechanics
are all already built (Course Mode) or spec'd (§11.2). Consolidation is a
**framing, entry-point, and content-scope change**, not a rebuild of the
backend. The new engineering surface is: multi-question worksheet parsing,
the parsed-candidate staging pipeline (gated per §4), and the skill-scaffold
content type (§3) plus its authoring/rendering path.

## 7. Deferred, separate from this plan — Study Buddy groups

Multiple students asked about linking accounts into study groups. This is
explicitly **not** part of the consolidation work above — it's a distinct
future-version idea with its own product, privacy, and social-design
questions (who sees what across linked accounts, whether it's opt-in per
student or per parent-purchased account, whether it changes the minor-privacy
posture in GOV-002, abuse/moderation surface). Recorded as a new deferred
backlog item (§8) so it isn't lost, not developed further here.

## 8. Open decisions (David's call) and backlog follow-through

1. **Naming**: does the consolidated mode get a new name ("Learn"), or does
   an existing name (Course Mode) just absorb Homework Mode's scope? Affects
   every doc that currently says "Course Mode" or "Homework Mode."
2. **Sequencing within this plan**: build order across (a) reframing BYOQ as
   primary entry using what's already built, (b) worksheet multi-question
   parsing, (c) the skill-scaffold content type, (d) `LEARN-006`
   recommendation logic. None strictly blocks another, but they compete for
   the same limited build time.
3. **GOV-001/GOV-002 urgency**: given §4 makes them a hard prerequisite for
   real-upload library growth, should they be escalated ahead of their
   current `Proposed` status in `MASTER_TODO.md`?
4. **Skill-scaffold authoring ownership**: does this become Orly's
   Learning-Quality-Owner scope under `CONTENT-001` (recommended, matches
   how every other content type is owned), or does it need a distinct
   owner/workflow given it includes non-question content (diagrams,
   mnemonics)?

**Backlog follow-through once directions are confirmed:** promote this plan
into `MASTER_TODO.md` as a real tracked item (working ID `LEARN-008`) with
the four sub-scopes from §6 as its execution items, and add a `P3` deferred
entry for Study Buddy groups alongside `PARENT-001`/`EXPAND-001`. Not done in
this pass because the plan itself is still awaiting the decisions in items
1–4 above; recording it as backlog before that would create a tracked item
with no settled scope.
