# BYOQ Upload Policy and Data Lifecycle — Discussion Draft

**STATUS:** discussion draft for review and comment; no build authorized  
**DATE:** 2026-09-23  
**OWNER:** David Bloom, Product Owner  
**REVIEWERS:** Product Owner, Learning Quality Owner, counsel/privacy reviewer,
technical/security owner, and marketing owner where public policy language is
affected

## 0. Purpose and status

This document records the product direction discussed after review of
`docs/product/COURSE_HOMEWORK_CONSOLIDATION_PLAN.md`. It is intended to give
other stakeholders one place to review and comment on:

- how student-provided questions, worksheets, and hand-drawn work are used;
- the boundary between BYOQ classification and Cramapple's teaching content;
- what permission a student gives by uploading;
- storage, improvement use, archiving, reactivation, and deletion behavior;
- background question recognition and classification; and
- the remaining legal, policy, security, and implementation questions.

This is not an implementation specification, approval record, task, database
design, or authorization to build. No production behavior, legal copy, schema,
retention job, classifier, upload flow, or settings control should be changed
solely because this discussion draft exists. Accepted decisions must be carried
into the appropriate canonical documents, approval records, task scope, and
implementation specifications before execution.

## 1. Relationship to the consolidation plan

The Course + Homework consolidation direction uses a student's own question or
worksheet as a primary way to identify what they need to learn. That does not
mean the uploaded question becomes the teaching example.

The intended live learning path is:

```text
student upload
  -> recognize and separate question(s)
  -> classify each question
  -> student confirms or corrects the proposed classification
  -> check Cramapple-library coverage
  -> teach open-hand using a distinct, vetted Cramapple-library question
  -> give a different Cramapple-library cold attempt
  -> return the student's original question unsolved
```

The student's upload and Cramapple's teaching library therefore have different
roles:

- **Student upload:** recognition, classification, private learning context,
  scoring where supported, progress evidence, preparation guidance, and
  internal product improvement.
- **Cramapple question library:** open-hand worked examples, cold attempts,
  extra practice, and released student-facing questions.

## 2. Teaching invariant — open hand uses the Cramapple library

**DIRECTION RECORDED:** BYOQ content must not be used as the open-hand teaching
question.

The system may use a student-provided question to determine the likely subject,
unit, topic, and skill/cell. It must then select a distinct vetted item from
Cramapple's question library for teaching and another suitable library item for
the student's cold attempt.

The live teaching path must not:

- solve the student's uploaded question;
- reveal the uploaded question's answer through a worked walkthrough;
- lightly rewrite the uploaded question and present the rewrite as a parallel
  example;
- carry over answer-bearing numbers, labels, structures, or reasoning steps
  that effectively give away the student's answer; or
- treat a stored upload as released Cramapple-library content.

If Cramapple has no vetted library coverage for the confirmed classification,
it should name the skill or topic it recognized and state honestly that it does
not yet have suitable practice. It must not generate improvised pedagogy to
fill the gap.

## 3. Interim permitted-use boundary

**DIRECTION RECORDED:** questions, worksheets, drawings, images, and documents
provided through an upload feature may be used and stored.

The intended permitted uses during this interim period are:

1. operating the student-facing service;
2. recognizing and extracting questions and student work;
3. scoring supported hand-drawn or written work;
4. maintaining the student's scores, attempt history, progress, and exam
   preparation context;
5. quality assurance, debugging, evaluation, and reliability review; and
6. improving Cramapple for students, including recognition, extraction,
   classification, grading, recommendations, coverage analysis, curriculum
   planning, and instructional quality.

Until the separate legal/content-reuse questions are resolved, a stored upload
must not automatically become released canonical content. In particular, this
draft does not approve:

- serving the uploaded question to another student as a library question;
- public publication of the upload;
- using the upload in marketing or testimonials;
- selling or licensing the upload;
- representing that Cramapple owns the underlying question merely because a
  student submitted it; or
- bypassing the ordinary content validation and release process.

This discussion interprets "no other use until legal issues are resolved" as
allowing private service operation and internal Cramapple improvement, while
blocking external, public, marketing, and canonical-library reuse. Reviewers
should flag this interpretation if it is not the intended boundary.

## 4. Upload permission and first-upload disclosure

**DIRECTION RECORDED:** contribution is opt-in through the student's voluntary
choice to use the upload feature. A separate contribution checkbox is not
required. On the first upload, the product must explain that uploading grants
the necessary permission and link to a dedicated Upload Policy.

The disclosure should appear before or immediately adjacent to the first upload
action. It should not rely on a hidden legal-page link. The product should
record:

- the student/account identifier;
- the acceptance timestamp;
- the Upload Policy version accepted; and
- the associated upload or first-upload event.

### Proposed first-upload copy for review

> By uploading, you give Cramapple permission to store and process this file to
> score your work, track your progress, prepare you for exams, and improve
> Cramapple for everyone. Do not include names or other personal information.
> You can delete uploaded files in Settings. [Read the Upload Policy.]

This is proposed product copy, not approved legal language. The final wording
must remain consistent with the Terms, Privacy Policy, and dedicated Upload
Policy.

### Hand-drawn work

Submitting an image is necessarily optional, but Cramapple cannot score the
hand-drawn content without receiving and processing it. A student who does not
want to grant the upload permission can decline to upload; the hand-drawn
scoring feature will then be unavailable for that work.

## 5. Personal-information reminder

**DIRECTION RECORDED:** remind students not to give Cramapple personal
information, but do not block the upload or another student action solely
because possible personal information is detected.

The reminder should be concise and visible near upload. Cramapple may still run
internal PII/name detection for minimization, reviewer safety, and quality
control, but the student-facing behavior is a warning rather than a mandatory
stop or forced correction.

Suggested reminder:

> Do not include names, school information, contact details, or other personal
> information in your upload.

The product must not claim that it can detect every identifier.

## 6. Recognition and background classification

**DIRECTION RECORDED:** every recognized question should be assessed in the
background for subject, unit, and topic. Where the taxonomy supports it, the
system should also propose the skill/cell needed for coverage lookup and
library-item selection.

For a multi-question worksheet, recognition and classification occur per
question, not only once for the whole page or document. Shared passages,
figures, tables, and directions must remain associated with every dependent
question.

Suggested states are:

```text
upload_received
upload_processing
question_or_worksheet_recognized
multiple_questions_segmented
recognition_failed
classification_proposed
classification_needs_confirmation
classification_confirmed
classification_corrected
coverage_available
coverage_unavailable
```

The product should show the proposed subject/unit/topic to the student and ask
the student to confirm or correct it. Student confirmation improves routing; it
does not make the uploaded question authoritative or convert it into approved
content.

If Cramapple cannot identify the uploaded material as a question or question
worksheet, it should say that it could not recognize the result and ask the
student to retake or replace the image. A student is not required to state the
source of the question.

## 7. Storage, inactivity, archiving, and reactivation

**DIRECTION RECORDED:** uploaded content is retained rather than automatically
deleted after processing.

### Active account

While the account is active, uploaded content remains associated with the
student account so Cramapple can support scoring, progress, preparation,
quality review, and the permitted improvement uses in §3.

### Inactive account

An account is inactive after **12 consecutive months with no account
activity**.

When an account expires under the applicable account/entitlement policy or
becomes inactive:

- archive the account;
- archive its uploaded content with it;
- retain related scores, progress, data, and metadata; and
- restrict archived material according to the archival security and access
  policy still to be specified.

Archiving is not deletion.

### Reactivation

If the student later purchases a new subject, reactivate the account and make
the archived account history and uploaded content available again under the
then-current product and policy rules.

The implementation specification will need to define how a purchase maps back
to the correct archived account and how conflicts, duplicate accounts, or a
changed login identity are handled. Those mechanics are not decided here.

## 8. Student-initiated deletion

**DIRECTION RECORDED:** students may opt into deletion of uploaded content
through a future Settings control.

Deletion removes what the student uploaded, including the original stored file
and stored reproductions of that file such as thumbnails or format-converted
copies. Deletion does **not** remove:

- scores;
- attempt and grading records;
- subject/unit/topic/skill classifications;
- progress records;
- extracted or derived data associated with the attempt;
- audit and policy-acceptance records; or
- other related metadata.

The final Upload Policy and Settings explanation should state this distinction
plainly so "delete upload" is not misread as "erase all evidence that the
attempt occurred."

### Consequence warning

Before deletion, warn the student that Cramapple will no longer be able to use
the deleted file for:

- visual re-analysis;
- image-based regrading or dispute review;
- reconstructing the student's original drawn work;
- image-specific progress evidence; or
- future exam-preparation guidance that depends on seeing that file.

Scores and retained related data may continue to contribute to progress and
preparation where they remain valid without the original image.

### Proposed deletion warning for review

> This deletes the files you uploaded. Your scores, attempt history, progress,
> classifications, and related records will remain. Cramapple will no longer
> be able to review or re-analyze the deleted images, and some image-based
> progress or exam-preparation guidance may no longer be available.

## 9. Upload Policy content requirements

The dedicated Upload Policy linked from first upload should address, in plain
language:

1. what counts as an upload;
2. what permission the student gives by uploading;
3. service operation and internal-improvement uses;
4. the non-blocking reminder not to include personal information;
5. background recognition, segmentation, and classification;
6. student confirmation or correction of classification;
7. the library-only open-hand teaching boundary;
8. active storage, the 12-month inactivity rule, account expiration, and
   archiving;
9. reactivation after purchasing a new subject;
10. deletion controls and the records that remain after deletion;
11. service-provider processing;
12. security and access limitations;
13. uses that are not currently authorized; and
14. how changes to the policy are communicated and versioned.

The policy should be incorporated into or linked consistently from the Terms
and Privacy Policy. The first-upload acceptance record should point to an
immutable policy version rather than only the latest mutable webpage.

## 10. Current public-policy alignment to review

The current public pages are:

- Terms: <https://cramapple.com/terms>
- Privacy Policy: <https://cramapple.com/privacy>

At the time of this discussion, those pages already describe using submitted
content and uploaded materials for service operation and broad internal
improvement. They also contain broader language concerning marketing use and
possible public publication. Review is needed to determine whether those
broader provisions should remain, be narrowed, or be made explicitly separate
from the interim upload boundary in §3.

The Terms page identifies itself as a draft for product and counsel review.
This discussion document does not determine whether the current public text is
legally sufficient, and it does not substitute for counsel review.

## 11. Governance interpretation for review

If adopted, the product direction would update the earlier planning posture as
follows:

### GOV-001 — interim upload rights and use

- Permit storage and processing for service operation.
- Permit internal Cramapple improvement as described in §3.
- Do not require a student to provide a source during intake.
- Keep public publication, marketing use, canonical-library release, and
  external reuse outside the interim permission until separately resolved.

Because source is not required, an upload cannot be presumed eligible for
canonical reuse. Any future canonical-promotion process remains a separate
rights, authorship, validation, and release decision.

### GOV-002 — notice, privacy, and user control

- Use the Terms, Privacy Policy, dedicated Upload Policy, and first-upload
  notice as the disclosure structure.
- Warn students not to include personal information.
- Do not block student actions solely on a possible-PII warning.
- Retain uploads under the active/archive lifecycle.
- Provide student-initiated deletion of uploaded files while preserving the
  related records defined in §8.

### GOV-003 — provider and academic-integrity boundary

- Apply the same permitted-use boundary to service-provider processing.
- Preserve the teach-not-solve and Cramapple-library-only open-hand rules.
- Do not treat an uploaded question as approved merely because it was
  recognized, classified, scored, or stored.

Provider-specific retention, provider training, regional processing, and
subprocessor terms still require technical/legal verification before a final
production specification.

## 12. Review questions

Reviewers should comment specifically on the following:

1. Does §3 correctly express the intended distinction between internal
   improvement and currently prohibited public/canonical/marketing reuse?
2. Is voluntary use of the upload action sufficient as the opt-in mechanism,
   provided the first-upload disclosure is prominent and versioned?
3. Should extracted question text and other derived data remain after the
   original uploaded file is deleted, as §8 currently records?
4. What exact event constitutes account expiration independently of the
   12-month inactivity rule?
5. What archive storage class, access roles, audit requirements, and restore
   process are required?
6. What deletion completion period and backup-expiration treatment should the
   final policy promise?
7. May service providers retain submitted content, or use it for provider-side
   model training, beyond processing it on Cramapple's behalf?
8. Should the current Terms/Privacy marketing and public-publication language
   be narrowed to match the interim boundary?
9. What evidence and quality threshold should be required before a proposed
   classification is used to select library teaching content?
10. What accessibility alternatives are required for students who cannot use
    camera or document upload?

## 13. Explicit non-goals for this discussion pass

This document does not:

- authorize a build;
- choose an OCR, vision, storage, or model provider;
- define physical database tables or storage buckets;
- define the final upload or Settings interaction design;
- approve legal language;
- approve canonical promotion of student-provided questions;
- change the content-release standard;
- decide Cram/Points positioning or pricing; or
- create an implementation task.

## 14. Proposed review outcome

After review, the Product Owner should record one of:

1. **Approve direction:** incorporate accepted decisions into the consolidation
   plan, intake design, governance backlog, legal-copy work, and a separately
   approved implementation task.
2. **Approve with changes:** identify the exact sections to revise and recirculate
   this discussion draft.
3. **Do not approve:** retain the existing upload-policy posture and record why
   this direction was rejected.

