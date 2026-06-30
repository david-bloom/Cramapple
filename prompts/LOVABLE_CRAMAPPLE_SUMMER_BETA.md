# Lovable Build Prompt - Cramapple Summer Feedback Beta

Build a polished, responsive, production-connected beta web application named
**Cramapple** for recent and upcoming AP Biology students.

This is a free research beta. Its purpose is not to deliver a complete AP
Biology course, generate topic lists, predict AP scores, or validate the full
Cramapple platform. Its purpose is to learn whether students find Cramapple's
core experience compelling:

```text
Choose an original AP-style FRQ
  -> answer independently
  -> receive criterion-level feedback
  -> see the highest-value missing point
  -> make one focused repair
  -> see whether the answer improved
  -> optionally try a related transfer question
  -> give candid product feedback
```

Use the attached Cramapple product documents as interaction and teaching
guidance, but implement only the narrow beta specified here:

- `STUDENT_PORTAL_INTERACTION_DESIGN.md`
- `STUDENT_PRACTICE_AND_GRADING_DESIGN.md`

Do not attempt to implement the complete future portal, recommendation engine,
content library, mastery model, review queue, tutor portal, or validated
production grader.

## Goal

Create a simple, credible experience that lets Cramapple answer:

1. Do past students believe this would have materially helped them?
2. Do upcoming students understand and value criterion-level FRQ feedback?
3. Can students use one focused repair to improve an answer?
4. Are Cramapple's predicted improvements calibrated?
5. Which parts feel useful, confusing, untrustworthy, or unnecessary?
6. Do users voluntarily try another question, save their place, or say they
   would return during exam preparation?

The product should feel like an early version of a serious learning tool, not a
survey wrapped around a generic chatbot.

## Product Principles

- Reach the first useful attempt quickly.
- Begin with a question, not a long onboarding sequence.
- Require the learner to answer before revealing answer-bearing help.
- Ground feedback in the learner's actual response and the supplied rubric.
- Show criterion points before revision.
- Recommend only one highest-value repair at a time.
- Distinguish independent work from coached revision.
- Treat AI output as experimental Cramapple coaching, not official College
  Board scoring.
- Preserve original submissions and append revisions rather than overwriting
  history.
- Collect behavioral evidence as well as opinions.
- Keep all content, prompts, grading results, and model configuration versioned
  so the beta can later migrate to Cramapple's content library and platform.

## Scope

### Required for beta launch

- Public landing page.
- One short role-selection step.
- Anonymous server-side sessions.
- Six original AP-style short FRQs.
- Versioned rubrics for all six FRQs.
- FRQ selection and attempt flow.
- Criterion-level AI evaluation.
- One recommended repair.
- `Better` and `Much better` predicted-improvement labels.
- Focused revision and re-evaluation.
- Optional fresh transfer question.
- Contextual and end-of-session feedback.
- Optional Google login to save and resume across devices.
- Anonymous local resume on the same browser without login.
- Model usage and cost recording.
- Application-enforced `$100 USD` daily hard cap.
- Accessible loading, failure, capacity, and resume states.

### Supported by the data model, but secondary

- Original Cramapple-authored MCQs.
- More FRQs and content types.
- Additional AP subjects.
- Future content-library identifiers and releases.
- Future validated graders and confidence policies.

MCQs must not delay the six-FRQ answer-feedback-repair experience. If initial
MCQs are included, they must be original Cramapple-authored questions and use
the same versioned content-package model.

### Out of scope

- Copying or embedding College Board questions, scoring guidelines, sample
  responses, tables, graphs, or other protected assets.
- Topic-list generation as the main experience.
- AI-generated public question banks.
- AP score projections.
- Percent mastery.
- Personalized next-best-topic recommendations.
- Review queues and spaced repetition.
- Parent or tutor dashboards.
- Image, graph, document, or handwriting upload.
- Public sharing or indexing of student work.
- Human-review promises.
- Automated disputes or regrading operations.
- Payments.
- Marketing-email capture.

## Routes

Use a clean SPA with client-side routing:

```text
/                         landing and privacy notice
/start                    role selection and beta explanation
/practice                 question selection
/practice/:questionId     cold FRQ attempt
/attempt/:attemptId       saved attempt and grading state
/attempt/:attemptId/repair
/attempt/:attemptId/result
/attempt/:attemptId/transfer
/session/:sessionId/end   session reflection
/resume                   local or authenticated session history
/account                  optional Google sign-in and saved sessions
/plan                     first-session plan and live session summary
/reviewer-login           reviewer auth entry and session check
```

Unauthorized users must not be blocked from practice. Authentication is
optional for learners and exists only for cross-device saving and
account-based resume, but live account and reviewer pages must treat the
Supabase Auth session as the source of truth when it is present.

## Landing Page

Create a calm, concise landing page. Do not lead with a methodology lecture.

Suggested hero:

```text
See exactly how your AP Biology answer could earn more points.

Try an original AP-style free-response question. Cramapple will show which
criteria your answer earned, what is missing, and the smallest change most
likely to improve it.
```

Primary action:

```text
Try a question
```

Secondary action:

```text
Resume
```

Trust note:

```text
Free research beta. No login required.

Cramapple uses experimental AI coaching. Results are not official College
Board scores, and Cramapple is not affiliated with or endorsed by the College
Board.
```

Do not use exaggerated score claims, testimonials, countdowns, streaks,
confetti, or marketing pressure.

## Privacy and Research Notice

Before beginning, show a short human-readable notice:

```text
A quick note before you start

Cramapple saves anonymous practice answers, feedback, and results so we can
evaluate and improve how it teaches. Please do not include your real name,
school, contact information, or anything else that identifies you.

A human note about privacy: Federal law limits what online services can collect
from children under 13. If you are 12 or younger, please do not sign in or
include your real name, school name, contact information, or anything else that
identifies you in an answer or feedback.
```

Require one checkbox:

```text
I understand that this is a research beta and that my anonymous practice data
may be used to evaluate and improve Cramapple.
```

Do not request date of birth, exact age, school, location, Reddit username,
phone number, or mailing-list consent.

## Role Selection

Require exactly one selection:

- Upcoming AP Biology student
- Past AP Biology student
- Tutor or teacher
- Parent

Store values as:

```text
upcoming_student
past_student
tutor_teacher
parent
```

Ask no other profile questions before the first attempt.

## Question Selection

Show six concise question cards. Each card may reveal:

- original title;
- AP Biology unit;
- broad skill;
- estimated response time;
- short or multi-part status.

Do not reveal hidden rubric criteria, answer-bearing concepts, model answers, or
the tested mechanism before the cold attempt.

Suggested labels:

```text
About 5 minutes
Short free response
Choose this question
```

Seed exactly six original short-FRQ content packages for the launch dataset.
The questions may test skills and concepts that commonly appear on AP Biology
exams, but all scenarios, prose, numbers, data, answer keys, rubrics, examples,
and visuals must be original.

Every package must include:

- stable `question_id`;
- `question_version`;
- title;
- AP Biology unit;
- broad skill tags;
- original prompt;
- original stimulus or data, if applicable;
- point value;
- independent rubric criteria;
- accepted answer variants;
- common incorrect patterns;
- minimum-fix guidance by criterion;
- one original aligned transfer question;
- source and rights status marked `cramapple_authored`;
- review status;
- author and reviewer metadata fields for future use.

Do not claim that placeholder seed content has passed expert review unless that
review has actually occurred. Use a content status that can prevent unreleased
packages from appearing.

## Stable Practice Frame

Use four recognizable regions:

1. Session context.
2. Question orientation.
3. Student attempt.
4. Feedback, repair, or completion state.

The cold-attempt screen includes:

- question and original stimulus;
- visible command verbs;
- response text area by subpart;
- autosave state;
- optional confidence rating;
- `Submit answer`;
- `Choose another question`.

Before submission, do not show:

- rubric criteria;
- model answer;
- likely score;
- tested-concept explanation;
- repair guidance;
- `Better` or `Much better`;
- expected point gain.

Autosave is not submission. Submission freezes an immutable response version
for grading.

## Core Teaching Loop

### 1. Cold attempt

Create an independent attempt and save the student's exact submitted response.
Label it:

```text
Independent attempt
```

### 2. Criterion-level evaluation

After submission, call the approved Supabase Edge Function. Show an accessible
grading state and preserve the answer if grading fails.

For each rubric criterion, display:

- `Earned`
- `Not yet earned`
- `Unable to determine`
- `Not applicable`

Each criterion card must include:

- learner-readable criterion;
- evidence from the student's exact response;
- concise reasoning;
- contradiction or ambiguity where relevant.

Show:

- points earned out of available points;
- what the student did well;
- the single highest-value missing criterion;
- the smallest useful next change;
- one recommended repair action.

Use progressive disclosure. Do not initially show a wall of feedback, every
possible intervention, and the next question simultaneously.

### 3. Predicted improvement

The repair recommendation must include one of:

```text
Better
Much better
```

Definitions:

- `Better` means the proposed repair is predicted to earn exactly one
  additional rubric point.
- `Much better` means the proposed repair is predicted to earn exactly two
  additional rubric points.

These labels describe the predicted effect of the proposed repair. They do not
replace the observed criterion result or baseline point total.

Do not show `Much better` when fewer than two unearned points remain.
Do not predict a gain greater than the number of available unearned points.
If the system cannot support either prediction, do not fabricate one; return an
uncertain result and invite another question.

Suggested presentation:

```text
The best next change

Explain how the altered protein changes transport across the membrane.

Better
This change is likely to earn 1 additional point.
```

or:

```text
Much better
This change is likely to earn 2 additional points.
```

### 4. Focused repair

Primary action:

```text
Fix this part
```

Open a revision workspace containing:

- immutable original response;
- focused repair prompt;
- editable revision;
- the criterion being repaired;
- the predicted `Better` or `Much better` effect.

Once repair guidance has been shown, label the revision:

```text
Coached revision
```

Do not relabel the original submission as coached.

### 5. Revision evaluation

Submit the revised response through the server-side grader. Create a new
response and grade record rather than overwriting the original.

Show:

- original points;
- revised points;
- actual point change;
- criteria that changed;
- whether the prediction was accurate.

Student-facing prediction outcomes may use:

```text
The revision improved by the expected amount.
The revision improved, but by less than expected.
The revision improved more than expected.
This revision did not earn an additional point yet.
```

Do not frame a mismatch as student failure. Prediction calibration is a
Cramapple-quality measurement.

### 6. Transfer question

Offer:

```text
Try a fresh question
```

The transfer question must test the repaired skill using a different original
scenario. It is a new independent attempt and must not expose the prior answer.

Transfer is optional in this summer beta. Record whether it was offered,
started, completed, and correct by criterion.

## AI and Backend Boundary

Lovable owns the client experience. It must never call OpenAI directly.

All model calls must go through an authenticated or anonymous-rate-limited
Supabase Edge Function, such as:

```text
evaluate-attempt
```

The OpenAI API key must exist only as a server-side secret.

Use:

- OpenAI Responses API;
- model configured server-side as GPT-5.5;
- reasoning effort `high`;
- Structured Outputs with a strict schema;
- `store: false`;
- configurable exact model identifier so a fixed snapshot can be used for
  stable calibration;
- versioned system and operation prompts.

Do not place the prior prototype prompt in browser code. Replace it with a
versioned Cramapple teaching prompt that implements the narrow teaching loop.

Server-side operations:

```text
grade_initial_attempt
select_repair
grade_revision
grade_transfer_attempt
```

These may share one Edge Function with an explicit operation field. Do not rely
on free-form conversation state as the source of truth.

Every grading call must receive:

- operation;
- anonymous or authenticated session ID;
- attempt ID;
- immutable response version ID;
- content package ID and version;
- rubric version;
- assistance condition;
- prompt version;
- idempotency key.

The server retrieves released question and rubric content. The client must not
be allowed to supply or modify canonical rubric criteria.

Expected structured result:

```json
{
  "status": "graded",
  "points_earned": 2,
  "points_available": 4,
  "criteria": [
    {
      "criterion_id": "criterion_1",
      "status": "earned",
      "response_evidence": "Exact short excerpt or faithful reference",
      "reason": "Why this evidence satisfies or misses the criterion"
    }
  ],
  "what_went_well": "Concise response-grounded observation",
  "highest_value_gap": {
    "criterion_id": "criterion_3",
    "minimum_fix": "The smallest useful change",
    "repair_prompt": "One focused student-facing prompt"
  },
  "predicted_improvement": {
    "label": "better",
    "predicted_point_gain": 1
  },
  "confidence": "high",
  "uncertainty_reason": null,
  "student_facing_summary": "Concise feedback"
}
```

Allowed prediction labels:

```text
better
much_better
none
```

Server validation must enforce:

- `better` maps to `predicted_point_gain = 1`;
- `much_better` maps to `predicted_point_gain = 2`;
- predicted gain cannot exceed remaining points;
- totals equal criterion decisions;
- unknown criterion IDs are rejected;
- malformed or contradictory output is not stored as a successful grade.

## Prompt Behavior

The teaching prompt must:

- use an encouraging, direct, non-pedantic tone;
- grade only against the supplied versioned rubric;
- evaluate criteria independently;
- cite evidence from the learner response;
- avoid generic rubric recycling;
- distinguish a biological-concept gap from insufficient explanation or
  signaling;
- identify one highest-value missing criterion;
- generate the smallest repair likely to earn the predicted point gain;
- avoid giving away unrelated criteria;
- avoid claiming an official College Board score;
- abstain when question, rubric, response, or evidence is insufficient;
- return only the required structured result.

Do not reproduce the prior prototype sequence, unit menu, 20/80 lecture,
provider-specific interface instructions, open-ended deep dive, score
projection, or generic chat navigation.

## Database

Generate Supabase migrations, indexes, foreign keys, timestamps, and Row Level
Security policies for a migration-friendly schema.

Recommended tables:

### `profiles`

- `id` references `auth.users`
- `role`
- `created_at`
- `updated_at`

Do not require a profile for anonymous use.

### `anonymous_sessions`

- `id` UUID
- `anonymous_token_hash`
- `role`
- `research_notice_version`
- `research_notice_accepted_at`
- `created_at`
- `last_active_at`
- `converted_user_id` nullable
- `conversion_confirmed_at` nullable

Never store the raw anonymous bearer token.

### `study_sessions`

- `id`
- `anonymous_session_id` nullable
- `user_id` nullable
- `started_at`
- `ended_at`
- `status`
- `entry_source` nullable
- `created_at`

Require exactly one valid owner path: anonymous session or authenticated user.

### `content_packages`

- `id`
- `content_type`
- `subject`
- `unit`
- `title`
- `version`
- `status`
- `rights_status`
- `review_status`
- `payload` JSONB
- `created_at`
- `released_at` nullable

Only released content is available to learners.

### `rubric_versions`

- `id`
- `content_package_id`
- `version`
- `points_available`
- `criteria` JSONB
- `status`
- `created_at`

### `attempts`

- `id`
- `study_session_id`
- `content_package_id`
- `content_version`
- `rubric_version_id`
- `attempt_kind`
- `assistance_condition`
- `status`
- `started_at`
- `submitted_at` nullable
- `created_at`

Attempt kinds include:

```text
initial
revision
transfer
```

Assistance conditions include:

```text
independent
coached
```

### `response_versions`

- `id`
- `attempt_id`
- `parent_response_version_id` nullable
- `response_text`
- `response_parts` JSONB
- `version_number`
- `is_submitted`
- `created_at`

Submitted response versions are immutable.

### `grading_results`

- `id`
- `attempt_id`
- `response_version_id`
- `operation`
- `status`
- `points_earned` nullable
- `points_available`
- `criterion_results` JSONB
- `highest_value_gap` JSONB nullable
- `predicted_label` nullable
- `predicted_point_gain` nullable
- `actual_point_gain` nullable
- `prediction_outcome` nullable
- `confidence`
- `uncertainty_reason` nullable
- `model_id`
- `prompt_version`
- `rubric_version_id`
- `input_tokens`
- `output_tokens`
- `estimated_cost_usd`
- `latency_ms`
- `created_at`

### `feedback_responses`

- `id`
- `study_session_id`
- `attempt_id` nullable
- `grading_result_id` nullable
- `feedback_moment`
- `question_key`
- `rating_value` nullable
- `choice_value` nullable
- `written_comment` nullable
- `created_at`

Feedback moments include:

```text
after_feedback
after_repair
session_end
```

### `analytics_events`

- `id`
- `study_session_id`
- `anonymous_session_id` nullable
- `user_id` nullable
- `event_name`
- `content_package_id` nullable
- `attempt_id` nullable
- `properties` JSONB
- `created_at`

Do not put full student responses or AI feedback into analytics-event
properties.

### `model_usage_ledger`

- `id`
- `request_id`
- `usage_date_utc`
- `reserved_cost_usd`
- `actual_cost_usd` nullable
- `status`
- `model_id`
- `input_tokens` nullable
- `output_tokens` nullable
- `created_at`
- `completed_at` nullable

### `prompt_versions`

- `id`
- `operation`
- `version`
- `status`
- `prompt_hash`
- `created_at`
- `released_at` nullable

Do not store server secrets or full private prompts in client-readable tables.

## Anonymous Sessions and Login

On first use:

1. Generate a cryptographically random anonymous token.
2. Store only the token in secure browser storage appropriate for the
   architecture.
3. Store only a hash server-side.
4. Use the anonymous session to authorize access to its own records.

Anonymous sessions must not be broadly readable through Supabase's public
client.

Optional Google login:

- Label: `Sign in with Google to save across devices`
- Explain that login is optional.
- After sign-in, ask the user to confirm attaching the current anonymous
  session to the account.
- Do not silently merge unrelated browser sessions.
- Preserve the original anonymous-session identifier for audit and research
  lineage.

Do not include a production `Dev Bypass Login`. A development-only bypass may
exist only behind a non-production environment flag and must be impossible to
render in production.

For non-production verification only, it is acceptable to add a clearly labeled
developer diagnostics surface that shows the active Supabase project ref,
whether `supabase.auth.getSession()` currently returns a session, and whether
that session has an access token. Any copy/export action for the token must be
impossible to render in production.

## Daily Cost Hard Cap

Enforce a hard maximum of:

```text
$100 USD per UTC day
```

The cap must be enforced server-side before every OpenAI request.

Requirements:

- Store current model input and output rates as server-side configuration.
- Estimate and reserve the maximum expected request cost atomically before
  calling OpenAI.
- Calculate actual cost from returned token usage.
- Reconcile the reservation after completion.
- Include active reservations when checking the cap.
- Reject a request when `actual spend + active reservations + requested
  reservation` would exceed `$100`.
- Prevent race conditions from concurrent requests.
- Never rely only on client state or an OpenAI billing alert.
- Make the limit configurable without a client deployment.
- Record rejected budget requests without storing unnecessary student text.

Capacity message:

```text
Cramapple has reached today's research limit.

Your work is saved. Please come back after the daily limit resets.
```

Do not expose internal spend, API credentials, or implementation details to the
student.

Also implement:

- per-anonymous-session rate limits;
- maximum response length;
- maximum retries;
- idempotent submission;
- timeout handling;
- duplicate-request protection.

## Feedback Collection

Feedback must be contextual and brief. Do not interrupt every screen.

### After initial AI feedback

Ask:

```text
Did this feedback clearly identify what would improve the answer?
```

Choices:

- Yes
- Partly
- No

Optional:

```text
What felt useful, confusing, or wrong?
```

### After revision

Ask:

```text
Did the repair help you understand how to earn the missing point?
```

Choices:

- Yes
- Somewhat
- No

Also record behavior automatically:

- revision started;
- revision submitted;
- predicted point gain;
- actual point gain;
- transfer started;
- transfer completed.

### Session end

Adapt wording by role where useful, while keeping stable question keys.

Ask:

```text
How useful would this have been during AP Biology preparation?
```

Scale:

```text
1 Not useful
2
3
4
5 Extremely useful
```

Ask:

```text
When would you have used Cramapple?
```

Choices:

- Throughout the course
- Before unit tests
- One to four weeks before the AP exam
- During the final week
- I would not have used it

Ask:

```text
What would you have used it instead of?
```

Allow multiple selections:

- A general AI chatbot
- Videos
- Review book
- Teacher or tutor help
- Another study app
- Nothing

Ask:

```text
What would make you trust or distrust the feedback?
```

Ask:

```text
After seeing this, what would you most likely do?
```

Choices:

- Try another question now
- Save it for exam season
- Share it with a student
- Probably not use it

Final open question:

```text
Be candid: what felt genuinely useful, and what felt pointless or annoying?
```

Do not ask only whether the user "liked" Cramapple.

## Research Events

Record at least:

```text
landing_viewed
research_notice_accepted
role_selected
question_list_viewed
question_selected
attempt_started
attempt_submitted
grading_started
grading_completed
grading_failed
feedback_viewed
repair_offered
repair_started
repair_submitted
repair_graded
transfer_offered
transfer_started
transfer_completed
another_question_started
login_offered
login_started
login_completed
session_feedback_started
session_feedback_completed
session_ended
daily_cap_reached
```

Use server timestamps for authoritative events. Avoid collecting invasive
device fingerprints or precise location.

## States and Failure Handling

Support:

- loading content;
- autosaving;
- saved;
- submitting;
- grading;
- graded;
- qualified or uncertain result;
- malformed model result;
- temporary grading failure;
- request timeout;
- rate limit;
- daily budget cap;
- offline or network failure;
- anonymous-session recovery;
- login cancellation;
- session conversion failure.

Technical failure copy:

```text
Your answer is saved, but feedback is taking longer than expected.
```

Actions:

- Try again
- Continue later
- Choose another question

Retry must reuse the same submission and idempotency key. It must not create a
duplicate attempt.

Uncertain result copy:

```text
Cramapple can offer a few useful observations, but it is not confident enough
to present this result as reliable.
```

Do not show a precise total when the result is internally inconsistent or the
grader cannot support it.

## Visual Direction

- Clean shadcn components and Tailwind CSS.
- Excellent typography and generous spacing.
- Warm off-white canvas.
- Deep green primary actions.
- White question and feedback cards.
- Restrained amber and red for warnings and errors.
- Calm, direct, academically serious tone.
- Mobile-first responsive layout.
- Avoid a chat-bubble interface.
- Avoid visual noise, gamification, fake mastery meters, and excessive
  animation.

The learner's response and exact criterion feedback should remain easy to
compare on desktop and mobile.

## Accessibility

- Full keyboard operation.
- Visible focus.
- Semantic headings, landmarks, form labels, status, and errors.
- No color-only criterion status.
- Screen-reader announcement for autosave, submit, grading, failure, and
  completion.
- Error summaries move focus to the relevant field.
- Reflow at 390 CSS pixels.
- Touch-friendly target sizes.
- Reduced-motion support.
- Time estimates are guidance, not timers.

## Forbidden Behavior

- Do not call OpenAI from the browser.
- Do not expose the OpenAI API key or private prompts.
- Do not let the browser write grading truth, point totals, model usage, or
  budget-ledger records directly.
- Do not let the browser submit its own rubric.
- Do not treat UI route hiding as authorization.
- Do not use service-role keys in client code.
- Do not copy official College Board content.
- Do not claim official scoring, validated grading, mastery, or likely AP score.
- Do not overwrite submitted responses or prior grades.
- Do not automatically publish or reuse student work as canonical content.
- Do not send raw student responses to marketing analytics.
- Do not create public student-response URLs.
- Do not collect unnecessary personal information.
- Do not include a production development-login bypass.
- Do not silently continue model calls after the daily cap is reached.

## QA Expectations

Verify:

1. A guest can accept the notice, choose a role, select an FRQ, answer, receive
   feedback, repair, and finish without logging in.
2. Cold attempt screens do not leak rubric criteria or answers.
3. Baseline criterion points are shown before repair.
4. `Better` always maps to predicted `+1`.
5. `Much better` always maps to predicted `+2`.
6. Prediction never exceeds remaining available points.
7. Original and revised responses remain separately visible.
8. Actual point gain is computed from stored grading results, not trusted from
   the client.
9. Coached revisions are not presented as independent evidence.
10. Transfer questions create new independent attempts.
11. Refreshing or retrying does not duplicate submissions or model calls.
12. Anonymous users can resume on the same browser.
13. An anonymous session can be deliberately attached after Google login.
14. One user cannot read another anonymous or authenticated session.
15. Only released content packages are selectable.
16. The client cannot modify rubrics or grading records.
17. Concurrent requests cannot exceed the `$100/day` cap.
18. The daily-cap state preserves student work and blocks new model calls.
19. Malformed or contradictory model output enters a safe failure or uncertain
    state.
20. Feedback records remain connected to role, session, content version,
    attempt, grading result, prompt version, and model version.
21. Mobile, keyboard, screen-reader, reduced-motion, slow-network, offline,
    error, and resume paths work.

## Definition of Done

The beta is complete when a guest can experience the full original-FRQ
answer-feedback-repair loop, Cramapple can measure predicted versus actual point
gain, the user can provide candid role-aware feedback, all activity is stored
with migration-friendly versioning, optional login safely preserves progress,
and server controls prevent OpenAI spend from exceeding `$100 per UTC day`.
