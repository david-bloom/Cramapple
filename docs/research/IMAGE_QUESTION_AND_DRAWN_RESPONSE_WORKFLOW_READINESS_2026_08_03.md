# Image Questions and Hand-Drawn Responses — Workflow Readiness

**Status:** Draft
**Owner:** Main Conductor / Technical Owner / Learning Quality Owner
**Related:** `TASK-0006`, `TASK-0011`, `TASK-0016` Phase D, `UX-008`
**Date:** 2026-08-03

## Outcome

Cramapple has pieces of both image workflows, but neither is an auditable
end-to-end product capability yet.

- Question images have a Production reference field and server-side signed
  reviewer delivery. The actual ten-image AP Biology source package was absent
  from `main`, and live reviewer/student click-through was never recorded.
- Hand-drawn responses have substantial corpora, label schemas, offline
  evaluation tooling, and a frontend research brief. There is no authorized
  working capture/upload implementation in this repository.

The immediate improvement is a shared artifact lifecycle: every image must be
bound to an exact item/response version, preserve immutable bytes and
provenance, carry accessibility and rights state, and fail closed until its
required reviews pass.

## Current-state evidence

### Question images

- Production history added `app.content_item_versions.stimulus_image_path` and
  exposed it through the curated view.
- `supabase/functions/review-queue/index.ts` selects the path and returns a
  short-lived server-signed URL. Its missing-image detector is a soft reviewer
  flag, not a publication gate.
- The July 2026 activity record says reviewer and student rendering were
  changed in the external Lovable application, but the live click-through
  remained open and that frontend source is not canonical in this repository.
- Ten deterministic AP Biology assets were recovered from
  `archive/pr43-stimulus-images-20260721`. Five fail a new visual-layout
  preflight; all ten lack recorded version-specific Learning Quality,
  accessibility, grading, and rights approval in their recovered package.
- The recovered PNG metadata identifies Matplotlib 3.11.1. Regeneration with
  3.9.4 produced actual pixel and bounding-box drift across the set, so the
  generator now pins and enforces 3.11.1; exact-environment reproduction is
  still pending and is not being assumed.

### Hand-drawn responses

- `scripts/drawn_response/` contains observation, criterion-decision,
  capture-quality, partition, method-run, and offline-evaluation tooling.
- Hundreds of local photographed responses and synthetic/reference renders
  exist, but older records warn that provenance, consent, duplicates, and
  corpus partitioning cannot be inferred from folder names alone.
- `TASK-0011` still lists the low-fidelity QR/camera prototype, representative
  phone testing, privacy/security/accessibility review, usability study, and
  proceed/revise/stop decision as incomplete.
- Engine 4 remains shadow-first. No low-confidence observation may become an
  authoritative learner grade.

## Shared image lifecycle

```text
item/response version
  -> image package or capture record
  -> immutable original bytes + checksum
  -> versioned derivative(s), never overwrite
  -> structural and capture-quality validation
  -> scientific/visual observation
  -> grading decision (separate record)
  -> accessibility + rights + privacy gates
  -> release/shadow eligibility
  -> signed delivery and audit telemetry
```

The two workflows share storage, identity, provenance, and access-control
principles, but they must not share approval semantics:

- a question stimulus is authored content and must be approved with its exact
  item version;
- a learner response is evidence and must remain immutable, private, and tied
  to the exact submission and rubric versions;
- capture quality says whether the photograph is usable, never whether the
  learner's graph is correct.

## Question-image authoring contract

Every question-image package must contain:

1. Stable package and asset IDs.
2. Exact `content_key` and content-version identity.
3. Image role and visual purpose.
4. Relative asset path, media type, dimensions, and SHA-256.
5. Deterministic source or governed authored-source record.
6. Rights basis and approval state.
7. Short alternative plus long-description/alternate-item strategy where
   required, with construct-equivalence and answer-leakage state.
8. Independent scientific, grading, accessibility, and visual-layout state.
9. `release_eligible`, derived mechanically from the required gates.

`scripts/validate_image_package.py` now validates the recovered package without
third-party dependencies. It verifies safe relative paths, PNG structure,
dimensions, checksums, deterministic-source existence, accessibility presence,
and release-gate consistency.

### Authoring workflow

1. Author the item and declare `visual_purpose` before creating an image.
2. Choose structured/deterministic rendering where the representation permits;
   use governed authored assets for diagrams that do not.
3. Generate into a temporary comparison directory.
4. Run structural validation and visual diff/review.
5. Review the rendered asset in the exact item context at desktop, narrow
   viewport, 200% zoom, keyboard/screen-reader alternative, and print where the
   task expects paper use.
6. Lock asset checksum and content-version relationship.
7. Publish the item version and asset atomically or keep both ineligible.
8. At delivery, fail closed when a required visual or approved equivalent is
   unavailable. Never silently collapse the task into prose.

## Hand-drawn response contract

The new `capture_image_record.schema.json` closes the provenance gap between a
folder of image files and the existing capture-quality/observation schemas. It
records:

- exact immutable image ID and SHA-256;
- original versus approved derivative role;
- direct parent-original identity;
- underlying response and item identity;
- relative/private object name rather than a public URL;
- byte length and pixel dimensions;
- transformation method, version, and parameters;
- metadata treatment;
- provenance and consent state;
- storage scope; and
- capture and ingestion timestamps.

The validator additionally rejects derivatives without an original, chains of
derivatives, response/item mismatches, duplicate image IDs, unsafe file names,
invalid digests, and non-positive dimensions.

### Response workflow

1. Create a narrowly scoped, short-lived submission slot bound to learner,
   session, item version, response, and one upload purpose.
2. Capture or select a photo, but do not submit automatically.
3. Validate decoding, media signature, size, dimensions, and private storage;
   preserve the original bytes and checksum.
4. Create separate orientation/crop and document-normalized derivatives with
   transformation provenance.
5. Let the learner review, retake, remove, or explicitly submit.
6. Run capture-quality review before graph observation.
7. Lock observations before criterion decisions. Cite observation IDs from
   every criterion result.
8. Abstain or route to a real available human-review path when capture or
   visual evidence is uncertain.
9. Return criterion feedback, allow dispute/recheck, and require an independent
   retry before adding mastery evidence.

## First approvable implementation slice

### Slice A — canonical question-image recovery and re-authoring

Scope:

- export the exact current versions of the ten AP Biology items;
- repair the five rejected diagrams;
- complete item-context scientific, grading, accessibility, and layout review;
- verify reviewer and student rendering with authenticated click-through;
- keep database rows and Storage unchanged until the replacement assets pass.

Acceptance evidence:

- manifest validation passes with `--require-release-eligible`;
- deterministic regeneration is byte-reproducible under the pinned environment,
  or replacement outputs receive new versions and full review;
- all ten exact item versions and checksums are recorded;
- narrow viewport, zoom, alt/long-description, answer-leakage, and missing-image
  behavior are captured;
- reviewer and student signed-image delivery both pass;
- independent QA records a proposed verdict.

Approval: content replacement and any Production upload/update are Hard Gates.
Local recovery, regeneration, validation tooling, and draft review packets are
standing-approved.

### Slice B — staff-only QR/direct-upload capture prototype

Scope after approval:

- simulated or consented test data only;
- short-lived single-use pairing plus direct-upload fallback;
- explicit review/submission;
- immutable original and two declared derivative types;
- capture-quality/retake states;
- no learner-facing automated score;
- no external model call until provider transfer/retention approval is verified.

Acceptance evidence:

- pairing expiry, replay, cancellation, duplicate submission, and recovery;
- signature/size/dimension/decoding rejection and private signed retrieval;
- raw-versus-derived checksum/provenance audit;
- blur, glare, cutoff, perspective, and cannot-determine scenarios;
- keyboard/non-drag controls and non-camera/non-QR alternative;
- representative browser/device matrix;
- data deletion/retention and incidental-identifier handling;
- independent security, privacy, accessibility, and Learning Quality review.

Approval: working prototype and any participant use require explicit Product
Owner approval. Production schema, Storage policy, provider calls, and learner
release remain separate Hard Gates.

## Open risks and blockers

1. Exact current item versions for the ten Production images are not present in
   the recovered package.
2. Five recovered diagrams have blocking visual defects; the other five are
   unapproved, not proven good.
3. Student/reviewer live rendering lacks recorded authenticated click-through.
4. The local hand-drawn corpus needs a consent/provenance/deduplication manifest
   before it can support claims about real-response accuracy.
5. Single-violation negative graph cases and adjudicated dual-human gold remain
   incomplete.
6. External-provider image transfer/retention approval remains a prerequisite
   for multimodal calls.
7. QR/camera accessibility and retention/deletion policy require human review.

## Handoff packet

**Task:** TASK-0006 question images + TASK-0011/TASK-0016 Phase D response
images.

**Current source:** this readiness record; the recovered package and its
`RECOVERY_REVIEW.md`; `TASK-0011_PHASE_1_EXECUTION_SPEC.md`; `UX-008` brief.

**Approved:** local recovery, deterministic tooling, schemas, fixtures, QA
planning, and draft packets.

**Not approved:** production asset replacement, working learner capture,
database/storage changes, provider image transfer, authoritative image grading,
participant use, or launch.

**Next owner action:** approve Slice A, Slice B, both in sequence, revise, or
stop. Recommended sequence is Slice A first because it repairs a current
question-delivery integrity risk without collecting new learner data.
