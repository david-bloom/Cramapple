# Content Authoring and Revision Workbench Design

**Status:** Proposed for Product Owner, Learning Quality, author, accessibility,
security, privacy, and rights review
**Related Task:** `UX-003`
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-06-15

## 1. Purpose

This document defines the proposed author experience for creating and revising
complete Cramapple question packages. It supplies the missing destination for
items that UX-002 reserves for modification or that an AP Reader edits and
recycles.

The workbench supports original authoring, governed document import, reviewer
comment response, immutable version comparison, provenance and rights capture,
task acknowledgement, resubmission, and role-based access to the UX-002 review
carousel.

Candidate submission does not approve or publish content.

## 2. Experience Principles

1. Author the whole package, not only the question stem.
2. Keep the approved authoring brief visible and immutable.
3. Save drafts without silently creating reviewable versions.
4. Create a new immutable version only at submission or explicit checkpoint.
5. Preserve reviewer decisions and comments as history.
6. Anchor comments to exact package fields or visual regions.
7. Make provenance and rights part of authoring, not an end-stage form.
8. Block submission when required package, source, rights, or attestation data
   is missing.
9. Keep authoring and independent review roles distinct.
10. Make the consequence of every resubmission explicit.

## 3. Primary Information Architecture

| Area | Purpose |
| --- | --- |
| My work | Assigned commissions, revisions, due dates, and acknowledgement |
| Workbench | Create or revise the complete question package |
| Comments | Respond to anchored reviewer findings |
| Versions | Compare immutable versions and review history |
| Sources and rights | Record provenance, assets, tools, and permission state |
| Submitted | View immutable submissions and downstream status |
| Review carousel | Enter UX-002 when separately assigned and qualified |

The authoring workbench and review carousel are separate modes. A user may have
both roles, but cannot review an artifact they authored or revised.

## 4. Task Queue and Acknowledgement

Each assigned task card shows:

- commission or revision task ID;
- artifact ID and current version, when one exists;
- original authoring or recycled revision;
- MCQ, short FRQ, or long FRQ;
- exam, unit, topic, skill, intended use, and intended difficulty;
- due date and estimated package scope;
- assignment reason and reviewer-return stage;
- unread comment count and blocking issue count;
- rights or source blockers;
- status: offered, acknowledged, in progress, ready, submitted, or returned.

Actions:

- `Acknowledge and start`
- `Open work`
- `Request clarification`
- `Report conflict`
- `Decline assignment`

Acknowledgement records receipt; it does not accept content quality or rights.
Decline and conflict behavior requires production policy and server controls.

## 5. Workbench Layout

Desktop uses four stable regions:

1. **Task rail:** queue, due state, and package progress.
2. **Brief bar:** immutable target, restrictions, and reviewer-return summary.
3. **Editor stage:** active package section.
4. **Context panel:** comments, checks, provenance, and version context.

Mobile stacks the brief, editor, and context panel. A persistent package
navigator exposes incomplete and blocked sections without relying on color.

Primary package sections:

```text
Question
Answers or rubric
Hints
Explanation
Sources and rights
Accessibility
Checks and submit
```

## 6. Create a Complete Package

### 6.1 Shared Question Fields

- stem and governed stimulus;
- question form and point count;
- exam, unit, topic, learning objective, science practice, skill, and task verb;
- intended use and intended difficulty;
- expected reasoning path;
- assumptions and required context;
- known ambiguity or failure cases;
- visual and accessibility requirements.

### 6.2 MCQ Fields

- exactly four answer options unless the active exam pack says otherwise;
- one proposed best answer;
- proof of the keyed answer;
- rationale for every option;
- distinct misconception or error mechanism for each distractor;
- teaching explanation;
- minimum correction;
- immediate-transfer and delayed-retrieval candidates.

### 6.3 FRQ Fields

- shared stimulus and independently deliverable prompt parts;
- criterion-level rubric and point values;
- accepted alternatives and equivalent reasoning;
- insufficient, contradictory, and boundary responses;
- calculation, unit, graph, diagram, and notation rules;
- full-, partial-, no-credit, equivalent, contradiction, and ambiguity cases;
- criterion-specific hints, explanation, and minimum fixes.

Hints are ordered and bounded. Explanations may reference rubric criteria but
must not collapse into generic rubric restatement.

## 7. Document Import

Authors may start from an approved original document containing questions,
answers, rubrics, hints, or explanations.

Proposed import flow:

```text
1. Select document
2. Confirm ownership and permitted use
3. Preview extracted sections
4. Map sections to package fields
5. Resolve extraction warnings
6. Import into an editable draft
```

The original document remains a provenance attachment. Import never marks the
content original, rights-cleared, complete, or approved.

The prototype simulates import and does not transmit a file. Production upload
requires malware scanning, access control, retention, deletion, extraction,
privacy, and rights approval.

### 7.1 Intake Template

The UX-003 handoff must use the same structured intake shape as UX-002 so a
reviewed item can be recycled without re-translation.

Supported upload formats:

- CSV with one row per reviewable item;
- JSON array with one object per reviewable item.

Required shared fields:

- `item_id`
- `review_stage`
- `question_type`
- `stem`
- `modules`
- `subtopics`

Recommended optional fields:

- `change_request`
- `notes`
- `source_title`
- `source_locator`
- `version`
- `difficulty`

MCQ-specific fields:

- `answer_letter`
- `answer_text`
- `answer_status`

FRQ-specific fields:

- `canonical_answer`
- `rubric_summary`
- `criterion_notes`

The intake parser should preserve the submitted row order, keep the original
upload as provenance, and map each row into either a question review item, an
answer review item, or a canonical-answer review item. Module and subtopic
values should remain multi-valued so the same item can be tagged to more than
one curriculum area.

### 7.2 Schema Landing Map

The template fields land in the database like this:

| Upload field | Schema destination |
| --- | --- |
| `item_id` | `app.content_ingest_rows.row_key` |
| `review_stage` | `app.content_ingest_rows.review_stage` |
| `question_type` | `app.content_ingest_rows.question_type` |
| `stem` | `app.content_ingest_rows.stem` |
| `modules` | `app.content_ingest_rows.modules` and later `app.artifact_label_assignments` |
| `subtopics` | `app.content_ingest_rows.subtopics` and later `app.artifact_label_assignments` |
| `change_request` | `app.content_ingest_rows.change_request` |
| `notes` | `app.content_ingest_rows.notes` |
| `source_title` | `app.content_ingest_batches.parsed_template` and `app.content_ingest_rows.row_payload` |
| `source_locator` | `app.content_ingest_batches.parsed_template` and `app.content_ingest_rows.row_payload` |
| `version` | `app.content_ingest_batches.parsed_template` and `app.content_ingest_rows.row_payload` |
| `difficulty` | `app.content_ingest_rows.row_payload` and, after review, `app.content_review_decisions.difficulty_label` |
| `answer_letter` | `app.content_ingest_rows.answer_letter` |
| `answer_text` | `app.content_ingest_rows.answer_text` |
| `answer_status` | `app.content_ingest_rows.row_payload` |
| `canonical_answer` | `app.content_ingest_rows.canonical_answer` |
| `rubric_summary` | `app.content_ingest_rows.row_payload` |
| `criterion_notes` | `app.content_ingest_rows.row_payload` |

The parser should retain the full uploaded row JSON in `row_payload` even when
some fields are also normalized into dedicated columns. That keeps the intake
provenance intact and gives UX-003 enough context to reconstruct a revision
without re-reading the source file.

The template is not an approval artifact. Imported rows still require the
normal completeness, rights, and review checks before they can become an
editable draft or enter any review queue.

## 8. Reviewer Comments

Comments are grouped by package field, severity, and review stage:

- blocking;
- required change;
- question;
- suggestion;
- resolved in current draft.

An author can:

- open the exact referenced field;
- reply;
- edit the draft;
- mark `Addressed in draft`;
- explain why no change was made;
- request clarification.

The author cannot delete, rewrite, or mark a reviewer comment finally resolved.
On resubmission, each required comment needs an author response and either a
linked change or a no-change rationale. Reviewers decide whether it is resolved.

## 9. Version Comparison

Version history shows immutable submissions, not autosave events.

Comparison supports:

- side-by-side and unified views;
- package-level and field-level filtering;
- additions, removals, and changed answer keys;
- rubric point changes;
- source, rights, and accessibility changes;
- reviewer comments associated with each version;
- author change summary and submission attestation.

Changing the answer key, assessed construct, rubric logic, stimulus, or rights
dependency receives a prominent high-impact warning and may trigger broader
reassessment.

## 10. Provenance and Rights

Every package records:

- original author, collaborators, and disclosed tools;
- authoring brief and commission;
- factual sources and claim relationships;
- source type, locator, and access date;
- assets, datasets, figures, and permissions;
- derivation: direct, paraphrase, synthesis, calculation, expert judgment, or
  Cramapple original;
- prior publication, sale, license, or assignment;
- restricted or credentialed material use;
- rights granted for edit, adaptation, model input, learner display, public
  display, and commercial distribution;
- originality and no-conflicting-rights attestations.

The interface must distinguish:

- `Recorded`
- `Needs evidence`
- `Rights review required`
- `Blocked`

It must not imply that an author attestation is counsel approval.

## 11. Checks and Submission

Checks appear continuously and again before submission:

- package completeness;
- one MCQ best answer and four complete option rationales;
- rubric point consistency;
- source and claim coverage;
- rights and asset status;
- originality and restricted-material disclosures;
- accessibility fields;
- unresolved blocking comments;
- deterministic calculation or visual checks, when applicable;
- affected-review scope.

Submission requires:

1. a change summary;
2. responses to required reviewer comments;
3. current-version originality and rights attestation;
4. acknowledgement that submission creates an immutable version;
5. acknowledgement that approval and publication remain separate.

## 12. Recycled Item Flow

UX-002 routes items into UX-003 when:

- tutor aggregate 3 reserves modification;
- AP Reader score 2 requires edit and recycle;
- a difficulty discussion chooses revision;
- an answer option requires modification;
- downstream quality, rights, or production evidence creates a revision task.

The workbench opens the last immutable version, the triggering decisions, and
the required comments. The author edits a draft derived from that version.

On resubmission:

- create a new immutable artifact or package version;
- preserve the predecessor link;
- attach the change summary, comment responses, provenance, and attestation;
- invalidate affected prior approvals;
- return the new version to the required two-tutor reassessment queue;
- never carry forward the old version's score as approval.

For MCQs, answer changes remain within the complete four-option package. The
interface does not permit an orphaned or partially approved option set.

## 13. Review Carousel Access

Qualified tutor authors or AP Readers may have a `Review carousel` switch in
global navigation.

Before entry, show:

- active reviewer role and qualification scope;
- assigned review count;
- independence and conflict reminder;
- explicit exclusion of authored, revised, collaborated-on, or otherwise
  conflicted artifacts.

The carousel itself remains UX-002. UX-003 links to it and displays downstream
status, but does not duplicate review scoring controls inside the editor.

## 14. State Model

Task states:

```text
offered
acknowledged
in_progress
ready_for_submission
submitted
revision_requested
accepted
rejected
declined
cancelled
```

Draft and version states:

```text
local_or_server_draft
preflight_blocked
ready_to_version
immutable_submitted_version
in_review
superseded
```

Comments and checks are linked to an artifact version and field path. Derived
queue state is rebuildable from assignments, versions, comments, and events.

## 15. Accessibility, Security, and Trust

- Complete keyboard operation and visible focus.
- Semantic section navigation and error summaries.
- No color-only completion, severity, or diff meaning.
- Autosave and immutable-version creation announced separately.
- Minimum 44 CSS-pixel primary controls where practical.
- Reflow without horizontal page overflow at 390 CSS pixels.
- Server-enforced assignment, role, qualification, and artifact scope.
- No client authority over acceptance, review assignment, rights clearance, or
  release.
- No service keys, held-out validation cases, or unrelated author records in
  the browser.
- Sensitive document previews require signed access and approved retention.

## 16. Prototype Scope

The UX-003 prototype should demonstrate:

- acknowledging a new assignment;
- opening a recycled MCQ revision;
- editing question, answers, rubric, hints, and explanation;
- simulated document import and field mapping;
- responding to anchored reviewer comments;
- side-by-side version comparison;
- provenance and rights status;
- preflight blockers and completion;
- immutable resubmission to two-tutor reassessment;
- switching to the UX-002 review carousel;
- preventing self-review.

The prototype uses original placeholder content and frontend-only state.

## 17. Open Review Questions

- Who may assign, reassign, extend, decline, or cancel authoring work?
- Which edits trigger answer-only, question-level, or full-package reassessment?
- Which provenance claims require source-steward verification before review?
- What rights statuses block draft work versus submission?
- May reviewer identities remain hidden from authors, and at which stages?
- Which import file types, limits, and retention periods are acceptable?
- How are compensation milestones tied to acknowledgement, submission,
  revision, acceptance, and rejection?
- Which authoring actions require reauthentication or a signed attestation?
