# Loops Development Rollout

STATUS: IN PROGRESS - nine templates published; one template and activation checks pending
DATE: 2026-10-06
RELATED: TASK-0060; merged PR #344

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
01-09 showed Published in the list. Template 10 was imported and has an ID, but
the provider list still showed Draft after the publish attempt, so it remains
explicitly unconfirmed in `manifest.json`. One pre-existing unrelated receipt
draft was left untouched. Loops Free branding remains present.

Sender remains Cramapple at the existing `mail.cramapple.com` sender domain;
existing reply-to configuration was not changed. This is not inbox rendering or
delivery certification. Dynamic names remain in bodies; 04 and 08 use static
subject lines to avoid unsupported ad hoc merge-tag entry in the subject editor.
05 uses "Your AP exam prep is ready" as its subject.

## Development Configuration

Project: `wmgjsdkphcyhngaffbqf`, not Production `pcntajvbdfqhbeewmdry`.
Deployed `send-auth-email` and `deliver-transactional-email` from merged PR #344.
Bound the published payment-template IDs in Development; automatic payment sends
remain disabled. Generated Development-only hook and worker secrets were installed
without printing their values. Auth hook and worker schedule are not activated.
Product URLs currently reference the public welcome/app pages; those pages are not
certified to accept Development codes. Do not claim an end-to-end browser sign-in
pass.

## Implementation and Remaining Gates

The new payer receipt/refund builders are wired to verified Stripe charge/refund
events and the durable outbox, with recipient ownership and settled-payment checks.
The parent reminder/expiry lifecycle has a private RLS-protected context/job store,
settlement and expiry rechecks, dedupe, leases and worker wiring. These paths remain
disabled until their Development migration and focused integration checks pass.

- Verify all enabled Auth email actions before replacing SMTP with the hook.
  Current code supports signup, invite and magiclink, not password recovery,
  email changes, reauthentication or security notification designs.
- Confirm a Development-connected frontend before claiming clickable auth QA.
- Apply the Development lifecycle migration and deploy the changed functions.
- Recheck payment/refund facts and recipient ownership; never send fabricated
  financial confirmations to real inboxes as a delivery test.
- Validate rendered links, actual controlled-inbox receipt, retries/replays and
  parent/direct checkout access before Production activation.
- `Brooklyn, NY USA` is owner-provided location text, not certification of a full
  postal address or footer legal compliance.
