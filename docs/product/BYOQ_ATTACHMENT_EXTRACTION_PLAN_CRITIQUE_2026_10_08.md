# Critique: BYOQ Attachment Extraction and Confirmation Plan (PR #387)

**Status:** Review notes — not a decision record
**Date:** 2026-10-08
**Reviewer:** Claude (Fable 5.1)
**Subject:** `docs/product/BYOQ_ATTACHMENT_EXTRACTION_AND_CONFIRMATION_PLAN_2026_10_08.md` (Codex, PR #387, open, docs-only, CI green, no reviews)
**Purpose:** Find weaknesses, challenge assumptions, and pose the questions David has to answer before the plan is approved. Nothing here authorises implementation.

Everything below is checked against live sources, not the plan's own description of them. Sources: the shipped schema (`supabase/migrations/20260928150000_task0039_byoq_core.sql`, `..._hardening.sql`), the `byoq` edge function and `_shared/byoq.ts`, `_shared/capture-quality-check.ts` and `capture-pairing/index.ts`, the Lovable App project `56cae479` (`src/lib/byoq/api.ts`, `src/screens/byoq/ByoqIntake.jsx`, `ByoqCapturePhone.jsx`, routes), Production `app.byoq_*` and `app.content_*` row counts (read-only, 2026-10-08), `docs/legal/PRIVACY_POLICY.md`, `TASK-0039`, `DECISION-0057/0068/0076/0077/0084`, and the two design docs the plan cites.

---

## 1. Evidence the plan does not state

### 1.1 Production usage is effectively zero

Production `app.byoq_*` on 2026-10-08:

| Measure | Value |
| --- | --- |
| `byoq_items` total | 3 (one each on 09-28, 10-02, 10-08) |
| source_kind / status | all `photo_single` / `draft` |
| items with a question photo but empty stem | 2 |
| `byoq_responses` | 0 |
| owners | 1 anonymous, 1 signed-in |
| pairing tokens | 2 consumed, 1 expired |

Nobody has completed the current flow. Two of three photo items never got the typed transcription, which is consistent with David's intuition that typing after photographing is where students stop, but at n=3 (almost certainly internal testing) it is not evidence. The plan presents the 2026-10-08 direction as product intent, which is legitimate, but it should say plainly that there is no usage data behind it, and Slice 0 should consider the cheapest possible probe: watch three to five real students use the current photo-then-type flow before building a parser.

### 1.2 "No vendor is selected" is already untrue in practice

`capture-pairing/index.ts` (lines 84–128, 1331) calls `runCaptureQualityCheck` from `_shared/capture-quality-check.ts`, which POSTs student photo bytes to `https://api.openai.com/v1/responses` with `store: false`, a strict JSON schema, a per-call cost reservation, a daily USD cap, and a timeout. `evaluate-attempt` requires `OPENAI_MODEL`. Cramapple therefore already has:

- an external processor relationship for student images (OpenAI),
- a working pattern for a vision call with no vendor retention, fail-closed cost control, and schema-constrained output,
- a privacy policy that already says Cramapple "may collect the content of that submission and any text we extract from it" (`docs/legal/PRIVACY_POLICY.md` §4, line 45; §3 line 41 names "extracted content from images, screenshots, or documents").

Whether the capture-quality call actually runs in Production depends on `OPENAI_API_KEY`/`CAPTURE_QUALITY_MODEL` being set there, which this review did not check. But the plan's §8.4 and Slice 1 treat vendor selection as greenfield and gate everything behind a ten-subject offline bake-off with human ground truth. That is the most expensive possible first step. The alternative worth putting in front of David: build the extraction on the existing OpenAI pattern in Development, measure it on the benchmark in §1.3, and run a comparison only if it fails the bar. §14.12 (privacy-policy timing) is partly answered by the existing policy text; what the policy lacks is naming the processor, not the concept of extraction.

### 1.3 The benchmark's ground truth already exists in the database

Production has 2,170 published MCQs and 583 published FRQs, each with stem, choices, subject, unit and topic already labelled (only 6 carry a stimulus image). Rendering those items into synthetic page images (clean, then degraded with rotation, blur, glare, multiple per page) gives a benchmark with automatic ground truth for boundary detection, choice completeness, and subject/unit/topic accuracy, with no rights question and no human labelling. The plan's Slice 0 ("build the rights-controlled benchmark and human ground truth") does not mention this and instead implies a bespoke labelled corpus. A small purpose-photographed set is still needed for the real-phone cohort, but it can be tens of photos, not hundreds.

### 1.4 The shipped flow is two-device, and the plan's flow is one-device

`ByoqIntake.jsx` mints a pairing token on the desktop, the phone leg (`ByoqCapturePhone.jsx`) uploads pages, and the desktop polls, then shows "Next: type the question". The plan's §5.1 ("Choose Take a photo / Upload an image, preview, crop, submit, review beside the original") reads as a single-device flow. It never says where the review card lives: on the phone (small screen, side-by-side is impractical) or on the desktop after polling. `DECISION-0076` made phone capture launch-required, so this is not a detail. Related: the marketing homepage's "your photo isn't kept" copy is still at odds with 30-day retention (flagged 2026-09-26, not yet confirmed fixed).

### 1.5 Governance state

- David's 2026-10-08 direction exists only as a quote inside the plan. No `DECISION`/`APPROVAL` entry records it. Gate A needs one.
- `TASK-0039` still reads "Phase 3 blocked on `BYOQ_WORKSHEET_PARSING_DESIGN.md`". The plan supersedes Phase 3's default and the worksheet design's vendor question but does not say what happens to TASK-0039 (close it as Done for Phases 1–2? fold Phase 3 into the new task?).
- `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (2026-06-13) is cited as the source of the confirmation UX, but much of it is superseded: four help modes, "Check my work", `gpt-4o-mini` rubric calibration, Open Hand routing. `DECISION-0057`/`0084` retired all of that. The plan should name which sections are still live (Stage 2 "Original vs Captured", Stage 3 confidence bands, §5.1 PII warning, §12 accessibility) and which are dead.
- Highest records today: `DECISION-0105`, `APPROVAL-0137`, `TASK-0067`. Open PRs claim none of the next numbers except PR #387 itself (docs only).

---

## 2. Assumptions to challenge

### 2.1 Subject/unit/topic inference is scoped as a model problem; it is mostly a product-context problem

- A signed-in student has an active subject (`src/lib/active-subject.ts`, `home-subject-param.ts`). Even anonymous visitors arrive from a subject-specific marketing path. Inferring the subject from pixels, then gating on ≥98% top-1 across ten subjects, solves a problem the product can mostly avoid: default to the known subject and let the model raise "this doesn't look like AP Biology".
- The ≥90% top-1 topic gate (§9.3) is probably unreachable and not needed. Cramapple's own content pipeline needs five-of-six checker agreement to label a topic on an item it wrote itself. A single-question photo is harder. The only consumer of the topic in BYOQ is the reference/hints panel; a wrong topic costs the student mildly irrelevant hints, not a wrong grade. The right shape is: unit proposal (one gate), top-3 topics plus "I'm not sure" (§14.6 already recommends this), and measure correction rate in the pilot rather than a top-1 threshold in the lab.
- Mechanism is unspecified: "taxonomy values must resolve to the live taxonomy" needs to say how. Passing all ten subjects' topic lists into one prompt is large and slow. A two-stage call (subject known → unit list → topic enum constrained in the JSON schema) keeps output structurally valid. The hyphen/underscore subject-key trap (`ap-biology` vs `ap_biology`) is live in this codebase and must be in the contract.

### 2.2 Per-field confidence is UI complexity built on a signal that is not calibrated

§5.3 builds three UI states (high/moderate/low) on per-field confidence from the model. Self-reported confidence from vision models is poorly calibrated; Cramapple's own OCR work found Vision-framework confidence took three discrete values and tracked correctness weakly. Alternatives that are cheaper and more honest: deterministic validity signals (2–6 choices, non-empty stem, a question mark or imperative verb), a two-pass agreement check (majority vote worked in the Engine 4 investigation), or simply no confidence UI in v1: show every field editable, highlight nothing, and measure which fields students correct. The plan's own §3.3 ("do not trade convenience for fabrication") is served better by "always review everything" than by a confidence band that tells the student they can skim.

### 2.3 The answer-material gate is specified in a way that cannot work as written

§6.2 says visual answer signals (circled/checked/bolded options, worked calculations, teacher marks) are flagged, masked, and "confirmation stays blocked while the server-side gate still detects an answer-bearing span." Two gates are being conflated:

- The shipped server-side gate is a regex with three rules (`answer_label`, `correct_marker`, `trailing_answer_line` in `_shared/byoq.ts`). It runs on text and is re-run on every edit. It cannot see a circle.
- A visual flag comes from the model once, on the image. It cannot be re-run on edited text; the circle is still in the photo no matter what the student types.

So either visual flags are advisory (mask by default, student asserts "not an answer", regex gate still applies to the text) or the model must re-run on every edit, which is expensive, non-deterministic, and gives a false positive no exit. The plan should pick the first and say so. It should also admit the regex will not catch "The correct choice is B because..." and decide whether the extraction prompt plus a schema with no answer field is the real control (it is), with the regex as a backstop.

### 2.4 The no-answer rule is being applied to the student's own writing

The most common BYOQ photo will be completed homework: the student's own answer written on the page. The worksheet design (§6.2) treats a student's own handwritten answer as a leak channel. That deserves a direct question: does `DECISION-0057` forbid Cramapple *revealing or grading* an answer, or forbid *storing any answer text at all*? If the former, a student's own circled "B" is their information and masking it is friction without benefit; the risk worth guarding is an answer key or teacher marking, and a future promotion path (already barred for `worksheet_split`). If the latter, the plan must expect to mask the common case, and the UX should be designed around it rather than treating it as adversarial. §6.3's `capture_role = response` separation is correct but does not cover a question photo that already has work on it.

### 2.5 PDFs in v1 add a new upload and parsing surface the plan does not cost

§14.2 recommends "phone photos/screenshots plus image-based and ordinary PDFs". The shipped storage path accepts only `image/jpeg|png|webp` (`ACCEPTED_MEDIA_TYPES`), ≤20 MB, with EXIF stripping that fails closed and a 10-current-page limit. PDF means: a new validation path, a PDF renderer inside a Deno edge function or a separate worker (malformed files, embedded JavaScript, encryption, decompression bombs), and a new vendor-or-library decision the plan says it is not making. Multi-page photo capture already exists (up to 10 pages per question). Dropping PDFs from v1 removes an entire security review from the critical path.

### 2.6 The staging schema is sized for worksheets but imposed on single photos

`byoq_items` already has `draft` status, nullable `stem`/`choices`/`item_type`/`subject_key`/`taxonomy_topic_id`, `leak_flags`, and `source_kind = 'photo_single'`. A single-photo proposal can live on the draft item itself (one additive `extraction` jsonb column holding the proposed fields, alternatives, warnings, model/prompt version, and digest), with the student's edits going through the existing `update_item`/`confirm_item` path and the existing leak gate. `byoq_intake_batches`/`byoq_intake_candidates` earn their place for worksheets (dedupe, resume, per-candidate resolution). The plan should split the schema decision by slice so Slice 2 needs one column and no new RLS surface.

### 2.7 Async processing is named but the infrastructure is not

§8.3 says parsing goes asynchronous "once it cannot reliably finish within the existing request budget". A single-photo vision call is seconds and can stay synchronous inside the `byoq` function with a timeout (the capture-quality pattern). A 20-page worksheet cannot. The repo has pg_cron and pg_net (used for the purge) but no job queue, no worker, and no status-polling contract. If Slice 3 needs a queue, that is new infrastructure and should be named as such, with the choice (pg_cron polling a jobs table, Supabase queues, or an external worker) made at Gate C, not discovered mid-build.

### 2.8 Cost controls need numbers, not adjectives

Quotas today: 30 items per owner per day, 200 live items, 120 anonymous owners per IP per hour, 5,000 per hour globally. A worksheet extraction at 20 candidates per upload with a vision model is a materially larger spend per call than anything BYOQ does today. The plan says "rate limits and global spend/circuit breakers fail closed" but gives no figures. The capture-quality module already has the shape (`CAPTURE_QUALITY_RESERVED_COST_USD`, `CAPTURE_QUALITY_DAILY_CAP_USD`); the plan should propose: parse calls per owner per day, pages per owner per day, per-IP per hour, and a global daily USD cap, each failing closed before the model is invoked.

### 2.9 Quality gates are stated as absolutes that cannot be measured as written

- "0 accepted hallucinated stems/choices": accepted by whom? The student confirms, so the measurable quantity is unflagged hallucination in the benchmark and the student correction rate in the pilot.
- "≥98% clean printed single-question detection": fine as a benchmark number, but the benchmark cohort definition (rendered items vs. real photos) must be fixed before the number means anything.
- "Functional parity anonymous vs signed-in": already true of the shipped function (one code path, `caller.primary` either way). State it as a regression check, not a gate.
- No pilot metric is tied to the product goal. The goal is "upload is the input" (§3.1). The pilot gate should be something like: median time from upload to confirmed item, and fraction of confirmations that required zero edits to stem and choices.

### 2.10 Observability does not exist yet for BYOQ

Slice 4 monitors latency, correction rate, and flags. No BYOQ analytics events were found in the App project's PostHog wiring during this review (not exhaustively verified). The plan should list the privacy-safe events as a Slice 2 deliverable, otherwise the pilot produces anecdotes.

### 2.11 Slice ordering front-loads the most expensive work

Slice 0 (benchmark + human ground truth + bake-off budget) and Slice 1 (ten-subject vendor bake-off) happen before any student sees anything. Given §1.2 and §1.3, a leaner order is possible:

1. Record the decision; open the task; split TASK-0039's Phase 3 disposition.
2. Single-photo extraction in Development on the existing OpenAI pattern, benchmark = rendered published items plus a small real-photo set, one additive column, no staging tables, no PDFs, no confidence UI, unit + top-3 topic proposal, answer-key regex as the hard gate and model flags as advisory.
3. Named Production pilot (real phones, real homework) with events.
4. Decide from pilot evidence whether worksheets (staging schema, batch review, async jobs) are worth building, and whether a vendor comparison is needed at all.

That is the plan's Slices 2 → 4 with Slices 0–1 shrunk to a week, and Slice 3 made conditional.

---

## 3. Smaller points

- §7 "Preserve a reference to the source region": the model can return bounding boxes, but the practice screen must then crop and display them. For a graph or diagram question, extraction cannot reproduce the figure; the item must show the original photo (or a crop) as its stimulus. `byoq_items` has no stimulus field; `get_item` returns attachments. Say explicitly that the photo is the stimulus.
- §8.3 idempotency on "owner + source digest + parser version": a retake has a new digest, which is correct. Two students in one class uploading the same worksheet have different owners, so no cross-owner reuse, which is correct for privacy but means no cost sharing. Fine, but state it.
- §14.5 staging retention (24 h anonymous / 7 d signed-in): must cascade from `byoq_owners` and be swept by the existing 15-minute purge, not a new job.
- §11 QA "no direct `anon` grants": already true; `anon` has no grants on any `byoq_*` table. Keep as regression.
- Review card on a phone: the design doc requires reflow at 390 px. "Beside the original" has to become "above the original" on mobile; worth one sentence.
- The plan's §2 says it "expands worksheet parser output... to include subject, unit and topic inference". The worksheet design (§4.4) already proposed batch-level subject/topic defaults from the first confirmed candidate. The real expansion is per-candidate model inference instead of inherit-from-first; say that.
- The Vercel preview comment on PR #387 is noise (docs-only); the only required check is `test`.

---

## 4. Questions for David

1. **Motivation.** Is this product conviction, or a response to observed drop-off? With three items in Production, would you accept a short observation of real students on the current flow before building, or is the direction firm regardless?
2. **Vendor.** OpenAI already processes student photos for capture quality with `store: false`. Is an offline bake-off required before using the same vendor and pattern for extraction in Development, or is "build on the existing pattern, measure, switch if it fails" acceptable?
3. **Privacy policy.** The policy already covers extracted content. Does it need to name the processor before a Development pilot, before a named Production pilot, or before general availability?
4. **Taxonomy scope.** Accept: subject defaults to the known active subject, unit is proposed, topic is top-3 plus "I'm not sure", no top-1 topic gate?
5. **PDFs.** Photos only in v1 (multi-page is already supported), PDFs deferred?
6. **Where does review happen?** Same-device phone flow, desktop after QR pairing, or both? This decides the review-card design.
7. **No-answer rule.** Does `DECISION-0057` forbid storing any answer text, or forbid Cramapple revealing or grading one? A student's own answer written on the page is the common case, and the answer changes how strict masking must be.
8. **Schema by slice.** Single-photo proposal stored on the draft item (one column), staging tables only when worksheets are built?
9. **TASK-0039 disposition.** Close Phases 1–2 as Done and open a new task for this plan, with Phase 3 and `BYOQ_WORKSHEET_PARSING_DESIGN.md` marked superseded by it?
10. **Pilot testers.** Who are the named testers for Slice 4? Are there real students available now (Orly, Micah, others)?
11. **Spend ceiling.** What daily USD cap and per-owner parse quota are you comfortable with for the pilot?

---

## 5. What the plan gets right

- The no-answer boundary is carried through every layer (schema allowlist, regex gate, masking, promotion bar).
- Per-candidate confirmation with no bulk confirm.
- Rollback by feature gate that leaves confirmed items untouched.
- Preference for synthetic and Cramapple-authored fixtures.
- Explicit separation of `question` and `response` capture roles.
- Treating handwriting as a reported cohort rather than averaging it in.

These should survive any re-cut of the slices.
