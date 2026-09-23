# BYOQ Answer Visibility and Data Model — Discussion

**Status:** Rule approved (see DECISION-0057); data-model approach is a recommendation, not yet approved; hint-throttling idea explicitly deferred.
**Date:** 2026-09-23
**Owner:** David Bloom
**Related:** `docs/product/APP_REBUILD_MIGRATION_PLAN.md` (Decision 21 — Open Hand answer-key serving contract), `docs/activity_log/DECISIONS_LOG.md` DECISION-0057, `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`, `docs/tasks/UX-004-STUDENT-PROVIDED-QUESTION-INTAKE.md`

## Context

Decision 21 in the App Rebuild Migration Plan left the Open Hand answer-key serving
contract with its *method* sanctioned (full-disclosure teaching is approved) but the
serving mechanism unresolved: the schema currently forbids serving `mcq_choices.is_correct`
/ `rationale` to any authenticated student (`20260824060000_revoke_mcq_answer_key_from_authenticated.sql`,
`20260827010000_mcq_choices_public_view_drop_answer_key.sql`).

This session's research found the reason it's safe to simply unblock Open Hand today:
**BYOQ (bring-your-own-question / photo-capture of a student's own homework) has no
backend tables yet.** `app.mcq_choices` and `app.frq_criteria` only ever contain
CramApple library content, joined through the curated `exam_pack → subject` hierarchy.
BYOQ is currently frontend-prototype-only (`/beta/preview/byoq/add`, `/bring-question`,
`/byoq`, `/ask`, `/check-work` routes; no `content-intake` or `capture-pairing` edge
function exists; no BYOQ table in any migration).

That gave the opening to ask the actual product question directly, since "Open Hand
always serves library content" was previously assumed, not confirmed. David confirmed
it explicitly in this discussion.

## The rule (approved — see DECISION-0057)

- **Open Hand questions are always pulled from the CramApple library.** They are never
  a student's own submitted question. The canonical answer/rubric can be shown in Open
  Hand mode because the content is CramApple-authored.
- **A BYOQ item must never be given an actual answer, in any mode.** This is not an
  Open-Hand-vs-Practice distinction — it is a provenance rule. A BYOQ item stays
  answer-free everywhere it appears.
- **BYOQ items may still receive substantial help**, just not the answer itself:
  rubric-derived hints, deep-dive material, reference content, and "how you win or lose
  points" strategy guidance are all allowed. The line is specifically the canonical
  worked answer / correct-choice reveal — not help in general.
- **Stuck-BYOQ routing:** if a student cannot solve a BYOQ item, the product should
  recommend a related Open Hand (library) question and then route the student back to
  the original BYOQ item. This gives the student a fully-worked example without ever
  answering their own question for them.

## Open, explicitly deferred (not decided)

- **Hint throttling for repeat BYOQ use.** David raised the idea that a student
  submitting multiple BYOQ items might become eligible for progressively fewer hints
  per item (to discourage using BYOQ as a way to get an AP library's worth of scaffolding
  on outside homework). Explicitly flagged as "something to consider, not ready to
  decide." No design work should proceed on this until it is picked back up.

## Future direction: BYOQ as SEO/AEO seed content

BYOQ submissions may be used to seed new SEO/AEO pages (design TBD), similar in spirit
to the existing per-question FRQ answer-page template
(`FrqQuestionData` already has a `source: 'official' | 'student'` field and a shared
`FrqQuestionPage` template designed for exactly this reuse — see
`docs/product/` per-question FRQ SEO planning). A promoted BYOQ item becomes public,
citable content at that point — which is a different trust state than "a student's
private, ungraded, un-vetted submission," and the data model should make that
transition an explicit, deliberate step rather than an implicit one.

## Data model question and recommendation

**Question raised:** should BYOQ items live in the same tables as CramApple-developed
(library) questions, or a separate table?

**Recommendation (not yet approved): separate table, unify only at the render layer.**

Reasoning:

1. **Security is the deciding factor.** The current answer-key lockdown holds by
   role/grant on `app.mcq_choices`, not by a provenance check — it has never had to
   distinguish library from BYOQ content because BYOQ has never touched that table.
   If BYOQ items are added to the same table, "never leak the answer" becomes a
   permission that has to be gotten right on every future query, RPC, and migration
   touching that table. A separate table (with no answer-bearing columns present at
   all, or with those columns simply not populated/not granted) makes the leak
   structurally impossible rather than policy-dependent.
2. **The content lifecycles differ.** Library items are authored and reviewed before
   they exist in the table at all. BYOQ items arrive raw and unvetted and need
   moderation/dedup before they're usable for anything, including hints. That is closer
   to the existing reviewer/content-governance pipeline (`content_review_assignments`)
   than to the publish-then-serve model library content uses.
3. **Unify at the point of promotion, not before.** When a BYOQ item is chosen to seed
   a public SEO/AEO page, that promotion step should materialize a library-shaped
   record (or a promoted view) carrying `source: 'student'`, matching the FRQ-question
   page template's existing design. Before promotion, the item stays in its own table
   with none of the answer-bearing shape to accidentally expose.
4. **BYOQ-specific state has nowhere sensible to live in the library table anyway** —
   a hint-budget/throttling counter (see the deferred idea above), moderation status,
   duplicate-detection state, and submitting-student ownership are all naturally
   BYOQ-only columns.

## New requirement captured: BYOQ metadata

Whatever the eventual BYOQ schema looks like, David has specified it needs at minimum:

- **Difficulty** (a difficulty label/estimate for the submitted item)
- **Unit/topic pair** (mapping the BYOQ item to a CED unit and topic, the same way
  library items are mapped, so it can sit inside the existing study-map/topic
  structure and — if promoted — the existing SEO unit taxonomy)

This is a captured requirement for the eventual BYOQ intake design, not a schema yet.
No migration exists for this today.

## Not yet done

- No migration has been written for a `byoq_items` (or similarly named) table.
- No RPC has been written to serve Open Hand's answer key for library content
  (the original Decision 21 serving-mechanism gap). That RPC is unblocked by this
  discussion (it can safely omit any BYOQ provenance check today, since BYOQ isn't
  reachable through `mcq_choices`/`frq_criteria`), but still needs to be written.
- The stuck-BYOQ → related-Open-Hand-question → return-to-BYOQ routing flow has no
  design or implementation yet.
