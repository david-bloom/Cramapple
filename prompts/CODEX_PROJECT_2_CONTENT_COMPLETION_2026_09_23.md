# Codex Project 2 — Content Completion (work orders E–I)

DATE: 2026-09-23 | RUNS: long-run, unattended, multi-session
MODE: **Proposal only. Read-only against Production. No writes to published content, ever.**

Successor to the overnight A–D run. Read `CODEX_OVERNIGHT_RUN_PROTOCOL_2026_09_22.md` first —
its rules on count mismatches, pre-existing artifacts, committing and partial completion apply
unchanged to every work order here.

---

## Authoring authorisation — Codex is the named drafter

Work orders F and G assign Codex genuine canonical-answer authorship. **This is explicitly
authorised by an approved decision, not by this charter.** The canonical-answer decision states:
*"Codex drafts full-point answers from each FRQ's rubric (it is the drafter only, writes to
reviewable staging files, not the database); a separate, independent, non-OpenAI model runs the
QA/verification pass."*

`DECISION-0045`'s stricter constraint — *"no OpenAI model may write or verify; three non-OpenAI
families required"* — governs **certified gold sets used to evaluate graders**, a different lane.
The same decision draws the line explicitly: *"Authored canonical ≠ certified gold set (holds
DECISION-0045's line)."* Do not treat a canonical answer you author as gold-set evidence, and do
not author or verify anything in the gold-set lane.

Two consequences that bind this project:

1. **You draft; you never verify your own drafts.** QA is a non-OpenAI model.
2. **A full-point answer is an answer key** and is never exposed to a student before they submit.

## What this project is NOT

**It is not the QA of work orders A–D.** Those four produced proposals that are now awaiting
independent cross-model QA under DECISION-0055, which requires a **different model from the
builder**. Codex QA-ing its own output is the exact failure mode that produced the
`canonical_answer_2` defect (49 items re-drafted because the first run only read one field) and
last night's AP Statistics topic-label rejection. **Do not QA A, B, C or D. Do not modify their
directories.** Claude holds that gate.

What you may do is act on QA results once they exist — see work order E, which is a rework of a
run already QA'd and rejected.

## Library state, verified read-only 2026-09-23

| Subject | Items | FRQ | MCQ | FRQ with no canonical answer |
|---|---:|---:|---:|---:|
| ap-statistics | 384 | 80 | 304 | 46 *(work order B proposes these)* |
| ap-calculus-bc | 127 | 64 | 63 | **29** |
| ap-calculus-ab | 122 | 62 | 60 | **33** |
| ap-chemistry | 119 | 51 | 68 | 1 |
| biology | 118 | 75 | 43 | 7 *(work order A addressed these)* |
| ap-physics-1 | 117 | 54 | 63 | **39** |
| ap-precalculus | 117 | 64 | 53 | **32** |
| ap-physics-c-em | 97 | 49 | 48 | **39** |
| ap-physics-c-mechanics | 77 | 36 | 41 | **29** |
| ap-physics-2 | 68 | 28 | 40 | **19** |
| **Total** | **1,346** | **563** | **783** | **274 (49% of all FRQ)** |

Nearly half the FRQ library has no canonical answer. Once A and B land that is **221 items across
six subjects** — the single largest content gap in the product, and the substance of work order G.

## Shared rules — every work order below

1. **Read-only against Production** (`pcntajvbdfqhbeewmdry`). No `INSERT`/`UPDATE`/`DELETE`, no
   migrations, no edge-function deploys. Propose in files; never write to the database.
2. **Fill gaps; do not replace.** Existing canonical answers, rubrics, criteria, labels and author
   prose are prior work. Where existing content looks wrong, **flag it** — never overwrite it.
   *(One scoped exception, DECISION-0056: work order F may remove uncredited prose its own new span
   supersedes, under the conditions in F requirement 5. It applies to F only — not to G, H or I.)*
3. **Never invent a criterion** outside an item's stored rubric. Never invent a topic code outside
   the closed list.
4. **State the `WHERE` behind every count.** On a mismatch apply the protocol's tiered rule: at
   ≤10% drift where the premise holds, proceed with the observed set and record the delta; above
   10%, or a missing required input, produce the packet plus a discrepancy report and move on.
5. **One directory per work order.** Never write into another's. Never create or edit
   `qa_findings.csv` or `qa_report.md` — those belong to the QA model.
6. **Commit and push per work order** to `codex/project2-2026-09-23`. No PR, no merge to `main`.
   *(A–D reached `main`; that was a deviation. Proposals belong on a branch until ratified.)*
7. **Partial completion is acceptable and must be honest.** Finish the item you are on, then report
   exactly what is complete and what was not attempted. Never degrade quality to finish a list, and
   never report a partial run as complete.

## Shared QA-preparation contract

Every work order produces artifacts a *different* model must be able to recompute without access to
your reasoning.

**Applies to every order:**

- **`packet.jsonl`** — model-neutral inputs only, re-derivable from Production. QA diffs it against
  its own read; if they disagree the run is invalid regardless of proposal quality. Never mix
  inputs and proposal in one file.

**Proposal shape depends on the kind of work** *(corrected 2026-09-23 — an earlier draft applied the
span schema to all five orders, which is wrong for topic labels and cleanup):*

| Orders | Proposal shape |
|---|---|
| **F, G** (canonical answers) | `full_text`; `spans[]` each carrying `text` + `criterion_keys[]` + `provenance` + `source_field` + `source_offset` where recovered; a `coverage` object naming covered and uncovered criteria explicitly; `derivations[]` for every numeric value |
| **E, H** (topic labels) | the topic-label CSV schema — one row per item with the evidence fields named in each order |
| **I** (cleanup) | dedicated proposal CSVs, named in the order |
- **`SUMMARY.md`** written last, carrying an **invariant table with your own measured result for
  each row**, the counts, your open questions, and a lowest-confidence-first ranking so QA can spend
  its budget where you are weakest. **If an invariant fails, report the failure — never adjust the
  invariant.**
- **Reproducibility metadata**: UTC start/end, model identifier, Production project ref, the UTC
  time of your snapshot, and the maximum `version_num` seen per item.
- **Self-flagged weak points.** Volunteering them makes your run more credible, not less.

An automated harness (`scripts/qa/overnight_qa_harness.py`) recomputes these invariants. It expects
exactly the field names above. Emitting a different shape does not hide a defect; it produces a
missing-artifact error and a slower review.

---

# Work order E — AP Statistics topic labels, rework

**Directory:** `docs/research/apstats_topic_labels_rework_2026_09_23/`
**Priority: highest.** This unblocks GAP-1 for a subject with 384 published items.

## Why this is a rework

`docs/research/bio_stats_topic_tagging_2026_09_22/` was independently QA'd on 2026-09-22.
**AP Biology was ACCEPTED. AP Statistics was REJECTED.** Read `qa_report.md` and
`qa_findings.csv` in that directory before starting — they are the specification for this rework.

The structure was flawless: 502/502 items, every code valid in the closed list, zero unit
mismatches. **The content was not.** 56 Statistics items carried a demonstrably wrong topic, and
the errors were template-shaped rather than random:

| Defect class | Items | What went wrong |
|---|---:|---|
| Compare-two-groups labelled `1.7` | 20 | `1.7` is summary statistics for **one** variable; these compare two groups, which is `1.9` |
| Sampling-**method** items mislabelled | 11 | One got `4.1 Sampling **Distributions** for Sample Means` — a different concept entirely |
| Graph-construction items labelled from a boilerplate stem | 24 | Stem is only "Submit one photograph…"; no topic is derivable from it |
| Regression/slope placed in Unit 1 | 5 | Unit 5 is Regression Analysis |

Two codes absorbed **45%** of the corpus (`1.3` 92 items, `1.7` 81).

## Root causes to fix — these are the work order

1. **The stem was treated as sufficient.** For templated MCQ and graph items the stem carries little
   or no signal. Build your classification evidence from **stem + stimulus + rubric criteria +
   `prompt_json.subtopics`**. Short AP Statistics stems keep their content in `stimulus`.
2. **Adjacent-topic ties were resolved consistently in the wrong direction.** Before labelling, run
   a **template pre-pass** that detects these four families and routes each to its correct topic
   family rather than letting the general classifier guess:
   - `apstat-compare_stats-*` and any "records X for two groups … compare" → `1.9`
   - "Sampling plan: … Which choice best describes the sampling method?" → `1.11` / `1.12`
   - `APSTATS-HDG-2026-GRAPH-*` → derive from rubric/stimulus, or `undetermined`
   - regression / slope / correlation / residual / least-squares → Unit 5
3. **A plausible default was emitted where a flag was correct.** You may now output
   `proposed_topic_code = "undetermined"` with `needs_human=true`. **An honest `undetermined` is a
   better result than a confident wrong code.** The prior run emitted zero.

   `undetermined` is a **sentinel, not a closed-list code**: leave `proposed_unit` and
   `proposed_topic_title` blank, and expect QA to count valid registry codes and `undetermined`
   rows separately rather than treating the sentinel as an invalid code. The QA harness was updated
   on 2026-09-23 to recognise it.

## Scope and closed list

All **384** published `ap-statistics` items. Closed list: `taxonomy_source_version`
`dae3c72e-82ca-4960-9552-1b034bd347e5`, **55 topics across 5 units**.

**The current AP Statistics CED has five units, not nine** — Exploring One-Variable Data and
Collecting Data; Probability, Random Variables and Probability Distributions; Inference for
Categorical Data: Proportions; Inference for Quantitative Data: Means; Regression Analysis. The
content's own `prompt_json.subtopics` strings use the **legacy 9-unit** numbering (`Unit 6:`,
`Unit 7:`, `Unit 9:` all appear). **Do not treat author unit numbers as agreeing or disagreeing
with the registry** — they are a different CED edition. Use the subtopic *prose* as a topical hint
and ignore its unit number.

Registry `subject_key` is `ap_statistics` with an underscore; content is `ap-statistics` with a
hyphen. **Normalise or you match zero rows.**

## Required evidence columns

Beyond the topic-label schema, every row must carry `previous_topic_code` (what the rejected run
proposed), `defect_class` (which of the four named classes this item fell into, or blank) and
`evidence_fields_used` (which of stem / stimulus / rubric / subtopics actually drove the decision).
Those three make the before/after comparison mechanical instead of a manual diff.

**Preserve the rejected proposal as comparison evidence; never copy its label as a default.**

**The four defect-class counts overlap and must not be summed.** The graph-item class spans both
Biology and Statistics, which is why 20 + 11 + 24 + 5 exceeds the 56 affected Statistics items.
Report **unique affected items** plus per-class membership.

## Success criteria

- Every one of the 384 items carries exactly one closed-list code **or** `undetermined`.
- **Zero items in the four named defect classes carry their previous wrong code.** Report each
  class explicitly with before/after.
- **Report topic concentration; do not engineer it.** Concentration above ~25% on one code is a
  *diagnostic* that exposed the last run, **not proof of error and not a target**. If a topic is
  legitimately common in this bank, label it that way and say so. Never move a label off its correct
  topic to flatten a distribution — that would trade a visible failure for an invisible one.
- Report `high`/`medium`/`low` confidence honestly. The prior run reported **zero `high`** across
  502 items; if that repeats, say so rather than inflating.

---

# Work order F — AP Biology, the 88 still-drafted criteria

**Directory:** `docs/research/apbio_drafted_criteria_2026_09_23/`
**Depends on:** work order A's output being QA'd and accepted. **Do not start F until Claude's QA
report exists in `apbio_canonical_recovery_2026_09_22/`.** If it does not, skip F and move to G.

**Gate status, 2026-09-23:** `qa_report.md` and `qa_findings.csv` now exist in
`apbio_canonical_recovery_2026_09_22/`. A's disposition is **accepted, except `APBIO-FRQ-S-073`
criterion `a`**. **F is unblocked.** An earlier run recorded a gate skip for F when the report did
not yet exist; that skip is superseded. **Read `qa_report.md` and `qa_findings.csv` before starting
— three of the five findings are yours to close and are specified in §Requirements below.**

## What is left, and why recovery cannot close it

Work order A recovered **13** of the 101 previously-drafted in-scope Biology criteria. **88 remain
drafted.** The recovery hypothesis was that the 2026-08-12 rubric split left recoverable answer
text behind. QA re-derived the reason it yielded so little, and it is sharper than "the split
created new criteria": **for all 41 rubric-split items the prior version's canonical answers are
byte-identical to the published ones.** Recovering "from the prior version" was therefore the same
operation as reusing the current answer, which the accepted prior run had already done. There was
never any additional text to recover for those 41; the retired parent `APBIO-FRQ-L-025` was the
only genuinely new source, and all 13 recoveries came from it. **The drafted-content problem is
real and must be authored, not recovered.**

Your job: for each of the 88, author an answer span that actually earns its criterion, grounded in
`docs/product/AP_BIOLOGY_CED_FACT_PACK.md` and the item's own stem and stimulus.

## Requirements

1. **Work criterion by criterion.** The rubric's `learner_facing_text`, `evidence_requirements` and
   `minimum_fix` state what earns the point. Write what a student writes to earn it — **not an
   instruction about what to write.** "The distribution is skewed left because most values cluster
   high" is an answer; "make sure your response identifies skew" is a restatement. The QA harness
   fails any span containing second-person rubric phrasing.

   **1a. Declarative restatement is the failure mode that actually occurred — guard against it
   explicitly.** A's QA measured all 88 of A's drafted spans against their own
   `learner_facing_text`: **mean word-level similarity 0.582, 33 at or above 0.70, 15 at or above
   0.85, and three character-identical** (`APBIO-FRQ-S-021` `a1`, `APBIO-FRQ-S-028` `b1`,
   `APBIO-FRQ-S-052` `b1`). None of those three contains second-person phrasing, so **the guard in
   requirement 1 would pass every one of them.** Many of these criteria are written as declarative
   content statements, which makes copying them the path of least resistance.

   For every span you author, compute word-level similarity to that criterion's
   `learner_facing_text` (case- and punctuation-normalised tokens, `difflib.SequenceMatcher`):

   - **≥ 0.85 — do not emit.** Re-author from the stem, stimulus and fact pack.
   - **0.70–0.85 — emit only with a `restatement_justified` flag** naming what the span adds beyond
     the criterion (a mechanism, a derivation, a value, a link to the stem).
   - **< 0.70 — no action.**

   Report the distribution in `SUMMARY.md` — count and mean, not just the maximum. These thresholds
   are QA-derived, not ratified; if the Product Owner sets different ones, they govern.

   A canonical answer that reproduces its rubric cannot be used to validate that rubric, and it is
   thin as the post-submission exemplar a student sees. **The point of F is the reasoning the rubric
   omits.**
2. **Preserve everything A recovered.** Recovered spans are vetted content. Reuse them verbatim and
   author only into the gaps.

   **2a. One exception, and only this one: `APBIO-FRQ-S-073` criterion `a`.** QA finding A-QA-001
   rejected it. The stem sets **2n=4**, so each of the four products of meiosis II holds **two**
   chromosomes, each a single chromatid — meiosis II separates sister chromatids and does not reduce
   chromosome number. A's drafted span says "four cells each contain one chromosome," which is wrong
   and also contradicts the same item's retained canonical text ("meiosis II separates sister
   chromatids"). **Author the correction yourself from the stem; do not copy a correction out of the
   QA report.** The QA model found the defect, so it must not also be the author of the fix — that
   is the model separation DECISION-0055 exists to protect. Criterion `a` is worth 2 points and
   covers both meiosis I and meiosis II; the meiosis I half of A's span is correct.
3. **Re-segment the full answer** so spans still concatenate exactly to `full_text` and every
   criterion is covered.
4. **Flag cross-criterion entanglement** — where one sentence earns two criteria, so deselecting one
   leaves an artifact. A found 23 such cases in the prior run; expect more as you author.
5. **Remove uncredited prose your new span supersedes — authorised, and narrowly.** QA finding
   A-QA-004 measured **46 uncredited recovered sentence-spans across 33 items** (5,661 characters)
   sitting ahead of drafted spans that restate the same point, so the assembled answer says the same
   thing twice — clearest at `APBIO-FRQ-S-021`, `APBIO-FRQ-S-058` and `APBIO-FRQ-S-023`. **30 of
   those 33 items are in your scope.**

   **DECISION-0056 (Product Owner direction, 2026-09-23) authorises removal for this work order**, as
   a scoped exception to shared rule 2 ("fill gaps; do not replace"). The exception is narrow:

   - Remove a span **only if** it carries no `criterion_keys`, **and** its provenance is
     `recovered_*` or `unchanged_from_prior_run`, **and** a span you authored in this run now covers
     the same content for a criterion of the same item.
   - **Never** remove a span that earns a criterion, and never remove text because you consider it
     poorly written. This is a redundancy exception, not an editing licence.
   - **Log every removal** in a `removals.csv` in your directory: `content_key`, the removed text
     verbatim, its character count, its provenance, its `source_version_id`, and the criterion whose
     new span supersedes it. QA re-derives every removed span against Production, so a removal you
     cannot justify from that table is a finding.
   - Nothing is deleted from Production. You are changing the assembled proposal, not the stored
     canonical answer — the original remains in A's directory and in Production either way.
   - Where removal changes the assembly, spans must still concatenate exactly to `full_text`.

   Out-of-scope items `APBIO-FRQ-S-061`, `APBIO-FRQ-S-063` and `APBIO-FRQ-S-064` carry the same
   redundancy but have no drafted criteria; leave them alone and list them in `SUMMARY.md`.
6. **Out of scope, unchanged:** the 4 `APBIO-HDG-2026-GRAPH-*` items (they need a spatial canonical
   on the Engine 4 path) and the 9 point-total mismatches (work order I). Also outside F, and left to
   A's record: `APBIO-FRQ-S-061`, `APBIO-FRQ-S-063` and `APBIO-FRQ-S-064` carry redundant uncredited
   prose but have no drafted criteria, and QA findings **A-QA-003** (a stale `fully_drafted_answer`
   flag on `S-101/102/103`, contradicted by their own 100%-recovered coverage) and **A-QA-005** (the
   `S-102` `b-iii`/`b-iv` connective entanglement, disclosed in A's `SUMMARY.md` prose but absent
   from its `flags[]`) are metadata defects in A's own artifacts. **Do not edit A's directory to fix
   them** — one directory per work order. They are recorded in A's `qa_findings.csv` and are closed
   by the Product Owner accepting them as known, or by a later rework order.

---

# Work order G — canonical answers for the remaining seven subjects

**Directory:** `docs/research/multisubject_canonical_answers_2026_09_23/`
**The largest item in this project: 221 FRQ.** Run it subject by subject, committing after each.

## Subject sequence and scope

| Order | Subject | FRQ with no canonical | Why this position |
|---:|---|---:|---|
| 1 | ap-physics-1 | 39 | Largest gap; highest-enrolment physics course |
| 2 | ap-physics-c-em | 39 | Largest gap after Physics 1 |
| 3 | ap-calculus-ab | 33 | Highest-enrolment maths course |
| 4 | ap-precalculus | 32 | |
| 5 | ap-calculus-bc | 29 | Shares much content with AB; do it after AB |
| 6 | ap-physics-c-mechanics | 29 | |
| 7 | ap-physics-2 | 19 | Smallest gap |
| 8 | ap-chemistry | 1 | **Its own clearly-labelled micro-batch**, not folded into another subject |

**Complete a subject before starting the next**, and commit per subject. A truthful "three subjects
complete, five not attempted" is a good outcome; eight half-done subjects is not.

Write a **per-subject completion manifest** inside the single G directory — `<subject>/manifest.json`
recording items attempted, items completed, and the UTC window — so an honest partial run is
mechanically verifiable rather than a prose claim.

**STOP-for-QA between subjects.** The governing decision on canonical answers requires Biology
drafts to be QA-verified before Statistics generation begins. Apply the same rule here: **finish a
subject, commit it, and do not begin the next subject's authoring until that subject's QA
disposition exists** — unless the Product Owner waives the gate in writing. If QA has not run,
stop and report rather than running ahead.

## Requirements

Identical in shape to work order B, which you have already run for AP Statistics. Per item: author
a full-credit answer earning **every** stored criterion, segment it into criterion-tagged spans,
and record a **`derivations[]` entry for every numeric value** in the answer, naming the inputs it
came from. That field is what lets a second model re-derive your arithmetic instead of trusting it.

Two subject-specific cautions:

- **Physics and Calculus answers are heavily quantitative.** Re-derive every value from the stem
  and stimulus. If a value cannot be derived from what the item provides, **flag it — do not invent
  it.** An invented-but-plausible number is the most dangerous output in this project.
- **Check for a recoverable prior version first**, as in work order A. For AP Statistics this was
  worthless (0 of 46 had prior text) and the order said so; for these subjects it is **unknown**.
  Run the check, report the number, and recover before authoring wherever text exists.

---

# Work order H — topic labels for the remaining six subjects

**Directory:** `docs/research/remaining_subjects_topic_labels_2026_09_23/`
**Depends on:** work order D's output being QA'd and accepted, since H repeats D's method at scale.

## Scope

**603 items** across the six subjects not covered by D (Calculus AB, Chemistry) or by the
Biology/Statistics work:

| Subject | Items | Already carry a valid CED topic code |
|---|---:|---:|
| ap-calculus-bc | 127 | 17 |
| ap-physics-1 | 117 | 33 |
| ap-precalculus | 117 | 19 |
| ap-physics-c-em | 97 | 26 |
| ap-physics-c-mechanics | 77 | 27 |
| ap-physics-2 | 68 | 27 |
| **Total** | **603** | **149** |

**Recover first**, exactly as in D: 149 items already carry an author-time code. Validate each
against the item's content, flag `content_disagrees` rather than overwriting, and derive only the
remaining ~454.

**Carry work order E's lessons forward even though this is a different subject set:** build evidence
from stem + stimulus + rubric, run a template pre-pass before classifying, allow `undetermined`, and
watch topic concentration. The failure mode is not inventing codes — the closed list prevents that —
it is confidently assigning the wrong one to a whole template family.

**Physics topic strings need care.** Several Physics FRQ carry unit *names* rather than topic codes
in `prompt_json.topic` ("Fluids", "Oscillations", "Electric Circuits"). Those are unit-level, not
topic-level: treat them as a unit hint, not a recoverable code.

---

# Work order I — mechanical cleanup

**Directory:** `docs/research/mechanical_cleanup_2026_09_23/`
**Lowest priority. Good filler when a larger order finishes early.** Small, bounded, low risk.

Artifacts: `packet.jsonl`, `point_total_proposal.csv`, `rubric_type_proposal.csv`,
`open_questions.csv`, `SUMMARY.md`.

## I.1 — Point-total mismatches

**10 items** where `prompt_json.total_points` disagrees with the rubric sum: 9 AP Biology
(`APBIO-FRQ-L-004/006/012/013/015/016/017/019/021`, all stating 8 against a rubric summing to 9)
and 1 AP Chemistry.

The 9 Biology items share an **identical** rubric shape — `a=1, b=3, c=3, d=2` — so this is one bad
authoring template, not nine independent errors. Propose the correction, do not apply it.

**Context that decides the fix:** `prompt_json.total_points` is read by **no runtime code**.
`evaluate-attempt` sums `frq_criteria.points_possible` instead. The field also exists on only 16 of
75 Biology FRQ. So the real question is not "which number is right" but **"should this field exist
at all"** — propose both options with evidence and let the Product Owner choose.

## I.2 — `rubric_type` coverage

`docs/product/CONTENT_GAPS_RUNNING_LIST.md` GAP-3 records missing `rubric_type` on a tail of items
and says to **re-verify the count before working**. Do that first and report what you actually
find; the recorded figures predate several content changes.

---

## Sequencing

**E → F → G → H → I.**

E is highest value and unblocks a rejected lane. F was gated on A's QA; **that gate is now open
(2026-09-23) and F's earlier skip is superseded — re-enter F before continuing G.** G is the largest body of work
and is subject-sequenced so partial completion is still useful. H is gated on D's QA and is breadth
rather than depth. I is filler.

**If QA gating blocks F or H, skip to the next order rather than waiting.** Report the skip.

## What happens after

Everything here is a proposal. The gate before anything serves a student is unchanged: **AI build
(you) → independent AI cross-model QA (a different model) → Product Owner approval**, per
DECISION-0055. Nothing in this project writes to Production, and nothing is ratified by having been
produced carefully.
