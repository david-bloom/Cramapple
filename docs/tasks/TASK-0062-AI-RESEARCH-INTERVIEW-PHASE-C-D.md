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


## Phase D review checkpoint — 2026-10-03

Product Owner approved the sequence: synchronize Phase C documentation, complete Phase D review/decision work, then proceed to Phase E only after the privacy hard gate is explicitly cleared.

### Evidence reviewed

- Canonical privacy policy is still **Draft for product and counsel review** (2026-06-22). It describes minors, feedback, improvement use, service providers, retention, and deletion choices at a general level, but does not specifically disclose AI research interviews, voice transcription, raw-audio handling, transcript/model vendors, or research-specific retention.
- Current Phase C harness remains isolated from real-user routes, microphone, models, persistence, and transcript analytics.
- Current Lovable project state has advanced beyond the Phase C implementation commit; no inference is made that the Phase C prototype is published merely because the project itself has a published Production surface.
- Existing canonical monitoring records say PostHog autocapture/session recording are disabled in the explicit wrapper and Microsoft Clarity is globally included; Clarity's effective student-surface recording behavior still requires verification.

### Phase D proposed decisions — NOT YET APPROVED

1. Pilot is opt-in and dismissible; no penalty or product-access consequence for declining.
2. Pilot eligibility: authenticated students who have completed at least one meaningful study session; do not interrupt checkout/purchase.
3. Research budget: two guided questions plus at most one discretionary adaptive probe; hard maximum three.
4. Typing is permitted. Voice, if enabled, must be explicitly initiated for each interview.
5. Preferred audio posture: transient processing only; do not retain raw audio after transcription.
6. Raw transcript retention: propose 30 days for pilot review, then delete or deidentify; structured research findings may be retained longer only after unnecessary identifiers are removed.
7. Raw transcript access: least privilege, limited to Product Owner/research reviewers needed for the pilot.
8. Do not solicit name, email, phone, school, teacher, health, or other unnecessary personal/sensitive information. Volunteered unnecessary identifiers should not be promoted into synthesis and should be eligible for deletion/redaction.
9. Follow-up opt-in means permission for one later in-app research question only; it is not marketing consent and is not a promise that a requested change will ship.
10. PostHog receives only coarse interview lifecycle metadata; no transcript/free text. Session replay/autocapture must not capture interview content.
11. Clarity must be verified disabled/excluded for the interview surface before pilot exposure, or removed from that surface.
12. Account deletion/data-subject handling must include raw research transcripts associated with the account, subject to any documented legal retention exception.
13. No real transcript is sent to a transcription or LLM vendor until the vendor/data-processing posture is selected and reviewed.
14. Because the privacy policy is draft and the product serves minors, legal sufficiency of notice/consent—especially for minors—remains an unresolved privacy/legal question. Product Owner approval alone does not establish legal sufficiency.

### Phase D blockers before approval

- Select/confirm transcription and LLM vendor(s) and document retention/training/data-processing behavior.
- Verify effective Clarity capture behavior on authenticated student surfaces.
- Confirm the exact student-facing disclosure/consent language and whether parental consent/age treatment requires counsel.
- Confirm retention/access/deletion matrix.
- Record the resulting privacy decision/approval.

**Current gate state:** Phase D review IN PROGRESS. Phase E real-student pilot remains blocked.
