# Lovable Build Brief - UX-003 Content Authoring and Revision Workbench

Build a polished, responsive, frontend-only Cramapple authoring workbench from
this brief. It is used by paid tutor authors and qualified content specialists
to create complete question packages and revise items recycled from UX-002.
Do not connect a database, Supabase, production authentication, uploads, model
providers, or deployment.

## Product Boundary

UX-003 creates drafts and immutable candidate versions. It does not approve or
publish content. UX-002 owns independent tutor and AP Reader scoring.

A qualified user may switch into the UX-002 review carousel, but must never be
assigned an artifact they authored, revised, collaborated on, or otherwise
have a conflict with.

## Visual Direction

- Calm professional editorial workspace.
- Warm off-white canvas, deep evergreen navigation, white editing surfaces,
  muted blue information, amber warnings, and red blockers.
- Dense enough for serious work without looking like an admin database.
- Strong typography, clear section progress, generous editor spacing.
- No gamification, celebration, streaks, leaderboards, or student-study motifs.

## Prototype Routes

```text
/prototype/author
/prototype/author/tasks/:taskId
/prototype/author/items/:artifactId/edit
/prototype/author/items/:artifactId/comments
/prototype/author/items/:artifactId/versions
/prototype/author/items/:artifactId/provenance
/prototype/review
```

Client-side routing is acceptable.

## Desktop Layout

1. Left task rail with My work filters and assignment cards.
2. Top immutable brief bar with target and restrictions.
3. Central package editor.
4. Right context panel for comments, checks, provenance, or versions.

On mobile, stack these regions and keep a persistent section navigator and
`Review and submit` action.

## Global Navigation

- My work
- Submitted
- Reference
- Review carousel

Show the active author identity and qualification scope. The `Review carousel`
entry displays assigned reviewer work only and includes a self-review exclusion
notice.

## Task Queue

Filters:

- Assigned
- In progress
- Revisions
- Ready
- Submitted

Each task card shows task ID, artifact/version, MCQ or FRQ, topic, intended
difficulty, due date, new or recycled status, comment count, blocker count, and
acknowledgement state.

Actions:

- Acknowledge and start
- Open work
- Request clarification
- Report conflict
- Decline assignment

Prototype at least:

1. A new unacknowledged short-FRQ assignment.
2. A recycled MCQ with three reviewer comments.
3. A submitted package waiting for tutor reassessment.

## Package Editor

Section navigation:

```text
Question
Answers / rubric
Hints
Explanation
Sources & rights
Accessibility
Checks & submit
```

Show completion, warning, and blocker status using icon, text, and color.

### Question

Include stem, optional stimulus, form, point count, exam, unit, topic, learning
objective, science practice, skill, task verb, intended use, intended
difficulty, reasoning path, assumptions, and known ambiguity.

### MCQ Answers

Show four editable option cards. One and only one can be proposed as the best
answer. Each option requires:

- answer text;
- correct-answer proof or distractor rationale;
- misconception or error mechanism;
- optional reviewer-comment indicator.

### FRQ Rubric

Provide criterion cards with point values, scoring rule, accepted alternatives,
insufficient evidence, contradiction behavior, and example boundary cases.

### Hints

Create ordered hints with support-level labels. Explain that hints should move
the learner without revealing the complete answer too early.

### Explanation

Include teaching explanation, minimum correction, immediate-transfer candidate,
and delayed-retrieval candidate.

## Document Import

Provide an `Import document` flow:

1. Select a fake local document.
2. Confirm ownership or permitted use.
3. Preview simulated extracted sections.
4. Map sections to question, answers, rubric, hints, and explanation.
5. Show extraction warnings.
6. Import into the current editable draft.

Do not actually upload or read a document. Label the behavior as simulated.
Keep the source document visible in provenance after import.

## Reviewer Comments

Create an anchored comments panel with:

- blocking, required, question, and suggestion severity;
- reviewer stage, timestamp, field path, and immutable original comment;
- jump-to-field;
- author reply;
- mark `Addressed in draft`;
- no-change rationale;
- request clarification.

Do not let the author delete or finally resolve reviewer comments.

Prototype these comments:

- The keyed answer is not uniquely supported by the stem.
- Distractor C repeats the same misconception as distractor B.
- The explanation needs to distinguish correlation from causation.

## Version Comparison

Offer `Current draft vs v2` and `v2 vs v1`.

Support:

- side-by-side and unified views;
- filters for question, answers/rubric, teaching, sources/rights, and
  accessibility;
- additions, removals, and changed content;
- prominent answer-key, construct, rubric-point, stimulus, and rights changes;
- prior review decisions and comments;
- author change summaries.

Autosaves are not versions. Label submitted versions immutable.

## Sources, Provenance, and Rights

Show a source table and asset list with:

- claim or field;
- source title and locator;
- source type;
- derivation;
- access date;
- author/owner;
- rights status;
- intended uses;
- evidence attachment status.

Status labels:

- Recorded
- Needs evidence
- Rights review required
- Blocked

Capture collaborators, disclosed tools, prior publication or assignment,
restricted-material use, factual sources, asset permissions, and originality
attestation.

Do not describe attestation as rights approval.

## Continuous Checks

Show live checks for:

- complete package;
- exactly one MCQ best answer;
- four option rationales and distinct distractor mechanisms;
- rubric point consistency;
- source coverage;
- rights status;
- accessibility fields;
- unresolved blocking comments;
- deterministic calculation or visual checks;
- reassessment impact.

Clicking a failed check jumps to the relevant section.

## Resubmission

`Review and submit` opens a confirmation summary requiring:

- change summary;
- response for every required comment;
- originality and rights attestation;
- acknowledgement that a new immutable version will be created;
- acknowledgement that prior scores do not transfer as approval.

Success state:

```text
Version 3 submitted
Returned to two tutors for independent reassessment
Prior version and decisions preserved
```

Provide links to `View submitted version` and `Back to my work`.

## Review Carousel Access

The global `Review carousel` action opens a transition screen showing:

- reviewer role and qualification;
- assigned review count;
- independence reminder;
- self-review exclusion.

Then link to the existing UX-002 route or show a compact preview card. Do not
duplicate score controls in the authoring editor.

## Required Prototype Scenarios

Provide controls to jump to:

- New assignment
- Recycled MCQ
- Import document
- Reviewer comments
- Compare versions
- Rights blocker
- Ready to submit
- Submitted
- Review carousel

## Accessibility

- Full keyboard operation and visible focus.
- Semantic tabs, fieldsets, labels, errors, and live status.
- No color-only section status, diff, warning, or blocker.
- Visible Previous/Next controls where step navigation exists.
- Reflow at 390 CSS pixels without horizontal page overflow.
- Minimum 44 CSS-pixel primary controls where practical.
- Respect reduced motion.

## Prototype Safety

- Frontend-only fixtures and local UI state.
- No network calls, uploads, authentication, storage, or production writes.
- No official, secure, credentialed, copyrighted, or learner content.
- Use clearly original placeholder AP Biology content.
- Label all save, import, attestation, and submission behavior as prototype
  simulation.

