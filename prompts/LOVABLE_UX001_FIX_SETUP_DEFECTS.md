# Lovable Fix - First-session setup defects (from live QA, 2026-06-29)

## Context

Live QA of the new-user flow on cramapple.com found four defects on the
first-session setup path. Fix all four. The flow is otherwise working
(account-created welcome, /setup surface, time selector, Start session → MCQ →
graded feedback), so these are targeted fixes, not a rebuild. Canonical design:
`docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` §4.1.

---

## Fix 1 - Course-position controls are unwired (HIGH)

On `/setup`, the "Where your class probably is" section has two dead controls:

- **"Change"** opens nothing — there is no unit picker.
- **"Yes, that's right"** has no visible effect.

A learner currently cannot confirm or adjust their course position, which breaks
a core onboarding decision (course position = pacing prior + confirm/adjust).

Required behavior:

- **"Yes, that's right"** confirms the prior-suggested unit: mark it confirmed,
  show a clear confirmed state (e.g. selected styling or a short "Got it" note),
  and use that unit in the recommended-session card.
- **"Change"** opens an accessible unit picker (the same eight AP Biology units
  used at first-session setup: Unit 1 Chemistry of Life … Unit 8 Ecology).
  Selecting a unit updates the heading ("Your class is probably around {unit}")
  and the recommended-session card.
- If the learner picks a unit ahead of the prior, show the soft work-ahead note
  ("You can work ahead. If this feels too early, we'll help you return to the
  strongest covered next step."). Never gate it.
- Do not expose internal labels (readiness, mastery freshness, position-estimate
  confidence, decay, Lock).

## Fix 2 - Welcome CTA must navigate to `/setup` (HIGH)

On `/account-created`, the primary button **"Set up my first session"** did not
navigate during QA (URL stayed on `/account-created`). Ensure its click handler
routes to `/setup`.

- Verify with a true first-time user (setup not yet completed): the welcome
  screen renders and the primary CTA reaches `/setup`.
- Keep the existing setup-complete guard intact (a learner who has already
  completed setup is forwarded to `/home`, which is working correctly).

## Fix 3 - Exam date and countdown are wrong (MEDIUM-HIGH)

`/setup` shows "Tuesday, May 12, 2026" with "0 days from today." That date is in
the past relative to now, and the countdown clamps to 0.

Required behavior:

- Resolve the official exam date from the active exam pack and use the correct
  **upcoming** administration (for an August 2026 beta this is the **2027** AP
  Biology administration, ~May 2027 — confirm the exact date from the exam-pack
  source of truth).
- The countdown must compute real days remaining and never display "0 days from
  today" for a date that is actually in the past. If the resolved date is in the
  past, treat that as a data error and surface a clear system-data warning rather
  than silently clamping to 0.
- If the exam date is supplied by a backend/exam-pack value Lovable cannot edit,
  **flag it** in the completion report so we can fix the data source — do not
  hardcode a guess.

## Fix 4 - In-app pages render in a cramped narrow column (MEDIUM)

On desktop (~1568px wide), `/setup` and `/session/mcq` render their content in a
~210px-wide left column with large empty space to the right. Marketing pages
(`/`, `/signup`) render full-width correctly, so this is an app-shell container
issue.

Required behavior:

- The in-app/learning pages should use a comfortable centered content column
  (consistent with the marketing pages' container), not a narrow left-jammed
  strip.
- Verify at desktop (~1280–1600px) and mobile (~390px) widths with no horizontal
  overflow at 390px.

## Also (minor, optional)

Page `<title>` tags still carry the internal dev label, e.g. "MCQ attempt —
Cramapple UX-001", "Home — Cramapple UX-001". Drop "UX-001" from user-facing
titles.

## Acceptance Criteria

- `/setup` "Yes, that's right" confirms the unit with visible feedback; "Change"
  opens a working unit picker that updates the heading and recommended session.
- Picking a future unit shows the soft work-ahead note and never gates.
- `/account-created` welcome CTA navigates to `/setup` for a first-time user;
  the setup-complete → `/home` guard still works.
- `/setup` shows the correct upcoming exam date and a correct days-remaining
  countdown; never "0 days from today" for a past date.
- In-app pages use a comfortable centered column at desktop; no 390px overflow.
- No internal labels (readiness, decay, Lock, UX-001) appear in user-facing UI
  or titles.

## Do Not Do

- Do not reintroduce a `/prototype` route or a multi-step setup wizard.
- Do not ask registration status or a target AP score.
- Do not hardcode an exam date if it comes from a backend/exam-pack source —
  flag it instead.

## Completion Output

Report: what was wired for each control, the welcome-CTA fix, the exam-date
source and resolved value (or a flag that it's backend-owned), the layout
container change, branches tested (desktop + 390px), and a preview link.
