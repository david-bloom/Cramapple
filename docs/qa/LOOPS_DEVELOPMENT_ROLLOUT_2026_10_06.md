# Loops Development Rollout

STATUS: IN PROGRESS - ten templates published; Development deployed; activation gates remain
DATE: 2026-10-06
RELATED: TASK-0060; merged PR #344

## Session Close - 2026-10-08

David requested session end. GitHub independently confirms rollout
[PR #358](https://github.com/david-bloom/Cramapple/pull/358) merged on
2026-10-07 at 08:20:43 America/New_York. Minimal CI, Vercel deployment and
Vercel Agent Review checks succeeded on the final PR head
`f3dfc92db4b611cb9d4684e115f96825ffc0c1bf`. The source and evidence below are
present on main. The implementation worktree was clean before this closeout.

This closeout checked GitHub and canonical documentation only. It did not
re-query Loops, Supabase, Stripe or inboxes, rerun tests, or change service
configuration. Development settings below are last verified rollout evidence,
not newly asserted live state as of October 8. A merged PR is not evidence of
Production activation or full checkout acceptance. No new approval is inferred.

Next owner: Codex/implementation. Single best next action: audit every enabled
Development Supabase Auth email action against the three implemented mappings,
and record the coverage gaps before activating the hook. Then continue the
remaining Development frontend, scheduler and payment/replay QA gates below.
David retains reminder-policy decisions and reviewed Production cutover approval.

Do not touch Production settings, disable current SMTP/Stripe receipts, enable
automatic-send flags, reset real accounts, or send fictional financial notices
to the supplied inboxes during restart. Preserve private credentials and keep
exact inbox addresses out of GitHub. The durable restart source is this report,
the morning checklist and merged PR #358, not an ephemeral local checkout.

## Owner Authorization

David instructed "execute 3-6" after providing the ten HTML designs, enabling
Chrome local-file uploads, and specifying footer text `Brooklyn, NY USA`.
This authorizes template publication, Development configuration/deployment,
missing transactional-trigger implementation and controlled-inbox QA. Production
cutover remains gated on reviewed delivery and checkout evidence. No live payment,
refund, legal-compliance acceptance, or task closure is recorded by this work.
Exact QA inbox addresses remain private and must not be committed.

## Published Templates

All ten supplied designs were imported into Loops using MJML ZIPs with a single
root `index.mjml`. Required variables were inspected in the provider UI. Templates
01-10 now show Published in the authoritative provider list, including refund
template 10; `manifest.json` records their IDs. One pre-existing unrelated receipt
draft was left untouched. Loops Free branding remains present.

Sender remains Cramapple at the existing `mail.cramapple.com` sender domain;
existing reply-to configuration was not changed. This is not inbox rendering or
delivery certification. Dynamic names remain in bodies; 04 and 08 use static
subject lines to avoid unsupported ad hoc merge-tag entry in the subject editor.
05 uses "Your AP exam prep is ready" as its subject.

## Development Configuration

Project: `wmgjsdkphcyhngaffbqf`, not Production `pcntajvbdfqhbeewmdry`.
Deployed `send-auth-email`, `stripe-webhook`, `send-parent-payment-email` and
`deliver-transactional-email` from this rollout branch. Applied migration
`20261006143000_parent_email_lifecycle.sql` as `parent_email_lifecycle`.
Both lifecycle tables enforce RLS; anonymous/authenticated clients cannot select
them or execute the claim RPC. Service-role access was separately verified.
Bound all ten published template IDs in Development, including the worker's
actual `LOOPS_PARENT_EXPIRED_TRANSACTIONAL_ID` binding. Automatic payment sends
remain disabled. Generated Development-only hook and worker secrets were installed
without printing their values. Auth hook and worker schedule are not activated.
Product URLs currently reference the public welcome/app pages; those pages are not
certified to accept Development codes. Do not claim an end-to-end browser sign-in
pass. Development generates eight-digit OTPs; the handler now preserves numeric
Supabase codes of 6-10 digits instead of rejecting every code longer than six.
No OTP generation, length setting or security configuration was weakened.

Disabled flags: `LOOPS_PAYMENT_EMAILS_ENABLED`, `LOOPS_PAYER_EMAILS_ENABLED`,
`PARENT_EMAIL_LIFECYCLE_ENABLED`. Development also sets
`PARENT_EMAIL_USE_SHORT_LINKS=false`: public-site short links cannot safely be
assumed to resolve records from the Development database. Request and reminder
emails therefore use the actual Stripe session URL. Default Production behavior
is unchanged. No Production configuration or deployment was performed.

## Verification Completed

- 47 focused tests pass; all four deployed entrypoints type-check.
- Two controlled student fixtures received genuine Development Auth codes through
  directly signed hook calls (one magiclink, one signup). Both codes verified in
  Supabase; Loops reported 100% delivery for templates 02 and 03. This does not
  establish automatic hook activation, browser login or visual inbox rendering.
- Both controlled parent inboxes accepted request email sends for an unpaid
  `cs_test_` session. One inbox receipt was independently read through Gmail:
  correct subject, populated design, no unresolved merge tags, requested footer.
  Its initial public short link exposed the environment mismatch fixed above.
  Corrected requests were then sent to both approved parent inboxes; one corrected
  Gmail message was read and its CTA confirmed to be an actual
  `checkout.stripe.com/c/pay/cs_test_...` URL, with no unresolved variables.
  No checkout was completed and no mobile/client rendering pass is implied.
- The protected worker returned HTTP 200 with zero payment jobs and lifecycle
  explicitly disabled. No real payment or refund was performed; no fabricated
  financial confirmation was sent as a delivery test.
- Luna reserve review found a refund-before-fulfillment ordering risk and missing
  expiry identity/recovery forwarding. Both were addressed in source. Fulfillment
  now checks current Stripe refund state before sending access/receipt notices;
  a full refund revokes newly granted access. This is not a full concurrent webhook
  race integration test. Lifecycle forwarding independently verifies the student.

## Implementation and Remaining Gates

The new payer receipt/refund builders are wired to verified Stripe charge/refund
events and the durable outbox, with recipient ownership and settled-payment checks.
The parent reminder/expiry lifecycle has a private RLS-protected context/job store,
settlement and expiry rechecks, dedupe, leases and worker wiring. These paths remain
disabled pending full event/replay and checkout evidence. Retry age now starts
at the first delivery attempt, not creation of a future reminder job.

- Verify all enabled Auth email actions before replacing SMTP with the hook.
  Current code supports signup, invite and magiclink, not password recovery,
  email changes, reauthentication or security notification designs.
- Confirm a Development-connected frontend before claiming clickable auth QA.
- Add frontend recovery URLs to parent requests; expiry remains unqueued without
  verified student identity and validated same-origin, subject-matching URLs.
  Correct the expiry template's claim about reusing the same parent inbox before
  enabling it: the current frontend does not establish that behavior.
- Choose reminder timing and configure a protected worker schedule; neither is active.
- Verify non-card receipt coverage. Current supplied receipt/refund contracts and
  implementation support card payments only; unsupported methods are not certified.
- Recheck payment/refund facts and recipient ownership; never send fabricated
  financial confirmations to real inboxes as a delivery test.
- Validate rendered links, actual controlled-inbox receipt, retries/replays and
  parent/direct checkout access before Production activation.
- `Brooklyn, NY USA` is owner-provided location text, not certification of a full
  postal address or footer legal compliance.
