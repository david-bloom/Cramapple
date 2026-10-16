# Codex prompt — close the AP Statistics MCQ gaps (units 1–3)

> **Before you send this:** confirm the two lines marked **[DAVID]** (interpretation and budget). Everything else is ready to paste.

---

You are the conductor for one bounded content task in the Cramapple repo (`/Users/davidbloom/Documents/Cramapple.nosync`). Start with `AGENTS.md`, then `docs/INDEX.md` (route through it; do not scan `docs/research`, `docs/teaching` or `scripts/*/out` broadly; open only the exact files named below).

## Goal
Close the **practice-MCQ gaps in AP Statistics, units 1–3**, using the content creation protocol: `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` **§0 (generate-and-select, v0.6)** with the seed pipeline (§0.8, `DECISION-0101`). Statistics units 1–3 have 372 practice MCQs but they are badly uneven: 16 of 40 topics have 0 or 1.

**[DAVID] Interpretation to confirm:** every empty topic gets **2 new seed MCQs**, and each seed then gets **3 variants** (`seed_pipeline.mjs --variants=3`), i.e. 6 new questions per empty topic. Stage A (seeds) and Stage B (variants) are separate gates; if you meant something else (for example 3 seeds per topic, or no variants), change this paragraph before sending.

**[DAVID] Budget:** proposed ceiling **$30 for Stage A and $40 for Stage B**, counting every gateway call including controls, retries and vetoes. Stop and report if you would exceed either. Author in your own session; the gateway is for checkers only (`feedback_author_in_session_arbitrate`: do not pay a model to author what you can author, and arbitrate flags yourself).

## Hard rules (the owner's, 2026-10-15)
1. **Statistics only, units 1–3 only.** Do not touch unit 4+ or any other subject.
2. Do **not** change More help (policy table, `more-help` function, app). It launched for Statistics units 1–3 on 2026-10-16 (`APPROVAL-0183`); new items you publish become eligible for it automatically once tagged.
3. **No Production write without a recorded Hard-Gate approval** (a new `APPROVAL-####` entry created by the Product Owner's go-ahead in chat). Check `main` **and open PRs and remote branches** for the highest approval number before numbering (0179–0182 are already claimed on branches). Development and local files are free to use.
4. Follow the protocol's "rules that do not bend" (§0.3): never hand-edit a generated item; a rule added later applies to the next batch; four non-author families clear an item and the author's family may only veto; **controls gate every batch**; recompute numeric keys deterministically (Python/sympy) before load; refresh the model roster at batch start.

## The gaps (Production, 2026-10-16, latest published versions, worked examples excluded)
| Unit | Topics with **0** practice MCQs | Topic with **1** |
| --- | --- | --- |
| 1 | 1.1, 1.3, 1.4 | none |
| 2 | 2.1, 2.3, 2.8, 2.11, 2.12 | 2.2 (needs 1 more to reach 2) |
| 3 | 3.7, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14 | none |

That is **15 empty topics (30 seeds) plus 1 seed for 2.2 = 31 seeds, then 93 variants**. Every topic already has at least one FRQ and one worked example. Also report, but **do not fill** without asking: the thin topics with 3–4 MCQs (1.10, 2.4, 2.5, 3.1, 3.3, 3.4, 3.5, 3.6, 3.15) and any topic whose reference entries lack vocabulary. Re-run the gap query at the start (the numbers above may move) and attach the output.

## Inputs (open exactly these)
- Protocol: `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §0, §2.1 (questions the Product Owner answers before every run; answer them in your plan using this prompt, ask only what is genuinely missing), §0.4 (escalation triage), §0.9 (running it, publishing).
- Tooling: `scripts/vercel-gateway-check/teaching_pipeline/` (`README.md`, `rubric.mjs`, `run.mjs`, `seed_pipeline.mjs`, `inputs/briefs_all.json`, `inputs/skills/<subject>.json`). Publishing: `scripts/content-seed/publish_mcq_batch.py` (never hand-carry SQL).
- Facts: `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, the unit briefs (`AP_STATISTICS_UNIT1_TOPIC_POINT_BRIEFS.md`, `..._UNIT2_...`; check `briefs_all.json` for unit 3), the reference-pack fact packs under `scripts/content-seed/ap-statistics-reference-u2-u3-2026-10-10/out/`, and the **CED PDF** `docs/teaching/ap-statistics-course-and-exam-description.pdf`. **The PDF governs** when a brief or fact pack disagrees (§0.4); both have been wrong before (Statistics 2.12 demanded CED 4.1 content, `APPROVAL-0129`). If a topic escalates, fix the source with the Product Owner's approval and regenerate; never patch the item.
- Statistics' "empty" topics are mostly the later, harder topics (two-sample inference, chi-square, the normal model and CLT). Expect to need topic-overlap decisions (§0.4 item 3); record them rather than deciding silently.

## Method
**Stage 0 (plan, no spend):** re-run the gap query; roster refresh; check that `briefs_all.json` and the fact pack cover all 16 topics; write the batch plan (`plan.json`), the skill list, and a cost estimate from §0.7 ($0.28 per accepted question measured; state your own estimate). Post it and wait for the budget line to be confirmed if it is still a placeholder.

**Stage A (seeds):** `run.mjs`/`seed_pipeline.mjs` generate-select for the 31 seeds: two stateless authors from different families in sequence, deterministic random key position, lint, four-family blind solve, rubric audit, re-sample, own-family veto, planted-defect controls first (all six must be caught or the batch is void). Seed labels per `DECISION-0101`: topic by the 5-of-6 vote rule, skills validated at 3 or more votes else practice level, difficulty is **not** an author target (store the vote as `provisional_model`). Escalate after 2 rounds; triage per §0.4.

**Stage B (variants):** only after Stage A is accepted: `--variants=3` per accepted seed, with the 3-gram similarity gate and inherited labels (no re-vote). Report 0-defect blind-judge results on a sample.

**Load (Hard-Gate):** build the plan with `publish_mcq_batch.py plan-from-seed-batch`, run `preflight` and `rehearse --env prod` (rehearsal always rolls back), then **stop and ask the Product Owner for the approval** before `publish`. After publish, call the subject's real selector as `service_role` to confirm the new items are served, and re-run the gap query. Note `feedback_content_pipeline_db_and_process_traps`: items walk draft → assigned → reviewed_approved → published; inserting a version flips the old label to stale; rehearse every write; compare an md5 over written rows after commit; check open PRs before pushing.

## Deliverables
1. The plan and cost estimate (Stage 0).
2. Per stage: accepted/escalated counts, cost from `calls.jsonl`, the controls result, and the final gap table.
3. A private artifacts folder (full questions, votes, keys stay out of the public repo); a metadata-only record in `docs/qa/` and an activity-log line.
4. A short handoff listing anything escalated, any CED/brief corrections made, and the thin topics left for a decision.

Do not proceed past a gate (budget, Hard-Gate, escalation needing the Product Owner) without asking. Report faithfully: if a control fails or an item is defective, say so with the evidence.
