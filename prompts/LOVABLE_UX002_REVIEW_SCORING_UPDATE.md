# Lovable Prompt — UX-002 Reviewer Portal: Categorical Scoring + Difficulty Agree/Propose

**For:** the Cramapple reviewer portal Lovable project that serves **cramapple.com**
— confirmed 2026-07-15 to be the **`exam-buddy-wireframe` remix**, NOT
`cramapple-prototype` (the change was mistakenly coded there first).
**Related:** `DECISION-0038`, `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`.

> **IMPORTANT — portal backend reality (discovered 2026-07-15).** This portal does
> NOT use the governed `app.*` schema or the `review-decision` edge function. It
> writes directly to `public.review_decisions` on its own connected Supabase
> project (Lovable Cloud disabled). Two corrections vs. the earlier build:
> 1. **Mapping:** map the categorical decision to the legacy numeric `tutor_score`
>    as **approve → 1, approve_with_edits → 2, disapprove → 3** (the earlier build
>    used `approve → 3`, which is backwards and corrupts the dashboard Agreement
>    math).
> 2. **DB migration (apply manually to the portal's connected Supabase):**
>    ```sql
>    alter table public.review_decisions add column if not exists tutor_decision text;
>    alter table public.review_decisions add column if not exists difficulty_action text;
>    ```
>    The Lovable agent cannot run this; without it, submit throws a column-missing
>    error. Frontend + this DB change must ship together, then publish.
>
> The `supabase/migrations/202607140001_*.sql` and `review-decision` edge-function
> changes in this repo are for the *governed* `app.*` backend (already deployed to
> Cramapple - Production) — a separate system from this portal. See the
> 2026-07-15 activity-log entry on the reviewer-portal backend split.
**Status:** Fix-forward on the remix per Product Owner (2026-07-15).

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
