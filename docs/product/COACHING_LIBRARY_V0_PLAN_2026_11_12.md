# Coaching Library v0: Build Plan (layers 1, 3, 5)

Status: DRAFT, independently assessed and revised 2026-11-12. Original author: Claude (Sonnet 5.5) for David Bloom. Owner approval covers the layer selection only; the workflow, thresholds, spend and release path below remain proposals. No Production change is proposed.
Parent plan: `docs/product/COACHING_ARC_PLAN_DRAFT_2026_11_11.md` (read its "Coaching voice rules", "Judging recipe" and "Coaching library v0" sections first).
Prototype evidence: `scripts/content-seed/coaching-prototype-2026-11-11/` (`RESULTS.md`, `out3pass/PASS3_READ.md`, `HUMAN_READ_PACKET.md`).

## 1. Purpose

Cramapple wants model-authored coaching on the feedback card that reads like a teacher: it names what the question required, what the student did or did not do against it, why that piece is required, and what to do next. The organizing principle (David, 2026-11-12): *we are showing students how to earn points.* FRQ coaching ties to the question's parts and rubric criteria. MCQ coaching ties the selected distractor's error or gap to why the one available point was missed; it must not invent an MCQ rubric or partial-credit criterion.

Prototype passes 1 to 3 showed models can do this, but three things limit trust: (a) texts sometimes assert facts not in the item's own authored material, (b) the voice rules live only in a prompt and a human's memory, and (c) there is nothing approved for the model or the judges to check against. The proposed library makes those constraints reviewable and testable; it cannot by itself prevent unsupported runtime claims or repair a wrong authored answer key. v0 covers three of nine candidate layers.

## 2. Scope

In scope for v0:

| Layer | What it is | Subjects | Production touch |
|---|---|---|---|
| 1. Requirement meanings | What each command word / task verb requires, what a bare answer lacks, and the reason for each requirement | AP Biology, AP Statistics | none |
| 3. Distractor error labels | A short structured label of the error or gap each wrong MCQ choice represents, anchored to the authored rationale | AP Biology, AP Statistics (published, non-retired items) | none |
| 5. Approved example texts | Human-approved coaching texts by case, used as style and structure exemplars and as judge references | MCQ and FRQ, both subjects | none |

Plus the two support layers that were agreed as needed from the start: **8 provenance/versions** and **9 gaps register**, and the **explainer citability audit** (informs an owner decision on whether layer 6 should join v0).

Out of scope: layers 2, 4, 6, 7 (deferred); Production DB tables; edge functions; `evaluate-attempt`; the feedback card; cross-session personalization; other subjects; any student data (synthetic inputs only, as in the prototype).

## 3. Facts the plan rests on (verified read-only against Production, 2026-11-12 unless noted)

- `app.frq_criteria` already holds per-element rubric fields: `criterion_key`, `learner_facing_text`, `points_possible`, `evidence_requirements`, `minimum_fix`, `accepted_variants`, `judgement_kind`. Across all subjects: 6,735 rows (6,639 text, 96 image); none lacks `evidence_requirements` or `minimum_fix`. Average learner text is about 95 characters. So FRQ rubric content exists; v0 does not author it.
- `app.mcq_choices` holds `choice_key`, `choice_text`, `is_correct`, `rationale` per choice. There is no error-type field. The per-distractor rationale is the only authored statement of why a choice is wrong.
- `app.topic_explainers` (published): AP Biology 60 rows, AP Statistics 55. Each has `core_idea`, `what_students_need_to_understand`, `how_this_becomes_points`, `answer_move`, `common_point_loss`, `mini_example_question`, `weak_answer`, `point_attaining_answer`, `practice_bridge`. The five prose fields together average about 810 characters (Biology, max 1,396) and about 1,280 (Statistics, max 1,658). They are short, which argues they can be cited whole by field.
- `app.topic_point_briefs` are published and complete for both subjects (60 and 55). Subject keys here are `ap_biology` and `ap_statistics` (underscores).
- Distractor count for the first slice is about 2,583 (earlier estimate for Biology plus Statistics; to be recounted at Step 0).
- Skill labels are partial (Statistics MCQ 88 of 460, FRQ 69 of 110; Biology MCQ 146 of 401, FRQ 74 of 89). Codex runs `TASK-0050` Phase B. This plan does not wait on it.
- Prototype judging: two non-generator judges (`google/gemini-3.8-flash`, `alibaba/qwen3.8-flash`), 7 of 7 planted controls required, either-judge factual flag blocks a text. Cost about $0.0015 to $0.003 per judge call.
- In pass 3 both judges marked all 12 new-prompt texts factually correct and free of unsupported claims about the student, but human review found remaining weak spots: thin "why required" on some MCQ texts, a missing fix kind, and a FRQ text listing points earned that were not verified against the rubric.

## 4. Principles

1. **Compose, don't duplicate.** The library holds only what the authored item/explainer/brief does not already say. Facts about a specific item stay in that item's fields; the library adds meanings, labels and exemplars that are cross-item.
2. **Every library entry has a source and an owner.** A statement is either derived from a named authored field or CED text, or is marked `authored_by_claude, pending_human_approval`. Nothing enters the model's context as "approved" without a recorded approver.
3. **Soft rule stays soft in v0.** Library membership is not yet a hard gate on model claims (David's ruling). An unsupported claim is flagged for human review and counted, even if both judges call it factually correct. A flagged text cannot enter the approved exemplar set or an approved pre-fill cache without a documented disposition. This is an offline content rule, not a change to the runtime rule.
4. **Approval has a defined meaning.** David reviews voice, usefulness and scope; two different-family model checkers screen subject accuracy. Neither model agreement nor a small human sample proves subject accuracy. Unresolved content disputes and any claim that needs knowledge beyond the source fields go to a qualified subject reviewer or remain in the gaps register. Do not describe an unreviewed batch as subject-expert approved.
5. **No Production writes.** The library is files in the repo, loaded by the prototype scripts. A runtime table is a later phase.

## 5. Storage, format and versioning

- Location: `docs/coaching_library/v0/` (new directory), plain JSON files plus a short `README.md`. Rationale: reviewable in PRs, diffable, no migration, no Production approval. (Alternative considered: a Supabase table now. Rejected for v0 because any DB write to Production is hard-gated and the schema is not yet known to be right.)
- Files: `layer1_requirements.json`, `layer3_distractor_labels_<subject>.json`, `layer5_examples.json`, `provenance.json`, `gaps_register.json`.
- Every entry carries: `id`, `subject`, `content_ref`, `source_fields`, `source_fingerprint`, `status` (`draft` | `checked` | `approved` | `blocked`), `checked_by` (model ids, run id), `approved_by` and `approved_on` (human where applicable), `library_version`, `supersedes`. A checked entry has passed automated checks; it is not an approved library entry. Store batch approval separately with approver, sample design, defects and disposition; do not populate an unsampled entry's `approved_by` as though it received individual review.
- `library_version` identifies an immutable snapshot of the whole library. Any change to an approved entry creates a new snapshot and changelog line; an entry revision retains its own lineage. Prompts and evaluation records capture the snapshot identifier, exact entry IDs and source fingerprints, so a text can be traced even when a later snapshot changes unrelated entries.
- Item-specific labels use the canonical item code plus authored version number as their portable key, with the Production `content_item_version_id` recorded as a verified alias. Do not assume version numbers or UUIDs map across environments: Step 0 must prove the mapping against current records. A changed stem, choice, rationale, correct answer, status or version invalidates the label until its fingerprint is checked again. CED-derived entries carry source edition, section and page/reference locator.
- Validation rejects duplicate active keys, missing source references, stale fingerprints, invalid status transitions, and any `approved` entry without its required human or batch approval record. The gaps register records missing/ambiguous rationales, unsupported extensions, checker disagreements and revision invalidations with an owner and disposition.

## 6. Layer 1: requirement meanings

**Goal.** For each command word and recurring requirement pattern in AP Biology and AP Statistics FRQs, an approved statement of (a) what the task requires, (b) what a response that does not do it looks like, (c) why full credit requires it, (d) how it differs from neighbouring words (for example identify vs describe vs explain vs justify).

**Source.** College Board Course and Exam Description task-verb definitions where the CED has them (the CED PDFs are the preferred source per earlier work; the assessor should confirm both CEDs define task verbs), then the verbs actually used in the published FRQ part text. Anything not in the CED is marked `claude_authored` and goes to the gaps register for a subject check.

**Method.**
1. Extract the distinct leading verbs from FRQ part text for published Biology (89) and Statistics (110) items; count frequency. Expected result is a short list (order of 15 to 30). Report the list before authoring.
2. For each verb, assemble the CED definition (verbatim reference, not copied into prompts) and 2 to 3 real part texts as evidence of use.
3. Draft the four fields per verb (model-drafted from the above, not from memory).
4. Two-judge check (recipe items 1 to 7) plus a deterministic check that every "why required" statement has a precise CED or rubric source locator. A locator proves traceability, not that the statement follows from the source; reviewers check that link. Where a rubric narrows or contradicts a general verb definition, the item rubric governs and the entry cannot be used as a universal rule.
5. David reviews voice and usefulness on all entries (short list), flagging any he wants a subject specialist to check.

**Size.** Roughly 15 to 30 entries per subject pair; small enough for full human read.

**Acceptance (proposed).** Every verb occurring in 3 or more published parts has an entry; rarer verbs are inventoried with a fallback to the item rubric. Every approved entry has a source and an approver; every factual flag is resolved and documented. Test each entry against at least one counterexample where the verb alone would overstate the actual rubric. The judges and David review these cases, and unresolved scope disputes remain blocked.

**Risks.** CED verbs may not match how the item author used the word (then the item's rubric wins; record the mismatch in the gaps register). "Why required" text can sound authoritative while being an invention; hence the source rule.

## 7. Layer 3: distractor error labels

**Goal.** For every wrong choice in every published, non-retired Biology and Statistics MCQ, a short structured label of the error or gap it represents, so coaching can say "Choice B says X; the error is Y; a correct answer must show Z; here is how that costs the point" without inventing the error.

**Label shape.**
- `error_summary`: one plain sentence, student-facing register, stating what the choice claims and why it fails (restates the rationale, does not add facts).
- `error_type`: value from a small per-subject controlled list (proposed seed list from the first 200 labels, then frozen: for example misapplied formula, wrong direction, confuses two concepts, correct fact wrong question, incomplete condition, over-generalization). Target at most 12 types per subject, so the list stays usable.
- `requirement_lost`: the thing the correct answer must show (derived from the correct choice's rationale and the stem).
- `fix_kind`: `answer_differently` | `learn_first` (rule 3 in the voice rules).
- `skill_code`: nullable, filled when TASK-0050 Phase B lands labels (do not wait).
- `source_fields`: always `mcq_choices.rationale` of this choice (and the correct choice's rationale); labels with no usable rationale are not drafted, they go to the gaps register.

**Method.**
1. Pull published non-retired MCQ items for both subjects; count distractors, rationale length distribution, missing/short rationales (Step 0 report). Check whether the existing authored rationale and correct-choice rationale already suffice for the proposed coaching. Deduplicate only exact source-equivalent cases; do not create a second paraphrase merely to fill a quota.
2. Draft labels in batches by cheap model, grounded only on stem, choices and rationales (author-in-session pattern: no expensive model authoring; the gateway only checks, per David's earlier instruction).
3. Two-judge check of each label with planted-wrong labels in every batch. Keep the seven frozen coaching controls for coaching-text runs; calibrate a separate label-control set, including a correct-sounding but unsupported extension and a wrong-answer-key case. Either-judge factual or source-support flag blocks the label. One regeneration is allowed; a repeated flag or disagreement is reviewed or blocked, never silently dropped.
4. Deterministic checks: required source locators and fingerprints, no student-motive language, `error_type` in list, no jargon list hit, and agreement with the stored answer key. Token overlap may help locate a claim but cannot establish entailment; do not count it as a factual check. A checker must decide whether each substantive label claim follows from the cited item fields, with human review of ambiguous cases.
5. Human review: David reads a stratified sample across both subjects, batches, error types, rationale quality and checker disagreements for voice and usefulness. Step 0 sets the sample size and acceptable uncertainty for each batch; about 60 labels over the entire population cannot justify a claim that the true defect rate is below 5%. Any material defect triggers a broader sample and batch repair before approval. A qualified subject reviewer resolves subject-correctness disputes that the source fields and judges cannot settle.
6. Promote a batch to `approved` only after its sample, checker results and exceptions are recorded. An unsampled entry may inherit a documented batch approval, but its metadata must say `approval_basis: batch`, not imply individual human reading. `checked` labels may be used in explicitly marked experiments only; approved exemplars and candidate pre-fill content use approved entries.

**Cost (estimate, to be confirmed in Step 0).** Drafting 2,583 labels at about $0.0003 each is under $1. At the pass-2 measured mean of $0.00164 per judge call, two judges cost about $8.5; at $0.002 to $0.003 per call, they cost about $10.3 to $15.5. Regeneration, controls, review and the pilot add cost. The earlier $6 to $10 total is therefore a lower scenario, not a reliable ceiling; Step 0 must price the complete workflow separately from coaching-text pre-fill.

**Acceptance (proposed).** Report coverage as approved / checked / blocked / missing, with a denominator of all eligible distractors; do not equate missing rationale with coverage. No unresolved factual or support flags in approved entries. Batch voice/usefulness defects are below the Step 0 review threshold with the sample and uncertainty reported. Keep the controlled type list small, but allow a rare valid type rather than forcing it into an inaccurate label. The ablation in Section 9 must show value beyond the authored rationale alone before expanding beyond the pilot.

**Dependencies/risks.**
- Thin or generic rationales ("This is incorrect because...") produce thin labels; report the share and send to gaps register rather than inflating.
- Rationales are the only source, so a wrong authored rationale propagates; the labels step does not re-derive the answer key (separate publish-time rule requires independent re-derivation).
- Skill linkage is deferred behind TASK-0050 Phase B, so v0 labels are not yet queryable by skill; this limits later cross-item patterning but not per-item coaching.
- Label drift when an item is revised: handled by keying to `content_item_version_id`.

## 8. Layer 5: approved example coaching texts

**Goal.** A small, human-approved set of coaching texts by case, used (a) as exemplars in the generation prompt and (b) as reference points for judges and for human calibration.

**Cases (proposed).** MCQ miss (no history); MCQ repeat miss (synthetic history); FRQ partial credit; FRQ nothing earned on a part; FRQ full credit with praise; student struggling (encouragement framing); student improving without full credit (progress framing). Seven cases × two subjects × two approved prompt exemplars = 28 prompt exemplars. A separate held-out set needs at least one additional approved text per case and subject (14 more, 42 total) if every case is to have held-out coverage; Step 0 may reduce the case matrix explicitly if that cost or review load is too high.

**Method.**
1. Seed from the 22 texts in `HUMAN_READ_PACKET.md` and the pass-3 texts, but only those David explicitly approved or after revision against his marked critique; nothing is "approved" by inference. Where the packet has no good text for a case, the text is written by Claude against the voice rules, labelled as such, and goes through the same check and approval.
2. Each example stores: the case, the item/version reference and source fingerprints, a synthetic or redacted input fixture sufficient to reproduce it, the text, which voice rules it demonstrates, the reason it was approved, and its fixed split. Store no real student response or private history in the repo.
3. Check: two judges plus planted controls, same as other layers; David approves each.
4. Split by item family and case into an **exemplar set** (used in prompts) and a **held-out set** (never shown to generators or used to tune prompts). Freeze the split before generation; near-duplicate versions of an item stay on one side. Held-out texts calibrate reviewers and compare outputs, but human readers also judge new responses against the actual source and student fixture.

**Acceptance (proposed).** Every retained case has two approved prompt exemplars and one approved held-out example per subject, or a documented gap and no claim of coverage for that case. The seven controls are a run-level judge validity check, not a per-example property. Each approved example has an individual source-supported review and explicit voice-rule checklist. Full-credit praise cases use the applicable success checklist rather than requiring a nonexistent defect.

**Risks.**
- Over-copying: generators may reproduce phrasing. Mitigation: rotate exemplars, measure n-gram overlap with exemplars in the ablation, and cap exemplars at 2 per prompt.
- Encouragement and praise copy is subject to the unresolved DECISION amending the one-word-verdict/no-praise/no-emoji design rules; exemplars for those cases are marked `design_rule_pending` and are prototype-only until that decision exists.
- Synthetic examples may not reflect real student writing; real attempts are few (5 users).

## 9. Evaluation: does the library help?

A library that does not improve coaching is cost. Test with a paired ablation and keep development items separate from held-out evaluation.

- **Items:** Use pass-2 and pass-3 items as a development/calibration set because the prompts and case choices were already shaped by them. Freeze a separate, unseen item/version and synthetic-response set before the ablation. Exclude exemplar item families and near-duplicates from that test. Report subject, item type, rationale quality and response-severity coverage; do not claim population performance from the small set.
- **Arms:** Pair each item/response/generator across a relevant baseline and one added layer: FRQ baseline vs layer 1; MCQ baseline vs layer 3; each type baseline vs layer 5; and each type baseline vs its applicable combined set. A common "all three" arm is misleading because layer 1 is FRQ-only and layer 3 is MCQ-only. Freeze the prompt except for library context, randomize presentation order to human readers, and record context-token and latency differences.
- **Generators:** the same two (haiku-5.5, gpt-6-luna), no DeepSeek (latency).
- **Measures:** judge scores (frozen recipe, both judges, seven of seven controls required for each coaching run, incoherence and retry rules); adjudicated factual errors; unsupported claims with source locators and dispositions; voice-rule pass rate; word count, token cost and latency; exemplar overlap; and a blinded human paired read with reasons. Include at least one negative-control case where the library should add nothing or abstain. Report numerator and denominator for each measure, split by subject and item type.
- **Decision rule (proposed):** first require no adjudicated new factual error or rubric contradiction in an added-layer arm. Then retain a layer for expansion only if paired human review shows a useful improvement or an adjudicated reduction in unsupported claims, with cost and latency within an owner-set ceiling. Treat a tie or an inconclusive small sample as a pilot result, not proof of benefit. If a layer fails, revise or narrow it and record the outcome in the gaps register.
- **Known limits:** model judges are not ground truth (Gemini scores near 5 on nearly everything), small samples, synthetic student inputs. The human read is the arbiter.

## 10. Sequence

0. **Counts and checks (read-only; duration to estimate).** Recount published non-retired MCQ items and distractors; rationale quality, not just length; verb list from FRQ part text; check CED editions and task-verb definitions; verify natural-key/version mapping and source fingerprints; audit explainer field citability and factual support, not just non-null fields. Output: a reproducible query/method, denominators, a short report, review sample design, per-run and total cost estimate, and a frozen held-out test set. If explainers fail, present a scoped layer-6 amendment for owner decision; the earlier approval of layers 1, 3 and 5 does not automatically authorize adding layer 6.
1. **Library scaffolding.** Directory, schema, provenance and gaps register structure, validation script (schema, referential integrity, status rules, banned terms).
2. **Layer 5 first (smallest, human-bound).** Assemble and approve exemplars and the held-out split. This also yields the prompt wording the other layers must fit.
3. **Layer 1.** Verb list, drafts, check, David review.
4. **Layer 3.** Pilot about 200 distractors across both subjects, including thin and ambiguous rationales. Run the MCQ ablation on a held-out pilot subset before approving mass labeling. Continue only after the owner reviews the pilot's value, defect rate and revised cost; then process the rest in batches with review and stop rules.
5. **Ablation and read-out.** Section 9. Update `RESULTS.md` and the parent plan.
6. **Close v0.** Library version 1 tagged; gaps register triaged; recommendation for layers 2, 4, 6, 7 and for the library-as-hard-rule step.

Layer order rationale: layer 5 needs the least data and gives the target form; layer 1 is small; layer 3 is large and benefits from the settled form.

## 11. Governance

- This draft review makes no Hard-Gate change. The proposed file library requires no migration or Production write. A later change to `evaluate-attempt`, the feedback card, student-data/provider handling, or the canonical pedagogy rules follows its own recorded approval gates. Approval of layers 1, 3 and 5 is not approval of those later actions.
- Model spend remains subject to the prototype's $3 per-run guard. The $15 to $25 total is an unverified estimate: Step 0 must recompute it for 42 candidate examples, batch controls, retries, extra adjudication and the held-out ablation. No paid bulk run begins until David records a total ceiling; report actual spend per step.
- No student data to any provider; only authored content and synthetic responses.
- Commit via a branch and PR per the repo's rules; the Activity Log entry and any task record accompany the first commit. No DECISION or APPROVAL numbers are claimed here; check open PRs before numbering (past collisions).
- Verify whether the earlier transcript exposed an active gateway key and rotate it through the approved secret-management path if so, before paid bulk runs. Do not copy the key into this repo or the report.

## 12. Open questions for David

1. Which of the packet's 22 texts do you consider approved as exemplars as marked, and which only after revision? (The summary of the human read does not record this per text.)
2. Who is the qualified subject reviewer for unresolved Biology and Statistics accuracy disputes, and what share of the pilot should that reviewer inspect? A pilot student alone is not a subject-correctness approver.
3. Are you content for layer 5's praise and encouragement exemplars to stay prototype-only until the design-rules DECISION exists?
4. Approve the `docs/coaching_library/v0/` file-based storage for v0?
5. What total budget and per-run cap should govern v0 after Step 0 recalculates the estimate?

## 13. Independent assessment (2026-11-12)

**Verdict: proceed with Step 0 and a bounded pilot, not the full library build yet.** Layers 1, 3 and 5 form a coherent offline experiment under the owner's selection. Layer 7's do-not-say rules already exist in the parent voice rules and canonical pedagogy file; encode them as validator checks in v0 rather than creating a fourth content layer. Layer 2's item-specific reasons belong with the part and criterion; the general verb library must never override them. Layer 6 remains conditional on the citability audit and a fresh scope decision.

The central risk remains: a soft library does not prevent the roughly 3–4% real-error rate seen in the small pass-2 prototype. The offline approval and citation checks reduce exposure for curated examples and pre-fill candidates, but no Production coaching release follows from this plan. Runtime grounding, grading-faithfulness and fallback behavior need a separate release design and evidence. An approved label can still faithfully repeat an incorrect authored rationale, so the pilot must audit source quality and escalate answer-key disputes.

The original approval and evaluation rules overstated what two model judges and about 60 human reads could establish. The revised batch statuses, qualified-review path, held-out item split and paired type-specific ablation make the pilot interpretable. Even a clean pilot cannot certify a near-zero error rate; report uncertainty and individual adjudicated failures rather than a bare "zero flags" claim. The large label pass should wait for the 200-distractor pilot's human value, source-quality and cost results.

**Remaining decisions:** David must identify which packet texts are actually approved, name or authorize a path to a subject reviewer, settle prototype-only praise/encouragement under the canonical copy rules, approve the proposed file format, and set a spend ceiling. These are decisions for the build, not prerequisites for this assessment.
