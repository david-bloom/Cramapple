# CED Verification & Physics Review — Status as of 2026-07-24

**Purpose:** David is ending this session (unreliable Google Drive MCP connector — repeated `MCP error -32003: MCP tool call requires approval` even after reconnects) and starting a new one. This doc is the handoff so the new session doesn't have to re-derive context.

## What triggered this effort

David asked to reference each AP subject's official Course and Exam Description (CED) when authoring/reviewing content, after an AP Statistics scope check found real curriculum errors (e.g. slope-inference and transformations content that no longer belongs in the 2026-27 AP Statistics CED). Directive: build a primary-source "CED Fact Pack" per subject, verify existing content against it, and fix what's wrong. Priority order given: **physics, then calculus, then chemistry** (biology added later).

## Done — verified against primary-source PDFs, fact packs current

All of the below have a primary-source-verified fact pack in Google Drive (parent folder id `0ADgrFwyVdiCFUk9PVA`), each explicitly labeled with edition/date and "(use this one)" where a superseded version exists:

| Subject | Fact pack | Edition confirmed | Notes |
| --- | --- | --- | --- |
| AP Statistics | existing doc, verified this session | 2026-27 (primary source, David-supplied PDF) | Slope inference and transformations/log-linearization confirmed removed from the 2026-27 CED. |
| AP Physics 1 | "...(v3, primary source Fall 2024, use this one)" | Fall 2024 / © 2026 | **Substantially restructured**: 8 units now (was 7), Fluids added as new Unit 8 (moved from Physics 2), old "Circular Motion and Gravitation" unit gone — orbital content now Unit 6 Topic 6.6. |
| AP Physics 2 | "...(v3, primary source, use this one — v2 was a placeholder error)" | Fall 2024 / © 2026 | **Fluids removed entirely** (moved to Physics 1). Units renumbered 9-15. Optics split into two units (13 Geometric, 14 Waves/Sound/Physical). |
| AP Physics C: Mechanics | "...(v2, primary source, use this one)" | Fall 2024 / © 2026 | No standalone Gravitation unit — confirmed gravitation/orbital content lives in Unit 6 Topic 6.6 (Motion of Orbiting Satellites). Corrects an earlier low-confidence, web-search-derived version that wrongly guessed a standalone Unit 7 Gravitation. |
| AP Physics C: E&M | "...(v2, primary source, use this one)" | Fall 2024 / © 2026 | Units renumbered 8-13 (was 1-5). Electrostatics split into two units. Content itself essentially unchanged, just regrouped. |
| AP Precalculus | "AP Precalculus 2026-27 — CED Fact Pack" | Fall 2026 / © 2026 | New subject for Cramapple, no prior fact pack. **Unit 4 (parametric functions/vectors/matrices) is explicitly not assessed on the AP Exam** — any `apprecalc-*` content there needs separating from exam-prep material. |

## Content fixes already made (physics 1)

A scope check on `apphy1-*` content (36 items) found it needed no corrections for the restructuring itself — the physics facts are unaffected by renumbering. But it also found two thin/missing areas relative to the new CED, now fixed:

- **Orbital mechanics (Unit 6.6) — previously zero coverage.** Added `apphy1-frq-017` (derive orbital speed from Newton's 2nd law + gravitation) and `apphy1-mcq-021/022/023` (speed formula, period-radius scaling, qualitative comparison).
- **Fluids density/buoyancy (Topics 8.1/8.3) — existing fluids items only covered pressure/continuity/Bernoulli.** Added `apphy1-frq-018` (buoyancy force-balance) and `apphy1-mcq-024/025/026` (density calc, Archimedes' principle, floating equilibrium).

All 8 new items are live in Supabase (`app.content_items` / `content_item_versions` / `frq_criteria` / `mcq_choices`) and assigned to reviewer Muhammad Saood (`content_review_assignments`, stage `tutor_question`, status `pending`).

Four reviewer briefing packets were written for Saood and merged to `main` in PR #48 (`docs/reviewer_packets/SAOOD_PHYSICS2_CED_PACKET.md`, `SAOOD_PHYSICS_C_MECHANICS_CED_PACKET.md`, `SAOOD_PHYSICS_C_EM_CED_PACKET.md`, `SAOOD_PHYSICS1_NEW_CONTENT_PACKET.md`) — these summarize the scope changes above and tell him exactly what to check when reviewing.

## Saood and Jill review status (from earlier in this session)

- **Saood** (physics reviewer): backlog audited for quality; his `approve_with_edits` items were validated, fixed where his notes were accurate, and flipped to `reviewed_approved`. As of this session he still has a large pending queue (~78 pending assignments before the 8 new items above were added) — that's normal throughput, not a blocker.
- **Jill Schmidlkofer** (stats reviewer): a full week of her review activity was audited. Her 15 `approve_with_edits` items were reviewed for validity, corrected where needed, and approved. Her 10 `disapprove` decisions (curriculum-scope claims about the 2026-27 AP Statistics CED) were checked against the actual CED — most were valid and the flagged content was retired; the extended "power/Type I/II error" scope check across the whole Statistics corpus grew out of this. One broken record (`APSTAT-MOD3-E001`, a null-decision row) was fixed at the `content_items.status` level (set to `reviewed_approved`) — see the open engineering bug below for why it couldn't be fixed at the decision-record level.

## Known engineering bugs — flagged, NOT fixed (need an engineering session, not a content-review one)

1. **`prevent_review_decision_mutation` trigger** references `old.id`, but the actual primary key column on `app.content_review_decisions` is `content_review_decision_id`. Any attempted UPDATE to a decision row throws an ugly raw Postgres error instead of a clean rejection.
2. **`lock_content_review_submission` trigger** (raises `review_submission:assignment_locked`) blocks inserting a new superseding decision against any assignment that already has an existing decision — even a broken one. Same bug class as the earlier `GRAPH-009`/`MCQ-078` assignment-locking issues (which were worked around at the `content_review_assignments.status` field level, not fixed at the trigger level).

Recommend bundling both into one engineering ticket.

## Not yet done — blocked on Google Drive connector reliability

David supplied three more Google Drive PDF links for **Calculus AB/BC, Chemistry, and Biology** CEDs, but the Google Drive MCP connector became unreliable (`MCP error -32003: MCP tool call requires approval` on every call, including after multiple reconnect attempts) and none of the three could be fetched or even identified. **The links, in the order David sent them (not yet matched to subject):**

1. `https://drive.google.com/file/d/1Kr9A7yyRx1XBi68n5AocPKvPzefddAOD/view?usp=drive_link`
2. `https://drive.google.com/file/d/1Z4EjyIKJOFSIfi-kp88ZD9RGnXdmmRmV/view?usp=drive_link`
3. `https://drive.google.com/file/d/1j8mwcYSevX3DZDKWuUEF-eWkRnFBReS8/view?usp=drive_link`

**Next session should:** confirm Google Drive connector is working (try `get_file_metadata` on one of the above first — if it still 32003s, ask David to fully disconnect/reconnect the connector in settings rather than a quick toggle, since that's what didn't work this session), identify which file is which subject, then run the same primary-source verification + fact-pack-creation process already established for physics/precalc (see below for the reusable method).

### Why this matters for Calculus and Chemistry specifically

Existing fact packs for **AP Calculus AB/BC** ("AP Calculus AB and BC 2026-27 — CED Fact Pack") and **AP Chemistry** ("AP Chemistry 2026-27 — CED Fact Pack") were built earlier this session from **web-search-derived mirror PDFs (Fall 2020 editions)**, not a David-supplied current-year primary source. Given how much Physics 1 and Physics 2 turned out to have changed for 2024-25 (unit restructuring, Fluids moving between courses, unit renumbering), there's real risk these two are stale and need the same re-verification physics just got. Once the correct PDF is identified and processed, create a new "(vN, primary source, use this one)" doc and flag the old one as superseded — don't just trust the existing fact pack.

**AP Biology** has a pre-existing fact pack from before this CED-verification effort (created 2026-07-13/14) that has not been checked against a primary source at all in this pass — treat it with the same suspicion.

### Reusable verification method (established and validated this session)

1. Get the actual CED PDF into Drive (David-supplied is most reliable; `apcentral.collegeboard.org` direct fetches 403 in this environment on every attempt; third-party mirror hosts like `core-docs.s3.amazonaws.com` sometimes work but are unreliable — don't trust web-search summaries alone for curriculum-scope facts, they've been shown to contradict each other).
2. `read_file_content` on the Drive file ID. For files >10MB, `download_file_content` fails outright with a size-limit error — use `read_file_content` instead (no hard size limit, though very large docs can still truncate the returned text silently before the end — check where it cuts off, e.g. missing the last unit's detail pages, and fall back to whatever TOC/summary text is available for anything past the truncation point).
3. Large results get saved to a local tool-result file; use Python (`json.load` + write to a scratch `.txt`) to pull `fileContent` out, then `grep`/regex over that text to find unit weighting tables (`Exam Weighting for the Multiple-Choice Section`) and topic markers (`TOPIC \d+\.\d+`).
4. Cross-check against the existing fact pack: what changed (unit count, names, numbering, weighting, what's newly in/out of scope).
5. Write a new fact pack doc titled `"<Subject> 2026-27 — CED Fact Pack (vN, primary source, use this one)"` in Drive folder `0ADgrFwyVdiCFUk9PVA`, explicitly noting what changed from the prior version and any authoring/review implications.
6. **Verify the upload before trusting it** — `create_file` reports `fileSize: "1"` for all Drive-doc conversions regardless of actual content (benign metadata quirk), but a real mistake (accidentally uploading a placeholder string) has happened twice this session. Always `read_file_content` the new doc back and confirm it's not empty/wrong before reporting done.
7. Query the actual `app.content_items` / `content_item_versions` corpus for the subject's prefix (e.g. `apcalcab-%`, `apchem-%`, `APBIO-%`) and grep stimulus/stem text for keywords tied to anything that changed scope, to find real content that needs fixing — don't assume the fact pack alone is the deliverable.

## Stray Google Drive docs needing manual cleanup (no delete tool available to Claude)

- "AP Physics 1 2026-27 — CED Fact Pack" (empty placeholder, superseded by v3)
- "AP Physics 2 2026-27 — CED Fact Pack (v2, primary source, use this one)" (this title was itself a placeholder-upload mistake, superseded by v3)
- "AP Physics C Mechanics 2026-27 — CED Fact Pack (LOW CONFIDENCE - needs primary source)" (superseded by v2)
- Original (pre-2024-edition) Physics 2 and Physics C E&M fact packs, now superseded by their "(v2/v3, primary source, use this one)" replacements

David needs to delete these manually in Drive; Claude has no delete tool for Drive files in this toolset.
