# Morning Reference: Checkout and Transactional Email

STATUS: CURRENT - joint review complete; fixes, designs and end-to-end checks outstanding
DATE: 2026-10-06
OWNER: David Bloom
BRANCH: codex/checkout-qa-friction
RELATED: TASK-0060, TASK-0058, merged Loops PR #341, ordering follow-up PR #342

## Start here

The goal is the fewest practical checkout steps with an obvious next action at
every point. Joint QA covers both functional bugs and avoidable friction.
Astra reviews the flow and implementation; Sol checks the live browser; Codex
checks production evidence and integrates the findings.

**First morning action:** review the priorities below and provide the six email designs. The Loops backend
foundation is built and tested, but final templates and inbox tests are needed
before it can replace live auth/payment email.

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

| Priority | Action | Owner | Completion evidence |
| --- | --- | --- | --- |
| 1 | Provide the six transactional email designs below | David | Designs and final copy ready to build in Loops |
| 2 | Review the QA's recommended checkout changes, including friction findings | David | Chosen priorities and desired flow recorded |
| 3 | Supply controlled student and parent inboxes for real-inbox testing | David | Separate inboxes available; brand-new student and existing-account cases covered |
| 4 | Confirm current Supabase auth emails show a six-digit code while migration remains pending | David + implementation | Invite, signup confirmation and login code work through the current sender |
| 5 | Verify the login fix and hub welcome banner are actually published and work after login | David + implementation | Successful signed-in hub load, banner dismiss persists on reload |
| 6 | Complete the final end-to-end purchase and parent-pay tests after fixes | David + QA | Correct amount, one intended verification request, access granted, clear next step |

## Email designs to provide

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

One-provider delivery is the agreed destination. Payer receipts, refund emails,
parent reminders/expiration and enabled account-security notices also need a
coverage decision and appropriate designs. Stripe receipts remain active until
the replacement receipt path has been tested, so the migration is not yet complete.

## Implementation work queued for Codex

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
