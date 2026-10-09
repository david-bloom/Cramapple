# BYOQ Photo Extraction and Confirmation Plan (v2)

**Status:** Proposed — revision 2, awaiting David's review of this cut  
**Date:** 2026-10-08  
**Product Owner:** David Bloom  
**Prepared by:** Claude (Fable 5.1), revising Codex's v1 (`BYOQ_ATTACHMENT_EXTRACTION_AND_CONFIRMATION_PLAN_2026_10_08.md`) after David's answers of 2026-10-08  
**Supersedes:** v1 of this plan; the remaining scope of `TASK-0039` (Phase 3 worksheet upload) and `BYOQ_WORKSHEET_PARSING_DESIGN.md`'s open decisions  
**Governing rule unchanged:** `DECISION-0057` — a BYOQ item is never graded, never Open Hand, and never shows the student a canonical answer  
**Records to create on approval of this revision:** `DECISION-0106` (direction and the eleven answers below), `APPROVAL-0138` (Gate A), `TASK-0068` (implementation), closure note on `TASK-0039`  
**Tier:** Hard-Gate  
**Branch:** `claude/task-0068-byoq-photo-extraction-plan`

> **Boundary.** This revision is still a plan. It authorises no migration, deployment, secret, Production write, or launch. Gate B (below) is the first implementation authorisation.

---

## 0. What changed from v1, and why

David answered the eleven questions in `BYOQ_ATTACHMENT_EXTRACTION_PLAN_CRITIQUE_2026_10_08.md` on 2026-10-08. The answers, verbatim where short:

| # | Question | David's answer | Effect on the plan |
| --- | --- | --- | --- |
| 1 | Motivation | Disregard Production usage (internal testing). Students "loved the idea but pretty obviously would not invest the time needed to accurately enter all the information", and often cannot type mathematical or scientific notation on a QWERTY keyboard. | Direction is firm. Notation handling becomes an explicit requirement (§4.4). |
| 2 | Vendor | "Build-measure-switch is fine... for now stick with OpenAI." | No bake-off. Reuse the existing OpenAI call pattern (§5.2). |
| 3 | Privacy policy | Updated; add a link in the UI element. | Link already exists in the consent notice. One sentence still missing (§8.1). |
| 4 | Taxonomy | "Accept subject/unit from context, parse the question itself. We should be able to tell if it is an MCQ or FRQ." | The model does not infer subject or unit. It extracts type, stem, choices, and proposes a topic within the known unit (§4.2). |
| 5 | Inputs | Photos only for v1; PDFs later if usage warrants. | No PDF path. Multi-page photo capture (already shipped, up to 10 pages) covers multi-page questions. |
| 6 | Where review happens | "Same device through a QR code." | Capture and review on the phone; QR remains the desktop-to-phone handoff (§4.1, §6.3). |
| 7 | No-answer rule | "We can store a student's answer." | Answer marks on the page are stored as the student's own work, never as a key, and never block confirmation (§4.5). |
| 8 | Schema | "Single photo approved." | Proposal stored on the existing draft item; no staging tables (§5.1). |
| 9 | TASK-0039 | "Yes to all. This work supersedes remaining work from 0039." | Phases 1–2 close as Done; Phase 3 and the worksheet design are superseded (§9). |
| 10 | Pilot testers | Micah and Orly. | Named Production pilot (§7, Slice 2). |
| 11 | Spend | "No cap. We will see how it goes." | No product quota on extraction. A technical breaker is recommended, not required (§8.3). |

David also stated: **per-field editability is critical, including a prompt to confirm the content is correct.** That is now the central requirement of the review screen (§4.3).

The slices collapse from five to three. The ten-subject vendor bake-off, the staging schema, the PDF renderer, the per-field confidence UI, the async job queue, and worksheet splitting are all removed from v1 scope. Each is listed in §10 with the evidence that would bring it back.

---

## 1. The decision to encode

When a student photographs a question, Cramapple reads the photo and proposes the question's type (MCQ or FRQ), its text, its answer choices when present, and a topic within the student's current unit. The student sees every proposed field beside the photo, can edit any field, and must explicitly confirm "this is my question" before the item becomes practice-ready. Typing remains available as a fallback and as the editor for every field.

Subject and unit come from where the student already is, not from the photo.

"Answer choices" means the visible option text. BYOQ still stores no answer key, rubric, `is_correct`, or rationale. Marks on the page that are not the question (the student's own work, a circled option, a printed answer line) are kept out of the question text; see §4.5 for what happens to them.

---

## 2. Goals and non-goals

**Goals**

1. A usable photo produces a filled-in review screen in seconds. The student verifies; they do not transcribe.
2. Mathematical and scientific notation survives extraction well enough that the student never has to type it (§4.4).
3. Every field is editable; confirmation is explicit; nothing is saved as ready without it.
4. Extraction never fabricates: a missing choice, an unreadable line, or a figure it cannot describe is reported, not invented.
5. The same behaviour for anonymous and signed-in owners. Identity changes persistence, not capability (`DECISION-0077`).
6. Rollback by configuration. Turning extraction off returns BYOQ to the shipped photo-then-type flow with no schema change.

**Non-goals for v1**

- Worksheets, multi-question photos, PDFs, or any document splitting.
- Inferring subject or unit from the image.
- A vendor comparison before the first build.
- Grading, answer checking, or a worked solution for the student's question.
- Rendering math (LaTeX/KaTeX); see §4.4 for why plain text plus the photo is enough to start.
- Promotion of any BYOQ item into canonical or public content.

---

## 3. What exists today (verified 2026-10-08)

- **Schema:** `app.byoq_items` (draft/ready/archived; nullable `item_type`, `stem`, `choices`, `subject_key`, `taxonomy_topic_id`; `leak_flags`; a DB CHECK that `ready` requires a stem, a type, 2–6 choices for MCQ, and no leak flags; a CHECK that choices carry only `choice_key` and `choice_text`). `app.byoq_attachments` (question/response roles, up to 50 page rows, JPEG/PNG/WebP only, ≤20 MB, EXIF stripped fail-closed). `app.byoq_capture_pairing_tokens` (20-minute capability, hashed, storage prefix pinned at mint).
- **Edge function `byoq`:** owner ops (`create_item`, `update_item`, `confirm_item`, `remove_flagged_text`, `get_item`, `mint_pairing`, `pairing_status`, ...) keyed by an anonymous owner key or a verified JWT; capability ops on the phone leg (`describe_capture`, `create_capture_upload`, `submit_capture`, `finish_capture`) keyed only by the pairing handle. A three-rule regex answer-leak heuristic (`answer_label`, `correct_marker`, `trailing_answer_line`) over stem/choices/title/source note, masked by default, one-click removal, re-run on every edit.
- **Frontend (Lovable App `56cae479`):** `/byoq/new?mode=photo` creates a draft `photo_single` item, shows a QR (`PairingPanel`) with an "I'm on my phone — use this device" button, polls `pairing_status`, then shows "Next: type the question" and the typed form (type radio, stem textarea, choices, source note, subject/unit/topic selects). `/byoq/capture?t=` is the phone leg (take photo, add page, retake, done). `/byoq/$itemId` is practice: the question pages are displayed as thumbnails above the stem; stem is plain text (`white-space: pre-wrap`); no formula renderer exists in the App (`package.json` has no KaTeX/MathJax).
- **Existing vision call:** `_shared/capture-quality-check.ts`, used by `capture-pairing`, POSTs student photo bytes to OpenAI's Responses API with `store: false`, a strict JSON schema, `max_output_tokens`, a timeout, a per-call cost reservation, and a daily USD cap, failing closed to `unavailable` when not configured. Model from `CAPTURE_QUALITY_MODEL`, key from `OPENAI_API_KEY`.
- **Privacy policy (live App copy, 2026-08-22):** collects "extracted content from images, screenshots, or documents" and "any text we extract from" a submission; lists "storage and processing providers". It does not say that an AI model reads uploads and names no processor. The consent notice on the intake screen already links the policy. The copy in `docs/legal/PRIVACY_POLICY.md` is older (2026-06-23) than the live one.
- **Benchmark material:** Production holds 2,170 published MCQs and 583 published FRQs with stem, choices, subject, unit, and topic already labelled. Only 6 carry a stimulus image.

---

## 4. Student experience

### 4.1 Flow

```text
Desktop (unchanged start)                 Phone (capture + review)
1. Bring your own question → Photo        
2. Draft item created; QR shown           3. Scan QR (or "use this device")
                                          4. Take photo(s); Done
                                          5. "Reading your question…" (a few seconds)
                                          6. Review screen: photo + proposed fields
                                          7. Edit anything; "Yes, this is my question"
8. Desktop polling sees the item ready;   
   navigates to practice                  8'. Phone shows "Done — practise on either device"
```

A student already on a phone starts at step 1 on the phone and never sees a QR. Step 7 can also be completed on the desktop: the proposal lives on the item, so the existing desktop form opens prefilled if the student abandons the phone review (§6.3).

If extraction fails or is unavailable, step 6 becomes the shipped flow: the photo is kept and the student types, with the message "We couldn't read this one — type it in, or retake the photo."

### 4.2 What is proposed

| Field | Source | Student sees |
| --- | --- | --- |
| Subject | Context: signed-in active subject; anonymous: the intake screen's subject select, prefilled from a `?subject=` parameter when arriving from a subject page | Shown as context, changeable |
| Unit | Context: the student's saved unit position when one exists; otherwise the unit select | Shown as context, changeable |
| Question type | Model | Radio, prefilled |
| Question text | Model | Textarea, prefilled |
| Answer choices (MCQ) | Model, labels and order preserved | Editable list, prefilled; add/remove |
| Topic | Model, chosen from the known unit's topic list | Select within the unit, prefilled with the first proposal; up to two alternatives listed above the select; "I'm not sure" allowed |
| Where is this from? | Student | Optional text, as today |
| Warnings | Model + server | "We couldn't read part of this" (retake offered); "This doesn't look like a <subject> question" (subject change offered); "The photo has a graph/table we can't type out — it stays in your photo" |

The model never outputs subject or unit. It is given the unit's topic list and must answer with a topic code from that list or `unsure`; the JSON schema enforces this (an enum per call). Hyphen/underscore subject keys are normalised server-side as today.

### 4.3 Review and confirmation (the critical requirement)

- Every proposed field is an ordinary editable control, prefilled. Nothing is read-only.
- The photo is shown above the fields on a phone and beside them on a wider screen, tappable to enlarge.
- The primary action reads "Yes, this is my question". It is the only way an item becomes `ready`. There is no auto-confirm, no timer, and no "looks good" shortcut that skips the screen.
- Fields the model could not fill are empty and marked, not guessed. The confirm button stays enabled only when the existing readiness rules pass (type chosen, stem non-empty, 2–6 choices for MCQ, no leak flags).
- A second photo or a retake re-runs extraction and refills only fields the student has not edited. Student edits are never overwritten.
- No per-field confidence bands in v1. The signal is not calibrated, and "review everything" is the honest instruction. The pilot measures which fields students edit; that data decides whether highlighting earns its place.

### 4.4 Notation

Students cannot type `∫₀¹ x² dx` or `H₂SO₄` on a phone keyboard, which is half the reason for this work. The App renders stems as plain text and has no formula renderer. For v1:

- The model is instructed to output plain Unicode text: superscripts and subscripts, Greek letters, `√`, `≤`, `≥`, `≠`, `×`, `→`, fractions as `a/b` with parentheses where order matters, and no LaTeX.
- The original photo stays visible on the review screen and on the practice screen (it already does), so the photo is the authoritative rendering and the text is the editable transcript.
- When the model reports a region it cannot transcribe faithfully (a long derivation, a matrix, a labelled diagram), it says so in the stem in square brackets, for example `[see diagram in photo]`, and raises the "stays in your photo" warning rather than approximating.
- The benchmark reports notation fidelity separately for Calculus, Physics, Chemistry, and Statistics fixtures (§6.1).

Adding a math renderer is deferred (§10). The pilot will show whether plain Unicode plus the photo is enough.

### 4.5 Answer marks on the page

The common photo is completed or partly completed homework. The practice screen already shows the student their own photo, so masking a transcript of their own marks protects nothing. Under David's answer to question 7:

- The model is asked to separate **the question** (stem, choices) from **marks that are not the question** (handwritten work, a circled or ticked option, a printed "Answer: B", a teacher's annotation). The second group goes into a new nullable `captured_work` text field, never into stem or choices.
- `captured_work` is the student's own record. It is never shown as correct, never used by hints or reference, never graded, and never read by any path outside BYOQ. The practice screen does not display it separately in v1 (the photo is already there); it exists so the question text can be clean without pretending the marks were not seen.
- The existing regex gate on stem/choices stays as the backstop and keeps its current behaviour (masked, removable, blocks `ready` while present). The DB CHECK does not change.
- A printed answer key is not the student's work. If the model reports `answer_key_present: true` for the photo, the review screen says "This page looks like it includes an answer key. We kept only the question." and the key text is not stored anywhere, including `captured_work`. This is the one case where material is dropped rather than kept.

### 4.6 Personal information

Unchanged from the shipped flow: the consent notice asks the student not to include names, schools, or other people's details. The model additionally flags `possible_personal_information: true` when it sees a name, school, or contact detail, and the review screen shows the existing wording ("This may include personal information. Review and remove it before continuing.") with the stem editable. No `continue anyway` suppression; the flag is advisory because the student is editing the text anyway.

---

## 5. Technical shape

### 5.1 Data model: one additive migration

```sql
alter table app.byoq_items
  add column extraction jsonb,          -- proposal + metadata, see below; null until a run completes
  add column captured_work text check (captured_work is null or char_length(captured_work) <= 4000);
```

`extraction` holds: `{ status: 'proposed'|'failed'|'unavailable', model, prompt_version, page_digests[], proposed: { item_type, stem, choices[], topic_code, alternatives[] }, warnings[], answer_key_present, possible_personal_information, latency_ms, created_at }`. It is owner-readable through `get_item`, never through RLS directly (same posture as every `byoq_*` column: `anon` has no grants; `authenticated` reads only its own rows).

No staging tables. No new RLS policies. `source_kind` stays `photo_single`. Rollback is `extraction = null` behaviour, which is the shipped flow.

### 5.2 The extraction call

- Lives in `supabase/functions/_shared/byoq-extraction.ts`, modelled on `capture-quality-check.ts`: OpenAI Responses API, `store: false`, strict JSON schema, bounded `max_output_tokens`, `AbortSignal.timeout`, and the same `reserveCost` hook. Model from `BYOQ_EXTRACT_MODEL` (default: the value of `CAPTURE_QUALITY_MODEL`), key from `OPENAI_API_KEY`. Not configured → `unavailable`, never an error to the student.
- Input: the item's current question pages (metadata-stripped derivatives already in storage), in page order, up to the shipped 10-page limit; the subject's display name; the unit's topic list as `{code, title}`. No owner id, no item id, no filename, no account data.
- Output schema (closed; additional properties rejected): `item_type`, `stem`, `choices[{choice_text}]` (keys assigned by position server-side, as today), `topic_code` (enum from the supplied list plus `unsure`), `alternatives[]` (same enum, ≤2), `captured_work`, `answer_key_present`, `possible_personal_information`, `unreadable_regions[]`, `visual_only_regions[]`, `looks_like_subject` (boolean). There is no field in which an answer key can be returned as structured data.
- Post-processing: output goes through the existing `validateItemFields` (so a malformed choice or an over-long stem is rejected exactly as a typed one would be), then `detectAnswerLeaks` on stem/choices (backstop), then topic resolution against the live taxonomy. Anything that fails validation yields `extraction.status = 'failed'` with the reason, not a partial write.
- Trigger: `finish_capture` on the phone leg runs extraction synchronously (expected single digits of seconds; timeout 45 s) and then returns. A new owner op `extract_question` re-runs it on demand (for the desktop "Try reading it again" action). Both are idempotent on `(item_id, page_digests, prompt_version)`: a repeat with unchanged inputs returns the stored proposal without a model call.
- Writes: the proposal is stored in `extraction`; the proposed fields are also copied into the draft item's `item_type`/`stem`/`choices`/`taxonomy_topic_id` **only when those fields are still null** (never over a student's edit). `captured_work` is written. `status` stays `draft`.

### 5.3 Phone-side review needs a capability extension

The phone leg holds only the pairing handle, never the owner key (deliberate: the owner key must not travel through a QR). Today the handle permits upload ops only. Review on the phone needs three more capability-scoped ops, each valid only for the pairing's bound item while the pairing is live:

- `capture_review_get` → the item view (proposal, pages, readiness problem), masked exactly as `get_item` would mask it;
- `capture_review_update` → the same validated field patch as `update_item`, with `confirm: true` allowed;
- `capture_review_remove_flagged_text` → as `remove_flagged_text`.

They reuse the owner-op implementations with the caller resolved from the pairing token instead of the owner key. The pairing's `expires_at` is extended once by 15 minutes at `finish_capture` so the review window is 20 + 15 minutes; after expiry the phone shows "Finish this on your computer" and the desktop form opens prefilled. A consumed or cancelled pairing refuses all three ops. This is the main new security surface in v1 and gets its own QA section (§7.3).

A student on the "use this device" path has the owner key in that browser and uses the ordinary owner ops; the review screen is the same component either way.

### 5.4 Frontend (Lovable App)

- `ByoqCapturePhone.jsx`: after Done, show "Reading your question…", then the review screen (new `ByoqReview.jsx`), then the done state.
- `ByoqIntake.jsx` (desktop): when polling sees `extraction.status = 'proposed'` and the item is still draft, prefill the existing form from the proposal and show "Finish on your phone, or here"; when the item becomes `ready`, navigate to practice as today. Add "Try reading it again" (calls `extract_question`).
- `ByoqReview.jsx`: photo, editable fields (§4.2), warnings, topic select within the unit, "Yes, this is my question". Reuses the existing form controls; nothing imports graded-practice code (the existing test enforces this).
- Practice screen: unchanged except that `captured_work` is not displayed.
- Marketing homepage: the "Bring your own question" section already links into the App; the "your photo isn't kept" wording was flagged 2026-09-26 and must match the 30-day retention before the pilot.

### 5.5 Analytics (privacy-safe, prerequisite for the pilot)

PostHog events with no question text, no image content, no owner key: `byoq_extract_run` (status, latency band, page count, subject, unit, warnings present), `byoq_review_shown` (device: phone/desktop), `byoq_review_confirmed` (which fields were edited, as booleans; whether topic was changed; seconds on screen band), `byoq_review_abandoned`, `byoq_extract_retry`. These are the pilot's evidence.

---

## 6. Evaluation

### 6.1 Benchmark

Built from Cramapple-authored content, so there is no rights question and ground truth is free:

- **Rendered cohort:** render published items (a sample of ~60 per subject, MCQ and FRQ, including every item with a stimulus image) to page images with a script (HTML → PNG), then produce degraded variants: rotation ±5°, mild blur, uneven lighting, a page edge cut off. Ground truth is the database row: type, stem, choices, topic.
- **Real-photo cohort:** ~40 phone photos of printed Cramapple items taken by David, Micah, and Orly on their own phones, with the item id recorded. Same ground truth.
- **Planted controls:** rendered items with a handwritten-style answer written in, a circled option, an "Answer: C" line, a fake answer-key block, and a fake student name; plus blank, blurred-to-unreadable, and non-question pages.
- **Notation cohort:** the Calculus, Physics, Chemistry, and Statistics items with the densest notation, scored separately.

### 6.2 Measures

- Item type accuracy.
- Stem fidelity: normalised edit distance to ground truth, and the fraction of items needing zero edits.
- Choice count, order, and per-choice text fidelity; zero invented choices.
- Topic top-1 and top-3 within the unit; `unsure` rate.
- Abstention on unreadable/non-question pages.
- Planted controls: answer text in stem/choices (must be zero after validation), `answer_key_present` recall, `possible_personal_information` recall.
- Latency per page; cost per run.

### 6.3 Gates for Gate C (Production pilot)

Starting proposals, to be fixed in this document before the build so QA does not invent them afterwards:

| Measure | Gate |
| --- | --- |
| Item type (rendered + real) | ≥ 97% |
| Stem zero-edit rate (rendered, clean) | ≥ 85%; report degraded and real cohorts separately |
| Choices complete and in order (rendered, clean) | ≥ 95%; 0 invented choices anywhere |
| Topic top-3 within unit | ≥ 90%; top-1 reported, not gated |
| Answer text in stem/choices after validation (planted) | 0 |
| Abstention on unreadable pages | ≥ 95% |
| Median latency, single page | ≤ 10 s |

The pilot's own gate (Gate D) is different and is the one that matters: fraction of confirmations with zero edits to stem and choices, median time from Done to confirmed, abandonment rate, and Micah's and Orly's direct report.

---

## 7. Slices and QA

### Slice 0 — record and open (docs only)

Record `DECISION-0106` and `APPROVAL-0138`; open `TASK-0068` with this document as its design; close `TASK-0039` Phases 1–2 as Done with a note that Phase 3 is superseded; mark `BYOQ_WORKSHEET_PARSING_DESIGN.md` superseded in `docs/INDEX.md`; draft the privacy-policy sentence (§8.1) for David to place. Fix the gates in §6.3.

**Exit:** records merged to `main`. Gate A.

### Slice 1 — Development build

Migration (§5.1); extraction module and ops (§5.2, §5.3); benchmark harness and report (§6); Lovable review screen, desktop prefill, retry, events (§5.4, §5.5); unit and integration tests; config flag `BYOQ_EXTRACTION_ENABLED`.

**Exit:** independent QA Pass on Development against §7.3; benchmark report meets §6.3. Gate B authorises the build; Gate C authorises Production.

### Slice 2 — Production pilot

Deploy with the flag on. Testers: Micah, Orly, David. Real phones, real homework, at least two subjects. Two weeks or 30 confirmed items, whichever first. Monitor events, OpenAI spend, failures, deletion behaviour.

**Exit:** pilot report; David decides expand / hold / roll back (flag off). Gate D.

### 7.3 QA plan (independent context, Standard for the repo)

1. **Contract:** output schema rejects any extra field; `validateItemFields` and the choices CHECK reject planted `is_correct`/`answer`/`rationale`; `detectAnswerLeaks` still gates `ready`; topic resolution rejects codes outside the unit; idempotency returns the stored proposal without a model call.
2. **Capability scoping:** the three review ops work only with the pairing's bound item; a handle for item A cannot read or write item B; expired, consumed, cancelled, and malformed handles are refused; the 15-minute extension happens once; no owner key ever appears in a phone-leg response.
3. **Fallback:** model not configured, timeout, non-JSON output, cost reservation refused → `unavailable`/`failed`, the photo is kept, the typed form works, no partial item fields.
4. **Edit safety:** a student's edit is never overwritten by a re-run or a second page; prefilled fields only fill nulls.
5. **Answer marks:** planted handwritten answers and circled options land in `captured_work`, not stem; a planted answer key is dropped and the warning shows; `captured_work` is never returned by any non-BYOQ path (grep-level check plus a test).
6. **Regression:** typed intake, QR capture, multi-page, retake, delete, 30-day purge, HEIC rejection, no graded-practice import in BYOQ files, anonymous and signed-in parity.
7. **UX/accessibility:** review screen at 390 px, keyboard and screen-reader operation of every field and the confirm action, live announcement of "Reading your question…" and completion, warnings associated with their fields.
8. **Live:** real phone, QR and "use this device", anonymous then sign-in claim, extraction off (flag) returns the shipped flow.

QA proposes Pass/Fail; it does not authorise Production.

---

## 8. Privacy, rights, cost

### 8.1 Privacy policy

The live policy covers extraction and processing providers. It does not say an AI model reads the photo. Proposed sentence for §2.3 ("User-Provided Content"), for David to place in the Lovable copy (and to sync `docs/legal/PRIVACY_POLICY.md`, which is a stale copy):

> When you photograph or upload a question, we use an automated model from a third-party AI provider to read the image and suggest the question's text and type for you to check. The image is sent only for that purpose and the provider does not keep it or use it to train its models.

The second clause must be true of the configured provider account and should be confirmed against OpenAI's API data-usage terms for the account in use before the pilot (the call already sets `store: false`). Timing: before the Production pilot (Slice 2), since Micah and Orly are real students.

The intake consent notice keeps its link and adds nothing else.

### 8.2 Rights

Unchanged from `DECISION-0084`: private study use only, no promotion path without a separate review. A photographed question may be a publisher's; nothing here copies it anywhere except the student's own private item, which is what the shipped feature already does with the photo.

### 8.3 Cost

David: no product cap on extraction. Recorded. Two things remain true regardless:

- Anonymous BYOQ needs no sign-in, so a drive-by script could run extraction repeatedly. The shipped per-owner, per-IP, and global owner-creation limits bound this to the existing quotas (30 items per owner per day, 120 anonymous owners per IP per hour, 5,000 per hour globally); extraction adds at most one model call per `finish_capture` or `extract_question`, and `extract_question` is rate-limited with the existing pairing-mint window (12 per 10 minutes per owner).
- The capture-quality pattern's daily USD breaker costs nothing to keep. **Recommendation:** set `BYOQ_EXTRACT_DAILY_CAP_USD` high enough never to trip under real use (for example 100) and page David if it does; when it trips, extraction returns `unavailable` and the typed flow continues. David may set it to unlimited; the code path should exist either way.

---

## 9. Governance

- `TASK-0039` Phases 1–2: **Done** (shipped 2026-09-28 under `APPROVAL-0058`; real-phone QR test on Production was the one listed follow-up and is absorbed into Slice 2). Phase 3: **superseded by this plan**; not carried forward.
- `BYOQ_WORKSHEET_PARSING_DESIGN.md`: superseded for vendor and schema decisions; its §6 answer-key analysis remains the reference if worksheets return (§10).
- `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (2026-06): only Stage 2 (Original vs Captured, completeness checklist), §5.1 (PII warning), §5.2 (extraction failure), and §12 (accessibility) are still live. Its help modes, "Check my work", rubric calibration, and Open Hand routing are retired by `DECISION-0057`/`0084`.
- `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` D9: amend to "photo capture with model-assisted extraction and student confirmation; worksheet upload not planned".
- New task `TASK-0068` carries branch, PR, acceptance criteria (§6.3, §7.3), and the pilot report.

### Approval gates

| Gate | Evidence | Authorises |
| --- | --- | --- |
| A — Plan | This revision accepted; §6.3 gates fixed; records in Slice 0 merged | Slice 1 design and benchmark work, no app or schema change |
| B — Development build | Task open; migration reviewed; capability design (§5.3) reviewed | Development migration, function deploy, Lovable preview work |
| C — Production pilot | QA Pass; benchmark report; privacy sentence live; rollback rehearsed (flag off) | Production migration and deploy with the flag on for the pilot |
| D — Expand | Pilot report; David's call | General availability or hold |

---

## 10. Deferred, with the evidence that would bring each back

| Item | Bring back when |
| --- | --- |
| Worksheets / multi-question splitting, staging tables, candidate review | Pilot students repeatedly photograph whole worksheets and the "one question per photo" instruction is being ignored |
| PDFs | Students ask for it or arrive with files rather than paper |
| Vendor comparison | Benchmark or pilot shows the OpenAI model failing §6.3 on a cohort that matters |
| Math rendering (KaTeX) | Pilot shows students editing notation into unreadable text, or Calculus/Physics zero-edit rates lag the others by a wide margin |
| Per-field confidence highlighting | Pilot shows a stable pattern of which fields get edited |
| Async job queue | Multi-page latency exceeds the function budget in practice |
| Subject/unit inference | Anonymous visitors from the generic homepage abandon at the subject select |

---

## 11. Remaining questions for David on this revision

1. **"Subject/unit from context" for anonymous visitors:** the intake screen keeps its subject and unit selects, prefilled from a `?subject=` parameter when arriving from a subject page. Agreed? (Signed-in students get the active subject and saved unit position automatically.)
2. **Phone review via capability-scoped ops (§5.3):** this is the one new security surface. Alternative with less surface: the phone shows "Photos received — finish on your computer" and review happens only on the desktop, prefilled. Which do you want for v1?
3. **Spend breaker (§8.3):** keep a high technical ceiling with a page to you, or none at all?
4. **Privacy sentence (§8.1):** place as drafted, or edit?
5. **`captured_work` (§4.5):** stored but not displayed in v1, since the photo is already on the practice screen. Agreed?
