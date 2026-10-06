# Transactional Email Design Import

STATUS: CURRENT - core backend template contracts implemented and tested; Loops import blocked, no cutover
DATE: 2026-10-06
OWNER: David Bloom (design); Codex (integration)
RELATED: TASK-0060; Loops PR #341; checkout QA PR #343; ordering fix PR #342

## Receipt and Scope

David supplied ten numbered HTML email files and a combined interactive HTML
preview on 2026-10-06, plus two parent and two student test inboxes. The first
student address is the existing-account case; the second is intended as new.
Account existence has not been independently verified. Keep exact addresses in
the private test setup/chat, not in this GitHub document or sample payloads.
Do not follow the hyperlink attached to the first address as an account identifier:
it points to a parent payment link, not an inbox.

The combined `Cramapple Transactional Email.html` is a JavaScript-bundled preview,
not a deliverable email body. It was not executed or imported into Loops.
The numbered HTML files are the design inputs. Their embedded platform/expiry/
trigger notes are source material, not new deployment or payment authorization.

## Package

- `source/`: original numbered HTML, preserved without design edits.
- `loops/`: adapted HTML and matching MJML envelopes for Loops custom-code import.
- `manifest.json`: subject, required variables, binding state and template IDs.

Loops accepts custom MJML uploads, not arbitrary HTML uploads. The MJML envelope
retains the supplied table-based body through `mj-raw`, with fonts/styles in its
head. Compiler validation does not establish Gmail/Outlook rendering or that
Loops discovers variables inside the raw body; inspect Review API Details after
import and test actual inboxes before binding IDs.

Normalization is deliberately limited:

- Supabase Go tokens become Loops `DATA_VARIABLE` tokens. All generation and
  verification stays in Supabase; no template is installed in Supabase.
- Sign-in's one-time clickable link becomes a plain `welcomeUrl` / Open Cramapple
  action, preserving the established code-first experience.
- Auth invite copy now asks for verification without promising paid access.
  Supabase can send an invite before entitlements exist, and editable metadata
  cannot substantiate purchase claims. Purchased-subject/parent-payment blocks
  are omitted from the adapted invite, not from the preserved original.
- Fixed one-hour expiry copy becomes `expiryText`; the backend supplies neutral
  expiry guidance rather than an unverified duration. Supabase expiry is unchanged.
- `[Mailing address]` becomes required `mailingAddress`, pending the real address.
- Adapted 07 supports settled direct purchases using purchased `subjects`, rather
  than inventing all-account subject holdings, an access-end date, or a separate
  receipt delivery promise. Original subjects-added design remains in `source/`.

## Template Readiness and Backend Gaps

| Design | Intended use | Binding or missing contract |
| --- | --- | --- |
| 01 Welcome verification | New-student invite | LOOPS_INVITE_TRANSACTIONAL_ID; implemented token, welcomeUrl, firstName (safe personalization only), emailAddress, neutral expiryText and mailingAddress. No paid-access claims from metadata. |
| 02 Sign-in code | Requested existing-account login | LOOPS_MAGICLINK_TRANSACTIONAL_ID; implemented emailAddress, expiryText and mailingAddress. Existing signed-out purchase must actually orchestrate its first code; this remains separate from template wiring. |
| 03 Email confirmation | Signup or unconfirmed-account confirmation | LOOPS_SIGNUP_TRANSACTIONAL_ID; implemented emailAddress, expiryText and mailingAddress. Confirm resend action mapping with controlled accounts before activation. |
| 04 Parent request | Parent recipient only | Implemented formatted USD amount, paymentUrl, explicit UTC expiresOn, parentEmail and mailingAddress. Preserves short-link preference and actual discounted session total. |
| 05 Parent paid | Student access notification | Implemented firstName, readable subjects, appUrl and mailingAddress. Recipient remains the Auth student, never the parent payer. Invite/confirmation overlap remains a release blocker. |
| 06 Receipt | Actual payer, distinct from student | No dedicated payer receipt trigger yet. Needs verified date, receipt number, payment method or non-card fallback, line items, total, receiptUrl and mailingAddress. Never assign student access from payer identity. |
| 07 Subjects added / purchase complete | Student after settled direct purchase | LOOPS_PURCHASE_TRANSACTIONAL_ID; adapted design and backend now agree on firstName, purchased subjects, appUrl and mailingAddress. No invented expiry, all-account holdings or receipt-send claim. |
| 08 Parent reminder | Parent, unpaid and unexpired request | No scheduler/trigger implemented. Source proposes one reminder, but timing and eligibility remain owner decisions; recheck settlement/expiry immediately before delivery. |
| 09 Link expired | Student recovery | No dedicated trigger/context-preserving recovery links implemented. The parent variant described in a comment is not a supplied standalone design or an authorized extra send. |
| 10 Refund | Payer after successful refund | No dedicated Loops refund trigger yet. Needs refund-specific amount/status, original payment details, truthful accessChange and receipt URL. Support partial/multiple refunds and non-card methods. Timing copy needs verification. |

`manifest.json` lists variables actually used, not merely variables named in
source comments. All IDs remain null until imported and checked; do not point
current backend environment variables at these richer contracts until import,
provider discovery/render verification and Development configuration are complete.

## Implementation Authorized While Manual QA Is Deferred

David instructed Codex to proceed with implementation because he cannot run
morning checklist steps 4-6 now. Those manual acceptance checks remain pending;
they are not a prerequisite to writing and testing the code, and are not marked
passed by delegation.

Implemented shared template-data builders, safe bounded personalization, escaped
text, HTTPS-only links without URL credentials, USD minor-unit formatting, and
required footer configuration. Contract tests read the actual import manifest
and cover all variables for the six wired templates. Codes are still generated
and verified by Supabase and are not written to the payment queue.

Includes PR #342's notification ordering correction: student ownership backfill
precedes independent email work. Queue-failure injection after actual grants
remains a separate fixture test, not established by type-checking.

Checkout F1 source remediation: add-on requests now validate the bearer with
`requireAuthedUser` and require the source order's student ID to match before
any customer/Stripe lookup. A mocked full-handler test rejects missing/invalid
tokens and wrong-account requests without Stripe calls. The route is not newly
promoted or published; no saved-card payment was attempted. Production deployment
is still outstanding, so do not describe the live endpoint as remediated.

Required new server config: `TRANSACTIONAL_MAILING_ADDRESS`. Missing footer
configuration fails before provider delivery; never deploy/activate the richer
contracts without it. Existing SMTP/Auth configuration and Stripe receipts are
unchanged. New templates/IDs must not be switched while old queued ambiguous
deliveries are awaiting reconciliation.

## Import Evidence and Blocker

Confirmed authenticated access to the Cramapple Loops workspace, Free plan.
Created one unpublished draft: `01 Welcome Verification - Design QA`, ID
`cmuwnate600hw0jzcwwtxrtmy`. The Code editor requires an MJML ZIP upload.
Upload failed because the ChatGPT Chrome extension has local-file access disabled.
No content was uploaded, no template was published, and no mail was sent.
Draft: https://app.loops.so/transactional/cmuwnate600hw0jzcwwtxrtmy?stepName=Compose

David's next step: enable Allow access to file URLs for the ChatGPT Chrome
extension, or upload the prepared MJML ZIP files manually. This expands extension
local-file access and must be the user's decision; Codex did not alter the setting.

## QA and Next Owner

Checks completed: all ten MJML files pass `mjml@4.17.1 --validate`; all ten
originals match Downloads byte-for-byte; adapted variable manifests match their
MJML; no Supabase Go syntax, script elements, magic-link placeholders or literal
mailing-address placeholders remain in adapted files. `git diff --check` passes.
This is structural validation only, not client rendering or provider delivery QA.

Implementation continuation verification: 49 focused backend tests pass (including
the mocked full add-on handler, nine new template/ownership tests and the existing
payment/auth/retry tests). All five changed function entrypoints type-check, and
all ten updated MJML files validate. No test recipient addresses were used in
provider calls; tests intercept fetch and use example.com fixtures. The frontend
preview pass is separately reviewed/recorded before any publish.

Codex: import the ten designs; inspect variable discovery and final rendered
HTML; supply safe backend data contracts; resolve first-code/duplicate-message
behavior; bind Development IDs only after contract tests; verify sender/domain,
reply-to, and configured expiry. Keep Stripe receipts until the replacement path
has demonstrated truthful receipt delivery. No Production auth hook activation,
payment notification enablement, reminder schedule or payment was performed here.

David: provide the actual mailing address and approve any reminder policy.
Supplied inboxes satisfy the earlier request for controlled test recipients;
they have not yet received test mail from this integration. Use the existing
student for returning/login tests and the intended new student for invite tests;
verify state first, and never delete/recreate a real account to reset a fixture.
Use synthetic fixtures for send-error, refund and queue failure tests; do not
send fictional payment/refund claims to real inboxes.

Before a full pass: new invite, existing first send, unconfirmed resend, parent
request, paid-parent student notification, payer receipt, added subjects,
reminder cancellation, expiry recovery, partial refund, duplicate webhook,
cross-device code entry and Gmail/Outlook mobile rendering. No pass inferred
from a design import or a compiler result.

Sources: [Loops custom email upload](https://loops.so/docs/creating-emails/uploading-custom-email)
and [Loops transactional guide](https://loops.so/docs/transactional/guide).
