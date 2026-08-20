# TASK-0016 Phase D — Stage D0: Decisions and Blockers

**Written:** 2026-08-19, as part of Stage D0 execution. See `CURRENT_STATE.md` for the full
narrative and `ARTIFACT_INVENTORY.json` for per-artifact classification.

**Updated same day:** `DECISION-0050`/`APPROVAL-0045` retired the dual-human-adjudicated gold
requirement for Engine 4 specifically, replacing it with `DECISION-0045`'s already-established
AI-generation + multi-model-verification + reader-certification model (Set C un-deferred).
Blocker 3 and blocker 6 below are updated in place to reflect this — struck through, not
deleted, so the history stays visible.

**Updated again, same day:** the AI-verification half of the DECISION-0045 protocol has now been
**executed** against the 200-photo corpus (~$2.15 spend, two independent verifier families,
91.5%/89.7% agreement with gold, 88.5% verifier unanimity, 31 flagged candidate corrections not
yet applied). Full results:
`docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/decision_0045_verification_2026_08_19/README.md`.
Blocker 3 and decision-needed item 3 are updated again below to reflect that only the
human-reader-certification step remains.

---

## Blockers (no owner decision needed to acknowledge; needed to proceed)

1. ~~**System A (`CaptureItem.tsx`/QR path) is currently broken against live Production**~~
   **Resolved by `DECISION-0051`/`APPROVAL-0046` (2026-08-19):** QR handoff is confirmed as
   Engine 4's sole capture path, no direct-upload fallback. The fix is **not** re-creating
   `capture_sessions`/`capture-research` — System A's frontend gets rewired onto System B's
   already-working, already-deployed `attach_capture`/`app.response_attachments` backend instead.
   Concrete remaining engineering gap: the phone leg is token-paired/unauthenticated, but
   `attach_capture` only accepts authenticated calls — a bridge between the two is the actual
   Stage D2 work item now, not a DB-recreation task.
2. ~~**The frontend worktree used for all route/component inspection is 16 commits stale.**~~
   **Resolved (2026-08-19):** reviewed the full 16-commit gap via `git diff` against
   `origin/main`. The one capture-relevant commit ("Added capture quality check," `e8b65e9`) is
   speculative frontend-only work on **System B** (`SameDeviceCapture`/`hand-drawn-pilot`) that
   reads backend fields (`capture_retake_reason`, a real `capture_quality_state` other than
   `pending`) that don't exist — confirmed the same already-known Layer A frontend/backend drift
   from `project_idea1_capture_quality_check_status` (backend reverted 2026-08-18, frontend
   never rolled back), not new capability. No other capture-relevant change exists in the gap.
   Nothing in `CURRENT_STATE.md`'s frontend-route findings needs revision.
3. ~~**No corpus in the repo meets the dual-human-adjudicated gold standard.**~~ **Resolved by
   `DECISION-0050`/`APPROVAL-0045` (2026-08-19)**, then **advanced same day**: the
   `DECISION-0045`-protocol AI-verification pass has been run against the 200-photo corpus
   (Gemini + Qwen3-VL, ~$2.15, 91.5%/89.7% agreement with gold, 88.5% verifier unanimity, 31
   flagged criterion-level discrepancies across 26 photos — not yet applied to gold). **The one
   remaining piece is the human reader-certification FAR audit** — cold verification of a sample
   against a ≤5% false-accept-rate gate, which cannot be done by an AI agent. A ready-to-run
   ~100-photo stratified sample proposal exists in the verification run's README. This is now a
   scheduling/reviewer-time blocker, not a methodology gap.
4. **The raw photo archive (`docs/hand drawn samples/`, 382 files) is not ingestion-ready** per
   its own 2026-08-03 readiness audit — exact duplicates, no consent/provenance manifest,
   unstripped metadata. **Groundwork completed 2026-08-19**
   (`docs/research/hand_drawn_corpus_readiness_2026_08_19/`): rerunning the audit today reproduces
   the exact same numbers (78 duplicate groups/156 files, 271 metadata-flagged files,
   `ingestion_ready: false` — the corpus's 372→382 growth is non-image files outside scope, not
   drift). A full duplicate-group listing, a pre-populated 372-row provenance-declaration template
   (every required field genuinely empty, none inferred/fabricated), and a working
   metadata-stripping prototype (`scripts/drawn_response/strip_capture_metadata.py`, demoed on 3
   files, originals untouched) are now ready. **Consent/provenance resolved (2026-08-19)**: all
   images were created by the owner, Orly Bloom, Micah Bloom, or Fiverr/Upwork freelancers under
   standard platform ToS transferring full rights to the buyer — no third-party/student content,
   no per-creator consent variance. Filled into `provenance_declaration_template.csv` for all 372
   rows. **What remains blocked is narrower now**: per-file identity linking
   (response/item/content-item-version + timestamps) still needs real human knowledge the
   template can't infer, and duplicate resolution (item 2) still needs that identity linking, but
   neither is a legal/consent question anymore. No file in the samples directory was modified.
5. **AP Statistics — the actual launch subject per TASK-0016 — has almost no real-photo
   evidence.** The 28-photo smoke-test corpus is confirmed sourced from `Stats-HRD-2/` (resolving
   the earlier ambiguity about two separate Statistics photo sets — it's essentially the same 29
   uncatalogued photos, 28 of them graded), against a 40-item real graph corpus and a
   300-response/100-per-archetype release target. The Biology-heavy corpus this repo has built up
   (200 real photos, ~150 synthetic items) is development evidence for the shared graph grammar,
   not Statistics launch validation — exactly the distinction the Phase D prompt warns against
   conflating. **DECISION-0045 AI-verification now run against this corpus too (2026-08-19)** —
   same verifier pair (Gemini 2.5 Flash + Qwen3-VL), ~$0.26 spend, 60 calls, 0 errors. Results
   (n=28, 112 criterion judgments): 87.5%/72.3% verifier-vs-gold agreement, **71.4%
   verifier-vs-verifier unanimity — notably lower than Biology's 88.5%**, concentrated in
   mosaic-plot and scatterplot/dotplot criteria (a genuine Statistics-specific ambiguity, not a
   Biology-vs-Statistics data-quality gap). 6 flagged discrepancies across 6 distinct photos
   (3× `POINTS_PLOTTED`, plus `HEIGHTS_BY_CONDITIONAL_PROPORTION`, `FIVE_NUMBER_VALUES`,
   `VARIABILITY_COMPARISON` — the last reinforcing an already-known "strictness dispute, not
   defect" finding from prior smoke-test work). Full results:
   `docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/decision_0045_verification_2026_08_19/README.md`.
   **Both subjects are now at the same state**: AI-verification done, human reader-certification
   the only remaining gate. The small size (28 photos) makes a full Statistics certification pass
   cheap relative to Biology's — worth folding into the same reader-time decision as blocker 3
   rather than treating as a separate ask.
6. **The one human pilot attempt (Orly Bloom) never produced usable data.** It was QA-blocked in
   2026-06-13 for data-reproducibility errors and an overstated rights claim, and TASK-0011's own
   record shows no subsequent approval. **Largely mooted by `DECISION-0050`** — the pilot existed
   to seed dual-human adjudication, which is no longer the target gold model — but it's still
   worth an explicit call on whether to formally close it out (its QA findings are still real
   defects in those 3 prompts if they're ever reused for anything else) rather than leaving it in
   permanent limbo.
7. **`PLOT_VALUES` prompt-tuning is a dead end — confirmed twice, in opposite directions
   (2026-08-19).** A second, narrower fix attempt (keeping only the magnitude-tolerance clause,
   dropping the first attempt's ordering-strictness carve-out) was tested against the 11
   `PLOT_VALUES`-related flagged discrepancies from the DECISION-0045 verification pass plus a
   30-photo stratified control set. Result: worse on the flagged set (3/11 moved toward verifier
   consensus vs. the unmodified grader's own 7/11 baseline and v1's 5/11), and a new 20% (6/30)
   regression on the control set, concentrated in the `EST` archetype — the archetype carrying
   `PLOT_VALUES`'s largest FAR contribution. **Diagnosis: most of this disagreement lives at the
   gold layer, not a grader-tolerance gap** — on 7 of the 11 flagged cases, the *unmodified*
   production grader already agrees with both independent verifiers; gold is the outlier, not
   the grader. **Do not attempt a third prompt-tuning pass without new evidence** — the real
   lever is resolving the flagged discrepancies through the reader-certification/gold-adjudication
   step (blocker 3), not more prompting. Full results:
   `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/plot_values_fix_v2_2026_08_19/`.
   ($1.12 spend, neither gold nor DECISION-0045 outputs modified, nothing deployed.)

## Decisions needed from the Product Owner

1. ~~Formally acknowledge System B's deviation... or explicitly amend TASK-0016 decision #10.~~
   **Resolved by `DECISION-0051`/`APPROVAL-0046` (2026-08-19):** option (a) — decision #10 stands
   as-is, System B's frontend is superseded/pilot-only, its backend is reused. See blocker 1
   above for the concrete engineering implication.
2. ~~Decide whether to re-create `capture_sessions`/`capture-research`, or retire System A's
   storage layer outright.~~ **Resolved by the same decision**: neither — System A's storage
   layer is retired in favor of reusing System B's `response_attachments`/`learner-uploads`
   infrastructure, not recreated under a new migration.
2a. **New from `DECISION-0051`, not yet built:** capture-failure handling split — generic retake
    guidance to the student on image-quality failures (blur/glare/cutoff/framing), a logged bug on
    technical failures (API/infra errors). Not previously specified in the Phase D prompt or
    `HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`; needs folding into both when Stage D2
    engineering actually implements this, and needs an actual bug-logging mechanism identified
    (this repo's existing error-tracking convention, if one exists — not investigated here).
3. ~~Decide whether the real-photo accuracy investigation... should be formally reclassified~~
   **Executed for Biology same day.** The AI-verification half of the `DECISION-0045` pass is
   done for the 200-photo Biology corpus (results above); the Statistics corpora (28+29 photos)
   have not yet had this pass run against them — same mechanism, not yet executed, smaller/cheaper
   run. **What's left is an owner decision, not a methodology question:** (a) whether/when to
   commit reader time to the ~100-photo certification audit (same reviewer-scarcity constraint as
   every other content-review commitment in this program), and (b) how to resolve the 31 flagged
   Biology discrepancies — accept the verifier-consensus correction, keep gold as-is, or send them
   to the same reader pass as a first triage step before the broader audit sample is drawn.
4. **Confirm the archetype freeze.** The Phase-1 spec already froze 3 archetypes
   (`CAT`/`SER`/`EST`) in 2026-06-15 and every later document (including the 2026-08-18/19
   accuracy work) has used exactly those 3. This looks settled, but Stage D0 explicitly calls for
   an owner-visible freeze — worth one explicit confirmation rather than assuming continuity is
   permission.
5. ~~Decide next Phase D step... (a) resume Stage D1... or (b)...~~ **Stage D1 executed
   2026-08-19** (`SPATIAL_CONTRACT.md`, `CROSS_SUBJECT_MAPPING.md`, 9 versioned JSON Schemas, a
   citation-integrity checker, and a 13-test suite confirming fail-closed behavior on a criterion
   decision citing a missing observation — done in parallel with corpus-collection work, per
   option (b), confirming that parallelization was safe). **What's left is Stage D2** (implement
   and verify the QR capture MVP) — but that's still blocked on blockers 1/2 above (System A
   broken against live Production; no owner decision yet on QR-vs-direct-upload), which D1's
   completion doesn't change. One known incompleteness from D1, stated not hidden: the existing
   DECISION-0045 verification output isn't yet a conforming `criterion_decision_result.v1` record
   (no observation citations) — backfitting it is flagged as follow-up in `SPATIAL_CONTRACT.md`
   §2.5, not done.

## Explicitly not blocking

- The 200-photo Biology accuracy investigation and its follow-on architecture work
  (`ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`) remain valid, useful evidence regardless of how
  decision 3 above resolves — nothing here invalidates that work, it just clarifies its evidence
  tier.
- Duplicate `" 2"` files (§`ARTIFACT_INVENTORY.json`) are harmless and were left untouched per
  Stage D0 instructions — no action needed unless someone wants repo hygiene cleanup separately.
