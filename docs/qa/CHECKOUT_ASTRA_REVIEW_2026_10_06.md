# Checkout Architecture and Friction Review

Date: 2026-10-06. Reviewer scope: Astra source review within David's joint Astra/Sol checkout QA. No browser execution, payments, account creation, email sends, deployments, commits, or pushes. This document is the only file written. Live ledger, entitlement counts, delivery operations, and consolidated morning handoff belong to the conductor.

Status: core source QA finalized for conductor integration. Open fixture tests and the first-code/two-email release contract remain explicitly unresolved; finalized review does not mean checkout is release-cleared.

## Evidence and Scope

- **Observed:** no browser execution by Astra. Sol's fresh observations are incorporated below with explicit attribution to `docs/qa/CHECKOUT_SOL_BROWSER_QA_2026_10_06.md`. TASK-0060 E1-E10 and the October 4 handoff are historical evidence only.
- **Code-reviewed:** source obtained from Lovable read-only get_project/read_file/list_files and Production get_edge_function on October 6. These findings establish code paths, not successful end-to-end execution.
- **Inference:** a consequence requiring timing, provider behavior, stored data, or a particular user state; explicitly identified below.
- **Untested:** browser rendering, actual code delivery/verification, wallet confirmation, payment completion, email templates, and operational configuration unless independently supplied by the conductor.

Read docs/INDEX.md, TASK-0060, the named checkout handoff, session-start instructions, and the architecture/design one-pager. Used targeted checkout paths; did not scan research, teaching, logs, corpora, or other worktrees. The user's explicit report-only write scope governs instead of routine governance-log edits. The Supabase skill informed the auth/backend review; no database changes were made.

Source reference convention throughout:

| Prefix | Exact snapshot |
| --- | --- |
| M | Lovable marketing `61dd6602-6991-4561-b418-e988bb7c8a0b`, commit `2b46267051c6ed273baf81e907a6abd930f20462`; paths below are project-relative |
| A | Lovable app `56cae479-f7c9-4988-b536-56538c38ee4e`, commit `aec926ad8f4c8e4f95b1b887486eafa2ca87d2c7` |
| B | This checkout at `510173aa445006f063a8c99922bba11379c97b65`, branch `codex/checkout-qa-friction` |
| L | Pending PR341 checkout `/private/tmp/cramapple-loops-email-20261006`, commit `81087866717d48f1fbc475a2d5506bff3c8cd2f5` |

Both Lovable projects report published=true, but get_project supplies the latest source commit, not a separately attested published commit. Frontend conclusions below are **current-source findings with publication parity unverified here**. Do not upgrade them to live browser observations. Project links: [marketing](https://lovable.dev/projects/61dd6602-6991-4561-b418-e988bb7c8a0b), [app](https://lovable.dev/projects/56cae479-f7c9-4988-b536-56538c38ee4e).

Production `pcntajvbdfqhbeewmdry` deployed source was independently retrieved. Each entrypoint below matched B byte for byte, including newlines:

| Function | Production version | B source |
| --- | --- | --- |
| create-checkout-session | 26 | `supabase/functions/create-checkout-session/index.ts` |
| stripe-webhook | 26 | `supabase/functions/stripe-webhook/index.ts` |
| get-checkout-status | 5 | `supabase/functions/get-checkout-status/index.ts` |
| create-parent-payment-link | 3 | `supabase/functions/create-parent-payment-link/index.ts` |
| send-parent-payment-email | 6 | `supabase/functions/send-parent-payment-email/index.ts` |
| resolve-parent-link | 1 | `supabase/functions/resolve-parent-link/index.ts` |
| create-post-purchase-addon | 2 | `supabase/functions/create-post-purchase-addon/index.ts` |

The deployed add-on gateway has `verify_jwt=false`. Deployed webhook checkout-access/addon-checkout helpers and resolver parent-short-link helper were also read. Source references to those helpers reflect the retrieved logic. No deployed environment values or customer records were read.

### Fresh Cross-Review Evidence

Sol's October 6 live Chromium review covers desktop 1280x720 and mobile 375x812. It directly observed the expanded preselected picker hiding the next email step (B1), full-price/pending URL-promo confusion (B2), loss of parent waiting/share state after modal dismissal (B3), an unexplained empty wallet placeholder before email (B4), and email-first plain `/welcome` (B5). Astra read that report and matched these behaviors to source without repeating browser execution. This corroborates those specific paths, not publication parity for every file reviewed.

The conductor independently reported: preceding 48 hours had five paid orders (four direct, one parent_share), all with student IDs and active entitlements matching expected subject counts; five completed and 36 expired webhook events were processed, maximum attempts one, without recorded errors. One parent-email request was recorded sent, meaning provider acceptance only. Two of five paid accounts remain email-unconfirmed; they may be synthetic test buyers, so this is neither demonstrated dropoff nor an entitlement defect. Production has no transactional_email_outbox.

The conductor's 24-hour Auth log summary was four `/otp` HTTP422 `otp_disabled`, one `/invite`200, one `/verify`200, and six `/token`200. Request context and configuration were not established here. These counts do **not** prove OTP is globally disabled, successful delivery, or the cause of any buyer's experience. Payment endpoints showed normal 200s plus two checkout400 responses and an invalid-parent-link404. Those cannot be assigned to findings without request-level evidence. F2/F3/F4/F13 describe source behavior or conditional risks; the aggregate healthy fulfillment evidence does not demonstrate their occurrence.

## Architecture Trace

| Path | Current source behavior | Trust boundary |
| --- | --- | --- |
| Student direct | `/checkout` prefills subjects, collects learner email, automatically prepares an Elements session after email settles, displays wallet/card, returns to `/checkout/return` | Server owns price, coupon lookup, subject validation, settlement, and grants |
| New anonymous buyer | Webhook resolves typed learner email, invites if account absent, then grants subject access; return page polls and presents CodeSignIn | Typed/purchased email is not proof of ownership; invite/code validation remains necessary |
| Existing signed-out buyer | Webhook finds existing Auth user and grants access; return page still says a code was emailed | No code send exists in that webhook branch; see F2 |
| Signed-in buyer | Checkout locks email to session email; backend compares it to authenticated profile email; return page bypasses code for any current session | Same-account normal path works by design; return bypass does not verify purchase ownership, see F10 |
| Student asks parent | Drawer creates hosted parent-share checkout, short URL, optional email/share; drawer polls status | Learner identity is Stripe metadata; parent supplies payer identity; parent payment does not sign in student |
| Parent opens link | `/p/$code` resolves then replaces location with Stripe URL; success returns with `role=parent` | Parent receives payment confirmation, no student token; short-link paid copy is less strict than status API, see F8 |
| Student waiting after parent pays | Drawer switches to old StartStudying component | Adds another send; cannot immediately enter the purchase invite code, see F3 |
| Auth handoff | Marketing browser client and app use `.cramapple.com` cookies; app home applies purchased subject and strips query hint | Cookie config agrees in source; actual cross-subdomain session and access execution remain untested |

Sources: M `src/routes/checkout.index.tsx:75-241,581-588,611-829`; M `src/components/checkout/PaymentResult.tsx:31-125`; B webhook `:255-283,312-416`; B create-parent-payment-link `:115-178`; M `src/routes/p.$code.tsx:22-38`; M `src/lib/supabase-cookie-options.ts:26-31`; A `src/lib/supabase-cookie-options.ts:9-23`; A `src/routes/_ux.home.tsx:82-123`.

## Prioritized Findings

Severity: P1 = address before relying on checkout at scale or saved-payment reuse; P2 = meaningful conversion, recovery, or correctness defect; P3 = avoidable interaction or clarity issue. No P0 or demonstrated unauthorized charge is asserted.

### F1 - P1 - Add-on payment session lacks learner ownership authorization

**Evidence: code-reviewed, deployed.** B `supabase/functions/create-post-purchase-addon/index.ts:24-63,94-110,138-145` accepts a source checkout ID and subject, uses a service client to resolve the learner and their saved Stripe customer, and returns a new Elements client secret. There is no authenticated-user or source ownership check; Production v2 also disables gateway JWT verification. M `src/routes/checkout.add-on.tsx:52-55,111-135,242-246` reads a session only to supply optional email; it does not gate the route. Removing the upsell from PaymentResult did not retire this endpoint/route. B `get-checkout-status/index.ts:132-151` still produces the add-on offer URL.

**Trigger:** in an authorized Dev fixture, an unauthenticated or different-account caller supplies the known ID of a paid single-subject student-direct order and another eligible subject. No guessing of IDs is needed for the ownership-boundary test.

**Demonstration boundary:** no unauthorized charge was demonstrated or attempted. The finding establishes the missing authorization check in deployed source; saved-method visibility and charge completion require an authorized fixture.

**Consequence:** a checkout return ID functions as authorization to create a payment session attached to another learner's saved customer. Whether Stripe displays a saved method or permits a charge without further challenge is **inference/untested**, not a demonstrated exploit. Additional concern: direct checkout sets off-session reuse before learner verification (B create-checkout-session `:203-218,234-237`); webhook resolves a typed email and saves the payer customer against that user (B webhook `:264-275,286-309,396-397`). Typed learner email and payer identity can differ even outside the explicit parent path.

**Shortest-flow improvement:** retire the dormant add-on route/endpoint if it is no longer wanted. Otherwise require a verified session belonging to the source learner before preparing a reusable-customer session, verify current paid eligibility, and bind saved-method reuse to verified payer consent. Keep anonymous first purchase available without granting saved-payment authority from its return ID. No extra step is needed for an already authenticated owner.

### F2 - P1 - Existing signed-out buyer is told to read a code that checkout never sent

**Evidence: code-reviewed, deployed backend/current frontend.** B webhook `:264-265` returns immediately for an existing Auth user; only the absent-user branch calls inviteUserByEmail (`:267-275`). There is no existing-user OTP send later in `handleCheckoutSessionCompleted`. M PaymentResult `:123-125` nevertheless says to check email and renders CodeSignIn; CodeSignIn `:34,42-55,110-114` initializes a 60-second cooldown and sends only when requested.

**Trigger:** pay while signed out using an already-existing learner email, with no recent valid code request. Includes both confirmed accounts and previously invited/unconfirmed accounts. Payment can be for a new subject, not only a duplicate.

**Consequence:** paid learner checks an inbox with no new sign-in code, waits a fabricated minute, then requests the first code through a button labeled as a resend. This is not an email delivery diagnosis; the code path never requested a code. A signed-in checkout bypasses this defect.

**Shortest-flow improvement:** distinguish code actually requested from payment confirmed. Provide an immediate first-send action when no auth send occurred, or orchestrate one deduplicated auth send after settlement. Show the code input as soon as a valid code can exist, with cooldown based on the send time. Do not reveal account existence in a public email lookup or infer verification from purchase.

### F3 - P1 - Parent waiting screen repeats the old send/cooldown trap

**Evidence: code-reviewed.** M checkout `:778-781` still uses StartStudying. M `src/components/checkout/StartStudying.tsx:62-90,108-117` sends OTP on the initial Start action; a 429 leaves the component in its idle state with the button disabled and no code-entry field. Verification at `:99` uses only type=email, unlike M `src/lib/code-signin.ts:12-16`, which falls back to invite. The notice at StartStudying `:9-10` still says a link was emailed.

**Trigger:** a new student remains in the parent drawer, parent settles payment, webhook sends an invite, student immediately clicks Start Studying. If the Auth cooldown applies as in historical TASK-0060 E2, the UI blocks entry of the already-delivered invite code. The conditional provider response is **untested today**; the UI behavior on 429 is deterministic in source.

**Consequence:** an unnecessary click and send, possible forced wait, and divergent verification behavior depending on which success screen the student sees.

**Shortest-flow improvement:** use the shared CodeSignIn state immediately in the paid drawer; bypass it for the verified intended learner. Let a new student enter the first invite code while resend is cooling down. Use one verification helper and accurate code wording across login, welcome, and parent waiting.

### F4 - P1 - Repeated purchases can overwrite prior order entitlement provenance

**Evidence: code-reviewed; data-dependent hypothesis pending an authorized fixture.** Direct creation B `create-checkout-session/index.ts:131-244` and parent creation `create-parent-payment-link/index.ts:74-136` do not reject already-owned subjects or deduplicate an order intent. Webhook `:205-219` upserts on `(user_id,subject_id,access_tier,source)` while replacing `stripe_checkout_session_id`. Status `get-checkout-status/index.ts:105-126` counts access by that session ID. Refund logic webhook `:533-539` revokes rows attached to the refunded session. No duplicate charge, lost grant, or incorrect refund outcome was observed; the conductor's sampled paid orders all had expected active grants.

**Trigger:** two successful purchases for the same learner and subject with the same entitlement source, such as two full-price single-subject orders; similarly, overlapping bundle orders share the bundle source. Reopening a lost parent drawer can create a second payable link (F6).

**Consequence:** source predicts duplicate charges without additional access; the older order can subsequently read as processing because its entitlement reference was overwritten. Refunding the newer duplicate can revoke the shared entitlement despite an earlier unrefunded purchase. Neither duplicate payments nor refund behavior was executed here.

**Shortest-flow improvement:** show owned subjects for authenticated learners, prevent duplicate order intent at the server, and preserve a per-purchase grant ledger so refunds affect only their own grants. For anonymous checkout, do not expose account ownership via email enumeration; reconcile ownership safely during fulfillment or verified recovery. Reuse an open parent request instead of creating another on every drawer visit.

### F5 - P2 - Sticky parent action bypasses the unapplied-promo guard

**Evidence: code-reviewed.** M checkout `:263-289,457` hides the payment section and disables Place order for an unapplied code. The separate sticky parent button at `:569-575` only checks missing subjects/email and paying. Drawer receives `form.appliedPromo` at `:581-588`, and creates its checkout using that value at `:656-662`.

**Trigger:** choose a subject, enter valid learner email, type a promo without applying it (or leave an invalid code), then use the sticky Ask a parent to pay and Create payment link. A URL promo still applying is another timing case.

**Consequence:** parent link can omit the typed discount although direct payment is blocked to prevent precisely that mismatch. Its amount is server-correct for the request, but not the buyer's intended discounted order.

**Shortest-flow improvement:** apply the same guard to every payment handoff and refuse drawer creation until the promo has been resolved or explicitly removed. Present the discounted total before share. Do not silently discard the promo.

### F6 - P2 - Closing the parent drawer loses the request; expiry recovery resends a dead link

**Evidence: code-reviewed.** M checkout conditionally mounts ParentDrawer at `:581-589`; session ID/link exist only in drawer state (`:624-636`). Closing/unmounting removes polling and request state. At `:785-786`, failed status says to send the link again, while `link.status` remains ready and Create payment link is hidden (`:753-763`). B status `:84-93` maps an expired session to failed. B parent creation cancel URL `:127` returns to `/checkout?ask=parent`, omitting subjects and promo.

**Observed corroboration:** Sol B3 reproduced closing and reopening the drawer at mobile width and saw Create payment link replace the prior waiting/share state. Expiry and parent cancellation remain source-reviewed only.

**Trigger:** create/share a link, close and reopen the drawer or reload; alternatively leave it until expiry, or parent cancels hosted checkout.

**Consequence:** student loses the waiting context and may make a second independently payable request; an expired request offers resend instead of renewal. A canceling parent lands at an empty student-order form.

**Shortest-flow improvement:** persist the request ID and safe order context, restore waiting on return, and provide Renew link for a terminal expired request. Cancel returns the parent to the same request summary. One stable request should survive reload, drawer dismissal, and device handoff; status must never be inferred from local storage.

### F7 - P2 - Return page silently stops checking while promising automatic updates

**Evidence: code-reviewed.** M PaymentResult `:25,84-89` permits ten total checks at roughly three-second intervals, about 27 seconds plus request time. Any unavailable/error response stops scheduling immediately. Copy `:147-151` continues to say the page updates on its own when the ten-check budget is exhausted. Manual Check again remains, but does not reset the automatic budget.

**Trigger:** webhook fulfillment takes longer than the initial polling window, or a transient status failure occurs during it.

**Consequence:** a paid learner can wait indefinitely on a spinner after access becomes ready. A network problem looks like an unfinished bank payment.

**Shortest-flow improvement:** reuse the existing visibility-aware, backed-off polling pattern in M `src/hooks/use-checkout-status-poll.ts:5-65`; distinguish paid/access-pending from bank-processing and temporary check failure. If polling intentionally stops, say so and offer one explicit retry/support action. Preserve the receipt/order context.

### F8 - P2 - Parent short-link page declares access unlocked from Stripe completion alone

**Evidence: code-reviewed, deployed classifier.** B `_shared/parent-short-link.ts:57-65` returns paid on either payment_status=paid OR session.status=complete; it checks neither local grants nor async settlement. M `src/routes/p.$code.tsx:53-56` translates this to access unlocked and nothing more to do. By contrast, deployed get-checkout-status `:103-129,155-161` requires active grants, and webhook `:428-444` defers unsettled payments.

**Trigger:** reopen a paid short link before webhook provisioning completes; if delayed methods are enabled, open a completed but unpaid session. Reopen a fully refunded link whose Stripe session remains complete.

**Consequence:** parent sees a stronger success claim than the system has established; refund/unfulfilled states can also appear as success. Actual enabled payment methods and incidence are **untested**.

**Shortest-flow improvement:** return distinct paid/provisioning/unlocked/refunded states using the same fulfillment authority as the regular result page, or limit this page's statement strictly to what Stripe confirmed. Never make the parent redo payment because provisioning is pending.

### F9 - P2 - Provider outages are presented as expired parent links

**Evidence: code-reviewed.** B resolver `:58-60` converts any Stripe retrieval exception into expired. M `src/lib/purchase-api.ts:158-166` converts every invocation failure to not_found, and M parent route `:30-33,58-62` presents all non-paid/non-open outcomes as expiry with no retry.

**Trigger:** temporary network, Edge Function, database, or Stripe outage while opening an otherwise valid parent link.

**Consequence:** parent unnecessarily asks student for another link, adding communication and duplicate-order risk.

**Shortest-flow improvement:** keep terminal expiry separate from temporarily unable to load. Retry the same link with its order context intact; only ask for renewal after confirmed expiry.

### F10 - P2 - Return-page identity and learner identity are not matched

**Evidence: code-reviewed; wrong-account consequence inferred.** M PaymentResult `:53-56` redirects for any session once the referenced purchase is unlocked. It remembers email using a single per-tab sessionStorage key (`:45-50`; M StartStudying `:21-24`), not one keyed to an order. CodeSignIn `:28-34,89-94` hides email/change controls when a valid initialEmail exists. Status deliberately returns no learner email (B `get-checkout-status/index.ts:165-169`), which is a useful privacy boundary.

**Trigger:** pay anonymously, then sign in to a different account before returning; switch accounts in another tab; or create checkout B in the same tab before revisiting checkout A's return URL.

**Consequence:** the UI can redirect to an account that did not receive this purchase, or verify against a stale remembered address without displaying it. This does not establish cross-account data access: backend entitlement checks may correctly deny it. It does create a confusing paid-but-no-access experience.

**Shortest-flow improvement:** the authenticated status response should attest whether this session owns the purchase without disclosing another person's email. Auto-enter only on a match. Bind remembered learner context to the order, display a masked confirmation, and provide safe sign-in/account-switch recovery. Changing the code-entry email must not silently transfer the entitlement.

### F11 - P2 - Slow Stripe initialization can remove wallets and temporarily hide alternatives

**Evidence: code-reviewed; timing effects inferred.** M StripePayment `:153-160` starts a four-second timer when the form mounts, including while useCheckoutElements is loading. It sets walletState=unavailable, and rendering at `:216` then omits the ExpressCheckoutElement entirely. Loading and error returns at `:198-212` omit cardAction and parentAction, even though outer checkout `:489-490` stops rendering them once a session is ready. The parent sticky action survives.

**Trigger:** throttle Stripe initialization beyond four seconds, delay wallet readiness, or return a provider error.

**Consequence:** an eligible wallet can be permanently absent for that mount; the visible Pay with card and in-section parent choices can disappear during initialization/error. This is not a fresh observation of any particular browser.

**Shortest-flow improvement:** keep alternatives mounted and actionable with explicit loading/error state. Start wallet readiness handling when the element is actually mounted, preserve a path for late readiness, and provide retry without regenerating the order unnecessarily.

### F12 - P2 - The primary action and expanded preselected picker obscure the next step

**Evidence: code-reviewed; usability judgment.** M checkout `:309-315,327-355,416-440,534-576` always shows the whole subject selector, labels even a returning account Create your account, collapses card details behind Pay with card, and reserves the sticky primary action for a disabled Place order until card completion (M purchase-offer `:69-95`). Wallet confirmation uses the wallet button independently, so the visually dominant Place order is not the next action for a wallet buyer.

**Observed corroboration:** Sol B1 measured the email section at document Y=594 on desktop and Y=856 on mobile, with its input below the initial view in both cases, despite Biology already being selected. B4 observed the blank reserved wallet slot with disabled alternatives. The hidden next required action warrants P2; the returning-account wording and card-expansion opportunities remain lower-severity usability findings.

**Trigger:** preselected one-subject arrival, a no-wallet browser, or signed-in returning learner.

**Consequence:** redundant selection affordances, an extra card-expansion click, and uncertainty about whether to use the wallet or the locked primary action. The form functions can be correct while the experience still feels unfinished.

**Shortest-flow improvement:** show the selected order summary with a compact Change subjects action; open card details immediately when wallets are unavailable; make the next incomplete action visible next to the relevant control and sticky area. Signed-in identity should read Access for [account], with a safe switch option. Keep wallet/card/parent choices, but make one next action obvious.

### F13 - P2 - Pending Loops change does not solve the code contract and can delay ownership backfill

**Evidence: code-reviewed, PENDING ONLY.** PR341 L `_shared/payment-email.ts:8-29,43-56` queues a receipt/access message with subjects, amount, currency and studyUrl, but no auth code. L migration doc `:51-55` explicitly says new buyers can receive both invite and purchase confirmation. Existing-user lookup remains unchanged. Consequently F2 survives this change; switching delivery providers alone does not implement one email carrying the code.

L webhook `:417-423` awaits enqueuePaymentEmail after granting entitlements but before returning userId; caller backfills anonymous checkout ownership only at `:464-469`. Enqueue throws on recipient/config/database failure. B/current webhook has no such enqueue step.

**Trigger:** after a future flag-enabled cutover, anonymous paid checkout grants access, then queue insertion/config lookup fails before the checkout row receives its user ID.

**Consequence (inference):** entitlement can exist while get-checkout-status continues processing because stored.user_id is null. Webhook retries may recover, but payment-email availability becomes a dependency of visible completion. No such Production failure is asserted; the changed payment functions are pending, and Dev foundation deployment is not hook activation.

**Confirmed pending ordering defect and assigned fix:** the conductor accepted this as a bug in the reviewed PR341 snapshot and will move enqueuePaymentEmail out of handleCheckoutSessionCompleted into handleCheckoutSessionEvent after persisted anonymous user_id backfill. This makes fulfillment visible before notification failure can interrupt the handler. Astra has not edited migration code and has not verified the planned fix; T26 remains its acceptance test. This fix is separate from the unresolved email design contract below.

**Shortest-flow improvement:** establish a coherent first-code contract alongside the provider migration. Persist fulfillment/ownership before independent notification enqueue, preserving a durable retriable notification intent without hiding already-granted access. Decide how to avoid redundant invite and purchase messages; do not put long-lived codes into the payment outbox.

**Morning release blocker: first-code/two-email contract unresolved.** TASK-0060 F9's fallback calls for one purchase email carrying the sign-in code. PR341 deliberately implements separate auth and payment messages, so a new anonymous buyer can receive two emails and an existing signed-out buyer can receive a receipt without any code. This is a product-contract mismatch, not evidence of duplicate Production delivery. The smallest coherent outcome is one immediately usable auth/purchase message for a new signed-out buyer, one sign-in code for an existing signed-out buyer when needed, and no auth email for a verified matching signed-in buyer. Combining purchase context with Supabase-generated codes must preserve code validity and delivery/retry semantics; suppressing the second email alone would not fix F2. Stripe payer receipts are a separate required receipt decision, particularly for parents, and must not be silently removed to meet a message-count target. The conductor's ordering fix does not close this release blocker.

### F14 - P2 - Parent email abuse control is scoped only to the checkout session

**Evidence: code-reviewed, deployed.** B create-parent-payment-link `:59-136` accepts anonymous creation; B send-parent-payment-email `:38-70,95-125` accepts arbitrary parent recipient plus an open parent-share session, counts at most five sends/hour for that session, then records after sending. There is no in-function recipient/actor limit or atomic reservation. Current delivery is Loops events/send, not the pending transactional API.

**Trigger:** a caller generates multiple sessions for the same recipient or makes concurrent sends against one session. This is a review scenario only; no sends or load probes were performed.

**Consequence (inference):** session rotation/concurrency can defeat the in-code throttle, risking unwanted branded email and delivery reputation. External infrastructure controls and actual Loops workflow behavior are untested and belong to operational review.

**Shortest-flow improvement:** use atomic send reservations plus recipient/request/actor controls, with quiet normal-path enforcement. Keep copy/share available if email is limited. Avoid adding a routine CAPTCHA or account requirement for every legitimate parent request without evidence it is needed.

### F15 - P2 - Promo arrival shows full price and offers an action whose prerequisite is missing

**Evidence: observed by Sol B2, code-reviewed by Astra.** M checkout `:86,215-222,225-241` seeds the URL promo but cannot apply it until the email and order are ready. Apply is disabled only while creating/paying (`:393`), while totals fall back to the undiscounted amount (M purchase-offer `:37-40`; checkout `:262`). Sol saw the full $39.99 total and an Apply prerequisite error before email; after synthetic email entry the code automatically applied and showed $1.00.

**Trigger:** arrive through the preselected promotional checkout link before entering email, then press the visible Apply action.

**Consequence:** a discount campaign appears broken or full-price at the exact moment the buyer is deciding whether to continue. No overcharge was observed; the issue is misleading readiness and next-action guidance.

**Shortest-flow improvement:** explicitly show Promo pending beside the total until pricing is resolved, surface email as the immediate next action, and auto-apply when ready. Disable or replace Apply while its known prerequisite is absent. Never imply that the fallback full price is the final promotional quote.

## Other Friction and Unresolved Cases

- **Code entry recovery:** CodeSignIn changes to code mode before an optional send completes (`:73-78`), and resend restarts the full cooldown even on non-429 error (`:47-53`). A typo on login's sent screen cannot be edited there (M login `:162-194`). Add visible target-email correction and distinguish retryable send failure from a delivered-code cooldown.
- **Welcome loses purchased subject:** M welcome `:9,34-38,50-51` preserves only an email hint, then goes to generic home. Return-page code completion passes the purchased subject, but the plain email link path does not. Retain a safe purchase/subject hint where available; a new user should not repeat a choice already made.
- **Legacy links drop context:** M checkout.start `:5-10` forwards only subject, losing subjects/promo. M ask-parent `:5-8` forwards only ask=parent. Preserve recognized safe order parameters in legacy redirects; test actual historical URL formats before claiming a live affected campaign.
- **Parent modal keyboard behavior:** M checkout `:641-650,719-728` focuses the panel and handles Escape but supplies no focus trap/inert background in this component. Keyboard escape into underlying order controls is a code-level risk; confirm with Sol's browser review.
- **Zero-total coupon:** deployed backend accepts no_payment_required as settled (B checkout-access `:20-27`), but frontend commit readiness still requires PaymentElement complete (M purchase-offer `:84`; StripePayment `:270`). Whether a zero-total Elements checkout emits a usable completion state is **untested**, not a confirmed bug. Require a Dev 100%-off test and a zero-charge primary action.
- **Overlapping session requests:** M checkout `:178-208` ignores only a matching in-flight key, and does not reject stale completion before setting state. Identity inputs and promo removal can change while requests/payment are in progress (`:331-346,363`). `sessionStale` prevents rendering a mismatched session, which is useful; out-of-order completion and input changes during wallet confirmation still need fault-injection tests.
- **Receipts:** parent result claims a receipt was sent (M PaymentResult `:109-113`), but this component has no delivery attestation. Verify current receipt configuration/delivery through the conductor; do not infer delivery from a successful charge or an accepted Loops event.

## Shortest Practical Flow

The following is a proposal, not a new policy decision. It preserves payment/auth separation and the student's and parent's separate identities.

| Persona | Short flow | Interactions to remove |
| --- | --- | --- |
| New student, preselected subject, wallet | Confirm learner email and order on one page; wallet authorization; enter the one delivered code inline; automatically open purchased subject | Re-picking subject, Start Studying before code entry, second code send, generic onboarding, post-purchase upsell |
| New student, card | Same page with card details already open when no wallet is available; one Pay [total] action; inline code; purchased subject | Card expansion in no-wallet case; confirmation page that needs another continue click |
| Verified returning learner | Recognize account and owned subjects; choose only new subjects; wallet/card confirmation; automatic subject entry when ownership matches | Email entry, new-account copy, code, welcome banner, repeated subject choice |
| Existing account but signed out | Optional sign in first, or purchase and receive/request one code immediately; verify once; purchased subject | Claiming a code was sent when it was not; arbitrary page-load cooldown |
| Student asks parent | Preserve chosen order/email/promo; one action prepares shareable request; share or send; persistent waiting screen; inline code after payment unless already verified | Separate Create link step where request can be prepared on opening, re-creation after drawer close, second invite/OTP send |
| Parent | Open stable short link; inspect learner-safe order summary and final price; authorize payment; accurate completion status | Parent account creation, student sign-in, re-entering student choices, repeated payment after a transient load failure |

Mandatory: explicit payment authorization for displayed total, learner ownership proof before account access when no verified intended session exists, server confirmation of settlement and fulfillment, independent parent/learner identity handling. A typed email, paid order, URL parameter, wallet billing email, or matching string alone is not established authentication evidence in this implementation. Any future wallet/OAuth bypass needs a verified assertion bound to the correct learner and device; it must retain code recovery.

Avoidable: extra continue screens, mandatory name for student-share requests, an email-send click when the invite code already exists, a resend wait before the first send, re-picking purchased subjects, a locked primary action without a clear next action, lost request context, and success claims stronger than the server's evidence.

## Risk-Based Test Matrix

This matrix is designed, not executed. Browser-only checks belong to Sol. Payment, email, account, replay, and data-mutation cases require a separately authorized Dev/test fixture or David's controlled run; the current no-payment/no-account/no-email restrictions remain in force. Use pairwise browser coverage plus explicit high-risk identity and failure states, rather than every possible combination.

| ID | Priority / owner | Fixture or trigger | Required outcome |
| --- | --- | --- | --- |
| T01 | P1 / Dev | New unconfirmed student, direct purchase | Exactly the intended auth send; invite code works in inline field; no automatic second send |
| T02 | P1 / Dev | Existing confirmed student signed out, new subject | First code requested promptly; no false already-sent claim or artificial first-send wait |
| T03 | P1 / Dev | Existing invited/unconfirmed student signed out | Correct auth template/type; ownership proof works; no assumption that prior purchase verified email |
| T04 | P1 / Dev | Same-account signed-in second purchase | No code/banner; new subject active after verified fulfillment |
| T05 | P1 / Dev | Different session at return; account changes in another tab | No misleading ownership bypass; safe account-switch path; no cross-account entitlement exposure |
| T06 | P1 / Dev | Parent pays for new student; immediate Start; force 429 | Delivered invite code remains enterable; no extra send required |
| T07 | P1 / Dev | Parent pays for existing student on another device | Parent never gets learner session; student receives correct notification/auth path |
| T08 | P1 / Dev | Add-on with source ID, anonymous/wrong user/matching user | Anonymous/wrong-user rejected before customer reuse; authorized owner only; retired route unavailable if chosen |
| T09 | P1 / Dev | Direct learner email differs from payer; saved-method flow | No reusable-card authority assigned merely from a typed email; explicitly verify binding and consent |
| T10 | P1 / Dev | Two paid same-source orders for same/overlapping subjects; refund newest | Prior unrefunded grant remains; old status remains truthful; duplicate prevention/reconciliation |
| T11 | P1 / Dev | Duplicate webhook and out-of-order settlement/refund | Idempotent grants/events; no refunded access reactivation; truthful status |
| T12 | P2 / Sol | One/two/three subjects via URL; aliases, duplicate/fourth/invalid hint | Valid choices persist, fourth prevented clearly, price and mode track actual selection |
| T13 | P2 / Sol | Typed unapplied/invalid promo, sticky parent action | Cannot create undiscounted request accidentally; same guard on all payment paths |
| T14 | P2 / Sol | URL promo, remove, change subjects, retry; slow overlapping requests | Removed code stays removed; last intended order wins; no stale price/payment session |
| T15 | P2 / Dev | 100%-off coupon, direct and parent | No unnecessary card requirement; no_payment_required grants access; displayed charge is zero |
| T16 | P2 / Sol | Close/reopen parent drawer, reload, Back | Same request restored; polling resumes; no surprise second payable link |
| T17 | P2 / Dev | Parent request expired/failed/canceled | Renew correct order; never resend dead link; cancel preserves order and promo |
| T18 | P2 / Dev | Stripe complete/unpaid, paid/grants-pending, refunded short links | No premature access-unlocked claim; distinct accurate states |
| T19 | P2 / Sol + fixture | Transient resolver/status failure; recover network | Retry same request; no false expiry; polling resumes |
| T20 | P2 / Dev | Status processing >30 seconds, then entitlement ready | Page eventually advances automatically or clearly announces paused checks |
| T21 | P2 / Sol | Stripe load >4 seconds, late ECE ready, load error | Wallet can recover; card/parent alternatives remain visible and usable |
| T22 | P2 / Sol | Chrome wallet/no-wallet, Safari wallet, Firefox; desktop and narrow mobile | One obvious payment action, no blank wallet gap, readable total, sticky bar does not cover content |
| T23 | P2 / Dev | Code invalid/expired, 429, provider outage, page reload, cross-device code | Correct helper handles invite/email; cooldown tied to send; correction/retry does not require repayment |
| T24 | P2 / Dev | Session cookies between both live domains; preview hosts separately | Same intended account on app; no duplicated sign-in; preview isolation understood |
| T25 | P2 / Sol | Keyboard-only modal, code paste/autofill, focus, error announcement | Focus stays coherent; errors and target email visible; no trapped or hidden next action |
| T26 | P2 / Dev PR341 | Enabled queue insert/config failure after granting anonymous purchase | Fulfilled order remains visible; email retried independently; ownership backfill persists |
| T27 | P2 / Dev PR341 | Invite/magiclink/signup templates plus purchase confirmation | Actual codes in auth templates; no misleading code promise in receipt; duplicate messages intentionally resolved |
| T28 | P2 / Dev | Parent send rate-limit concurrent requests and rotated sessions using a stub provider | Atomic throttle without sending unwanted mail; copy/share fallback works |
| T29 | P3 / Sol | Legacy checkout/start and ask-parent links with subjects/promo | Valid context survives redirects; no unexpected empty picker |
| T30 | P3 / Dev | First welcome, returning buyer, shared device, banner dismissed | Purchased subject active; welcome does not interrupt study; no unnecessary account-setup steps |

## Verification and Handoff Boundary

Completed: pinned both frontend snapshots; read the relevant routes/components/helpers; compared seven deployed Production entrypoints with B; inspected pending Loops source and its explicit deployment caveat; designed matrix above. No test suites or browser flows were run by this reviewer. No claim is made about current inbox delivery, aggregate failures, or production customer impact frequency.

Sol B1/B2/B3 are corroborated at F12/F15/F6, with B4/B5 captured in flow and recovery analysis. Highest safety priority: F1 authorization and F4 grant accounting. Highest paid-entry priority: F2/F3 and the F13 one-email contract. Highest freshly observed conversion priority: collapse the preselected picker, make promo readiness truthful, and preserve parent request state. Keep these parallel workstreams so an audit fix does not postpone the ordinary student's shortest-flow improvements. PR341 remains pending; it is not a deployed remedy for these findings.
