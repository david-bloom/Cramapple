# Transactional Email Design Import

STATUS: CURRENT - supplied designs preserved and adapted; Loops import blocked, no cutover
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
- The invite-only Go conditional becomes always-visible `paymentContext` text.
  Supply a truthful direct/parent purchase sentence, not a boolean or raw HTML.
- Fixed one-hour expiry copy becomes `expiryText`; set from verified auth
  configuration, never change Supabase expiry merely to satisfy a design note.
- `[Mailing address]` becomes required `mailingAddress`, pending the real address.

## Template Readiness and Backend Gaps

| Design | Intended use | Binding or missing contract |
| --- | --- | --- |
| 01 Welcome verification | Paid new-student invite | LOOPS_INVITE_TRANSACTIONAL_ID; hook currently sends only token/welcomeUrl. Add safe firstName, emailAddress, verified purchased subjects, truthful paymentContext, expiryText and mailingAddress. Never infer access from editable user metadata. |
| 02 Sign-in code | Requested existing-account login | LOOPS_MAGICLINK_TRANSACTIONAL_ID; add emailAddress, expiryText and mailingAddress. Existing signed-out purchase must actually orchestrate its first code; a template cannot do this. |
| 03 Email confirmation | Signup or unconfirmed-account confirmation | LOOPS_SIGNUP_TRANSACTIONAL_ID; add emailAddress, expiryText and mailingAddress. Confirm resend action mapping with controlled accounts. |
| 04 Parent request | Parent recipient only | Existing code sends amountTotal (cents), checkoutUrl and expiresAt; design needs formatted amount, paymentUrl, expiresOn, parentEmail and mailingAddress. Preserve safe short links and actual discounted total. |
| 05 Parent paid | Student access notification | Existing queue sends subjects/studyUrl; design needs firstName, appUrl and mailingAddress. Suppress overlap with paid-new-student invite according to the first-code contract. |
| 06 Receipt | Actual payer, distinct from student | No dedicated payer receipt trigger yet. Needs verified date, receipt number, payment method or non-card fallback, line items, total, receiptUrl and mailingAddress. Never assign student access from payer identity. |
| 07 Subjects added | Student after additional settled subjects | Existing purchase mapping is generic and lacks newSubject/allSubjects/accessThrough. Derive entitlement expiry from policy/data; do not invent a date or promise a separate receipt before its trigger exists. |
| 08 Parent reminder | Parent, unpaid and unexpired request | No scheduler/trigger implemented. Source proposes one reminder, but timing and eligibility remain owner decisions; recheck settlement/expiry immediately before delivery. |
| 09 Link expired | Student recovery | No dedicated trigger/context-preserving recovery links implemented. The parent variant described in a comment is not a supplied standalone design or an authorized extra send. |
| 10 Refund | Payer after successful refund | No dedicated Loops refund trigger yet. Needs refund-specific amount/status, original payment details, truthful accessChange and receipt URL. Support partial/multiple refunds and non-card methods. Timing copy needs verification. |

`manifest.json` lists variables actually used, not merely variables named in
source comments. All IDs remain null until imported and checked; do not point
current backend environment variables at these richer contracts yet.

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
