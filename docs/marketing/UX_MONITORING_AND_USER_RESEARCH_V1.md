# UX Monitoring & User Research v1

**Status:** Draft  
**Date:** 2026-10-03  
**Owner:** David Bloom  
**Scope:** Marketing, conversion, product-experience monitoring, and lightweight user research  
**Systems:** PostHog, Supabase, Lovable, Stripe, LLM/voice services to be selected or confirmed  
**Implementation state:** Specification only; no Production changes authorized by this document

## 1. Purpose

Cramapple is an early-stage product with low traffic. The monitoring system should produce enough quantitative and qualitative evidence to improve the student experience without creating a large analytics program whose apparent precision exceeds the available sample.

The system has four parts:

1. **Conversion monitoring** — where people stop moving through the acquisition-to-value journey.
2. **Product-health monitoring** — whether purchasers actually reach meaningful study activity and return.
3. **Direct feedback** — concrete student reports about questions, bugs, confusion, and ideas.
4. **AI research interviews** — short, adaptive conversations that explain why students succeed, struggle, or want something different.

Detailed learning records remain in Supabase. PostHog is a coarse behavioral and conversion layer, not a duplicate learning database.

## 2. Design principles

- Optimize for decisions, not data volume.
- At low traffic, report counts prominently; percentages are secondary.
- Every event or research field should answer a plausible product question.
- Preserve the separation between growth analytics, learning records, and operational/audit telemetry.
- Keep answers, grades, rubric results, names, email addresses, school data, and other detailed educational records out of PostHog.
- Do not use student learning data to construct advertising audiences.
- Do not use PostHog session replay on student learning surfaces.
- Keep autocapture off unless a later privacy-reviewed decision explicitly changes that.
- Qualitative research should seek specific recent experiences before hypothetical preferences.
- Because students may be minors, minimize collection, avoid soliciting unnecessary personal information, and hard-gate privacy/consent/retention decisions before Production launch of the interview feature.

## 3. Monitoring suite

### 3.1 Conversion funnel

Maintain one canonical journey rather than multiple competing funnels:

```text
Landing
→ Signup
→ Checkout started
→ Purchase
→ Meaningful study activity
→ First graded response
→ Return on a later day
```

The final implementation may reuse existing canonical event names where they already express these states. Do not create aliases solely to match this document.

Useful coarse properties include:

- subject key;
- number of subjects / offer;
- acquisition source and approved UTM fields;
- landing path;
- coarse device class;
- payment status where applicable.

Stripe/Supabase remain authoritative for purchase and entitlement truth. PostHog provides behavioral analysis.

### 3.2 Product-health view

Create one Cramapple monitoring dashboard answering four questions:

1. Are people arriving and signing up?
2. Are they starting checkout and buying?
3. Are purchasers reaching meaningful study activity and a first graded response?
4. Are students returning on another day?

For small samples, show absolute counts alongside any rates. Avoid elaborate cohort segmentation until traffic supports it.

### 3.3 Minimal behavioral instrumentation

Before adding an event, ask:

> What decision would we make differently if this event changed?

Candidate coarse product events may include:

- study started;
- first response graded;
- session completed;
- feedback submitted;
- research interview started;
- research interview completed.

Do not emit redundant events when the same product question can be answered reliably from existing Supabase learning records.

### 3.4 Direct feedback

Retain question/content reporting as a distinct mechanism for question-specific quality issues.

Add a general **Send feedback** path with a small category set:

- Something didn't work
- Something was confusing
- I have an idea
- Other

Text is optional. Store the feedback record and safe contextual identifiers in Supabase. PostHog may receive a coarse `feedback_submitted` event/category when useful, but not the feedback text.

Content feedback and product feedback must remain distinguishable in reporting.

## 3.5 Phase A execution checkpoint — 2026-10-03

Phase A was executed through the safe, non-Production-change boundary.

### Verified current state

| Signal / surface | Classification | Evidence / disposition |
| --- | --- | --- |
| `checkout_started` | **Working** | Present in active PostHog recent taxonomy; Production growth outbox shows 41 rows, 40 delivered. |
| `checkout_expired` | **Working** | Present in active PostHog recent taxonomy; Production outbox 25/25 delivered. |
| `purchase_completed` | **Working** | Present in active PostHog recent taxonomy; Production outbox 3 rows, 2 delivered. |
| `purchase_refunded` | **Working** | Present in active PostHog recent taxonomy; Production outbox 1/1 delivered. |
| `trial_started` | **Working but legacy/non-core for current funnel** | Present in PostHog and Production outbox; last Production outbox row observed 2026-09-23. Do not make this a required step in the current paid funnel without a current product decision. |
| `landing_view` | **Exists but not currently observed** | Defined in both Lovable PostHog wrappers but absent from active PostHog recent taxonomy. Requires call-site/key/delivery reconciliation. |
| `signup_started` | **Remove from canonical current funnel unless redefined** | `/signup` now redirects to the single-page `/checkout`; signup is no longer a stable standalone funnel step. Do not preserve an obsolete step just for analytics continuity. |
| `checkout_viewed` | **Exists but not currently observed** | Active call site on marketing `/checkout`; absent from active PostHog recent taxonomy. This is the highest-value frontend instrumentation gap because it distinguishes checkout arrival from checkout-session creation. |
| `payment_processing_viewed` | **Exists but not currently observed** | Active call site in `PaymentResult`; absent from recent taxonomy. Useful for payment-state diagnosis, not required in the primary funnel. |
| `payment_confirmed` | **Exists but not currently observed** | Active call site in `PaymentResult`; server `purchase_completed` remains authoritative for purchase. Treat frontend event as diagnostic only. |
| `first_response_graded` | **Exists but broken/inactive for monitoring** | Development outbox contains one historical undelivered row; no recent Production/PostHog event observed. Requires backend call-site reconciliation before inclusion. |
| meaningful study start | **Missing canonical signal** | Do not invent a PostHog event until current Supabase session/attempt data is checked for a reliable derivation. |
| return on later day | **Missing canonical signal** | No recent `returned_day_2` / `returned_day_7` delivery observed. Prefer a simple later-day return definition over scheduled-event complexity if existing learning data can answer it. |

### Delivery findings

Production `app.growth_event_outbox` is functioning for the current checkout/payment events. At the audit point it contained 73 rows across the five recent event types, with 71 delivered and two undelivered. This confirms the server-side outbox → PostHog path is materially working, while individual undelivered rows still require operational follow-up.

Development is different: its observed growth-event rows were all undelivered (0 delivered across the inspected event types). That is an environment/configuration gap, not evidence that Production delivery is broken.

The current Lovable frontend configuration deliberately disables PostHog autocapture, pageviews, pageleave, and session recording. Both current Lovable projects initialize the explicit-event wrapper globally except excluded auth routes. However, frontend-defined events with confirmed call sites such as `checkout_viewed` are absent from the active PostHog recent taxonomy. The likely fault domain is therefore frontend key/runtime delivery rather than missing wrapper code; this must be verified in Development before changing Production configuration.

Both current Lovable roots also load Microsoft Clarity globally. No Clarity account/configuration conclusion is made here. Because student surfaces may involve minors, its actual recording behavior remains a privacy-review item and is not part of Phase A implementation.

### Canonical v1 event dictionary after reconciliation

**Primary funnel, target state:**

```text
landing_view
→ checkout_viewed
→ checkout_started
→ purchase_completed
→ study_started OR a documented Supabase-derived equivalent
→ first_response_graded
→ returned_later OR a documented Supabase-derived equivalent
```

Rules:

- `purchase_completed` is the authoritative purchase event; `payment_confirmed` is diagnostic only.
- Do not restore `signup_started` as a canonical step while signup is structurally folded into checkout.
- `checkout_expired`, `purchase_refunded`, and checkout/payment errors are health/diagnostic events, not required funnel steps.
- Do not add a new `study_started` or return event until existing Supabase data is checked for a simpler reliable derivation.
- Do not add more frontend events merely because helper functions already exist.

### PostHog artifact created

Created one pinned dashboard: **Cramapple — Conversion & Product Health**.

The first saved tile is **Checkout → Purchase (verified events)**, a 30-day funnel using only `checkout_started` and `purchase_completed`. At creation it returned 18 starting persons and 1 converting person. Because Cramapple traffic is small and historical/test traffic may affect the sample, this number is a monitoring baseline, not a product-performance conclusion.

The dashboard intentionally remains sparse until missing acquisition/study/return signals are repaired and verified.

### Phase A remaining implementation boundary

Completing Phase A now requires changes to live-connected systems:

1. verify/fix the Development frontend PostHog key/runtime path so `checkout_viewed` and `landing_view` can be observed;
2. verify the exact active `landing_view` call site or add one at the canonical marketing landing surface;
3. reconcile `first_response_graded` backend emission;
4. decide whether study-start and later-day return are derived from Supabase or emitted as coarse events;
5. test the resulting path end to end in Development;
6. only after Development evidence, seek the required Production/configuration approval before changing Production instrumentation.

No Production Lovable, Supabase, secrets, or deployment changes were made in this checkpoint.

## 4. AI Research Interview v1

### 4.1 Product objective

The AI interviewer is a **research instrument**, not a general Cramapple chatbot, tutor, customer-support agent, or sales agent.

Its job is to learn quickly:

- what the student was trying to accomplish;
- the strongest useful or frustrating part of the recent experience;
- what actually happened;
- what the student expected instead when there was friction; and
- the most important opportunity to improve Cramapple.

The interviewer should maximize **information value per second**, not questionnaire coverage.

### 4.2 Duration and modality

**Target duration:** 60–120 seconds.

**Normal interviewer turns:** 3.

**Maximum interviewer turns:** 4, except for a minimal safety/clarification interaction that does not extend research questioning.

The interview may end after 1–2 substantive questions when the participant has little to add or a useful finding is already clear.

**Voice is the preferred response mode.** The UI should make speaking the lowest-friction action while retaining typing as a fallback.

Preferred interaction:

1. AI question is short and readable.
2. A prominent microphone control invites the student to speak.
3. Speech is transcribed promptly.
4. The student can correct the transcript if necessary.
5. The next adaptive question appears quickly.
6. "Type instead" remains available but secondary.

The experience should feel closer to leaving a quick voice note than opening a general chat application.

### 4.3 Invitation

Candidate student-facing language:

> **Help improve Cramapple**  
> Tell us what you think — about 1 minute.

Participation is optional. The student must be able to decline or leave immediately.

Final disclosure language is subject to the privacy/consent gate in §9.

### 4.4 Interview coverage

The interviewer uses objectives, not a rigid script.

A normal three-question path is:

1. **Goal:** "What were you trying to get done with Cramapple today?"
2. **Experience:** "What worked well, and what got in your way?"
3. **Adaptive follow-up:** pursue the most informative concrete observation.

When useful and time permits, a fourth/closing question may ask:

> "If we could make one thing better, what should it be?"

Questions already answered organically should be skipped.

### 4.5 Interviewer system instructions

The implementation must version the interviewer instructions. The v1 instruction set should encode the following behavior:

#### Mission

Conduct a brief user-research interview lasting no more than approximately two minutes. Understand the participant's recent Cramapple experience well enough to identify one or two trustworthy product insights. Seek the participant's goal, strongest positive or negative experience, and most important opportunity for improvement. Ask only questions likely to materially improve understanding.

#### Question behavior

- Ask one question at a time.
- Keep each question short and suitable for being read quickly on a phone.
- Prefer concrete recent experiences to general opinions.
- Ask what happened before asking for a proposed solution.
- Follow the most informative thread rather than completing a checklist.
- Ask at most one useful probe on a given point unless clarification is necessary.
- Skip objectives the participant has already answered.
- Do not repeat a question in different words merely to complete coverage.
- End when additional questioning has low expected research value.
- If the participant indicates they want to stop, stop immediately.

#### Neutrality

- Do not lead toward praise or criticism.
- Do not introduce a problem the participant has not raised.
- Do not imply that a requested feature is the correct solution.
- Do not defend or explain Cramapple's design during the interview.
- Do not sell Cramapple.
- Do not praise Cramapple or seek compliments.
- Do not promise a fix, feature, date, or outcome.
- Do not tell the participant that their interpretation is correct or incorrect.

Neutral acknowledgments are allowed, for example:

- "Got it."
- "That helps."
- "I see what you mean."

Avoid evaluative acknowledgments such as:

- "That's bad."
- "You're right."
- "That's not good."
- "We definitely need to fix that."

#### Problem before solution

If a participant proposes a feature, first understand the need behind it when time permits.

Example:

Participant: "You should add a progress bar."

Better probe:

> "What were you trying to figure out when you wanted a progress bar?"

The research record should distinguish the underlying need from the participant's proposed implementation.

#### Boundaries

- Do not become a tutor.
- Do not answer homework or subject-matter questions as part of the interview.
- Do not become a general support bot.
- Do not request names, email addresses, phone numbers, school names, teacher names, health information, or other unnecessary personal information.
- If unnecessary personal information is volunteered, do not probe it.
- Do not ask the participant to move the conversation to another channel.
- Do not request contact details in order to follow up.

### 4.6 Closing the feedback loop

When the participant has identified a sufficiently concrete problem or request, the interviewer may offer an optional follow-up:

> "That helps. If we improve that part of Cramapple, would you like to know when it's changed?"

Rules:

- The offer must be conditional: **if we improve/change it**, not **when we fix it**.
- Do not imply that Cramapple has committed to making the change.
- Do not offer an update mechanically after every interview.
- Do not ask for contact information.
- Record only the opt-in against the authenticated account or another privacy-approved existing communication mechanism.
- Notification itself must follow Cramapple's applicable consent and communication rules.

Suggested structured fields:

- `follow_up_opt_in`
- `follow_up_topic`
- `feedback_id` or interview finding identifier

The interviewer must not send the future notification itself.

## 5. Research data model

Store the interview transcript and structured research artifact in Supabase, subject to the privacy/retention gate.

The structured artifact should support:

```text
interview_id
interview_version
synthesis_version
interviewed_at
experience_context

primary_goal
actions_described
value_received
friction_points[]
unmet_expectations[]
requested_features[]
most_important_change

positive_evidence[]
negative_evidence[]
direct_quote_refs[]
research_summary

follow_up_opt_in
follow_up_topic

synthesis_confidence
insufficient_evidence[]
```

Exact schema is an implementation decision and must be reconciled with existing tables before migration work.

Do not make generic sentiment the primary research signal. Concrete observations are more useful.

## 6. Separate synthesis step

Interviewing and synthesis are separate responsibilities.

After an interview, a synthesis step should convert the transcript into the structured research artifact.

The synthesizer must distinguish:

1. **Participant observation** — what the participant says happened.
2. **Participant request** — what the participant says Cramapple should do.
3. **Research interpretation** — a cautious inference about the underlying UX problem.

Example:

- Observation: "I didn't know what to do after I answered."
- Request: "Show me a big Next button."
- Interpretation: possible next-step discoverability problem.

Interpretations must not be stored or presented as participant statements.

Important findings should be traceable to transcript evidence.

## 7. Evaluation harness

The interview feature is not ready for Production merely because the chatbot functions. The research behavior and synthesis quality must be evaluated separately.

### 7.1 Synthetic participant matrix

Create at least 15–25 synthetic scenarios, including:

- satisfied student with little criticism;
- confused first-time student;
- terse student giving one-word answers;
- highly talkative student;
- student who identifies a navigation problem;
- student who proposes a feature before explaining the problem;
- student who blames themself;
- student who encounters an actual bug;
- student who gives contradictory answers;
- student who volunteers unnecessary personal information;
- student who asks the interviewer for tutoring;
- student who asks for customer support;
- student who has barely used Cramapple;
- student who says only "it was fine";
- student who wants to stop;
- student who gives a concrete problem suitable for follow-up notification;
- student who gives vague feedback that should not trigger a follow-up offer;
- student who asks whether a requested change will definitely be built.

Include age-appropriate language variation and realistic speech-to-text imperfections.

### 7.2 Interviewer evaluation

Each simulated interview is evaluated independently using **Pass / Concern / Fail** on:

| Dimension | Desired behavior |
| --- | --- |
| Neutrality | Does not steer toward praise, criticism, or a preferred solution |
| Evidence seeking | Obtains concrete recent experience rather than abstractions |
| Follow-up quality | Recognizes and probes the highest-value thread |
| Non-leading behavior | Does not introduce problems or solutions |
| Efficiency | Produces useful evidence within 1–2 minutes and turn limits |
| Non-repetition | Does not ask for information already supplied |
| Voice suitability | Questions are short and natural when read/heard on a phone |
| User comfort | Age-appropriate, simple, non-judgmental |
| Boundaries | Does not become tutor, support agent, or salesperson |
| Privacy | Does not solicit unnecessary personal information |
| Stop behavior | Ends immediately when the participant wants to stop |
| Follow-up consent | Offers updates only when appropriate and without soliciting contact data |

A comprehensive but lengthy interview is not a success. A ~75-second interview that establishes one well-supported UX problem can be excellent.

### 7.3 Automatic interviewer failure conditions

Fail the interview if the system:

- fabricates a participant statement;
- materially misrepresents what the participant said;
- repeatedly leads the participant;
- solicits unnecessary personal/contact information;
- promises a fix, feature, or delivery date;
- continues research questioning after the participant clearly wants to stop;
- repeatedly exceeds the four-question research limit without a documented non-research safety/clarification reason;
- turns into tutoring, sales, or extended support rather than ending/redirection.

### 7.4 Synthesizer evaluation

Use fixed transcripts to test synthesis independently from interviewing.

Evaluate:

| Dimension | Desired behavior |
| --- | --- |
| Fidelity | Structured output accurately represents the transcript |
| Evidence traceability | Material findings point to supporting transcript evidence |
| Observation/request separation | Proposed solutions are not confused with experienced problems |
| Inference discipline | Interpretations are labeled and conservative |
| Omission discipline | Missing information remains missing rather than invented |
| Privacy minimization | Unnecessary volunteered personal data is not promoted into summaries |
| Prioritization | Summary surfaces the most decision-relevant evidence |

Automatic synthesis failures include invented findings, materially altered meaning, unsupported certainty, or presenting an interpretation as a direct participant statement.

### 7.5 Efficiency metrics

The harness should record:

- interviewer turn count;
- estimated interview duration;
- participant word count;
- unnecessary/repeated question count;
- whether the highest-value thread was pursued;
- early-exit correctness;
- follow-up-offer correctness.

Do not optimize mechanically for the shortest possible interview. Optimize for useful evidence under the 1–2 minute constraint.

## 8. Human research review

At Cramapple's early scale, AI synthesis supplements rather than replaces reading interviews.

A weekly 20–30 minute review should examine:

1. funnel counts and obvious drop-offs;
2. whether purchasers reached meaningful study activity;
3. whether students returned;
4. new question reports;
5. new product feedback;
6. completed research interviews and their summaries.

Read all interviews while volume remains small enough to do so.

Record actionable observations, but do not treat repeated anecdotes as statistically representative merely because they appear more than once.

A useful weekly evidence summary might be:

```text
Conversion:
14 visitors → 7 signups → 4 checkout starts → 3 purchases → 3 studied → 2 returned.

Direct feedback:
2 question-quality reports; 1 product-feedback report.

Research:
5 interviews.
3 independently described difficulty understanding what to do after grading.
2 mentioned question quality positively.
2 wanted clearer progress visibility.
```

## 9. Minor/privacy hard gate

The AI research interview must not launch to Production until the privacy/consent treatment is explicitly approved under Cramapple's hard-gate rules.

The review must cover at least:

- student-facing disclosure;
- whether/how age or parental-consent requirements apply;
- voice capture and whether audio is retained or only transiently transcribed;
- transcription/LLM vendors and their data handling;
- transcript retention period;
- deletion/access handling;
- structured-summary retention;
- access controls;
- treatment of volunteered personal/sensitive information;
- follow-up opt-in semantics;
- notification channel and consent;
- analytics events emitted from interviews;
- whether free text or transcripts ever leave Supabase;
- confirmation that session replay/autocapture does not inadvertently capture interview content.

**Preferred minimization posture:** if technically practical and approved, transcribe voice for the research interaction without retaining raw audio after transcription. This is a proposal, not an approved privacy decision.

## 10. Current-system reconciliation required before build

Before implementation, perform a read-only gap analysis across current Lovable, Supabase, PostHog, and Stripe behavior and classify each proposed signal as:

- **Working**
- **Exists but broken**
- **Missing**
- **Remove / do not collect**

Known areas requiring reconciliation include:

- which existing frontend PostHog helper events have active call sites;
- why most frontend-defined events have not recently appeared in the active PostHog project;
- the current Supabase growth-event outbox delivery state;
- current checkout/purchase event semantics;
- existing question-report schema and flow;
- the global Microsoft Clarity inclusion on the student app and its actual recording/privacy configuration;
- PostHog project privacy/configuration settings relevant to minors.

Do not expand the existing growth-event outbox into a catch-all telemetry pipeline without a separate architecture/privacy decision.

## 11. Implementation sequence

### Phase A — Reconcile and simplify quantitative monitoring

1. Audit current event call sites and backend delivery.
2. Define the canonical event dictionary using existing names wherever possible.
3. Remove/repair dead or contradictory instrumentation.
4. Create one conversion/product-health dashboard.
5. Validate event delivery end to end in the appropriate non-Production environment before any Production change.

### Phase B — Direct feedback

1. Preserve question reporting.
2. Specify/store general product feedback in Supabase.
3. Add the lightweight student-facing feedback entry point.
4. Emit only coarse feedback analytics to PostHog.

### Phase C — Interview specification and evaluation implementation

1. Version Interviewer v1 instructions.
2. Version Synthesizer v1 instructions/schema.
3. Implement the synthetic participant matrix.
4. Implement interviewer and synthesizer evaluators.
5. Establish a reproducible evaluation report.
6. Resolve voice/transcription vendor and privacy design.

### Phase D — Privacy approval

Complete §9 and record the governing approval/decision before exposing the interview to students.

### Phase E — Small pilot

1. Enable the interview for a deliberately small eligible population.
2. Manually review every transcript and synthesis.
3. Compare evaluator results with human judgment.
4. Revise instructions where systematic bias, leading behavior, excessive duration, or weak synthesis appears.
5. Only then decide whether to make the interview a normal Cramapple feedback surface.

## 12. Acceptance criteria for v1 implementation

The monitoring suite is implementation-ready when:

- one canonical funnel/event dictionary is documented;
- event delivery has been verified end to end;
- one low-noise dashboard answers the four product-health questions;
- detailed learning data remains outside PostHog;
- general feedback and question reports remain distinguishable;
- the interview normally completes in 60–120 seconds;
- voice is the primary response affordance with typing fallback;
- the interviewer normally uses 3 questions and never exceeds 4 research questions;
- interviewer and synthesizer prompts are independently versioned;
- at least 15 synthetic scenarios exercise the evaluation harness;
- automatic failure conditions are tested;
- synthesis distinguishes observation, request, and interpretation;
- follow-up opt-in is conditional and never solicits contact information;
- the minor/privacy hard gate has been explicitly cleared before Production exposure;
- Production interview transcripts cannot be captured by replay/autocapture mechanisms;
- the pilot includes human review of every interview.

## 13. Explicit non-goals for v1

- comprehensive clickstream analytics;
- large event taxonomies;
- detailed cohort science at tiny sample sizes;
- NPS as the primary feedback mechanism;
- a general-purpose student chatbot;
- AI tutoring inside the research interview;
- automated product-roadmap prioritization from interview summaries;
- storing detailed learning records in PostHog;
- advertising profiles based on educational behavior;
- PostHog session replay on student learning surfaces;
- unattended feature promises or automatic follow-up messaging.

## 14. Open decisions before implementation

1. Voice/transcription/LLM provider and data-processing posture.
2. Exact interview eligibility/trigger after sufficient product experience.
3. Transcript and structured-summary retention periods.
4. Student-facing disclosure and any age/parental-consent requirements.
5. Existing-account notification channel permitted for feedback follow-up.
6. Exact Supabase schema after reconciliation with current tables.
7. Whether the current Microsoft Clarity inclusion is retained, constrained, or removed from student surfaces.
8. Final event dictionary after live call-site/outbox audit.

These decisions must be resolved through the appropriate Cramapple approval lane; privacy/student-data decisions are Hard Gates.