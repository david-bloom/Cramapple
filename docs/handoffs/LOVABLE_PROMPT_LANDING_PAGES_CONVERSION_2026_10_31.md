# Lovable prompt — landing-page conversion fixes (home + every `/ap-*-prep` page)

**Sent:** 2026-10-31 to marketing project `61dd6602-6991-4561-b418-e988bb7c8a0b` (HEAD `06ae34f7` at send time).
**Source:** `CONVERSION_REVIEW_HOME_AND_SUBJECT_LANDING_PAGES_2026_10_31.md` prompts B–E, merged into one change.
**Deliberately excluded:** Prompt A (checkout first paint). The paywall plan owns checkout; see
`docs/product/PAYWALL_CHANGE_PLAN_2026_10_31.md`.
**Review:** read the resulting commit by SHA before David publishes; check the five hero questions render at 375 px.

---

```
Goal: raise landing-page conversion on cramapple.com (/) and the subject pages /ap-biology-prep, /ap-statistics-prep,
/ap-chemistry-prep, /ap-physics-prep, /ap-calculus-prep (all rendered by src/components/Homepage.tsx via
src/lib/prep-pages.ts), plus /ap-stem-prep (src/routes/ap-stem-prep.tsx). 96% of paid traffic is on phones, so every
decision below is mobile-first: design at 375x812 and check desktop second. Do NOT touch /checkout or anything under
src/components/checkout, src/lib/trial-checkout.ts, src/lib/purchase-*.ts, src/lib/attribution.ts, or any backend
request. Keep the existing design tokens and fonts from docs/new_design (Bungee wordmark, Passion One display, Source
Sans 3 body); no new fonts, no new colours, no motion (prefers-reduced-motion is the default experience).

1. HERO PROVES THE PRODUCT (Homepage.tsx)
Replace the hero stock photo (homepage-mockup-girl-hero.jpg / calculus-prep-hero.jpg) with a <HeroQuestionCard>
component rendered inside the existing dark hero band, to the right of the copy on desktop and directly under the
CTA on mobile. The card shows one real question: an eyebrow "AP {Subject} · Unit {n}", the stem, the four choices
with the correct one marked with a check and the label "Earns the point", and a short "Why this earns the point"
explanation. Minimum 16px body text at 375px; the card must be fully readable without zooming. Put the data in a new
file src/data/hero-questions.ts keyed by PREP_SUBJECTS key plus "default" (used on /). Use exactly this content, no
edits:

- default and biology — eyebrow "AP Biology · Unit 1"
  Stem: One strand of a DNA segment is written 5'-ATGCCG-3'. Which is the sequence of the complementary DNA strand,
  written 5' to 3'?
  A. 5'-TACGGC-3'   B. 5'-UACGGC-3'   C. 5'-GCCGTA-3'   D. 5'-CGGCAT-3' (correct)
  Why: Pairing A-T and C-G gives 3'-TACGGC-5', because the strands are antiparallel. Reading that strand in its own
  5' to 3' direction gives 5'-CGGCAT-3'.
- chemistry — eyebrow "AP Chemistry · Unit 1"
  Stem: Na+ and Mg2+ both have the electron configuration 1s2 2s2 2p6. Which statement correctly compares their radii
  and gives the reason?
  A. Mg2+ is larger, because magnesium has more protons and neutrons, so its nucleus takes up more space.
  B. Na+ is larger, because it has an extra electron shell compared with Mg2+.
  C. The ions are the same size, because identical electron configurations mean identical shielding and therefore
  identical radii.
  D. Na+ is larger, because its 11 protons attract the same 10 electrons less strongly than the 12 protons of Mg2+ do.
  (correct)
  Why: The two ions have the same number of electrons and the same shielding, so the difference comes from nuclear
  charge. Mg2+ has the larger effective nuclear charge, pulling the electrons closer.
- physics — eyebrow "AP Physics 1 · Unit 2"
  Stem: A lamp hangs at rest from the ceiling on a chain. The chain exerts an upward force on the lamp. Which force is
  the Newton's-third-law partner of the chain's upward force on the lamp?
  A. the lamp's downward force on the chain (correct)   B. the ceiling's upward force on the chain
  C. Earth's downward gravitational force on the lamp   D. the net force on the lamp, which is zero
  Why: Third-law partners are equal and opposite and act on two different objects, with the roles swapped. The chain
  pulls up on the lamp, so the partner is the lamp pulling down on the chain.
- statistics — eyebrow "AP Statistics · Unit 2"
  Stem: A fair six-sided die is rolled once. Let A be the event that the roll is even, and B the event that the roll is
  greater than 4. What is P(A or B)?
  A. 4/6 (correct)   B. 5/6   C. 1/6   D. 1
  Why: The events share the outcome 6, so they are not mutually exclusive. P(A or B) = 3/6 + 2/6 − 1/6 = 4/6, which
  matches counting the outcomes 2, 4, 5, 6.
- calculus — eyebrow "AP Calculus AB · Unit 1"
  Stem: What is the limit as x→5 of (x² − 25)/(x² − 3x − 10)?
  A. 0   B. 10/7 (correct)   C. 10/3   D. The limit does not exist, because the denominator is 0 at x = 5.
  Why: Factor to (x − 5)(x + 5) / ((x − 5)(x + 2)), cancel the common factor x − 5, and substitute x = 5 into
  (x + 5)/(x + 2) to get 10/7.

New hero copy (keep the eyebrow line as is):
  h1: "Know exactly what earns the point on every AP {Subject} question." (on / use "every AP question")
  lead: "Practice built from the rubric, unit by unit, in 15 minutes a day."
  button: "Start free trial" (xl, links to the existing checkout href for that page)
  note under the button: "Nothing charged today. $39.99 one-time after your 7-day trial. Cancel anytime."
Keep the hero band dark with the existing contrast; the question card is a light card on that band.

2. PROOF INSTEAD OF SLOGANS (Homepage.tsx, the 01/02/03 section)
Replace the three bullets with these facts (exact figures from the catalog on 2026-10-31; on a subject page use that
subject's row, on / use the totals):
  totals: "2,499 multiple-choice and 761 free-response questions across 10 AP subjects"
  biology: "223 multiple-choice and 89 free-response questions, Units 1–8"
  statistics: "464 multiple-choice and 110 free-response questions"
  chemistry: "211 multiple-choice and 71 free-response questions"
  physics: "Physics 1: 176 multiple-choice and 69 free-response questions (Physics 2 and both Physics C courses also
  included)"
  calculus: "AB: 357 multiple-choice and 93 free-response questions (BC and Precalculus also available)"
  second bullet (all pages): "Every wrong answer explained. Every free-response answer scored line by line against
  the rubric."
  third bullet (all pages): "Hand-drawn answers graded from a photo of your paper."
Fix the typo "most point" wherever it remains.

3. THE GRADED-FRQ DEMO, STATIC (Homepage.tsx)
Reuse src/components/marketing/FrqDemo.tsx below the proof section: render it in its "graded" state only, no typing
animation and no auto-advance (treat prefers-reduced-motion as always on), keep the Prev/Next controls, single
column on mobile, and change the section title to "See exactly where the points are won and lost". Keep the four
existing examples verbatim. Keep the existing lazy-loaded desktop screenshot section below it, but on viewports under
640px show a cropped version of bio-prep-screenshot that contains only the "Answer key" column at readable size.

4. ONE OFFER, ONE LABEL, A FAQ, AND A PROMO BANNER (Homepage.tsx and ap-stem-prep.tsx)
- Every CTA button on these pages reads "Start free trial" (aria-labels updated to match). No "Get started", no
  "Try for free", no "Buy now".
- Pricing heading: "Free for 7 days, then one-time pricing". Remove "Pay once for the year". Keep the three cards on /;
  on subject pages (Homepage rendered with a subject) show only the single-subject card and add the line "You can add
  more subjects later from your account." under it.
- Add a <PricingFaq> accordion directly under pricing with four items: "What happens on day 7?" → "Your card is charged
  the one-time price for your subject. Checkout shows the exact date before you start."; "How do I cancel?" → "From
  your account, any time before the trial ends. If you cancel in time you pay nothing."; "Can a parent pay?" → "Yes.
  Checkout has 'Ask a parent to pay', which sends them a link."; "Refunds?" → link to the existing refund policy page.
- Read a `promo` search param on /, every *-prep route and /ap-stem-prep. When present, show a banner directly above
  the hero CTA: for the known code BIOLOGY50 (case-insensitive) "Code BIOLOGY50 applied: 50% off, $19.99 after your
  free trial"; for any other code "Code {CODE} will be applied at checkout". Append promo= to every checkout link on
  the page. Banner uses the brand orange tint background with ink text; no banner without a code.
- Replace the "More points, less effort, better sleep" study-guide list with a chooser titled "Pick your subject and
  start free": full-width tap targets (min height 56px) linking to /checkout?subjects=<key>: AP Biology → ap-biology,
  AP Statistics → ap-statistics, AP Chemistry → ap-chemistry, AP Physics → ap-physics-c-mechanics, AP Calculus AB →
  ap-calculus-ab, AP Calculus BC → ap-calculus-bc, AP Precalculus → ap-precalculus. Under each, a small secondary link
  "study guides →" to the existing hub route. On subject pages the chooser pre-highlights the page's own subject.

5. /ap-stem-prep (src/routes/ap-stem-prep.tsx)
Keep the headline ("First AP unit was tough? The next one doesn't have to be.") and the offer note. Add the same
subject chooser (id="pick-subject") directly under the hero offer; the hero "Start free trial" button scrolls to it
instead of linking to bare /checkout; the pricing card button links to /checkout?subjects=ap-biology. Replace the
desktop-screenshot device frame with the HeroQuestionCard for biology on mobile (keep the device frame on desktop).
Add the proof lines from section 2 (totals) and the PricingFaq. Apply the promo banner from section 4.

6. WEIGHT AND MEASUREMENT
- Any hero image still used anywhere (calculus-prep-hero.jpg etc.) ships as AVIF/WebP via <picture> with a 750px
  variant under 150 KB; keep width/height attributes; lazy-load every image below the fold.
- In src/routes/__root.tsx trim the Google Fonts request to Bungee, Passion One (400;700), Source Sans 3 (400;600;700)
  and STIX Two Math. Search the codebase for Plus Jakarta Sans, JetBrains Mono, Archivo Black and Nunito Sans; where a
  route still uses one, either switch it to a token font or keep only that family in the request. Report which you did.
- In src/lib/posthog.ts: set capture_pageleave: true (leave autocapture, capture_pageview and session recording off),
  add "cta_position" to ALLOWED_PROPS, add captureLandingCtaClicked({ route, cta_position }) that sends the event
  "landing_cta_clicked", and call it from every landing CTA with positions hero, pricing, benefits, chooser, band, faq.
  Update posthog tests.

Done means: all tests pass; at 375x812 on / and /ap-biology-prep the hero copy, button, note and the full question
card are readable without zoom; no page still says "Get started" or "Try for free"; /ap-biology-prep?promo=BIOLOGY50
shows the banner and its checkout links carry promo=BIOLOGY50; clicking any CTA sends landing_cta_clicked. Summarize
every file you changed and anything from this list you could not do.
```
