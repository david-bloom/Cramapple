# TASK-0062 — AI Research Interview: Phase C → Phase D

STATUS: IN PROGRESS — PHASE C HARNESS UPDATED; PHASE D PRIVACY REVIEW OPEN

**Owner:** Main Conductor / ChatGPT  
**Product Owner:** David Bloom  
**Branch:** `chatgpt/ux-monitoring-user-research-v1`  
**Environment:** Development only  
**Production:** HARD GATE

## Product-owner decision — 2026-10-03

Interview research budget is now:

1. Guided Q1: “What were you trying to get done with Cramapple today?”
2. Guided Q2: “What worked well, and what got in your way?”
3. At most one discretionary adaptive probe, only when it materially improves evidence.

Hard maximum: **3 research questions**. The interview may end after Q2. There is no mandatory “one thing better” question. Duration is observational telemetry only and must never cause padding or prolongation.

## Phase C implementation checkpoint

Lovable Development commit: `886c81510705ab45f72315702832a144df524161`.

The isolated synthetic-only prototype now enforces the three-question rule. It remains disconnected from ordinary student navigation, models, microphone, transcript storage, and analytics.

Verification reported:
- 49 research-interview tests passing;
- 503 full-suite tests passing;
- typecheck clean;
- no publish/deploy.

## Phase D — privacy approval work

Phase D is a **decision/review phase**, not permission to expose the interview to students.

The following must be resolved and durably approved before any real-student pilot:

1. **Participant disclosure** — concise language explaining that this is optional product research and that responses are recorded/transcribed for product improvement.
2. **Minor / parental-consent treatment** — determine applicable requirements for Cramapple's teen population and pilot design; do not infer legal sufficiency from product preference.
3. **Voice/audio handling** — preferred posture is transient audio only, discard raw audio after transcription; verify vendor/runtime behavior.
4. **Transcript/model vendor** — identify transcription and LLM vendors and their retention/training/data-processing controls before sending real transcript data.
5. **Transcript retention** — choose a bounded retention period for raw transcripts and separately for structured research findings.
6. **Access control** — define who can read raw transcripts and summaries; default to least privilege.
7. **Volunteered personal/sensitive data** — do not solicit it; define minimization/redaction/deletion behavior when volunteered.
8. **Follow-up permission** — treat opt-in as permission for a later in-app research question, not permission for marketing and not a promise of a fix.
9. **Notification channel** — use only an already-authorized Cramapple account/in-app channel unless a separate communications consent decision authorizes otherwise.
10. **Deletion/access requests** — define how research transcripts/findings participate in account deletion and applicable data-subject handling.
11. **Analytics/replay boundary** — PostHog may receive only coarse interview start/completion metadata; transcript/free text must not enter PostHog. Confirm replay/autocapture/Clarity cannot capture interview content.
12. **Pilot eligibility/trigger** — define when a student has enough product experience to be invited without coercive or excessive prompting.

## Phase D evidence required

Before Product Owner approval, produce:
- current privacy-policy and consent-flow gap analysis;
- current Clarity/PostHog recording configuration audit for the student surface;
- candidate transcription/LLM data-flow diagram and vendor data-handling comparison;
- proposed retention/access/deletion matrix;
- proposed student disclosure and opt-in copy;
- explicit list of unresolved legal/privacy questions requiring counsel or Product Owner judgment.

## Gate

No real-student interview, microphone capture, transcript persistence, research-table migration, transcript-bearing model call, notification, or Production publication occurs under this task until the Phase D privacy decision is explicitly approved and recorded.
