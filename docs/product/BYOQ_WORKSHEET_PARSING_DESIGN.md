# BYOQ Worksheet Parsing Design

**Status:** Proposed for Product Owner, Learning Quality, security, privacy,
and rights review
**Related Task:** `TASK-0039` Phase 3 (this document is that phase's required
design pass — Phase 3 does not start until this is approved)
**Related Decisions:** `DECISION-0057` (a BYOQ item never exposes a canonical
answer, in any mode)
**Owner:** Product Owner with Learning Quality Owner
**Last Updated:** 2026-09-26 (revised same day after adversarial review — see
"Revision note" below)

## Revision note (2026-09-26)

A first draft of this document was adversarially reviewed the same day it was
written. The review found the draft's own stated top risk — an embedded
answer key leaking into a question's text — was not actually closed by the
draft's three-layer mitigation, and that the mitigation was scoped to
worksheets when the same risk applies to Phase 1's typed intake too. This
revision: rewrites §6 around masking-by-default and a hard re-check gate
instead of a one-time prompt; extends the risk explicitly to Phase 1 (§6.4);
drops two UI actions (`Merge with next`, `Split this candidate`) that added
real implementation cost without addressing the stated top risk, in favor of
editing directly in the existing Confirm Capture stage; and fixes two
citations that were doing more work than they could support (§2, §8). Where
the original draft is unchanged, it's because the review found it sound.

## 1. Purpose

`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` designs BYOQ intake for exactly
one question per submission. This document extends that design for the case
where a student uploads one document — a worksheet, problem set, or study
guide — that contains **several** questions, and the product needs to split
it into individually usable BYOQ items.

It does not finalize a parsing vendor, does not authorize production uploads
or model calls, and does not change anything already decided in
`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` or `DECISION-0057` — it only
adds what's new about *several* questions arriving in one upload instead of
one.

## 2. Why this needs its own document

Confirmed this session, and the reason `TASK-0039` blocks Phase 3 on this
document rather than letting it inherit the single-question design directly:

- **No splitting precedent exists anywhere in this codebase.** The closest
  thing — `prompts/APBIO_FRQ_CANONICAL_SPAN_SEGMENTATION_2026_09_22.md` and
  the Statistics equivalent — segments an *already-known* FRQ's own answer
  text into rubric-criterion spans. That is a different problem: it starts
  from one question CramApple already wrote and already has a rubric for.
  This document is about turning an unstructured, unreviewed *source*
  document into several new, separate, unreviewed BYOQ items. The staging
  model in §5 (hold parser output as a draft until a human confirms it) is
  new to this repo, not an extension of an existing convention — it should
  be evaluated on its own terms, not assumed safe by analogy to something
  else.
- **No OCR/document-parsing vendor has been tested for this task.** Every
  vendor evaluation on record (TrOCR, HandwritingOCR.com, LlamaParse) was
  scoped to *grading* an already-known hand-drawn response, not to detecting
  question boundaries in an unknown document. None of that evaluation
  transfers directly, and per the grading-engine handoff notes, LlamaParse's
  chart parsing is itself VLM-based — the two "candidate directions" named in
  §10 are not as categorically different as they may first appear.
- **Copyright/rights exposure is categorically larger than a single typed
  question.** A student pasting one question in their own words is a
  different rights posture than uploading a photograph of an entire teacher-
  or publisher-authored worksheet, verbatim, with layout, numbering, and
  (frequently) an embedded answer key intact. This repo already has a
  reusable framework for a related distinction —
  `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`
  names "answer-key material" as the single most rights-sensitive category of
  external content, for the case of CramApple's own authoring pipeline mining
  external material. That protocol's mechanics don't transfer directly here
  (it assumes a known source and rights holder; BYOQ never has that) — see
  §8 for what does transfer: the underlying judgment that answer-key material
  deserves the strictest handling of anything in a source document.
- **An embedded answer key is not just a rights problem here — it's a live
  DECISION-0057 leak risk**, because a parser can attribute answer text to a
  question's `stem` as ordinary free text, a channel the schema's "no
  `is_correct` column" protection does not cover (see §6).

## 3. Experience principles (in addition to §2 of the single-question design)

1. **A worksheet is a batch of independent confirmations, never a bulk
   import.** Every question that becomes a real `byoq_items` row does so
   through the same per-question Confirm Capture / Confirm Match stages
   `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` already defines — a worksheet
   upload changes how a candidate's *stem gets proposed*, not how it gets
   *accepted*. No candidate ever becomes a `byoq_items` row without a
   student looking at that specific candidate and confirming it.
2. **A mis-split is corrected by editing, not by a dedicated splitting UI.**
   The parser will sometimes merge two questions into one candidate or split
   one into two. For a first version, the student fixes this the same way
   they'd fix any wrong extraction — by editing the proposed text directly in
   Confirm Capture (an existing capability) — rather than the product
   building a bespoke merge/boundary-editing tool whose feasibility depends
   entirely on which parsing vendor is chosen (see §4.3).
3. **An embedded answer key is masked by default, not merely warned about.**
   If any part of a candidate's proposed text pattern-matches as likely
   answer content, the default view a student sees never shows that text in
   the clear — masking happens before the first time a student could read
   it, not as a prompt after.
4. **Bound the batch.** An unbounded worksheet is an unbounded storage,
   parsing-cost, and review-burden surface. Cap candidates per upload (§7).
5. **The upload itself is the same private, non-published, non-canonical
   material `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §10 already
   describes** — nothing here changes who can see it or whether it can ever
   be published; if anything, a worksheet-sourced item needs a *stricter*
   bar before promotion (§8), since the source is less likely to be the
   student's own original words.

## 4. Proposed flow

Extends `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`'s Stage 1 ("Document")
input method with three new stages between upload and per-question intake.
Existing single-question stages (Confirm Capture, Confirm Match, Choose
Help, Review and Begin) are reused unchanged, once per confirmed candidate.

```text
1. Upload worksheet          (extends existing Stage 1 "Document" method)
2. Splitting pass            (server-side; produces candidate boundaries)
3. Candidate review list     (new)
4. Per-candidate confirmation (existing single-question Stages 2-5, looped)
5. Batch summary             (new)
```

### 4.1 Upload worksheet

Same guidance and constraints as the existing Document input method
(`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §4.3): supported-format and
size guidance, no silent upload in a prototype, production upload gated on
the same security/privacy/rights decisions. Additional worksheet-specific
consent copy (see §9):

> This looks like it may contain more than one question. Only upload
> material you have the right to use for your own study — not a live test or
> quiz you're currently taking, and not something you don't have permission
> to copy.

**Zero-output and garbage-output handling:** if the splitting pass produces
no candidates, or produces candidates whose text is unreadable, this maps
onto the existing single-question `extraction_failed` state
(`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §5.2) — preserve the original
upload, offer retake/replace/switch-to-typing, never fabricate a candidate to
fill the gap.

**Dedupe:** a re-upload of the same physical document (a retake after a
blurry first attempt, or an accidental duplicate) should not silently
produce a second full batch of candidates. Storage uploads already compute a
content digest (`_shared/capture-attachment.ts`'s pattern) — reuse that: a
new upload whose digest matches an existing, still-`pending` batch for the
same user resumes that batch instead of creating a new one. A digest match
against an already-fully-resolved batch surfaces a "you've already reviewed
this" notice with a link to the resulting items, rather than re-parsing.

### 4.2 Splitting pass (server-side, no client trust)

Input: the uploaded document/photo set. Output: an ordered list of candidate
regions, each carrying:

- a stable `candidate_id` (ordinal within the batch, not yet a `byoq_items`
  row)
- the region's source reference (page/bounding-box or character range,
  whichever the chosen parsing approach produces) — kept for the student's
  own reference and for any future dispute, mirroring why
  `response_attachments` keeps the original image rather than only derived
  text
- a proposed `item_type` guess (`mcq`/`frq`) and proposed `stem`/`choices`
  text
- a `flagged_span` list (see §6) — zero or more `(field, start, end)`
  references into the proposed text that the answer-key heuristic matched,
  not a single boolean
- a `confidence` band, reusing the existing high/moderate/low convention
  from `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §6

**Nothing here writes a `byoq_items` row.** These candidates live in a
short-lived, owner-scoped staging table (see §5) until a student confirms
one individually.

The heuristic that produces `flagged_span` must be **re-run on the current
text at every point the text can change** — after the student edits a
candidate's proposed stem/choices in Confirm Capture, before that candidate
can be confirmed — not only once, at parse time (see §6).

### 4.3 Candidate review list (new)

A single screen listing every proposed candidate as a short card: candidate
number, a one-line preview of the proposed stem, the proposed item type, and
the confidence band. **If any `flagged_span` exists for a candidate, its
preview shows the masked text (e.g. `█████`) in place of the flagged
span, never the underlying text** — masking is the default rendering, not an
opt-in. Per-candidate actions:

- `Review and confirm` → enters 4.4 for this candidate
- `Not a question` → discard (a header, instructions, page number, answer-key
  page, or duplicate). A flagged candidate can still be discarded without
  ever unmasking it — discarding never requires revealing the flagged text.

There is no `Merge with next` or `Split this candidate` action in this
version (Principle 2) — a student who sees a wrongly-merged or wrongly-split
candidate opens `Review and confirm` and edits the proposed text directly,
same as correcting any other extraction error. No bulk "confirm all" action
exists — every candidate that becomes a real item passes through 4.4
individually, per Principle 1.

**Over-cap handling:** if the splitting pass proposes more candidates than
the batch cap (§7) allows, this is treated as a signal the parser over-split
the document, not that the document itself has too many questions. Present
the top-N candidates by confidence for review and discard the remainder with
a clear message inviting the student to re-upload just the remaining
pages/section if genuinely needed — never a blanket rejection of the whole
upload.

### 4.4 Per-candidate confirmation (reuses the existing single-question flow)

Exactly `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`'s Stage 2 (Confirm
Capture) through Stage 5 (Review and Begin), run once per confirmed
candidate, with one addition: if this candidate has any `flagged_span`,
Confirm Capture shows the same masked rendering the review list used, plus:

> Part of this looks like it might be an answer or answer key. Remove it (or
> confirm it isn't one) before continuing — Cramapple never stores an answer
> for your own questions.

Two actions: `Remove flagged text` (deletes the masked span from the
editable text; the heuristic re-runs on the result per §4.2) or `This isn't
an answer, show it` (reveals the span for the student's own editing, then
the heuristic re-runs on whatever they leave in place). **Either way, the
candidate cannot be confirmed while any `flagged_span` still matches the
current text** — this is a hard gate enforced by re-running the same
heuristic server-side at confirm time, not merely a client-side prompt the
student can click past. Because the heuristic can still miss an unlabeled
leak (§6.2), this gate reduces the labeled/explicit case; it is not a
guarantee against every way an answer could appear in a worksheet.

Only on confirmation does this candidate become a real `byoq_items` row
(`source_kind = 'worksheet_split'`), through the same creation path Phase 1
of `TASK-0039` already defines. The batch's subject/topic classification
(Confirm Match) defaults to whatever the first confirmed candidate resolved
to, editable per candidate, so a 15-question batch doesn't force 15
independent classification passes when the whole worksheet is plainly one
unit's material — but each candidate still gets its own explicit
confirmation screen, per Principle 1.

### 4.5 Batch summary (new)

After the student has worked through every candidate they chose to review: a
summary of how many questions were found, confirmed, discarded, and left
unreviewed, with a direct link to practice each confirmed item.

**Resuming a batch:** a batch with any `pending` candidates is not a
per-question `saved_for_later` state (that's a Stage 5 concept for one
already-confirmed question) — it needs its own batch-level state, surfaced
as a "you have N questions from a worksheet still to review" entry point on
Home, distinct from the single-question resume point. An edit made to a
candidate's text before the student navigates away is preserved on the
candidate row (not lost) so returning to it resumes from the edited text,
not the original parse.

**Source document lifecycle:** once a batch reaches a terminal state (every
candidate confirmed or discarded), default to retaining the source
upload — the same posture `response_attachments` already takes toward a
student's own captured images (kept as reference, not auto-deleted) — with
the retention window itself following whatever this task's general
retention decision settles (`TASK-0039`'s "New gaps"). A batch swept for
staleness under §7 (abandoned, never resolved) removes its staging rows and
its source upload together, since nothing was ever confirmed from it.

## 5. Data model implications

A worksheet upload needs a place to hold parser output *before* any of it
becomes a real, owner-visible-forever `byoq_items` row. Proposed:
`app.byoq_intake_batches` (one row per upload: `user_id`, storage
reference(s), parse status, digest for the dedupe check in §4.1) and
`app.byoq_intake_candidates` (one row per proposed split, FK'd to the batch,
holding the proposed text/type/confidence/`flagged_span`s from §4.2, plus
`resolution`: `pending` / `confirmed` / `discarded`, and — once confirmed —
the resulting `byoq_items.id`). Both tables are owner-scoped RLS, same
posture as `byoq_items` — no anon/public grant, no role other than the
owning student and service role.

The batch table earns its place independent of any other design choice here:
it's what makes the dedupe check in §4.1 possible. A single flat
candidates-with-a-`storage_ref`-column table, without a batch parent, would
need to re-derive "which upload was this from" some other way to support
dedupe and the resume entry point in §4.5.

**A narrower, corrected claim than an earlier draft of this document made:**
a staging-table row is not inherently free of answer-visibility risk just
because it isn't a `byoq_items` row — it is directly rendered to its owner in
the review list and in Confirm Capture, and it is the row most likely to
contain unredacted parser output. What actually limits its risk is (a)
masking by default (§4.3/§4.4) and (b) that it is never reachable by any
grading or Open Hand code path, the same "no shared code path" property
`TASK-0039`'s Option A gives `byoq_items` itself.

## 6. The answer-key leak risk, specifically

This is the risk this document treats as more severe than anything in the
single-question design, because it can defeat DECISION-0057's structural
protection (`byoq_items` has no `is_correct`/`criteria` column at all)
through a channel that protection doesn't cover: **free text**, in either
`stem` or `choices`.

### 6.1 What the mitigation in §4.2-§4.4 actually does

1. A text-pattern heuristic (`Answer:`, `Key:`, an isolated lettered/numbered
   answer line adjacent to a question, a visually distinct "Answer Key"
   page/section) scans the parser's raw output for both `stem` and
   `choices`, independent of whichever parsing vendor is chosen.
2. Any match is masked by default everywhere the candidate's text is shown
   to the student, before they can read it — not after.
3. A flagged candidate cannot be confirmed while the current text still
   matches, checked server-side at confirm time, after any edit.

### 6.2 What this does not do, stated plainly rather than implied

- **It only catches labeled or clearly delimited answer text.** It does not
  catch a student's own handwritten or printed answer already on the page
  (a filled-in blank, a circled/bolded/underlined choice, a red-pen mark), a
  solutions page that repeats and then works the stem with no `Answer:`
  token, or any answer that isn't textually distinguishable from the
  question. This is the more common real-world leak channel for a
  *completed* worksheet, and this design does not close it. Flag this
  explicitly to the Product Owner as an accepted residual risk, not a solved
  one — closing it would need a different kind of detection (likely visual,
  not textual) that is out of scope for this document.
- **It is a UX aid, not an adversarial control.** Because the flag and its
  masking are visible to the student, a student motivated to evade it (the
  live-quiz-cheating scenario `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
  §8 is already trying to limit) can learn by trial which phrasings the
  heuristic catches and phrase around it. This does not argue for hiding the
  flag — the parent design's honesty principle argues against concealment —
  but this document should not claim the heuristic "reduces the odds" against
  a motivated adversary; it reduces accidental leaks from an ordinary
  worksheet's ordinary answer key, which is the case this document is
  actually designed for.

### 6.3 A discard does not require a reveal, but a preview always risks one

Because masking is the default in the review list itself (§4.3), a student
never has to unmask a flagged candidate to discard it — closing the specific
gap where seeing "Answer: B" in a one-line preview would itself be the leak,
before the student ever opened Confirm Capture. This is why §4.3 was changed
to mask by default rather than only masking inside Confirm Capture.

### 6.4 This risk is not worksheet-specific

The same free-text leak channel exists for Phase 1's typed/pasted intake — a
student can paste "Answer: B" into a typed question exactly as a worksheet
can print one. Recommend `TASK-0039` Phase 1 apply the same heuristic (§6.1
item 1) and masking-by-default (§6.1 item 2) to typed/pasted `stem`/`choices`
text, not just worksheet-derived text — this document's mitigation should be
the shared building block both paths use, not a worksheet-only feature.

## 7. Bounding the batch

- Cap candidates per worksheet upload at a fixed number (recommend 20 — the
  same order of magnitude as a typical problem set; this is a starting
  estimate, not measured data — `docs/research/orly_source_log/` is a real,
  if small and rights-limited, source of actual worksheet structure that
  could ground this number before launch, subject to that log's own rights
  caveats about what may be examined for structure versus content). Handle
  over-cap per §4.3, not by rejecting the whole upload.
- Sweep `byoq_intake_batches`/`byoq_intake_candidates` rows left in `pending`
  past a fixed age (recommend 30 days, matching this task's general
  retention posture, itself still an open Product Owner decision per
  `TASK-0039`'s "New gaps" section) — remove the staging rows and the source
  upload together (§4.5) — this is a staging table, not a permanent record,
  and unlike a confirmed `byoq_items` row it has no reason to be kept
  indefinitely.
- This is one instance of `TASK-0039`'s general, still-open "rate
  limits/quotas" gap — resolve both together, not separately. The per-batch
  classification-call cost (§4.4's default-then-edit approach bounds this to
  roughly one full classification pass plus N confirmations, not N full
  passes) should be sized alongside whatever quota Phase 1 settles on.

## 8. Promotion boundary is stricter here than for typed BYOQ items

`BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md` already requires that
promoting any BYOQ item to public SEO/AEO content be an explicit, deliberate,
reviewed step, never automatic. For a worksheet-sourced item
(`source_kind = 'worksheet_split'`), recommend going further: **bar
promotion entirely until a separate rights policy exists for this
`source_kind`**, rather than attempting to reuse
`ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`'s mechanics directly
— that protocol answers "does CramApple have rights to mine this known
teacher's known document," a question it can answer because the source and
rights holder are always known there. BYOQ never has that information: the
student is the only source, and this design does not (and should not)
attempt to establish who actually holds rights to a photographed worksheet.
What does transfer is the underlying judgment — that answer-key material is
the most rights-sensitive category of a source document — which is exactly
why §6 treats it as this document's top risk, independent of the promotion
question.

## 9. Consent and academic-integrity copy

Extends `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §8's "Where is this
question from?" prompt and §5.1's personal-information warning with
worksheet-specific copy (§4.1 above). A worksheet is more likely than a
single typed question to be an active in-class handout, and different
questions on one worksheet could plausibly be from different assignments —
recommend asking the academic-integrity question once per batch as a
default (avoiding 20 repeated prompts) but making it correctable per
candidate in Confirm Match, the same "default from the batch, override per
item" pattern §4.4 uses for subject/topic. Final consent/retention/
minor-notice language remains gated on counsel approval, same as the rest of
BYOQ.

## 10. Accessibility

Extends `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` §12 for the new
screens. Because this version has no bespoke boundary-editing or merge UI
(§4.3), the accessibility surface is smaller than a first draft of this
design would have needed: a list of cards with two per-row actions (keyboard-
operable, each with a clear accessible name), a masked-text rendering that
announces "possible answer content hidden" to a screen reader rather than
silently rendering block characters, live announcements for parse
progress/completion, and the batch-resume entry point on Home following the
same keyboard/focus/reflow requirements as every other entry point there.

## 11. Open Decisions

- **Parsing approach and vendor** (`TASK-0039` Decision needed #2). Neither
  candidate direction has been tested against a real multi-question
  worksheet as of this writing, and per §2 they may be less categorically
  different than they first appear (LlamaParse's own chart parsing is
  VLM-based). Recommend deciding via a small, concretely-scoped bake-off
  before committing engineering time to either: a stratified sample of real
  multi-question worksheets (source and size TBD — `docs/research/orly_source_log/`
  is the one real corpus this repo has, subject to its own rights caveats
  about what may be examined; a purpose-collected sample may be needed
  instead), boundary-level precision/recall against human-adjudicated ground
  truth for "how many real questions are on this page and where do they
  start/end" as the metric, and an explicit owner and cost budget before it
  starts — mirroring how the LlamaParse grading pilot was itself scoped
  (never run) rather than deferring this decision without shortening the
  path to making it.
- **Candidate cap** — is 20 the right number (§7), and should
  `orly_source_log` be checked for real structure before launch?
- **Staging-table retention window** — is 30 days the right number (§7), and
  does it match whatever retention decision `TASK-0039`'s "New gaps" section
  eventually settles for confirmed `byoq_items` rows?
- **Per-candidate vs. per-batch academic-integrity context** (§9) — is a
  batch-level default with per-candidate override sufficient, or does it need
  to be mandatory per-candidate given a worksheet could span assignments?
- **Whether Phase 1 adopts the same heuristic/masking** (§6.4) — this
  document recommends yes; formalizing it is Phase 1's decision to make, not
  this document's.
- **Whether a later version should add merge/split UI** — deferred here in
  favor of edit-in-Confirm-Capture (§4.3); revisit once real usage shows how
  often mis-splits occur and whether editing alone is sufficient.
