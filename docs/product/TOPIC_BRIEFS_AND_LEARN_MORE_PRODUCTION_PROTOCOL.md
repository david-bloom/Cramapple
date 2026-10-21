# Topic Briefs And Learn More Production Protocol

Status: Canonical operating protocol.

Owner: Product Owner / Learning Quality.

Applies to:

- Topic point briefs shown on student topic cards.
- Topic explainers shown through `Learn more`.

Purpose: define how Cramapple creates, reviews, publishes, verifies, and
retires topic-guide content before students can use it.

## Definitions

A **topic point brief** is the compact student-facing card payload for one
subject, unit, and topic. It explains what the topic is, why it matters, how it
turns into AP points, the answer move to practice, and the common point loss to
avoid.

A **topic explainer** is the richer `Learn more` payload for the same subject,
unit, and topic. It gives enough instruction for the student to understand the
scoring move and return to practice. It is not a textbook lesson, article
library, or replacement for class instruction.

The two documents are paired by:

- canonical `subject_key`, such as `ap_biology`;
- exact `topic_code`, such as `1.1`.

`unit_number` must agree between the paired rows, but the database uniqueness
key is `(subject_key, topic_code)`. A unit drift can make a unit-scoped RPC
return a brief without its explainer, so unit equality is a required QA check.

## Source Of Truth

Canonical student runtime source:

- `app.topic_point_briefs`
- `app.topic_explainers`
- `public.get_topic_point_guides(subject_key, unit_number, topic_code)`

The frontend must prefer `public.get_topic_point_guides` because it normalizes
subject keys and returns paired briefs and explainers together.

Repository source records may live in Markdown product documents and SQL
migrations, but once content is published, Supabase is the runtime source of
truth. Markdown files preserve rationale and review history; they are not a
separate runtime content store.

## Database Contract

The application tables use canonical underscored subject keys, such as
`ap_biology`. `app.subjects` also carries registry-facing keys used by the
student selector, such as `biology` or `ap-statistics`. The public views expose
that student-facing registry key as `subject_key`, plus
`canonical_subject_key` for the app-content key. The RPC accepts either
namespace through `app.normalize_student_subject_key(...)`, returns canonical
camelCase JSON, and should be the frontend's normal read path.

Publishing depends on all of these being true:

- `app.subjects` has an active row for the normalized subject key.
- `class_importance` and `exam_importance` are one of `not-important`,
  `somewhat-important`, or `very-important`.
- `status` is one of `draft`, `published`, or `retired`.
- `topic_code` and `practice_topic_code` match `^[0-9]+\.[0-9]+$`.
- `learn_more_path` starts with `/learn/` and uses the hyphenated route subject
  segment, such as `/learn/ap-biology/unit-1/...`.
- Published rows have `published_at`; draft or retired rows should not acquire a
  new publication timestamp accidentally.

Idempotent updates should preserve the original `published_at` unless the batch
is intentionally republishing previously unpublished content.

## Content Standard

Every topic point brief must be:

- Cramapple-authored and original;
- tied to a real subject, unit, and topic in the approved taxonomy;
- specific to point attainment, not generic study advice;
- concise enough for a topic card;
- free of external links;
- free of copied third-party, released, secure, or official question language;
- careful not to imply College Board affiliation or endorsement.

Every topic explainer must:

- use the paired point brief as its anchor;
- preserve the exact subject, unit, and topic;
- explain the AP-quality answer move, not just the concept;
- include a topic-specific weak-answer / point-attaining-answer contrast;
- use a topic-specific mini-example, not a generic title-interpolation prompt;
- move the student back toward practice;
- avoid diagnostic, cold-assessment, secure, or answer-bearing content.

Recommended budgets:

- `what_it_is`: 80-260 characters.
- `why_it_matters`: 80-260 characters.
- `answer_move`: 80-320 characters.
- `core_idea`: 100-360 characters.
- `point_attaining_answer`: 120-520 characters.

Rows outside these ranges are not automatically wrong, but the reviewer must
record why the extra length or brevity helps students.

## Required Fields

Topic point brief required fields:

- `subject_key`
- `unit_number`
- `topic_code`
- `title`
- `class_importance`
- `exam_importance`
- `what_it_is`
- `why_it_matters`
- `how_points_are_earned`
- `answer_move`
- `common_point_loss`
- `learn_more_path`
- `practice_subject_key`
- `practice_unit_number`
- `practice_topic_code`
- `source_note`
- `status`

Topic explainer required fields:

- `subject_key`
- `unit_number`
- `topic_code`
- `title`
- `core_idea`
- `what_students_need_to_understand`
- `how_this_becomes_points`
- `answer_move`
- `mini_example_question`
- `weak_answer`
- `point_attaining_answer`
- `common_point_loss`
- `practice_bridge`
- `source_note`
- `status`

## Sequential Unit Authoring

Author a unit in topic order unless an explicitly scoped prototype requires a
later topic. Before drafting each topic, maintain a unit content ledger with:

- concepts, vocabulary, formulas, representations, and answer moves already
  introduced;
- the topic where each item was first introduced;
- items that are genuinely new in the current topic;
- prior items that require retrieval, application, extension, or correction;
- shared material assigned to the unit reference instead of repeated on topic
  cards.

Each topic Deep Dive should teach the instructional delta. It may briefly cue a
prior idea when needed, but should link or refer back instead of redefining it.
The distinction must be explicit in the authoring packet:

- `new_here`: first introduced in this topic;
- `builds_on`: previously introduced and necessary for the current task;
- `unit_reference`: shared reference material not owned by the topic;
- `future_topic`: related content that belongs later in the sequence.

The completed topic packet updates the ledger before authoring begins on the
next topic. This cumulative record is an editorial production artifact; it does
not require a production schema change.

## Phase 0: Consolidated Current Content

Before rewriting or restructuring content, Deep Dive may act as the single
student-facing compilation of the current reusable unit/topic guidance. Phase 0
is a presentation and editorial-inventory step, not a schema migration and not
a transfer of runtime authority.

For each topic, assemble a local derived packet from the current unit/topic
point brief and explainer fields. Preserve every source value and its provenance,
then render the relevant material together in Deep Dive. Prefer derivation at
build or render time over maintaining a second manually synchronized copy. When
a temporary manual copy is necessary, label it with its source field, source
version or migration, and extraction date.

Phase 0 may include:

- topic `what_it_is`, `why_it_matters`, `how_points_are_earned`, `answer_move`,
  and `common_point_loss`;
- topic explainer concepts, scoring guidance, mini-example, response contrast,
  misconception, and practice bridge;
- reusable unit/topic instructional guidance shown beside an Open Hand item,
  when that guidance comes from the approved topic-guide sources;
- links or compact previews for unit-owned reference material.

Phase 0 must not copy item-specific Open Hand answer content into Deep Dive,
including canonical answers, correct choices, rationales, worked solutions,
rubric evidence requirements, accepted variants, or minimum fixes. Those fields
remain behind the Open Hand access and scoring-exclusion contract.

Phase 0 acceptance requires:

- one complete student-facing place to read the currently approved reusable
  guidance for the selected unit/topic;
- source provenance for every imported block;
- no silent rewriting during extraction;
- no new database columns, migrations, or production content authority;
- an explicit duplicate-content report for the later editorial phase;
- a freshness rule so the compilation cannot silently drift from its sources.

For the prototype, the local parsed JSON packet is the editable compilation and
the existing database rows remain authoritative. Production implementation
should fetch or generate the compilation from those rows until a separately
approved content model replaces them.

## Phase 1 Website Pilot

The confirmed Phase 1 pilot is:

- subject: AP Statistics;
- unit: Unit 1, Exploring One-Variable Data and Collecting Data;
- topic: 1.7, Summary Statistics for One Quantitative Variable;
- channel: responsive website only;
- boxing prototype: `docs/product/AP_STATS_1_7_DEEP_DIVE_WEBSITE_PILOT.html`;
- Phase 0 lightweight comparison:
  `docs/product/AP_STATS_1_7_DEEP_DIVE_PHASE0_LIGHTWEIGHT.html`;
- Open Hand rail comparison, preserving the boxing content unchanged:
  `docs/product/AP_STATS_1_7_DEEP_DIVE_WITH_OPEN_HAND.html`.

The pilot uses the published 1.7 topic point brief and topic explainer as its
runtime-content baseline and the approved AP Statistics fact pack as grounding.
Because it begins at 1.7 rather than 1.1, classifications of `new_here` and
`builds_on` are provisional. The pilot tests the box structure and editing
workflow; it does not establish the final Unit 1 content ledger.
The website separates three levels:

- a compact topic summary containing the core idea, primary answer move,
  progress state, note state, and practice action;
- a focused Topic Deep Dive with `Understand`, `Score it`, and `See it`
  sections;
- a linked Unit 1 reference for shared formulas, vocabulary, representation
  guidance, cross-topic traps, and unit notes.

The Topic Deep Dive must not duplicate the complete Unit 1 reference. Topic
content may show formulas or vocabulary introduced or directly needed in 1.7,
with the complete reference remaining unit-owned.

### Website Row Limits

Row limits are authoring and layout constraints, not permission to hide required
meaning. Every production box must declare its row limit at each supported
responsive width. If reviewed copy exceeds the limit, rewrite it or move
supporting detail to the appropriate Deep Dive or unit-reference block. Do not
silently ellipsize instructional content.

| Content box | Maximum rows | Overflow treatment |
| --- | ---: | --- |
| Topic title | 2 | Rewrite only when the approved title has an approved short display title; never truncate the topic code. |
| Topic summary | 3 | Reduce to one core idea. |
| Primary answer move | 3 | Move supporting detail into `Score it`. |
| Unit-reference preview | 3 | Name only the available unit-level categories. |
| Deep Dive section title | 2 | Rewrite the heading. |
| Concept paragraph | 4 each | Split into a new reviewed block; do not ellipsize. |
| Formula explanation | 2 | Move derivation or caveats to the unit reference. |
| Answer-step title | 1 | Use one action per step. |
| Answer-step body | 3 | Move explanation to the surrounding section. |
| Misconception block | 4 | Keep the mistake and correction together; rewrite if over. |
| Worked-example prompt | 4 | Shorten context without changing the task. |
| Weak response | 4 | Move analysis to `Why it works`. |
| Stronger response | 4 | Move analysis to `Why it works`. |
| `Why it works` block | 4 | Keep only the scoring-relevant distinction. |
| Notes title | 2 | Use the approved short topic title after the full breadcrumb. |
| Student-authored note | Unlimited | Use a scrollable editor; never clamp student text. |

The pilot is accepted only when representative desktop, tablet, and mobile
screens demonstrate that every box stays within its limit without overlap,
layout shift, inaccessible hidden text, or loss of required instructional
meaning.

PDF and Google Docs are a later presentation phase. They will use the same
reviewed content fields but may distribute them across multiple pages instead
of inheriting website row limits or tab behavior.

## Provenance Requirements

Every row must carry enough provenance to explain why it exists and how it was
created. `source_note` is the row-level provenance field; batch notes and
activity-log records provide the wider release context.

| Content path | Required provenance |
| --- | --- |
| Newly authored row | Approved source artifact and authoring batch. |
| Generated-from-brief explainer | `generated-from-brief:<migration-filename-without-extension>` plus the source brief scope. |
| Copied subject-owned row | Source subject/topic and reason for duplication. |
| Moved row | Original subject/topic, new subject/topic, and reason for the move. |
| Repair | Previous issue, repair reason, and approval reference. |
| Retirement | Retirement reason and rollback reference. |

Rows with generic provenance such as `cramapple-authored` are acceptable only
for genuinely hand-authored rows where the batch record carries the source and
review details. Generated, copied, moved, repaired, and retired rows need
specific row-level notes.

## Production Lifecycle

### 1. Scope The Batch

Before authoring begins, define:

- subject;
- units and topic codes;
- source taxonomy version;
- CED fact pack or approved source file for each subject;
- whether the batch creates point briefs only or point briefs plus explainers;
- expected row counts by subject and unit;
- acceptance checks and rollback plan.

The batch must not mix unrelated production objectives. If taxonomy repair,
frontend wiring, and content authoring are all needed, record each boundary
clearly.

### 2. Ground The Content

Before authoring, map every topic to the approved source artifact that grounds
it. Current subject source files include:

- `docs/product/AP_BIOLOGY_CED_FACT_PACK.md`
- `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`
- `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md`
- `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md`
- `docs/product/AP_PRECALCULUS_CED_FACT_PACK.md`
- `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`

For each topic, preserve enough citation or row-level source context for a
reviewer to answer:

- Does this topic exist in the current approved taxonomy?
- Does the brief describe the right concept?
- Does the explainer align to the topic's learning objective and essential
  knowledge?
- Does the point-attainment language follow from the source facts rather than
  from generic AP test-taking advice?

Originality is not a substitute for accuracy. A row can be fully original and
still blocked if it is factually wrong or misaligned to the CED.

### 3. Author The Topic Point Brief

Author one point brief per approved taxonomy topic. Use the current subject
taxonomy and Cramapple-approved source facts as grounding.

The brief should answer:

- What is this topic?
- Why does it matter in class?
- Why does it matter on the AP exam?
- How does the student earn points with it?
- What answer move should the student practice?
- What common mistake costs points?

Do not publish a point brief whose topic code does not exist in the approved
taxonomy unless Product Owner explicitly approves a temporary taxonomy/content
repair path.

### 4. Author The Learn More Explainer

Author one explainer for each point brief intended to have a usable `Learn
more` destination.

The explainer should include:

- `core_idea`, usually expanding the brief's `what_it_is`;
- `what_students_need_to_understand`, usually expanding `why_it_matters`;
- `how_this_becomes_points`, usually expanding `how_points_are_earned`;
- the same topic-specific `answer_move`;
- a small Cramapple-original mini-example;
- the same or refined `common_point_loss`;
- a `practice_bridge` that points the student back into practice.

If the explainer is generated from the brief fields, record that method in the
batch note and row `source_note`. Generated-from-brief explainers are allowed
only when the source brief has already passed review, the generated text remains
topic-specific, `core_idea` is not merely a copy of `what_it_is`, and the
mini-example is specific to the topic rather than a generic template.

### 5. Accuracy Review

Learning Quality review must confirm:

- every topic exists in the approved taxonomy for the intended subject;
- every topic's source grounding is present and reviewable;
- concept descriptions are factually correct;
- AP course alignment is correct for the subject variant, especially AB/BC and
  Physics variants;
- point-attainment language accurately reflects what a student must do, connect,
  justify, calculate, interpret, represent, or name;
- Learn More content adds useful instruction beyond restating the topic card;
- mini-examples are topic-specific and scientifically/mathematically valid.

Every row is in scope for accuracy review. For batches of 30 or more rows a
reviewer may sample rather than read every row, provided the batch note
records the sample size (at least 20% of the batch, floor 20 rows), the
selection method (random plus every row flagged low-confidence by the
authoring pass), and the fact-pack sections covered. A sampled batch that
surfaces a factual defect returns to full review before it can proceed.

Accuracy review must be completed before originality/routing review. A row that
fails factual or CED alignment cannot be rescued by clean routing or original
wording.

### 6. Originality And Routing Review

Learning Quality or release review must confirm:

- every row is original Cramapple-authored content;
- every row is aligned to the intended AP subject, unit, and topic;
- no row includes copied official AP, third-party, or secure assessment
  language;
- point-attainment language is topic-specific;
- `learn_more_path` and `practice_*` fields route to the same subject/unit/topic;
- paired brief/explainer rows agree on title, topic, answer move, and common
  point loss unless a documented reason exists;
- paired brief/explainer rows agree on `unit_number`;
- reusable text, examples, and bridges are not repeated across large unrelated
  topic sets unless the batch explicitly records an approved templating
  exception.

Product Owner approval is required before any production publication batch that
adds new student-facing coverage or changes existing student-facing meaning.

Current operating gap: author, reviewer, and Product Owner may be the same
person for topic-guide content. That is allowed for now only if the batch note
states the role overlap plainly and records what approval artifact exists, such
as an activity-log entry, task note, reviewed migration, or explicit Product
Owner decision. When independent review is available, it should be used and
named.

### 7. Prepare The Database Change

Use an idempotent SQL migration or approved production data-application packet.

The change must:

- insert or update only the intended subject/unit/topic rows;
- use canonical `subject_key` values in `app.*` tables;
- set `status = 'published'` only for reviewed rows;
- set `published_at` for published rows;
- preserve or write a useful `source_note` when content is copied, generated
  from another row, repaired, or moved between subjects;
- capture a before-state for every row the batch may update or retire;
- update automated QA expectations in the same commit when published counts
  change;
- avoid frontend writes to `app.topic_point_briefs` or `app.topic_explainers`.

When copying shared material between subjects, create subject-owned rows rather
than shared rows if the Product Owner has chosen independent subject ownership.
Rewrite subject keys, practice subject keys, and Learn More paths accordingly.

### 8. Apply To Development First When Available

If Development has the required schema and representative data, apply and verify
there first.

Development verification must include:

- expected row counts;
- zero orphan point briefs;
- zero orphan explainers;
- all published point briefs have matching published explainers when the batch
  promises paired coverage;
- all paired rows agree on `unit_number`;
- active `app.subjects` rows exist for the affected subjects;
- distinctness and length-budget checks are reviewed;
- sample RPC calls for at least one row per subject;
- RLS and grant behavior remains authenticated-only.

If Development is known not to match Production for the required objects, record
that limitation and run the same read-only verification directly against
Production after Product Owner approval.

### 9. Apply To Production

Production application requires:

- Product Owner approval for the exact batch;
- environment confirmation for the Production Supabase project;
- before-state capture for changed rows;
- a rollback plan;
- migration or SQL packet reviewed for idempotency and scope;
- no service-role key exposure to frontend code.

After applying, do not treat the batch as student-ready until live verification
passes.

### 10. Verify Live Production

Run read-only QA against Production.

Minimum checks:

- `app.topic_point_briefs` published count matches the expected batch total.
- `app.topic_explainers` published count matches the expected paired total.
- `public.topic_point_briefs` and `public.topic_explainers` expose the same
  published counts to authenticated users.
- `anon` cannot select the public views or execute the RPC successfully.
- `authenticated` can execute `public.get_topic_point_guides`.
- Representative RPC call returns one brief and one explainer for a target
  topic.
- Returned RPC payload uses camelCase frontend fields.
- `learnMorePath` and `practiceParams` are present and correct.
- No published brief or explainer is orphaned from the approved taxonomy unless
  a documented temporary exception exists.
- No published explainer is orphaned from a published point brief.
- Paired brief/explainer `unit_number` values match.
- Affected subjects have active `app.subjects` rows.
- New explainers are not simple restatements of the paired card.
- Weak answers, point-attaining answers, mini-examples, and practice bridges
  share no values across published explainers, excluding rows whose
  `source_note` records an approved cross-subject duplication.
- Rows outside content length budgets are listed in release evidence with the
  reviewer-approved reason.

For AP Biology Unit 1 Topic 1.1, the smoke check should confirm the brief text
contains:

```text
Water is a polar molecule
```

### 11. Verify Frontend Consumption

Before considering the content student-usable, confirm the frontend:

- waits for an authenticated session before querying;
- calls `/rest/v1/rpc/get_topic_point_guides`;
- passes the selected subject key, unit number, and topic code;
- maps selected content by exact `topicCode`;
- renders point brief fields from the RPC response;
- renders Learn More content from the paired explainer;
- uses `practiceParams` for the practice entry action;
- shows loading and error states explicitly;
- shows "Point brief coming soon" only after a successful query with no matching
  brief.

Frontend code must not duplicate topic-guide content into static constants and
must not query private `app.*` tables.

### 12. Record Release Evidence

Record the release in the appropriate task, product document, or activity log.
The record should include:

- date;
- environment;
- subjects and units covered;
- expected and observed counts;
- taxonomy coverage before and after, by subject and unit;
- migration or SQL packet name;
- before-state capture location or rollback artifact;
- sample RPC calls tested;
- frontend route or screen tested;
- QA script or query names and results;
- known gaps;
- rollback notes.

## Coverage Policy

Per-subject topic-guide coverage is tracked in every release evidence record
(step 12) using `hasPointBrief` and `hasExplainer` from
`public.get_student_taxonomy`. A subject at less than a Product-Owner-approved
coverage floor is either accepted as a known gap (student experience shows
"Point brief coming soon" per §11, and the gap is named in the activity log)
or the subject is not offered in the student picker until coverage rises. The
default floor is 100% until a lower floor is recorded for the subject in the
activity log with an owning task.

No batch may lower the coverage of a subject that has previously reached the
floor.

## Change Types

### New Coverage

New coverage adds rows for topics that did not previously have published
student-facing topic-guide content. It requires full authoring, Learning Quality
review, Product Owner approval, database QA, and frontend smoke testing.

### Repair

A repair changes existing student-facing meaning, routing, status, title, or
topic attribution. It requires Product Owner approval and before/after evidence.

### Copy Or Move

A copy or move reuses reviewed content under another subject or topic ownership
model. It requires explicit rationale, rewritten routing fields, source notes,
and orphan checks before and after.

### Retirement

Retirement changes `status` away from `published` or otherwise removes content
from student use. It requires a reason, rollback path, and verification that the
frontend no longer exposes the retired row.

## Machine-Checkable Acceptance Criteria

Every production batch should translate these criteria into SQL or scripted QA.
If a criterion is intentionally waived, record the Product Owner approval and
the row scope.

- C1: Pairing orphans are zero in both directions. A pairing orphan is a
  published point brief without a published explainer for the same
  `(subject_key, topic_code)`, or a published explainer without a published
  point brief.
- C2: Paired rows have equal `unit_number`.
- C3: Every published row maps to an approved taxonomy topic for the same
  canonical subject and topic code. A taxonomy orphan is a published row whose
  subject/topic does not exist in the approved taxonomy.
- C4: `practice_subject_key`, `practice_unit_number`, and
  `practice_topic_code` match the point brief's subject, unit, and topic unless
  a documented practice-routing exception exists.
- C5: `learn_more_path` starts with `/learn/`, uses the correct hyphenated
  subject route, and includes the correct `unit-{n}` segment.
- C6: Each affected subject has an active `app.subjects` row.
- C7: New explainer `core_idea` text is not byte-identical to the paired brief's
  `what_it_is`, unless the row is a documented legacy exception.
- C8: New mini-example, weak-answer, point-attaining-answer, and
  practice-bridge text share no values across published explainers, excluding
  rows whose `source_note` records an approved cross-subject duplication.
- C9: Content length budgets are checked and every over-budget row is listed in
  release evidence.
- C10: Authenticated public views and app tables expose the same published
  counts for the batch scope.
- C11: Anonymous users remain locked out of views and RPC execution.
- C12: The Lovable/frontend smoke path renders a real brief and Learn More
  explainer for at least one topic in the batch.

## Relationship To Content Operations

Question items, scoring rubrics, release candidates, and adjudicated review
records remain governed by
`docs/product/CONTENT_OPERATIONS_ADJUDICATION_RELEASE_DESIGN.md` and related
task approvals. This protocol is a lighter operating path for topic-guide
instructional content only. It does not create a bypass for question content,
secure assessment content, grading criteria, model calibration, or rights/legal
review.

When topic-guide content begins to influence scoring, diagnostic placement,
mastery evidence, or recommendation eligibility, route that change through the
full content operations release process instead of this protocol alone.

## Failure Modes That Block Production

Do not release if any of these are true:

- topic code is not in the approved taxonomy;
- no approved CED/source grounding exists for a new or meaning-changing row;
- factual accuracy or CED alignment review is incomplete;
- point brief exists without a required paired explainer for a paired batch;
- explainer exists without a matching point brief;
- paired rows disagree on `unit_number`;
- affected subject is not active in `app.subjects`;
- `learn_more_path` points to the wrong subject or unit;
- `practice_*` fields point to a different topic than the brief;
- generated-from-brief Learn More content merely restates the card or uses a
  generic mini-example;
- RPC returns snake_case fields where frontend expects camelCase;
- anonymous users can read the topic-guide content;
- frontend falls through to "Point brief coming soon" after a query error;
- copied content still references the source subject in route or practice
  fields;
- automated QA expectations are stale after a count-changing batch;
- Product Owner approval is absent for a student-facing production change.

## Rollback

Every production batch must have one of these rollback paths:

- set affected rows back to the prior `status`;
- restore prior row values from a captured before-state;
- apply a reversing migration for a copy/move;
- revert frontend wiring if the data is correct but consumption is broken.

The before-state capture is required for any update, retirement, copy/move, or
meaning-changing repair. It may be a read-only SQL export, a transaction-local
snapshot used by the migration, or a reviewed migration that can reconstruct the
previous state exactly.

Rollback verification must use the same authenticated RPC path students use.

## Student-Ready Definition

A topic brief and Learn More explainer are student-ready only when:

- content is reviewed and approved;
- rows are published in Production;
- live authenticated RPC verification passes;
- frontend renders the brief and Learn More explainer for the selected topic;
- practice routing uses the same subject/unit/topic;
- release evidence is recorded.
