# Lovable prompt — Reddit Pixel + "Do Not Sell or Share" opt-out (marketing, 2026-10-25)

**Project:** Lovable "New Cramapple Marketing" `61dd6602`, written against commit `db106773`. **Not sent yet.**
**Owner decisions behind it (David, 2026-10-25):** install Reddit Pixel `a2_jws6uftcrlca`; put the opt-out on `/ap-biology-prep`.
**Not covered here:** the day-7 trial conversion `Purchase`, which needs Reddit's Conversions API from the backend (separate
task); Privacy Policy wording (David / lawyer); Reddit Ads Manager settings (keep "advanced matching" and any automatic
event setup **off**, so Reddit never receives emails or other personal data).

---

```text
Add the Reddit Pixel to the marketing site with a "Do Not Sell or Share My Personal Information" opt-out. Do not change any page copy, layout or styling except what is listed here. Do not touch checkout logic, Stripe, Supabase, PostHog behaviour or Microsoft Clarity.

1. New module src/lib/reddit-pixel.ts (mirror the style of src/lib/posthog.ts):
   - Pixel id constant: "a2_jws6uftcrlca".
   - Load Reddit's script (https://www.redditstatic.com/ads/pixel.js) and call rdt('init', id) ONLY when ALL of these are true:
     a. the site runs on a production host: reuse detectEnvironment(window.location.hostname, !import.meta.env.DEV) from src/lib/posthog.ts and require "production" (never on Lovable previews, localhost or ?backend=dev);
     b. the route is not /login, /signup or /tutor-login (same rule as shouldDisableOnRoute in posthog.ts);
     c. the visitor has not opted out (step 3);
     d. the browser does not send Global Privacy Control: navigator.globalPrivacyControl !== true. A GPC signal counts as an opt-out.
   - Exported helpers, each a no-op when the pixel is not loaded:
     trackRedditPageVisit() → rdt('track', 'PageVisit')
     trackRedditSignUp() → rdt('track', 'SignUp')
     trackRedditPurchase(valueDollars?: number) → rdt('track', 'Purchase', { value, currency: 'USD' }) (omit value when unknown)
   - Never pass email, name, phone, user id, Stripe ids, subject names or any other field to Reddit. No advanced matching, no "em"/"externalId" fields. Only the event name, plus value and currency for Purchase.

2. Wiring:
   - In src/routes/__root.tsx RootComponent, next to the existing initPostHog() effect: initialise the Reddit pixel once and send trackRedditPageVisit() on first load and after every client-side navigation (subscribe to the router's resolved/navigated event; one PageVisit per navigation, no duplicates on re-render).
   - In src/components/checkout/PaymentResult.tsx, inside the existing effect that sends captureCheckout("payment_confirmed") (guarded by confirmedRef so it fires once):
     when trialView === "trialing" → trackRedditSignUp();
     when view === "unlocked" (pay-now) → trackRedditPurchase(server.amount_total / 100 when amount_total is a number, else no value).
     Both parent and student roles. No other pages send SignUp or Purchase.

3. Opt-out (stored per browser, works site-wide):
   - Store the choice in localStorage key "cramapple_privacy_optout" = "1" (wrap reads/writes in try/catch; if storage is unavailable, treat the visitor as opted out for safety).
   - Exported helpers in src/lib/reddit-pixel.ts: isAdTrackingOptedOut() (true if the stored flag is set OR navigator.globalPrivacyControl === true) and setAdTrackingOptOut(true|false).
   - When a visitor opts out on the page: save the flag and stop any further Reddit calls on this page immediately (the helpers check the flag before every call). The script already loaded does not need removing; nothing more is sent to Reddit after opting out.
   - Opting back in only clears the stored flag; the pixel starts again on the next page load. If GPC is on, show that the browser's Global Privacy Control signal is honoured and the visitor is opted out regardless.

4. /ap-biology-prep (src/routes/ap-biology-prep.tsx), footer only:
   - Add one more footer link after "For Parents": "Do Not Sell or Share My Personal Information". Same style as the other footer links.
   - It opens an accessible dialog (focus moves into it, Escape and a Close button close it, focus returns to the link) with this text:
     Title: "Do Not Sell or Share My Personal Information"
     Body: "We use an advertising pixel from Reddit on this site to measure whether our Reddit ads lead to visits, free trials and purchases. Under some state privacy laws, that counts as sharing your information for advertising. You can opt out here. We never send your name or email address to Reddit."
     Status line: "You are opted in." or "You are opted out." (or "Your browser's Global Privacy Control signal is on, so you are opted out.")
     Primary button: "Opt out" (or "Opt back in" when opted out; hidden when GPC is on).
     Secondary link: "Read our Privacy Policy" → /privacy.
   - Build the dialog as a reusable component (src/components/privacy/PrivacyChoicesDialog.tsx) so other footers can add the same link later. Only add it to /ap-biology-prep in this change.

5. Tests (vitest, next to the existing posthog tests):
   - The pixel does not load on a non-production host, on /login, when the opt-out flag is set, or when navigator.globalPrivacyControl is true; it does load on cramapple.com otherwise.
   - trackRedditSignUp/trackRedditPurchase send nothing after setAdTrackingOptOut(true).
   - Purchase sends only { value, currency } and never any other field.
   - The /ap-biology-prep footer shows the link; the dialog toggles the stored flag and its status text.

Reply with the files you changed and the test results. Do not publish.
```

---

## Check after Lovable replies (before David publishes)

- Read the diff by commit SHA (`list_edits` / `get_diff`), not just the reply.
- In the preview: no request to `redditstatic.com` (previews are non-production by design). On the published site, Reddit's
  Pixel Helper / Events Manager shows `PageVisit`; a test trial start shows `SignUp`.
- With the opt-out set, or with a GPC browser, no requests go to `alb.reddit.com` / `pixel-config.reddit.com`.
- Privacy Policy: David (with the lawyer) adds Reddit as an advertising partner and describes the opt-out and GPC handling.
  Many visitors are under 18; California requires opt-in for sharing the data of under-16s, which this opt-out flow does not
  provide. That is a legal call, not something this change settles.

## Follow-up prompt (David, 2026-10-25): the opt-out on the homepage footer too

Sent after the first prompt finished, so the two changes do not race.

```text
Add the same "Do Not Sell or Share My Personal Information" footer link to the homepage (src/routes/index.tsx), using the PrivacyChoicesDialog component you just built. Place it after "For Parents" in the homepage footer, same style as the other footer links, same dialog behaviour and text. Change nothing else on the homepage. Add a test that the homepage footer shows the link and that it opens the dialog. Reply with the files you changed and the test results. Do not publish.
```

## Outcome so far (2026-10-25)

- First prompt → Lovable commit **`5d69b73e`** (269 tests), **published by David**. Review: guards, events, payload and dialog
  correct, but **the live pixel sent nothing**. On cramapple.com/ap-biology-prep, `window.rdt.sendEvent` existed while
  `callQueue` still held `init` and `PageVisit`, and the only Reddit request was `pixel.js`. Cause: the queue stub never calls
  `sendEvent`, and `init`/tracks run after the script loads. The dialog also had no focus trap.
- Second message (sent instead of the homepage-only follow-up above): fix the stub to forward to `sendEvent` like Reddit's
  snippet, add a focus trap, and add the homepage footer link, with tests. Needs review and a publish; then check on
  cramapple.com that event requests reach Reddit.
- Fix → Lovable commit **`b57aeb43`**, **published by David**. Reviewed by diff: the stub forwards to `sendEvent` (queues only
  before load), focus trap and Escape in the dialog, homepage footer link, tests for each; nothing else changed.
- **Live check on cramapple.com (2026-10-25):** `/ap-biology-prep` loads `pixel.js`, fetches the pixel config and sends
  `alb.reddit.com/rp` with only `event=PageVisit&id=a2_jws6uftcrlca`; the queue is empty. The dialog opens with the specified
  text; "Opt out" sets `cramapple_privacy_optout=1` and shows "You are opted out."; the next page (homepage) loads no Reddit
  script and makes no Reddit requests. The homepage footer shows the link after "For Parents".
- Not checked live: `SignUp` on a real trial start and `Purchase` on a pay-now purchase (covered by tests). Design note: the
  dialog's "Opt out" control is styled as plain text rather than a button.
