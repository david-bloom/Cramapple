# Lovable Build Prompt — Dynamic Subject List on /signup

## How To Use This File

Give this file to Lovable as an **amendment** to the existing `/signup` page
and the "Add another subject" flow it shares (confirmed both routes render
the same subject-selection component as of 2026-07-03). Do not rebuild the
page from scratch — only replace the hardcoded subject list with a
Supabase-backed one and keep everything else (layout, copy, purchase flow
for the selected subject) unchanged.

## Context

`/signup` currently renders a **hardcoded, static list** of exactly 4
subjects (AP Biology — Available; AP Chemistry, AP Environmental Science, AP
Physics — Coming Soon). Confirmed via live QA (2026-07-03): the page makes
zero network calls to Supabase or any subjects API — the list ships baked
into the JS bundle. Meanwhile `app.subjects` in Production already has an
`ap-statistics` row (`status: 'active'`) with a fully published exam pack
and 48 live content items — none of which appear anywhere on `/signup`
because the page never asks the database.

Separately, this repo's `prompts/LOVABLE_AP_STATISTICS_PHASE5_SUBJECT_SELECTOR.md`
(already built as a Lovable project, not yet published) covers the
**post-purchase practice/onboarding** subject selector — a different
surface. That prompt explicitly lists "Pricing or subject-bundling UI" as
out of scope. `/signup` was never covered by it. This prompt fills that gap.

**Read before building:** AP Statistics content being `active`/`published`
in the database does **not** mean it has been reviewed by a tutor or
cleared for rights/originality — it hasn't, on either count, as of
2026-07-03. Product Owner direction (2026-07-03): show AP Statistics as a
live, selectable subject anyway — real payment processing is not currently
wired up site-wide, so nothing here creates real financial exposure, and
the explicit purpose is to let students and tutors actually click through
and use AP Statistics for feedback and tutor recruiting. The site needs to
*look* live and complete; a "Coming Soon" label on Statistics would defeat
that purpose. The unreviewed-content risk itself hasn't gone away — the
resolution is that showing it to tutors is *part of* how it gets reviewed,
and showing it to students now is explicitly intended for feedback, not a
commercial launch claim.

## Goal

Replace the hardcoded subject list on `/signup` with one driven by
Supabase, so subject names/descriptions/ordering reflect real data instead
of a stale bundled array, and so AP Statistics appears as a real,
selectable, clickable option — going through the exact same
purchase/checkout flow AP Biology currently uses, whatever that flow
currently does (real Stripe charge, stubbed/test checkout, or anything in
between — do not build new payment logic, do not change what happens after
a subject is selected). Keep an explicit, easy-to-find allowlist as the
single source of truth for which Supabase-returned subjects are
selectable, so future subjects (Chemistry, APES, Physics) don't
automatically become selectable the moment a row exists in Supabase — but
ship this build with AP Statistics already in that allowlist alongside
Biology.

## Scope

1. **Fetch subjects from Supabase.** Query `app.subjects` (join to
   `app.exam_packs` / `app.exam_pack_versions` to confirm at least one
   `exam_pack_version.status = 'published'` exists for that subject —
   mirror the same join pattern already specified in
   `prompts/LOVABLE_AP_STATISTICS_SUBJECT_AWARE_ONBOARDING.md`). Render
   `display_name` from the query result, not a hardcoded string.
   - Confirm the client (anon/authenticated Supabase key already used
     elsewhere in the app) can actually read `app.subjects` and
     `app.exam_pack_versions` under current RLS policies. If a read is
     blocked, report that back explicitly rather than silently falling
     back to a hardcoded list — a missing RLS policy is a backend
     decision, not something to work around in the frontend.
2. **Availability gating (explicit allowlist, not raw existence).** Add a
   small, clearly-named, easy-to-find constant in the frontend codebase —
   e.g. `PURCHASABLE_SUBJECT_KEYS = ['biology', 'ap-statistics']` — that is
   the single source of truth for which Supabase-returned subjects render
   as "Available" (clickable, proceeds into the purchase flow) versus
   "Coming Soon" (rendered, not clickable, same as today's disabled rows).
   A subject present in Supabase but **not** in this list must render as
   "Coming Soon," never as "Available," regardless of its `status` or
   exam-pack state — this keeps Chemistry/APES/Physics exactly as they are
   today. Comment the constant clearly: something like `// Subjects shown
   as Available here are visible/selectable to real users for feedback and
   tutor recruiting purposes — this does not by itself mean the content has
   passed tutor review or rights clearance (check content_item_versions
   .review_status / rights_records for that). Do not add a subject here
   without an explicit go-ahead.`
3. **Ordering and copy.** Preserve the current visual order (Available
   subjects first, then Coming Soon, in whatever order Supabase returns
   them within each group) unless product direction says otherwise. Keep
   existing "AVAILABLE" / "COMING SOON" badge styling exactly as-is.
4. **Loading and error states.** Add a lightweight loading state while the
   subject list resolves (the page currently renders instantly since the
   list is static — this is new). On fetch failure, fail closed: show
   whatever subjects are in `PURCHASABLE_SUBJECT_KEYS` as a minimal
   fallback (so the page never shows a broken/empty state to a paying
   customer) and log the error for debugging — do not silently show an
   empty subject list.
5. **Apply to both call sites.** `/signup` (new purchase) and "Add another
   subject" from `/account` render the same component as of this writing
   — confirm that's still true and update both if they've diverged.

## Out of Scope

- Adding any subject beyond Biology and AP Statistics to
  `PURCHASABLE_SUBJECT_KEYS` — Chemistry, APES, and Physics stay "Coming
  Soon" exactly as they render today.
- The post-purchase practice/onboarding subject selector — that's
  `LOVABLE_AP_STATISTICS_PHASE5_SUBJECT_SELECTOR.md`'s scope, already
  built separately.
- Pricing tiers, bundle logic, or the bundle-copy text ("Chemistry, APES,
  Physics in Spring 2027") — do not touch unless asked; note in your
  completion report if you notice it's inconsistent with the homepage
  hero's roadmap text ("Statistics, Calculus AB, Chemistry, and Physics
  next") but do not silently reconcile them — flag it, don't fix it here.
- Any Supabase migration or RLS policy change — if reads are blocked,
  report it, don't work around it.
- The homepage FRQ demo module — separate prompt
  (`LOVABLE_HOMEPAGE_DEMO_FRQ.md`), separate scope.

## Forbidden Behavior

- Do not derive "Available" status from `app.subjects.status = 'active'`
  or from the existence of a published `exam_pack_version` alone. Purchase
  availability must go through `PURCHASABLE_SUBJECT_KEYS`.
- Do not add Chemistry, APES, or Physics to `PURCHASABLE_SUBJECT_KEYS` as
  part of this change — they stay "Coming Soon."
- Do not build new or different payment/checkout logic for AP Statistics —
  it must go through the exact same flow selecting AP Biology triggers
  today, whatever that flow currently is.
- Do not remove the "Coming Soon" disabled-row treatment for non-launched
  subjects — Chemistry/APES/Physics should look identical to today.
- Do not call any Supabase write/mutation from this page — read-only.
- Do not add any "unreviewed," "beta," or similar disclaimer badge to AP
  Statistics unless separately asked — the site should look complete.

## QA Expectations

Verify:
1. `/signup` and `/account` → "Add another subject" both now issue a real
   Supabase read for subjects (confirm via network tab) instead of zero
   network calls.
2. AP Biology still renders as "Available" and its existing purchase flow
   is unchanged end-to-end.
3. AP Statistics renders as **"Available," clickable, and goes through the
   identical flow AP Biology's "Available" row triggers** — this is the
   key check, not an incidental detail. Confirm it's not silently routed
   somewhere different or gated by an extra step Biology doesn't have.
4. Chemistry, APES, and Physics still render as "Coming Soon," unchanged.
5. Simulate a fetch failure (e.g. temporarily break the query) and confirm
   the page falls back to the `PURCHASABLE_SUBJECT_KEYS` list rather than
   showing an empty or broken page.
6. No new console errors; no new writes to Supabase from this page.

## Required Evidence on Completion

- Screenshot of `/signup` showing AP Statistics listed as "Available,"
  visually consistent with AP Biology's row.
- Confirmation, with a code reference, of exactly where
  `PURCHASABLE_SUBJECT_KEYS` lives and what it currently contains.
- Network tab evidence of the Supabase read actually happening on page
  load.
- Any RLS/read-permission issues encountered, reported explicitly rather
  than worked around.

## Next Expected Output

Changes visible in the Lovable editor/preview, ready for review. Reference
this file when describing the change. Flag the homepage-vs-pricing roadmap
copy inconsistency (see "Out of Scope") as a separate note, not a fix.
