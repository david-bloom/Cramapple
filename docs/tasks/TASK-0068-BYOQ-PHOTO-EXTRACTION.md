# TASK-0068 — BYOQ Photo Extraction With Student Confirmation

**Task ID:** TASK-0068
**Title:** Read a photographed question with a model, propose type, text, choices, and topic; the student edits every field and confirms before the item is practice-ready
**Owner:** Claude session (implementation). **Product Owner:** David Bloom
**Tier:** Hard-Gate (model processing of student uploads, schema migration, new capability-scoped ops, Production deploy)
**Status:** Approved at Gate A, not started (2026-10-08, `DECISION-0108` / `APPROVAL-0139`). Gate B (Development build) not yet requested.
**Priority:** High
**Created Date:** 2026-10-08
**Approved Date:** 2026-10-08 (Gate A only: plan, benchmark design, capability design)
**Branch:** `claude/task-0068-byoq-photo-extraction-plan` (plan, PR #391). The build opens its own branch, `claude/task-0068-byoq-photo-extraction`, on the first implementation session and records it here.
**PR:** #391 (plan). Build PR: none yet.
**Design:** `docs/product/BYOQ_PHOTO_EXTRACTION_PLAN_V2_2026_10_08.md` (governing). Critique and David's answers: `docs/product/BYOQ_ATTACHMENT_EXTRACTION_PLAN_CRITIQUE_2026_10_08.md`. Superseded: v1 plan, `BYOQ_WORKSHEET_PARSING_DESIGN.md`, `TASK-0039` Phase 3.
**Related:** `TASK-0039` (shipped baseline, Done), `DECISION-0057`, `DECISION-0077`, `DECISION-0084`, `DECISION-0108`, `APPROVAL-0139`

## Product Goal

A student photographs a homework question and, a few seconds later, sees it already filled in: multiple choice or free response, the question text, the answer choices, and a topic within their current unit. They fix anything wrong and confirm. They never retype the question and never have to type mathematical or scientific notation. Typing remains available as a fallback and as the editor for every field. Nothing is graded and no answer is ever shown (`DECISION-0057`).

## Technical Scope

Exactly the plan's §4–§5. In brief:

1. **Migration (additive):** `app.byoq_items.extraction jsonb` (proposal, alternatives, warnings, model and prompt version, page digests, status) and `app.byoq_items.captured_work text` (≤ 4,000 chars; the student's own marks on the page, never stem or choices). No new tables, no new RLS policies, DB `ready` CHECK unchanged.
2. **Extraction module** `supabase/functions/_shared/byoq-extraction.ts` on the `capture-quality-check.ts` pattern: OpenAI Responses API, `store: false`, closed JSON schema (type, stem, choices, topic enum from the supplied unit list plus `unsure`, alternatives, captured_work, answer_key_present, possible_personal_information, unreadable/visual-only regions, looks_like_subject), timeout, cost reservation, daily USD breaker, `unavailable` when not configured. Input: the item's question pages, the subject display name, and the unit's topic list; no identifiers. Output passes `validateItemFields`, `detectAnswerLeaks`, and taxonomy resolution before any write; proposed fields fill only null item fields.
3. **Ops in the `byoq` function:** extraction runs synchronously inside `finish_capture`; new owner op `extract_question` for re-runs; three capability-scoped review ops (`capture_review_get`, `capture_review_update`, `capture_review_remove_flagged_text`) bound to the pairing's item, plus a one-time 15-minute pairing-window extension at `finish_capture`. Idempotent on `(item_id, page_digests, prompt_version)`.
4. **Lovable App:** new `ByoqReview.jsx` (photo thumbnails, every field editable and prefilled, warnings, topic select within the unit with up to two alternatives and "I'm not sure", primary action "Yes, this is my question"), used on the phone after Done and on the desktop as a prefilled form; "Try reading it again"; config flag `BYOQ_EXTRACTION_ENABLED`; PostHog events per plan §5.5.
5. **Benchmark harness:** rendered fixtures from published items (stratified by subject, MCQ and FRQ, clean and degraded), ~40 real phone photos of printed Cramapple items, planted controls, and a notation cohort; report against plan §6.3.

## Out of Scope

Worksheets or any multi-question splitting; PDFs; subject or unit inference from the image; a vendor bake-off; math rendering (KaTeX); per-field confidence highlighting; an async job queue; displaying `captured_work`; grading, answer checking, or worked solutions; promotion of BYOQ items to canonical or public content; any privacy-policy change (`DECISION-0108` item 3).

## Routes / Components / Systems Affected

- Supabase: `app.byoq_items` (two new columns); edge function `byoq` (new ops); new `_shared/byoq-extraction.ts`; new env `BYOQ_EXTRACT_MODEL`, `BYOQ_EXTRACTION_ENABLED`, `BYOQ_EXTRACT_DAILY_CAP_USD`; existing `OPENAI_API_KEY`.
- Lovable App `56cae479`: `/byoq/capture` (phone leg gains the review step), `/byoq/new` (desktop prefill and retry), new `src/screens/byoq/ByoqReview.jsx`, `src/lib/byoq/api.ts` (new ops), PostHog wiring.
- Marketing `61dd6602`: the homepage BYOQ section's retention wording must match the shipped 30-day purge before the pilot (flagged 2026-09-26).

## Data / Security / Integration Impact

- Student photo bytes (already metadata-stripped derivatives) are sent to OpenAI with `store: false`; no owner id, item id, filename, or account data accompany them.
- The three review ops are the one new security surface: they must act only on the pairing's bound item, refuse expired/consumed/cancelled/malformed handles, and never return an owner key on the phone leg.
- `captured_work` is BYOQ-private: no non-BYOQ path reads it; it is never shown as correct and never graded.
- Rollback is the config flag: off returns the shipped photo-then-type flow; the two columns stay, unused.
- No change to quotas, the 30-day anonymous purge, RLS, or the no-answer DB CHECKs.

## Acceptance Criteria

- [ ] Benchmark report meets plan §6.3 (item type ≥ 97%; stem zero-edit ≥ 85% on clean rendered; choices complete and ordered ≥ 95% with 0 invented; topic top-3 within unit ≥ 90%; 0 answer text in stem/choices after validation on planted controls; abstention ≥ 95% on unreadable pages; median single-page latency ≤ 10 s).
- [ ] A phone-captured question reaches a prefilled review screen on the phone and, abandoned there, opens prefilled on the desktop.
- [ ] Every proposed field is editable; `ready` is reachable only through the explicit confirm; a student edit is never overwritten by a re-run or a second page.
- [ ] Planted handwritten answers and circled options land in `captured_work`, not stem; a planted answer key is dropped with the warning shown.
- [ ] Capability scoping: handle for item A cannot touch item B; expired/consumed handles refused; extension happens once.
- [ ] Model unavailable, timeout, malformed output, or breaker tripped → photo kept, typed form works, no partial fields written.
- [ ] Regression: typed intake, QR capture, multi-page, retake, delete, 30-day purge, HEIC rejection, anonymous/signed-in parity, no graded-practice import in BYOQ files (existing test).
- [ ] Review screen usable at 390 px with keyboard and screen reader; progress and completion announced.
- [ ] PostHog events emitted with no question text, image content, or owner key.
- [ ] Pilot (Micah, Orly, David; two weeks or 30 confirmed items): report on zero-edit confirmation rate, median Done-to-confirmed time, abandonment, failures, spend, and testers' direct feedback.

## QA Plan

Independent context, per plan §7.3: contract tests (schema closure, allowlist rejection, leak gate, topic resolution, idempotency); capability-scoping tests; fallback paths; edit safety; answer-mark routing; regression suite; UX/accessibility pass; live phone check with the flag on and off. QA proposes Pass/Fail and does not authorise Production.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:**

| Gate | State | Authorises |
| --- | --- | --- |
| A — Plan | **Approved 2026-10-08** (`APPROVAL-0139`) | Slice 1 design and benchmark work; no app or schema change |
| B — Development build | Pending | Development migration, function deploy, Lovable preview work |
| C — Production pilot | Pending | Production migration and deploy with the pilot flag on |
| D — Expand | Pending | General availability or hold |

## Implementation Notes

None yet.

## QA Review

**QA Verdict:** Pending.

## Done Decision

**Decision:** Pending
**Date:** —
