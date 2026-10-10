# Reference Pack + Question Page Template — Session Close

**STATUS:** Documentation complete; question-page implementation not started

**DATE:** 2026-10-09 (America/New_York)

**OWNER:** David Bloom / next implementation session

**REPOSITORY BRANCH:** `claude/task-0067-production-records`

**LOVABLE PROJECT:** `56cae479-f7c9-4988-b536-56538c38ee4e` (New Cramapple App)

**PRODUCTION:** Unchanged by this session

## 1. Current task

This session connected two pieces of the learning experience:

1. define how the 91-topic AP Chemistry CED scope inventory becomes a checked **Reference Pack** of
   vocabulary, equations/relationships, and memory hooks; and
2. document the proposed core question-page template that selects a small, question-relevant subset
   of that pack for Worked Examples, graded Practice, and BYOQ.

The durable content protocol is now in
`docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md`. The question-page template is recorded
here and in the activity log. A local rendering and Lovable prompt were prepared, but the prompt was
not sent and no Lovable code was changed.

## 2. What changed this session

### 2.1 AP Chemistry Reference Pack protocol

Added a full “Reference Pack build protocol” to the 91-topic inventory. It defines:

- the product boundary between the complete Lesson Notes pack and the smaller question-page subset;
- CED-only inclusion and exclusion rules;
- candidate consolidation, owner topic, and cross-topic reuse;
- required evidence and provenance for every row;
- distinct writing rules for vocabulary, equations/relationships, and memory hooks;
- the configured extraction/checker/veto workflow;
- planted-defect controls, stateless Round 2, and evidence-based Product Owner escalation;
- component-level and unit-level acceptance gates;
- Development load and RPC QA; and
- Production hard gates and rollback order.

### 2.2 Question-page template

The proposed page makes the center question the primary task and turns the left and right panes into
compact, mode-aware support.

#### Header

- Move `Return to student hub`, `Change topic`, and the subject selector into the orange bar.
- Directly below it, show the subject/unit/topic breadcrumb, lesson title/subtitle, and learning-mode
  label.
- Show session position as plain `current/total` text only, for example `2/5`.
- Remove `exam in __ days`, mastery summaries such as `5 of 8 mastered`, the segmented progress bar,
  and `Save and stop` from the core work-page strip.
- Keep the exam countdown on the Student Hub.
- Preserve server/session persistence even though `Save and stop` is removed from this strip.

#### Left pane

- **Worked Example MCQ:** choices and revealed rationales appropriate to a worked example.
- **Worked Example FRQ:** rubric, what earns each point, and common point-loss guidance.
- **Graded Practice:** no answer key, correctness, earned/lost point state, or canonical answer before
  submission; authorized answer/rubric feedback after submission only.
- **BYOQ:** ungraded topic-aligned guidance such as “How points are earned,” what this kind of question
  asks for, and common pitfalls. Never claim that the student's answer is correct, incorrect, earned,
  or lost a point.

#### Center pane

- Keep the stimulus, question, student/worked response, and primary actions here.
- Worked Example remains illustrative and unscored.
- Practice remains the existing scored attempt flow.
- BYOQ shows the student's question read-only and provides support without grading it.

#### Right pane

- Skills
- Vocabulary, maximum three terms selected for the question
- Relevant equations, graphs, diagrams, or other visuals
- One directly relevant Memory Hook when available
- One Full Lesson Note link

The full Reference Pack belongs in Lesson Notes. The question page is a filtered projection. Empty
sections, fake counts, placeholder academic content, and developer copy are omitted. This task does
not build or redesign the Notes page.

#### BYOQ loading rule

Before both unit and topic are confirmed, do not guess, auto-select the first topic, or show unrelated
support. Show a focused confirmation state. Immediately after both are confirmed, use the existing
topic-content path (`fetchTopicGuides` or its current equivalent) to populate both support panes. Show
truthful loading/unavailable states and never fabricate content. BYOQ must not call `evaluate-attempt`,
import answer-key logic, expose `is_correct`, or display a canonical answer.

#### Responsive and accessible behavior

- Desktop: left guidance / center question / right reference.
- Narrow screens: center question first, then left guidance, then right reference.
- Orange-bar controls wrap without overlap or horizontal scrolling.
- Accordions use semantic buttons and state; focus remains visible; color is not the only signal.

## 3. How to make a Reference Pack

### 3.1 Inputs and grain

Use the current CED PDF as authority, the fact pack as an extraction aid, the 91-topic inventory as the
completeness/boundary checklist, and current taxonomy rows as valid keys. Build one unit per batch.
Unit 4's 22 checked Production entries are reused rather than regenerated.

Convert row-level scope into one-entry/one-lookup-need candidates. Combine synonyms and inseparable
ideas, split entries with different definitions or conditions, and assign ownership to the first topic
that requires the entry. A later topic enters `topic_codes` only when its own CED objective or essential
knowledge uses the entry.

### 3.2 Required candidate record

Every candidate records:

- stable id, subject, unit, owner topic, and reuse topics;
- kind: vocabulary, formula, list/sequence, convention, or diagram;
- title, body, ordered items, and governed visual reference when applicable;
- use conditions, non-use boundary, assumptions, and caution;
- CED edition, page, topic, and LO/EK identifiers;
- batch/source/model/date provenance;
- for equations: accepted name, LaTeX, symbol meanings, units/constraints, and equation-sheet status;
- for hooks: a proposed hook or explicit `no_hook`, linked to one reference entry.

### 3.3 Vocabulary rules

Use the CED meaning and preferred chemistry language. Definitions should be concise but include the
distinction that makes the term useful and the condition that prevents the predictable misconception.
When classroom shorthand differs from point-earning language, the definition uses the exam-safe
wording and `caution` explains the difference.

### 3.4 Equation rules

Give the accepted name and correct LaTeX expression; define every symbol; state required units,
temperature scale, standard-state assumptions, and sign convention; explain when evidence calls for
the relationship and when it must not be used. Do not turn a proportional or qualitative trend into a
false equality. Equation-sheet availability is metadata, not a reason to omit the entry.

### 3.5 Memory Hook rules

A hook exists only to recall one accepted reference entry. Its expansion is complete and correctly
ordered; scope comes from the linked entry. Use familiar public-domain devices or short
Cramapple-authored phrases, record the rights provenance, and add a caution when the hook is not the
language that earns the exam point. Songs, lyrics, audio, and publisher-specific novel wording are out.
“No hook” is a valid and expected result.

### 3.6 Checker workflow

1. Extract candidates from the unit's CED pages and fact-pack section.
2. Before checking, create six CED-verified defects: wrong formula/definition, excluded/non-CED item,
   wrong owner, wrong list/order, wrong hook expansion, and another-unit content.
3. Run two independent checker families on factual accuracy, CED inclusion, topic ownership/reuse,
   conditions/cautions, and evidence. Check hook expansion, linkage, admissibility, and provenance
   separately.
4. Run the extractor-family audit as reject-only. It cannot rewrite a row or rescue a rejection.
5. Re-sample a flag once; only a repeated flag counts. Both independent checkers must accept and the
   audit must not repeatedly veto. Entry and hook outcomes remain independent.
6. All six controls must be rejected. An invalid control is replaced and controls alone rerun; a valid
   leaked control voids the batch.
7. Rejected content gets a stateless Round 2 from title, owner, and original CED evidence without
   checker reasons. Do not hand-edit generated rows.
8. Persisting disagreement goes to the Product Owner with the candidate, CED evidence, and reasons.
   Resolve against evidence; do not stage a semantic debate between models.

Configured roster on 2026-10-09: Claude Sonnet 5.5 extraction, Gemini 3.5 Flash and GPT-6 Sol as the
independent checkers, and Claude Haiku 5.5 as the reject-only own-family audit. Any roster change needs
the production protocol's smoke test and batch-level Product Owner ratification.

### 3.7 Completeness and publication

A unit is complete only when every inventory phrase has a recorded disposition: accepted, consolidated
into a named accepted entry, or excluded with CED evidence. Validate ownership, reuse topics, duplicate
resolution, no-hook outcomes, controls, checker verdicts, and every CED boundary.

Preserve candidates, controls, verdicts, counts, no-hook outcomes, escalation decisions, generated SQL,
QA results, model slate, and cost. Do not commit raw JSONL model logs. Load generated SQL into
Development, run `scripts/qa/unit_reference_and_memory_hooks_qa.sql`, and probe a populated topic, a
hook topic, the unit roll-up, and an empty result. Production requires a named approval, the same SQL,
repeated QA, and separate frontend-publish approval. Retire hooks before linked entries.

## 4. What was verified

- The new AP Chemistry protocol was reread in place after editing.
- `docs/INDEX.md` now describes the inventory as containing the Reference Pack build protocol.
- The local 1440×900 @2x rendering was regenerated and visually inspected; its lesson strip contains
  the learning-mode label and only `2/5`—no exam countdown, mastery summary, segmented bar, or
  `Save and stop`.
- Markdown whitespace checks passed for the tracked index change.
- No model authoring/checking run, database query, RPC change, Lovable build, or deployment was run in
  this documentation session.

## 5. What remains open

- The question-page prompt has not been sent to Lovable, so no shared shell or BYOQ pane-loading change
  exists yet.
- The local rendering covers the Worked Example FRQ desktop state only; MCQ, graded Practice, BYOQ
  pre-confirmation/post-confirmation, mobile order, and accessibility still require implementation and
  QA.
- The Full Lesson Note link must use an existing destination; a route must not be invented.
- Formula rendering remains an existing design item; current Production can show LaTeX source.
- AP Chemistry units outside the checked Unit 4 pilot remain scope inventory, not published content.

## 6. Open blockers and risks

- The working tree contains unrelated tracked and untracked changes owned by other work. Do not clean,
  reset, stage, or rewrite them during this closeout.
- A shared frontend shell must preserve mode-specific security: Practice cannot leak answer truth and
  BYOQ cannot inherit grading behavior merely because components are shared.
- Selecting three vocabulary terms and a single hook for a question needs a deterministic relevance
  rule; arbitrary first-three selection would undermine the Reference Pack design.
- Treat the old local prompt/rendering under `output/` as a convenience artifact, not durable source of
  truth. This handoff and the product inventory are the durable records.

## 7. Files changed or checked

Changed:

- `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md`
- `docs/INDEX.md`
- `docs/activity_log/ACTIVITY_LOG.md`
- this handoff

Local-only artifacts changed/created but not committed as source of truth:

- `output/core-page-rework-rendering/core-page-rework.html`
- `output/core-page-rework-rendering/core-page-rework@2x.png`
- `output/lovable-prompts/core-work-page-rework-2026-10-09.md`

Checked:

- `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`
- `docs/tasks/TASK-0066-MEMORY-HOOKS.md`
- `docs/tasks/TASK-0067-UNIT-REFERENCE-CONTENT.md`
- `scripts/content-seed/task0067-reference-pilot-2026-10-09/README.md`
- `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`
- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- `prompts/CLOSE_SESSION_PROMPT.md`

## 8. Commands and tests

- Targeted `sed`, `rg`, and `wc` reads only; no broad repository scan.
- `/Users/davidbloom/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node output/core-page-rework-rendering/render.mjs` — passed; PNG regenerated.
- `view_image` on the regenerated PNG — passed visual inspection for the header change.
- `git diff --check -- docs/INDEX.md` — passed.

No application test suite was run because no application source changed.

## 9. Approval and implementation state

- Documentation: complete for this session.
- Reference Pack Production system: existing approved system remains governed by `DECISION-0104`,
  `DECISION-0105`, `DECISION-0107`, and `APPROVAL-0140`.
- AP Chemistry expansion beyond Unit 4: not generated, checked, or approved for Production.
- Question-page redesign: documented proposal only. Not sent to Lovable; not built in Preview; not
  published; no backend change.

## 10. Exact next step and do-not-touch scope

**Next owner:** David Bloom or the next Lovable implementation session.

**Single best next action:** review this template, then send one implementation prompt to Lovable
Preview for the shared shell across Worked Example MCQ/FRQ, Practice MCQ/FRQ, and BYOQ. Require the
agent to report changed routes/components, the exact BYOQ topic-content call path, tests, commit hash,
Preview URL, and confirmation that Production was not published.

**Do not touch next session:** the database schema, scoring contracts, attempt persistence,
answer-authorization boundary, Student Hub exam countdown, Production publish state, Notes-page design,
or unrelated dirty-tree files.

Recommended restart prompt:

> Read `docs/handoffs/REFERENCE_PACK_AND_QUESTION_PAGE_SESSION_CLOSE_2026_10_09.md` and the embedded
> Reference Pack protocol in `docs/product/AP_CHEMISTRY_CED_SCOPE_INVENTORY_2026_10_09.md`. Implement
> only the documented shared question-page template in Lovable Preview. Preserve Practice answer
> security and BYOQ no-grading. Do not change the backend or publish to Production. Wait for completion,
> inspect the diff and tests, and report the Preview checkpoint.
