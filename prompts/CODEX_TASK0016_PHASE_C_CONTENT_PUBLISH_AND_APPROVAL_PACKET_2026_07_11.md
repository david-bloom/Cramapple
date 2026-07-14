# Codex Execution Prompt — TASK-0016 Phase C: Publish-Ready Content + Single-Reviewer Approval Packet

**Status:** cleared to execute as a **content-staging + tooling pass**. This
prepares real content for David (Product Owner) to review and approve
directly — it does **not** flip anything to `published` itself, and it does
**not** perform the two-Grading-Validator blind-scoring + Lead-adjudicator
process from `CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.1. That process is
explicitly superseded for this corpus by Product Owner decision (2026-07-11):
**David reviews and approves directly, replacing the dual-blind-scoring gate.**
This does not change any other content's governance — it applies to this
calibration corpus only, by explicit owner call, not a standing policy change.

## Why this supersedes the prior framing

An earlier version of this handoff scoped Phase C's remaining work as a
measurement-only dry run that avoided touching real content, on the theory
that the human-adjudication bottleneck (two blind scorers + a Lead adjudicator)
was a hard blocker. The Product Owner corrected that: the actual move is to
**create the content we need and get it approved**, not wait on the full
formal adjudication process. Concretely, that means:

1. Get the already-built 100 MCQ + 100 FRQ candidate corpus into
   publish-ready shape against the real content schema.
2. Package it as a **fast single-reviewer approval packet** — not 320
   individual criterion-level blind-scoring rows, but a skimmable review
   surface that puts the highest-risk items first so David can approve in one
   pass.
3. Stage the actual publish (via the real `admin-content` bulk-import path),
   but **do not execute the publish step** — leave it ready to run the moment
   approval comes back, as a separate, explicit, reversible action.

## Read first (do not skip)

1. `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` — the launch bar this
   corpus is aimed at: 100 MCQ + 100 FRQ + 10 Investigative-Task, ≥95%
   criterion-level agreement, cost ≤$0.01/item, latency p50≤1000ms.
2. `docs/research/ap_statistics_gold_set_candidate_2026_07_09/` — the 100-item
   FRQ candidate package: `provisional_labels.json` (criterion-level AI labels
   + evidence quotes), `manifest.json`, `README.md`. This is your primary FRQ
   content + label source.
3. `docs/research/ap_statistics_mcq_launch_bank_2026_07_09/
   ap_statistics_mcq_launch_bank_2026_07_09.json` — the 100-item MCQ bank.
4. `prompts/CODEX_TASK0016_PHASE_C_REMEDIATION_2026_07_09.md` — the one
   confirmed content defect from independent QA (`APSTAT-MOD6-H007`'s
   mislabeled confidence-level criterion) and the deterministic-key-coverage
   gap (R2). **Check whether R1's fix and R3's schema restoration actually
   landed in the current `provisional_labels.json`** before building the
   approval packet — if either is still stale, that item goes in the
   packet's high-risk section, not the routine section.
5. `docs/research/AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md` —
   binding boundary-contract resolutions (z*/t* tolerance, sign-sensitivity
   scoping, MOD8-pattern method-only scoping). Cite these, don't re-litigate.
6. `supabase/functions/admin-content/index.ts` — **the real production
   content-authoring path.** Read the `bulk_import`, `create_draft`,
   `update_draft`, and `publish` operations (`AllowedOperation` type near the
   top, `normalizePublishedState()`, the `CompatibilityProjection` shape) and
   use this exact schema for your staged output — do not invent a new import
   format or write raw SQL against `content_items`/`content_item_versions`
   directly. `CompatibilityProjection` (content_key, item_type, frq_form,
   title, stem, stimulus, prompt_json, explanation, help_text, content_labels,
   mcq_choices[], frq_criteria[]) is what `bulk_import` consumes per item —
   confirm this by reading the function body around line 900+, don't guess
   from the type alone.
7. `supabase/functions/_shared/grading-router.ts` — confirm what `rubric_type`
   / `evaluator_strategy` values each item needs so it dispatches correctly
   once published (`mcq` → `rule_based_mcq`, `discrete_text` →
   `llm_discrete_text` for the FRQ items in this corpus — these are text FRQ
   items, not `structured_formula`, unless an item's key set says otherwise).
8. `docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json` +
   `AP_STATISTICS_VERIFICATION_PROFILE.json` — cross-reference which of the
   100 FRQ items already have deterministic keys, so the approval packet can
   flag "this item's numeric criteria are deterministically checkable" as a
   confidence signal (a keyed + validated item is lower-risk to approve than
   one resting entirely on AI-provisional judgment).

## Goal

Three deliverables, in this order (each gates the next):

### D1 — Independent re-verification pass (fast, not exhaustive)

Before packaging anything for approval, spend a bounded pass re-deriving the
numeric/factual claims in the FRQ corpus the same way the R1 finding was
caught (independent recomputation, not just trusting the stored label) —
prioritize:
- Every item with a keyed deterministic target (cheapest to check: run
  `validate_keys.py` / the shared TS verifier functions and confirm they still
  pass).
- Every item flagged in the existing `adjudication_queue.csv` (30 items) —
  these were already self-identified as boundary/ambiguous cases.
- A random sample of ~15-20 of the remaining unflagged items, to catch defects
  the AI labeler wouldn't have flagged on itself (the MOD6-H007 shape:
  high-confidence, unflagged, wrong).

Log every finding (content_key, criterion, what you checked, verdict) in a
`verification_log.md` — this is what lets David trust a fast approval pass
instead of needing to independently check 100 items himself.

### D2 — Publish-ready staged import

1. Transform the 100 MCQ items + 100 FRQ items (stem, stimulus, rubric
   criteria, canonical answers, choices) into the exact `bulk_import` payload
   shape from `admin-content/index.ts`, targeting the existing AP Statistics
   `exam_pack_version_id` already used by the 18+18 live smoke batch (look it
   up, don't hardcode a guess).
2. Set `rubric_type`/`evaluator_strategy` per item per read-first item 7.
3. Output this as a runnable staged script/payload file (e.g.
   `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
   bulk_import_payload.json` + a short `README.md` on how to invoke it against
   `admin-content` with `operation: "bulk_import"`) — land items as `draft`
   status via bulk_import, **do not call `publish`**. Drafts are inert (not
   graded, not learner-visible) until a separate publish step, so staging as
   draft is safe to do without further approval; flipping to `published` is
   the action that needs David's sign-off.
4. Confirm no `content_key` collisions with the 76 items already published
   (the 18 MCQ + 18 FRQ smoke batch + whatever else is live) — dedupe or
   rename before staging, don't silently overwrite.

### D3 — Single-reviewer approval packet

Produce `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/
approval_packet.md`, organized for one person to approve in one sitting, not
320 line-by-line criterion rows:

1. **Top section — everything that needs a decision**, ranked by risk:
   - Any D1 finding that changed a label or surfaced a defect.
   - The pre-existing 30-item adjudication queue, condensed to one line each
     (content_key, the specific ambiguity, your recommended resolution).
   - Anything still stale from the R1/R3 remediation check (read-first item
     4).
2. **Middle section — coverage summary**: module/difficulty distribution
   tables (already exist in the source READMEs, just carry them forward),
   deterministic-key coverage count, and the D1 sample-check pass rate.
3. **Bottom section — one-line approve/reject checklist**: a single checkbox
   per logical unit (e.g. "MCQ bank (100 items)", "FRQ items modules 1-3",
   ... not 100+ individual item checkboxes) so David can approve in bulk
   where nothing flagged a concern, and only needs to look closely at the top
   section's flagged items.
4. State explicitly at the top of the file: **this packet, once approved,
   authorizes running the staged `publish` operation from D2 — nothing
   publishes automatically.**

## Explicitly out of scope — do not attempt

- Calling the `publish` operation yourself, on any item, under any condition —
  that is the action David's approval unlocks, not something this prompt
  executes.
- Measuring LLM-grader (`llm_text` route) agreement, cost, or latency against
  the published content — that's real follow-on work once content is live,
  not part of this staging pass.
- Re-litigating the resolved boundary-contract decisions or the R1-R4
  remediation items — cite them; only raise something new if D1's independent
  re-verification finds a *distinct* defect.
- Any hand-drawn/image/QR-capture content (a different track).
- Touching Development's or Production's edge functions, migrations, or
  secrets.
- Publishing to Development — this corpus is a Production launch-gate
  artifact; stage it against Production's schema/IDs only, unless you find
  evidence the calibration run is meant to happen in Development instead
  (check `docs/architecture/` for the current environment-split guidance
  before assuming).

## Required Evidence on Completion

- `verification_log.md` (D1) — every check performed, verdict, and whether it
  changed anything from the AI-provisional label.
- `bulk_import_payload.json` + README (D2) — the exact staged payload, the
  `exam_pack_version_id` it targets, confirmation of zero `content_key`
  collisions with live content, and the invocation instructions (not run).
- `approval_packet.md` (D3) — matching the three-section shape above, with an
  explicit statement that publish is a separate, not-yet-executed step.
- A short top-level summary: item counts staged, findings count, and the
  single sentence David needs to read to know what he's approving.

## Do Not Touch

- The `publish` operation itself — draft-only staging, no live status flips.
- Production/Development edge functions, migrations, secrets, or deploy
  config.
- The resolved boundary-contract decisions or R1-R4 remediation items
  (apply/cite, don't reopen).
- Any content already `published` (the 76 live AP Statistics items) — this is
  additive staging, not a rewrite of what's already live.

## Next Expected Output

A PR against `main`, branch-prefixed `codex/...`, referencing `TASK-0016`
Phase C, containing `verification_log.md`, `bulk_import_payload.json` +
README, and `approval_packet.md`. Ready for David to read the approval packet
directly and either approve (triggering a separate, explicit publish step) or
flag specific items back for another pass — no dual-blind-scoring round
required.
