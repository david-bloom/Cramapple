# Lovable Prompt — Gold-set verification screen (blind element marking)

**Target:** Lovable workspace for `exam-buddy-wireframe` (production build source for
cramapple.com). **Not** the `david-bloom/Cramapple` docs repo.
**Date:** 2026-08-03
**Related:** DECISION-0045; `docs/research/GOLD_SET_GENERATION_PROTOCOL.md` (Phase 4);
`docs/research/GOLD_SET_AUTHORING_GUIDE.md` v2.0 §2;
`docs/research/GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md`
**Users:** Jill (AP Statistics, 48 answers) and Muhammad Saood (AP Physics, 64 answers)

---

## Backend status — APPLIED to Production 2026-08-03

Migration `supabase/migrations/20260803120000_gold_set_verification.sql`, applied to
Production `pcntajvbdfqhbeewmdry` and functionally verified. This prompt is ready to
paste; the contract below exists and behaves as described.

| Object | Access |
|---|---|
| `app.gold_set_answers`, `app.gold_set_elements`, `app.gold_set_verification_assignments`, `app.gold_set_element_marks` | RLS forced, **zero policies**, service_role only |
| `public.gold_set_access()` | `authenticated` — boolean, caller-scoped |
| `public.gold_set_verification_next()` | `authenticated` — caller-scoped via `auth.uid()` |
| `public.gold_set_verification_progress()` | `authenticated` — caller-scoped |
| `public.submit_gold_set_verification(uuid, jsonb, boolean)` | `authenticated` — caller-scoped |

**Permission.** Access requires either `role='admin'` or an unexpired
`gold-set-review` flag in `app.feature_flag_assignments`. Granted 2026-08-03 to
**Jill Schmidlkofer** and **Muhammad Saood**, plus both admin profiles by role —
4 eligible of 25 profiles. Every other tutor and reader is denied at the database:
`gold_set_verification_next()` raises `not_authorized`, verified. Grants are ordinary
data (`scripts/content-seed/gold-set/20260803_gold_set_permission_grants.sql`), so adding
a reader later needs no code change and no redeploy.

**Changed from the original draft of this prompt:** submit is a caller-scoped RPC, not an
edge function. The function body is already a single transaction, so it gets atomicity
natively, and it removes a deploy surface. There is no `gold-set-verification-submit`
edge function — do not call one.

Two behaviours the UI depends on and does not need to re-implement:

- **Sibling separation** is enforced at seeding: answers to the same question are
  interleaved round-robin, so two answers to one item are always at least (number of
  items) apart. Verified: zero adjacent siblings. This is not cosmetic — siblings seen
  back to back anchor the reader's marking, and that bias is systematic rather than
  random, so it does not average out.
- **Marks are write-once.** An `UPDATE` on a submitted mark raises
  `gold_set_marks_immutable` at the database level. The UI's "no going back" rule is
  therefore a courtesy to the reader, not the actual guard.

---

## Design rule that governs everything below

**The reader must never receive the script, the machine verifiers' marks, the grader's
output, the writer's model family, the route the answer took, or the item's canonical
answer.** This is enforced by the read contract not returning those fields at all — the
UI cannot leak what it was never sent. Do not add a query that fetches the underlying
`app.gold_set_answers` row, and do not join to `content_item_versions.canonical_answer_1`.

If the certification is contaminated, the pilot produces a number that looks fine and
means nothing. That is the failure mode this screen exists to prevent.

---

Paste everything inside the fence below into Lovable.

---

```
Add a gold-set verification screen to the reviewer portal. This is a NEW feature, not a
change to the existing review flow. Do not modify the existing reviewer review routes,
queue, or decision submission.

## What this is

Two subject-matter tutors are checking AI-generated student answers against rubric
criteria, to certify an automated labelling pipeline. For each answer they mark, per
criterion, whether the answer actually satisfies it — present or absent, with a quote as
evidence. They do NOT award points and they do NOT score.

The scientific validity of the whole exercise depends on the reader seeing ONLY the
question and the answer. Everything else is withheld deliberately.

## Where it lives, and who can see it

This is a section INSIDE the existing reviewer portal, alongside the existing review
queue — not a separate app, not a separate login, not a top-level nav item for everyone.
Readers reach it from the reviewer portal they already use.

Gate it on supabase.rpc('gold_set_access'), which returns a boolean:

- Add a "Gold set" entry to the reviewer portal navigation, rendered ONLY when
  gold_set_access() returns true. When it returns false, render nothing at all — no
  disabled item, no "request access" link, no tooltip. A reviewer without the permission
  should not learn the feature exists.
- Guard both routes below with the same call. A reviewer who reaches the URL directly
  without permission gets redirected to the reviewer home, not an error page.
- Cache the result for the session (it does not change mid-session), but do NOT persist
  it to localStorage.

Do NOT gate on profiles.role in the client. Permission is admin-by-role OR an unexpired
gold-set-review feature flag, and the flag can be granted or revoked without a deploy —
a client-side role check would be both wrong and stale. Call the RPC.

The RPCs are independently enforced server-side, so a client-side gating bug leaks the
menu entry at worst, never the data.

## Routes

/reviewer/gold-set          -> progress + start/continue
/reviewer/gold-set/verify   -> the marking screen

IMPORTANT: /reviewer/gold-set/verify takes NO id parameter. The server decides which
answer comes next. Readers must not be able to navigate to a specific answer, revisit a
submitted one, or skip ahead. Do not add an id to the URL, and do not cache a list of
upcoming assignments in the client.

Both routes require an authenticated profile. Show a "not assigned" empty state if the
caller has no gold-set assignments — do not error.

## Data

Read: supabase.rpc('gold_set_access') returns boolean. Use for nav visibility and route
guards, as described above.

Read: supabase.rpc('gold_set_verification_next') returns null (queue empty) or:

  {
    assignment_id: string,
    seq: number,
    stem: string,
    stimulus: string | null,
    stimulus_image_path: string | null,
    answer_text: string,
    elements: Array<{
      element_id: string,
      criterion_key: string,
      element_label: string,     // what this element requires, in words
      element_index: number
    }>
  }

Read: supabase.rpc('gold_set_verification_progress') returns { done: number, total: number }.

Write: supabase.rpc('submit_gold_set_verification', {
    p_assignment_id: string,
    p_marks: Array<{ element_id: string, present: boolean, evidence_quote: string | null }>,
    p_flagged_contaminated: boolean
  })

It returns { status: 'submitted' | 'already_submitted' | 'flagged_contaminated',
assignment_id: string }. Treat 'already_submitted' as success and advance — it means a
retry or a double-tap, not an error.

There is NO edge function for this. Do not create or call one.

Send evidence_quote: null for absent elements. The database rejects a quote on an absent
mark and requires one on a present mark, so the disabled-submit rule below is what keeps
the reader from hitting a server error.

Use the curated public contract only. Do NOT read app.* tables directly. Do NOT query
content_item_versions, frq_criteria, content_review_* or grading tables from this screen —
everything needed is in the RPC payload above, and anything extra risks leaking data the
reader must not see.

If Supabase config or session is absent, run in visible mock mode with 3 sample answers,
exactly as the rest of the portal does.

## The marking screen

Single answer, full attention, no queue rail. Layout desktop:

- Header strip: "Answer {done+1} of {total}" and nothing else. No item name, no answer
  identifier, no subject badge, no indication of how many answers share this question.
- Left column (~40%): the question. Stem, then stimulus if present, then the stimulus
  image if stimulus_image_path is set (resolve through the same storage helper the
  existing reviewer route uses). Collapsible, but expanded by default.
- Right column (~60%): the student answer in a bordered card, larger type, clearly
  distinguished as the thing being judged. Below it, the element list.

Mobile: question first (collapsible, collapsed by default after first scroll), then
answer, then elements stacked.

## The element list

For each element, in element_index order:

- The element_label as the question being asked of the reader.
- Two mutually exclusive buttons: "Present" and "Absent". NEITHER is selected initially —
  the reader must choose explicitly. Do not default to Absent.
- An evidence quote textarea, shown only when "Present" is chosen, labelled "Quote the
  words that satisfy this". Required when Present, max 300 chars. Not shown for Absent.
- Keyboard: with an element focused, "p" marks Present, "a" marks Absent, Tab moves to
  the next element. One reader has 224 marks to make; this matters.

Do NOT display point values anywhere on this screen. The criterion's worth is deliberately
withheld so the reader marks content rather than totalling a score.

Do NOT show a running count of present/absent, a subtotal, a percentage, or any summary
of the marks made. That is scoring, and it is not this reader's job.

## Submit

- Submit is disabled until every element has an explicit Present/Absent choice and every
  Present has a non-empty quote.
- On click, show a confirm dialog: "Submit these marks? You will not be able to change
  them or see this answer again." Confirm proceeds; cancel returns.
- On success, load the next answer immediately in the same route. Do not navigate back to
  a list, and do not show the marks that were just submitted.
- If the queue is empty, show a completion state: "All assigned answers verified. Thank
  you." with a link back to the reviewer home.
- The submit call must be idempotent-safe: if it returns a "already submitted" error,
  treat it as success and advance rather than showing an error.

## Autosave

Persist in-progress marks for the current assignment to localStorage keyed by
assignment_id, and restore them if the reader reloads mid-answer. Clear the key on
successful submit. This protects against a browser crash costing work; it must not allow
returning to an answer already submitted.

## Contamination flag

A quiet secondary link under the submit button: "I've seen something I shouldn't have".
Clicking it opens a confirm ("This answer will be set aside and not counted. Continue?"),
then submits with flagged_contaminated: true and whatever marks exist, and advances to the
next answer.

Readers are instructed to use this if they have accidentally seen the AI's marking, the
grader's output, or the writing script for an answer. It must be one click and carry no
friction or judgement in the copy — an unreported contamination is far more expensive than
a discarded answer.

## Progress route (/reviewer/gold-set)

Minimal. "{done} of {total} answers verified", a progress bar, and a primary button
reading "Start verifying" or "Continue" depending on whether done > 0. Below it, three
lines of guidance:

  - Mark only what is actually written. A vague gesture or a hedge is not present.
  - Do not award points. Mark each element present or absent, nothing else.
  - If you see the AI's marking or the grader's score, use the flag link and move on.

No table of past submissions, no ability to review completed work.

## Visual direction

Match the existing reviewer portal: warm off-white canvas, deep green navigation, white
cards, restrained amber and red. Serious editorial workbench. The answer card is the
visual focus of the screen. No gamification, no streaks, no confetti, no celebratory
completion animation.

## Explicitly out of scope — do not build

- Any display of AI grading results, confidence, or verifier agreement.
- Any adjudication, disagreement-resolution, or comparison view.
- Any editing of content items, criteria, or rubrics.
- Any export, or any view of another reader's marks.
- Element decomposition editing. That is a separate spreadsheet workflow and does not
  belong in this app.
```

---

## Notes for whoever runs this

- **The 100%-verification rule is a pilot-only setting.** After certification, the same
  screen serves a ~100-answer sample per set; nothing in the UI needs to change, only how
  many assignments get seeded.
- **`element_label` is doing real work.** For Set B (Statistics, Physics) each criterion is
  a single point, so `element_label` is just the criterion's `learner_facing_text`. For
  Set A (Biology, Chemistry) it is one row per point from the confirmed decomposition, and
  the criterion will expand to several elements. The contract above already carries
  `element_index`, so the screen does not change when Set A arrives.
- **Point values are withheld by choice, not oversight.** If a reader objects that they
  need them to judge, that is worth hearing — but the protocol asks for element presence,
  and points are the input to exactly the scoring behaviour we are trying to keep out of
  the reader's head.
