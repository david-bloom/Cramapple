# Paywall change plan — try first, then the 7-day card trial (2026-10-31)

**Status:** DRAFT for David's decisions (D1–D7 in §8). Nothing here is built or approved. **Owner:** David Bloom.
**Tier:** Hard-Gate (access control, payments adjacency, public pages, minors' data).
**Keeps:** the seven-day card trial exactly as decided in `DECISION-0126` / `SEVEN_DAY_CARD_TRIAL_PLAN_2026_10_18.md`
(card saved at start, one off-session charge on day 7, one trial per student email, cancel ends access). This plan moves
*where* that trial sits in the journey; it does not change its rules, price or mechanics.
**Related:** `handoffs/CONVERSION_REVIEW_HOME_AND_SUBJECT_LANDING_PAGES_2026_10_31.md` (the evidence),
`handoffs/LOVABLE_PROMPT_LANDING_PAGES_CONVERSION_2026_10_31.md` (landing fixes already sent),
`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` D18 (BYOQ is identity-agnostic) and O5 (Open Hand serving contract),
`DECISION-0089` / `DECISION-0117` (answer-key direct reads stay closed), `marketing/AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md`.

## 1. Problem

The current journey is ad → landing page → `/checkout` (email + card) → trial → product. The card wall is the first
thing a student meets after the landing page, before they have seen a single question. Week one of Reddit spend:
415 landing visitors, 5 reached checkout, 0 trials. Fixing the landing pages (sent to Lovable today) and the checkout's
first paint (Prompt A, not yet sent) will help, but neither changes the structure: the student is asked for a card
before the product has proved anything.

## 2. What the evidence supports (short version of the research note)

- A wall converts best when it sits at the point of demonstrated value, after usage has sorted who will pay
  (newspaper meters, Aral & Dhillon 2020). Teenagers are the most wall-sensitive segment (Chiou & Tucker 2013).
- Publishers put a registration wall before the paywall; registered-to-paid runs 0.5–12%, ~3% average (Piano).
- Card-at-start trials convert trial→paid roughly 2.5–3.5× better than no-card trials, from far fewer starts. The card
  trial is worth keeping; it just should not be the door.
- Free-acquired users have lower lifetime value and respond to usage, so activation, not sign-up, is the metric.

Applied: keep the card trial, put a bounded, real product sample in front of it, and ask for an email before the sample
so the lead survives even when the card does not come.

## 3. Target journey (v1)

```
Ad (UTM + promo) → landing page (sample question, proof, FAQ)
  → "Try it free, no card" → email code sign-in (registration wall; existing passwordless auth)
  → SAMPLE in the real app: pick subject + the unit you are in now; 8 MCQs with feedback + 1 FRQ graded + that unit's
    explainer; 72-hour window; one sample per email
  → meter hit (9th question / 2nd FRQ / hand-drawn upload / cheat sheet / another unit)
  → in-app sheet "Start your 7-day free trial" → existing /checkout?subjects=<key> with email prefilled
  → card trial (unchanged) → full access → day-7 charge (unchanged)
```

Why "the unit you are in now" and not Unit 1: it is late October. Students arriving from a "first unit was tough"
ad are in Unit 2–4. A Unit 1 sample would be irrelevant to them; the sample must land on the test they have next.

Why email before the sample, not after: the lead is the asset; the trial-start rate from a registered student with a
sample behind them is the number we need to learn, and the email makes a 3-message nurture possible for the ~90%
who will not start a trial on the spot.

## 4. The meter (what is free)

| Free in the sample | Behind the card trial |
| --- | --- |
| One subject, one unit of the student's choice | Every other unit and subject |
| 8 scored MCQs with distractor-specific feedback | Question 9 onward |
| 1 graded FRQ (typed) | 2nd FRQ, hand-drawn photo grading |
| The unit's explainer / reference pages, read-only | Cheat sheets, progress tracking, More help |
| 72 hours from first sign-in | — |

Items served in the sample come only from the Open Hand teaching designation (`app.open_hand_teaching_items`) and
published Practice items whose keys are already returned through the scoped functions; no direct table reads are
opened (keeps `DECISION-0089` / `DECISION-0117`). FRQ grading in the sample is capped at one per email and rate-limited
per IP like the trial endpoints (`SEVEN_DAY_CARD_TRIAL_PLAN` §6.3), because free grading attracts abuse and costs money.

## 5. What changes, by system

**Backend (Supabase, this repo)**
- New entitlement tier: `subject_entitlements.access_tier = 'sample'` (column exists), granted by a new function
  `grant_sample_access(subject_key, unit)` on first code sign-in from the sample path; `ends_at = now() + 72h`;
  one sample row per `user_id` ever (unique partial index), independent of trial eligibility (one trial per email stays).
- Serving: the session/question functions honour `sample` by restricting to the chosen unit and counting served scored
  items against the cap (8); the FRQ evaluate path refuses a second sample FRQ with a typed error the app can render.
- Checkout from inside the app: `/checkout?subjects=<key>&from=sample` with the signed-in email prefilled; nothing else
  in checkout changes. On trial start, the sample row is superseded by the trial rows as today's grant logic does.
- Attribution: the landing touch already stored by the marketing site must survive the sign-in hop
  (`ad_attribution` on the sample sign-in, then on `trial_start`), so the Reddit click id reaches the day-7 conversion.
- Flag: `SAMPLE_ACCESS_ENABLED` (default off in Production). Rollback = flag off; existing sample rows expire on their own.

**App (Lovable `56cae479`)**
- Sample state on the hub: subject + unit picker on first visit, a visible meter ("6 of 8 questions left in your free
  sample"), locked tiles with one consistent upgrade sheet, and the FRQ cap message.
- Upgrade sheet copy: "Your first 7 days are free. Nothing is charged today; $39.99 one-time on <date> unless you
  cancel." → button "Start my free trial" → checkout. One design, reused at every meter.

**Marketing (Lovable `61dd6602`)**
- Landing CTAs point to `/try?subjects=<key>` (new route: one email field, code sign-in, redirect into the app's sample
  picker) instead of `/checkout`. Keep a secondary "Already decided? Start your 7-day free trial" link to checkout for
  the student who wants to skip the sample.
- Prompt A (checkout first paint says $0 today, "Start my free trial" from the start) still ships; checkout is now the
  second door, and it must agree with the first.

**Email (Loops)**
- Three sample-nurture messages: day 0 ("your sample is open until …"), day 2 ("what you got right / the next point"),
  day 3 ("sample closed; start your free trial"). Each links to the in-app upgrade sheet. Transactional, not marketing.

**Analytics (PostHog)**
- New events: `sample_signup`, `sample_started` (subject, unit), `sample_question_answered`, `meter_hit` (which gate),
  `trial_prompt_shown`, and the existing `trial_card_started`. All carry the stored acquisition props.

## 6. Experiment

- **Split:** by landing URL variant on the same Reddit campaigns (`utm_content` names the arm): Arm A = landing →
  checkout (today's door, with Prompt A fixed); Arm B = landing → `/try` sample. 50/50 by ad, not by visitor, so Reddit
  reporting lines up with ours.
- **Primary metric:** trial starts per 100 ad clicks. **Secondary:** sample sign-ups per 100 clicks, meter-hit rate,
  trial starts per sample sign-up, cost per trial. **Guardrails:** day-7 conversion rate of Arm B trials versus Arm A,
  refunds and disputes, FRQ grading spend per sample.
- **Stop rules:** run two weeks or until 30 trials in total. Arm A's current rate is zero, so the first 10 trials in
  either arm already decide the direction; the two-week run is to learn the day-7 conversion of sample-born trials.

## 7. Risks and how they are held

| Risk | Hold |
| --- | --- |
| Answer-key leakage through the free layer | Sample serves through the same scoped functions as paid; Open Hand items are designed to be seen face-up; no new grants |
| Free FRQ grading abused or expensive | One FRQ per sample email, IP rate limit, flag to disable grading in sample only |
| Multiple emails per student | One sample per email, 72-hour window, device/IP soft cap; accept some leakage, it is still Unit-scoped |
| Minors' email collected earlier than today | Same data as checkout collects today, earlier in the journey; the under-16 / COPPA counsel item already open (`SECURITY_REVIEW_2026_10_15.md`) now covers this path too |
| Sample-born trials convert worse on day 7 | Measured as a guardrail; the trial's own rules (cancel, grace, recovery) are unchanged |
| Two doors drift apart | One copy source for the offer line, used by landing, `/try`, upgrade sheet and checkout |

## 8. Decisions for David

| ID | Decision | Recommendation |
| --- | --- | --- |
| D1 | Sample scope: the unit the student picks vs Unit 1 only | The unit they pick (relevance beats containment) |
| D2 | Meter size | 8 MCQs + 1 FRQ; tune after the first 100 samples |
| D3 | Registration wall before the sample vs after 3 free questions | Before; the lead is the point, and code sign-in is one field |
| D4 | FRQ grading inside the free sample | Yes, exactly one; it is the product's proof, and the cap bounds the cost |
| D5 | Sample window | 72 hours (a unit-test week, not a semester) |
| D6 | Experiment split | By ad (`utm_content`), 50/50, two weeks or 30 trials |
| D7 | Nurture emails for sample sign-ups who do not start a trial | Three transactional messages, Loops |

## 9. Phases and gates

| Phase | Work | Gate |
| --- | --- | --- |
| 0 (this week) | Landing fixes (sent), Prompt A checkout first paint, UTMs + promo on every ad URL, Clarity review of `/ap-stem-prep` | David publishes; no approval |
| 1 | Backend spec for `sample` tier (functions, caps, flag, attribution hop), Codex review, Development build + SQL tests | Design approval |
| 2 | App sample state + upgrade sheet; marketing `/try` route; Loops templates; PostHog events | Lovable commits reviewed by SHA |
| 3 | Production: migration + functions behind `SAMPLE_ACCESS_ENABLED=false`, then on for the test arm | `APPROVAL-xxxx` per step |
| 4 | Two-week split test; weekly read-out; decision to widen, tune the meter, or revert (flag off) | `DECISION-xxxx` |

## 10. Out of scope here

Pricing, bundles, the trial's rules and charge mechanics, a permanent freemium tier, and the referral program. If the
sample proves out, a standing free tier is a separate decision with its own economics.
