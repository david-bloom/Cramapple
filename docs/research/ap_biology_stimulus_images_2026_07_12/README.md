# AP Biology Missing Stimulus Images — Generated 2026-07-12

**Status:** Images generated and reviewed by eye; not yet uploaded to
Storage or linked in the database. Blocked mid-execution by an MCP tool
access interruption (Supabase and Lovable both stopped responding
mid-session) — this directory exists so the work survives that interruption
and can be finished in one pass once access is restored.

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

## Remaining steps once tool access is restored

1. **Apply migration** `supabase/migrations/202607121001_add_stimulus_image_path.sql`
   to Production (`pcntajvbdfqhbeewmdry`) — adds
   `content_item_versions.stimulus_image_path text`.
2. **Upload the 10 PNGs** to the `content-assets` Storage bucket at
   `biology/frq/<content_key>.png`.
3. **Update the 10 rows** in `app.content_item_versions` to set
   `stimulus_image_path = 'biology/frq/<content_key>.png'` for the matching
   `content_key`.
4. **Extend the curated `public.content_item_versions` view** (and
   `public.grading_results`-style views as needed) to expose the new
   column — same gap pattern found and fixed earlier this session for
   `grading_results`; don't repeat it here.
5. **Deploy the `storage-sign-url` fix already committed to git** (adds
   read-only `content-assets` access for `tutor`/`reader`/`validator`).
6. **Update the reviewer portal frontend** (`cramapple-prototype` Lovable
   project, `reviewer.review.$assignmentId.tsx`) to fetch a signed URL for
   `stimulus_image_path` when present and render an `<img>`, alongside the
   existing text stimulus.
7. **Update the student-facing session frontend** (same project, FRQ
   session route) with the equivalent render path, so students see the
   same images tutors/readers are reviewing.
8. **Verify**: confirm a reviewer (tutor-role account) can actually load
   and see an image for at least one of the 10 items, and confirm a
   student-facing practice session does too.
9. Get this independently re-QA'd before treating it as done — standing
   practice this session for every live-grading/content change.
