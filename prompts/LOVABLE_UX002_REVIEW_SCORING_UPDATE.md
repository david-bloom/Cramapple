# Lovable Prompt — UX-002 Reviewer Portal: Categorical Scoring + Difficulty Agree/Propose

**For:** the Cramapple reviewer portal Lovable project that serves **cramapple.com**
— the **`exam-buddy-wireframe`** project (repo `david-bloom/exam-buddy-wireframe`),
NOT `cramapple-prototype` (the change was mistakenly coded there first).
**Related:** `DECISION-0038`, `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`.

> **Backend reality (HAR-verified 2026-07-17 — corrects the earlier note here).**
> This portal **already uses the governed backend**: its server functions call the
> deployed `review-queue` / `review-decision` edge functions on the Production
> project (`pcntajvbdfqhbeewmdry`), writing to `app.content_review_decisions`
> (confirmed by a live submit returning a `decision_hash` and the new
> `tutor_decision`/`difficulty_action` columns). There is **no separate DB and no
> `public.review_decisions` in this portal's path** — the earlier note claiming
> otherwise was wrong.
>
> Consequences for this prompt:
> - **This is a FRONTEND-ONLY change.** No DB migration is needed on the portal
>   side (the `DECISION-0038` migration + edge functions are already live and in
>   this portal's path).
> - **No mapping fix is needed here.** The `review-decision` edge function already
>   maps `approve→1, approve_with_edits→2, disapprove→3` server-side. (The reversed
>   `approve→3` mapping was in `cramapple-prototype`'s separate direct-insert code,
>   which is NOT the live path.)
> - The submit should send `tutor_decision` + `difficulty_action` (and
>   `difficulty_label` when proposing) to the `review-decision` edge function the
>   portal already calls; the function also still accepts the legacy numeric
>   `tutor_score`, so there is no hard cutover risk.
**Status:** Frontend-only change on `exam-buddy-wireframe`; backend already
deployed and verified in the live path (2026-07-17).

---

Paste the following into the Lovable project:

> Update the reviewer portal's scoring model. Two changes:
>
> **1. Replace the 1–3 numeric score with a categorical decision.**
> Wherever a tutor or AP Reader records a suitability score, replace the numeric
> 1 / 2 / 3 control with three clearly-labeled buttons:
> - **Approve** (green) — suitable to advance as-is.
> - **Approve with edits** (amber) — good, but specific edits are needed; requires
>   a rationale.
> - **Disapprove** (red) — not suitable in this version; requires a rationale.
>
> Remove any "1 = best / 3 = worst" numbering and the numeric keyboard shortcuts
> `1/2/3` for scoring. There is no numeric score anymore. Submit sends
> `tutor_decision` (for tutor stages) or `reader_decision` (for the AP Reader
> stage) as one of `approve` | `approve_with_edits` | `disapprove`.
>
> Update the disposition preview shown before submit:
> - Two tutors **both Approve** → "Advances to AP Reader review."
> - **At least one Approve with edits, none Disapprove** → "Goes to edit-and-recycle;
>   a new version returns to two tutors."
> - **Any Disapprove** → "This version is excluded; the author may submit a revision."
> Replace any "tutor aggregate 2–6" language with these plain outcomes.
>
> **2. Replace cold difficulty labeling with Agree / Propose.**
> Show the item's **intended difficulty** (read-only, e.g. "Intended: Medium").
> The reviewer picks one:
> - **Agree** — accepts the intended difficulty.
> - **Propose different** — reveals the five-level picker (Easy, Moderately easy,
>   Medium, Hard, Very hard) to choose a different level.
> Submit sends `difficulty_action` = `agree` | `propose`, plus `difficulty_label`
> = the chosen level when proposing (or the intended level when agreeing).
> Show the preview: "All reviewers agree → difficulty confirmed. Any proposal →
> goes to difficulty discussion." Never average or auto-pick.
>
> **Keep everything else:** independent/blinded reviews (don't show the other
> reviewer's decision, rationale, or difficulty until both are locked), immutable
> submitted decisions, required rationale for Approve-with-edits and Disapprove,
> the MCQ four-answer independent review, accessibility (keyboard operable, visible
> focus, 44px targets, no color-only meaning — pair each color with a text label
> and icon), and the responsive carousel.
>
> Use original placeholder content and frontend state only. Do not authenticate
> users, write production records, or publish content in this prototype.

---

## Notes for the operator

- The green/amber/red colors must not be the only signal (accessibility): each
  button carries its text label and an icon, and status chips use text too.
- The backend contract is: `content_review_decisions.tutor_decision` /
  `reader_decision` ∈ {approve, approve_with_edits, disapprove};
  `difficulty_action` ∈ {agree, propose} with `difficulty_label` on the 5-level
  scale. This matches migration `202607140001`.
- After the Lovable change builds, verify the preview against the new disposition
  rules before promoting.
