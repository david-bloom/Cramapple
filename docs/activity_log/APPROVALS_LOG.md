# Approvals Log

This log records approvals, rejections, Done decisions, and risk acceptances.

## Index

Most recent entries (full chronological list follows below):

- APPROVAL-0070 — Deploy Stripe Functions to Production, Tranche 1 Only (`stripe-webhook`, `get-checkout-status`, `send-parent-payment-email`) — DECISION-0094
- APPROVAL-0069 — Apply the Three Stripe Payment-Schema Migrations to Production (TASK-0041 Cutover, Gate C Step D) — DECISION-0094
- APPROVAL-0068 — Replace the Text of Five Published AP Biology Seeds in Production With CED-Vocabulary Versions (`APBIO-MCQ-005`, `018`, `021`, `022`, `023`) and Carry Their Labels Forward — DECISION-0093
- APPROVAL-0067 — Repair One Distractor Rationale on Published AP Biology MCQ `APBIO-MCQ-023` in Production (Choice A) and Carry Its Labels Forward — DECISION-0093
- APPROVAL-0066 — Repair 11 Published AP Calc AB MCQs in Production (Key Letter on `apcalcab-mcq-037`, 10 Distractor-Rationale Repairs) and Carry Their Serving Labels Forward — DECISION-0093
- APPROVAL-0065 — AP Calc AB Unit 1 Batch (136 Items) and Seeded Variants (24 Items) to Production, With AI-Gateway Spend — DECISION-0093
- APPROVAL-0064 — TASK-0056 to Production (Three Migrations) and the `evaluate-attempt` F2 Deploy — DECISION-0089
- APPROVAL-0063 — TASK-0056 in Development (Parity Replay, Reviewer Function, Revoke) and the Lovable Reviewer-Read Edit — DECISION-0089
- APPROVAL-0062 — Production Hotfix: Create `open_hand_scoring_exclusions` Table Only (Dev + Prod) — TASK-0051
- APPROVAL-0061 — Execute TASK-0051 Open Hand Unification in Development — DECISION-0086
- APPROVAL-0060 — Execute TASK-0050 Skill-Dimension Rollout in Development, with AI-Gateway Spend — DECISION-0085
- APPROVAL-0059 — Execute TASK-0041 Purchase Funnel in Development — DECISION-0083
- APPROVAL-0058 — Ship TASK-0039 BYOQ (Phases 1–2: Data Model, Typed Fallback, Phone/QR Capture, Practice Screen) to Production — DECISION-0084
- APPROVAL-0057 — Execute TASK-0046 Subject Onboarding Gate in Ordered Per-Subject Slices
- APPROVAL-0056 — TASK-0042 Cross-Cutting Content-Pipeline QA Remediation and Subject-Scoped Production Writes
- APPROVAL-0055 — Adopt Lean Source-of-Truth Startup Mode (Tier-First Reading, `AGENTS.md`, Log `INDEX_END` Markers) — DECISION-0081
- APPROVAL-0054 — Ratify Three Session-Start Bootstrap Edits (Live Front-Ends, Required First-Read, Anti-Stale Rule) — DECISION-0078
- APPROVAL-0053 — BYOQ Is Identity-Agnostic: `byoq_items.user_id` Not Required; Resolves the DECISION-0070/0068 Conflict
- APPROVAL-0052 — TASK-0039 BYOQ Phase Priority Corrected (Camera-First) and Ownership Confirmed (Claude, Not Codex)
- APPROVAL-0051 — Deploy the AP Statistics Combined Practice Selector (TASK-0044) to Production
- APPROVAL-0050 — BYOQ Data-Model Architecture (Option A) and TASK-0039 Phase 1 Scope
- APPROVAL-0049 — Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (TASK-0038 Phase 4)
- APPROVAL-0048 — Promote `APBIO-HDG-2026-GRAPH-002` to Human-Graded-Pilot-Approved (TASK-0038 Phase 2)
- APPROVAL-0047 — Device-Neutral Cramapple Bootstrap and Shared ChatGPT Project Contract
- APPROVAL-0046 — Confirm QR Handoff as Engine 4's Sole Capture Path; Approve Capture-Failure Handling Split
- APPROVAL-0045 — Retire Engine 4's Dual-Human-Adjudicated Gold Requirement; Adopt the DECISION-0045 Gold Model
- APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)
- APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification
- APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines
- APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment (TASK-0020)
- Older entries: [`APPROVALS_LOG-0001_to_0040.md`](archive/APPROVALS_LOG-0001_to_0040.md)

**Rotation rule:** once this log exceeds ~400 lines, archive the older entries to `docs/activity_log/archive/APPROVALS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries.

<!-- INDEX_END -->

## APPROVAL-0070 — Deploy Stripe Functions to Production, Tranche 1 Only (`stripe-webhook`, `get-checkout-status`, `send-parent-payment-email`) — DECISION-0094

**Date:** 2026-10-02
**Approved By:** David Bloom ("yes", in reply to "Do you approve tranche 1?", 2026-10-02 Claude session)
**Related Task:** `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`
**Related Decision:** `DECISION-0094`; schema precondition `APPROVAL-0069`
**Request:** `docs/product/STRIPE_PRODUCTION_FUNCTION_DEPLOY_APPROVAL_REQUEST_2026_10_02.md`
**Decision:** Approved — **tranche 1 only**

**Approved scope:** deploy `stripe-webhook`, `get-checkout-status` and `send-parent-payment-email` from `main` (`0bfe8511`) to Production (`pcntajvbdfqhbeewmdry`), each with `--no-verify-jwt --use-api`. None of these creates a charge. Verification afterward is read-only and uses invalid-body probes only.

**NOT approved by this entry (tranche 2, still pending, and gated by the checklist prerequisites):** `create-checkout-session`, `create-post-purchase-addon`, `create-parent-payment-link`. Also not approved: any secret change, any Stripe dashboard action, the Lovable publish, the Orly email, the go/no-go.

**Standing condition recorded:** do not publish the Lovable marketing project until tranche 2 is deployed and verified. The live publishable key is already in the project's `.env` (verified 2026-10-02); the live site still shows "Online payment isn't switched on yet."

**Outcome:** _pending — to be filled in after David runs the deploys and the checks are made._

## APPROVAL-0069 — Apply the Three Stripe Payment-Schema Migrations to Production (TASK-0041 Cutover, Gate C Step D) — DECISION-0094

**Date:** 2026-10-02
**Approved By:** David Bloom ("approved", in reply to the request in `docs/product/STRIPE_PRODUCTION_MIGRATIONS_APPROVAL_REQUEST_2026_10_02.md`, 2026-10-02 Claude session)
**Related Task:** `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`
**Related Decision:** `DECISION-0094`
**Decision:** Approved

**Approved scope:** apply to Production (`pcntajvbdfqhbeewmdry`), in order, `20260928134000_task0041_payment_runtime_repair.sql`, `20260928135500_task0041_parent_email_audit.sql` and `20260928191213_task0041_webhook_replay.sql`. File SHA-256s were re-verified against the request immediately before applying.

**How it was used (all three applied 2026-10-02, via `apply_migration`, one transaction each, each checked before the next):**

| File | Ledger version recorded in Production | Result |
|---|---|---|
| `…134000_task0041_payment_runtime_repair` | `20261002001232` | `app.stripe_customers` created, RLS on, service-role policy only; existing tables/policies unchanged (5 session rows intact) |
| `…135500_task0041_parent_email_audit` | `20261002001253` | `app.parent_payment_email_requests` created, RLS on, service-role policy only |
| `…191213_task0041_webhook_replay` | `20261002001308` | replay columns added; **5 existing events backfilled to `processed`** (attempt_count 1); status CHECK present; `app.claim_stripe_webhook_event(text)` executable by `service_role` only |

**Post-apply checks (all passed):** no `anon`/`authenticated` grants on the new tables; function privilege anon/authenticated/public = false, service_role = true; `subject_entitlements` still 253; security advisor reports no new finding for these objects.

**Known drift (not fixed here):** `apply_migration` stamped its own versions (above), which differ from the committed filenames (`TASK-0055`). No files were renamed and no `db push` was run.

**Not authorized by this entry:** any function deploy; any secret; Stripe live-mode work; the Lovable publish or publishable key; the open-hand migration; any `subject_entitlements` change; the go/no-go.

## APPROVAL-0068 — Replace the Text of Five Published AP Biology Seeds in Production With CED-Vocabulary Versions (`APBIO-MCQ-005`, `018`, `021`, `022`, `023`) and Carry Their Labels Forward

**Date:** 2026-10-01  
**Approved By:** David Bloom (2026-10-01 Claude session: "stay within the CED vocab"; "Seed_remediation_preview is approved"; "apply to production, do not run the roll back rehersal". The Product Owner reviewed the old-versus-new text in `SEED_REMEDIATION_PREVIEW.md` and declined the rolled-back rehearsal.)  
**Related Task:** none (content remediation from the AP Biology seeded-variant pilot; see `scripts/content-seed/apbio-seeded-pilot-2026-09-30/PILOT_REPORT.md`, rounds 3 and 4)  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** on Production (`pcntajvbdfqhbeewmdry`), run `scripts/content-seed/reviewer-qa-remediation/20261001_apbio_seed_ced_vocabulary_remediation.sql` for exactly five items: `APBIO-MCQ-005`, `APBIO-MCQ-018`, `APBIO-MCQ-021`, `APBIO-MCQ-022`, `APBIO-MCQ-023`. Owner-remediation pattern (new version, never in place). Stimulus, stem and all four choices and rationales are replaced with the text in the preview; the keyed letter of each item is unchanged (005 C, 018 B, 021 C, 022 A, 023 D) and asserted by the script. Each item's labels (validated serving, provisional coverage) are captured in the transaction, restored to their prior status and re-pointed at the new version with their original validation records, and the approval id recorded in each label payload. Unit and topic are not changed. `021` and `023` are replacement items on the same topic.

**Evidence:** the AP Biology CED V.1 (printed pp. 49-51 and a full-text search) does not name isomers, receptor-mediated endocytosis, clathrin, signal peptide / SRP, 70S/80S ribosomes, binary fission, or integral/peripheral proteins; the Product Owner ruled that items stay within CED vocabulary.

**Not approved by this entry:** any other item; the seeded variants going into Production; changes to topic or unit labels; the `005` variant pair (held); any change to the other published Biology seeds (for example `APBIO-MCQ-018` was included, but `APBIO-MCQ-008` and others were not).

**Waiver recorded:** no rolled-back rehearsal was run, at the Product Owner's direction. The script is one transaction with in-script assertions and aborts without writing if any fail.

**How it was used (2026-10-01):** no rolled-back rehearsal (waived by the Product Owner). The real run committed in one transaction: 5 items repaired, 10 labels restored; all in-script assertions passed. Verified afterwards on Production: `APBIO-MCQ-005` v3, `018` v3, `021` v2, `022` v2, `023` v3 are each the only published version, with 4 choices and exactly one correct, and the keyed letter unchanged (005 C, 018 B, 021 C, 022 A, 023 D); no stem/choice desync. Each item's serving label is `validated` and its coverage label `provisional_model`, both pointing at the new version, hash-fresh, with `approval_ref: APPROVAL-0068` and the original validation record. AP Biology counts are unchanged from before the run (118 published versions, 160 published items, 69 validated serving labels, 6 stale labels that are older and unrelated). 5 review decisions written, 0 duplicate published versions, no `anon`/`authenticated` grant on `is_correct`/`rationale`.

## APPROVAL-0067 — Repair One Distractor Rationale on Published AP Biology MCQ `APBIO-MCQ-023` in Production (Choice A) and Carry Its Labels Forward

**Date:** 2026-10-01  
**Approved By:** David Bloom (2026-10-01 Claude session: "I approve 023 production change", given in answer to the written scope below: a Production repair of `APBIO-MCQ-023` choice A, with a rolled-back test first, then the real run)  
**Related Task:** none (content repair from the AP Biology seeded-variant pilot; see `scripts/content-seed/apbio-seeded-pilot-2026-09-30/S0A_AUDIT_REPORT.md`)  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** on Production (`pcntajvbdfqhbeewmdry`), run `scripts/content-seed/reviewer-qa-remediation/20261001_apbio_mcq_023_choice_a_rationale_repair.sql` for exactly one item, `APBIO-MCQ-023`. Owner-remediation pattern (new version, never in place). Only choice A's rationale text changes; the key (D), all choice texts and all `is_correct` flags are unchanged. The item's two labels (a validated serving label, a provisional coverage label) are restored to their prior status and re-pointed at the new version, with their original validation record, and the approval id recorded in each label's payload.

**Evidence:** both checkers (Gemini 3.5 Flash, DeepSeek V4 Pro) flagged the same rationale; verified by hand: the old text said that not being labeled by impermeant biotin does not distinguish extracellular from cytoplasmic facing for a transmembrane protein, which is false because the reagent labels extracellular-facing domains. The first sentence of that rationale (integral proteins need detergent) was correct and is kept.

**Not approved by this entry:** any other item; the published seed `APBIO-MCQ-018` wording (noted separately); any variant going into Production; changes to the provisional seed topic labels.

**How it was used (2026-10-01):** a rolled-back run on Production came first (all in-script assertions passed; Production was unchanged afterwards: still one version, v1 published, labels unchanged). The real run then committed: `APBIO-MCQ-023` has a new published version 2 (v1 retired); only choice A's rationale differs; the key is still D; all choice texts and `is_correct` flags are unchanged; no stem/choice desync; one published version. Both labels (serving `validated`, coverage `provisional_model`) are back to their prior status, point at v2, are hash-fresh, and carry `approval_ref: APPROVAL-0067`; the serving label keeps its original validation record. AP Biology counts are unchanged (118 published, 43 unit-gated servable, 69 validated labels). The 6 stale Biology labels that remain are older and unrelated (4 FRQ coverage labels, `APBIO-MCQ-041`, `APBIO-MCQ-088`); `023` is not among them. No `anon`/`authenticated` grant on `is_correct`/`rationale`.

## APPROVAL-0066 — Repair 11 Published AP Calc AB MCQs in Production (Key Letter on `apcalcab-mcq-037`, 10 Distractor-Rationale Repairs) and Carry Their Serving Labels Forward

**Date:** 2026-10-01  
**Approved By:** David Bloom (2026-09-30/10-01 Claude session: "Plan approved" for the 037 + TASK-0053 repair plan; "Yes, replace the two unexplained wrong-answer numbers in 031"; "Yes, draft the label carry-forward"; "Yes, do a rolled-back test run on Production"; and, to apply: "for calc, you register my approval in the activity log, put the id in the carry-forward approval and then you run the two scripts")  
**Related Task:** `TASK-0053` (distractor-specific MCQ feedback shows these rationales to students); handoff open items 1 and 2 of `SESSION_CLOSE_2026_09_30_SEEDED_GENERATION.md`  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** on Production (`pcntajvbdfqhbeewmdry`), run `scripts/content-seed/reviewer-qa-remediation/20260930_apcalcab_037_key_and_distractor_rationale_repair.sql` and then `20260930_apcalcab_label_carry_forward.sql` for exactly 11 items: `apcalcab-mcq-005, 007, 008, 016, 026, 030, 031, 037, 038, 080, np2-006`. Owner-remediation pattern (new version per item, never an in-place edit). Keys and `is_correct` flags unchanged. `037`: `canonical_answer_1` A to B (records only; grading reads `is_correct`). Distractor rationales corrected on 10 items. `031`: two distractor values with no derivation (-5.34, -3.81) replaced by 7.62 and -2.04 (approved). Serving labels carried forward: 5 `validated` items keep their original validation record (a human validation carried across a rationale-only change, hereby approved), 6 `provisional_model` items restored; no relabelling.

**Evidence:** `scripts/content-seed/calc-ab-pilot-2026-09-30/PILOT_REPORT.md`, `.../calc-ab-seed-audit-2026-09-30/AUDIT_REPORT.md`; every number independently recomputed; rolled-back run on Production 2026-09-30 (repair + carry-forward together) passed all in-script assertions and left Production unchanged.

**Not approved by this entry:** any other item, subject or unit; the 24 seeded Calc AB variants (to be re-checked against the repaired seeds separately); the unaudited published MCQs; anything touching a class B/C seed.

**How it was used (2026-10-01):** both scripts ran on Production as one transaction (all in-script assertions passed): 11 items got a new published version, 11 serving labels restored and re-pointed (5 `validated` with their original validation record, 6 `provisional_model`). Verified afterwards: one published version per item; `canonical_answer_1` equals the correct choice on all 11 (`037` is now `B`); `is_correct` unchanged; 0 stem/choice desync; 0 stale hashes on the 5 validated labels; no stale Calc AB serving labels; no `anon`/`authenticated` grant on `is_correct`/`rationale`. Calc AB counts unchanged: 279 published, 196 unit-gated servable, 198 validated labels. `030`'s provisional label never had a hash (pre-existing, unchanged). A rolled-back run on 2026-09-30 preceded the real run.

## APPROVAL-0065 — AP Calc AB Unit 1 Batch (136 Items) and Seeded Variants (24 Items) to Production, With AI-Gateway Spend

**Date:** 2026-09-30  
**Approved By:** David Bloom (2026-09-30 Claude session: "Execute all with my permission as product owner"; "I approve promotion to validated"; "I approve putting all of these questions in front of students"; checker picks "Gemini 3.8 Flash + DeepSeek V4 Pro"; "Run it as a blind calibration run")  
**Related Task:** none (content batch; see the handoff)  
**Related Decision:** `DECISION-0093`  
**Decision:** Approved

**Approved scope:** load, owner-approve, label, promote to `validated` and publish 136 AP Calc AB Unit 1 items (34 originals + 102 variants; 8 of them relabelled to Unit 2) and 24 seeded variants on Production (`pcntajvbdfqhbeewmdry`); Vercel AI Gateway spend for the model checks.

**How it was used:**

- All loads were atomic chunks verified by md5 against the source (136 of 136 and 24 of 24 exact; 0 letter/key inconsistencies). Approvals, labels, difficulty, cells and publish ran in transactions with a duplicate-published-version guard.
- After each publish: servable-items census and selftest (no mismatches, capped skips only), 0 stale label hashes, no column grant on `is_correct`/`rationale` for `anon`/`authenticated`. Calc AB moved from 119 to 255 to 279 published items and from 38 to 174 to 198 validated serving labels.
- Gateway spend was logged for the pilot, Unit 3 run, Fable calibration and 24-variant labeling: about $1.03 + $0.47 + $2.73 + $0.99 (checkers, calibration, labels). The Unit 1 run's spend was not logged (the scripts did not record usage); token logging was added afterwards.
- **Not approved by this entry:** any other subject or unit, changing an already-published item, or the repairs of the published seeds (separate tasks).

## APPROVAL-0064 — TASK-0056 to Production, Plus the `evaluate-attempt` F2 Deploy

**Date:** 2026-09-30  
**Approved By:** David Bloom ("You deploy the grading fix"; "Approved, apply the Prod migrations tonight", 2026-09-30 Claude session)  
**Related Task:** `TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md`; `TASK-0051` (F2)  
**Related Decision:** `DECISION-0089`  
**Decision:** Approved

**Approved scope:** apply `20260930120000`, `20260930120100` and `20260930120200` to Production, and
deploy `evaluate-attempt` with the F2 fix (`.maybeSingle()` → `.limit(1)`).

**How it was used:**

- Precondition: David published the Lovable reviewer-read edit (`783f6e04`) before the apply.
- All three migrations applied to Production. `…120100` and `…120200` went in one transaction, so no
  half-applied state was ever live. Each ledger entry is recorded under its file version, and its body
  MD5 matches the committed file and Dev.
- Guard (`scripts/qa/answer_key_exposure_guard.sql`) on Production: **no rows.**
- **`evaluate-attempt` deploy: not done from the cloud session.** The proxy blocks `api.supabase.com`, and
  the MCP deploy would have meant re-typing 24 files (about 340 KB). Handed to David as the repo's usual
  CLI command. Production v68 was confirmed byte-identical to `main` beforehand, so the deploy changes
  only the F2 lines.
- **Deploy done** (David, CLI): Production `evaluate-attempt` v70 was verified byte-identical to `main`
  (24 files) after PR #285 merged.

**Not authorized by this entry:** `get_open_hand_item` / the TASK-0051 Production gate, or Stripe
live-mode work.

## APPROVAL-0063 — TASK-0056 in Development, Plus the Lovable Reviewer-Read Edit

**Date:** 2026-09-30  
**Approved By:** David Bloom ("I approve all three", 2026-09-30 Claude session)  
**Related Task:** `TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md`  
**Related Decision:** `DECISION-0089`  
**Decision:** Approved

**Approved scope (as presented):**

1. Development: replay the committed `public.mcq_choices` fix (Dev never had it), and apply
   `public.get_review_item_version`.
2. Lovable app `56cae479`: the reviewer portal's `getReviewTask` edit.
3. Development: apply the answer-key revoke and confirm the guard is clean.

**How it was used:**

- (1) Replayed as ledger version `20260827010001`, byte-identical to Production's entry (MD5 match).
  Applied `20260930120000`. Tested: assigned reviewer 1 row with explanation, unassigned 0, admin 1,
  `anon` 42501.
- (2) Narrower than presented: `getReviewTask` never used `explanation`, so the edit drops it from the
  select instead of switching to the RPC. One line, Lovable commit `783f6e04`; typechecks. **Not
  published.** This works on Production today and after the revoke, without the new function.
- (3) Applied `20260930120100`. The guard then showed its column revokes were no-ops, because
  `authenticated` holds table-level SELECT. Added and applied `20260930120200` (table SELECT replaced by
  a safe-column grant, the `20260824060000` pattern). Same scope. Guard clean on Dev.

**Not authorized by this entry:** any Production change (migrations, `evaluate-attempt` deploy),
publishing the Lovable edit, or Stripe live-mode work.

## APPROVAL-0062 — Production Hotfix: Create `open_hand_scoring_exclusions` Table Only (Dev + Prod)

**Date:** 2026-09-29  
**Approved By:** David Bloom  
**Related Task:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`, `TASK-0053`  
**Related Decision:** `DECISION-0086`  
**Decision:** Approved (option A of three presented; "Go with A but do Dev and Prod so they stay sync'd")

**Why:** `evaluate-attempt` v67 (the TASK-0053 MCQ-feedback deploy, 2026-09-29 12:26 UTC) was
deployed from a `main` that already carried TASK-0051's scoring-exclusion check. That check selects
from `app.open_hand_scoring_exclusions` before grading and returns HTTP 500
`open_hand_eligibility_check_failed` on any error. Production had no such table, so every graded
submission in Production would have failed. Zero attempts had reached Production since v67, so no
student was affected.

**Approved scope:** migration `20260929130754_open_hand_scoring_exclusions_table_only.sql` — the
table section of `20260929034129` copied verbatim, nothing else — applied to Development (a no-op
there) and Production, with both ledgers recording the same version.

**Not authorized by this entry:** `public.get_open_hand_item` in Production, or any other part of
`20260929034129`. The answer-key RPC stays behind TASK-0051's end-to-end test, independent QA and
Production gate.

## APPROVAL-0061 — Execute TASK-0051 Open Hand Unification in Development

**Date:** 2026-09-29  
**Approved By:** David Bloom  
**Related Task:** `TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`  
**Related Decision:** `DECISION-0086`  
**Decision:** Approved

Approves execution of TASK-0051 in Development/task-branch scope: amending `get_open_hand_item` to
the entitlement-scoped access model with a view-only staff/QA bypass, making
`open_hand_scoring_exclusions.learning_session_id` nullable, repointing the `open-hand-item` edge
function at the RPC, consolidating the two competing branches onto one, Development migrations and
Development function deploys, and the end-to-end Dev verification in the task's checklist.

This approval does **not** authorize: any Production migration or function deploy; wiring the plate
loop to live data for students; or changing the `open-hand-item` response contract (the list-vs-
single-item disclosure question in TASK-0051 item 5) or the exclusion's version-vs-item keying
(item 7) — both are frontend/integrity contract changes needing the Product Owner's confirmation
first.

_Correction, 2026-09-29: an earlier version of this entry also withheld authorization for "a
workaround for the `evaluate-attempt` bundle-size limit." No such limit applies — it belongs to the
Supabase MCP deploy tool, not the platform, and the function has been deployed to Production via the
CLI. That clause is withdrawn; deploying `evaluate-attempt` to Development via the CLI is within this
approval._

_Numbering note: this entry took 0061 because `APPROVAL-0060` was then claimed by the unmerged PR
#259. **#259 merged 2026-09-29**, so 0060 is on `main` and the sequence is correct._

## APPROVAL-0060 — Execute TASK-0050 Skill-Dimension Rollout in Development, with AI-Gateway Spend

**Date:** 2026-09-29  
**Approved By:** David Bloom  
**Related Task:** `TASK-0050-SKILL-DIMENSION-ROLLOUT.md`  
**Related Decision:** `DECISION-0085`  
**Decision:** Approved

Approves execution of TASK-0050 subject by subject in Development/task-branch scope: CED sourcing
into fact packs (Phase 0), topic × skill grid migrations applied to Development (Phase A), and
model-consensus skill labeling of published MCQ and FRQ items (Phase B) — including the Vercel
AI-Gateway spend, per David, 2026-09-29: "create a plan for adding the skill dimension to each
subject. I authorize the vercel gateway cost. Use the CEDs."

This approval does **not** authorize: Production migrations or Production writes of any grid or
label; relaxing `content_item_cells_validation_check` or creating a system/service profile
(`DECISION-0085`'s open item); changing `DECISION-0074`'s mastery rule; or authoring new content
items. Each remains a separate Hard Gate, and Production stays gated per subject on David's explicit
go-ahead for that subject's content.

## APPROVAL-0059 — Execute TASK-0041 Purchase Funnel in Development

**Date:** 2026-09-28  
**Approved By:** David Bloom  
**Related Task:** `TASK-0041-LAUNCH-PAYMENT-FLOW.md`  
**Related Decision:** `DECISION-0083`  
**Decision:** Approved

Approves immediate execution of TASK-0041 in Development/task-branch scope using prices $39.99 single / $69.99 two-subject / $89.99 three-subject. Includes code, Development schema migrations, Development Edge Function deployment, sandbox read-only verification and non-live test-session creation, Lovable code edits without publish, and QA evidence collection.

This approval does **not** authorize Production migrations/deployments, live Stripe writes/configuration, secret changes, enabling live paid sales, Lovable Production publish, or final risk acceptance. Those remain separate Hard Gates.

## APPROVAL-0058 — Ship TASK-0039 BYOQ (Phases 1–2) to Production

**Date:** 2026-09-28
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Related Decision:** `DECISION-0084`
**Decision:** Approved

### Summary

Product Owner direction, 2026-09-28: "Work through all phases unless blocked. The goal is to get task
0039 into production." This authorizes the following Production changes:

- the two BYOQ migrations (`20260928150000_task0039_byoq_core`, `20260928160000_task0039_byoq_hardening`);
- the `byoq` edge function (`verify_jwt=false`, with its own owner-key, JWT, and capability auth);
- two Vault secrets (`byoq_purge_token`, randomly generated server-side; `byoq_function_url`);
- the `learner-uploads` 20 MB object cap;
- publishing the App and Marketing Lovable projects with the BYOQ screens and homepage link.

### Notes

- Phase 3 (worksheet upload) is not covered. It stays blocked on its design doc's open decisions.
- 2026-09-28: David confirmed `DECISION-0084` items 1–2: access is free and open, with a limit of 30 new questions per owner per day and 120 new anonymous users per IP per hour.
- 2026-09-28: David also confirmed item 3 (30-day anonymous retention) and item 7 (stuck-routing deferred).
- 2026-09-28: David approved item 8 as topic-level step-by-step hints: up to four hints from the published point brief, revealed one at a time, never specific to the student's question and never recorded. Published in the App.
- The eight "New gaps" defaults in `DECISION-0084` were chosen by the implementer under this
  direction and are flagged for explicit Product Owner confirmation or revision.
- Independent QA ran before the Production apply: one Fail round, with all four blocking findings
  fixed and re-verified on Development.

## APPROVAL-0057 — Execute TASK-0046 Subject Onboarding Gate in Ordered Per-Subject Slices

**Date:** 2026-09-28
**Approved By:** David Bloom
**Related Task:** `TASK-0046-SUBJECT-ONBOARDING-GATE-FULL-PROGRAM.md`
**Decision:** Approved

### Summary

Authorizes execution of TASK-0046's read-only Production six-criteria verification program after confirming TASK-0042 is Done. Execute the eight non-Day-1 subject slices in this order: AP Chemistry, AP Calculus AB, AP Calculus BC, AP Precalculus, AP Physics 1, AP Physics 2, AP Physics C: Electricity and Magnetism, AP Physics C: Mechanics.

### Notes

- This approval covers read-only Production verification and documentation updates only; it does not authorize Production data writes, migrations, deployments, secrets/configuration changes, payments, or launch.
- Preserve TASK-0046's required one-subject-per-slice branch/PR structure and fresh independent QA before any slice is marked Done.
- TASK-0042 was verified Done on 2026-09-28 from the canonical task record before execution began.


## APPROVAL-0056 — TASK-0042 Cross-Cutting Content-Pipeline QA Remediation and Subject-Scoped Production Writes

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0042-LAUNCH-CONTENT-PIPELINE.md`
**Decision:** Approved

### Summary

Authorizes Codex to implement and verify the content-pipeline QA remediation described in the
Product Owner's 2026-09-27 execution handoff, including necessary subject-scoped Production data
corrections: reconstructing and auditing the original hashes for 216 prior promotions; reverting
stale or unverifiable promotions; applying the five specified Medium-to-Hard corrections; hardening
the runner; and completing safe remaining single-unit label writes.

This is a Product Owner exception to TASK-0042's one-branch-per-subject rule for the cross-cutting
remediation. Production changes remain durable, subject-identifiable migrations with exact counts.

### Limits

- Does not weaken `DECISION-0066`: multi-unit labels still require genuine independent third review.
- Does not authorize invented quantity targets or attainment ratios.
- Does not authorize replaying applied migrations, exposing secrets, or leaving the CLI Production-linked.
- Final acceptance requires fresh independent QA by an agent that did not author the fixes.

### Closeout addendum — 2026-09-27

David explicitly approved transmitting 141 current question packets—including stems, answers, and
rubrics—to Vercel AI Gateway using `anthropic/claude-haiku-4-5` for DECISION-0066's blind third
review. The review completed with 27 exact full-label confirmations, 66 disagreements, 48 rubric or
scope holds, and zero call errors. Migration
`20260927184534_task0042_promote_blind_third_review_confirmations` promoted only the 27 exact
matches. David also decided that the nine non-Biology subjects have no fixed quantity targets; see
`DECISION-0082`.

### ID reconciliation

This authorization was initially recorded in the task branch as `APPROVAL-0051`. When current
`main` was merged, that ID was already occupied by TASK-0044, so this record was renumbered to the
next free ID, `APPROVAL-0056`. Migration
`20260927181002_correct_task0042_approval_note_provenance` updated the 152 affected Production
validation-decision notes; it did not alter labels or promotion outcomes.

## APPROVAL-0055 — Adopt Lean Source-of-Truth Startup Mode (Tier-First Reading, `AGENTS.md`, Log `INDEX_END` Markers)

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Docs:** `prompts/CODEX_NEW_SESSION_PROMPT.md`, `prompts/CLAUDE_NEW_SESSION_PROMPT.md`, `AGENTS.md` (new)
**Related Decision:** `DECISION-0081`
**Decision:** Approved

David reviewed the Codex-authored startup-cost analysis and Claude's revised protocol draft directly
in-session, requested six tightening edits (tier-classification pointed at `AGENT_OPERATING_MODEL.md`
rather than redefined inline; softened "follow Session-Start Procedure" wording; constrained `SYNC`
to the same index-marker/exact-ID discipline; a narrow branch-hygiene read rule; non-eager skill
loading; an explicit `AGENTS.md`/`INDEX_END` precondition note), and approved shipping once applied.
Applied to both `CODEX_NEW_SESSION_PROMPT.md` and `CLAUDE_NEW_SESSION_PROMPT.md`. See `DECISION-0081`
for full rationale and scope.

## APPROVAL-0054 — Ratify Three Session-Start Bootstrap Edits (Live Front-Ends, Required First-Read, Anti-Stale Rule)

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Doc:** `docs/team_charter/CRAMAPPLE_SESSION_START.md` (governed bootstrap)
**Related Decision:** `DECISION-0078`
**Decision:** Approved

David ratified the three session-start bootstrap edits merged in PR #232 (live Lovable front-ends in the
Repository Map; required first-read of `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` + `docs/INDEX.md`
for architecture/design/front-end/session-mode/launch work; the anti-stale rule). They change routing and
guidance, not authority order or hard gates. In-doc "pending ratification" flags flipped to ratified. See
`DECISION-0078` for full text.

## APPROVAL-0053 — BYOQ Is Identity-Agnostic: `byoq_items.user_id` Not Required; Resolves the DECISION-0070/0068 Conflict

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Related Decision:** `DECISION-0077`
**Decision:** Approved

David resolved the DECISION-0070 (ungated/anonymous BYOQ) vs. DECISION-0068 (authenticated `user_id`-keyed
schema) conflict directly, 2026-09-27: BYOQ is identity-agnostic — `byoq_items.user_id` is nullable
(recognition, not a gate), BYOQ runs anonymously on the marketing page and recognized in the app with
identical behavior, and the anonymous scoping mechanism is build work under TASK-0039. Amends the
Option A schema approved under `APPROVAL-0050`/`DECISION-0068`; the parallel-tables architecture is
unchanged. See `DECISION-0077` for full text.

## APPROVAL-0052 — TASK-0039 BYOQ Phase Priority Corrected (Camera-First) and Ownership Confirmed (Claude, Not Codex)

**Date:** 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`
**Decision:** Approved

### Summary

Approves `DECISION-0076`: corrects `TASK-0039`'s phase priority so camera/phone capture (originally
labeled "Phase 2") is the primary, launch-required BYOQ intake method, with typed/pasted intake
("Phase 1") shipping as a fallback rather than the first-shipped path. Confirms BYOQ implementation
ownership as Claude, superseding an earlier direction that had it as Codex's workstream (Codex is
instead working on the content pipeline). Does not reopen `DECISION-0068`/`APPROVAL-0050`'s
architecture/schema approval.

### Notes

- Found and reported, not yet resolved: `DECISION-0070` (2026-09-26) states BYOQ ships "ungated, as an
  anonymous session" — structurally in tension with the approved owner-scoped RLS schema, which assumes
  an authenticated `user_id`. This approval does not cover that question; it remains open.

## APPROVAL-0051 — Deploy the AP Statistics Combined Practice Selector (TASK-0044) to Production

**Date:** 2026-09-26 (approval); Production deploy actually reached via PR #227, 2026-09-27
**Approved By:** David Bloom
**Related Task:** `TASK-0044-LAUNCH-SUBJECT-ONBOARDING-GATE.md` (found the gap)
**Decision:** Approved

### Summary

Approves building and deploying to Production a fix for a gap TASK-0044 found: AP Statistics had
101/101 published MCQ items content-ready but zero servable through any backend RPC on the
flat/`targeted_drill` practice path, because `select_practice_frqs` is FRQ-only by design and the only
existing combined FRQ+MCQ selector (`select_biology_practice_items`) is Biology-only by design. Approves
the deploy itself: a new, additive `app.select_ordinary_combined_practice_items` Postgres function
(Biology's own selector is untouched) plus the corresponding `student-session-items` edge-function
routing change.

### CORRECTION, 2026-09-27: which branch actually fulfilled this approval

The branch this approval was originally requested for (`claude/task-0047-ap-statistics-mcq-serving`)
built only a `targeted_drill`-only routing, and its migration/edge-function version were applied to
Cramapple Development only — **never to Production**, despite this entry's original text. The branch
that actually shipped this approval's intent to Production, via `main` PR #227 on 2026-09-27, is
`codex/task-0044-statistics-mcq` — a superset that routes both `mcq` (the real Home session format) and
`targeted_drill` to the same new RPC. Independently verified byte-for-byte identical (function body,
comment, deployed edge-function source) to what Production was already running before the PR formally
landed it in `main`'s git history, so this approval's substance — approving this class of fix for this
diagnosed gap — was correctly fulfilled, just not by the branch originally named.

### Evidence

- Focused handler suite passing on the shipped branch, including Statistics Home `mcq` routing,
  Statistics `targeted_drill` routing, answer-field redaction, and missing-choice fail-closed behavior.
- Applied to Cramapple Development and called live against Dev's real AP Statistics content: correct
  MCQ-only results in `mcq` mode.
- Live post-merge verification against Production: `app.select_ordinary_combined_practice_items`
  returns 7 FRQ + 13 MCQ for AP Statistics, matching the pre-deploy dry-run projection exactly;
  `app.select_biology_practice_items` re-verified unchanged at 12 FRQ + 8 MCQ — confirms AP Biology's
  serving path was not affected.

### Notes

- Does **not** close TASK-0044 — a fresh, independent QA pass and Main Conductor integration are still
  required before it is marked `Done`.
- Does **not** substitute for actually verifying the live, student-facing AP Statistics MCQ experience
  end-to-end (`LAUNCH_RUNBOOK_2026_10_02.md` item 4) — this approval covers the backend serving path
  only.

## APPROVAL-0050 — BYOQ Data-Model Architecture (Option A) and TASK-0039 Phase 1 Scope

**Date:** 2026-09-26
**Approved By:** David Bloom
**Related Task:** `TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`, Phase 1
**Decision:** Approved

### Summary

Approves `DECISION-0068`: BYOQ (bring-your-own-question) gets its own parallel data model
(`app.byoq_items`/`app.byoq_responses`, and later `app.byoq_capture_pairing_tokens`/
`app.byoq_attachments`) rather than generalizing the live `app.attempts`/`app.response_versions`/
`app.response_attachments`/`app.capture_pairing_tokens` tables, after an adversarial review found the
generalize-in-place option would leave a real path for a BYOQ item to reach the human-grading queue.
Authorizes starting `TASK-0039` Phase 1: the `byoq_items`/`byoq_responses` schema, a separate BYOQ
Practice screen sharing components with (never branching inside) the live graded Practice screens,
and the Home entry point.

### Notes

- Does **not** authorize Phase 2 (QR photo capture) or Phase 3 (worksheet parsing) — both remain
  gated on their own open items (`TASK-0039`'s Pre-flight verification step for Phase 2; the Open
  Decisions in `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md` for Phase 3).
- Does **not** resolve `TASK-0039`'s "New gaps" list (entitlement/trial gating, rate limits/quotas,
  retention/deletion, consent copy, the private-until-promoted boundary, subject/taxonomy scoping,
  stuck-BYOQ routing, the hints/deep-dive floor) — these still need an explicit Product Owner call
  before Phase 1 ships to real students, separate from this schema/scope approval.

## APPROVAL-0049 — Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (TASK-0038 Phase 4)

**Date:** 2026-09-23
**Approved By:** David Bloom
**Related Task:** `TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`, Phase 4
**Decision:** Approved

### Summary

Approves `DECISION-0059`: a pilot-scale operational commitment for manual
hand-drawn grading, scoped to one item (`APBIO-HDG-2026-GRAPH-002`) and one
grader (David Bloom). Sets a 24-hour grading SLA with at least daily queue
checks; adopts a manual, logged-correction interim stance for disputes
(no regrade tooling exists yet); accepts that manually-graded students
receive a score but no repair prompt (`highestValueGap` stays null); and
adopts a two-stage rollout -- Stage 1 (admin-gated, one real end-to-end run
by David) before Stage 2 (a small named group, never the general Biology
population), with no further widening without revisiting this decision.

### Notes

- Does **not** close TASK-0020 Program C's Hard Gate -- that still needs the
  full multi-owner design (Learning Quality, Operations, Privacy/Security)
  for any broader launch. This approval covers only the one-item, one-grader
  pilot scope named in `DECISION-0059`.
- Does not authorize lifting `/session-hand-drawn-pilot`'s admin gate by
  itself -- Stage 1's real end-to-end run must happen and be reported first.

## APPROVAL-0048 — Promote `APBIO-HDG-2026-GRAPH-002` to Human-Graded-Pilot-Approved (TASK-0038 Phase 2)

**Date:** 2026-09-23
**Approved By:** David Bloom
**Related Task:** `TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`, Phase 2
**Decision:** Approved

### Summary

Approves `DECISION-0058`'s operational definition of "approved" for hand-drawn
`label_status` (human-graded-pilot-ready; explicitly not AI-grading-ready, not
rights-cleared) and names `APBIO-HDG-2026-GRAPH-002` (`content_item_version_id
1c29347d-0f41-4f09-96a7-6f863be82eaf`) as the item promoted under it, after
reviewing its real `content_review_decisions` trail (one flagged concern, fixed and
re-approved 2026-08-08) rather than the `review_status` label alone. Authorizes
updating `prompt_json.label_status` on this item from `ai_provisional_unapproved` to
`human_graded_pilot_approved` in Production.

### Notes

- This approval covers this one item only; it does not blanket-approve the other 23
  reviewed-but-`ai_provisional_unapproved` hand-drawn items, and does not authorize
  Phase 3 (real `/session` frontend wiring) or Phase 4 (a real human-grading queue)
  — each remains its own go-ahead per TASK-0038's Hard-Gate tier.
- Does not certify automated grading readiness (DR-1 remains failed, unchanged) or
  content rights/authorship (`rights_status` remains
  `independently_authored_synthetic_research_seed_unverified`).

## APPROVAL-0047 — Device-Neutral Cramapple Bootstrap and Shared ChatGPT Project Contract

**Date:** 2026-09-22
**Approved By:** David Bloom
**Related Task:** Cramapple mobile/desktop context parity
**Decision:** Approved

### Summary

Approves DECISION-0054 and the narrowly scoped governance changes that make the existing
Cramapple ChatGPT Project use one current GitHub bootstrap across desktop, iPhone, ChatGPT Work,
Codex, and Claude. Approval covers the new session-start and Project-instructions documents,
their startup-prompt/README links, and the associated governance records.

### Notes

- Keep the existing Cramapple Project on Default memory while ChatGPT Work is part of the workflow.
- Do not create a separate mobile Cramapple Project.
- GitHub remains authoritative; Project memory and prior chats provide continuity but do not replace current repository or live-service verification.
- This approval does not authorize a Production deployment, migration, secret change, payment action, or other live-system mutation.

## APPROVAL-0046 — Confirm QR Handoff as Engine 4's Sole Capture Path; Approve Capture-Failure Handling Split

**Date:** 2026-08-19
**Approved By:** David Bloom
**Related Task:** TASK-0016 Phase D, TASK-0025
**Decision:** Approved

### Summary

Approves `DECISION-0051`: reaffirms QR handoff (System A) as Engine 4's sole capture path with no
direct-upload fallback, resolving the System A/System B ambiguity in favor of TASK-0016's original
decision #10. System B's `SameDeviceCapture` frontend stays superseded/pilot-only; its
`attach_capture`/`app.response_attachments` backend is approved for reuse as System A's storage
layer. Also approves the capture-failure handling split: generic retake guidance on image-quality
failures, bug-logged on technical failures.

### Notes

- Does not itself authorize any Production deployment or migration — Stage D2 implementation
  still follows this program's normal deploy discipline (diff-before-deploy, Dev-before-Prod).
- Does not resolve the pre-existing `capture_quality_state`/`capture_retake_reason` frontend/
  backend contract mismatch — separate follow-up.

## APPROVAL-0045 — Retire Engine 4's Dual-Human-Adjudicated Gold Requirement; Adopt the DECISION-0045 Gold Model

**Date:** 2026-08-19
**Approved By:** David Bloom
**Related Task:** TASK-0016 Phase D, TASK-0011
**Decision:** Approved

### Summary

Approves `DECISION-0050`: retires the ≥300-response, ≥40-per-archetype dual-human-adjudicated
gold-set requirement as a hard gate specifically for Engine 4 (spatial/hand-drawn grading), and
un-defers `DECISION-0045`'s Set C — Engine 4 gold-set construction now follows the same
AI-generation + two-independent-non-OpenAI-model-verification + reader-certification protocol
already governing every other engine, with the same independence constraints.

### Notes

- Does not waive corpus-readiness requirements (consent/provenance manifest, deduplication,
  metadata stripping) the existing photo corpus still needs per its own 2026-08-03 readiness
  audit.
- Does not retroactively certify the existing 200-photo real-Biology corpus's single-pass-AI gold
  as meeting the new standard — a `DECISION-0045`-protocol pass still needs to actually run
  against it before it's launch-qualifying evidence.
- Surfaced and requested during Stage D0 execution of TASK-0016 Phase D
  (`docs/research/grading_phase_d_spatial_2026_07_27/`), which had identified the old requirement
  as Engine 4's largest concrete blocker.

## APPROVAL-0044 — Replace Free Score Check with 7-Day Trial; Enable GRADING_ENTITLEMENTS_ENABLED (TASK-0026)

**Date:** 2026-08-15
**Approved By:** David Bloom
**Related Task:** TASK-0026
**Decision:** Approved

### Summary

Approves `DECISION-0047`: replaces the never-launched activation-limited
Free Score Check with a 7-day full-catalog trial, and authorizes enabling
`GRADING_ENTITLEMENTS_ENABLED=true` in Production as part of that change.

### Notes

- Resolves the gap `APPROVAL-0043`'s notes identified: that flag stayed
  `false` specifically because "no path for a new, unprovisioned student to
  get entitled" existed. `app.start_trial` is that path -- verified via
  direct RPC test against a real production attempt (both a pre-existing
  `beta` account, confirming no regression, and a freshly granted trial
  row, confirming the new path works) before flipping the flag.
- The flip was sequenced deliberately: migration + Edge Function deployed
  first, smoke-tested, then the flag set as a discrete, reversible secrets
  change -- not bundled with any other production change, given the
  documented history of an outage from flipping a related flag blind.
- FSC entitlement machinery (table, RPCs, Edge Function) was dropped from
  Production and Dev only after the trial path was verified working, so
  there was no window where neither model granted access.
- Does not itself approve the Loops lifecycle-email vendor choice or the
  day-2/day-7 PostHog scheduled-job gap -- those are tracked separately in
  TASK-0026, not launch-blocking.

## APPROVAL-0043 — Retire the ≤1000ms p50 Grading Latency Gate; Approve Engine 1/3 Go-Live Ahead of Full Gold-Set Certification

**Date:** 2026-08-14
**Approved By:** David Bloom
**Related Task:** TASK-0016
**Decision:** Approved

### Summary

Approves `DECISION-0046`: retires the ≤1000ms end-to-end p50 grading-latency
hard gate (originally set under `APPROVAL-0033`, 2026-07-08) in favor of a
two-SLA framing (time-to-acknowledgement / time-to-complete-feedback), and
authorizes Engine 1 (once its evidence-grounding P0 fix ships) and Engine 3
(shadow-only) to go live in Production ahead of the full 300+
dual-adjudicated gold-set certification originally required as a launch
gate. Full rationale and evidence in `DECISION-0046`.

### Notes

- Does not reopen the Quality > Speed > Cost priority order (2026-07-29
  owner decision) — the numeric latency target is what changed, not the
  ordering.
- The gold-set certification program continues in parallel as a dependency
  for later production-authority stages (per TASK-0016's 2026-08-13
  addendum, the five-stage model: offline → shadow → beta-audited →
  sampled-audit → broad), not waived outright.
- `GRADING_ENTITLEMENTS_ENABLED` (whether to gate grading behind
  entitlements at initial go-live) is explicitly **not** covered by this
  approval. **Resolved 2026-08-14, separately from this approval: stays
  `false`.** Investigation found `app.authorize_grading_access` requires an
  entitlement-granting path (`subject_entitlements` or `free_score_checks`).
  **Corrected 2026-08-14 (QA-caught, codex):** the original note here said
  this path "doesn't yet exist for any real student" — inaccurate;
  `subject_entitlements` has 71 active rows across 8 `student`-role
  accounts (all internal/family/test, none an unrelated real customer). The
  operative point stands — no path for a *new, unprovisioned* student to
  get entitled — but turning the flag on would not "block all grading,"
  it would leave the 8 already-provisioned accounts working. See TASK-0016
  addendum item 4 for the full correction.
- This approval covers the launch-bar scope change only. Each actual
  Production deploy/migration under this work still follows its own
  deploy discipline (diff-before-deploy, create→run→cleanup for any live
  test data) as already practiced in this program.

## APPROVAL-0042 — Lock TASK-0020 Launch Slice and Assessment Baselines

**Date:** 2026-08-03
**Approved By:** David Bloom
**Related Task:** TASK-0020
**Decision:** Approved with Notes

### Summary

Lock the deep assessment to all 48 published AP Statistics targeted-drill FRQs plus all 41 published AP Biology FRQs. Do not narrow the 89-item assessment scope to manufacture a readiness verdict.

### Notes

- Essential question visuals fail closed and may be replaced only with an already approved construct-equivalent item or representation.
- Manual review is the launch baseline for hand-drawn responses; automation remains shadow-only until its independent grading and repair evidence bars pass.
- Every officially supported answering-device class must have a viable paper-photo capture route; use QR/cross-device handoff where the answering device cannot satisfy that requirement.
- Any later item/archetype removal from launch scope requires a separate Product Owner and Learning Quality decision.
- Construct-sensitive classification and accessible-equivalence judgments still require Learning Quality validation before final launch verdicts.

## APPROVAL-0041 — Execute Image and Drawn-Response Launch-Gating Assessment

**Date:** 2026-08-03
**Approved By:** David Bloom
**Related Task:** TASK-0020
**Decision:** Approved with Notes

### Summary

Execute the read-only assessment in `IMAGE_AND_DRAWN_RESPONSE_LAUNCH_GATING_ASSESSMENT_PLAN_V5_2026_08_03.md`. Determine the launch blockers, safe named scope, and reliable implementation paths for required prompt visuals and hand-drawn response capture, preservation, review, grading, and repair.

### Notes

- Approval covers read-only repository, Production, deployment, storage-metadata, and browser/API assessment; reproducible inventory; launch verdicts; and proportional next-approval remediation handoffs.
- The cheap cross-course scan may begin immediately. Deep Step 2 requires the Product Owner-selected launch slice and the Product Owner/Learning Quality-approved minimum viable content volume.
- No schema, API, frontend, deployment, configuration, storage-object, learner-data, or Production mutation is approved.
- No real learner/minor image access, new vendor/model selection, operational manual-review setup, automated learner-facing grading, risk acceptance, or launch is approved.
- The quarantined branch `codex/image-workflows-design-sketch` at `a34a078` remains inert and must not be merged or used as baseline architecture.
- Final QA requires a genuinely fresh independent context before the task reaches an owner decision.

## Approval Format

```markdown
## APPROVAL-0000 — Approval Title

**Date:** YYYY-MM-DD
**Approved By:** David Bloom / [Delegated Domain Approver name]
**Related Task:** TASK-0000 / N/A
**Decision:** Approved / Rejected / Approved with Notes / Done / Not Done / Do Not Do / Approved (Batch) / Approved (Domain)
**Decided By:** (required when Decision is Approved (Domain) — names the domain approver)
**Applies To:** (required when Decision is Approved (Batch) or Approved (Domain) — agents/roles/tasks the approval covers)
**Expires / Review Trigger:** (required when Decision is Approved (Batch) or Approved (Domain); end-of-day inclusive, America/New_York, or a named condition)
**Status:** Active / Expired / Superseded (required when Decision is Approved (Batch) or Approved (Domain))

### Summary

What was approved or rejected?

### Notes

-
```

**Conflict rule:** if `Expires` has passed but `Status` still reads `Active`, the approval is treated as expired regardless of the recorded status — the date wins. `Status: Superseded` overrides date-based validity even before expiration.
