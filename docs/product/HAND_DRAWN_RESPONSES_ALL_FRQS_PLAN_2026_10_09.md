# Hand-Drawn Responses on Every FRQ — Plan

**Status:** Draft for Product Owner review. **D1, D2 (with condition), D4 approved 2026-10-09** (`DECISION-0109`/`0110`/`0111`, `APPROVAL-0142`); D3, D5–D8 open; no build or deployment approved; no code changed.
**Owner / Product Owner:** David Bloom. **Author:** Claude (Fable 5.1), session of 2026-10-09.
**Tier:** Hard-Gate (production frontend and functions, student photos, grading truth, privacy).
**Extends:** `TASK-0016` Phase D (Engine 4), `TASK-0025` (attachment schema), `TASK-0038` (human-graded pilot), `DECISION-0051` (QR capture), `DECISION-0059` (pilot grading commitment). Reuses `TASK-0068` (BYOQ photo extraction) as code and as a product pattern.
**Branch:** `claude/hand-drawn-deployment-2026-10-09` (plan and records). **Build:** `TASK-0069`, branch `claude/hand-drawn-frq-build-2026-10-09`, record `docs/handoffs/TASK0069_FRQ_PHOTO_EXECUTION_2026_10_09.md`.

## 0. Goal

Any student, on any FRQ Cramapple serves today or publishes later, can answer on paper, photograph the page, and get the same rubric-level result a typed answer gets. The photo is preserved, the student confirms what we read from it, and grading never depends on an unverified machine read of the image.

Principle that makes this feasible now: **the student is the decider; the model is a first draft; the grader works on text it can verify.** That is BYOQ's proven shape (`TASK-0068`), applied to responses instead of questions. It turns the Engine 4 problem (vision reads cannot be trusted as the grader, `project_engine4_far_investigation_2026_08_18`) into a transcript-confirmation step the existing text grader already handles.

## 1. Where we are (verified against Production and the live Lovable App, 2026-10-09)

| Layer | State |
| --- | --- |
| Content | 1,090 published FRQs, all with `frq_criteria`. 40 carry `prompt_json.hand_drawn=true` + `expected_graph_spec` and route to `shadow_review` (rubric_type `spatial`). One (`APBIO-HDG-2026-GRAPH-002`) is `human_graded_pilot_approved`; the other 39 are `ai_provisional_unapproved` and excluded from serving by `20260923150000`. |
| Capture (backend) | `capture-pairing` edge function + `app.capture_pairing_tokens`: QR pairing, phone upload, 20 MB cap, byte-level type/dimension validation (`_shared/capture-attachment.ts`), EXIF strip (`_shared/image-metadata.ts`), capture-quality check (`_shared/capture-quality-check.ts`, `gpt-4o-mini`, metered), bind into `app.response_attachments` (immutable, retake lineage, one current original per response version). Live in Production since 2026-08-20. |
| Capture (frontend) | Live Lovable App has `CaptureItem`, `/capture-phone`, `prepareCaptureSlot`/`submitCapturedResponse`, only on the legacy `/session` surface (`SessionFrame`). The live Practice FRQ screen (`/practice-frq` → `LivePracticeFrq` → `PracticeFrqScreen`) has **no photo affordance**. |
| Grading | `evaluate-attempt` grades text only. `spatial` and `human_shadow` route to `shadow_review` (a hold). `record_manual_grade`, `list_manual_grading_queue`, `get_manual_grading_context` exist for human grading. Engine 4 automated grading fails DR-1 (FAR 10.9% at 40% coverage vs ≤2%). |
| Pilot | TASK-0038 Phases 1–4 done backend-side. The Phase 3/4 frontend (`/session-hand-drawn-pilot`, grading queue, RLS-safe per-attempt page, consent notice) was committed to `exam-buddy-wireframe` on 2026-09-23 and **never ported to the Lovable App**. Stage 1 of `DECISION-0059` has not run. |
| Usage | `response_attachments` 0 rows, manual grades 0, attempts on the pilot item 0. |
| Policy | Privacy policy already covers images, extracted content, AI-provider processing, and retention for service/audit purposes. Consent copy near the upload (David, 2026-09-23) is decided but not live. |
| Marketing | `cramapple.com` already claims "Paper work still earns points" (`HandDrawnExplainer`). Today no student can exercise that claim. |

## 2. Target student workflow

On every FRQ, in the Practice FRQ screen (the live student path), under the answer boxes:

1. **Choose how to answer.** Type, photograph, or both. One control: "Add a photo of your work". Items whose rubric needs a constructed visual show it as required ("This question needs a drawn graph. Photograph your page.") and hide nothing else.
2. **Capture.**
   - Desktop/laptop: QR to phone (`CaptureItem` + `/capture-phone`), unchanged from Stage D2. Typed-URL fallback stays.
   - Phone/tablet as the primary device: same-device camera (`<input capture>`), the BYOQ "I'm on my phone" path. *Decision D1 below: this is a narrow amendment to `DECISION-0051`, which rejected laptop-camera upload, not phone-as-primary.*
   - Multiple pages: up to N photos per response (BYOQ allows pages; default N=3). Each is its own attachment under one response version.
3. **Quality gate.** Existing check runs on upload: generic retake copy for a poor photo, blameless copy for a checker fault, continue allowed on "indeterminate". No change.
4. **"Is this your answer?"** We read the page and show a per-part transcript beside the photo: written text, numbers, equations in plain Unicode, and for graph items the plotted points, axis labels, and scale we can read. Every field is editable; unreadable spans are marked `[unreadable]`; a drawn element we cannot transcribe is `[see photo]`. The student confirms. This is the BYOQ review loop (`ByoqReview`, `proposalPatch`, re-read-then-fill semantics) with a response schema instead of a question schema.
   **Condition (David, 2026-10-09, `DECISION-0110`):** the screen does not only ask "is this right?"; it asks the student to **confirm or add anything missing so Cramapple can help**. Concretely: each `[unreadable]` span is an inline prompt ("We couldn't read this — type what you wrote"); a part with no transcribed answer says so ("We didn't find an answer for part (b) in your photo. Add it here, or leave it blank"); and the screen closes with "Anything we missed? Add it so we can score your whole answer and show you what to fix." Text the student adds is stored as `student_added` alongside the model's read, so audits can tell what was photographed from what was typed at review.
5. **Submit.** The confirmed transcript becomes the response text; the photo stays bound. Grading runs immediately (section 5). If any criterion must be judged from the image itself, the student sees the graded text criteria now and "a reviewer will check your drawn work" for the rest, with the usual result card updating when it lands.
6. **Afterwards.** The student can open their photo from the feedback card and dispute a criterion (existing `grade_disputes`). Retake before submit is unlimited; after submit, one response per attempt as today.

Consent copy (David 2026-09-23) appears once per capture control: "By submitting a photo, you agree to our Terms and Privacy Policy. Don't include names or other personal information in the photo."

## 3. Content model: every FRQ declares a response policy

Replace the item-level special case (`hand_drawn` flag + `label_status` gate + separate selector) with one additive field every FRQ carries:

```
prompt_json.response_policy: "typed_only" | "photo_allowed" | "photo_required"
```

- **Default for all existing FRQs:** `photo_allowed`. Set by one backfill migration, so all 1,050 non-spatial FRQs accept a photo on day one with no per-item work.
- **The 40 construct-a-graph items:** `photo_required`. Derived from `hand_drawn=true`; the stem text ("construct", "sketch", "draw", "plot") plus `expected_graph_spec` presence is the rule, checked by the backfill rather than assumed.
- **`typed_only`:** reserved for items where a photo makes no sense (none identified yet). Exists so the pipeline has an explicit opt-out rather than an absent value.
- **Future FRQs:** the generation pipeline (`TASK-0065` generate-select, `scripts/content-seed/task0065_load/build_load_sql.py`) writes `response_policy` on every new item. The checker pass adds one deterministic rule: a stem that asks the student to construct a visual must carry `photo_required` and an `expected_graph_spec`; a `photo_required` item without a spec fails lint. The publish gate (`20260805140000_require_practice_format_at_publish.sql` pattern) refuses an FRQ with no `response_policy`.
- **Serving:** `_shared/student-item-delivery.ts` `RenderItem` gains `response_policy` next to the existing `response_mode`; `select_practice_frqs` stops excluding `hand_drawn` items once Phase 1's grading path is live (the exclusion was a safety fix for a UI that could not capture; it is retired, not relaxed, in the same migration that ships the capture UI). `select_hand_drawn_pilot_items` and `label_status='human_graded_pilot_approved'` are retired with TASK-0038's close.
- **`label_status`** stays what it is today, a content-review label, and is never a serving or grading gate for this feature.

## 4. Image management

**Capture paths.** QR (existing) and same-device (D1). Both land in `capture-pairing`'s `submit_capture`: validate bytes, strip metadata, quality-check, bind. Same-device reuses the same token so one code path owns every photo; the token's `access_path` records which.

**Validation and normalisation.** Existing: PNG/JPEG/WEBP signature check, dimensions, SHA-256, 20 MB cap, EXIF/GPS/thumbnail strip before storage. Add: downscale to a long edge of 2,000 px and re-encode to JPEG q85 for the stored *derived* copy used by models and graders, keeping the original bytes as the immutable record. (Vision calls on a 3–6 MB phone photo are slower and cost more for no accuracy gain; BYOQ's benchmark ran at this size.)

**Storage layout.** Bucket `learner-uploads` (private). Path `{user_id}/responses/{attempt_id}/{response_version_id}/{attachment_id}.{ext}` for originals, `.../{attachment_id}.derived.jpg` for the derived copy. `app.response_attachments` row per original with `kind='original'`; derived copies are addressed by convention from the original row, not separately bound, so the immutability trigger covers exactly one row per photo.

**Binding and lineage.** Unchanged: one current original per response version, retakes chain through `replaces_attachment_id`, bound objects cannot be updated or deleted by the owner through the storage API. Multiple pages: `submission_slot_id` already exists on the token; slot `page-1..N` gives N current originals per response version (the "at most one current original per response version" constraint becomes "per (response version, slot)").

**Access.**
- Student: signed download of their own attachments (existing `storage-sign-url`), 10-minute links, shown on the feedback card and the attempt history.
- Grader (admin): `get_manual_grading_context` + the `sign_download` admin exception (existing). Add `kind='derived'` access so the grader sees the normalised copy by default and can open the original.
- Model: the derived copy only, sent inline, `store: false`, never a URL the provider could refetch.
- No public URL ever. Column grants keep `storage_path` out of PostgREST for non-owners (BYOQ precedent).

**Retention and deletion.** Today the immutability trigger blocks all deletion, including service role, and the privacy policy promises deletion requests "subject to operational constraints". Resolve with a **redaction** mechanism, not deletion: `response_attachments.redacted_at` + a service-role function that deletes the object bytes (original and derived) and nulls nothing else. The row, digest, dimensions, and grading record survive for audit; the image does not. Triggers: account deletion, a support-handled erasure request, or an age-based sweep (D4: proposed 24 months after the attempt, matching "history and progress" retention). Unbound uploads keep the existing bucket sweep. No image is ever used for a training or benchmark corpus without the separate, deidentified, reviewed path the privacy policy describes; the research corpora stay the creator-consented sets already on record.

**Cost per photo (estimate, from BYOQ and Stage D2 numbers).** Quality check ≤ $0.01 reserved. Transcript ≈ 3.7k input tokens on `gpt-4.1-mini`, under $0.01, median 2.4 s single page. Storage ≈ 3–5 MB per photo (original as uploaded plus the derived copy). At 1,000 photo responses a day: under $20/day in model spend and 3–5 GB/day of storage growth, which is the number D4's retention rule has to bound. All model calls reserve through `app.reserve_model_usage` against `OPENAI_DAILY_CAP_USD`, with a per-student daily photo cap (D5) and a feature breaker `FRQ_PHOTO_DAILY_CAP_USD`.

## 5. Grading

Grading is decided by **what the criteria need**, not by how the student answered. Each `frq_criteria` row is one of two kinds, derived once at backfill and carried on new items by the pipeline:

- **text-judgeable** (the overwhelming majority, including all criteria on the 1,050 non-spatial FRQs): the rubric can be applied to words, numbers, and equations.
- **image-judgeable** (a subset of the 40 spatial items' criteria, e.g. curve shape, placement relative to a stimulus, shading): the rubric needs the picture.

| Student response | Text-judgeable criteria | Image-judgeable criteria |
| --- | --- | --- |
| Typed only | `evaluate-attempt` as today | Not reachable (item is `photo_required`) |
| Photo, confirmed transcript | `evaluate-attempt` on the transcript, same prompt, same route (`llm_discrete_text`); `grading_results.input_modality='photo_transcript'` | Phase 1: human queue. Phase 2: Engine 4 auto-grade per (archetype, criterion) cell that has passed its gate, with self-consistency (2-of-3) for "earned", abstain → human queue |
| Mixed (some parts typed, some photographed) | Per part; parts are flattened with the existing `(a) … (b) …` convention | As above |

Why this is sound:

1. **The grader never sees an unverified read.** The transcript the student confirmed is the response of record, stored in `response_versions.response_text` with `response_parts.source='photo_transcript'`, the model's raw proposal kept alongside for audit, and `normalized_response_sha256` computed on the confirmed text as it is for typed answers.
2. **Spatial values become deterministic checks.** For `PLOT_VALUES`, axis labels, and scale, the confirmed transcript is compared to `expected_graph_spec` by code, not a model — the same move the Statistics deterministic fallback already makes in `evaluate-attempt`. The Engine 4 investigation found these are exactly the criteria where the model over-credits.
3. **Remaining image-judgeable criteria stay honest.** They go to the human queue (`DECISION-0059` machinery, now with a real reason to exist) until Engine 4's gates pass per cell. "Partially graded, reviewer checking the rest" is a real state (`attempts.status='partially_graded'`, new) the UI shows, replacing today's all-or-nothing `human_review_pending`.
4. **Student-confirmed does not mean student-trusted.** The transcript is what the student *claims* the page says, and `student_added` spans are text the student typed at review rather than photographed. A confirm step that lets a student type an answer they never wrote is a practice-integrity question, not a scoring one — the photo is preserved, and a spot-check comparing transcript to image on a sample (the benchmark scorer, section 7) measures drift. Practice scores are not high-stakes.

**Human queue.** Unchanged ops, two additions: the grader sees the confirmed transcript beside the photo and only decides the image-judgeable criteria (text ones are pre-filled from the automated pass, editable), and `record_manual_grade` learns to write a partial result that merges with the automated one. Repair authoring: `highest_value_gap` is produced by the automated pass for the text criteria, so a photographed answer gets the same repair prompt a typed one does — the TASK-0038 "score but no repair" gap closes for free.

**Engine 4 (Phase 2).** No new grading approach. The D3 reader-certification and locked-holdout gates stand. What changes is the input: the reader grades a confirmed transcript plus the image, and the synthetic benchmark (section 7) supplies labelled graphs at volume so the per-cell FAR/FRR numbers are measured before any cell is promoted. Promotion is per (archetype, criterion), recorded, reversible by flag.

## 6. Storage and schema changes (all additive; Dev first, Prod after QA)

| Object | Change |
| --- | --- |
| `content_item_versions.prompt_json` | `response_policy` (section 3); backfill migration; publish-gate check. |
| `app.frq_criteria` | `judgement_kind text default 'text'` (`text` / `image`); backfill the 40 spatial items by criterion key (`PLOT_VALUES`, `X_SCALE`, `Y_SCALE`, labels → `text`; shape/placement/shading → `image`). |
| `app.response_versions.response_parts` | Convention, no DDL: `{ "<part>": text, "_source": "typed"|"photo_transcript"|"mixed", "_proposal": {...}, "_student_added": { "<part>": [spans] }, "_confirmed_at": ts }`. |
| `app.response_attachments` | `slot_id text`, `redacted_at timestamptz`, `transcript_status text` (`none`/`proposed`/`confirmed`); uniqueness becomes per (response version, slot). Immutability trigger allows only the redaction function to touch `redacted_at`. |
| `app.capture_pairing_tokens` | No change; `upload_purpose='DRAWN_RESPONSE'` still correct. `access_path` gains `same_device`. |
| `app.attempts.status` | Add `partially_graded`. |
| `app.grading_results` | `input_modality text`, `graded_criteria_scope text[]` (which criteria this row decided), so an automated row and a manual row for one attempt compose. |
| New function module | `_shared/drawn-response-extraction.ts`: `runByoqExtraction`'s call shape with a response schema (per-part text, numbers, plotted points, labels, `[unreadable]`/`[see photo]`), student's marks as the primary field, printed answer key as a warning not a drop rule. Prompt version in the idempotency key. |
| `attempt-response` | `propose_transcript` (owner or phone capability), `confirm_transcript` (owner), both idempotent, both reserving spend; `submit_response` requires a confirmed transcript when a current attachment exists. |
| `capture-pairing` | Same-device path; derived-copy generation; N-page slots. |
| `evaluate-attempt` | Reads `judgement_kind`; grades text criteria; emits `partially_graded` when image criteria remain; deterministic spatial checks from the transcript. |
| Retention | pg_cron sweep calling the redaction function on the age rule (D4). |
| Column grants | `_proposal`, storage paths, and `raw_model_response` hidden from PostGREST as BYOQ does. |

## 7. Phases, gates, and what each needs

**Phase 0 — Make the existing pilot reachable (prerequisite, days).** Port the five TASK-0038 frontend pieces from `exam-buddy-wireframe` (`e16c72d`, `d50a403`, `677728c`) into the Lovable App by hand; publish; David runs `DECISION-0059` Stage 1 end to end. Proves capture → storage → human grade → student result with real accounts before anything is generalised. *Gate:* one real graded photo in Production. *Approval:* Lovable publish (production).

**Phase 1 — Photo on every FRQ, transcript-graded (the launch slice, ~3–4 weeks).**
Build order: schema and backfill → extraction module + benchmark → `attempt-response` ops → `evaluate-attempt` partial grading → Practice FRQ screen (capture control, review step, result states) → grader UI update → consent copy → PostHog events. Ship behind `FRQ_PHOTO_RESPONSES_ENABLED` with a subject allow-list (start: AP Biology and AP Statistics, the subjects with hand-drawn content and the pilot grader). Independent backend QA and browser QA (Sol's script pattern) before Production.
*Gates:* benchmark transcript fidelity ≥ 95% on rendered pages and ≥ 85% on the real-photo cohort for text/number fields; zero answer-bearing fields in the schema (test); planted-control abstention 100%; human queue SLA met during a two-week internal run.
*Records:* new Hard-Gate task; decisions D1–D6; approval for the Production publish.

**Phase 2 — Automate the image-judgeable criteria where the gates pass (open-ended).** Engine 4 D3/D4/D5 as written, with the transcript as input and the synthetic benchmark for volume. Promote cells individually; human queue remains the default for unpromoted cells and for abstentions. *Gate per cell:* FAR ≤ 2% on a locked holdout, reader-certified.

**Phase 3 — Future FRQs inherit by default (ships with Phase 1's pipeline change, enforced from the next content batch).** `response_policy` and `judgement_kind` written by the generator, checked by the checker families, refused by the publish gate when missing. One doc change to `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` / the generate-select protocol.

**Phase 4 — Operations at scale.** Redaction sweep live, erasure runbook, grader roster beyond David (`DECISION-0059` revisit), parent-view rules for photos (none shown to parents until decided), storage cost review at 10k photos.

## 8. Decisions needed from David

- **D1 — Same-device capture on phones.** **Approved 2026-10-09 (`DECISION-0109`).** `DECISION-0051` amended narrowly: QR remains the path from a desktop; a student already on a phone uses that phone's camera.
- **D2 — Transcript confirmation is mandatory before grading a photo.** **Approved with a condition 2026-10-09 (`DECISION-0110`):** the confirmation screen must prompt the student to confirm *or add missing content* so Cramapple can help (section 2, step 4).
- **D3 — Default `photo_allowed` on all 1,050 non-spatial FRQs at launch**, versus allow-listing subjects first. Recommendation: flag-gated subject allow-list for two weeks, then all.
- **D4 — Photo retention.** **Approved 2026-10-09 (`DECISION-0111`):** keep while the account exists; redact bytes 24 months after the attempt or on account deletion or erasure request; row and digest kept for audit. A counsel read against the policy's retention section is still recommended before Phase 1 ships; it does not block the build.
- **D5 — Spend and rate limits.** Proposed: 30 photos per student per day, `FRQ_PHOTO_DAILY_CAP_USD` 50, both fail closed to "type your answer instead".
- **D6 — Partial grading as a visible state.** Students see text criteria graded now and image criteria "with a reviewer". Alternative: hold the whole result until the reviewer finishes. Recommendation: partial, with the 24-hour SLA shown.
- **D7 — Grader roster.** `DECISION-0059` names David alone. Phase 1 can run that way for two subjects; Phase 2 or a third subject needs a second qualified grader.
- **D8 — Which surface.** Build on the Practice FRQ screen (live student path) and leave `/session`'s `CaptureItem` as the component source. The one-pager's D14 "standardise on `/session`" is unexecuted; this plan does not depend on it either way, but the capture UI should be built once, as a shared component used by whichever survives.

## 9. Risks

| Risk | Mitigation |
| --- | --- |
| Transcript errors on handwriting (math notation, superscripts, Greek letters) | Plain-Unicode rules from BYOQ; `[unreadable]` marker; student edits; benchmark cohort of real handwriting from the existing 372-photo corpus. |
| A student "confirms" text that is not on the page | Photo preserved; sampled transcript-vs-image audit; practice is low-stakes; report in metrics, do not block. |
| Model cost spikes | Reservation ledger, per-student cap, feature breaker, flag rollback with the typed flow intact (BYOQ pattern). |
| Minors' handwriting as personal data | No faces expected; PII reminder in copy; EXIF stripped; private bucket; redaction path; no training use without the deidentified review path. |
| Human queue backlog | Partial grading keeps text criteria instant; queue only holds image criteria; SLA visible; roster decision D7. |
| Engine 4 never clears DR-1 for some cells | Those cells stay human-graded indefinitely; the product does not depend on them. |
| Lovable publish ships other sessions' preview edits | Review the diff at publish time (noted in the TASK-0068 close); publish from a known commit. |

## 10. Metrics and QA

PostHog (privacy-safe, no content): `frq_photo_offered`, `frq_photo_started` (device class, path), `frq_photo_bound` (quality state), `frq_transcript_proposed` (fields filled, unreadable count), `frq_transcript_confirmed` (fields edited — the real fidelity number, as `byoq_review_confirmed.topic_changed` is for BYOQ), `frq_photo_graded` (modality, partial or full), `frq_photo_reviewer_resolved` (hours to resolve). Targets for the two-week run: ≥ 30% of FRQ attempts in the allow-listed subjects use a photo; transcript edit rate < 20% of fields; reviewer SLA met ≥ 95%.

QA: Deno tests for the extraction schema (no answer field, abstention, markers), `attempt-response` op tests (owner/capability/admin refusals, idempotent re-propose), `evaluate-attempt` partial-grading tests, SQL regression for the serving change (hand-drawn items served only with `response_policy`), browser script with seeded captures via the canvas-file technique from `scripts/byoq_preview_seed.ts`, and a real-phone run on `app.cramapple.com` before each Production publish.

## 11. Out of scope

BYOQ items (separate tables by `DECISION-0068`; the BYOQ practice screen may later adopt the same capture component, as a separate task). Worksheet/document upload. Parent access to photos. Automated grading of image-judgeable criteria beyond the Engine 4 gate process. Changing the privacy policy text (counsel review of D4 may require a sentence on image retention; that is a policy task, not this plan).

## 12. Records to create when approved

One Hard-Gate task ("Hand-drawn responses on every FRQ") with Phases 0–4 as checkpoints; `DECISION` entries for D1–D8 as David answers them; `APPROVAL` entries for the Phase 0 publish, the Phase 1 Development deployment, and the Phase 1 Production publish; a `docs/INDEX.md` row under a new "Hand-drawn responses" topic pointing here, since the index currently has no entry for this area.
