# Paywall change plan — try first, then the 7-day card trial (2026-10-31)

**Status:** Draft — revised 2026-11-08 with David's confirmed product choices in §8. Remaining choices and implementation
details are open. This revision records design decisions; it does not authorize implementation or release.
**Owner:** David Bloom.
**Tier:** Hard-Gate for implementation (access control, payments adjacency, public pages, minors' data).
**Revision branch:** `codex/paywall-frq-source-choice`. Original draft merged in PR #580; initial November 8 revision merged in PR #589.
**Keeps:** the seven-day card trial exactly as decided in `DECISION-0126` / `SEVEN_DAY_CARD_TRIAL_PLAN_2026_10_18.md`
(card saved at start, one off-session charge on day 7, one trial per student email, cancel ends access). This plan moves
*where* that trial sits in the journey; it does not change its rules, price or mechanics.
**Related:** `handoffs/CONVERSION_REVIEW_HOME_AND_SUBJECT_LANDING_PAGES_2026_10_31.md` (the evidence),
`handoffs/LOVABLE_PROMPT_LANDING_PAGES_CONVERSION_2026_10_31.md` (landing fixes),
`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` D18 (BYOQ is identity-agnostic) and O5 (Open Hand serving contract),
`DECISION-0089` / `DECISION-0117` (answer-key direct reads stay closed), `marketing/AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md`,
`qa/MCQ_ENTITLEMENT_BLOCK_2026_10_27.md` (access-denial handling).

## 1. Problem and evidence limits

The journey assessed on October 31 was ad → landing page → checkout (email + card) → trial → product.
Week one of Reddit spend produced 415 landing visitors, 5 checkout visits and 0 trials. These are historical
observations, not a fresh production check. The conversion review also found contradictory checkout pricing,
missing promotions and weak product demonstrations. The data supports testing a product sample, but does not
isolate the card requirement as the cause of low conversion. Verify which landing and checkout fixes have shipped
before defining the experiment's control.

## 2. Rationale

Keep the card trial and let students experience useful question feedback before asking them to register or provide
a card. David chose one complete anonymous MCQ experience, followed by registration to save that work and unlock
the remaining sample. This supersedes the original draft's email-before-any-sample recommendation.

The original draft cited newspaper meters (Aral & Dhillon 2020), teenage wall sensitivity (Chiou & Tucker 2013),
Piano registration-to-paid benchmarks, and card/no-card trial comparisons. Those cross-industry claims have not
been independently validated in this revision and are not forecasts for Cramapple. Measure activation and eventual
paid acquisition in this product; email capture alone is not proof that the change works.

## 3. Target journey (revised 2026-11-08)

```
Ad (UTM + promo) → landing page
  → "Try it free, no card" → choose subject + unit
  → answer 1 Cramapple MCQ and receive complete feedback, without registration
  → register to save that answer and feedback and continue
  → once registration succeeds AND the first answer is saved:
      activate the 72-hour sample; 7 MCQs + 1 graded FRQ remain
  → sample includes the selected unit's explainer/reference pages and photo submission of an FRQ answer
  → allowance hit / locked feature / sample expiry → existing 7-day card trial offer
      with direct checkout and parent-payment handoff
  → card trial (unchanged) → day-7 charge (unchanged)
```

The first MCQ counts toward the total of eight; registration does not grant eight additional MCQs.
Preserve subject/unit, the first answer and its feedback across registration. Do not start the timer merely because
a code sign-in succeeds if saving the first answer has not succeeded.

The student chooses the unit relevant to their current work, rather than being limited to Unit 1. Before rollout,
verify that every selectable unit can deliver the promised sample and reference material.

### Two different photo flows

- **Photo of an answer:** the student photographs their handwritten response to either a Cramapple-provided FRQ
  or a student-uploaded FRQ.
  The free FRQ must demonstrate this flow, including transcript review/correction and grading.
  Never ask the student to photograph a question Cramapple already provides.
- **Photo of a question (BYOQ):** when a student uploads their own question, try to identify its
  **subject, unit and topic**, and ask the student to confirm or correct that combination before proceeding.
  Do not silently treat inferred labels as confirmed or assume subject/unit are already known.

**Both question sources are allowed (David, 2026-11-08):** the student may choose a Cramapple-provided FRQ or upload
their own FRQ for the sample. Both use the same single graded-FRQ allowance; this is not one allowance per source.
Uploaded questions still require subject/unit/topic confirmation. Handling an uploaded question outside the selected
subject/unit remains open. This sample-source choice does not change the existing identity-agnostic BYOQ policy.

## 4. The meter and expiration

| Included | Behind the card trial |
| --- | --- |
| One subject and unit selected before the first MCQ | Other subjects/units after sample selection; switching rules remain open |
| 8 MCQs total with complete feedback: 1 before registration + 7 afterward | 9th MCQ onward |
| 1 graded FRQ from either Cramapple or a student upload, including a photo of the student's answer; one shared allowance | 2nd FRQ, regardless of question source |
| Selected unit's explainer/reference pages, read-only during the sample | Cheat sheets, progress-tracking features, More help |
| Saved answer feedback remains read-only after expiry | New questions after the sample deadline |
| Parent-payment handoff remains available after expiry | — |

**Timing (confirmed):**
- Activation requires both successful registration and successful saving of the first answer.
- The sample admits new questions for 72 hours from activation. Its purpose is urgency.
- An already-started question or photo FRQ may finish within a further **72-hour completion grace period** after
  sample expiry. This is not a new practice allowance. No new questions start during grace.
- Thus an eligible in-progress attempt can finish up to 144 hours after activation.
- After expiration, saved feedback remains readable; offer the card trial and parent-payment handoff.
- The sample clock and completion grace are separate from the unchanged seven-day card trial and its payment rules.

**Implementation details still to specify:** the authoritative definition of "started," parallel open attempts,
retry/reload behavior, and failed upload/extraction/grading treatment. Proposed requirements are to record starts
on the server, keep a fixed grace deadline, prevent refreshes from extending it, and avoid consuming another
allowance on a technical retry. These details are not additional owner decisions.

Published Practice items are the candidates for scored sample questions. Open Hand teaching items remain
**unscored**, with the existing scoring exclusions preserved. Do not relabel a face-up teaching item as a scored MCQ.
Keep direct answer-key table reads closed (`DECISION-0089` / `DECISION-0117`). The anonymous MCQ needs an explicitly
reviewed serving and feedback contract; existing paid-user checks cannot simply be bypassed.

## 5. What changes, by system

All implementation mechanisms below are proposed until the detailed design is reviewed.

**Backend**
- Design a bounded anonymous MCQ attempt and a secure, retry-safe handoff that saves it to the registering student.
  Saving and sample activation must not produce duplicate attempts, lost feedback or premature timers.
- The original draft proposed a `sample` entitlement tier and `grant_sample_access`. Validate this approach against
  current schema and access checks before implementation; sign-in alone must not activate access.
- Preserve independent MCQ and FRQ allowances: import the first MCQ as one of eight, leaving seven plus one FRQ.
  Define consumption, retries and concurrent requests explicitly.
- Enforce subject/unit restrictions, the sample deadline, the separate completion grace and read-only feedback access.
  Fix access-denial handling so expiry produces a usable upgrade/exit path, not a generic save error or blocked page.
- Support photo-answer extraction, student confirmation and grading within the one-FRQ sample.
  Specify extraction/retake cost limits as well as grading limits; an IP cap must account for shared school networks.
- Allow either a Cramapple-provided or student-uploaded FRQ within the same single graded-FRQ sample allowance.
  For uploaded questions, propose subject/unit/topic and require confirmation/correction. Out-of-unit handling
  remains open; do not change access to the existing BYOQ path outside this sample by implication.
- Preserve attribution and promotion through anonymous use, registration, trial start and eventual conversion.
- Keep sample eligibility separate from trial eligibility. Resolve the original "one per email" versus "one per user ID"
  inconsistency, including existing users, changed emails and prior trials, before specifying uniqueness constraints.
- Proposed `SAMPLE_ACCESS_ENABLED` defaults off. Specify separately whether disabling it stops new admissions or also
  stops existing attempts/grading. Preserve the promised feedback access. A flag alone is not a complete rollback spec.
- Specify sample-to-trial transition and cancellation precedence; the unchanged card-trial cancellation rule must
  not be bypassed by accidentally restoring sample practice access.

**App**
- Subject/unit picker before the first MCQ; complete answer feedback before registration.
- Registration prompt to save work and continue. After activation, show seven MCQs and one FRQ remaining.
- Let the student choose a Cramapple-provided FRQ or upload their own question. For uploads, confirm subject/unit/topic.
  Support photo-answer submission, transcript confirmation and grading with one shared FRQ allowance.
- Distinct sample-expiry, completion-grace and saved-feedback states; show the applicable deadline.
- One upgrade sheet and parent-payment handoff retaining the student, subject and applicable promotion.
  Offer wording and amounts must reflect authoritative eligibility/pricing; do not promise every student a
  $39.99 trial when a promotion, bundle or prior-trial rule changes the offer.
- Distinguish the 72-hour sample from the seven-day card trial in all copy.

**Marketing**
- Proposed `/try?subjects=<key>` begins with subject/unit selection and the anonymous MCQ, not an email wall.
  Registration follows the complete question-and-feedback experience.
- Keep a secondary direct-to-card-trial route.
- Verify the checkout first-paint fix and consistent offers before experiment launch. The October 31 report that
  prompts were sent is not evidence of current publication.

**Email**
- Original proposal: activation, day-2 and expiry messages through Loops. Schedule and approval remain open (D7).
- Draft expiry copy must explain that new free practice has ended, saved feedback remains, and eligible open work
  has its own completion deadline. Do not falsely say all access has closed.
- Suppression after trial start and behavior during grace must be specified.
- Do not classify every nurture message as transactional by assertion. Review the purpose/content and applicable
  preferences/unsubscribe handling before sending; upgrade promotion and service notices may differ.

**Analytics**
- Distinguish anonymous question start/completion, registration, successful answer saving/sample activation,
  photo submission/grading, allowance hits, expiry/grace completion, trial prompts, parent handoff and trial start.
- Preserve acquisition properties across identity changes without double-counting the first MCQ.
- Event names and allowed properties need a reviewed instrumentation contract; these are not deployed events.

## 6. Experiment — decision remains open

The original D6 proposal was a 50/50 split by Reddit ad, two weeks or 30 trials, using trial starts per 100 clicks
as the primary metric. David has not adopted that experiment design.

Review concerns and proposed revisions:
- Ad-level splitting may mix journey effects with creative, audience and delivery differences. Consider persistent
  visitor assignment after arrival from the same ads; retain ad attribution separately.
- Verify a functioning, consistently priced control. Historical zero trials does not establish a fixed zero baseline.
- Measure anonymous activation, registration completion and sample-to-trial conversion as diagnostic steps.
  Evaluate paid acquisition and net revenue/cost alongside trial starts, refunds and grading/extraction spend.
- Remove the original assertion that the first ten trials decide the direction. Define exposure counts,
  uncertainty, duration and stop rules before starting.
- Allow final cohorts to mature through sample use, any completion grace, the later trial start and its seven-day
  conversion window. A two-week enrollment period is not automatically a complete paid-conversion readout.

## 7. Risks and outstanding design checks

| Risk | Required design check |
| --- | --- |
| Anonymous retries become unlimited sampling | Decide anonymous allowance and switching policy; preserve a low-friction first experience |
| Question/answer leakage | Scoped serving/feedback contracts; no direct key-table grants; Open Hand remains unscored |
| Free photo extraction or grading abuse | One sample FRQ plus explicit retry, extraction and spending limits |
| Deadline ambiguity | Fixed activation/expiry/grace timestamps; server-defined attempt start; no new starts after expiry |
| Lost progress at registration | Preserve first answer/feedback, retry safely, activate only once both prerequisites succeed |
| Expiry strands students | Usable typed access-denial handling, read-only feedback and parent-payment handoff |
| Earlier collection of minors' data | Review the new path explicitly against the existing privacy/counsel work; prior checkout collection is not sufficient evidence |
| Different offers across doors | Shared authoritative offer context, including promotions and eligibility |
| Sparse or unsuitable unit content | Check complete sample availability for every selectable unit before release |
| Sample/trial overlap | Explicit transition and cancellation precedence that preserves existing trial rules |

## 8. Decision record

**Source:** David's explicit choices in the paywall-assessment chat on 2026-11-08, followed by "update the plan,"
and his subsequent confirmation: "both a Cramapple-provided question or a student-uploaded question are allowed."
These are product choices recorded durably here, not authorization to implement, migrate, publish or send email.
The original D1–D7 identifiers below are local to this plan, not new global `DECISION-xxxx` IDs.

| ID | Topic | State / outcome |
| --- | --- | --- |
| D1 | Subject/unit | **Confirmed:** student chooses subject and unit before answering the first MCQ |
| D2 | MCQ allowance | **Confirmed:** eight total; the anonymous first MCQ counts, leaving seven after registration |
| D3 | Registration | **Confirmed:** one complete MCQ-and-feedback experience first; registration then saves work and unlocks the remainder |
| D4 | Free FRQ | **Confirmed:** choose either a Cramapple-provided question or a student-uploaded question; both share the sample's single graded-FRQ allowance and support photo submission of the student's answer |
| D5 | Sample clock | **Confirmed:** 72 hours to create urgency, beginning when registration succeeds and the first answer is saved |
| D6 | Experiment | **Open:** allocation, metrics and stopping criteria; review concerns in §6 |
| D7 | Nurture emails | **Open:** whether to send, schedule, content, classification and preference handling |
| D8 | Expired sample | **Confirmed:** retain read-only feedback and offer parent-payment handoff |
| D9 | Uploaded question classification | **Confirmed:** try to infer subject/unit/topic and ask the student to confirm/correct; this is distinct from uploading an answer |
| D10 | Completion grace | **Confirmed:** already-started questions/photo FRQs may finish within a further 72 hours after sample expiry; no new questions during grace |

Still open: anonymous repeat/switching allowance; precise attempt-start/consumption/retry rules;
out-of-unit uploads; identity/eligibility rules; trial-transition precedence; and
rollback behavior. Assistant recommendations in §§4–7 are proposed details, not confirmed owner choices.

## 9. Phases and gates

| Phase | Work | Gate |
| --- | --- | --- |
| 0 | Verify landing/checkout fixes, offer consistency, attribution and current mobile journey | Existing publication approvals still apply |
| 1 | Resolve open product rules; specify anonymous handoff, access, photo grading, clocks, caps and rollback | Detailed design approval before build |
| 2 | Development backend and app/marketing changes; instrumentation; email drafts if adopted | Reviewed source and QA; no implied Production authority |
| 3 | Production changes behind disabled flag, then activation for the approved test population | Explicit release approvals per step |
| 4 | Approved experiment and cohort-mature readout; widen, tune or revert | Separate owner decision |

### Revision handoff (2026-11-08)

Documentation-only revision: updated this plan and its `docs/INDEX.md` entry, including David's follow-up confirmation
that either FRQ question source is allowed within one shared allowance. No code, schema, entitlement,
payment, email or deployment changes. Current live behavior has not been reverified in this revision.
**Next owner:** David, with the reviewing agent. **Next action:** resolve the open rules in §8 and the experiment
in §6 before preparing an implementation specification. Preserve the existing trial rules and BYOQ policy;
do not treat this document update as execution approval.

## 10. Out of scope here

Pricing, bundles, changes to the card trial's rules or charge mechanics, a permanent freemium tier, and the referral
program. Both FRQ question sources are included in the sample; handling uploads outside the selected subject/unit
remains undecided.
If the sample proves out, a standing free tier is a separate decision with its own economics.
