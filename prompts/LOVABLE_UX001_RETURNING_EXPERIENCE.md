# Lovable Build Brief - Cramapple Returning Experience + Route Consolidation

## How To Use This File

Give this entire file to Lovable as a follow-up build prompt. It extends the
student experience already described in
`prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md`. Where the two agree, that file
still applies; where this file is more specific, follow this file.

Canonical Cramapple source material:

- `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` (§4.2 Returning Session)
- `docs/product/PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md` (§9.1)
- `docs/proposals/2026-06-29-year-aware-point-maximization.md`

This is a frontend-first build. Use Supabase Auth/session as the source of truth
when available; fall back to local mock state when backend config is absent. Do
not invent backend behavior. Remember missing backend config so the wiring can
be fixed later.

---

## Part A - Route Consolidation (resolve the `/prototype` conflicts)

There must be exactly **one** student app, living at real top-level routes. The
`/prototype/*` namespace was a temporary review artifact and must not ship.

You flagged that promoting prototype routes would collide with existing live
routes. That collision is expected and intended — we want one canonical set of
real routes, not two parallel ones. Resolve as follows:

1. **Before overwriting anything, report what each conflicting live page
   currently contains** (a one-line summary per page) so we can confirm nothing
   valuable is lost:
   - `home.tsx`
   - `progress.tsx`
   - `check-work.tsx`
   - `account-created.tsx`
2. **Make the UX-001 implementation the canonical version at each real route**,
   then **delete the `/prototype` duplicate.** Do not keep both. The intended
   real routes are:
   - `/account-created`
   - `/setup`
   - `/setup-paused`
   - `/home`
   - `/progress`
   - `/check-work`
   - `/bring-question`
   - `/topic`
   - `/session/mcq`, `/session/frq`, `/session/uncertain`, `/session/complete`
   - `/account`
3. **`/setup` vs `/session/setup`:** these are different paths, so there is no
   hard conflict. Keep them distinct: `/setup` is the new-account first-session
   composed setup surface; `/session/setup` is only for mid-session adjustments
   if that is a real, separate need. If `session.setup.tsx` merely duplicates the
   composed surface, fold it into `/setup` and remove it.
4. After consolidation, **no `/prototype` route, prototype switcher, or
   demo-state menu may remain.** Navigation is ordinary student navigation only:
   Home, Review, Progress, Account.

If any conflicting live page already contains real, current work we should keep,
stop and tell us before overwriting it.

---

## Part B - Returning Experience Changes

A returning learner is **not** re-onboarded. Cramapple already knows their
confirmed course position, accumulated evidence, and history. The returning
experience is re-entry into a picture that has moved since the last visit.

### B1. Home re-entry order

On `/home` for a returning learner:

1. Recover any incomplete onboarding or interrupted session first.
2. Show a triggered course-position re-confirmation **only when triggered**
   (see B2).
3. When the reachable frontier has grown since the last visit, show a
   "newly reachable" prompt (see B4).
4. Show one recommended next action with reason and time estimate.
5. Offer continue, choose another action, or change available time.

Keep one clear primary action. The re-entry additions are ambient cards or
prompts, never blocking gates.

### B2. Triggered course-position re-confirmation

Do not re-ask course position every session and do not silently assume it. Show
a lightweight one-tap re-confirmation (the returning analog of first-session
confirm) only when a mock trigger flag is set:

```ts
type ReturningState = {
  pacingPriorCrossedUnit: boolean; // calendar advanced past a unit boundary
  performanceDivergedFromFrontier: boolean; // wrong on assumed-covered, or fluent above prior
  frontierGrewSinceLastVisit: boolean;
  pendingWorkAheadUnitId: string | null; // a unit they tried early and were redirected from
};
```

When `pacingPriorCrossedUnit || performanceDivergedFromFrontier` is true, show:

```text
Quick check: is your class around Unit 4 now?

[ That’s right ]  [ Change unit ]  [ Not sure ]
```

Otherwise do not show it. This prompt is dismissible and never blocks the
recommendation.

### B3. Seasonal recommendation emphasis

The Home recommendation keeps the same card structure but changes emphasis by
exam proximity. Drive this from a mock `seasonPhase`:

```ts
type SeasonPhase = "early" | "mid" | "late";
```

- `early` — recommendation builds/locks the current unit.
- `mid` — retention rises; a decayed earlier unit can be the headline
  recommendation, and due review reads as primary, not a footnote.
- `late` — integration, cross-unit prioritization, and fuller exam practice.

This is the same recommendation surface with different content. Do not build
three separate UIs and do not expose the words "decay", "freshness", "readiness",
or "Lock" to the learner.

### B4. Newly reachable material and work-ahead loop

When `frontierGrewSinceLastVisit` is true, show a non-blocking card:

```text
Your class has probably moved into Unit 4.

[ Start Unit 4 ]  [ Shore up Unit 3 first ]
```

When `pendingWorkAheadUnitId` is set (the learner tried this unit early and was
soft-redirected, and the prior has now caught up), show:

```text
Unit 6 is in range now — you tried it early. Ready to take it on?

[ Start Unit 6 ]  [ Maybe later ]
```

Never gate either path. These are invitations, not requirements.

### B5. Two-axis Home and Progress

Surface both axes distinctly:

- **Content coverage** — what the learner knows, by unit/frontier.
- **Point-capture skill** — how well the learner captures available points
  (answering the question asked, hitting rubric language, full reasoning).

A returning learner whose content is still thin but whose point-capture is
improving should see that win. Home may recommend a point-capture drill
independent of unit, for example:

```text
You keep leaving out the mechanism step. A 10-minute drill could fix that across
several units.
```

Keep content and point-capture visibly separate; do not merge them into a single
composite score.

### B6. Review as rhythm, not penalty

Frame due review as natural cadence ("Time to see if this still holds"), never as
overdue/late/penalty language. Decay-driven re-surfacing and Lock due-review must
not show the same item twice on Home or in the review queue. Until the
coordination rule is finalized, dedupe by item so each target appears at most
once.

## Mock State Additions

Extend the existing setup mock state with returning context:

```ts
type ReturningContext = {
  isReturning: boolean;
  seasonPhase: "early" | "mid" | "late";
  returning: ReturningState; // from B2
  contentCoverage: { unitId: string; unitLabel: string; coverage: "none" | "partial" | "covered" }[];
  pointCaptureTrend: "improving" | "mixed" | "needs_attention";
};
```

Use mock fixtures so reviewers can see each state. Provide a way (mock toggle in
code, not a learner-facing switcher) to preview `early`, `mid`, and `late`
phases.

## Student-Facing Copy Constraints

Do not use these learner-facing terms: readiness score, mastery, diagnostic
test, position-estimate confidence, mastery freshness, decay, Lock. Use plain
student language: "where your class probably is", "time to see if this still
holds", "in range now", "you keep leaving out…".

## Accessibility Requirements

- Complete keyboard operation and visible focus.
- Re-confirmation and newly-reachable prompts are reachable and dismissible by
  keyboard; dismissing them returns focus sensibly.
- No color-only state for content coverage vs. point-capture.
- Mobile width around 390px has no horizontal overflow.
- Triggered prompts announce via a live region when they appear.

## Acceptance Criteria

- No `/prototype` route, switcher, or demo menu remains.
- Conflicting live pages are summarized before being replaced, then replaced by
  the UX-001 implementations with the prototype duplicates deleted.
- `/setup` and `/session/setup` are either clearly distinct or consolidated.
- Returning Home recovers incomplete work first.
- Course-position re-confirmation appears only when a trigger flag is set and is
  dismissible.
- Recommendation emphasis visibly differs across `early`, `mid`, and `late`.
- Newly-reachable and work-ahead invitations appear when their flags are set and
  never gate.
- Home/Progress show content coverage and point-capture as separate signals.
- Review copy is cadence-framed, not punitive; no item appears twice on Home.
- One answer is never represented as mastery, readiness, course position, or an
  AP score.
- Mobile and keyboard accessibility pass a basic manual QA walk.

## Do Not Do

- Do not keep both `/prototype/*` and top-level versions of any page.
- Do not overwrite a conflicting live page that contains real current work
  without flagging it first.
- Do not re-onboard returning learners or re-ask time/goals every session.
- Do not show course-position re-confirmation on every visit.
- Do not expose internal labels (readiness, mastery freshness, decay, Lock).
- Do not merge content coverage and point-capture into one composite score.
- Do not gate work-ahead or newly-reachable material.
- Do not create production database schema unless an existing backend contract
  already requires it.

## Completion Output

Report: conflicting-page summaries, routes changed/deleted, components changed,
mock states added, branches tested, accessibility checks, any deviations, and a
preview link.
