# Plate Loop Build Plan — 2026-09-27

**Status:** In progress | **Owner:** David Bloom | **Decision:** Make the plate loop the real
student-facing architecture (David, 2026-09-27: "execute the plate loop … completing student hub
including this architecture is your goal").

**Part of:** `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`. Lovable app project `56cae479`
("New Cramapple App"); Supabase Prod `pcntajvbdfqhbeewmdry`, Dev `wmgjsdkphcyhngaffbqf`.

## The architecture

Four question templates: **Open Hand** (MCQ/FRQ) and **Practice** (MCQ/FRQ).
- **Open Hand** = teaching mode, everything face-up: correct answer + per-choice rationale (MCQ),
  rubric criteria + credited-response segments (FRQ), plus reference and deep dive. No grading.
- **Practice** = the student does a real item, graded through the existing chain
  (`session-event → attempt-response → evaluate-attempt`); the aid panes (rubric, how-points, deep
  dive, reference) are **hint-gated** (closed by default, each revealed by its own hint, which marks
  the attempt coached).
- **The loop:** from an Open Hand item the student picks **"Try one on your own"** → Practice with a
  same-skill item loaded, or **"Upload your own question"** → Practice in **BYOQ** mode.

**BYOQ never grades.** Per David 2026-09-27: "we do not grade or correct student work. we will scaffold
their byoq with rubric, reference, deep dive and any other info but not grade." BYOQ classifies the
pasted question into a cell and shows that cell's scaffolding around the student's own question.

## Key finding: it's a gated read, not authoring

The Open Hand "face-up" content already exists server-side; the practice serving path
(`student-session-items`) deliberately strips it so a practising student can't read the answer. Data
locations: `app.mcq_choices` (`is_correct`, `rationale`), `app.frq_criteria` (rubric),
`app.canonical_answer_spans` (FRQ credited-response segments), `app.topic_explainers` (reference),
`app.topic_point_briefs` (deep dive).

**Coverage (Production, 2026-09-27) — live Open Hand is feasible for both Day-1 subjects:**

| Subject | MCQ w/ correct+rationale | FRQ w/ criteria | FRQ w/ credited-response segments |
| --- | --- | --- | --- |
| AP Biology | 43/43 | 75/75 | 71/75 |
| AP Statistics | 304/304 | 69/69 | 35/69 |

FRQ degrades gracefully where segments are missing (show criteria + canonical answer, skip the
segment-highlight interaction). This overturns the earlier recon note that live Open Hand FRQ was blocked.

## Phases

- **P1 — Frontend plumbing (DONE, Lovable commit `96219e2c`, off by default, `/session` preserved,
  415/415 tests).** Same-skill targeting params on Live Practice (`bias.ts`), Open Hand "Try one on
  your own" CTA, and a `plate-loop` feature flag + `practiceEntry()` switch (only `startPractice`
  routes through it).
- **P2 — Live Open Hand (IN PROGRESS).** New gated edge function
  `supabase/functions/open-hand-item/index.ts` (this commit): authenticated (`requireProfile`) +
  entitlement-gated (active `subject_entitlements` for the subject, or staff/QA), returns the face-up
  payload (MCQ choices w/ is_correct+rationale; FRQ criteria + canonical + credited-response spans;
  plus per-topic reference + deep dive). Data layer Dev-verified (Stats MCQ). Frontend: new
  `LiveOpenHandMcq`/`LiveOpenHandFrq` containers + adapters + routes wiring Open Hand to this read
  (Lovable, in progress).
- **P3 — BYOQ scaffold, no grade (DONE, Lovable `dab60c01`, 432/432 tests).** `/byoq` paste →
  `classifyHomeworkQuestion` (AP Stats Unit 1) → `/byoq-scaffold` showing the student's own question
  read-only with the topic's rubric/how-points + reference + deep dive hint-gated. No grade/submit/
  answer. Reuses `topic-content.ts` (`fetchTopicGuides`) — no new backend. Open Hand's "Upload your own
  question" CTA routes here. Removed the legacy "Check my work" help-mode option.
- **P4 — deploy package (the remaining Hard Gate).** Whole loop built + Dev-verified behind the
  off-by-default flag. Because the Lovable app + preview point at Production Supabase, going live needs:
  (1) deploy `open-hand-item` to Production (additive, read-only, entitlement-gated; via the repo's
  edge-function deploy / PR #214), (2) publish the Lovable app, (3) flip `?loop=plate` and verify
  end-to-end, then decide when to default the flag on. Non-blocking follow-ups: Open Hand FRQ "null"
  title when `topic_code` missing; FRQ text stimulus not rendered; empty reference vocabulary; BYOQ =
  AP Stats Unit 1 only; nothing browser-verified until the function deploys.

## Security note

`open-hand-item` is the ONLY path that exposes answer keys to a student, gated on entitlement, in a
separate function the Practice/exam grading path never calls — so the answer key cannot leak into a
graded attempt.

## Hard-Gate boundary

Everything is built and verified on Dev + the Lovable preview + a repo PR. The Production deploy of the
edge function and the Lovable publish are Hard Gates for David; they are NOT done autonomously.
