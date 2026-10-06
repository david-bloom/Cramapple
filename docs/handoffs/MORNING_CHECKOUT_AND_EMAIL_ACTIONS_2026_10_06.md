# Morning Reference: Checkout and Transactional Email

STATUS: CURRENT - David's checklist steps 1-3 complete; integration, fixes and end-to-end checks outstanding
DATE: 2026-10-06
OWNER: David Bloom
BRANCH: codex/checkout-qa-friction
RELATED: TASK-0060, TASK-0058, merged Loops PR #341, ordering follow-up PR #342

## Start here

The goal is the fewest practical checkout steps with an obvious next action at
every point. Joint QA covers both functional bugs and avoidable friction.
Astra reviews the flow and implementation; Sol checks the live browser; Codex
checks production evidence and integrates the findings.

**Progress update, 2026-10-06:** David confirmed checklist steps 1-3 complete:
email designs provided, QA recommendations reviewed, and controlled parent/student
inboxes supplied. Ten numbered HTML designs are preserved and adapted for Loops
in [PR #344](https://github.com/david-bloom/Cramapple/pull/344).
Design delivery is complete; publishing/binding templates and real-inbox tests
are separate implementation steps, not completed by this confirmation.

Implementation and rollout plan:
https://github.com/david-bloom/Cramapple/pull/341

Detailed QA report: [Checkout QA](../qa/CHECKOUT_FLOW_QA_2026_10_06.md).

## Highest-priority engineering fixes

- Existing signed-out buyers are told to read a code checkout never sent.
- Parent-pay completion still requests another code instead of accepting the
  original invite code, with a cooldown/error-state trap.
- The dormant add-on payment endpoint needs retirement or authenticated ownership
  checks before reusing the saved Stripe customer.
- Repeat purchases need order-specific entitlement accounting so refunds cannot
  invalidate access paid for by an earlier order.

These are source-reviewed findings, not newly demonstrated charges or exploits.
Codex owns remediation; you do not need to debug them. Keep the observed UX fixes
below in the same build, with the fewest clear steps as the acceptance criterion.

Product decision to settle before email cutover: how purchase confirmation and
the first verification code form one coherent experience. The current Loops
foundation would send a separate invite and confirmation for a new buyer; it
does not yet fulfill the desired one-email contract. Never promise a code in a
receipt that does not actually contain one.

## First UX findings to review

- Compact the subject step when an incoming link already selected a subject;
  email is currently below the first screen on desktop and mobile.
- Clarify pending promo state: the pilot link initially shows $39.99 until email
  entry makes the $1 code auto-apply. Current instructions disagree about what to do next.
- Preserve the parent link/share state when the modal is closed and reopened.
- Explain the blank wallet placeholder while email is still missing.
- Keep /welcome's email-first fallback for a new device, but reuse checkout email
  on the return tab where possible.

These are fresh browser findings; the final report distinguishes them from
source-reviewed defects and tests still needing real payment or inbox evidence.

## Your checklist

| Priority | Status | Action | Owner | Completion evidence |
| --- | --- | --- | --- | --- |
| 1 | Complete | Provide transactional email designs | David | Ten numbered HTML designs received; originals and validated MJML adaptations in PR #344 |
| 2 | Complete | Review the QA's recommended checkout changes, including friction findings | David | David explicitly confirmed step 2 complete on 2026-10-06; this is review completion, not a QA pass or resolution of every open product decision |
| 3 | Complete | Supply controlled student and parent inboxes for real-inbox testing | David | Two parent and two student addresses supplied privately, including intended existing/new student cases; no account reset or test-send result implied |
| 4 | Pending | Confirm current Supabase auth emails show a six-digit code while migration remains pending | David + implementation | Invite, signup confirmation and login code work through the current sender |
| 5 | Pending | Verify the login fix and hub welcome banner are actually published and work after login | David + implementation | Successful signed-in hub load, banner dismiss persists on reload |
| 6 | Pending | Complete the final end-to-end purchase and parent-pay tests after fixes | David + QA | Correct amount, one intended verification request, access granted, clear next step |

## Email designs received

The table below retains the original six core purposes. The supplied ten designs
also cover payer receipts, subjects added, parent reminders, payment-link expiry
and refunds. See [the import readiness checklist](https://github.com/david-bloom/Cramapple/blob/codex/loops-email-designs/docs/email/transactional/README.md)
for exact files, variables and unresolved trigger/data contracts. Loops upload
remains blocked by Chrome extension local-file access; the real footer mailing
address is also needed. These do not reopen completed design-delivery step 1.

| Design | Recipient / purpose | Essential content |
| --- | --- | --- |
| Verify email | Student with an unconfirmed account | Six-digit code and plain /welcome link |
| New-student invite | Student whose account is created after purchase | Six-digit code and plain /welcome link |
| Sign-in code | Existing student requesting login | Six-digit code and plain /welcome link |
| Parent payment request | Parent asked to pay | Student first name, subjects, actual discounted price, short payment link, expiration |
| Parent payment completed | Student after parent payment | Subjects unlocked and a clear study CTA |
| Purchase confirmation | Student after direct purchase or subjects added | Purchased subjects, actual amount and study CTA |

The first three can share one visual design. Separate Loops template IDs map to
Supabase's different auth actions; the student should not have to understand them.
Keep code emails short. A purchase confirmation must not imply that payment alone
signs the student in.

One-provider delivery is the agreed destination. Designs for payer receipts,
refunds and parent reminders/expiration have now been supplied; their trigger
and coverage decisions remain outstanding. Any enabled account-security notices
also need explicit coverage. Stripe receipts remain active until
the replacement receipt path has been tested, so the migration is not yet complete.

## Implementation work queued for Codex

2026-10-06 delegation: David cannot run checklist steps 4-6 now and authorized
Codex to proceed with implementation. Those manual acceptance checks are deferred,
not passed, and do not block code work. No permission to skip release gates is inferred.

Implemented in [PR #344](https://github.com/david-bloom/Cramapple/pull/344), source
checkpoint `9ae755de900a241c04462f334792eb0e90e90a60`:

- Six core Loops template-variable contracts, formatted discounted USD prices,
  explicit parent-link expiry, safe text/links and correct student recipient.
- Auth templates no longer promise paid access from editable metadata; direct
  confirmation omits unverified access-end dates and separate-receipt promises.
- Verified authentication and order-owner checks before add-on customer reuse;
  mocked handler rejects missing/invalid tokens and wrong account without Stripe calls.
- Notification ownership backfill precedes independent queue work (PR #342 correction).
- 49 backend tests passed; five function entrypoints type-check; ten MJML files validate.

No new Production deployment, template publish, email or payment occurred.
Loops upload access, actual footer mailing address, template ID binding and inbox
QA remain pending. Existing-account first-code orchestration, invite/confirmation
overlap and repeat-purchase entitlement provenance are still release blockers.
Preview-only frontend friction changes are implemented and source-reviewed in
the marketing Lovable project, checkpoint
`8f17fe707140d06b3f2802431bdd27c9c9709713`. They include compact preselected
subjects, shared promo/parent guards, retained parent links, wallet timing,
original-code entry, bounded polling and stale-session recovery protections.
Lovable reports 85 frontend tests passed and a clean type-check. Codex checked
the compact picker, email visibility, promo prerequisites and layout in Chrome
at 390x844 and 1440x900; real auth/payment result paths remain deferred.
See [the implementation checkpoint](../qa/CHECKOUT_IMPLEMENTATION_VERIFICATION_2026_10_06.md)
for exact evidence boundaries and the private preview link. This is not published
to Production and does not resolve every release blocker in the joint audit.

- Build/publish your Loops designs and bind Development template IDs.
- Configure the signed Auth hook and worker secrets; keep codes out of the queue.
- Check enabled Auth actions and add mappings for every enabled email type before cutover.
- Deploy the changed parent-email and payment-webhook functions in Development.
- Enable the payment queue and a protected retry schedule in Development.
- Test real inbox delivery, rate limits, retries, duplicate webhooks and parent/student identity.
- Resolve the QA's release blockers and then perform the reviewed Production cutover.
- Disable overlapping old Loops workflows so one action does not send duplicate mail.

## What is already established

- Loops migration PR #341 merged during QA at 09:01:24 UTC. Merge is not deployment evidence.
- QA found and fixed notification queue ordering in source: persist student
  identity before independent email work. Follow-up draft [PR #342](https://github.com/david-bloom/Cramapple/pull/342)
  is pushed and tested; failure-injection QA and deployment remain pending.
- 20 focused email/payment tests passed; changed entrypoints type-check.
- The queue migration and two new handlers are deployed only in Development.
- Auth hook activation, published designs/IDs, changed payment-function deployments,
  scheduling and real inbox QA are still pending.
- Production currently has no Loops transactional payment queue.
- Read-only Production audit during this QA: five paid sessions in the preceding
  48 hours, all with student IDs and active access, with no expected-subject-count
  mismatches. Five completed and 36 expired webhook events were processed, each
  with one attempt; no unprocessed/error events were found in that window.
- Those paid sessions include four direct purchases and one parent payment.
  Two paid accounts still have unconfirmed email; cause is unverified and may
  include test addresses. Payment evidence does not establish a usable sign-in.
- One parent email request in that window was recorded as sent. That is provider
  acceptance evidence, not proof the parent received or read it.

## Remaining checks carried from the earlier checkout session

Real new-student invite/code entry, confirmed-account login and resend cooldown,
unconfirmed-account signup confirmation, signed-in second-subject purchase,
parent payment completion, cross-device use, wallet rendering in Chrome/Safari,
and signed-in hub/banner behavior still require current evidence. Historical
observations from TASK-0060 are not substitutes for the current QA.

## Friction principles for the next build

1. Preserve subject selection from the incoming link.
2. Ask only for information needed to pay and assign access correctly.
3. Show the payable total before any payment CTA.
4. Keep the preferred payment method prominent; reveal card details only when chosen.
5. Reuse the code already emailed after purchase rather than requesting a second email.
6. A signed-in student goes directly to study after payment.
7. A parent can pay without creating a Cramapple account.
8. A student returning after parent payment should see unlocked access and one clear next step.

The joint audit is complete: 33 focused backend tests passed, and Sol checked
desktop/mobile Chromium states without paying or sending email. Astra documented
15 prioritized findings and 30 risk-based test cases; those cases have not all run.
No full checkout or Production cutover pass is claimed. This document is the
morning reference instead of an email, with evidence gaps in the linked report.
