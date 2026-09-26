# Launch Plan — Marketing Home Page — 2026-09-26

**Status:** Draft | **Owner:** David Bloom (Product Owner) / Micah Bloom (GTM-001) | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**This plan originally named `CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` as the source of truth for voice,
type, and color. That brief is superseded.** `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §11 records:
"Visual-identity brief v2 status — **Resolved.** `docs/new_design/` is canonical." `docs/new_design/`
specifies Bungee (wordmark) / Passion One (display) / Source Sans 3 (reading) / STIX Two Math, a brand
orange masthead (`#f54900`, `#ca3500` ink) — not Plus Jakarta Sans and the warm forest/emerald palette
this plan originally described. Dark mode is also retired (2026-09-21, David) — light-only, superseding
v2's dark-first requirement.

**This plan also originally implied it could run independently of the other four.** It cannot, as
written: `APP_REBUILD_MIGRATION_PLAN.md` §3 records David's explicit sequence — rebuild the app first,
reskin marketing pages second (a visual pass, not a rebuild), update Stripe third, and only then
"design and deploy a new home page, last... once the system it advertises exists." A brand-new home
page built now, ahead of that sequence, would advertise a product and design system that no longer
exist. **This plan is gated on Phase 4 of the rebuild plan** unless David explicitly overrides that
sequencing for this work. See the decision register in `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`.

Corrected below: authoritative sources, voice/type/color references, and the dark-mode requirement.
The rest of this plan's structure (page-structure/copy deliverable, claim-evidence discipline) still
holds.

## CORRECTION #2, 2026-09-26 (`DECISION-0070`): logo resolved, BYOQ added to scope

**Logo/wordmark is no longer an open item — it's decided.** David confirmed a type-only wordmark is
sufficient for launch; no illustrated logo mark is required. Drop the "logo decision" acceptance
criterion below to a non-blocking note.

**New launch-critical scope: the home page ships the full BYOQ (Student-Provided Question Intake)
experience, ungated and anonymous.** A visitor does not need to sign in or purchase to use BYOQ. This
was previously scoped as UX-004 in the content-pipeline plan and treated as non-critical (gated on
human domain reviews). It is now launch-critical for this plan specifically. See
`docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` for the UX spec — this plan does not
redesign it, it implements/audits it as an anonymous-session feature on the home page.

**Target launch window is next week** (`DECISION-0070`). This is a materially tighter timeline than the
rebuild sequencing this plan is gated on (see the first correction above) — flag the tension to David
rather than silently assuming one overrides the other; see decision register items D-1/D-2 in the
index.

## CORRECTION #3, 2026-09-26 (`DECISION-0073`): the home page already exists — this is a fix pass, not a build

**This plan's premise was wrong. It assumed no home page existed yet and gated the work on Phase 4 of
the rebuild sequence. A live, working home page already exists**, at
`https://ap-prep-canvas.lovable.app/` (the "Remix of Cramapple App" Lovable project,
`d334fed9-5a97-4e76-906e-7c0ad7082212`), confirmed via its live HTML. It already:

- Fully matches the new design system (`docs/new_design/` tokens, Bungee/Passion One/Source Sans 3,
  orange masthead) — no visual rebuild needed.
- Shows the correct Day-1 subjects as "Live now" (AP Biology, AP Statistics) and the rest as "Coming
  soon," matching `DECISION-0069`.
- Ships a full anonymous, ungated BYOQ flow ("Upload a photo" / "Paste the text," no account needed),
  matching `DECISION-0070` — this criterion below is likely already met, verify rather than build.
- Includes an interactive embedded practice demo (the "Open Hand · FRQ" rubric-scoring plate), copy
  matching the Vision doc's positioning, and a full page structure (hero, method, upload flow, hand-
  written-answer pitch, deep-dive notes pitch, pricing, subjects grid, footer).

**What actually still needs fixing for Friday, given `DECISION-0071` (free launch, no Stripe):**

- The page currently shows a **$39.99 purchase CTA** ("Get it · $39.99" in the masthead, a full
  pricing/buy section with "Get AP Statistics" and a tutor-cost comparison) and links to `/signup` as a
  paid flow. This needs to become a free-access/trial CTA instead — do not simply hide the pricing
  section without replacing the CTA's destination and copy.
- Everything else in this plan's acceptance criteria below becomes **verify-against-live-HTML**, not
  **build-from-spec** — re-read this page's actual markup before treating any criterion as unmet.

This plan is **no longer gated on Phase 4 of the rebuild sequence** in the way the first correction
above assumed, since the deliverable already exists — flag this resolution to David rather than
continuing to treat D-1's sequencing question as blocking this specific plan.

## Product Goal

The public marketing home page (pre-login, unauthenticated) says what Cramapple is, who it's for, and
gets a visitor to sign up or purchase — without contradicting the product's actual scope or making an
unsupported claim. Done when a visitor can go from the home page to purchase without hitting an
undecided brand element or unverified claim.

## Authoritative sources — do not contradict these

- `docs/product/CRAMAPPLE_VISION.md` — positioning, problem statement, target customer/buyer (§2, §3,
  §4, §11, §12). This is the source of truth for *what the page says*, and is unaffected by the
  correction above.
- `docs/new_design/` (see its `README.md`) and the `cramapple-design` skill — **the canonical design
  system as of the rebuild plan**, superseding `CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md`. This is the
  source of truth for *how it looks*: Bungee (wordmark), Passion One (display), Source Sans 3 (reading
  text), STIX Two Math; brand orange masthead; light-mode only. Do not build against the v2 brief's
  forest/emerald palette or dark-mode requirement — both are retired.
- `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §3, §11, §12 — the sequencing this plan must respect
  (home page last, Phase 4) and any brand-relevant open decisions in §11's decision table.
- `docs/MASTER_TODO.md` GTM-001 — positioning/tagline/value-prop testing, readiness-language rules
  (no unsupported score prediction), social-proof/performance-claim evidence rules. This plan absorbs
  GTM-001's marketing-page-relevant items rather than duplicating them — check GTM-001's status before
  starting work that might already be in progress under Micah Bloom.

## What's already decided vs. still open

**Decided:** audience (primary: AP student, rising 10th-12th; secondary: parent 40-55), competitive
lane ("warm precision" per the original identity work, voice unaffected by the design-system
correction), typography and color per `docs/new_design/` above, light-mode only, voice ("like a very
sharp tutor" — not hype, not clinical, not encouraging-teacher-tone), anti-patterns banned (no mascots,
no gamification, no manufactured urgency).

**Decided (added 2026-09-26, `DECISION-0070`):** logo/wordmark — type-only wordmark is sufficient, no
illustrated mark required; BYOQ ships on the home page, ungated, anonymous; target launch window is
next week.

**Still open — gates on this plan:**
- No page-structure/copy-block spec exists yet. This plan's actual deliverable is producing one — once
  the sequencing gate above is cleared.
- BYOQ's anonymous/ungated delivery raises privacy, rights, and academic-integrity questions that
  `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`'s own task (UX-004) still lists as needing review
  (accessibility/security/privacy/rights/academic-integrity/Product Owner). Shipping it ungated on a
  public page makes those reviews launch-critical, not deferrable — flag to David rather than shipping
  around them.
- GTM-001's "readiness language without unsupported score prediction" and "social-proof/performance-
  claim evidence rules" are still `Proposed` — any claim on the page ("improves your score," "X% of
  students...") must be checked against these rules once they exist, not written ahead of them. In
  practice this means: ship zero unsupported performance claims until GTM-001 resolves.
- Where the deliverable actually lives: **confirmed** — `https://ap-prep-canvas.lovable.app/`, the
  "Remix of Cramapple App" Lovable project (`d334fed9-5a97-4e76-906e-7c0ad7082212`). An agent executing
  this plan needs Lovable access to that project to actually ship changes.

## Acceptance Criteria

- [x] Rebuild-sequencing gate — **moot, page already exists** (`DECISION-0073`). No longer blocking.
- [x] Logo/wordmark — **not a blocker** (`DECISION-0070`), and already correct on the live page: a
      type-only "CRAMAPPLE" wordmark per `docs/new_design/`'s token system, light-mode only.
- [x] **$39.99/Stripe CTA — David is handling directly**, not delegated to an agent: adding a "Free
      this week!" banner to the live page rather than a full CTA/pricing-section replacement. This is a
      lighter fix than originally scoped (swap destination/copy of every purchase touchpoint) — a
      banner layered on top of the existing pricing display, announcing free access, rather than
      removing pricing. An agent picking up this plan should **not** independently rework the $39.99
      CTA or pricing section — check with David on current status before touching it, since he may
      already be mid-edit in Lovable.
- [ ] Page structure and copy — **already exists and is largely correct**; verify against the live HTML
      rather than drafting from scratch. Hero/positioning statement, problem framing, and value props
      are present and match `CRAMAPPLE_VISION.md`'s tone. Spot-check for drift, don't rebuild.
- [x] BYOQ is implemented on the home page as a full, ungated, anonymous-session experience per
      `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` — **confirmed present in the live HTML** ("Upload a
      photo" / "Paste the text," "One free question. Your photo isn't kept."). Still verify the
      privacy/rights/academic-integrity review flagged above has actually happened, not just that the
      feature works.
- [ ] Every claim on the page is either (a) a stated product fact verifiable in this repo, or (b)
      explicitly flagged pending GTM-001's evidence rules. No "X% improvement" or similar performance
      claim ships without a cited evidence source. Spot-check the live copy against this rule.
- [ ] Visual execution passes WCAG AA contrast per `docs/new_design/`'s tokens, light mode only —
      already appears correct on the live page (orange-on-light, high-contrast ink), do a real contrast
      check rather than assuming from a visual read.
- [ ] Copy reviewed against `docs/new_design/`'s voice guidance — no clinical/robotic, no hype/
      exclamation-heavy, no warm-fuzzy-teacher tone.
- [ ] CTA path from home page leads to free access/sign-up for Friday's launch — verify it does not
      link to or imply any checkout/purchase flow, since payment flow is deferred (`DECISION-0071`).
- [ ] David has signed off on the final page (Hard Gate: public performance claims and brand identity
      finalization both require his approval per `STANDING_APPROVAL_LANES.md`).

## Out of Scope

- Pricing decisions (BIZ-001) — this plan reflects pricing, it does not set it.
- Campaign/paid-acquisition content (fall/winter/spring campaigns in GTM-001) — this plan covers the
  evergreen home page, not campaign landing pages.
- Backend/checkout implementation — see the payment-flow plan.

## Method Note

Before marking any criterion Done, verify against the actual live page (once built) or the actual
current Stripe catalog and current MASTER_TODO status — do not assume a decision was made because it
appears settled in a chat or an earlier draft. Cite what you checked and when.
