# Lovable Build Brief - Cramapple Returning Student Experience

## How To Use This File

Give this entire file to Lovable as a follow-up build prompt. It changes the
**returning** student experience only. It assumes the student app already exists
at real top-level routes (`/home`, `/progress`, etc.); route consolidation and
removal of `/prototype` are handled separately in
`prompts/LOVABLE_UX001_ROUTE_CONSOLIDATION.md`.

Canonical Cramapple source material:

- `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` (§4.2 Returning Session)
- `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md` (§9.1)
- `docs/proposals/2026-06-29-year-aware-point-maximization.md`

This is a frontend-first build. Use Supabase Auth/session as the source of truth
when available; fall back to local mock state when backend config is absent. Do
not invent backend behavior. Remember missing backend config so the wiring can
be fixed later.

---

## Principle

A returning learner is **not** re-onboarded. Cramapple already knows their
confirmed course position, accumulated content and point-capture evidence, and
history. The returning experience is **re-entry into a picture that has moved
since the last visit**, not a fresh setup.

On `/home` for a returning learner, the order is:

1. Recover any incomplete onboarding or interrupted session first.
2. Show course-position re-confirmation **only when triggered** (change 1).
3. Show newly-reachable / work-ahead invitations when applicable (change 3).
4. Show one recommended next action with reason and time estimate
   (emphasis varies by season — change 2).
5. Offer continue, choose another action, or change available time.

Keep one clear primary action. Every addition below is an ambient card or
triggered prompt — never a blocking gate, never a re-onboarding step.

## Mock State

Use frontend-only mock state so reviewers can see each case. Provide a way to
preview states from code (not a learner-facing switcher).

```ts
type ReturningContext = {
  isReturning: boolean;
  seasonPhase: "early" | "mid" | "late";
  // change 1 triggers
  pacingPriorCrossedUnit: boolean;       // calendar advanced past a unit boundary
  performanceDivergedFromFrontier: boolean; // wrong on assumed-covered, or fluent above prior
  assumedUnit: { unitId: string; unitLabel: string };
  // change 3
  frontierGrewSinceLastVisit: boolean;
  newlyReachableUnit: { unitId: string; unitLabel: string } | null;
  pendingWorkAheadUnit: { unitId: string; unitLabel: string } | null; // tried early, was redirected
  // change 4
  contentCoverage: { unitId: string; unitLabel: string; coverage: "none" | "partial" | "covered" }[];
  pointCaptureTrend: "improving" | "mixed" | "needs_attention";
};
```

---

## Change 1 - Periodic course-position re-confirmation

Do not re-ask course position every session, and do not silently assume it. Show
a lightweight one-tap re-confirmation (the returning analog of the first-session
confirm) **only when** `pacingPriorCrossedUnit || performanceDivergedFromFrontier`
is true.

When shown:

```text
Quick check: is your class around {{assumedUnit.unitLabel}} now?

[ That’s right ]   [ Change unit ]   [ Not sure ]
```

Behavior:

- `That’s right` confirms the assumed unit and dismisses the prompt.
- `Change unit` opens the same accessible unit picker used in first-session
  setup.
- `Not sure` keeps the assumed unit but marks the estimate as low-confidence
  internally (do not show that label to the learner).
- Dismissible; never blocks the recommendation below it.

When neither trigger is set, do not render this prompt at all.

## Change 2 - Recommendation emphasis shifts with the calendar

The Home recommendation keeps the **same card structure** but changes its center
of gravity by `seasonPhase`. Do not build three different UIs.

- `early` — recommend building/locking the current unit.
- `mid` — retention rises: a previously-learned earlier unit can be the headline
  recommendation, and due review reads as the primary action, not a footnote.
- `late` — integration, cross-unit prioritization, and fuller exam practice.

Example headlines by phase (same card):

```text
early:  Build Unit 3: Cellular Energetics — about 15 min
mid:    Bring back Unit 1 — it’s time to see if it still holds — about 10 min
late:   Put it together: a mixed full-length set — about 25 min
```

Keep `Why this?` and `Choose something else` as secondary actions in all phases.

## Change 3 - Newly reachable material and the work-ahead loop

When `frontierGrewSinceLastVisit` is true and `newlyReachableUnit` is set, show a
non-blocking card above the recommendation:

```text
Your class has probably moved into {{newlyReachableUnit.unitLabel}}.

[ Start {{newlyReachableUnit.unitLabel}} ]   [ Shore up where I am first ]
```

When `pendingWorkAheadUnit` is set — the learner tried this unit early, was
soft-redirected, and the prior has now caught up — show:

```text
{{pendingWorkAheadUnit.unitLabel}} is in range now — you tried it early.
Ready to take it on?

[ Start {{pendingWorkAheadUnit.unitLabel}} ]   [ Maybe later ]
```

Both are invitations, never gates. If both apply, show at most one card (prefer
the work-ahead loop) so Home stays calm.

## Change 4 - Two-axis Home and Progress

Surface two **distinct** signals; never merge them into one composite score:

- **Content coverage** — what the learner knows, by unit (`contentCoverage`).
- **Point-capture skill** — how well the learner captures available points
  (answering the question asked, hitting rubric language, full reasoning),
  summarized by `pointCaptureTrend`.

A returning learner whose content is still thin but whose point-capture is
improving must see that win. Home may recommend a point-capture drill
independent of unit:

```text
You keep leaving out the mechanism step. A short drill could fix that across
several units.
```

On Progress, show content coverage and point-capture in separate sections with
plain labels.

## Change 5 - Review as rhythm, not a guilt list

Frame due review as natural cadence, never as overdue/late/behind/penalty
language.

- Good: "Time to see if this still holds."
- Avoid: "Overdue", "You’re behind", "3 reviews late".

Decay-driven re-surfacing and Lock due-review must not show the **same item
twice** on Home or in the review queue. Until the coordination rule is finalized
(`LEARN-007`), dedupe by item so each target appears at most once, and present
review as an opportunity, not a backlog to clear.

---

## Student-Facing Copy Constraints

Do not use these learner-facing terms: readiness score, mastery, diagnostic
test, position-estimate confidence, mastery freshness, decay, Lock, overdue.
Use plain student language: "where your class probably is", "time to see if this
still holds", "in range now", "you keep leaving out…".

## Accessibility Requirements

- Complete keyboard operation and visible focus.
- Re-confirmation and newly-reachable/work-ahead prompts are reachable and
  dismissible by keyboard; dismissing returns focus sensibly.
- Triggered prompts announce via a live region when they appear.
- No color-only distinction for content coverage vs. point-capture.
- Mobile width around 390px has no horizontal overflow.

## Acceptance Criteria

- Returning Home recovers incomplete work before anything else.
- Course-position re-confirmation appears only when a trigger flag is set and is
  dismissible (change 1).
- Recommendation emphasis visibly differs across `early`, `mid`, `late` using one
  card structure (change 2).
- Newly-reachable and work-ahead invitations appear only when their flags are set
  and never gate; at most one shows at a time (change 3).
- Home and Progress show content coverage and point-capture as separate signals,
  not one composite (change 4).
- Review copy is cadence-framed, not punitive, and no item appears twice (change 5).
- One answer is never represented as mastery, readiness, course position, or an
  AP score.
- Mobile and keyboard accessibility pass a basic manual QA walk.

## Do Not Do

- Do not re-onboard returning learners or re-ask time/goals every session.
- Do not show course-position re-confirmation on every visit.
- Do not expose internal labels (readiness, mastery freshness, decay, Lock).
- Do not merge content coverage and point-capture into one composite score.
- Do not gate work-ahead or newly-reachable material.
- Do not use overdue/penalty framing for review.
- Do not create production database schema unless an existing backend contract
  already requires it.

## Completion Output

Report: components changed, mock states added, how to preview each `seasonPhase`
and trigger combination, branches tested, accessibility checks, any deviations,
and a preview link.
