# Paywall plan — analytics instrumentation contract and email copy (DRAFTS, 2026-11-08)

**Status:** DRAFT for review. **Nothing here is deployed or sent.** No PostHog schema change, no Loops send, no email of any kind.
**Authority:** `APPROVAL-0206` (Development/draft only). **Parent:** `PAYWALL_CHANGE_PLAN_2026_10_31.md` §5 (Analytics, Email).
**Depends on (not decided here):** the backend contract from the `paywall-backend` session (server-defined attempt start, saved-answer success, deadlines); plan §6 experiment (D6, open); plan §8 D7 nurture emails (open).

## Part A — Analytics contract

### A.1 Rules

1. The existing app wrapper (`src/lib/posthog.ts`) enforces a property **allow-list** and tags `environment`; events and properties below are **proposals** and each new property must be added to that list in a reviewed change. Nothing here changes Production PostHog.
2. Properties are coarse and never carry question text, answer text, image data, transcript text, student name, email address, school, or age. Event names are snake_case, matching existing events (`question_submitted`, `choice_selected`, `own_question_started`).
3. **No double-counting the first MCQ.** The first MCQ is counted once, when it is answered anonymously: `sample_first_mcq_answered`. Registration, saving and activation are **separate events about the same attempt**, never a second "question answered". Funnels count questions from `sample_first_mcq_answered` plus `sample_mcq_answered` where `sample_ordinal >= 2`. `sample_ordinal` is set by the **server** (1–8) and is the join key; a client retry of the same attempt id must emit no second event (`attempt_id_hash` dedupe, below).
4. **Acquisition survives identity change.** Anonymous visitor properties (`utm_*`, `reddit_click_id`, `creative_id`, `referral_code`, `landing_path`, `referrer_host`, `offer`) are captured on first touch. On registration the app calls PostHog `identify` with the account's stable id so the anonymous distinct id is **aliased/merged**, not replaced; the acquisition properties are re-sent once as `sample_registration_completed` properties and as person properties set-once (`$set_once`). The server also stores attribution at registration (backend contract) so Stripe/trial attribution does not depend on the browser. A QA check: a registered student's trial-start event must still carry the original `utm_campaign`.
5. Minors: no new identifier beyond the existing PostHog distinct id; the identify call uses the opaque account id, never email.
6. Server-side facts (saved, activated, expired, trial started) should be emitted by or reconciled with backend records; client events are intent/visibility signals. Where they disagree, the server record is the source of truth.

### A.2 Events

| Event | When | Allowed properties |
| --- | --- | --- |
| `try_landed` | `/try` renders | acquisition set, `subject_key`, `route` |
| `sample_unit_selected` | Subject+unit chosen before first MCQ | `subject_key`, `unit_number`, `unit_available_mcq_band` (`lt8`/`8plus`) |
| `sample_first_mcq_shown` | Anonymous question displayed | `subject_key`, `unit_number` |
| `sample_first_mcq_answered` | Anonymous answer submitted and feedback shown (counts the MCQ once) | `subject_key`, `unit_number`, `correct` (bool), `seconds_band` |
| `sample_register_prompted` | Registration sheet shown | `subject_key`, `unit_number` |
| `sample_registration_completed` | Sign-in/code succeeds | acquisition set (re-sent), `subject_key` |
| `sample_answer_saved` | Server confirms the first answer was saved to the account | `subject_key`, `unit_number`, `status` (`ok`/`retry`/`failed`) |
| `sample_activated` | Server confirms activation (registration **and** saved answer) | `subject_key`, `unit_number`, `mcq_remaining` (7), `frq_remaining` (1) |
| `sample_mcq_answered` | Questions 2–8 answered | `subject_key`, `unit_number`, `sample_ordinal` (2–8), `correct`, `seconds_band` |
| `sample_frq_source_chosen` | Cramapple or own question chosen | `frq_source` (`cramapple`/`upload`) |
| `sample_upload_classified` | BYOQ subject/unit/topic proposed and confirmed or corrected | `topic_changed` (bool), `edited_fields`, `status` |
| `sample_frq_photo_submitted` | Photo of student's answer uploaded | `status`, `page_count`, `latency_band` |
| `sample_frq_transcript_confirmed` | Student confirms/corrects the transcript | `edited` (bool) |
| `sample_frq_graded` | Grading result shown | `status`, `latency_band` (never the score text) |
| `sample_allowance_hit` | MCQ allowance reached, FRQ allowance reached or a locked feature opened | `allowance` (`mcq`/`frq`/`feature`), `feature` (coarse name) |
| `sample_expired` | New-question window ended (observed on the next visit, server timestamp) | `hours_active_band` |
| `sample_grace_completed` | An in-progress item finished inside completion grace | `item_type` (`mcq`/`frq`) |
| `sample_grace_ended_unfinished` | Grace ended with open work | `item_type` |
| `upgrade_sheet_shown` | One upgrade sheet shown | `trigger` (`allowance`/`locked_feature`/`expiry`/`direct`), `offer` |
| `parent_handoff_started` | Parent-payment link requested | `trigger`, `offer` |
| `card_trial_started` | Existing server-side trial-start (unchanged), now carrying `entry` | `entry` (`sample`/`direct`), acquisition set, `offer` |

New allow-list properties required: `unit_available_mcq_band`, `correct`, `sample_ordinal`, `mcq_remaining`, `frq_remaining`, `frq_source`, `allowance`, `feature`, `hours_active_band`, `item_type`, `trigger`, `entry`, `edited`. `unit_number`, `subject_key`, `offer`, `status`, `latency_band`, `page_count`, `edited_fields`, `topic_changed`, `seconds_band` already exist.

### A.3 Metrics these enable (diagnostics, not a decision on D6)

Anonymous start → first-answer → registration → saved → activated → 8th MCQ / FRQ graded → upgrade sheet → trial start → day-7 conversion; breakdown by `entry` and by unit band. Definitions of the primary metric, exposure counts, stopping rules and cohort maturity remain the open experiment decision (D6).

## Part B — Email drafts

**All copy below is a DRAFT. Do not paste into Loops, schedule or send.** Whether to send any of these (D7), when, and how they are classified is open. A service notice about a student's own access and an upgrade promotion may need different treatment; I have **not** labelled any message transactional. Preference and unsubscribe handling, suppression after trial start, and behavior during completion grace must be specified and reviewed first. The sample is **72 hours**; the card trial is a different thing, **seven days**; copy must keep them apart. Values in `{braces}` are filled from authoritative backend data; never hard-code the price or the deadline. If the student's offer differs (promotion, bundle, prior trial), the offer sentence must use the backend's offer context.

### B.1 Activation (sample started)
Subject: `Your 72 hours of AP {subject} practice have started`
> You answered a {subject} question and saved it. Your free sample is open until {sample_expires_at}.
> You have **7 more multiple-choice questions** and **1 graded free-response question** left in {unit}.
> For the free-response question, use one of ours. {if photo_answers_enabled}You can photograph your handwritten answer.{else}Type your answer.{/if} Your saved answers stay in your account.
> (Uploading your own question for grading is not in the first release, DECISION-0134 P6; do not promise it here.)
> This is a short free sample. It is not the seven-day card trial, which you can start separately at any time.
> [Keep practicing] — {app_link}

### B.2 Day-2 reminder (only if D7 adopts a nurture sequence)
Subject: `{hours_left} hours left in your free AP {subject} sample`
> Your free sample ends at {sample_expires_at}. You have {mcq_remaining} multiple-choice questions and {frq_remaining} graded free-response question left.
> If you start a question before then, you can finish it until {grace_ends_at}. That is a fixed 72 hours after the sample ends, not 72 hours from when you started the question.
> [Open your sample] — {app_link}

### B.3 Expiry (new free practice has ended)
Subject: `Your free AP {subject} sample has ended`
> Your 72-hour free sample ended at {sample_expired_at}. You cannot start new free questions, **but your saved answers and feedback stay in your account, and you can read them any time.**
> {if open_work} You have a question in progress. You can finish it until {grace_ends_at}; no new questions start after the sample ends. {/if}
> To keep practicing, you can start the seven-day card trial. {offer_sentence_from_backend}
> If a parent pays, you can send them a payment link. {parent_link_cta}
> [See your saved feedback] — {app_link}   [Continue with the seven-day trial] — {upgrade_link}

Do **not** say "your access has ended", "your account is closed" or "you can no longer log in"; none is true. Do not state a trial price unless it comes from the backend's offer context, since promotions, bundles and prior trials can change it.

### B.4 Review checklist before any send
- Each message is accurate for an active sample, expired sample, active grace and a student who already started the card trial (suppress or reword).
- Timezone shown with the deadline; deadlines are server timestamps.
- Sender, physical-address, unsubscribe and preference handling reviewed against the classification chosen for each message.
- Minor-appropriate tone; no urgency claim that is false (no "last chance" while grace is running).
