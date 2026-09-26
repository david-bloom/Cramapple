# Launch Plan — Marketing Home Page — 2026-09-26

**Status:** Draft | **Owner:** David Bloom (Product Owner) / Micah Bloom (GTM-001) | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## Product Goal

The public marketing home page (pre-login, unauthenticated) says what Cramapple is, who it's for, and
gets a visitor to sign up or purchase — without contradicting the product's actual scope or making an
unsupported claim. Done when a visitor can go from the home page to purchase without hitting an
undecided brand element or unverified claim.

## Authoritative sources — do not contradict these

- `docs/product/CRAMAPPLE_VISION.md` — positioning, problem statement, target customer/buyer (§2, §3,
  §4, §11, §12). This is the source of truth for *what the page says*.
- `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` — voice, type, color, competitive lane ("warm
  precision," not education-warm, not utility-cold). This is the source of truth for *how it looks and
  sounds*. Treat v2 as current; `CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` (v1) and
  `Cramapple-Vision-v0.3.docx` are superseded/stale — do not draw from them without checking dates.
- `docs/MASTER_TODO.md` GTM-001 — positioning/tagline/value-prop testing, readiness-language rules
  (no unsupported score prediction), social-proof/performance-claim evidence rules. This plan absorbs
  GTM-001's marketing-page-relevant items rather than duplicating them — check GTM-001's status before
  starting work that might already be in progress under Micah Bloom.

## What's already decided vs. still open

**Decided:** audience (primary: AP student, rising 10th-12th; secondary: parent 40-55), competitive
lane, typography (Plus Jakarta Sans + JetBrains Mono for student FRQ answers only), color system (warm
forest/emerald, two-token accent, gold reserved for "full marks" moments), voice ("like a very sharp
tutor" — not hype, not clinical, not encouraging-teacher-tone), anti-patterns banned (no mascots, no
gamification, no manufactured urgency).

**Still open — gates on this plan:**
- Logo/wordmark not finalized (two mark options open per the identity brief). A launch-ready home page
  cannot ship a placeholder or ad-hoc mark — this needs a David decision before final asset production.
- No page-structure/copy-block spec exists yet. This plan's actual deliverable is producing one.
- GTM-001's "readiness language without unsupported score prediction" and "social-proof/performance-
  claim evidence rules" are still `Proposed` — any claim on the page ("improves your score," "X% of
  students...") must be checked against these rules once they exist, not written ahead of them.

## Acceptance Criteria

- [ ] Logo/wordmark decision recorded (cite the decision, e.g. a DECISION-NNNN entry) and final asset
      produced in both light/dark-background variants per the identity brief's token system.
- [ ] Page structure and copy draft exists, covering at minimum: hero/positioning statement, problem
      statement (matching Vision §2), what Cramapple is / is not (Vision §4), pricing/CTA section
      (must match the live Stripe catalog in the payment-flow plan, not an invented price), and a
      value-prop section for the secondary buyer (parent).
- [ ] Every claim on the page is either (a) a stated product fact verifiable in this repo, or (b)
      explicitly flagged pending GTM-001's evidence rules. No "X% improvement" or similar performance
      claim ships without a cited evidence source.
- [ ] Visual execution passes WCAG AA contrast (identity brief requirement) in both color modes.
- [ ] Copy reviewed against the identity brief's Voice section — no clinical/robotic, no hype/
      exclamation-heavy, no warm-fuzzy-teacher tone.
- [ ] CTA path from home page to checkout is verified against the live purchase flow in
      `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` — do not link to or imply pricing that doesn't match the
      live Stripe catalog.
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
