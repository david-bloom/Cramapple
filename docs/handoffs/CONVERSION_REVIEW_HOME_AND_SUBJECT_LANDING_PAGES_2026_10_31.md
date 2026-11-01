# Conversion review — home page and subject landing pages (2026-10-31)

**Status:** Review and handoff (no code changed). **Owner:** David Bloom. **Scope:** `cramapple.com/`,
`/ap-biology-prep` (and the other `*-prep` pages built from the same component), plus `/ap-stem-prep`, because that is
where almost all paid Reddit traffic actually lands. The checkout first screen is included because it is the single
largest leak for every landing page.
**Inputs:** Reddit Ads hourly export "First Reddit report.csv" (2026-10-25 22:00 ET to 2026-10-31 12:00 ET), PostHog
events (project 559891), Production `app.trial_orders`, the live pages on a 375×812 viewport and desktop, and the
marketing Lovable source (`61dd6602`, HEAD on 2026-10-31).
**Related:** `marketing/AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md`, `product/REDDIT_CONVERSIONS_API_DAY7_PLAN_2026_10_25.md`,
`tasks/TASK-0077-PRODUCTION-RUNBOOK.md`, `qa/CHECKOUT_SOL_BROWSER_QA_2026_10_06.md` (B1/B2 are still live).

## 1. The headline

Six days of Reddit spend produced **zero trials**. Not a low rate: zero.

| Step (2026-10-25 → 10-31) | Reddit visitors | All visitors |
| --- | --- | --- |
| Landing view (people) | 415 | ~560 |
| Reached `/checkout` | 5 (1.2%) | 17 |
| `checkout_started` | 0 | 3 (all 10-25; David's own test orders) |
| Trial started / purchase (Production `trial_orders`) | 0 | 0 real |

Spend in the same window: $573 (two campaigns, 365 clicks, $1.57 average CPC). 96% of clicks came from phones
(iOS 77%, Android 19%), and most arrive in Reddit's in-app browser (PostHog shows them as `$direct`).

Where the traffic went: **Launch Pilot 50% Discount → `/ap-stem-prep`** (~409 people), **AP Biology → `/ap-biology-prep`**
(~31 people). The home page received almost no Reddit traffic (1 person); its ~130 sessions were Facebook, direct and
your own testing. So "home page conversion" is today a Facebook/direct question and "subject page conversion" is the
Reddit question.

Reddit's "Total Results" column (175 on AP Biology, more than its 59 clicks) is a pixel `PageVisit`, mostly view-through.
It is not a conversion signal; ignore it when judging the ads.

## 2. What is measurable and what is not

- The marketing site sends PostHog **named events only**: `autocapture`, `capture_pageview`, `capture_pageleave` and
  `capture_performance` are all off (`src/lib/posthog.ts`). A session therefore has one event (`landing_view`) unless the
  student clicks a CTA (`checkout_viewed`). "Session duration" is meaningless here; scroll depth and time on page do not
  exist in PostHog.
- What we can say: on `/ap-stem-prep`, **92% of sessions never fired a second event** (403 of 439); `/ap-biology-prep` 75%;
  `/` 72%. The product-side read is "no CTA tap", not "left in 3 seconds".
- Microsoft Clarity is installed on every page (`__root.tsx`). Its recordings and scroll-depth heatmaps for
  `/ap-stem-prep` on mobile are the fastest way to see whether people read the page at all. Nobody has looked yet.
- No web-vitals data exists for the marketing pages. Load weight measured by hand: home/bio hero JPEG **1.53 MB**
  (preloaded, `fetchpriority=high`), main script bundle **908 KB**, and a Google Fonts request for **nine families**.
  `/ap-stem-prep` has no hero image, and its no-tap rate is the worst of the three, so weight is not the whole story,
  but it is a cheap fix and the in-app browser on cellular is the worst case.

## 3. Findings (evidence-labelled)

**F1 — The promise breaks on the first checkout screen. [Observed, live + source]**
Every landing CTA says "Try for free" / "Start free trial", "7 days free, then $39.99". The checkout's first paint says
**"Total due today $39.99"**, a disabled **"Place order"** button, and "Secure payment powered by Stripe". The trial
heading ("Your first 7 days are free"), the $0-today line and the "Start my free trial" label render **only after an
email is entered** and the server returns a trial quote (`TrialHeader` in `src/components/checkout/TrialOffer.tsx`;
`trialActive ? TRIAL_BUTTON_LABEL : "Place order"` in `src/routes/checkout.index.tsx`). The runbook recorded this
state on 2026-10-21 ("checkout shows $39.99 pay-now as today") and it is unchanged. A 16-year-old who tapped "free" and
sees "$39.99 due today, Place order" has every reason to close the tab. The 5 Reddit visitors who reached checkout all did.

**F2 — The STEM page sends people to a bare `/checkout` with ten checkboxes. [Observed]**
`/ap-stem-prep` links to `/checkout` with no subject. On a 375×812 phone the email field sits at y=820, below the fold,
behind 10 subject tiles; the sticky bar says "3 steps left". QA item B1 (2026-10-06) flagged exactly this and it is still
live. `/ap-biology-prep` already passes `?subjects=ap-biology`, which collapses the picker to one line.

**F3 — The 50%-off campaign lands on a full-price page with no code. [Observed; ad copy unverified]**
Ad URLs carry only `rdt_cid` (no UTMs, no `promo`). The landing page shows $39.99 with no discount, and checkout applies
nothing. `/checkout?promo=CODE&subjects=KEY` already works (promo auto-applies after email). If the creative says "50%
off", the arrival experience contradicts it; if it does not, the campaign name is misleading internally. Either way,
PostHog cannot tell the two campaigns apart (`utm_campaign` is null on every paid landing view; channel classifies as
`other`/`direct`), despite the UTM convention in `AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md`.

**F4 — Home and subject pages show no product and no proof above the fold. [Observed]**
Hero = stock photo of a student + three generic bullets ("1000s of vetted and verified MCQs and FRQs", "Focus on getting
the most point from each answer" (typo), "Personalized feedback, cheat sheets and progress tracking"). The only product
visual is a desktop screenshot that is unreadable at phone width. There is no sample question, no rubric example, no unit
list, no FAQ (what happens on day 7, how to cancel, parent pays, refund), and no evidence for any claim. The biology page
is the home page with "Biology" substituted into the headline (`Homepage subject={...}`); nothing on it is about AP
Biology.

**F5 — Mixed offer language on one screen. [Observed]**
Three pricing cards: "Get started" / "Try for free" / "Get started"; "one-time" vs "Pay once for the year"; bundles say
"Buy now" under a heading that says "start with a 7-day free trial". The subject list at the bottom ("More points, less
effort, better sleep") links to study-guide hubs, not to a trial, so the one place a student can choose a subject does not
start one.

**F6 — Mobile weight. [Measured, not yet tied to behaviour]** See §2. Target: LCP under 2.5 s on a mid-range Android.

## 4. Recommendations

Priority is impact × effort. Items 1–2 are cross-cutting and come first; they fix the leak every landing page drains into.

### 4.0 Cross-cutting (do before any landing-page copy work)

1. **Checkout first paint must match the landing promise** (fixes F1). When the trial gate is on, render the trial
   framing before email: heading "Your first 7 days are free", order summary "Total due today **$0.00**" plus "Then
   $39.99 on the day your trial ends (we'll show the exact date next)", button label "Start my free trial" from the
   start, and a one-line "Cancel from your account before it ends and you pay nothing." The server quote still owns the
   real date and amount once email is entered; the pre-email state is a placeholder, not a promise of a different price.
   Keep the Terms tick and mandate text exactly as they are.
2. **Ad URL hygiene** (fixes F3, no code): every Reddit ad link gets
   `?utm_source=reddit&utm_medium=paid_social&utm_campaign=<slug>&utm_content=<ad id>` and, for the discount campaign,
   `&promo=<CODE>`; subject-specific ads add `&subjects=<key>` on the landing URL so it passes through to checkout.

### 4.1 Home page (`/`) — five changes

| # | Change | Why | Effort |
| --- | --- | --- | --- |
| H1 | **Prove the product in the hero.** Replace the stock photo with a phone-sized, readable product frame: one real MCQ (or one FRQ rubric line) with the "why this earns the point" explanation. Headline: "Know exactly what earns the point on every AP question." Sub: "Practice built from the rubric, unit by unit, in 15 minutes a day." CTA: "Start 7-day free trial"; note under it: "Nothing charged today. $39.99 one-time after the trial. Cancel anytime." | F4, F5 | M |
| H2 | **One offer, one label, one price story.** Every button says "Start free trial". Pricing heading: "Free for 7 days, then one-time pricing". Remove "Buy now" and "Pay once for the year" wording. Add a four-question FAQ under pricing: what happens on day 7, how to cancel, "my parent pays" (text link), refund policy. Fix "most point". | F5 | S |
| H3 | **Subject chooser that starts a trial.** Replace the study-guide list with six large tap targets ("AP Biology →" …) linking to `/checkout?subjects=<key>`; keep "study guides" as a small secondary link per subject. | F2, F5 | S |
| H4 | **Replace the three generic bullets with verifiable facts** pulled from the catalog (published MCQ/FRQ counts per subject, "every wrong answer explained", "FRQs scored line by line against the rubric", "hand-drawn answers graded from a photo"). No testimonials or score claims until GTM-001's evidence rules exist. | F4 | S |
| H5 | **Mobile weight.** Hero image ≤150 KB (AVIF/WebP, `srcset` with a 750 px mobile size), lazy-load everything below the fold, cut Google Fonts to the families and weights the page uses (`docs/new_design/`: Bungee, Passion One, Source Sans 3). | F6 | S |

### 4.2 Subject landing pages (`/ap-biology-prep` and siblings) — five changes

| # | Change | Why | Effort |
| --- | --- | --- | --- |
| S1 | **Make the page about the subject.** Headline aimed at the moment the student is in: "Unit test coming up in AP Bio? Learn what earns the point before it does." Above the fold: one real AP Biology question with its scoring explanation, readable at 375 px. Below: the units covered (Units 1–8, with topic counts) and a "Bio study guides" link as secondary. | F4 | M |
| S2 | **Carry the subject and the offer through to checkout.** Keep `?subjects=ap-biology`; with 4.0 item 1 in place, the first checkout screen reads "AP Biology · Your first 7 days are free · $0.00 today". Button label consistent end to end: "Start free trial" → "Start my free trial". | F1, F2 | S (after 4.0) |
| S3 | **Honour a promo on arrival.** Read `?promo=` on the landing route, show a banner ("50% off applied: $19.99 after your free trial, code BIOLOGY50") and forward it to `/checkout?subjects=…&promo=…`. Without a code, no banner. | F3 | S |
| S4 | **Proof + FAQ + single CTA style.** Same H2/H4 treatment: one CTA label, FAQ, verifiable facts; drop the bundle cards here (one subject page = one subject offer; mention "add a second subject later" instead). | F5 | S |
| S5 | **Instrumentation so the next review can measure.** Add `landing_cta_clicked` (props: `route`, and a new allow-listed `cta_position`) and turn on `capture_pageleave` (it carries scroll depth) for the marketing routes. Until then, use Clarity. | §2 | S |

### 4.3 `/ap-stem-prep` (current Reddit destination) — three changes

The headline ("First AP unit was tough? The next one doesn't have to be.") is the best copy on the site; keep it.

- **T1** Subject picker on the page (six tap targets) → `/checkout?subjects=<key>`; the generic "Start free trial"
  button stays but goes to the picker, not to the 10-checkbox checkout. (F2)
- **T2** Crop the app screenshot to a phone-readable single question; add the proof lines and the FAQ. (F4)
- **T3** Promo banner from `?promo=` as in S3; add UTMs to the ad URL. (F3)

## 5. Lovable prompts (paste one at a time, review each commit by SHA before David publishes)

Guardrails for every prompt: do not change any backend call, request body, Terms text or the trial mandate text; do not
add fonts or new colours; keep `src/lib/posthog.ts`'s property allow-list rule (add a key only by extending
`ALLOWED_PROPS`); do not touch `src/lib/attribution.ts`; run the existing tests.

### Prompt A — checkout first paint matches the free-trial promise (4.0 item 1)

```
In src/routes/checkout.index.tsx and src/components/checkout/TrialOffer.tsx: when the trial checkout gate is on
(isTrialCheckoutEnabled) and there is no server quote yet, render a pre-quote trial state instead of the pay-now state.
Specifically, before an email is entered: (1) show the heading "Your first 7 days are free" with the line
"Nothing is charged today. Add your email and a card to start." where TrialHeader renders today; (2) in the order
summary show "Total due today $0.00" and a second line "Then $39.99 per subject on the day your trial ends" (use the
list price for the chosen subjects; the exact date and amount still come only from the server quote once it exists);
(3) label the sticky button "Start my free trial" (TRIAL_BUTTON_LABEL) from the start, still disabled until the form is
valid; (4) keep "Secure payment powered by Stripe" but move it to a smaller line under the button. When the server quote
arrives, replace the placeholder with the quote-driven lines exactly as today. If the quote returns pay_now, fall back to
today's pay-now rendering. Do not change the Terms checkbox, the mandate text, any request to create-checkout-session,
or any promo logic. Add tests for the pre-quote trial rendering and the pay_now fallback.
```

### Prompt B — subject chooser on the home page and the STEM page (H3, T1)

```
Home page (src/components/Homepage.tsx, section "More points, less effort, better sleep"): replace the list of
study-guide links with a chooser of six large tap targets (full width on mobile, min height 56px): AP Biology,
AP Statistics, AP Chemistry, AP Physics, AP Calculus AB, AP Calculus BC, AP Precalculus. Each links to
/checkout?subjects=<checkoutKey> using the keys in src/lib/prep-pages.ts (physics → ap-physics-c-mechanics; for the
three calculus options link to /checkout?subjects=ap-calculus-ab, ap-calculus-bc, ap-precalculus). Heading: "Pick your
subject and start free". Under each target add a small secondary link "study guides →" to the existing hub route.
STEM page (src/routes/ap-stem-prep.tsx): add the same chooser directly under the hero offer block, and make the hero
"Start free trial" button scroll to the chooser (id="pick-subject") instead of linking to bare /checkout. Keep the
pricing card's button linking to /checkout?subjects=ap-biology as a default. Use existing classes/tokens from
makeover-home.css and homepage-mockup.css; no new fonts.
```

### Prompt C — hero proof block on home and subject pages (H1, S1, H4)

```
In src/components/Homepage.tsx: replace the hero stock photo (homepage-mockup-girl-hero.jpg) with a product frame
component <HeroQuestionCard subject=...> that renders one real question at phone-readable size (min 16px body text at
375px): the question stem, the four choices with the correct one marked, and a two-sentence "Why this earns the point"
explanation. Source the question from a new src/data/hero-questions.ts with one entry per PREP_SUBJECTS key plus a
default; I will supply the question text (use clearly-labelled placeholder text until then and keep it out of
production). New hero copy: eyebrow unchanged; h1 "Know exactly what earns the point on every AP {subject} question.";
lead "Practice built from the rubric, unit by unit, in 15 minutes a day."; button "Start free trial"; note "Nothing
charged today. $39.99 one-time after your 7-day trial. Cancel anytime." Replace the three "01/02/03" bullets with three
facts I will confirm (leave TODO markers): "<N> published MCQs and <M> FRQs for AP {subject}", "Every wrong answer
explained, every FRQ scored line by line against the rubric", "Hand-drawn answers graded from a photo". Fix the typo
"most point". Keep the lazy-loaded desktop screenshot section but crop it to a single question on mobile.
```

### Prompt D — one offer, one label, FAQ, and promo banner (H2, S3, S4, T3)

```
Across src/components/Homepage.tsx and src/routes/ap-stem-prep.tsx: (1) every CTA button reads "Start free trial"
(aria-labels updated); (2) pricing heading "Free for 7 days, then one-time pricing"; remove the words "Buy now" and "Pay
once for the year"; on subject pages (Homepage rendered with a subject) hide the two bundle cards and add one line "You can
add more subjects later from your account." under the single card (no price: the trial flow has no second-subject
offer today, so do not present the bundle difference as one); (3) add a <PricingFaq> accordion with four items: "What happens on
day 7?" (your card is charged the one-time price for your subject, the exact date is shown at checkout), "How do I
cancel?" (from your account, any time before the trial ends, and you pay nothing), "Can a parent pay?" (yes, checkout
has "Ask a parent to pay", which texts or emails them a link), "Refunds?" (link to the existing refund policy); (4) read
the `promo` search param on `/`, the `*-prep` routes and `/ap-stem-prep`; when present, show a banner above the hero
offer "Code {CODE} applied: {discounted price} after your free trial" (compute the display price from a small map of
known codes to percent off that I will supply; unknown codes show "Code {CODE} will be applied at checkout") and append
`promo=` to every checkout link on the page. Use existing tokens; the banner uses the brand orange tint with ink text.
```

### Prompt E — mobile weight and instrumentation (H5, S5)

```
(1) Export homepage-mockup-girl-hero.jpg and calculus-prep-hero.jpg as AVIF and WebP at 750px and 1376px widths,
serve them with <picture>/srcset, target under 150 KB for the mobile variant, keep width/height attributes and
fetchpriority="high" on the hero only; lazy-load every other image. (2) In src/routes/__root.tsx trim the Google
Fonts request to Bungee, Passion One (400;700) and Source Sans 3 (400;600;700) and STIX Two Math; search the codebase
for any remaining use of Plus Jakarta Sans, JetBrains Mono, Archivo Black or Nunito Sans and either replace it with a
token font or keep only that family. (3) In src/lib/posthog.ts set capture_pageleave: true for the marketing routes
(leave autocapture, pageview and session recording off) and add "cta_position" to ALLOWED_PROPS; add
captureLandingCtaClicked({ route, cta_position }) and call it from every landing CTA (positions: hero, pricing,
benefits, chooser, band). Update the posthog tests.
```

## 6. Operational checklist (not Lovable)

- [ ] Rebuild both Reddit ad URLs with UTMs (+ `promo`, + `subjects` where the ad is subject-specific); confirm by
      opening one ad in a private window and reading `landing_view` properties in PostHog.
- [ ] Watch five Clarity recordings of `/ap-stem-prep` on mobile from 10-26 to 10-30 before approving copy changes;
      note where the scroll stops.
- [ ] Decide the discount campaign's real promise (free trial vs 50% off vs both) and make the creative, landing banner
      and checkout say the same thing.
- [ ] Confirm `TRIAL_ADMISSION_ENABLED` is still on in Production (the pre-email checkout shows pay-now by design, so the
      live page alone cannot prove the trial is on).
- [ ] After Prompt A is published, run one tagged trial (the still-open item from the 2026-10-29 session close) and check
      the order's `ad_attribution`.

## 7. Open questions for David

1. What do the two live creatives say, and what are their destination URLs? (The report has no URL column.)
2. Is the "Launch Pilot 50% Discount" campaign supposed to deliver a code (`Biology50` was used in a 10-25 test order)?
3. Keep three bundle cards on the home page, or lead with one subject and upsell inside the app? The page cannot do both well on a phone.

## 8. Evidence trail

- Reddit CSV aggregated by campaign/OS/day/hour (python, scratchpad). Launch Pilot: 45,550 impressions, 306 clicks,
  $403.02; AP Biology: 10,021 impressions, 59 clicks, $170.41.
- PostHog HogQL (project 559891): `landing_view` by path/channel, by referrer and click-id coverage, by URL pattern;
  funnel for persons with a Reddit touch; checkout_viewed rows; session second-event counts.
- Production SQL: `app.trial_orders` since 2026-10-20 (3 rows: one refunded 10-21 test, two `setup_expired` 10-25).
- Live pages: mobile and desktop screenshots of `/`, `/ap-biology-prep`, `/ap-stem-prep`, `/checkout`,
  `/checkout?subjects=ap-biology`; link targets and image sizes via page script; HTML fetched as iPhone Safari (SSR
  confirmed, hero present in HTML).
- Lovable source read at HEAD: `Homepage.tsx`, `ap-biology-prep.tsx`, `ap-stem-prep.tsx`, `prep-pages.ts`,
  `checkout.index.tsx`, `TrialOffer.tsx`, `trial-checkout.ts`, `use-trial-gate.ts`, `posthog.ts`, `__root.tsx`.
