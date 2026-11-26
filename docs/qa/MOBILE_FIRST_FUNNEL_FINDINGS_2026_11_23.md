# Mobile-first funnel audit and first changes (2026-11-23)

**Status:** Findings plus one app PR (not merged, not published). **Owner:** David Bloom.
**Method:** built-in browser at 375x812 (and 768x1024 for the changed page) against live `cramapple.com` and `app.cramapple.com`, signed out; source read in a fresh clone of `david-bloom/ap-prep-blueprint` at `e88d633`. Evidence images: `docs/qa/evidence/mobile_first_2026_11_23/`.
**Not checked:** anything behind sign-in on production (hub, live `/question`, `/hub-mock` content, the email-code step, a real trial start). No form was submitted, so no email was sent. Clarity and PostHog were not opened. The question page was checked only through the local dev harness (`/dev-qx-harness`, Chemistry fixtures).

## 1. Headline

The picture in `CONVERSION_REVIEW_HOME_AND_SUBJECT_LANDING_PAGES_2026_10_31.md` is out of date. Since then the marketing pages gained a subject chooser, a real hero question, an FAQ and "no card needed", and **every landing CTA now goes to `app.cramapple.com/start?subject=<key>`** (the no-card trial, DECISION-0135), not `/checkout`. Measured at 375px, none of the pages I opened scroll sideways, text inputs are 16-17px (no iOS zoom), and the question page (via harness) has no target under 44px and no text under 16px. The mobile base is sound. The gaps are narrower.

## 2. Ranked findings

| # | Finding | Evidence | Status |
| --- | --- | --- | --- |
| 1 | **`/start` was a context-free email box.** A student who tapped "AP Biology" saw "Start your free trial" with no subject, no "7 days, no card" reassurance, and a half-width button. | `02_live_start_before_375.jpg` | **Fixed in app PR 65** (`03`, `04`). Low risk, copy matches DECISION-0135 and the marketing page. |
| 2 | **Legacy `/checkout` still tells the old story and is still reachable.** First paint: "Total due today $39.99", disabled "Place order", ten subject tiles when no `?subjects=`. At 375px the "Secure payment powered by Stripe" text collides with the wordmark in the orange bar. No current marketing CTA links there, but ads, emails and bookmarks may. | `01_live_checkout_375.jpg`; link audit of `/`, `/ap-stem-prep` | **OPEN** (marketing Lovable `61dd6602`): decide redirect vs retire. Prompt in section 4. |
| 3 | **Small tap targets on marketing pages.** "study guides →" links (10 per page) 40px; header links, "Log in" 40px; login "Create an account" 22px, "Student login" 26px, submit 42px; "Terms"/"Privacy" 36px; checkout "Change", promo toggle 24px. Floor in the app is 44px (`.cm-btn`). | JS measurement, 375px | **OPEN** (Lovable prompt, S-effort). |
| 4 | **Marketing login email input has no `inputMode`/`autocapitalize` hints.** Autocomplete is set and size is 17px, so low impact. | login DOM | **OPEN** (same prompt). |
| 5 | **Eyebrow 13px and "ANY ONE AP STEM SUBJECT" 15px** on `/ap-stem-prep`. Chrome, not content; within the design-system chrome exception. | DOM | Informational. |
| 6 | **Hub redesign (`/hub-mock`) is not evaluable signed out** (redirects to login). Its open items (phone fixes, 18px floor, laptop check) cannot be advanced from here. | navigate | **OPEN**, needs David's signed-in screenshots or a test account. |
| 7 | **Evidence gap:** no per-step mobile funnel data after the 10-31 review. No numbers here on whether the new landing pages convert. | not opened | **OPEN** (Clarity recordings for `/ap-stem-prep` and `/start`; PostHog `landing_view` to `/start` visits). |
| 8 | **Sign-in code step not exercised.** Source shows a 6-digit `one-time-code` input with numeric keypad; autofocus added in PR 65. Whether the email actually arrives/links work on a phone is unverified. | source only | **OPEN**, needs one real-inbox test on a phone. |

## 3. Decided versus open

**Decided (basis):** one responsive frame, orange/light/square/zero-motion, body copy floor 16px (D3/D4, DECISION-0075); no-card single-subject 7-day trial entering at `/start` (DECISION-0135); phone-first hub with two big choices is *owner direction only*, no DECISION yet.

**Open, needs David:**
1. Retire or redirect `/checkout` (finding 2)? It carries the pay-now path used by the paywall/parent flow, so do not delete without a decision.
2. Ratify the phone-first hub decisions (two-path first screen, no emphasised door, 18px floor) as DECISIONs, per the 2026-11-08 session close.
3. Is a 44px tap-target floor for marketing pages wanted as a stated rule (the app already does it)?
4. Authorise a signed-in phone walkthrough (a test account, or David's screenshots) for hub, live `/question` and `/hub-mock`.
5. Publish: app PR 65 merges to app `main` only after David's go; publishing in Lovable is David's call and ships everything on `main`, so check for unreleased app PRs first (lesson from the 2026-11-04 spinner incident).

## 4. Lovable prompt (marketing project 61dd6602; not sent)

```
Mobile tap targets and checkout header. (1) Every link or button on /, /ap-*-prep, /ap-stem-prep, /login and /checkout
gets min-height 44px (pad the hit area; keep the visual size). This includes "study guides →", header "Log in",
"Student login", "Create an account", Terms/Privacy footer links, and the checkout "Change" and promo-code toggle.
(2) /login email input: add inputMode="email", autoCapitalize="none", spellCheck={false}, enterKeyHint="go".
(3) /checkout at widths under 480px: put "Secure payment powered by Stripe" on its own line under the wordmark
instead of beside it (it currently overlaps). Do not change any request body, Terms text, promo logic or fonts.
```

## 5. What was changed (app PR 65, `ap-prep-blueprint`, branch `claude/mobile-first-start-page-2026-11-23`)

- `/start` heading echoes the subject from `?subject=` and adds "7 days of full access. No card needed."
- All `RegisterForm` action rows stack and fill the row at 640px and below.
- Email input: `enterKeyHint`, `autoCapitalize="none"`, no spellcheck; the code input autofocuses.
- Verified: `tsc` clean, 1397/1397 tests pass (one test added), local dev server at 375 and 768 (`03`, `04`). Not verified: the code step on a real phone, and iOS autofocus behaviour (iOS may decline to raise the keyboard without a tap).
