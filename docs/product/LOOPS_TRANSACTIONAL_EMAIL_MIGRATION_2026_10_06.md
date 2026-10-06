# Loops Transactional Email Migration

STATUS: CURRENT - backend built; Development foundation deployed; live cutover pending designs and QA
DATE: 2026-10-06
OWNER: David Bloom
BRANCH: codex/loops-transactional-email
RELATED TASK: TASK-0060
TIER: Hard-Gate (Auth, payment notifications, deployment)

## Authorization and goal

David instructed: "Write up a plan to move to loops and execute. I'll provide
design templates in the morning." This authorizes implementation of the migration.
All Cramapple transactional subjects, bodies, layouts and delivery move to Loops.
Supabase remains responsible for generating and validating authentication codes.
Final designs, published Loops IDs, real-inbox QA and cutover remain dependencies.
No migration is complete merely because its code is committed.

## Execution plan

1. Build a strict Loops transactional API client, with timeout and explicit failures.
2. Build a signed Supabase Send Email Hook for signup, invite and magiclink.
   Each uses a six-digit code and a plain /welcome link, preserving TASK-0060.
   Missing templates fail visibly; they must never silently suppress email.
3. Replace parent-request workflow events with a direct Loops transactional call.
   Preserve session validation, short links, existing rate limits and audit records.
4. Enqueue student purchase and parent-payment confirmations only after the
   Stripe webhook has verified settlement and granted entitlements. Use the Auth
   user's email, never the parent's payer identity, to notify the student.
5. Add a service-only queue worker with leases and retries. Persist one message
   per checkout session; never store authentication codes in this queue.
6. When David supplies designs, create/publish Loops templates and bind their IDs.
   Verify the sending domain and disable overlapping legacy Loops workflows.
7. Rehearse the migration and deploy in Development. Configure the hook only
   after published templates and a matching signing secret exist. Run inbox QA.
8. Roll out to Production after evidence is reviewed; configure a protected
   scheduled worker, monitor failures, and retain the previous SMTP config for rollback.

## Design handoff

| Template | Environment variable | Data variables |
| --- | --- | --- |
| Verify email | LOOPS_SIGNUP_TRANSACTIONAL_ID | token, welcomeUrl |
| New student invite | LOOPS_INVITE_TRANSACTIONAL_ID | token, welcomeUrl |
| Sign-in code | LOOPS_MAGICLINK_TRANSACTIONAL_ID | token, welcomeUrl |
| Parent payment request | LOOPS_PARENT_REQUEST_TRANSACTIONAL_ID | studentName, subjects, subjectCount, amountTotal, currency, checkoutUrl, expiresAt |
| Parent payment completed (to student) | LOOPS_PARENT_PAID_TRANSACTIONAL_ID | subjects, amountTotal, currency, studyUrl |
| Purchase / subjects added (to student) | LOOPS_PURCHASE_TRANSACTIONAL_ID | subjects, amountTotal, currency, studyUrl |

Amounts are integer minor units (for USD, cents); template rendering must format
them correctly. Subject keys are supplied as a comma-separated string. Auth
templates contain no one-time clickable links and no promotional content.
The invite and purchase confirmation serve different purposes; a new purchaser
can receive both. Do not claim the purchase confirmation contains an auth code.
Auth and payment transactional sends do not add recipients to a marketing audience.

## Configuration

- Existing LOOPS_SECRET_KEY: server-only Loops API credential.
- SEND_EMAIL_HOOK_SECRET: generated Supabase Standard Webhooks secret.
- AUTH_EMAIL_WELCOME_URL: environment-specific plain /welcome URL.
- TRANSACTIONAL_STUDY_URL: environment-specific student hub URL.
- LOOPS_PAYMENT_EMAILS_ENABLED=true: enable enqueuing after migration/templates.
- TRANSACTIONAL_EMAIL_WORKER_SECRET: independent secret for scheduled queue calls.
- Template ID variables from the table above, separate in Dev and Production.

Deploy send-auth-email with JWT verification disabled: its signed webhook is the
authentication boundary. Deploy deliver-transactional-email with JWT verification
disabled only with the dedicated bearer secret configured. Parent request and
stripe-webhook retain their existing deployment authentication configuration.
Schedule a POST to the worker every minute using the protected bearer secret;
store it in the scheduler's secret store, never in version-controlled SQL.

## QA and rollback

Test signature rejection, body tampering, missing config, unknown auth actions,
Loops errors/timeouts, signup/invite/magiclink mapping, and successful responses.
Verify Dev signup, new purchase, existing-account login, resend cooldown,
parent request, parent payment, signed-in second purchase, delayed settlement,
webhook replay and queue failure recovery with real controlled inboxes.
The queue has service-role-only access and SKIP LOCKED claims. Review permissions
and run advisors after rehearsal. It stores payment recipient email and coarse
purchase data only; purge sent records after the agreed retention period.

Before enabling the hook, inspect enabled Auth actions. This initial handler
supports signup/invite/magiclink only. Email changes, reauthentication, recovery
or security notifications must get explicit handlers and templates if enabled;
otherwise defer hook cutover. Password recovery is outside the passwordless UX.

Loops idempotency lasts 24 hours. Leases and sent records stop ordinary duplicates,
but a process crash after delivery and before marking sent leaves an ambiguous
send. A 409 is retained for review rather than assumed successful. Do not blindly
retry ambiguous sends after 24 hours. This is a cutover review item.

Rollback: disable the Send Email Hook to restore saved SMTP/templates; disable
LOOPS_PAYMENT_EMAILS_ENABLED and the worker schedule; redeploy the previous
parent-request function and re-enable its legacy workflow. Preserve the queue
for reconciliation. Never revoke paid entitlements due to email failure.

## Remaining transactional coverage

Parent reminders/expiration, refund notifications, payer receipts and any enabled
account-security emails need designs and trigger definitions. Stripe's receipt
emails remain during rehearsal. Full one-provider delivery requires a Loops payer
receipt path and verified receipt links before disabling Stripe receipt emails;
this implementation does not silently remove receipts or invent that policy.

## Sources

- https://loops.so/docs/integrations/supabase/send-email
- https://loops.so/docs/api-reference/send-transactional-email
- https://supabase.com/docs/guides/auth/auth-hooks/send-email-hook
- docs/tasks/TASK-0060-USER-TESTING-CHECKOUT.md

## Execution evidence

- Backend implementation complete for the initial six templates above.
- 20 focused tests passed: seven transactional email tests plus ten checkout
  access tests and three webhook-ledger tests. Signature tampering, unsupported
  actions, missing config, provider/network failures, recipient selection,
  disabled queue, retry retention and stale ambiguous sends are covered.
- Deno type-check passed for all four changed/new entrypoints; diff check clean.
- Development migration applied as 20261006084914, matching the committed file.
- New Development functions deployed: send-auth-email version 1 and
  deliver-transactional-email version 1. The Auth hook was not activated.
  The changed stripe-webhook and parent-request functions have not been deployed.
- Rolled-back Development DML assertions passed: first claim returns one message,
  second returns none while leased. No QA queue rows persist.
- Development privilege checks: anon and authenticated cannot SELECT the queue;
  authenticated cannot execute its claim RPC.
- Security advisors identify RLS-with-no-policies on the new table. This is
  intentional for a service-only outbox: client grants are revoked, RLS denies
  clients, and service_role is the only granted caller. No client policy is needed.
- HTTP smoke checks: worker rejects an unauthenticated POST with 401; auth handler
  returns 503 while its signing configuration is missing. Neither test sends mail.
- Still pending: designs/published IDs, hook and worker secrets, Development inbox
  tests, deployment of the changed payment functions, worker scheduling, and
  Production cutover. No Production changes or real email sends were made.

## Morning handoff

David supplies the six designs in the handoff table. Implementation continues on
this branch: publish those templates in Loops, configure the environment-specific
IDs and secrets, activate and test the Development Auth hook, deploy the changed
Dev payment functions, enable the queue and worker schedule, and run the real-inbox
script before Production cutover. Decide receipt/security/reminder/refund coverage
before describing the broader one-provider migration as complete.
