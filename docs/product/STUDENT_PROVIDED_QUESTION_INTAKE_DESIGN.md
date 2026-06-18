# Student-Provided Question Intake Design

**Status:** Proposed for Product Owner, Learning Quality, accessibility,
security, privacy, rights, and academic-integrity review
**Related Task:** `UX-004`
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-06-13

## 1. Purpose

This document defines the proposed student experience for bringing an outside
question into Cramapple by typing, pasting, photographing, or uploading it.

The flow helps the learner provide complete context, verify extraction, choose
the kind of help wanted, and understand when Cramapple can teach confidently,
provide only qualified guidance, or must decline.

It does not finalize copyright, minor-consent, retention, deletion,
model-provider, upload-security, or academic-integrity policy.

## 2. Experience Principles

1. **Preserve the student's intent.** Do not turn a real question into a long
   form or generic topic search.
2. **Verify before teaching.** Let the learner confirm extracted text,
   answer choices, visuals, and missing context.
3. **Ask once, then proceed honestly.** Use at most one clarification round
   for relevance or completeness.
4. **Do not invent missing material.** Missing figures, passages, answer
   choices, or prior subparts remain explicit.
5. **Separate input confidence from answer confidence.** A clean extraction
   does not prove that Cramapple has a validated rubric.
6. **Make the help mode meaningful.** Teach, Hint, Check My Work, and Walk
   Through a Solution have different learning consequences.
7. **Protect cold evidence.** A hint or solution changes the attempt from cold
   to coached.
8. **Keep external material isolated.** A student submission does not enter
   canonical content or become approved merely because Cramapple answered it.
9. **Explain data use plainly.** Private learning, anonymous internal
   improvement, and public publication are separate states.
10. **Prefer a bounded limitation over confident fabrication.**

## 3. Proposed Information Architecture

Student entry points:

- `Bring a question` from Home;
- `Check my work` from Home or first-session setup;
- `Add missing context` during a learning interaction;
- future public landing-page trial.

The signed-in student flow uses five stages:

```text
1. Add question
2. Confirm capture
3. Confirm match
4. Choose help
5. Review and begin
```

Completed stages are recoverable. The original upload or pasted submission and
the learner-confirmed extraction remain distinguishable.

## 4. Stage 1 - Add Question

### 4.1 Input Methods

Offer three visible choices:

1. **Type or paste**
2. **Photo or screenshot**
3. **Document**

The MVP may launch with text only. Photo, screenshot, and document behavior is
designed now but remains implementation-gated by upload security, privacy,
rights, extraction, retention, and accessibility decisions.

### 4.2 Capture Guidance

Prominent guidance:

> Include the complete question, answer choices, and any graph, table, diagram,
> passage, or earlier subpart it refers to.

Secondary safety guidance:

> Remove names, faces, school information, contact details, and anything
> personal or confidential before submitting.

The interface must not claim it can detect every identifier.

### 4.3 Input-Specific Behavior

**Type or paste**

- large text field;
- optional answer-choice formatter;
- optional learner-answer field when entering through Check My Work;
- preserve line breaks, equations, and labels where possible.

**Photo or screenshot**

- camera or image picker;
- preview, rotate, retake, and remove;
- quality checks for blur, glare, crop, orientation, and missing edges;
- no silent metadata or location assumptions.

**Document**

- supported-format and size guidance;
- selected-page preview;
- extraction progress and failure state;
- ability to remove the file and switch input method.

No upload should be transmitted in a prototype. Production upload behavior
requires separate security approval.

## 5. Stage 2 - Confirm Capture

Show two distinct regions:

1. **Original submission:** immutable preview of what the learner supplied.
2. **Cramapple captured:** editable or correctable extracted content used for
   classification and teaching.

Present a completeness checklist:

- question text;
- answer choices;
- graph, table, diagram, or passage;
- earlier subpart or shared stimulus;
- learner answer, when Check My Work is requested.

### 5.1 Personal-Information Warning

If a prototype detector finds a possible name, face, school label, contact
detail, or location clue:

> This may include personal information. Review and remove it before
> continuing. Cramapple may not detect everything.

Actions:

- `Review and remove`
- `Use another image`
- `Cancel`

Do not offer `Continue anyway` until counsel and security approve the exact
policy.

### 5.2 Extraction Failure

If text or visual extraction is incomplete:

- show which region failed;
- preserve the original preview;
- allow correction, retake, replacement, or switch to typing;
- never fill missing text speculatively.

## 6. Stage 3 - Confirm Match

Cramapple proposes:

- subject;
- AP exam;
- unit or topic;
- skill or question archetype;
- classification confidence.

### 6.1 High Confidence

Show the proposed match and allow correction without interruption.

### 6.2 Moderate Confidence

Require confirmation:

> This looks like an AP Biology cellular energetics question about limiting
> factors. Does that seem right?

Actions:

- `Yes, continue`
- `Choose a different topic`
- `Add context`

Student confirmation improves routing but does not make the question or rubric
authoritative.

### 6.3 Low Confidence or Missing Context

Use one clarification round:

- request the missing visual, choices, passage, or preceding text; or
- ask whether the apparent different subject was intentional.

If unresolved, either:

- continue with clearly qualified conceptual guidance;
- avoid precise scoring;
- or decline when Cramapple cannot provide a safe useful answer.

### 6.4 Portfolio Outcomes

- **Current enrolled subject:** standard flow.
- **Another supported subject:** answer once and present subject expansion
  separately from the teaching.
- **Unsupported subject:** polite decline and a future subject-waitlist entry
  point. Contact collection remains blocked on counsel-approved age and consent
  design.

## 7. Stage 4 - Choose Help

### 7.1 Teach Me

Explain the underlying concept, use a worked example where useful, and finish
with a fresh independent attempt.

### 7.2 Give Me a Hint

Give one bounded cue. Mark subsequent work on the original question as coached,
not cold evidence.

### 7.3 Check My Work

Require the learner's attempted answer. Evaluate only what the available
question, context, and rubric confidence support.

- Validated match: criterion-level grading may be available.
- Partial match: evaluate supported elements and identify unverified elements.
- No validated match: give formative reasoning feedback without an
  authoritative score.

### 7.4 Walk Me Through a Solution

Show a reasoned solution and then offer a related independent attempt. Explain
that this provides the most support and the least cold-performance evidence.

## 8. Academic-Integrity Context

Ask:

> Where is this question from?

Proposed choices:

- Practice, homework, or studying
- A quiz or test I am taking right now
- I am not sure

The exact enforcement behavior remains pending `GOV-003`.

The conservative prototype behavior for a current quiz or test is:

- keep Teach Me and Give Me a Hint available;
- disable full solution and answer-checking actions;
- explain that Cramapple can help with the concept without completing an active
  assessment.

This is a UX proposal, not final policy.

## 9. Stage 5 - Review and Begin

Summarize:

- input method and capture completeness;
- confirmed question text and included assets;
- proposed subject/topic/archetype;
- confidence level and what it permits;
- selected help mode;
- assessment context;
- whether a learner answer is included;
- known limitations.

Primary action changes by mode:

- `Start teaching`
- `Give me a hint`
- `Check my work`
- `Walk through the solution`

Secondary actions:

- `Edit question`
- `Change help`
- `Save and finish later`

## 10. Data and Publication Explanation

At the contribution point, use direct provisional copy:

> Your question stays part of your private learning activity. Cramapple may use
> anonymous or deidentified questions and responses to improve its teaching
> and grading. Making anything public is a separate reviewed process.

Also state:

- the question does not enter the canonical library automatically;
- public publication does not change the learner's grade, progress, or access;
- final consent, retention, deletion, and age-specific language require
  counsel approval.

Do not imply that the student grants publication rights merely by submitting a
question.

## 11. Key States

```text
capture_draft
capture_processing
capture_needs_review
personal_information_warning
extraction_failed
capture_confirmed
match_high
match_moderate
match_low
clarification_requested
clarification_exhausted
supported_subject
other_supported_subject
unsupported_subject
help_selected
learner_answer_required
active_assessment_limited
ready_to_begin
saved_for_later
```

## 12. Accessibility and Security

- Full keyboard operation and visible focus.
- File input alternatives and typed-entry fallback.
- No drag-only upload.
- Image preview controls have text labels.
- Extraction status uses live announcements.
- Errors identify the field and recovery action.
- Mobile reflow at 390 CSS pixels without horizontal overflow.
- Original and corrected extraction remain distinguishable to screen readers.
- Production file validation, malware scanning, signed access, storage,
  provider handling, and deletion are server responsibilities.
- The client does not make authoritative rights, grading, or publication
  decisions.

## 13. Prototype Scope

The UX-004 prototype should demonstrate:

- typed/pasted entry;
- simulated photo and document entry;
- capture confirmation;
- possible-personal-information warning;
- extraction failure and typed fallback;
- missing-figure clarification;
- high, moderate, and low match confidence;
- topic correction;
- all four help modes;
- Check My Work requiring an answer;
- active-assessment limitation;
- unsupported-subject decline;
- review-and-begin summary;
- private, anonymous-improvement, and public-publication separation.

## 14. Open Decisions

- Final academic-integrity rules for active homework, quizzes, and tests.
- Permitted source and copyright treatment for student uploads.
- Minor notice and consent language.
- Upload formats, limits, provider, storage, and retention.
- Whether anonymous improvement use is opt-out, consent-based, or handled
  through another approved model.
- Public-candidate rights and student notice.
- Confidence thresholds for high, moderate, and low match.
- Exact first-release input methods.
- Visitor trial and unsupported-subject waitlist UX.
