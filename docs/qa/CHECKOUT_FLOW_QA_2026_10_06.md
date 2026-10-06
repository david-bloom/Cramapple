# Checkout Flow QA: Reliability, Clarity and Friction

STATUS: CURRENT - joint review complete; remediation and full end-to-end certification outstanding
DATE: 2026-10-06
OWNER: Codex (conductor); Astra (strategy/code review); Sol (browser QA)
BRANCH: codex/checkout-qa-friction
RELATED TASKS: TASK-0060, TASK-0058
BASE: main 510173aa445006f063a8c99922bba11379c97b65

Publication base: main 5a48e6f2e8d5de42eb157c27ec0c310dd4b61424 after PR #341 merged.
Review snapshots below remain pinned to the source actually inspected.

## Goal and scope

David approved joint Astra/Sol QA and clarified: "they should look for suboptimal
experience as well as bugs. The goal is checkout with as few steps and in as
obvious a way as possible."

Review the entire route from an incoming subject link to the student's study
hub, including direct purchase, parent payment, account verification and return
visits. Findings must distinguish bugs from UX friction and retain an evidence
label: observed live, code-reviewed, inferred or untested.

Execution uses read-only service inspection and browser checks without paying,
sending emails or creating student accounts. Bounded synthetic unpaid sessions
are permitted where required for browser states. No Production configuration,
deployments or payment changes are part of this QA.

## Sources and reviewers

- TASK-0060 checkout evidence and 2026-10-04 session handoff.
- TASK-0058 post-pilot checkout backlog and payment funnel technical spec.
- Current Lovable marketing/app sources, distinguished from published UI.
- Production Supabase function inventory and aggregate database inspection.
- Loops migration draft PR #341, explicitly distinguished from Production.
- Astra review: CHECKOUT_ASTRA_REVIEW_2026_10_06.md.
- Sol browser report: CHECKOUT_SOL_BROWSER_QA_2026_10_06.md.
- Morning checklist: ../handoffs/MORNING_CHECKOUT_AND_EMAIL_ACTIONS_2026_10_06.md.

## Operational evidence verified by the conductor

Read-only Production snapshot on 2026-10-06; queries use a rolling preceding
48-hour window. Counts are not conversion rates: abandoned QA sessions and
session recreation can inflate the unpaid-session denominator.

| Check | Result | What this establishes |
| --- | --- | --- |
| Paid sessions | 5 (4 student_direct, 1 parent_share) | Both payment paths have recent settlement evidence |
| Paid sessions with no student user ID | 0 | Recipient identity resolved for these sessions |
| Paid sessions with no active entitlement | 0 | Access grant persisted for these sessions |
| Non-unlimited expected subject-count mismatches | 0 | Subject grant counts match these checkout records |
| Completed webhook events | 5, all processed, maximum one attempt | Recent completion processing succeeded |
| Expired webhook events | 36, all processed, maximum one attempt | Recent expiry processing succeeded |
| Unprocessed/error webhook records in window | 0 | No recorded processing failure in this bounded sample |
| Parent payment emails | 1 recorded sent | Provider acceptance, not inbox delivery or readability |
| Recent parent short links | 1 | Short-link creation is recorded |
| Paid students with unconfirmed email | 2 of 5 | Verification follow-up needed; cause not established |
| New Loops payment queue installed in Production | No | PR #341's payment notification queue is not live |

The paid records do not establish successful sign-in, inbox delivery, purchase
UI clarity, distinct parent/student devices, wallets, or hub behavior. The two
unconfirmed accounts may include deliberate test addresses; no cause is inferred.
No emails, names, payment details, or live payment links are retained in this report.

### Production function inventory

| Function | Version | Status |
| --- | --- | --- |
| create-checkout-session | 26 | ACTIVE |
| stripe-webhook | 26 | ACTIVE |
| get-checkout-status | 5 | ACTIVE |
| send-parent-payment-email | 6 | ACTIVE |
| create-parent-payment-link | 3 | ACTIVE |
| resolve-parent-link | 1 | ACTIVE |

All report verify_jwt=false; gateway settings alone do not demonstrate insecure
access. Signature, session and identity checks must be reviewed in function code.

### Automated checks

33 focused backend tests passed (0 failed): checkout-access (10), webhook-ledger
(3), addon-checkout (4), parent-short-link (10), stripe-catalog (6). These exercise
settlement/refund decisions, retries, parent-payer ownership and short-link guards.
They do not replace browser/payment/inbox end-to-end tests.

## Shortest practical flows to evaluate

| Buyer | Target flow | Avoidable detours to look for |
| --- | --- | --- |
| Signed-in student, preselected subject | Confirm total -> pay -> hub | Re-entering email, repeated subject selection, extra start/continue screens |
| New student, preselected subject | Email -> pay -> enter already-sent code -> hub | Separate signup page, duplicate auth email request, postpurchase upsell |
| Student asking parent | Email/subject -> share clear payment link -> wait or leave -> unlocked access | Required parent account, extra setup, unclear wait state, second login email after invite |
| Parent paying | Open link -> see student first name/subjects/total -> pay -> confirmation | Student login prompts, misleading study CTA, parent account creation |
| Returning after parent payment | Access notification -> sign in only if necessary -> hub | Dead/expired one-time link, full checkout repeated, wrong device/account |

Count user decisions, form entries, taps and screen transitions separately.
Wallet authorization, identity proof and entitlement settlement are different
requirements; removing a UI step must not substitute payer identity for student
identity or treat a typed email/payment alone as proof of account ownership.

## Required test matrix

| Scenario | Evidence needed before a full pass |
| --- | --- |
| Incoming /signup and subject links | Redirect preserves intended subject(s) and promo |
| No subject / no email | Clear next action and disabled-state explanation |
| One, two and three subjects / fourth pick | Correct totals; visible selection limit feedback |
| Invalid or edited email | Validation understandable; payment can't use a stale identity |
| Promo prefilled / manually entered / removed / invalid | Correct actual total; no accidental undiscounted charge |
| Wallet ready / loading / unavailable | Stable layout and obvious card fallback |
| Card reveal / incomplete card / decline / 3DS | Clear progress and recoverable errors; no duplicate charge |
| New student payment | One intended verification request; existing code accepted; correct hub |
| Confirmed student login | Code arrives and works; immediate resend shows cooldown |
| Unconfirmed student's resend | Correct signup code email, not a dead callback link |
| Signed-in repeat purchase | Email/account retained; bypass unnecessary code step |
| Parent modal / copy / share / email | Correct discounted amount, safe short link and useful confirmation |
| Parent pays on another device | Parent is payer only; correct student receives access |
| Student stays on waiting page | Settlement updates in place; sign-in uses existing invite code |
| Student leaves / returns after parent pays | Durable access notification and obvious study route |
| Parent short link malformed / expired / already paid | Accurate states and recovery CTA |
| Slow, delayed, duplicated or failed webhook | Access and notification don't duplicate or disappear |
| Refund / partial refund | Access behavior and notifications match policy |
| Mobile / keyboard / Chrome / Safari / Firefox | Visible totals, readable forms, focus, no overlapping sticky UI |
| App-domain session handoff / hub banner | Correct authenticated hub; banner dismiss persists |
| Loops cutover | All enabled auth actions mapped; delivery failures recoverable; no overlapping legacy send |

## Findings and final verdict

### Confirmed browser friction

| ID | Priority / type | Reproduction and consequence | Recommended change |
| --- | --- | --- | --- |
| UX-01 | P2 / friction / observed | Open checkout with subject=biology. All ten tiles remain expanded although Biology is selected. Email starts at document Y=594 at 1280x720 and Y=856 at 375x812; its input is outside the initial viewport. A disabled sticky action does not lead to it. | Collapse the completed subject step to a selected-subject summary with Change, and put email immediately next. |
| UX-02 | P2 / misleading state / observed | Open the Biology link with promo=FRIENDSSPECIAL. Before email entry, both totals show $39.99 and Apply requests subjects/email, while payment requests applying/clearing the promo. After synthetic email entry, it auto-applies and totals become $1.00. | Represent a URL promo as pending; make email the explicit next step and auto-apply when eligible. Do not present Apply as ready before prerequisites. |
| UX-03 | P2 / state recovery / observed | Create an unpaid parent link at $1.00; close and reopen the parent modal. It resets to Create payment link rather than showing the existing share state. | Preserve active link/waiting state and offer New link only when requested or required. Source review will determine whether page-level state provides another recovery path. |
| UX-04 | P3 / unclear loading state / observed | No-email checkout shows an empty grey Express Checkout slot; card/parent controls say Add your email. | Keep the reserved height but explain inside it that email unlocks payment options. |
| UX-05 | P3 / possible extra entry / observed + conditional | Plain /welcome asks for email before showing the code field despite its code-entry headline. | Keep email-first on a new device; reuse safely held email on the checkout return tab. This is not yet evidence that the direct return page itself re-asks email. |

These findings come from Sol's Chromium desktop/mobile pass. The report does not
claim actual wallet behavior or screenshot-file evidence: screenshots were
inspected in the browser but could not be exported from that CUA surface.

### Authentication follow-up from operational logs

The preceding 24-hour Production auth logs include four /otp responses with
HTTP 422 and otp_disabled. All four logged the category "Signups not allowed for
otp". One invite and one verify request returned 200; six token requests returned
200. This is a signal to test unknown-email recovery and current sign-in handling,
not proof that OTP is globally disabled or that those failures affected paid users.
Inspect enabled Auth settings and reproduce with controlled confirmed/unconfirmed
accounts before assigning a causal bug. Supabase's code reference is at
https://supabase.com/docs/guides/auth/debugging/error-codes.

Payment function request aggregates in that same 24-hour window show 14 successful
checkout-creation responses and two 400s; 36 checkout-status 200s; two parent-link
creation 200s; one parent-link-resolution 200 and one 404; two parent-email 200s;
and 31 webhook 200s. These HTTP counts are not unique users, purchases or inbox
deliveries. They differ from the 48-hour ledger counts because windows and event
types differ. No raw URLs, recipients or log messages are included.

### Integrated implementation findings

Full source/line references, consequences and 30 designed risk cases are in
[Astra's review](CHECKOUT_ASTRA_REVIEW_2026_10_06.md). These are source-reviewed
risks unless explicitly labeled observed; no exploit or customer failure rate
was demonstrated. Sol's browser findings overlap F6/F12/F15, not additional bugs.

| ID | Priority | Finding and disposition |
| --- | --- | --- |
| F1 | P1 | Dormant add-on endpoint reuses a paid session's Stripe customer without authenticated learner ownership. Retire the no-longer-used route/API or verify the owner before customer reuse; test anonymous and wrong-account rejection. |
| F2 | P1 | Existing signed-out buyers are promised an emailed code although checkout sends none, then encounter a resend cooldown. Orchestrate the first send and reflect its actual state. |
| F3 | P1 | Parent waiting screen still requests another OTP after payment and can hide code entry on 429; invite verification is inconsistent with the shared helper. Reuse the original code, render entry immediately and share verification logic. |
| F4 | P1 | Repeat same-source subject purchases overwrite entitlement order provenance. Earlier order status and subsequent refunds can become incorrect. Preserve grant provenance and test overlapping orders/refunds. |
| F5 | P2 | Sticky parent action bypasses the unapplied-promo guard. Apply the same readiness guard to every payment path; reproduce with a typed unapplied code. |
| F6 | P2 | Parent request state disappears when closing the drawer (observed); expiry/cancel recovery also loses or resends invalid context (source). Preserve one active request and renew explicitly. |
| F7 | P2 | Status polling stops after roughly 27 seconds while promising automatic updates. Resume recovery or explicitly expose paused checking. |
| F8 | P2 | Parent link says access unlocked from Stripe completion alone. Distinguish settlement, grants pending, ready and refunded states. |
| F9 | P2 | Resolver/provider failures masquerade as expired links. Separate transient failure from verified expiry and permit retry. |
| F10 | P2 | Return page trusts any current auth session and a tab-global email without matching purchase identity. Bind recovery to the order and show the intended student email. |
| F11 | P2 | Slow Stripe initialization can permanently remove wallets and temporarily hide alternatives. Keep a recoverable wallet state and visible card/parent fallback. |
| F12 | P2 | Expanded preselected picker and disabled primary action obscure the next step (observed). Compact the completed subject step; put email and the actual next action in view. |
| F13 | P2 | Loops originally queued before anonymous ownership backfill; fixed in follow-up PR #342 source. Separate invite plus confirmation still violates the desired first-code/one-email contract, and existing-account first send remains unresolved. |
| F14 | P2 | Parent-email throttle is per session and non-atomic. Use atomic actor/recipient controls and stub-provider concurrency tests; no abuse sends performed. |
| F15 | P2 | Incoming promo shows full price and contradictory readiness (observed). Show a truthful pending state and apply as soon as prerequisites are valid. |

### Conductor disposition and release gates

PR #341 merged at 09:01:24 UTC during QA; it is no longer a draft. This does not
attest any new Production deployment. Development-only deployment evidence above
remains the latest checked runtime evidence. Historical reviewer references to
"pending PR341" describe their inspection snapshot.

[PR #342](https://github.com/david-bloom/Cramapple/pull/342) fixes notification
ordering at commit 10aaa4359f5d0293582dac47fe2f724a96e1652f. Twenty focused
email/payment tests and webhook type-check passed. Queue-failure injection (T26)
has not run, and this fix is not a claim of Production remediation. The one-email
contract is a separate release blocker, not fixed by moving the queue call.

Engineering priorities:

1. Resolve F1/F4 safety and accounting risks alongside F2/F3 first-code recovery.
2. Ship the observed picker/promo/parent-state improvements in the same cycle;
   reducing friction is a first-class acceptance criterion, not optional polish.
3. Run Development fixtures T01-T11 for ownership, auth, duplicate settlement and
   refunds, then T26-T28 for notification failures, template semantics and throttles.
4. Run controlled inbox and test-payment direct/parent flows, including existing,
   unconfirmed and signed-in buyers, cross-device return, decline and 3DS.
5. Verify current published frontend revisions, real wallet browsers, keyboard
   focus, code paste and authenticated hub/banner behavior before release.

Acceptance: a preselected subject remains selected; email, payable total and next
action are obvious without exploring the page; parent links survive reopening;
signed-in buyers go straight to study; signed-out buyers enter the intended first
code without an unnecessary second send; recovery never asks for repayment.

**Verdict:** review complete, checkout not yet certified end to end. The 33 backend
tests passed and bounded browser states worked, but the 30 risk cases are a design
matrix, not 30 executed passes. No real payment, inbox/code verification or signed-in
hub run was performed. Production was not changed by this QA.
