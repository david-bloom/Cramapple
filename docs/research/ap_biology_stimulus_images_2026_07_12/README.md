# AP Biology Missing Stimulus Images — Generated 2026-07-12

**Status:** Draft recovery candidate. The package was recovered from
`archive/pr43-stimulus-images-20260721` on 2026-08-03 because its assets and
generator never reached `main`. Historical records say the files were uploaded
to Production and wired into reviewer/student rendering in July, but live
click-through and version-specific content fidelity were never independently
verified. The recovery preflight found five blocking visual-layout defects; see
`RECOVERY_REVIEW.md` and the machine-readable `manifest.json`. Do not treat this
directory as release eligible.

## Context

David reported graphs not rendering in the reviewer portal. Root-caused
across four layers (see `docs/activity_log/ACTIVITY_LOG.md`, 2026-07-12,
"Graphs Not Rendering in Reviewer Portal" entries):

1. `storage.objects` was completely empty on Production — no image files
   anywhere, in any bucket.
2. No column in the `app` schema could reference an image for a content
   item (`content_item_versions.stimulus` is text-only).
3. The reviewer portal frontend (`reviewer.review.$assignmentId.tsx` in the
   `cramapple-prototype` Lovable project) renders `artifact.stimulus` as
   plain text — no `<img>`, no chart component, nothing capable of
   displaying an image regardless of what's in the field.
4. `storage-sign-url`'s `canAccessBucket` only allowed `admin`/
   `content_author` to read the `content-assets` bucket — reviewers
   (`tutor`/`reader`) were excluded even if 1-3 were fixed.

## What was identified

Queried every AP Biology content item for image-referring language, then
read each full stem/stimulus by hand (not just keyword match) to separate
genuine gaps from false positives:

- **10 short FRQs — genuine gap, images generated here.** Stimulus is only
  a qualitative description ("A graph shows...", "A diagram shows...")
  with no underlying data — unlike the long-form FRQs, these aren't
  answerable without seeing the actual figure.
- **12 `APBIO-HDG-2026-GRAPH-*` items — no image needed, by design.**
  Student constructs and photographs their own graph from given data.
- **14 long-form FRQs — narratively reference a "Figure"/"graph" but fully
  embed the underlying data as text** (tables, sequences, character
  matrices). Answerable without an image. Not touched here — flagged as a
  separate, lower-priority clarity question, not a hard gap.
- **6 MCQs — false positives** from the original broad keyword search;
  fully self-contained text, no image needed. Matches David's report that
  MCQs were fine.

## The 10 generated images

| content_key | image | what it shows |
| --- | --- | --- |
| `APBIO-FRQ-S-002` | catalase reaction rate vs. temperature | line graph, peak at 37°C, sharp decline above 50°C |
| `APBIO-FRQ-S-003` | thylakoid membrane | PSII → ETC → PSI → ATP synthase, light reactions |
| `APBIO-FRQ-S-005` | GPCR signaling cascade | signal → GPCR → G protein → adenylyl cyclase → cAMP → PKA → targets |
| `APBIO-FRQ-S-008` | DNA replication fork | helicase, leading strand (continuous), lagging strand (Okazaki fragments) |
| `APBIO-FRQ-S-009` | pre-mRNA splicing | E1-I1-E2-I2-E3 pre-mRNA, two alternative spliced products |
| `APBIO-FRQ-S-012` | logistic population growth | sigmoid curve approaching carrying capacity K |
| `APBIO-FRQ-S-014` | electron transport chain | Complexes I-IV, ATP synthase, H+ pumping (accurate: no pump at Complex II) |
| `APBIO-FRQ-S-015` | lac operon | lacI, promoter, operator, lacZYA, repressor, allolactose induction |
| `APBIO-FRQ-S-018` | gap junctions vs. plasmodesmata | side-by-side animal/plant cell comparison |
| `APBIO-FRQ-S-020` | blood glucose homeostasis | rise after meal, return to set point over ~2 hours |

Generated via `generate.py` (matplotlib, textbook-schematic style — not
photorealistic, appropriate for assessment content). Each image was
individually reviewed against its stimulus text for scientific accuracy
before this directory was written (see the corresponding activity log
entry for the review notes, e.g. Complex II correctly shown without proton
pumping, ETC/GPCR pathway order, replication fork topology).

**2026-07-19 second-pass review (before Storage upload) found 3 real
errors in the initial batch, since fixed and regenerated:**

- `APBIO-FRQ-S-008` (replication fork): the "fork movement" arrow pointed
  *away* from the still-paired parental strands and into the
  already-unwound leading/lagging-strand region — backwards, since a fork
  can only advance into unreplicated DNA. Arrow direction corrected.
- `APBIO-FRQ-S-014` (ETC): drew a direct Complex I → Complex II arrow,
  implying a single sequential I→II→III→IV pathway. Complex I and Complex
  II are independent, parallel entry points (from NADH and FADH₂
  respectively) that both feed Complex III — they don't feed each other.
  Complex II moved off the main row with its own arrow into Complex III.
- `APBIO-FRQ-S-015` (lac operon): an arrow ran from `lacI` directly into
  the operon's `Promoter` box, visually implying a functional link between
  lacI's own promoter and the operon's promoter. Replaced with a
  standalone annotation on `lacI`, no connecting line.

The other 7 images were re-checked in the same pass and found correct.

## Historical deployment record and remaining steps

1. ~~Apply migration~~ — done. `202607121001` applied to Production
   (`pcntajvbdfqhbeewmdry`).
2. ~~Upload the 10 PNGs~~ — done. Uploaded to `content-assets` at
   `Biology/FRQ/<content_key>.png` (capitalized — differs from the
   `biology/frq/` convention in the migration comment; used as-uploaded).
3. ~~Update the 10 rows~~ — done. All 10
   `app.content_item_versions.stimulus_image_path` values set and confirmed.
4. ~~Extend the curated `public.content_item_versions` view~~ — done, via
   `202607121002_content_item_versions_view_stimulus_image_path.sql`.
5. ~~Deploy the `storage-sign-url` fix~~ — done.
6. ~~Update the reviewer portal frontend~~ — done, in the correct project
   (`exam-buddy-wireframe`, not `cramapple-prototype` — see the 2026-07-19
   activity log entry for why).
7. ~~Update the student-facing session frontend~~ — done, same project.
8. **Verify** (still open): confirm a reviewer (tutor-role account) can
   actually load and see an image for at least one of the 10 items in the
   live UI, and confirm a student-facing practice session does too.
   Verified so far only at the data/auth level (see activity log) — not
   yet an actual click-through by a logged-in account.
9. Get this independently re-QA'd before treating it as fully done —
   standing practice this session for every live-grading/content change.
10. Resolve the blocking recovery findings in `RECOVERY_REVIEW.md` and complete
    every review gate in `manifest.json` against the exact current content-item
    versions.

## Reproducible generation

From the repository root:

```bash
python3 -m pip install -r \
  docs/research/ap_biology_stimulus_images_2026_07_12/requirements.txt
python3 docs/research/ap_biology_stimulus_images_2026_07_12/generate.py \
  --out /tmp/cramapple-apbio-images
python3 scripts/validate_image_package.py \
  docs/research/ap_biology_stimulus_images_2026_07_12/manifest.json
```

The generator defaults to this package directory when `--out` is omitted.
Generate to a temporary directory for comparison so unreviewed output does not
silently replace the recorded PNGs. It refuses to generate canonical candidates
under a Matplotlib version other than 3.11.1; `--allow-version-drift` is only for
non-canonical visual comparison.
