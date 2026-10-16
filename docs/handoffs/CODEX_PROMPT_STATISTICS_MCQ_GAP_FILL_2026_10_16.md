# Codex prompt — close the AP Statistics MCQ gaps (units 1–3): seeds first, then cheaper variants

> **Before you send this:** confirm the **[DAVID]** lines (variant count and budgets). Everything else is ready to paste. This version replaces the earlier draft (seeds and variants together at a padded budget).

---

You are the conductor for one bounded content task in the Cramapple repo (`/Users/davidbloom/Documents/Cramapple.nosync`). Start with `AGENTS.md`, then `docs/INDEX.md` (route through it; do not scan `docs/research`, `docs/teaching` or `scripts/*/out` broadly; open only the exact files named below).

## Goal
Close the **practice-MCQ gaps in AP Statistics, units 1–3**, using the content creation protocol: `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` **§0 (generate-and-select, v0.6)** and the seed pipeline (§0.8, `DECISION-0101`). Statistics units 1–3 have 372 practice MCQs, but 15 of 40 topics have none and one (2.2) has one. More help is live for Statistics (`APPROVAL-0183`), so every new item makes it more useful.

**Plan in two gated stages:**
- **Stage A — seeds only.** 2 new seed MCQs for each empty topic and 1 for topic 2.2: **31 seeds**. Stop at a gate and report.
- **Stage B — cheaper variants (only after the Product Owner says go).** Up to **3 variants per seed (93)**, produced with a **cheaper but still four-family-checked** profile that you must validate first (below). **[DAVID]** if you want 2 variants per seed instead (62), say so at the gate.

**[DAVID] Budget** (counts every gateway call: controls, retries, vetoes, label votes). Stage A ceiling **$12** (expected $7–10: the Biology seed pilot cost $0.314 per accepted item before the cost levers and about $0.22 after, `scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07/RESULTS.md`). Stage B ceiling **$22 including the validation work** (the standard profile would be about $20–29; the aim of the cheaper profile is roughly $0.15 per variant, about $14). Stop and report if you would exceed either. Author in your own session; the gateway is for checkers only (`feedback_author_in_session_arbitrate`: do not pay a model to author what you can author, and arbitrate flags yourself).

## Hard rules (the owner's, 2026-10-15)
1. **Statistics only, units 1–3 only.** Do not touch unit 4+ or any other subject.
2. Do **not** change More help (policy table, `more-help` function, app); new items you publish become eligible for it automatically once tagged.
3. **No Production write without a recorded Hard-Gate approval** (a new `APPROVAL-####` created on the Product Owner's go-ahead in chat). Check `main`, open PRs **and remote branches** for the highest approval number first (0179–0183 are claimed on branches). Development and local files are free to use.
4. Protocol §0.3 does not bend: never hand-edit a generated item; a rule added later applies to the next batch; **no item is accepted unless four non-author families clear it** (the author's family may only veto); **controls gate every batch**; recompute numeric keys deterministically (Python/sympy) before load; refresh the model roster at batch start.

## The gaps (Production, 2026-10-16, latest published versions, worked examples excluded)
| Unit | Topics with **0** practice MCQs | Topic with **1** |
| --- | --- | --- |
| 1 | 1.1, 1.3, 1.4 | none |
| 2 | 2.1, 2.3, 2.8, 2.11, 2.12 | 2.2 (needs 1 more) |
| 3 | 3.7, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14 | none |

Every topic already has at least one FRQ and one worked example. Report, but **do not fill** without asking: thin topics with 3–4 MCQs (1.10, 2.4, 2.5, 3.1, 3.3, 3.4, 3.5, 3.6, 3.15). Re-run the gap query at the start and attach the output; the numbers may have moved.

## Inputs (open exactly these)
- Protocol §0, §0.4 (escalation triage), §0.5 (evaluating a change to the method), §0.9 (running and publishing), §2.1 (questions the Product Owner answers before a run: answer them from this prompt, ask only what is missing), §3.2 (model menu; slot D `alibaba/qwen3.7-plus` is "for high-volume variant sampling, not first-time scope checks").
- Tooling: `scripts/vercel-gateway-check/teaching_pipeline/` (`README.md`, `rubric.mjs`, `run.mjs` including its `calibrate` command and the `--fourth=<model>` option, `seed_pipeline.mjs`, `inputs/briefs_all.json`, `inputs/skills/<subject>.json`). Publishing: `scripts/content-seed/publish_mcq_batch.py` (never hand-carry SQL).
- Facts: `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, the unit briefs (`AP_STATISTICS_UNIT1_TOPIC_POINT_BRIEFS.md`, `..._UNIT2_...`; check `briefs_all.json` for unit 3), the reference-pack fact packs in `scripts/content-seed/ap-statistics-reference-u2-u3-2026-10-10/out/`, and the **CED PDF** `docs/teaching/ap-statistics-course-and-exam-description.pdf`. **The PDF governs** when a brief or fact pack disagrees (§0.4; Statistics 2.12 once demanded CED 4.1 content, `APPROVAL-0129`). If a topic escalates, fix the source with the Product Owner's approval and regenerate; never patch the item.
- Most empty topics are the later, harder ones (two-sample inference, chi-square, the normal model and CLT). Expect topic-overlap decisions (§0.4 item 3); record them rather than deciding silently. Avoid stems whose key is simply "name the procedure" (More help's identify/define rule refuses to coach those).

## Stage A — seeds (31), then STOP
1. **Stage 0 (no spend):** gap query; roster refresh; confirm briefs and fact pack cover all 16 topics; write `plan.json` and the skill list; state your cost estimate.
2. **Run** `run.mjs` / `seed_pipeline.mjs` for the seeds (two stateless authors in sequence, deterministic random key position, lint, four-family blind solve, rubric audit, re-sample, own-family veto, **planted-defect controls first**: all six must be caught or the batch is void). Seed labels per `DECISION-0101`: topic by the 5-of-6 vote rule, skills validated at 3 or more votes else practice level, difficulty is not an author target (`provisional_model`). Escalate after 2 rounds; triage per §0.4.
3. **Gate:** report accepted/escalated counts, cost from `calls.jsonl`, controls result, any CED or brief corrections, and the 31 accepted seeds' topic/skill labels. Offer a blind re-judge on a sample. **Do not start Stage B or publish without the Product Owner's word.**
4. **Load (Hard-Gate):** `publish_mcq_batch.py plan-from-seed-batch` → `preflight` → `rehearse --env prod` (rolls back) → stop and ask for the approval → `publish`. Afterwards call the subject's real selector as `service_role` to confirm the items are served and re-run the gap query. Follow `feedback_content_pipeline_db_and_process_traps` (draft → assigned → reviewed_approved → published; a new version flips the old label to stale; rehearse every write; md5 over written rows after commit; check open PRs before pushing).

## Stage B — cheaper variants (only after the gate)
The cheaper profile must **keep four non-author families plus the author-family veto and the 3-gram similarity gate** (Jaccard ≤ 0.35 against the seed and earlier siblings); it may only change **which models fill the checker slots**. It must not drop a checker or a stage (rule 3, §0.5).

1. **Calibrate** each cheaper model you intend to use (the `calibrate` command against the known-defect and known-clean sets; candidates: `alibaba/qwen3.7-plus` via `--fourth=`, and cheaper solve-stage models, protocol lever 2). Record valid-structured-output rate, known-defect catch and known-clean false-flag rate. A model that fails calibration is not used.
2. **Head-to-head on 3 seeds (9 variants):** run the standard profile and the cheaper profile on the same seeds with the planted-defect controls in both. Compare cost per accepted variant, acceptance rate and defect catch. Proceed only if the cheaper profile catches every planted defect and its accepted variants pass a blind re-judge with 0 defects.
3. If it passes, run the remaining seeds under the cheaper profile within the Stage B ceiling; if not, **stop and report the standard-profile cost** and let the Product Owner choose (fewer variants, or pay).
4. Variants **inherit the seed's labels** (no re-vote). Load with the same Hard-Gate path as Stage A, with a separate approval.

## Deliverables
1. Stage 0 plan and cost estimate.
2. Per stage: accepted/escalated counts, cost from `calls.jsonl`, controls and calibration results, and the final gap table.
3. Private artifacts (full questions, votes, keys stay out of the public repo); a metadata-only record in `docs/qa/` and an activity-log line.
4. A short handoff: escalations, CED/brief corrections, thin topics left for a decision, and the measured cost per accepted item for each profile (this feeds the protocol's cost section).

Do not pass a gate (budget, Hard-Gate, escalation needing the Product Owner, Stage B start) without asking. Report faithfully: if a control fails or an item is defective, say so with the evidence.
