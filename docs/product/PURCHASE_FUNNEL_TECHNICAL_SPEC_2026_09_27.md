# Purchase Funnel Technical Specification — TASK-0041

**Status:** In Progress — execution approved (`DECISION-0083`, `APPROVAL-0058`)  
**Date:** 2026-09-27  
**Owner:** David Bloom  
**Implementation Task:** `TASK-0041 — Launch: Payment Flow`  
**Tier:** Hard-Gate  
**Canonical repository:** `david-bloom/Cramapple`  
**Implementation branch:** `chatgpt/task-0041-purchase-funnel`

> This document is the implementation specification for TASK-0041. Development/task-branch execution was approved on 2026-09-28 (`DECISION-0083`, `APPROVAL-0058`). Production deployment/migration, live Stripe writes/configuration, secrets, live paid sales, Lovable Production publish, and risk acceptance remain separate Hard Gates.
>
> The supplied design document included a secret-like string. It is intentionally omitted here and must not be copied into source control, prompts, logs, or client code.

---

## 1. Purpose

Implement a high-converting, mobile-first Cramapple purchase funnel for digital AP-prep access.

The funnel must minimize pre-purchase friction, prioritize express wallet payment, allow a student without a payment method to hand off payment to a parent, and provision the purchased AP subject access to the student rather than the payer.

The implementation target is:

```
Subject selection
  -> Mobile single-page checkout
      -> Student direct payment
          -> Order confirmation
          -> Optional post-purchase add-on
      -> Ask Parent to Pay
          -> Shareable parent-payment URL
          -> Parent payment
          -> Student access provisioned
```

This specification intentionally separates:

1. **Required implementation** — the plan an AI implementation agent should build.
2. **Alternate concepts / recommendations** — ideas that are not part of the required implementation unless separately approved.

---

## 2. Governing Cramapple constraints

Where the external purchase-funnel brief conflicts with current Cramapple records, the current canonical Cramapple records govern.

### 2.1 Current product and design decisions

- Marketing + signup funnel surface: Lovable project `61dd6602`, `cramapple.com`.
- Authenticated student app: Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`, `app.cramapple.com`.
- Design system: light-only, brand orange `#f54900`, orange ink `#ca3500`, square corners, zero motion except the documented ConfettiBurst exception, Bungee / Passion One / Source Sans 3 / STIX Two Math.
- Current decided pricing:
  - Single subject: **$39.99**
  - Two-subject bundle: **$69.99**
  - Three-subject bundle: **$89.99**
  - Unlimited: deferred and not marketed.
- TASK-0041 owns the paid purchase / paid entitlement path.
- Stripe webhook fulfillment remains the authoritative entitlement grant path. Client-side redirects must never grant access.
- Live Stripe and sandbox Stripe changes are Hard-Gated under TASK-0041.

### 2.2 Existing code to preserve where possible

Current backend surfaces include:

- `supabase/functions/create-checkout-session/index.ts`
- `supabase/functions/stripe-webhook/index.ts`
- `app.subject_entitlements`
- `app.stripe_checkout_sessions`
- `app.stripe_webhook_events`
- Growth events including `checkout_started`, `purchase_completed`, `checkout_expired`, `purchase_refunded`.

Current functionality already includes:

- Hosted Stripe Checkout Session creation.
- Single / 2-subject / 3-subject / unlimited catalog modes.
- Promotion-code support via Stripe Checkout.
- Parent-gift metadata and student-account resolution.
- Webhook signature verification.
- Webhook-event idempotency ledger.
- Checkout-session persistence.
- Paid entitlement grants.
- Parent gift attribution.
- Refund revocation.
- Async payment success/failure handling.

The implementation agent should **extend and refactor this path**, not create a second unrelated fulfillment system.

---

## 3. Primary UX requirements

### 3.1 General rules

The purchase funnel must:

- be mobile-first;
- require no shipping information;
- require no physical address UI beyond any minimum billing/postal requirement imposed by Stripe/payment networks;
- require no password creation before payment;
- display express wallet methods before card entry;
- keep the selected subject(s) and total visible;
- hide promo-code entry until explicitly requested;
- expose "Ask a Parent to Pay" directly from the checkout;
- avoid modal upsells before the first purchase;
- provision student access from server-side verified Stripe payment state only;
- keep parent payment independent of parent account creation.

### 3.2 Mobile layout

Primary breakpoint target: under 479px.

Requirements:

- single-column layout;
- all form inputs >= 16px font size;
- interactive tap targets >= 48 x 48 px;
- primary action remains in thumb reach;
- no horizontal scrolling;
- no multi-column form fields on mobile;
- safe-area padding for iOS bottom inset.

### 3.3 Checkout page order

Render in this order:

1. Minimal Cramapple header.
2. Trust / secure-payment text.
3. Compact order summary.
4. Express Checkout block.
5. Divider: "or pay with card".
6. Student email.
7. Stripe Payment Element.
8. Collapsed promo-code trigger.
9. Sticky bottom CTA.
10. Secondary "Ask a Parent to Pay" action.

Recommended exact primary CTA pattern:

`Pay $[total] & Start Studying`

The exact wording may be adjusted to fit the canonical Cramapple voice, but the CTA must state both price and immediate benefit.

---

## 4. Stripe integration model

### 4.1 Direct student checkout: Checkout Sessions API with custom UI

Use Stripe Checkout Sessions in `ui_mode: "custom"` for the direct student checkout.

Rationale:

- It preserves the existing Checkout Session-based webhook and entitlement architecture.
- It supports a fully custom Cramapple checkout surface.
- It permits Stripe Elements-based payment UI.
- It avoids introducing an independent PaymentIntent-only fulfillment path.
- It supports discount handling and future payment-method reuse through Checkout Session configuration.

Implementation agent must confirm the installed Stripe SDK/API version supports `ui_mode: "custom"` before coding. If the currently pinned SDK does not support it, upgrading Stripe SDK/API version becomes a separately reviewed implementation step.

### 4.2 Express payment

Use Stripe Express Checkout Element above the normal Payment Element.

Enable dynamic presentation of supported methods, with priority for:

- Apple Pay
- Google Pay
- Stripe Link

Do not hard-code a wallet button as visible when Stripe reports it unavailable for the device/browser.

The checkout must still function when no express method is available.

### 4.3 Card / fallback payment

Use Stripe Payment Element as the fallback block.

Do not manually build card-number, expiration, CVC, or postal-code inputs if Stripe's Payment Element owns them.

Configure the Payment Element to minimize unnecessary billing collection while preserving Stripe/payment-network requirements.

### 4.4 Parent payment

Parent payment uses a **Stripe-hosted Checkout Session** generated by the server.

Reason:

- shareable URL is required;
- parent should not need a Cramapple session;
- parent may open the link on any device;
- Stripe-hosted Checkout minimizes risk on an externally shared payment page.

The parent payment session must contain enough metadata to provision the student's entitlement after webhook verification.

### 4.5 Post-purchase add-on payment

The plan calls for a one-tap post-purchase add-on without card re-entry.

To support this:

- the original direct payment must create/use a Stripe Customer;
- the original payment method must be saved for permitted future reuse;
- configure the Checkout Session / underlying PaymentIntent with `setup_future_usage` suitable for later reuse;
- store the resulting Stripe Customer ID and reusable PaymentMethod association server-side, never in client-controlled metadata;
- the add-on charge must originate from a server endpoint;
- client must never supply arbitrary amount or Stripe Price ID.

A failed "one-tap" add-on that requires authentication must degrade to a Stripe authentication/payment confirmation flow rather than be treated as a successful charge.

---

## 5. Checkout state model

Represent the selected offer server-side using the existing modes:

```ts
type PurchaseMode =
  | "single"
  | "bundle_2"
  | "bundle_3";
```

`unlimited` remains non-marketed and out of this funnel.

Client selection payload:

```ts
type CheckoutSelection = {
  mode: "single" | "bundle_2" | "bundle_3";
  subject_keys: string[];
  student_email: string;
  promo_code?: string;
};
```

Server rules:

- `single` requires exactly 1 distinct subject.
- `bundle_2` requires exactly 2 distinct subjects.
- `bundle_3` requires exactly 3 distinct subjects.
- every subject key must exist in the server-side price catalog;
- price and amount are derived on the server;
- client-supplied amounts are ignored/rejected;
- duplicate subjects are rejected.

---

## 6. Student identity and account provisioning

### 6.1 No-password-before-payment rule

A student must be able to complete the purchase without first creating a password or completing an authenticated account session.

Student email is the required identity field before payment.

### 6.2 Student email

UI:

```html
<input
  type="email"
  autocomplete="email"
  inputmode="email"
/>
```

Server:

- trim;
- lowercase;
- validate;
- do not accept blank value;
- persist only where required for checkout fulfillment.

### 6.3 Fulfillment behavior

After a verified paid Checkout Session:

1. find an existing Supabase Auth user by normalized student email;
2. if found, grant entitlement to that user;
3. if not found, create/invite the student using the established parent-gift pattern;
4. grant entitlements only after the student user ID is resolved;
5. send the student an activation/access email;
6. record the Stripe Checkout Session -> user association.

Generalize the existing parent-gift helper rather than duplicating account-resolution code.

Suggested helper name:

`resolveStudentUserId(service, metadata)`

### 6.4 Existing authenticated students

If a signed-in student enters checkout:

- derive their user ID and email server-side where possible;
- do not permit a signed-in student to purchase for an unrelated student email through the direct-payment path;
- parent/gift flow remains the separate mechanism for buying for another student.

---

## 7. Direct checkout API

Refactor the existing `create-checkout-session` Edge Function so it supports a custom Checkout Session.

### 7.1 Request

`POST /functions/v1/create-checkout-session`

Example:

```json
{
  "purchase_type": "student_direct",
  "mode": "single",
  "subject_keys": ["ap_biology"],
  "student_email": "student@example.com",
  "promo_code": "OPTIONAL"
}
```

### 7.2 Authentication

Direct purchase must support:

- anonymous pre-account student; and
- authenticated student.

Do not require `requireProfile()` for all `student_direct` purchases.

If an authenticated user exists, the server must reconcile request email with authenticated identity.

### 7.3 Stripe Session creation

Conceptual server shape:

```ts
stripe.checkout.sessions.create({
  mode: "payment",
  ui_mode: "custom",
  line_items: [{ price: SERVER_RESOLVED_PRICE_ID, quantity: 1 }],
  return_url: `${APP_BASE_URL}/checkout/return?session_id={CHECKOUT_SESSION_ID}`,
  customer_creation: "always",
  customer_email: studentEmail,
  allow_promotion_codes: true,
  metadata: {
    purchaser_type: "student_direct",
    student_email: studentEmail,
    mode,
    subject_ids: subjectKeys.join(","),
    is_upsell_eligible: String(mode === "single")
  },
  payment_intent_data: {
    setup_future_usage: "off_session"
  }
});
```

Exact Stripe parameters must be adjusted to the installed SDK/API version.

### 7.4 Response

Return only the fields required by the front end.

Example:

```json
{
  "status": "ok",
  "session_id": "cs_...",
  "client_secret": "..."
}
```

Do not return Stripe secret keys, PaymentMethod secrets, or internal catalog mappings.

---

## 8. Checkout front-end

Target surface: Cramapple marketing Lovable project.

### 8.1 Route

Create or replace:

`/checkout`

Query/state should carry only selection identifiers, not trusted price values.

Example:

`/checkout?subjects=ap_biology`

The page calls the backend to resolve the authoritative offer.

### 8.2 Components

Suggested component decomposition:

```
CheckoutPage
  CheckoutHeader
  OrderSummary
  ExpressPaymentSection
    ExpressCheckoutElement
  PaymentDivider
  StudentEmailField
  CardPaymentSection
    PaymentElement
  PromoCodeDisclosure
  CheckoutStickyBar
    PrimaryPayButton
    AskParentButton
  CheckoutErrorRegion
```

### 8.3 Order summary

Show:

- subject name(s);
- purchase type ("1 subject", "2 subjects", etc.);
- original total if discounted;
- discount amount if active;
- final total.

Do not show shipping, quantity controls, or cart-management affordances.

### 8.4 Promo codes

Default state: collapsed text action.

Label:

`Have a promo code?`

On open:

- show input and Apply control;
- apply through a server/Stripe-supported mechanism;
- update authoritative total;
- expose invalid / expired / ineligible states inline;
- do not clear subject selection on failure.

Support URL auto-apply:

`?promo=CODE`

Rules:

- validate server-side;
- URL code is not trusted;
- invalid code must not block checkout.

### 8.5 Sticky action bar

Requirements:

- fixed/sticky at viewport bottom;
- respects safe-area inset;
- does not cover card fields;
- button disabled while payment is submitting;
- shows current authoritative total;
- secondary parent-pay action directly beneath or adjacent in the same purchase action area.

---

## 9. Ask Parent to Pay

### 9.1 Trigger

Student taps:

`Ask a Parent to Pay`

Open a bottom drawer or modal optimized for mobile.

### 9.2 Parent-link creation API

Add a dedicated Edge Function:

`create-parent-payment-link`

Do not generate parent-payment URLs entirely client-side.

Request:

```json
{
  "mode": "single",
  "subject_keys": ["ap_biology"],
  "student_email": "student@example.com",
  "student_name": "Optional display name",
  "promo_code": "OPTIONAL"
}
```

For an authenticated student, derive student email and user ID server-side and ignore conflicting client identity.

### 9.3 Stripe hosted Session

Create a new hosted Checkout Session:

```ts
stripe.checkout.sessions.create({
  mode: "payment",
  ui_mode: "hosted",
  line_items: [{ price: SERVER_RESOLVED_PRICE_ID, quantity: 1 }],
  customer_email: undefined,
  allow_promotion_codes: true,
  success_url: `${APP_BASE_URL}/checkout/success?session_id={CHECKOUT_SESSION_ID}&role=parent`,
  cancel_url: `${APP_BASE_URL}/checkout/parent-cancelled`,
  metadata: {
    purchaser_type: "parent_share",
    student_email: studentEmail,
    student_name: studentName ?? "",
    mode,
    subject_ids: subjectKeys.join(",")
  }
});
```

If the student already has an internal user ID, include an opaque internal recipient reference server-side where appropriate. Do not make fulfillment depend solely on a client-supplied user ID.

### 9.4 Parent share drawer

Provide:

- **Copy Payment Link**
- **Share**
- **Send Parent Email**

Use Web Share API when available.

Fallback:

- copy link;
- SMS deep link where supported.

Suggested share text:

`Can you help me unlock Cramapple for my AP prep? Here's the payment link: [URL]`

Do not include sensitive account information in share text.

### 9.5 Send Parent Email

Inline input:

- parent email;
- submit.

Backend sends a transactional message containing:

- student first/display name if available;
- selected subject(s);
- total;
- secure Stripe Checkout link;
- expiration note if applicable.

Do not require a parent Cramapple account.

Rate-limit this endpoint to prevent abuse.

---

## 10. Parent payment view

Stripe-hosted Checkout is the payment form.

Cramapple may optionally provide a lightweight pre-redirect/interstitial context page, but the payment itself must remain hosted in this implementation.

Required context before or inside the payment flow where supported:

- "[Student] set up a Cramapple study plan."
- selected AP subject(s);
- total price;
- "Access is for [student email]" or a privacy-reduced variant.

Do not expose the student's full email if the link is likely to be forwarded broadly unless necessary for payer confidence. If displayed, mask part of the address when feasible.

Parent provides their own payment email to Stripe.

Payer email must not replace `student_email` in entitlement metadata.

---

## 11. Webhook / fulfillment changes

`stripe-webhook` remains the sole authority for granting paid entitlements.

### 11.1 Metadata schema

Normalize metadata to:

```ts
type PurchaseMetadata = {
  purchaser_type: "student_direct" | "parent_share" | "parent_gift";
  student_email: string;
  student_name?: string;
  mode: "single" | "bundle_2" | "bundle_3";
  subject_ids: string; // comma-separated subject keys in Stripe metadata
  is_upsell_eligible?: "true" | "false";
};
```

Retain backwards compatibility for existing `parent_gift` sessions.

### 11.2 Fulfillment rules

For `student_direct`:

- resolve/create student account from student email unless a verified internal user reference exists;
- grant purchased subject entitlement(s);
- record Checkout Session user association.

For `parent_share`:

- ignore parent payer identity for entitlement ownership;
- resolve/create student account from student metadata;
- grant entitlement to student;
- send parent receipt through Stripe and student activation through Cramapple.

For `parent_gift`:

- preserve current behavior.

### 11.3 Payment state

Never grant on redirect.

Grant only for verified Stripe webhook events where payment state is acceptable:

- `checkout.session.completed` with paid state;
- `checkout.session.async_payment_succeeded`.

Preserve existing async-pending behavior.

### 11.4 Idempotency

Keep `app.stripe_webhook_events` insert-first event ledger.

Entitlement writes must remain safe on duplicate delivery.

### 11.5 Refunds

Existing refund revocation remains active.

Any new add-on entitlement must be traceable to the specific Stripe payment/session that purchased it so refunds can revoke only the relevant entitlement.

---

## 12. Order confirmation

### 12.1 Route

`/checkout/success`

Do not trust query parameters as proof of payment.

The page may display an optimistic "processing" state while backend confirmation is pending, but "Access Unlocked" must be based on a server-confirmed paid Checkout Session / entitlement state.

### 12.2 Required content

Header:

`Access Unlocked!`

Then:

- purchased subject(s);
- access destination;
- start-studying CTA;
- email activation guidance if the student account was just created.

### 12.3 Parent payer confirmation

When `role=parent`:

- confirm payment;
- say access was sent/unlocked for the student;
- do not sign the parent into the student account;
- do not show student-only study CTAs as though the parent is the learner.

---

## 13. Post-purchase one-tap add-on

### 13.1 Eligibility

Show only when:

- original purchase mode = `single`;
- payment succeeded;
- a reusable payment method is available;
- the proposed add-on subject is not already entitled;
- an approved promotion/price exists.

The supplied brief example ("AP Biology for 50% off") is illustrative only. The actual add-on subject and discount must come from approved server-side offer configuration.

### 13.2 UI

Non-blocking card on confirmation page.

Example structure:

```
Add another AP subject
AP Statistics
50% off this add-on
$19.99
[Add with 1 Tap — $19.99]
[No thanks]
```

Do not obstruct the "Start Studying" action.

### 13.3 Endpoint

Add:

`POST /functions/v1/create-post-purchase-addon`

Request:

```json
{
  "source_checkout_session_id": "cs_...",
  "subject_key": "ap_statistics"
}
```

Server must derive:

- authenticated/verified recipient;
- Stripe Customer;
- saved PaymentMethod;
- eligible offer;
- amount/price;
- current entitlement state.

Never accept client amount.

### 13.4 Charge behavior

Create and confirm a new PaymentIntent or Stripe-supported one-click checkout using the stored Customer/PaymentMethod.

If issuer authentication is required:

- return `requires_action`;
- invoke Stripe confirmation/authentication UX;
- grant add-on entitlement only after verified success webhook.

### 13.5 Consent

The confirmation card must clearly state the exact charge before the tap.

Do not perform an automatic add-on charge merely because a payment method was saved.

---

## 14. Data model changes

Implementation agent must first inspect current schema and reuse fields/tables where possible.

Expected additions may include:

### 14.1 Stripe customer mapping

If no reliable mapping already exists:

```
app.stripe_customers
- user_id uuid primary key / unique
- stripe_customer_id text unique not null
- created_at timestamptz
- updated_at timestamptz
```

Do not create this table if an equivalent canonical mapping already exists.

### 14.2 Parent-share request audit

Optional but recommended for support/analytics:

```
app.parent_payment_requests
- id uuid
- student_user_id uuid nullable
- student_email text
- checkout_session_id text unique
- mode text
- subject_keys text[]
- status text
- created_at timestamptz
- paid_at timestamptz nullable
- expires_at timestamptz nullable
```

This is not required if existing Checkout Session persistence provides equivalent supportability.

### 14.3 No raw card data

Cramapple must never store:

- PAN/card number;
- CVC;
- raw wallet token;
- Stripe secret key;
- Payment Element client secrets in durable application logs.

---

## 15. Security requirements

- Server resolves all Price IDs.
- Server validates subject count and catalog membership.
- Webhook signature verification remains mandatory.
- Webhook fulfillment remains idempotent.
- Parent payment links use Stripe-hosted session URLs and inherit Stripe session expiration.
- Email-send endpoint is rate-limited.
- Parent-share creation is rate-limited.
- Do not place secret keys or sensitive tokens in query parameters.
- Do not log Stripe client secrets.
- Do not trust client-supplied user IDs.
- Do not grant access from success URL.
- Do not permit arbitrary subject/price combinations.
- Do not expose internal database IDs unnecessarily in share links.
- Apply CORS only to approved Cramapple origins.
- Preserve least-privilege Supabase service-role usage in Edge Functions only.
- Review privacy implications of student email appearing on parent-facing pages before Production.

---

## 16. Error and recovery behavior

### 16.1 Checkout initialization failure

Show:

`We couldn't start checkout. Your selection is saved. Try again.`

Do not clear selected subjects.

### 16.2 Wallet unavailable

Hide unavailable wallet buttons and continue with Payment Element.

### 16.3 Payment declined

Use Stripe-returned customer-safe error messaging.

Keep checkout state intact.

### 16.4 Parent link creation failure

Do not dismiss the drawer.

Offer Retry.

### 16.5 Webhook processing delay

Success page shows:

`Payment received. We're unlocking your access now…`

Poll/read server confirmation with bounded retry.

Do not grant client-side access.

### 16.6 Account invite failure after successful payment

This is a paid-without-access incident.

Requirements:

- persist the paid Stripe session;
- persist processing error;
- raise operational alert/log;
- provide support-safe confirmation rather than telling the payer payment failed;
- support deterministic replay/reconciliation.

### 16.7 Add-on charge requires authentication

Launch Stripe authentication flow.

Do not report success until server-confirmed.

---

## 17. Analytics

Use PostHog and/or the existing growth-event path according to current project conventions.

Minimum funnel events:

```
subject_selection_completed
checkout_viewed
express_checkout_available
express_checkout_selected
card_checkout_selected
promo_opened
promo_applied
promo_failed
ask_parent_opened
parent_link_created
parent_link_copied
parent_share_invoked
parent_email_sent
checkout_started
checkout_payment_pending
purchase_completed
checkout_expired
checkout_failed
purchase_refunded
addon_offer_viewed
addon_purchase_started
addon_purchase_completed
addon_purchase_failed
```

Required common properties where privacy permits:

- purchase mode;
- subject keys;
- offer total;
- discount amount;
- purchaser type;
- device class;
- payment method category;
- source campaign / referrer where already supported.

Do not put raw email addresses in analytics properties.

---

## 18. Accessibility

- Logical heading order.
- Labels programmatically associated with inputs.
- Error messages announced with ARIA live region.
- Visible focus state.
- Keyboard operable checkout.
- No color-only error/success cues.
- 48px minimum touch targets.
- Contrast must meet WCAG AA.
- Wallet/payment buttons retain Stripe-required branding.
- Sticky footer must not trap keyboard focus or obscure focused fields.

---

## 19. Implementation sequence

An implementation agent should proceed in this order after Hard-Gate approval:

### Phase A — Read-only verification

1. Verify current Lovable checkout surfaces.
2. Verify Stripe SDK/API version.
3. Verify existing Stripe catalog mapping.
4. Verify current Supabase schema for Stripe Customer mapping.
5. Verify current parent-gift path.
6. Verify paid entitlement-gating behavior.
7. Record any mismatch against this spec before writing code.

### Phase B — Backend refactor in Development only

1. Generalize student recipient resolution.
2. Add anonymous `student_direct` session support.
3. Add custom-ui Checkout Session response.
4. Add `parent_share` metadata path.
5. Add parent-payment-link endpoint.
6. Extend webhook for new purchaser types.
7. Add server-side Stripe Customer/payment-method mapping required for add-on.
8. Add post-purchase add-on endpoint.

### Phase C — Front-end

1. Build mobile checkout page.
2. Integrate Express Checkout Element.
3. Integrate Payment Element.
4. Add promo disclosure.
5. Add sticky CTA.
6. Add parent-share drawer.
7. Add success/processing states.
8. Add parent confirmation state.
9. Add add-on module.

### Phase D — Development QA

1. single subject / card;
2. single subject / Apple Pay where testable;
3. Google Pay where testable;
4. Link;
5. valid promo;
6. invalid promo;
7. parent share / copy;
8. parent share / email;
9. parent payment -> student entitlement;
10. duplicate webhook replay;
11. async payment;
12. refund;
13. existing student;
14. new student;
15. one-tap add-on;
16. add-on requiring authentication;
17. failed invite after paid session recovery.

### Phase E — Production readiness

No Production or Stripe live-mode change occurs until the TASK-0041 Hard Gate is explicitly cleared.

---

## 20. Acceptance criteria

The implementation is ready for independent QA only when all applicable criteria are met.

### Checkout UX

- [ ] Mobile single-page checkout exists.
- [ ] Express Checkout renders above card payment.
- [ ] Apple Pay/Google Pay/Link appear dynamically when available.
- [ ] Payment Element works as fallback.
- [ ] Student email is the only Cramapple-owned required identity field before payment.
- [ ] No password is required before payment.
- [ ] No shipping fields are present.
- [ ] Promo entry is collapsed by default.
- [ ] Sticky payment CTA includes current total.
- [ ] "Ask a Parent to Pay" is visible without abandoning checkout.

### Direct purchase

- [ ] Anonymous new student can pay.
- [ ] Existing student can pay.
- [ ] Verified webhook creates/grants correct subject entitlement.
- [ ] Success redirect alone cannot grant entitlement.
- [ ] Duplicate webhook does not double-grant.

### Parent payment

- [ ] Student can generate a parent link.
- [ ] Link opens without Cramapple login.
- [ ] Parent can pay without creating a Cramapple account.
- [ ] Parent payer identity does not become entitlement owner.
- [ ] Student receives access after verified payment.
- [ ] Copy/share/email actions work.
- [ ] Parent email endpoint is rate-limited.

### Promotions

- [ ] Promo URL parameter can auto-apply.
- [ ] Promo entry is hidden until requested.
- [ ] Invalid promo does not break checkout.
- [ ] Server remains authoritative for total.

### Confirmation

- [ ] Confirmation page verifies payment/entitlement server-side.
- [ ] Processing state handles delayed webhook.
- [ ] Student receives activation guidance.
- [ ] Parent gets payer-specific confirmation.

### Add-on

- [ ] Single-subject successful purchase can expose eligible add-on.
- [ ] Add-on never blocks access to original purchase.
- [ ] Exact add-on charge is disclosed before action.
- [ ] Server determines add-on amount and eligibility.
- [ ] Saved payment reuse complies with Stripe flow.
- [ ] Authentication-required fallback works.
- [ ] Add-on entitlement is granted only after verified charge success.

### Reliability / security

- [ ] Webhook signature verification retained.
- [ ] Event idempotency retained.
- [ ] No raw card data stored.
- [ ] No Stripe secret/client secret exposed in logs.
- [ ] Paid-without-access failure can be reconciled.
- [ ] Refund handling remains correct.

---

## 21. QA evidence required

Independent QA should capture:

- viewport screenshots for iPhone-sized checkout states;
- evidence of available/unavailable wallet behavior;
- Stripe test session IDs;
- webhook event IDs;
- resulting `app.subject_entitlements` rows;
- duplicate-event replay evidence;
- parent-share session metadata;
- new-student account provisioning evidence;
- existing-student entitlement evidence;
- promo calculations;
- add-on original PaymentIntent/session + add-on charge;
- refund/revocation evidence;
- PostHog/growth-event event traces where applicable.

QA must be in a fresh context separate from implementation, per the Cramapple operating model.

---

## 22. Explicit hard gates / implementation blockers

This spec is build-ready as a technical design, but the following remain governed gates:

1. TASK-0041 execution approval.
2. Any Stripe sandbox catalog/config write under the current TASK-0041 approval record.
3. Any live Stripe catalog/config write.
4. Live-mode sales enablement.
5. Production deployment.
6. BIZ-001 closure for access/refund/discount/parent policy.
7. Final approved add-on discount/offer.
8. Pricing resolved by `DECISION-0083`: $39.99 / $69.99 / $89.99.

An AI implementation agent must stop at any of these boundaries unless the canonical approval record explicitly clears it.

---

# 23. Alternate concepts and recommendations — NOT part of required implementation

Everything below this heading is advisory and must not be silently implemented as part of the main specification.

## A1. Consider on-session rather than off-session semantics for the immediate add-on

The supplied plan describes the post-purchase add-on as an "off-session charge." The customer is actually still on the confirmation page and actively tapping the add-on CTA.

A cleaner implementation may classify the add-on as an **on-session saved-payment purchase**, using the saved Customer/payment method while the customer is still present. This reduces conceptual mismatch and gives Stripe a more natural authentication path when required.

The product behavior remains "one tap when possible."

## A2. Prefer "parent share" over "parent gift" language in the student UX

The current backend calls the feature `parent_gift`. The user mental model is different: the student is asking a parent to pay for the student's own study plan.

Recommendation:

- retain `parent_gift` for backward compatibility;
- introduce `parent_share` for the new funnel;
- use "Ask a Parent to Pay" in UI.

## A3. Avoid the phrase "256-bit encrypted checkout"

The supplied design calls for "Secure 256-Bit Encrypted Checkout." Unless Cramapple has a precise, verified basis for that claim, a safer trust message is:

`Secure payment powered by Stripe`

This is simpler, recognizable, and avoids an unnecessary technical marketing claim.

## A4. Bundle pricing — RESOLVED 2026-09-28

The Product Owner set the two-subject bundle to **$69.99** and three-subject bundle to **$89.99** in `DECISION-0083`. The immediate post-purchase second-subject upgrade is implemented as the **$30.00 difference** between a $39.99 single purchase and the $69.99 two-subject total.

## A5. Consider post-purchase subject selection rather than a hard-coded add-on

Instead of offering one predetermined subject, the success page could offer:

`Add another AP subject for [approved price]`

and let the student choose from eligible subjects.

Advantages:

- better fit for students taking different AP combinations;
- avoids irrelevant upsell;
- can use the same server-side add-on offer logic.

Tradeoff: one extra interaction.

## A6. Consider expiring parent-payment links sooner than Stripe's maximum

A long-lived payment link can become confusing if pricing, selected subjects, or student state changes.

Consider a product-level expiration such as 24–72 hours and regenerate after expiration.

## A7. Consider masking student email on the parent page

Instead of:

`Access for student@school.edu`

use:

`Access for s***@school.edu`

when the payment URL could be forwarded.

## A8. Consider delaying account invitation until after payment

The required implementation already provisions/invites only after verified payment. Preserve this property. Do not create abandoned Supabase Auth accounts merely when a student opens checkout or generates a parent link.

## A9. Measure parent-share conversion as its own funnel

Parent share is not merely an alternate payment button. Instrument:

`ask_parent_opened -> parent_link_created -> parent_checkout_opened -> parent_purchase_completed`

This will show whether the feature solves student payment friction or just moves abandonment later.

## A10. Consider a Stripe-hosted fallback route

If Custom Checkout Sessions / Elements cause launch risk, retain a hidden operational fallback:

`/checkout/hosted`

that creates the already-proven hosted Checkout Session.

Do not expose two checkout choices to the user. This is an operational rollback/fallback path only.

---

## 24. Source references

Canonical Cramapple references:

- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`
- `docs/INDEX.md`
- `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`
- `docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`
- `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`
- `supabase/functions/create-checkout-session/index.ts`
- `supabase/functions/stripe-webhook/index.ts`

External implementation reference supplied by Product Owner:

- Google Doc: Cramapple high-converting mobile checkout & purchase flow, 2026-09-27.

Stripe implementation assumptions were checked against current Stripe documentation on 2026-09-27; the implementation agent must re-check the installed SDK/API version before execution.
