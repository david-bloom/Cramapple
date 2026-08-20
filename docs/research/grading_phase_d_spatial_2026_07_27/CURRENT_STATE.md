# TASK-0016 Phase D — Stage D0: Current State

**Written:** 2026-08-19. **Executed by:** Claude, per
`prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md`, which names Claude the
accountable execution owner for Phase D and requires this stage ("Recover and freeze actual
state") before any further implementation. This is the first time Stage D0 has been run — this
directory did not exist before today.

Evidence-class labels follow repo convention (Live verified / Deployed verified / Repository
only / Prototype-research only / Proposed / Not verified). Full raw findings behind every claim
below live in three parallel investigations run today; see `ARTIFACT_INVENTORY.json` for the
per-artifact classification this doc summarizes.

**Updated same day:** `DECISION-0050`/`APPROVAL-0045` retired the dual-human-adjudicated gold
requirement for Engine 4 specifically and un-deferred `DECISION-0045`'s AI-generation +
multi-model-verification + reader-certification model in its place. Wherever this document below
says a corpus lacks dual-human gold, read that as "still needs a `DECISION-0045`-protocol pass,"
not "blocked pending human adjudication that hasn't been scheduled." See
`DECISIONS_AND_BLOCKERS.md` for the specifics.

**Updated again, same day:** the AI-verification half of that protocol has now been **run**
against the 200-photo corpus — see §3a below and
`docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/decision_0045_verification_2026_08_19/`.
Only the human reader-certification step remains outstanding.

**Updated again, same day:** `DECISION-0051`/`APPROVAL-0046` resolved the System A/B capture
question — QR handoff (System A) confirmed as Engine 4's sole capture path, no direct-upload
fallback; System A's frontend gets rewired onto System B's already-working
`attach_capture`/`app.response_attachments` backend rather than recreating the missing
`capture_sessions`/`capture-research` objects. New guidance: image-quality capture failures get
generic retake copy, technical failures get bug-logged. See `DECISIONS_AND_BLOCKERS.md` items 1-2.

**Updated 2026-08-20 — STAGE D2 SHIPPED.** After the S-1 fix and 5 rounds of independent QA, the
owner authorized the full deployment sequence. Both migrations and both edge functions
(`capture-pairing`, `attempt-response`) are now live on Development and Production; both `main`
branches (backend `4b3527c`, frontend `320ea3f`) are pushed; the Lovable frontend is published and
`cramapple.com` verified live and healthy. Full deployment record: `DECISIONS_AND_BLOCKERS.md`
item 8. This is the first Stage D2 traffic ever to reach a real deploy.

**Updated again, same day:** Stage D1 (freeze the spatial contracts) is now **complete** —
`SPATIAL_CONTRACT.md`, `CROSS_SUBJECT_MAPPING.md`, and `schemas/` now exist in this directory. A
second `PLOT_VALUES` prompt-tuning attempt was also tried and confirmed a dead end (worse than
both the unmodified grader and the first, reverted attempt). The DECISION-0045 AI-verification
pass has also now been run against the 28-photo Statistics corpus (87.5%/72.3% agreement, 71.4%
verifier unanimity — lower than Biology's, concentrated in mosaic/scatterplot criteria, 6 flagged
discrepancies). Both subjects are now at the same state: AI-verified, awaiting human
reader-certification. See `DECISIONS_AND_BLOCKERS.md` items 5 and 7.

**Updated 2026-08-20 — STAGES D4 + D5 PACKAGED (R&D-tier).** Per owner directive, the observation
bake-off (D4 → `BAKEOFF_RESULTS.md`) and abstention calibration (D5 → `ABSTENTION_CALIBRATION.md` +
`abstention_thresholds.json`) were packaged from existing 2026-08-18/19 evidence, with two new
deterministic re-analyses (`analysis/`) and one bounded paid run. New findings: **arm 4
(gate-on-escalation) is near-neutral** vs. gating alone (neither clears FAR); the **full-corpus
self-consistency confirmation** ($6.64, 322 calls, 0 errors) shows the FAR lever **holds at scale
without reversing** (majority-earned 19.0→14.7) but still fails ≤2%; and **only 3 of 24
(archetype,criterion) cells are provisionally auto-eligible** — the data confirms Engine 4 is
shadow-only. Everything remains `ai_provisional`-gold / no-locked-holdout / R&D-tier; the genuine
remaining D4/D5 work (a locked D4d holdout) stays gated on D3. Full record: `EXECUTION_LOG.md`
(Stages D4+D5 entry), `D3_D4_D5_STATUS.md` updates.

---

## 1. Where Phase D actually stands

**Nothing in Phase D's own defined sequence (Stages D0-D7) has been executed before today.**
Two separate, ad hoc efforts touched hand-drawn capture and real-photo grading accuracy in the
last two weeks, but neither was run as Phase D work, neither followed the state-freeze →
contracts → capture MVP → gold → bake-off → abstention → shadow order, and neither is complete
against its own scope:

1. **Real-photo grading accuracy investigation (2026-08-18/19)** — measured Engine 4's actual
   accuracy against 200 real Biology photos and 28 real Statistics photos. This is genuinely
   valuable, directly-relevant evidence (§3 below), but it substitutes for Phase D's Stage D4
   bake-off without having gone through D0-D3 first, and its gold is single-pass AI, not the
   dual-human-adjudicated standard D3 requires.
2. **Two divergent capture-frontend builds (2026-08-15)** — "System A" (`CaptureItem.tsx`, QR
   pairing + a real Gemini quality check, live on `/session`) and "System B"
   (`SameDeviceCapture.tsx`, TASK-0025's pilot, same-device upload + real image preservation via
   `attach_capture`/`app.response_attachments`, admin-only/unlinked). Neither is Stage D2 done
   correctly: System A implements QR handoff (the approved MVP per TASK-0016 decision #10) but
   violates D2's own requirement to persist the original image; System B persists the image but
   isn't QR and was built without running D0/D1 first. See §2 and
   `docs/research/HAND_DRAWN_CAPTURE_PATH_RECONCILIATION_2026_08_19.md` for full detail.

## 2. Capture path — live system state (Deployed verified, queried 2026-08-19)

| Object | Dev (`wmgjsdkphcyhngaffbqf`) | Prod (`pcntajvbdfqhbeewmdry`) |
|---|---|---|
| `app.response_attachments` rows | 0 | 0 |
| `capture_sessions` table | **Does not exist** | **Does not exist** |
| `capture-research` storage bucket | **Does not exist** | **Does not exist** |
| `learner-uploads` bucket objects | 0 | 0 |
| `app.grading_results` rows with `model_id='manual-review'` | 0 | 0 |
| `app.content_item_versions` with `evaluator_strategy='human_shadow'` | — | 59 (2 assigned / 24 published / 27 retired / 6 reviewed_disapproved) — unchanged since 2026-08-18 |

**New finding, not previously known:** `capture_sessions` (System A's backing table) and the
`capture-research` bucket (its storage target) **do not exist in either database today.** A
generated TypeScript types file in the frontend worktree (`src/integrations/supabase/types.ts`,
last touched 2026-07-09) shows `capture_sessions` existed in Production as of that date, created
outside any committed migration (no `supabase_migrations.schema_migrations` entry for it, in
either project). It has since been removed from both projects with no migration recording either
its creation or its removal. **System A's `capture.functions.ts` (11 call sites) currently calls
a table that does not exist — this path is not "research-scoped," it is presently broken against
live Production**, not merely research-scoped as its own code comments claim. This is a materially
different finding than the reconciliation note drafted before this investigation, which treated
System A as functional-but-scoped rather than broken.

**Frontend snapshot caveat, now resolved:** the worktree used for all frontend inspection
(`.worktrees/task0019-frontend`) was checked out at commit `369e4e8` (2026-08-16), 16 commits
behind `origin/main`. Reviewed the gap directly via `git diff` against `origin/main` (without
mutating the worktree). Of the 16 commits, only one touches capture code: `e8b65e9` ("Added
capture quality check," merged 2026-08-18), which modifies `SameDeviceCapture.tsx` and
`hand-drawn-pilot.tsx` — **System B, not System A** — to display a `retakeReason` banner when
`attach_capture`'s response carries `capture_quality_state: "retake_required"` and a
`capture_retake_reason` string. **Confirmed this is dead/speculative code**, not new capability:
`capture_retake_reason` does not exist anywhere in the backend (`grep -rn` across `supabase/`
returns zero matches), and `capture_quality_state` never leaves its default `'pending'` value
today (TASK-0025 explicitly scoped the actual quality-check mechanism out — "no way to move it to
`'acceptable'` other than a direct service-role update"). This is the same frontend/backend
contract drift already recorded in memory (`project_idea1_capture_quality_check_status` —
Layer A shipped 2026-08-18, reverted same day on the backend, frontend never rolled back) —
this commit is that same drift's frontend half, not a new development. **No other capture-relevant
change exists in the 16-commit gap.** The remaining 15 commits are unrelated (styling, unit-data
fixes, routing). Every other frontend-route/component claim in this document and the prior
reconciliation note stands as previously reported — nothing else needs updating.

## 3. Corpus state (Repository + Prototype-research only, verified 2026-08-19)

No corpus anywhere in this repo meets the dual-human-adjudicated gold standard Stage D3/§12.2
requires. Everything that exists is one of: synthetic-generated prompts, traced-from-synthetic
photos (real handwriting of a synthetic template, not an independent response), or single-pass
AI-graded "gold."

- **`hand_drawn_graph_benchmark_2026_06_30/` (VISION_FAST_ESC, n=150):** all historical numeric
  claims (97.33% exact match, 99.478% criterion accuracy, p50 3393.5ms, avg cost $0.003943)
  **independently reverified against the raw `runs/` JSONL and confirmed correct.** But this
  corpus is all-earned synthetic trace pages, not independent or real-negative — value is
  `REGRESSION_FIXTURE` only, as the Phase D prompt itself already warned.
- **200-photo real-photo corpus (`hand_drawn_graph_real_photo_benchmark_2026_08_18/`):** real
  handwriting, but gold is single-pass AI (one model call per 10-photo batch), not dual-human.
  Measured result **fails all four Phase-1-spec-adjacent DR-1 thresholds**: 23.0% exact match /
  84.5% F1 / 30.6% false-accept / 20.5% false-reject (baseline arm; later work in the same
  corpus improved this — see `ENGINE4_PRODUCTION_DESIGN_2026_08_18.md` — but no arm clears all
  four gates). This is the most decision-relevant accuracy evidence that exists today, and it
  says today's architecture is not launch-ready on any capture path.
  `HOLDOUT_ELIGIBLE, pending dual-human adjudication` — not yet actually holdout-eligible.
- **AP Statistics real photos:** only 29 uncatalogued photos exist (`Stats-HRD-2/`), not
  cross-referenced against the 40-item AP Statistics graph corpus in any manifest found. A
  separate 28-photo Statistics accuracy smoke test exists (`docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/`,
  see memory `project_engine4_far_investigation_2026_08_18`) — also single-pass gold, same gap.
- **`docs/hand drawn samples/` (382 files, corrected from a stale "372" figure — the readiness
  audit's count predates later additions):** per its own readiness audit
  (`HAND_DRAWN_CORPUS_READINESS_AUDIT_2026_08_03.md`), **not ingestion-ready** — exact duplicates
  present, no consent/provenance manifest, embedded metadata unstripped.
### 3a. DECISION-0045 AI-verification pass, executed (Live verified, 2026-08-19)

Two independent, non-OpenAI, non-Anthropic model families independently graded all 200 real
photos, blind to the existing gold, each other, and any grader output — required because the
existing gold was written by Claude/Anthropic and the grader under test is OpenAI, so Anthropic
is "consumed" as the writer family. `moonshotai/kimi-k2` turned out not to support image input at
all and `kimi-k2-thinking` was empirically unreliable on this task's schema (hangs/parse
failures) — both dropped after a validation probe, per instruction not to substitute a
disallowed OpenAI/Anthropic model; `alibaba/qwen3-vl-235b-a22b-instruct` was probed and validated
as a third candidate instead. Final pair: **Google (`gemini-2.5-flash`) + Alibaba
(`qwen3-vl-235b-a22b-instruct`)**. Total spend ~$2.15 (423 calls), well under the $10 autonomous
cap.

- **Agreement vs. existing gold** (n=133 usable photos — 67 excluded because Qwen returned empty
  judgments on them, concentrated in the `EST`/`SER` archetypes, a Qwen reliability finding, not a
  content disagreement): Gemini 91.5%, Qwen 89.7% overall per-criterion agreement.
- **Verifier-vs-verifier unanimity:** 88.5%.
- **31 criterion-level flags across 26 photos** where both verifiers unanimously disagree with the
  existing gold — dominated by `PLOT_VALUES`/`X_SCALE` tolerance cases (17/31) and
  `UNCERTAINTY_MARKS` (7/31, the same criterion that was already the weakest-agreeing one in
  Result 1). **Not applied to the gold file** — these are candidates for human review, per
  `DECISION-0045`'s "checked... before a reader sees them" language, not automatic corrections.
- **Outstanding: reader-certification.** `DECISION-0045` still requires a human reader to cold-verify
  a sample and certify a false-accept rate (≤5% upper-95%-bound gate). This cannot be done by an AI
  agent. A ready-to-run ~100-photo stratified sample proposal (weighted toward the
  weakest-agreement criteria found above) is written up in the verification directory's README.

- **Archetype count:** the Phase-1 spec (`TASK-0011_PHASE_1_EXECUTION_SPEC.md`) already froze
  exactly **3 archetypes** (categorical-comparison-w/-SEM, continuous-measured-series-w/-SEM,
  continuous-relationship-w/-graph-derived-estimate — i.e. `CAT`/`SER`/`EST`), matching Stage
  D0's own requirement to freeze at ≤3. **This part of D0 is already satisfied**, done in the
  2026-06-15 spec, not something this pass needs to redo.
- **Release-corpus target, also already specified and unchanged:** 300 responses, 100/archetype,
  split 90 development / 60 calibration / 120 locked holdout / 30 challenge
  (`TASK-0011_PHASE_1_EXECUTION_SPEC.md`, confirmed word-for-word against the Phase D prompt).
  **Nothing close to this exists** — current real-photo counts are 200 (Biology, ungated
  archetype mix) and 28-29 (Statistics), all single-pass-AI or ungraded.

## 4. Required-reading summary (Repository only, read 2026-08-19)

All 8 documents named in the Phase D prompt's "Read first" list beyond what was already covered
this session (TASK-0016, the ledger, the capture-experience design) have now been read in full.
Highlights that bear on Phase D specifically:

- **TASK-0011** itself is still `Status: Research`, `Approval: Pending` — the umbrella task Phase
  D executes has never been formally approved past research scope.
- **`DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`** is the direct ancestor of the Phase-1 spec and the
  source of several non-negotiable constraints Phase D inherits: no vendor selection before a
  held-out bake-off, perception/judgment must be separate schema records, no single-pass
  automated score as V1, image overlays deferred pending a localization benchmark that has never
  run, and — a warning worth restating given this session's own numbers — the original
  proposal's cost/latency estimates were explicitly called "not decision-grade" and had to be
  replaced with measured results, exactly the discipline the 2026-08-18 real-photo work then
  correctly followed.
- **`ORLY_DRAWN_RESPONSE_PILOT_PROTOCOL.md` / `DRAWN_RESPONSE_PILOT_V0_REVIEW.md`:** the one
  concrete human-pilot attempt (Orly Bloom, Learning Quality Owner) was **QA-blocked** —
  reproducibility errors in two of three prompts' stated data, plus an overstated/false
  rights-approval claim that had to be corrected. TASK-0011's own progress notes never record
  a v0.2 approval, so this pilot has been stalled since 2026-06-13 and produced zero corpus data.
- **`GRADING_RESEARCH_CANONICAL_PROCESS.md`:** only `adjudicated_gold`/`held_out` tiers may
  support quality/release claims — by this rule, no claim made anywhere about Engine 4 today (in
  this doc or any prior research doc) is release-grade evidence yet.
- **`grading_cross_subject_takeaways.md`:** almost entirely Engine 1/text-grading lessons; the
  one live warning worth carrying into Phase D is Lesson 27 (2026-08-13) — an architecture/
  latency claim validated on the wrong model silently failed to replicate on production's real
  model. Any Phase D architecture choice made by analogy to Engine 1/3 needs its own
  measurement, not a borrowed number.
- **`docs/GRADING_PROGRAM.md`** (the master index) independently confirms: 33 published AP
  Statistics items already carry `rubric_type='spatial'`/`evaluator_strategy='human_shadow'`,
  deliberately parked on human grading while TASK-0011 stays research-only — i.e. "content with
  no engine" is the correct, current, intended state, not a gap to rush closed.

## 5. What Stage D0 concludes

- **Do not treat either capture system (A or B) as a finished Stage D2.** System A is currently
  non-functional against live data (missing table/bucket) in addition to its known
  image-deletion defect; System B preserves images correctly but isn't the approved capture
  method and skipped D0/D1.
- **Do not treat the 200/28-photo accuracy work as a Stage D4 bake-off pass.** It's real,
  valuable, correctly-measured evidence that the current architecture fails launch thresholds —
  but its gold tier (single-pass AI) doesn't meet Stage D3's dual-human-adjudication requirement,
  so nothing built on it yet counts as a locked holdout result.
- **Archetype freeze (D0 item 7) and the release-corpus target are already done**, inherited
  correctly from the 2026-06-15 Phase-1 spec — this pass confirms them, does not need to redo
  them.
- **The corpus itself is not ingestion-ready** — real photos exist but lack consent/provenance
  manifests and have unstripped metadata, a separate gate from accuracy or capture-method choice.
  **Groundwork completed 2026-08-19** (`docs/research/hand_drawn_corpus_readiness_2026_08_19/`):
  a full duplicate-group listing, a ready-to-fill provenance-declaration template, and a
  demonstrated (not applied) metadata-stripping tool. Blocked, unchanged in kind, on an actual
  human provenance/consent declaration — see `DECISIONS_AND_BLOCKERS.md` item 4.

**Updated 2026-08-20:** a separate session reworked all 15 Round-1 findings (backend `c45b838`,
frontend `b01d3b0`, on top of the commits described just below) and a Round 3 independent QA
review has now run against that rework. **Verdict: HOLD FOR FURTHER REWORK, close — not a
redesign.** All 6 blocking findings confirmed genuinely fixed (one empirically probed live), but
4 new must-fix issues surfaced (a redemption-budget off-by-one, `keepOpen` derived from DB state
instead of the quality verdict, the new double-submit guard never clearing on failure, and 6
retryable validation failures still hitting a dead-end screen) plus 5 recommended fixes. Full
detail: `QR_MVP_QA_REVIEW_ROUND3_2026_08_20.md`. See `DECISIONS_AND_BLOCKERS.md` item 8 for the
complete disposition and next-step pointer.

**Updated again 2026-08-20 — rework pass 2 executed.** All four must-fix (N1-N4) and all five
recommended (N6, N7, N8, N11, N14) Round-3 findings addressed; N5/N9/N10/N12/N13 and the F13 orphan
gap deferred with recorded reasoning. Notably N7 added an `is_submitted` guard INSIDE
`bind_response_attachment` (new migration `20260819120100`) after confirming against live Prod that
the deployed function has none, making the "open capability can't corrupt a submitted response"
guarantee a real DB invariant rather than an edge-function race. Reworked to backend `5ce92ec` /
frontend `668a2cd`; 290 backend + 232 frontend tests pass, check/lint/tsc/build clean; nothing
merged, pushed, deployed, or applied (live Prod shows 0 of the two capture migrations applied, 0
capture functions present). Detail: `QR_MVP_REWORK_ROUND2_2026_08_20.md`. **Awaiting a Round-4
independent QA** (prompt
`prompts/CLAUDE_TASK0016_PHASE_D2_QR_CAPTURE_INDEPENDENT_QA_ROUND4_2026_08_20.md`) — two consecutive
independent reviews have held this, so it stays owner-gated, not self-certified.

**Updated again 2026-08-20 — Round 4 QA ran, then rework pass 3.** Round 4 verdict: **HOLD, one
blocking item, narrowly scoped** — 8 of 9 pass-2 fixes held up, but N7's shared-function guard was
not safe as written: **B1**, its lock acquisition order (`response_versions` then `attempts`) was
inverted against the already-deployed `app.submit_response` (`attempts` then `response_versions`),
a real deadlock empirically confirmed by `EXPLAIN` on Dev — and if `submit_response` were the
victim, a capture-feature guard would be breaking core answer submission; and **S1**, the guard's
new error code was mapped in only one of the shared function's two callers, so applying the
migration alone would have turned a legitimate refusal into a 500 on the live `attach_capture`
path. Detail: `QR_MVP_QA_REVIEW_ROUND4_2026_08_20.md`. **Rework pass 3 (backend `ad3cd5a`,
frontend `7d09188`) fixed both must-fix items and all five should-fix items (S2, S3, L1, L2, L5)
with nothing deferred.** B1's fix was re-verified the same way it was found — read-only `EXPLAIN`
on Dev showing each new lock statement as its own single-relation `LockRows`, taken in
`submit_response`'s order, with the unlocked attempt-id resolve planning with no `LockRows` at all.
Tests: backend 297 pass / 0 fail (295 before), frontend 239 pass / 0 fail (was 232);
check/lint/tsc/build clean on changed files. Nothing merged, pushed, deployed, or applied —
re-confirmed read-only that live `bind_response_attachment` is still byte-identical on both Dev and
Prod and that neither capture migration is in `schema_migrations` on either project. Detail:
`QR_MVP_REWORK_ROUND3_2026_08_20.md`; disposition in `DECISIONS_AND_BLOCKERS.md` item 8.
**Awaiting a Round-5 independent QA — this pass is explicitly not self-certified as mergeable**;
three consecutive independent reviews have held this feature, which is the established practice
here, not a formality.

**Original Round 1 build/QA record, preserved below:** D2 (QR capture MVP) was **built and
unit-tested** as of 2026-08-19. Backend: a new `capture-pairing` edge function bridges the
unauthenticated, token-paired phone leg into the existing `attach_capture`/
`app.response_attachments` path (reuses `validateCaptureObject`, `bind_response_attachment`, the
storage TOCTOU guard, `audit_events` — no parallel validation path or table). On branch
`worktree-agent-ac9429c5f676cfd4f` in this repo, commit `768b1bb`, 82 new tests passing, full
`_shared` suite 260/260, **migration not applied, nothing deployed**. Frontend: rewires
`CaptureItem.tsx`/`capture.functions.ts` off `capture_sessions` onto the new bridge, implements
DECISION-0051's failure-handling split (backend has no error-tracking system — used
`app.audit_events`, not alerting; frontend has one — `reportLovableError`). Branch
`phase-d2-qr-capture-rebuild` in `exam-buddy-wireframe` (`/Users/davidbloom/Documents/exam-buddy-wireframe`,
durable — commit `6dd89ff`), 229 vitest passing, `tsc`/build clean, **not pushed, no PR, no
Lovable publish.** Full detail, including everything explicitly NOT yet verified (DB-level
atomicity, end-to-end real-phone run, cutoff/blur/glare model accuracy, per-IP rate limiting,
accessibility beyond structural review): `QR_MVP_IMPLEMENTATION.md`,
`SECURITY_PRIVACY_ACCESSIBILITY_REVIEW.md`, `QR_MVP_TEST_RESULTS.md` in this directory.
**Independent QA review completed 2026-08-19 — Verdict: HOLD FOR REWORK, not merged.** 5 finder
angles, 6 blocking findings (each independently re-verified), 8 serious non-blocking, several
lower-severity. The two primary user journeys are dead ends on first use: a blurry photo cannot
be retaken without walking back to a fresh QR scan (the exact behavior DECISION-0051 exists to
guarantee), and "Cancel pairing" strands the desktop permanently at "Loading…". Most serious: the
capture-quality vision call reserves against the *shared* daily grading budget
(`OPENAI_DAILY_CAP_USD`) but never releases it on failure — a capture bug can silently break
`evaluate-attempt` for students who never touched capture that day. Also confirmed: an
unmetered-in-practice paid-call retry loop, the DECISION-0051 bug-logging mechanism silently
drops rows under a UNIQUE-constraint collision and returns a fabricated `incident_id`, two SQL
housekeeping updates are always rolled back by their own exception handling, and an
`ON DELETE CASCADE` is unreachable because of an unconditional guard trigger. Full findings: `QR_MVP_QA_REVIEW_2026_08_19.md`, this directory.
**Positive finding, not to be lost in the above:** the trust boundary itself held under adversarial
review — token design, RLS posture, cross-user denial, single-use-under-concurrency (a real
compare-and-set, not check-then-act), and reuse of `attach_capture`'s byte-validation were all
verified correct, and 7 of 8 defects from `attach_capture`'s own prior QA history were confirmed
NOT reintroduced. The defects are concentrated in lifecycle edges and the two-call budget
protocol, not the security architecture — fixable without a redesign, per the reviewer.
Neither branch has been merged, pushed, or deployed.

**Reworked 2026-08-20 — awaiting a fresh independent QA.** The next session first re-verified,
independently, that no rework had been done (the branches were byte-identical to the failed
commits `768b1bb`/`6dd89ff`), then re-ran the full Round-1 checklist against the actual code and
executed the rework: **all 15 findings addressed.** Blocking: retake-eligible captures now RECORD
(new `record_capture_upload`, capability left live in `uploaded`) instead of consuming, so in-place
retake works (F1); Cancel re-mints a fresh QR (F2); the paid quality call moved AFTER the bind,
`complete_model_usage` releases the reservation on every path, and a same-path idempotency
short-circuit bounds paid calls (F3/F4); `logAuditEvent` uses a server-unique `request_id` and
returns null on failure — no collision, no phone-driven suppression, no fabricated `incident_id`
(F5); the claim function RETURNS its terminal transitions instead of UPDATE-then-RAISE (F6).
Non-blocking: `ON DELETE CASCADE` reachable (guard is UPDATE-only) (F7); `failure_class` surfaced
through `pairing_status`, desktop keys on it with a distinct blameless screen (F8); synchronous
double-submit guard (F9); retryable HEIC screen (F10); provenance `sequence` assigned under a
parent-row lock via `append_capture_pairing_event` (F11); auto-supersede fails closed for a
non-default slot (F12); finalize-race returns the accurate reason + audit, orphan self-heals (F13);
`describe_capture` advances issued→paired for "phone connected" (F14); new
`capture-pairing/index_test.ts` covers the endpoint (F15). Backend
`worktree-agent-ac9429c5f676cfd4f` @ `c45b838` (260 `_shared` + 22 handler tests, check/lint
clean); frontend `phase-d2-qr-capture-rebuild` @ `b01d3b0` (230 vitest, tsc/build clean).
**Still not merged, pushed, or deployed; migration still applied to neither Dev nor Prod.** Rework
detail: `QR_MVP_REWORK_2026_08_20.md`. The reworked branches need a fresh independent QA before
merge — prompt: `prompts/CLAUDE_TASK0016_PHASE_D2_QR_CAPTURE_INDEPENDENT_QA_ROUND3_2026_08_20.md`.

D3/D4/D5 status mapped against
existing evidence — see `D3_D4_D5_STATUS.md`. Summary: D3 is method-satisfied (DECISION-0050) but
volume- and reader-time-blocked, neither closeable by an AI agent; D4/D5 are substantially
answered in substance by existing 2026-08-18/19 research even though not packaged in Phase D's
exact artifact format — recommend repackaging over re-running. **D6 (100%-human-reviewed shadow)
remains fully blocked**: zero real students have ever reached any grading engine
([[project_production_zero_real_students]]), and no reviewer capacity has been established for
this specifically — this needs a product/ops decision from the owner, not engineering. (Zero-real-students
finding re-verified 2026-08-18, `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` UPDATE 2026-08-18b.)

See `DECISIONS_AND_BLOCKERS.md` for the concrete list of open blockers and owner decisions this
state implies, and `ARTIFACT_INVENTORY.json` for the full per-artifact classification.
