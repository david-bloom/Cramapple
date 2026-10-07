# Content authoring & QA protocol — canonical, v0.6

**Status:** Adopted, 2026-08-08. Promoted from draft after a 212-item run across all 10
subjects exercised both QA methods (§4 CED-conformance and §9 independent re-derivation)
at production scale and fed the results back through publish. See the §9.3 revision note
below — that run also promotes §9 from piloted to a standing, publish-gating requirement
(hand-verify every FRQ criterion and MCQ answer key by independent computation before
publication), folded into Phase 6 (§6). Governs the pipeline that produces and reviews
`app.content_items` (exam questions: MCQ/FRQ stems, choices, rubric criteria). This is a
different pipeline from `GOLD_SET_GENERATION_PROTOCOL.md`, which produces **student
answers** to test the grader. The two share conventions (multi-family independence,
blind verification, grep-verify before trusting a model's citation claim) but are not the
same process — do not merge them.
For generating items *from existing questions as seeds* (variant families, or a third-party problem's
skill family), see `SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md`, which feeds this pipeline's Phases 2-6.

**Revision note (v0.2):** incorporates an independent review (Opus 4.8, 2026-08-06) that
caught a factual error in v0.1's fact-pack claim (§1.6, §7.3), an under-specified publish
predicate (§7.2), and the fact that §3.2 silently depends on §7.1. It also reframes
Phase 7(b) after David's observation that **published content does not drift** — only the
checker model, the fact pack, or a re-authored version can change, so re-checking is
event-driven, not periodic (§6 Phase 7, §7 P0 ranking).

**Revision note (v0.3):** adds §9, a second QA method distinct from §4's CED-conformance
check. Piloted 2026-08-08 on 75 Physics items across three pools (single-`approve`,
single-`approve_with_edits`-then-repaired, and a targeted structural-pattern scan) — the
measured yield gap between pools (§9.3) is the load-bearing finding and should drive pool
selection on future runs, not intuition about which subject "seems risky."

**Revision note (v0.4):** promotes the document from draft to adopted. Triggered by a
2026-08-08 owner-directed QA/repair/publish pass over all 212 `changes_requested` items
across all 10 subjects: every item got a §4-style CED-conformance read plus a §9-style
independent re-derivation (every MCQ answer key and FRQ criterion re-solved from
first principles, not read-and-trust) before any publish decision. That run surfaced and
fixed a systemic stem/`mcq_choices` desync bug across four Physics pools (~50 items),
19 genuine content defects (CED-scope violations, wrong CED-unit tags, contradictory
stimulus data, mismatched rubric criteria, redundant FRQ parts), and confirmed §9 catches
defect classes §4 cannot. §9's status line and Phase 6 (§6) are updated accordingly —
independent re-derivation is no longer optional-pilot, it is a publish precondition.

**Revision note (v0.5, 2026-09-29):** §3.2's fixed checker roster (Haiku 4.5 + DeepSeek v3.2) is replaced
by a **suggested-model menu the Product Owner picks two from** per batch. The fixed roster had gone stale
(the gateway now offers several newer generations of each family) and it named a same-family checker for
batches authored by Claude. The independence rules themselves are unchanged. Direction: David Bloom,
2026-09-29 (in-session). No DECISION/APPROVAL number has been assigned yet; record one before relying on this
as ratified policy. The same revision adds **variants as an optional, prompted step** (§2.1, Phase 5b): before each
run the Product Owner is asked whether to make variants of each question and how many.

**Revision note (v0.6, 2026-10-07, `DECISION-0099`):** new MCQs are now made by **generate-and-select**
(§0). No item is ever edited: candidates are accepted whole or dropped whole. Authors and checkers read one
shared rubric, four model families that did not write an item must all clear it, and the author's own family
holds a reject-only veto. Planted-defect controls gate every batch. Direction: David Bloom, 2026-10-06 ("a way to
add questions without needing to edit them using at least 4 models and multiple sessions") and 2026-10-07
("update the content creation protocol with the improved new approach").
- **Evidence:** a blind, held-out comparison on 24 topics. Defective items: legacy 4/24, generate-and-select
  1/23. The judges also disputed 6/24 legacy items and none of the new ones (§0.1).
- **What changes:** §2.1's checker question and §3.2's family count change to match. §6 Phases 1–5 are carried
  out by §0 for new MCQs.
- **What does not change:** §4, §5, §9 and Phase 6 still apply to existing content and FRQs, which §0 does not
  cover yet.

**Why this document exists:** there is currently no single place that states what has to
be true before a batch of questions gets written, which model does which job and why,
what gates a question before it reaches a student, and what closes the loop after
publish. What exists instead is a set of conventions applied ad hoc, rediscovered
mid-incident, or written into one-off SQL scripts. This document is that convention set,
made explicit, plus the gaps that need engineering work before it can be **enforced**
rather than just followed.

**The two things that gate everything are schema changes, not process (see §7):**
**P0-A — authoring provenance columns (§7.1)**, without which §3.2's writer-independence
rule is inert and no event-driven re-check (Phase 7) can compute its target set; and
**P0-B — a publish gate defined against `review_status` (§7.2)**, without which the
disapproved-but-published bug recurs (it already has, once). Everything else is
secondary to these two.

---

## 0. Default method for new MCQs: generate-and-select (v0.6)

**Status:** adopted 2026-10-07 (`DECISION-0099`).
- **Proven on:** Open Hand teaching MCQs, units 1–3, AP Biology, Statistics, Chemistry and Calculus AB.
- **Tool:** `scripts/vercel-gateway-check/teaching_pipeline/` (`README.md`, `rubric.mjs`, `run.mjs`).

### 0.1 Why: the evidence

On 2026-10-06 questions that had been "reviewed many times" kept failing new checks. Five causes:
1. **Rules applied after writing.** The named-trap and action-fix rules caused 25 of 38 blocks, and the authors
   were never given them.
2. **Reviews checked different things.** Earlier passes covered the key and scope, not traps.
3. **Single model calls are noisy.** The same unchanged sentence passed and then failed for one checker.
4. **Patches create work.** Every hand patch needed a full re-check, and could introduce a new defect.
5. **Parallel specs.** Two sessions worked one task to different specs.

**The method test.** It compared the legacy method (one author, two checkers, one patch loop) with
generate-and-select on the same 24 topics. Both arms were judged blind by three model families used by neither
arm, against the CED PDF text, with planted defects to prove the judges work (all 4 caught). The live
Production items for those topics were judged as a third arm. Full write-up:
`scripts/content-seed/task0065-method-test-2026-10-06/RESULTS.md`.

| | Legacy | Generate-and-select | Live items (legacy, shipped) |
|---|---:|---:|---:|
| Items with a confirmed accuracy or CED defect | 4/24 | **1/23** | 3/24 |
| Items a judge consistently would not publish | 6/24 | **0/23** | 4/24 |
| Keys correct (33 numeric keys recomputed) | 24/24 | 23/23 | 24/24 |
| Cost per defect-free item | ~$0.19 | $0.77 | — |
| Wall-clock for 24 topics | 10.3 min | 13.7 min | — |

- **Significance.** The sample is small (error difference p = 0.35), but every measure points the same way.
- **Root cause of the one pipeline error.** It traced to an overreaching topic brief (Statistics 2.12) that
  caused the same defect in all three arms. The brief is now fixed (`APPROVAL-0129`).
- **Production follow-up.** The three defective live items were replaced through this method (`APPROVAL-0129`).

### 0.2 The method

| Step | What happens | Why |
|---|---|---|
| Rubric | One rubric (`rubric.mjs`) builds both the author prompt and every checker prompt: on topic, CED scope, one defensible answer, self-contained, clean stem, keyed rationale explains, every distractor a named trap ending in one action `Fix:`, accurate, concise (1–3 sentences, ≤60 words; fix ≤25 words), style. | An item is written to exactly the standard it is checked against. A new rule goes into the rubric **before** the next batch, never applied to items already written. |
| Authors | Each round has two stateless authors from different families (now GPT-6.1, then Claude Opus 5.5). They run **in sequence**: the second writes only if the first's candidate is rejected. Each author gets the topic's point brief, the unit's topic list, the full CED fact pack and explicit length targets. It never sees another candidate or any checker feedback. | Two families give two independent chances. Running them in sequence stops paying for a candidate nobody uses. Statelessness prevents drift toward a checker's preferences. |
| Key position | The runner places the correct answer at a deterministic random letter. | Removes letter bias (`feedback_mcq_authoring_requirements`). |
| Lint | Deterministic rules: 4 choices, 1 correct, no inline list, one final `Fix:` per distractor, length limits, no HTML, emoji, `!` or `!=`, no figure the student cannot see. | Free and exact. Catches what models are noisy on. |
| Blind solve | The **four families that did not write the item** solve it without the key. A wrong answer, a second defensible answer or a defect counts as a flag. | Catches wrong keys and ambiguity. |
| Rubric audit | The same four judge every rubric rule and name the topic the item tests. They get the CED fact pack and the unit topic list (with CED text where available). | Catches scope, topic, trap, accuracy and style failures. |
| Re-sample | A checker that flags is asked once more. Only a repeated flag counts. | Absorbs single-call variance. |
| Own-family veto | The author's family then audits too. **It can reject, never approve.** | Without it the strictest checker (GPT-6.1) never saw GPT-written items, so the bar depended on who wrote the item. |
| Select | The first candidate that passes everything is accepted. After 2 rounds (4 candidates) with none, the topic is **escalated**. | No patching. Escalations go to triage (§0.4). |
| Controls | Six planted-defect items (lint, wrong key, fact-style fixes, missing traps, false fact, wrong topic) run before any generation. If one is accepted the batch is void. | Proves the checkers can still see defects with today's models and rubric. |
| Sessions | Per-topic lock files let sessions share a batch on one machine. Separate machines use disjoint `--shard=k/n`. Every candidate's state is written as it completes, so runs resume. | "Multiple sessions" without two sessions working one topic. |

### 0.3 Rules that do not bend

1. **Never hand-edit a generated item.** A failing item is regenerated, not repaired. This retires the patch
   loop (§5's adjudicate-and-repair, Phase 5) for new MCQs.
2. **A rule added after writing applies to the next batch, not the current one.** Put it in `rubric.mjs`, re-run
   the controls, then generate.
3. **No item is accepted on its own family's say-so.** Four non-author families clear it. The author's family
   may only reject.
4. **Controls gate every batch,** including re-runs after a rubric or model change.
5. **Numeric keys are recomputed deterministically** (Python/sympy) before load. §9 still applies.
6. **A human spot-checks a sample of accepted items per subject** before the first load, and the Production
   load is a Hard-Gate approval. Never set `review_status` from the pipeline alone without that approval
   recorded.
7. **Refresh the model roster at batch start** (gateway list). A model that fails structured output in the
   smoke run is replaced, not worked around.

### 0.4 Escalation triage

When a topic escalates, or several candidates fail for the **same** reason, suspect the inputs before the
authors.
1. **Check the brief and the fact pack against the CED PDF** (`docs/teaching/ap-*-course-and-exam-description.pdf`),
   not against each other. Both have been wrong:
   - Biology 2.10's brief demanded evidence the CED does not list (`APPROVAL-0127`).
   - Biology 3.3's fact pack had dropped EK 3.3.A.2.ii (`APPROVAL-0127`).
   - Statistics 2.12's brief demanded CED 4.1 content (`APPROVAL-0129`).

   The fact packs' per-topic EK sections are paraphrase. The PDF governs.
2. **Fix the source** with the Product Owner's approval, then regenerate. Never patch the item.
3. **Topic overlap** (for example Biology 1.5 vs 2.3, where answering needs a later topic): the Product Owner
   decides whether to allow it. Record the decision in the batch.

### 0.5 Evaluating a change to the method

Use the method-test design (`docs/product/OPEN_HAND_CONTENT_METHOD_TEST_DESIGN_2026_10_06.md`) whenever the
method itself changes: new author or checker families, a rubric change that loosens a rule, or a cost cut.
- **Judges and source.** Judges come from families used by neither arm, and judge against the CED PDF excerpt
  for each topic.
- **Planted defects.** Mix them into the blind set. If any is missed, the results do not count.
- **Scoring traps learned:**
  - score the key from the structured answer only, since judges fill free-text fields with commentary;
  - a "false statement" counts only in the stem, a rationale or fix, or the keyed choice, since wrong choices
    are false by design;
  - parse topic codes from the first number pair.
- **Disputes.** A dispute is a single judge objecting. Adjudicate each one blind to arm with a recorded reason,
  and have a human confirm.

### 0.6 Replacing a live item

The `APPROVAL-0129` pattern (`scripts/content-seed/task0065-live-replacements-2026-10-07/`):
1. Generate the replacement through §0.2.
2. Load it under a new `content_key` (`-r2`) with the standard loader.
3. In the same transaction: release the old teaching row, retire the old item and its version, and assert the
   topic has exactly one active teaching row.
4. Development first. Then a Production rehearsal that raises and rolls back, then the apply.
5. Verify a content hash against the locally computed plan.
6. Call the real serving function (`get_open_hand_teaching_item`) as an authenticated user. Do not model its
   predicate.

### 0.7 Cost, speed and tuning

**Updated 2026-10-07 (measured):** three changes cut the cost per accepted question from $0.72 to **$0.28**
(−61%) on the method test's 24 topics:
- **Cache-friendly prompts.** The fixed role, rubric and fact pack come first, and Claude's prefix carries a cache
  marker.
- **Sequential authors.**
- **Explicit length targets** for writers.

Acceptance rose to 24/24 from 26 candidates, and the controls still caught 6/6. A blind held-out re-judge found 0
defects in 24, with clean pedagogy and "publish" on all 24. Write-up:
`scripts/content-seed/task0065-cost-test-2026-10-07/RESULTS.md`.

**Levers 2 and 3, measured 2026-10-07** (`scripts/content-seed/task0065-cost-levers-2026-10-07/RESULTS.md`):
- **Fourth checker.** Meta Muse Spark 1.3 replaces Kimi K3. It is calibrated equal on 9 known defects and 24
  known-clean items, at less than half the cost per audit.
- **Unit-scoped fact pack** (now the default). All course-wide sections plus units up to the item's unit.
- **Result:** $0.28 → **$0.20 per accepted question**, 24/24 accepted, and the blind re-judge again found 0
  defects in 24.
- **Cumulative:** −72% from $0.72.
- **Caching:** GPT and Gemini report no cached input through the gateway in any setup, so that lever is closed.
- **Any future fourth-checker swap** must first pass the `calibrate` command against the same known-defect and
  known-clean sets.

The original measurement follows.


Originally measured at about $0.74–0.77 per accepted item. 24 topics took about 14 minutes with four subjects running in parallel, three topics each.
That is 3.5–4.9× the legacy cost per defect-free item, which failed the method test's proposed 3× cost rule.
The rule for that case: tune, don't drop. Levers, in order:
1. A cheaper fourth checker where its smoke test and calibration hold (Kimi K3 was the most expensive checker).
2. Cheaper solve-stage models (the solve prompt is short and needs no fact pack).
3. Generating the second author's candidate only when the first is rejected.
4. Sending only the topic's unit section of the fact pack where that section carries the exclusion statements.

Re-run §0.5 after any cut that could lower the bar.

### 0.8 Scope

| Use | Status |
|---|---|
| **Open Hand teaching MCQs** | Required method. |
| **New scored MCQs** | May use §0 for authoring and checking. They still need serving labels (topic/skill/difficulty, by the voting rules in the Units 1–3 runbook) and the Phase 6 publish gate. Not yet piloted for scored items; pilot one batch before relying on it. |
| **FRQs** | Not covered. §4–§6 and §9 govern. |
| **Variants (Phase 5b) and seeded generation** | Unchanged. Their outputs may be checked with §0's checker stages. |
| **§0 seeds and variants** (`seed_pipeline.mjs`) | Piloted 2026-10-07 on Biology Unit 1: 21/21 seeds and 61/63 variants accepted, 0 defects under blind judging. Rules (DECISION-0101): (1) **difficulty is not an author target**; the four-family vote on each seed is stored only as a `provisional_model` label until it is recalibrated from student attempts. (2) **Skills are targeted at the practice level**; a slot may narrow a practice to the skills a multiple-choice item can exercise. The seed's skill is validated at 3 or more matching votes, otherwise it stays at practice level. (3) **Variants inherit the seed's skill and difficulty labels**, with no re-vote. The variant prompt keeps the seed's validated skill and reasoning demand. |
| **Existing published content** | §4, §5 and §9 govern re-checks. Defects found there are fixed by replacement (§0.6), not by in-place edits, where the item is a teaching item. |

### 0.9 Running it

From `scripts/content-seed/task0065-generate-select/` (or a new batch folder). Generate:

```bash
node ../../vercel-gateway-check/teaching_pipeline/run.mjs run --batch=<dir> --subject=<key> --session=<name>
```

Report:

```bash
node ../../vercel-gateway-check/teaching_pipeline/run.mjs report --batch=<dir>
```

The `report` command writes `accepted.json` (ready for the loader) and `summary.json`. Every model call is
logged to `<batch>/calls.jsonl` for cost. See the README for sharding, resuming and the veto back-fill.

---

## 1. Current state, stated plainly

This is what the pipeline actually does today, verified against the repo and Production
(`pcntajvbdfqhbeewmdry`) this session — not the aspirational version.

1. **Authoring is ad hoc and per-batch.** Content is written in batch folders named by
   subject/unit/date (`scripts/content-seed/calc-ab-bc-units1-3-frq-2026-08-03/`,
   `physics1-2-cmech-cem-units1-3-frq-2026-08-03/`, etc.). Each folder's
   `generate-sql.mjs` turns an already-written JS/JSON literal of questions into `INSERT`
   SQL — it does not call a model. The actual drafting happens upstream of the repo (an
   authoring session, not a logged pipeline step), so **there is no record in the
   database or the repo of which model wrote a given item, what source material it was
   grounded in, or whether it was shown the CED fact pack at all.** That is P0-A (§7.1).
2. **No fact-pack-grounding requirement is enforced at write time.** Nothing checks that
   an authoring pass was given the CED fact pack, let alone the full one.
3. **Human tutor review is real, is a multi-stage state machine, and is where quality
   control currently lives.** It is not the single black box "human review" implies.
   `supabase/functions/review-decision/index.ts` runs it: a **blind group of two tutors**
   (`review_stage='tutor_question'`) each submit a `tutor_score` (1/2/3); the server
   **aggregates** the two (`advanceWorkflow`, lines 117–213) — sum 2 advances to a
   `reader_question` stage, sum 3 → `modification_reserved`, sum 4–6 → `excluded`. The
   reader stage then approves (FRQ → `question_review_approved`; MCQ → fan out
   `tutor_answer` ×4 choices ×2 tutors), recycles (`modification_reserved`), or excludes
   (`excluded`). The outcome of all this lands in **`content_item_versions.review_status`**.
4. **Publishing is a separate, disconnected step, and it reads the wrong column.**
   `review-decision/index.ts` writes `review_status` and never touches
   `content_item_versions.status`. Every `published` transition observed this session
   happened via a hand-run SQL script flipping `status`, with **no code path checking
   `review_status` first.** That is P0-B (§7.2), and it is not hypothetical: this session
   found and repaired 8 AP Biology FRQs, plus flagged (not yet repaired) 1 Chemistry and
   2 Statistics items, that were `status='published'` while their `review_status` was a
   rejection state. The same bug was fixed once before, 2026-07-31 (`ACTIVITY_LOG.md`,
   "7 Disapproved Items Unpublished"), and recurred — because the fix was a one-time SQL
   cleanup, not a standing constraint. **Note the two-column trap:** "disapprove" is not a
   single field. It is an *aggregate* of two blind `tutor_score`s (or a reader
   `disagree`) that resolves to `review_status IN ('excluded','modification_reserved')`.
   A gate written against "latest `tutor_score` = 3" would miss an item excluded by two
   `score=2`s summing to 4 — exactly the class this bug is about. §7.2 specifies the
   predicate correctly.
5. **There is no automated CED-conformance check in production.** The blind dual-model
   check developed this session (§4) is a research prototype run by hand against
   `docs/product/*_CED_FACT_PACK.md`, not a pipeline stage.
6. **Fact-pack depth is uneven — but less uneven than v0.1 claimed.** Corrected after
   direct grep of all nine packs this session:
   - **Deep (topic map + explicit exclusion boundaries + Relevant Equations):** Biology
     (1007 lines, inline `*Exclusion:*` tags and equation blocks per EK), Chemistry
     (177 lines, dedicated "High-risk exclusion boundaries" section, 15 statements).
   - **Partial (topic map + course-level removals/exclusions, but no per-topic inline
     exclusions or equation blocks):** Statistics (164 lines, `## 8. Confirmed removals —
     do NOT author these`, 5 removed topics + "do not conflate" clarifications), Calculus
     AB/BC (155 lines, "AB scope excludes all of Units 9 and 10, linear partial fractions,
     and improper integrals"; "Practice 4 is not assessed in the MCQ section"),
     Precalculus (117 lines, Unit 4 "Not assessed on the AP exam").
   - **Bare (topic titles only, zero exclusions, zero equations):** Physics 1, Physics 2,
     Physics C Mechanics, Physics C E&M (55–64 lines).

   The conformance check (§4) **can run today** for the partial tier against those
   course-level removal lists — it will catch authoring a wholesale-removed topic, though
   not fine-grained within-topic overreach. It **cannot run meaningfully for the four
   Physics packs** — a model asked to find scope violations against a bare topic list has
   nothing to check against and will either hallucinate coverage or under-flag by default.
   This reshapes §7.3: build 4 Physics packs from scratch; deepen 3 partial packs later;
   do not fund a five-subject rebuild.

---

## 2. Inputs the protocol requires before a batch starts

Authoring should not start on a subject/unit until these exist. "Fact-pack tier" uses the
three-way classification from §1.6, not a binary — it determines whether Phase 4 can run,
not whether authoring can start.

| Input | Current status | Owner |
|---|---|---|
| CED fact pack, and its **tier** (deep / partial / bare per §1.6) | Deep: Bio, Chem. Partial: Stats, Calc AB/BC, Precalc. Bare: Physics ×4 | Content ops |
| Target item-type distribution and count for the batch (MCQ vs FRQ, unit coverage) | Set informally per batch folder name; not written down anywhere durable | Content ops |
| Confirmed-reachable writer/verifier model roster for the batch (§3) | Ad hoc per script; no standing smoke test (§7.4) | Eng |
| Reviewer roster with subject qualifications (`validator_qualifications`) and queue depth | Exists, used for assignment (`feedback_content_review_assignment_policy` memory) | Content ops |

A batch against a **partial or bare** fact pack can still be **authored** (the topic map
is enough to write a plausible in-scope question) but Phase 4's coverage is limited
(partial) or impossible (bare). Record the fact-pack hash and tier at check time (§7.1)
so a later fact-pack upgrade knows exactly which items to re-check (§6 Phase 7).

### 2.1 Questions the Product Owner answers before every run (v0.5)

The authoring session asks these **before** a batch is checked or extended, waits for the answers, and records
them in the batch README next to the authoring provenance. It never assumes an answer or reuses the last
batch's answers.

1. **Checker models.**
   - **For a generate-and-select batch (§0, the default for new MCQs):** "Confirm this slate." List the two
     author models and the five checker families, re-listed from the live roster with current prices and an
     estimated batch cost. Every candidate is checked by the four non-author families plus its own family's
     reject-only veto.
   - **For checks that are not §0** (existing content, FRQs, seeded-variant spot checks): "Which two of these
     four checker models do you want?" (the §3.2 menu, with current prices and what each has been tested on).
     The two must be from different families, and neither from the author's family.
2. **Variants.** "**Do you want variants? If yes, how many per question?**"
   - **No answer or "no": no variants are made.** Variants multiply the item count, the review load and the
     model spend, so they are opt-in.
   - **A number k:** each original gets k variants, following Phase 5b below.
   - If the answer is yes but the number is missing, ask again; do not pick a number.

Ask them together in one prompt so the Product Owner can see the cost of both choices at once: the estimated
checker spend for the two picks, and the size of the batch with and without variants (originals x (1 + k)).

---

## 3. Model role assignment — and why each rule exists

Two **separate** independence constraints apply. They protect against different failures
and have different reference points; do not conflate them.

**3.1 Grader-independence** (fully specified in `GOLD_SET_GENERATION_PROTOCOL.md` §3,
R1–R5): applies only when a model's output will later be **graded** by the production
grader (OpenAI). Not in scope for question authoring today; becomes relevant if a future
step has a model draft a **canonical answer** — at which point no OpenAI-family model may
write or verify it. Pointer only; that document governs.

**3.2 Writer-independence** (this pipeline, CED-conformance checking): applies to the
check in §4 — verifying a written question stays inside the CED's declared scope. The
reference point is the **item's own author**, not the grader.

- **The conformance-check model must not share a family with whatever authored the item.**
  Same-family author and checker share a notion of what counts as "close enough" to a
  fact-pack example, so the check inherits the writer's blind spot instead of catching it.
- **At least two independent families check every item, never one** (generate-and-select uses four plus a
  reject-only own-family veto, §0). A single model's verdict cannot
  gate a publish decision — §5 documents the measured, systematic failure modes of both
  models used this session. This is the direct answer to "can we just run one model and
  trust it": no, because each family's errors are systematic, not random noise a bigger
  sample averages out.
- **Checker selection is a menu, not a fixed roster (v0.5).** Before each batch the protocol proposes **four**
  candidate checker models, one per family, spanning reasoning power and cost. The Product Owner picks **two**, as one of the two pre-run questions in §2.1.
  Rules for the pick, which do not bend:
  1. The two picks must be from **different families**. Because the menu has one model per family, any two of
     the four satisfy this.
  2. **Neither pick may share a family with the item's author.** If the author is a menu family, drop that
     model from the menu and pick from the remaining three. (The 2026-09-29 Calc AB batch was authored by
     Claude, so Anthropic models were never on the menu.)
  3. Record the picks, their exact model ids, and the date in the batch's README next to the authoring
     provenance, so a later re-check knows which slate cleared the batch.
  4. A model that has never been used on this pipeline must pass a **smoke test** before its verdicts count:
     valid structured output (`generateObject`) on at least three items, one of which has a table or a
     piecewise definition, and it must reproduce at least the known flags in a small calibration sample
     (the Chemistry items `apchem-frq-l-021` and `apchem-sfrq-035` are grep-confirmed real). A model that only
     works through the plain-JSON fallback is usable but must be recorded as such.
  5. Changing the slate never re-opens already-checked published content (§6 Phase 7, last paragraph), but it does
     require re-measuring the §5 bias table for any model newly used at scale (§7.4).

  **Menu as of 2026-09-29** (prices are gateway list prices, $ per million input / output tokens; they change,
  so re-list them at batch start with `gateway.getAvailableModels()`). "Evidence" is what has actually been
  run on this pipeline, not a claim about the model in general.

  | Slot | Model id | Family | Price in/out | Role | Evidence on this pipeline |
  |---|---|---|---:|---|---|
  | A. Reasoning-strong | `openai/gpt-6-sol` | OpenAI | $2.00 / $10.00 | Highest reasoning on the menu; use when a batch is scope-sensitive (Biology, Chemistry) | none yet: smoke test required |
  | B. Balanced | `google/gemini-3.5-flash` | Google | $1.50 / $9.00 | Fast, strong structured output; a sound default | Calc AB Unit 1 (34 items): 34/34 valid, 0 retries. Its predecessor `gemini-2.5-flash` failed structured output on 11 items |
  | C. Value reasoning | `deepseek/deepseek-v4-pro` | DeepSeek | $0.66 / $1.98 | Cheapest reasoning-class option; good for large batches | none yet for v4. Its predecessor `deepseek-v3.2` ran 34/34 with 0 retries, but over-flags verbatim mismatches (§5.2) |
  | D. Low cost | `alibaba/qwen3.7-plus` | Alibaba | $0.40 / $1.60 | Cheapest acceptable tier; use for high-volume variant sampling, not for first-time scope checks on a new subject | none yet: smoke test required |

  Menu maintenance: replace a slot's model when a newer generation from the same family is available and
  smoke-tested, keep one family per slot, and keep the four slots spanning reasoning power and cost. The
  menu is proposed by the authoring session and ratified per batch by the Product Owner's pick; it is not a
  standing approval to spend on any model.

  **Cost sanity check.** Each call sends the full fact pack with the item. The Calc AB/BC pack is about 80 KB,
  roughly 22,000 input tokens, so one 34-item batch checked by two models is 68 calls and about 1.5 million
  input tokens: on the order of $1.50 to $3 at these list prices, plus a small output cost. A batch against
  a larger pack (Biology, 1,007 lines) costs proportionally more; estimate it at batch start.

> **⚠ §3.2 depends on P0-A.** Writer-independence requires knowing who authored the item, which §7.1 says is
> **not recorded anywhere** in the database. Until provenance columns exist, the author is recorded in the
> batch README (see the Calc AB Unit 1 batch) and the person picking the two checkers must read it.

**3.3 What the adjudicating model (Sonnet, in this conversation) is and isn't.** Sonnet
acted as tie-breaker this session — but **not as a third independent vote.** Every
adjudication was a direct grep of the fact pack against the disputed claim, not a third
opinion. That distinction is load-bearing: a third model's disagreement resolves nothing
(§3.2's whole point is that model disagreement is expected and uninformative on its own);
a grep against the source document resolves it, because the fact pack — not any model's
reading of it — is the authority. §5's adjudication step is **"verify against source,"
not "get a third opinion."** A protocol that resolves disagreement by adding a third model
vote just adds a third systematic bias to reconcile.

---

## 4. The conformance check itself

Prototype, run by hand this session: Biology (8-item pilot, then 20-item random sample)
and Chemistry (20-item random sample); attempted against Physics and found not meaningful
(§1.6). Scripts: `scripts/vercel-gateway-check/apbio_ced_conformance_sample20.mjs`,
`apchem_ced_conformance_sample20.mjs`.

**Per item, blind to the model:** stem, stimulus, rubric criteria (or MCQ choices), and
the **full text** of the subject's CED fact pack. Not shown: which reviewer(s) touched the
item, what decision they made, whether it was flagged before, or the other verifier's
output.

**Ask the model for:** `scope_verdict` (`fully_in_scope` / `contains_out_of_scope_content`
/ `uncertain`); `out_of_scope_concepts` (specific facts/terms the item requires that are
absent from, or explicitly excluded by, the fact pack); `internal_consistency_issues`
(contradictions inside the item — e.g. this session's `apchem-frq-l-010` rubric requiring
"delocalized electrons in molten NaCl", which is chemically wrong); `confidence`;
`reasoning`.

**One prompt rule, learned from observed false positives, that must be pinned in one
place.** The line: *"Do not flag a specific numeric value, named object, or illustrative
example as out-of-scope merely because it isn't verbatim in the fact pack — flag it only
if the underlying mechanism/concept it requires is absent or explicitly excluded."*
Without it, DeepSeek over-flags illustrative examples (§5.2); with it, every flag in the
Chemistry run was grep-confirmed real. **This string is load-bearing and is currently
duplicated across both `_sample20.mjs` scripts.** If it drifts between copies or is
reworded, the false-positive rate silently returns. → Action: extract it (and the schema)
to one shared module both scripts import, so there is a single source of truth.

---

## 5. What the two-model check actually catches — measured this session

Do not run this with one model and treat the output as ground truth. Both models ran
against the identical 20-item Biology sample and agreed on only **60% of verdicts**, and
each has a *different, identifiable, systematic* bias — not independent random noise more
calls would average out.

**These measurements are from one session, one 20-item sample, on pinned versions
(`claude-haiku-4-5`, `deepseek-v3.2`). They are not permanent protocol constants** — the
two-family rationale rests on them, so they must be **re-validated on any checker-slate
change** (§7.4), the way the gold-set protocol re-certifies on a model-slate change.

**5.1 Haiku — visible-and-rationalized, not blind.** Haiku does not miss exclusion text;
it quotes it correctly, then argues why it doesn't apply. Grep-confirmed:
`APBIO-FRQ-L-026` (cleared `fully_in_scope`; excluded cluster — effective population size,
MVP, purging hypothesis, MHC alleles — present in item, absent from pack; caught by
DeepSeek on rerun); `apchem-frq-l-021` (cleared while its own reasoning cites fact-pack
line 139's "do not assess... the formal concept of state functions," then argues part (d),
which requires exactly that, is "not the same as" the excluded thing — it is; caught by
DeepSeek); `apchem-sfrq-035` (same pattern against line 139's buffer-pH-change clause).
Implication: Haiku alone is unsafe — its failure looks like careful reasoning, so
spot-checking the reasoning text rather than the underlying claim won't catch it.

**5.2 DeepSeek — verbatim-matching over-strictness.** Flags ~2–3× more items than Haiku,
often conceding the general principle is in scope one sentence before flagging because a
named example/equation wasn't verbatim. Grep-confirmed false positives:
`APBIO-MCQ-093` ("trophic cascade" is at pack line 974, EK 8.5.B.3), `APBIO-MCQ-002`
(amylase/starch/iodine test naming an in-scope enzyme-substrate principle),
`APBIO-FRQ-L-008` (water-potential equation, an explicitly listed Relevant Equation).
Implication: a DeepSeek-only flag is not sufficient grounds to fail an item without a
grep check.

**5.3 The adjudication rule — the vote is not load-bearing; the grep is.**

| Signal | Action |
|---|---|
| Both models flag the same item | High-confidence real defect. **Still grep-verify the specific claim** before repairing — models cite specifics that can be wrong even when the verdict is right (`apchem-frq-l-010`'s exact wording needed correction, not just confirmation it existed). |
| One flags, one clears | **Not resolvable by model count.** Grep the pack for the specific concept/exclusion named. If the exclusion text exists and the item requires the excluded concept, the flag is real regardless of which model raised it (`apchem-frq-l-021`, `apchem-sfrq-035` were correct single-model flags). If it's a named example of an in-scope principle, it's a false positive regardless of which model raised it. |
| Both clear | Provisionally accept; note it is unverified by a third path (cheap to be wrong — nothing prompted a check). |

---

## 6. Proposed end-to-end sequence

Each phase gates the next **except where noted** — the human-review phase runs as an
autonomous state machine, so Phase 4's scheduling relative to it is specified explicitly.

```
Phase 0  Preconditions       Fact pack present; its tier (§1.6) determines whether Phase 4
                             can run for this batch. Writer/verifier roster confirmed
                             reachable (§7.4 smoke test, once it exists).

         NEW MCQs (v0.6): Phases 1, 2, 4 and 5 are carried out by generate-and-select (§0).
         Its accepted items go straight to the human spot-check and Phase 6. Nothing is
         hand-patched. The phases below remain the method for FRQs and existing content.

Phase 1  Authoring           Model drafts item against the FULL fact-pack text (not a
                             summary). RECORD: authoring model, fact_pack_hash, batch_id.
                             [Blocked on P0-A / §7.1 — not recorded today.]

Phase 2  Structural QA       Mechanical, no model: non-blank stem/choices; correct choice
                             count; each criterion's points_possible present and the
                             criteria sum to the item's declared max points (not an
                             arbitrary target); no competing published version for the
                             same content_key. (Pattern already in every repair script.)

Phase 3  Human review        The review-decision state machine (§1.3): blind tutor pair →
                             aggregate → reader stage → terminal review_status. Runs to
                             completion autonomously via advanceWorkflow.

Phase 4  AI CED-conformance   Two independent-family models, blind (§4). Runs only where
                             Phase 0's tier allows (deep/partial). SCHEDULING: run in
                             PARALLEL with Phase 3, not gated behind it — the two are
                             independent signals (machine-scope vs human-judgment) and
                             serializing them wastes the wall-clock of whichever is slower.
                             Both must clear before Phase 6. Where the tier is bare, skip
                             with an explicit "human-only, not AI-checked" flag on the item.

Phase 5  Disagreement         Grep-adjudicate per §5.3. Never repair on a model's unverified
         adjudication         citation — confirm the specific claim against the source first.

Phase 5b Variants (optional)  ONLY if the Product Owner said yes in §2.1, and ONLY after the originals have
                             cleared Phase 4/5 (a defect found in an original is fixed first: every
                             variant inherits it otherwise). For each original, author k variants:
                             separate content_items with their own content_keys (a variant is never a new
                             content_item_versions row; that mechanism is for edits to the same question).
                             By default a variant changes BOTH the numbers and the context, keeps the same
                             skill and the same misconception targets for its distractors, and must differ
                             from its original and its siblings in more than constants. Every variant carries
                             an independent recomputation of its answer (§9 discipline; never parse the keyed
                             text), stems are checked for near-duplication (similarity below 0.7 to the
                             original and to siblings), and correct-answer positions are drawn at random
                             across the set with no triple sharing one letter. Record the variant count and
                             which original each came from. Phase 4 then runs on the ORIGINALS in full and on
                             a SAMPLE of variants (at least one per original, and every variant whose function
                             family or setting differs from its original); Phase 3 reviews originals in full
                             and spot-checks variants. Each variant still needs its own Phase 6; a variant is
                             not publishable just because its original is.

Phase 6  Publish gate         status='published' allowed ONLY from an allowlist of
                             terminal-approved review_status values (§7.2), AND ONLY after
                             §9 independent re-derivation has re-solved every MCQ answer
                             key and FRQ criterion from first principles and found no
                             disagreement with the stored content (§9, adopted v0.4).
                             Blocked for any rejection, in-progress state, or unresolved
                             §9 disagreement. [Blocked on P0-B / §7.2.]

Phase 7  Event-driven         NOT a periodic resample — published content does not drift.
         re-check             The only things that change are the checker model, the fact
                             pack, or the item version, so re-check is triggered by events,
                             and P0-A's provenance makes each target set a query:

                             (a) disapproved-but-published cross-check — TEMPORARY net
                                 until P0-B's constraint exists; then belt-and-suspenders.
                             (b) fact pack version changes → re-check every published item
                                 whose recorded fact_pack_hash != the new hash
                                 (WHERE fact_pack_hash = <old>). This is what a corrected
                                 Biology pack, or newly-built Physics packs, triggers.
                             (c) item gets a new version (edit/remediation) → that version
                                 re-enters Phase 4. This is just the forward path, not a
                                 sweep.
                             (d) backfill — items published before any check, or checked
                                 against a shallower pack tier: one-time, converges to zero,
                                 identified by "no conformance record at current tier."

                             A checker-MODEL change does NOT trigger a content re-check
                             (the content didn't change; a new model's flags are its own
                             biases, §5). It triggers re-validation of the §5 bias table
                             instead (§7.4).
```

---

## 7. Gaps that block enforcing this — ranked

### P0-A — No authoring provenance (§7.1)

Nothing records which model wrote an item, against which fact-pack version, in which
batch. Consequences: §3.2 (writer-independence) is inert (§3.2 callout); Phase 7's
event-driven re-check has no way to compute "which items were checked against the now-stale
pack" (Phase 7b/d); and no audit can distinguish an authoring-prompt fix from a one-off
content fix. **Minimal fix:** columns on `content_item_versions` (or a sidecar table) for
`authored_by_model`, `fact_pack_hash`, `fact_pack_tier`, `batch_id`, plus
`conformance_checked_at` / `conformance_result` once Phase 4 is wired. This is the
first-priority change because two other rules depend on it existing.

### P0-B — Publish is not gated on review outcome (§7.2)

The concrete, recurring bug (§1.4). **Specify the gate against `review_status`, as an
allowlist, not a denylist:**

- **Publishable review_status (allowlist):** `question_review_approved` (FRQ terminal
  approve) and the MCQ answer-review terminal state reached after the `tutor_answer`
  fan-out completes. Confirm the exact MCQ terminal value against `advanceWorkflow` /
  the `tutor_answer` completion path before writing the constraint — it is not one of the
  values shown in the tutor/reader excerpt (`ap_reader_pending`,
  `answer_tutor_review_pending`, `difficulty_discussion`, `question_review_approved`,
  `modification_reserved`, `excluded`), which are intermediate or rejection states.
- **Everything else is blocked**, including in-progress states — an allowlist fails safe
  when a new `review_status` value is added later; a denylist of `('excluded',
  'modification_reserved')` would silently pass a future rejection state nobody remembered
  to add.

**Implement as one of:** (1) a trigger/constraint on `content_item_versions` refusing
`status='published'` unless `review_status` ∈ allowlist; or (2) move the publish
transition into `advanceWorkflow` (`review-decision/index.ts`) as one more state
transition, since it already computes the terminal `review_status` — one code path
instead of ad hoc SQL scripts each re-implementing (or forgetting) the check. Option (2)
is the more durable home. Phase 7(a) stays as a detection net even after the gate exists —
defense in depth, not a substitute.

### P1 — Fact-pack depth for the Physics tier (§7.3)

Corrected scope after §1.6: **the four Physics packs** (55–64 lines, zero exclusions,
zero equations) need building from scratch to the deep bar before Phase 4 can run for them
at all. **Statistics, Calculus AB/BC, and Precalculus already have course-level removal/
exclusion lists** and can be conformance-checked against those today (partial coverage);
deepening them to per-topic inline exclusions is a later improvement, not a blocker. Do
not fund a five-subject rebuild — it is a four-subject build plus a three-subject deepen,
sequenced by which subject has the most content already published against its current
pack (uncounted — see §10).

### P2 — No standing model-roster smoke test (§7.4), and no bias re-validation

Two related pipeline-health gaps: (a) borrow the gold-set protocol's Phase 0.2 pattern
(≥19/20 schema-valid calls before trusting a checker family) as a standing gate — Kimi's
100% failure was found by ad hoc testing, and the next broken family will be too without
this. (b) On any checker-slate change (new family, version bump, swap), **re-validate the
§5 bias table** on a fresh sample before relying on the documented Haiku/DeepSeek behavior
— those numbers are version-specific and will go stale. Neither is release-blocking, but
both erode silently if left to memory.

---

## 9. Existing-content QA — independent re-derivation

**Status:** Adopted, 2026-08-08 — a standing, publish-gating pipeline stage, promoted from
pilot after a 212-item run across all 10 subjects (not just Physics) confirmed the method
at production scale (see the v0.4 revision note above and §9.3's updated table). This is a
**second, distinct** QA method from §4's CED-conformance check — the two ask different
questions, catch different defect classes, and neither substitutes for the other. Every
item must clear both before Phase 6 (§6) allows publish.

**9.1 What it is, and how it differs from §4.** §4 asks *"does this item stay inside the
CED's declared scope?"* — a blind model panel checks the item against the fact pack's text
and needs at minimum a partial-tier pack to have anything to check against (§1.6). §9 asks
*"is the stored stem/stimulus/rubric/answer-key actually correct?"* — an agent independently
re-derives the item's answer from first principles (the physics/math/reasoning, not the
fact pack) and diffs the result against what is stored. It requires no fact pack at all,
works at any tier including bare, and catches a different class of defect: not scope
overreach, but wrong distractor rationales, self-contradictory rubric text, physically
false claims embedded in "correct" reasoning, and rubric criteria that don't actually
grade what the stem asks. It is the QA-direction application of the same discipline
Phase 1 (§6) requires of authoring: ground every claim, hand-verify every computation,
before trusting it — applied to content someone else already wrote, not content being
drafted now.

**9.2 Method.**

1. Select a pool (§9.3 — this is the step that determines whether the pass is worth
   running at all).
2. For each item, read the stem/stimulus/rubric-criteria-or-choices exactly as stored, plus
   (if repairing against a specific reviewer note) the note itself.
3. **Independently re-solve the item from scratch** — do not read the stored answer key
   first and check it "looks right." Derive the numeric or logical answer, show the work,
   then compare to what is stored.
4. Where they disagree, determine whether the stored version or the independent derivation
   is correct — this can itself surface a *third* possibility: both are wrong in different
   ways (found twice this session, §9.3 examples).
5. Any fix goes through the same insertion discipline as new authoring (§9.4) — never edit
   a `content_item_versions` row in place; insert a new version.

**9.3 Pool selection matters more than the method — measured this session.**

| Pool | n | Real defects found | What this means |
|---|---|---|---|
| Single `approve`, never edited, never repaired | 25 | 0 confirmed defects (1 minor data-completeness gap: `apphy1-mcq-021` had a null `canonical_answer_1`, though the actual answer key in `mcq_choices.is_correct` was right) | Content that already cleared one human reviewer has a **low** independent-defect rate. Resampling this pool blind is expensive per real finding. |
| Single `approve_with_edits`, repaired against the reviewer's own note | 25 | 2, **beyond what the note itself said** — `apphy1-mcq-022`'s distractor rationale asserted a physically false claim ("constant orbital speed gives T∝r^(1/2)"; it actually gives T∝r), and `apphycem-mcq-007`'s distractor rationale directly contradicted its own choice text | A human reviewer's note tells you *where* to look, but re-deriving the physics independently — not just implementing the requested edit literally — is what catches defects the reviewer themselves didn't articulate. |
| Targeted structural-pattern scan (a specific hypothesis — "is the pasted-prompt-rubric defect systemic?" — checked with a SQL substring match, not model re-derivation) | 126 (68 E&M + 58 Mechanics FRQs) | 31 confirmed (22–28% of the pool) | By far the highest yield of the three. A **named, specific defect hypothesis** checked mechanically beats blind re-derivation over an unfiltered pool. |

**The actionable takeaway:** do not spend this method's cost on blanket resampling of
already-approved content — the yield is low. Spend it on (a) content that has never been
independently checked at all, (b) repair work, where re-deriving from scratch catches more
than literally implementing the requested edit, or (c) a specific, named defect-pattern
hypothesis (the way §5 catches DeepSeek's verbatim-matching bias or Haiku's
visible-and-rationalized bias by name) — pattern-hunting outperforms undirected sampling
by roughly an order of magnitude on this session's numbers.

**9.4 Remediation mechanics, and the schema gotchas that only surface once you try to
correct something.** Every fix uses the `owner_remediation_approval` pattern already
established for defect-fix batches: insert a new `content_item_versions` row
(`version_num` + 1, never edit the existing row), insert its `frq_criteria` /
`mcq_choices`, insert a `content_review_assignments` row
(`assignment_purpose='owner_remediation_approval'`) and a matching
`content_review_decisions` row (`tutor_score=1`), then set `content_items.status` to
`reviewed_approved`. Three constraints bit this session's remediation batch and are worth
recording so they don't have to be rediscovered:

- **`lock_content_review_submission` requires the assignment to be `pending` or
  `in_progress` at insert time**, not `submitted` — it flips the assignment to `submitted`
  itself as a side effect of the decision insert. Inserting the assignment as
  already-`submitted` and then trying to attach a decision fails with
  `review_submission:assignment_locked`.
- **`content_review_decisions.decision_hash` is `NOT NULL`** with no default — supply one
  (`md5(version_id::text || reviewer_id::text || batch_tag)` is sufficient; it does not
  need to be cryptographically meaningful, just present).
- **`content_review_decisions` is immutable by design** — a trigger
  (`prevent_review_decision_mutation`) unconditionally blocks `UPDATE`/`DELETE`, by the
  same write-once philosophy as `gold_set_element_marks`. The documented correction path is
  `supersedes_id`, but **superseding still needs a fresh `pending` assignment on the same
  version**, and a uniqueness constraint (`content_item_version_id, reviewer_id,
  review_stage`) blocks a second assignment for the same reviewer+version+stage. In
  practice this means a wrong remediation cannot be undone by superseding on the same
  version — it requires **a further new version** (found and executed live this session,
  correcting a misapplied fix on `apphycm-frq-018`: reverted the content verbatim to the
  pre-mistake version, then inserted a normal new decision on that reverted version
  explaining the correction and pointing at the item that was actually supposed to be
  fixed). Write this down once here rather than rediscovering it under time pressure again.

**9.5 Standing recommendation.** Do not run §9 as a periodic full-corpus sweep — §9.3's
yield table is the argument against it. Run it (a) whenever a defect *pattern* is
hypothesized (a reviewer note, a QA finding, or a spot-check surfaces something that might
recur — check whether it does, mechanically, before assuming it's isolated), and (b) as
the verification step whenever repairing flagged content, never as a blind resample of
content that already cleared review.

---

## 10. Explicit non-goals

- Does not cover the grading/gold-set pipeline (`GOLD_SET_GENERATION_PROTOCOL.md` governs
  that) — shared conventions, not shared process.
- Does not decide **which** flagged-but-unrepaired items get fixed now vs. batched
  (`apchem-frq-l-001`, `APSTATS-MCQ-015`, `APSTATS-SFRQ-018`, plus Chemistry's three §5
  conformance findings: `apchem-frq-l-010`, `-021`, `-035`) — a scheduling decision.
- Does not pick which Physics pack is built first, or which partial pack is deepened first
  (§7.3) — depends on published-item counts per subject, which nobody has counted yet.
- Does not claim §9's three-pool comparison (n=25, n=25, n=126, one session, one subject
  family) is a statistically settled yield ratio — it is a directional finding strong
  enough to guide pool selection, not a constant to cite without re-checking on a
  different subject or a larger sample.
