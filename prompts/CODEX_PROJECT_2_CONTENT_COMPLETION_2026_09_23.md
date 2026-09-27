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
- **Every criterion must have text exclusive to it** *(added 2026-09-23 after QA of work orders B and
  G; applies to every span-shaped order — F and G)*. Spans exist for one reason: **deselecting a
  rubric point must strike exactly the text that earns it, and nothing else.** A run can satisfy
  every other invariant here — exact concatenation, full coverage, no invented criteria, removal
  never emptying the answer — and still fail that purpose completely, which is what happened twice:

  | Run | Criteria with no span of their own | Mean over-strike |
  |---|---:|---:|
  | B (AP Statistics, 240 criteria) | 81% | 0.82 |
  | G `ap-physics-1` (176 criteria) | **100%** | **1.00** |
  | C (AP Statistics, existing text it may not rewrite) | 35% | 0.35 |

  **The rule:** every criterion must be earned by at least one span tagged with that criterion *and
  no other*. Measure it yourself and report two numbers in `SUMMARY.md` — the count of criteria with
  no exclusive span, and the mean over-strike fraction (for each criterion, the share of the text its
  deselection removes that is not exclusively its own). **Both should be 0.**

  Where one sentence genuinely earns two criteria, you are authoring in F and G, so **split the
  sentence into two** rather than double-tagging one span. Double-tagging is the last resort, not the
  default; where you use it, flag it. *(This is the one rule C could not follow, because C segments
  published prose it is forbidden to rewrite. You are not in that position.)*
- **Self-flagged weak points.** Volunteering them makes your run more credible, not less.
- **Confidence must track topical ambiguity, not metadata quality** *(added 2026-09-23 after QA of
  work order E)*. E reported 370 `high`, 14 `medium`, 0 `low`, 0 `undetermined`, 0 open questions —
  and every one of the six items QA rejected was marked `high`. Its `medium` rows all tracked
  *metadata provenance* (`legacy_metadata_crosswalk`), so a genuinely ambiguous adjacent-topic call
  was indistinguishable from a certain one, and confidence was useless for triage. **Where two
  topics both plausibly fit an item, that item is `medium` at best regardless of how clean its
  metadata is.** An honest `undetermined` still beats a confident wrong code.

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

# Work order E.1 — the six boxplot items E labelled `1.8`

**Directory:** `docs/research/apstats_topic_labels_rework_2026_09_23/` (E's own directory — this is a
correction to your own proposal, not a new work order's output).
**Size: six rows.** Do this before F if you are already in that directory; otherwise after F.

## What QA found

E was **accepted except six items**. Read `qa_report.md` and `qa_findings.csv` in that directory
(finding **E-QA-001**). These six carry `proposed_topic_code = 1.8`:

```
APSTATS-HDG-2026-GRAPH-007   APSTATS-HDG-2026-GRAPH-013   APSTATS-HDG-2026-GRAPH-014
APSTATS-HDG-2026-GRAPH-015   APSTATS-HDG-2026-GRAPH-016   APSTATS-HDG-2026-GRAPH-017
```

Each stimulus reads "compared *X* for **two groups** … Construct **side-by-side boxplots** … Then
**compare** the typical *X* and the spread in context", and three of each item's four rubric criteria
are comparison criteria. `1.8` is *Graphical Representations of Summary Statistics for **One**
Quantitative Variable*. These belong in `1.9`, *Comparisons of the Distributions for One Quantitative
Variable* — the same topic you correctly assigned to both other compare-two-groups templates.

**Your own `SUMMARY.md` states the rule you did not apply here:** "Both compare-two-groups templates
were assigned 1.9." This is the defect class that caused the original rejection, in a family the work
order did not name.

## Requirements

1. **Relabel all six to `1.9`**, with `proposed_topic_title` set to the registry title for `1.9` and
   `proposed_unit` = 1. Take the title verbatim from `app.taxonomy_topics` at
   `dae3c72e-82ca-4960-9552-1b034bd347e5`; do not retype it.
2. **Change nothing else on those rows** except `rationale`, which must say why `1.9` beats `1.8`
   for a two-group comparison. Leave `previous_topic_code` as the *rejected run's* code — it records
   the original defect, not this correction. Do not alter the other 378 rows.
3. **Generalise the fix rather than patching six rows.** Re-run your compare-two-groups detection
   across every item you labelled `1.5`, `1.6`, `1.7` or `1.8`, and report the result. QA's scan
   found exactly these six, and `STATS-MOD3-H006` as a correctly-labelled near-miss (`1.6`: it
   describes one bimodal distribution, not two groups). If your scan finds more than six, say so and
   fix them; if it finds exactly six, say that too — a confirmed bound is a result.
4. **Set confidence honestly on the corrected rows.** `1.8` versus `1.9` here is a genuine
   adjacent-topic call. If you would not stake the run on it, it is `medium`, not `high`. See the
   shared contract's confidence rule.
5. **Write `E1_CHANGES.md`** in the same directory: the six rows before and after, your scan result,
   and one line stating that `qa_report.md` and `qa_findings.csv` describe the **pre-correction**
   state and are not yours to edit.
6. **This needs a fresh QA pass.** Correcting a QA finding does not clear the finding; a different
   model confirms the correction. Do not mark E closed.

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

   **Where a span serves several criteria, score each `span × criterion` pair separately and let the
   highest score govern that span.** Emit the pair-level evidence as `similarity_report.csv` in your
   directory, alongside the compact per-criterion figure in your ledger.

   **This is a gate, not an optimisation target.** *(Codex's point, adopted 2026-09-23.)* Padding a
   span with verbosity to push the ratio down would satisfy the number and defeat the purpose. If a
   span scores high because the criterion genuinely states the whole answer — which happens for
   one-fact criteria — say so in `restatement_justified` and leave the sentence alone rather than
   inflating it. A short correct answer is not a defect.

   **Correction to an earlier version of this work order:** it claimed
   `scripts/qa/overnight_qa_harness.py` enforces this. At the time it did not — the harness had
   modes for A–D only, and its similarity routine ran against A in report-only mode. An `order_F`
   mode has since been added, and it is QA-owned: **you do not extend the shared harness** (shared
   rule 5 keeps you inside your own directory). Your `similarity_report.csv` is your self-check; the
   harness is the independent one.

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
   chromatids"). Criterion `a` is worth 2 points and covers both meiosis I and meiosis II; the
   meiosis I half of A's span is correct.

   **On independence — corrected 2026-09-23, because Codex's challenge was right.** An earlier
   version said "do not copy a correction out of the QA report." But this work order and the QA
   findings both state the substance of the correction, so blindness is already gone and pretending
   otherwise would be theatre. **The standard is independent derivation, not artificial wording
   divergence:** derive the meiosis I and meiosis II chromosome and chromatid counts from the stem's
   `2n = 4` and record that derivation. Do **not** manufacture a different-sounding sentence to look
   independent — a deliberately reworded correct answer is worse content, not better provenance.
   The separation DECISION-0055 actually protects is preserved by the next step: a different model
   QAs your correction.
3. **Re-segment the full answer** so spans still concatenate exactly to `full_text`, every criterion
   is covered, **and every criterion has at least one span tagged to it alone** — see the
   span-exclusivity invariant in the shared contract. Work orders B and G both satisfied every other
   segmentation invariant and still failed this one (B at 81%, G's `ap-physics-1` at 100%). You are
   authoring, so where a sentence earns two criteria, split it into two sentences rather than
   double-tagging one span. `order_F` in the QA harness enforces this.
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
   - **A-QA-004's 30 in-scope items are candidates, not a quota** *(confirmed 2026-09-23)*. That
     finding reports where redundancy was measured; it does not authorise removal. The four
     conditions above govern each case independently. **Do not force a 30-of-30 result** — retain and
     flag every ambiguous case, and a run that removes far fewer than 30 with sound reasoning is a
     better outcome than one that hits the number. Refuse any removal whose provenance or
     `source_version_id` is missing, since DECISION-0056's audit trail would be incomplete.
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

# Work order F.1 — re-label `APBIO-FRQ-S-101` to match its four-part stem

**Directory:** `docs/research/apbio_drafted_criteria_2026_09_23/` (work order F's own directory —
this is a correction to your own output).
**Size: one item, one paragraph.** Do it whenever F's directory is next open; it blocks the Biology
canonical migration (M1) and nothing else.

## What the grader found

The AP Biology completion plan captured a grader baseline on 2026-09-24, before any canonical is
written to Production (`docs/research/biology_m5_grader_baseline_2026_09_24.md`). Two of the three
reachable items score 100%. `APBIO-FRQ-S-101` scores **3 of 4**, on two separate runs, and the
reason is not a grader defect:

> *"The student did not provide a separate explanation explicitly answering part (a)(iv) about why
> parsimony is preferred or fully defining 'most parsimonious' as required."*

That is correct. Here is why it happens:

- The item's **stem asks four sub-parts** — `(a)(i)` through `(a)(iv)` — and its rubric carries four
  criteria, `a-i` through `a-iv`.
- The **answer text is labelled `(i)`, `(ii)`, `(iii)` only.** It was recovered verbatim from retired
  parent `APBIO-FRQ-L-025`, which asked a **three**-part question.
- The content earning `a-iv` **is present**, but it sits inside the `(iii)` paragraph. QA of work
  order A confirmed it verbatim at its exact offset, so the mapping was right.

So the content is correct and the **presentation** is not: a student reading this canonical sees no
part (iv). It is an artefact of splitting a three-part parent into a four-criterion child without
re-labelling the answer's sub-parts.

## What to do

1. **Split the `(iii)` paragraph into labelled `(iii)` and `(iv)`**, matching the stem's four parts.
   The definition of "most parsimonious" stays under `(iii)`; the explanation of why parsimony is
   preferred becomes `(iv)`.
2. **This is a re-label, not a re-authoring.** Preserve the recovered wording. You may add the `(iv)`
   label and the minimal connective needed for the sentence to stand on its own — nothing more. The
   text is vetted content from a retired published parent, and QA verified it byte-for-byte.
3. **Re-verify the invariants** afterwards: spans still concatenate exactly to `full_text`, every
   criterion still covered, and every criterion still has a span tagged to it alone. F scored 0 of
   261 criteria without an exclusive span; do not regress that.
4. **Update the span provenance honestly.** The `(iv)` span is no longer byte-identical to the parent
   source, so it is not `recovered_parent` any more. Mark it `drafted` — or propose a more precise
   value and say why — and record the change rather than leaving a `source_offset` that no longer
   resolves.
5. **Record it in `F1_CHANGES.md`**: the before and after text, which spans changed, the provenance
   change, and your re-verified invariant numbers.

## What you do NOT do

**Do not re-grade it.** The grader path is `service_role`-gated and, more importantly, the model that
makes a fix must not be the one that verifies it. Claude re-runs the gate against your corrected text
and records the result against the baseline.

**Do not touch `APBIO-FRQ-S-102` or `-103`.** Both score 100% on the current deployment and are
accepted as they stand.

## One generalising check, because the pattern may not be unique

`S-101/102/103` are the only Biology items split from a retired parent, so the *parent-split* cause
is contained. But the underlying defect is more general: **an answer whose sub-part labels do not
match the sub-parts its stem asks for.** Scan work order F's 71 items for it — where a stem enumerates
`(a)(i)`, `(b)(ii)` and so on, do the answer's labels cover the same set? Report the count either way.
**Finding only `S-101` is a result worth having**, not a wasted pass.

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

## G.1 — first, re-cut `ap-physics-1`; it already carries the defect B was rejected for

**Do this before authoring any further subject.** The 39-item `ap-physics-1` batch you have already
committed fails the span-exclusivity invariant completely: **176 of 176 criteria have no span of
their own, and the mean over-strike is 1.00** — every character struck by deselecting a criterion is
shared with another. 88 spans carry 176 criteria, so every span is double-tagged or worse. That is
the same defect that got work order B's segmentation rejected, and it is worse here.

This is not your error alone: G said "identical in shape to work order B", and B's own invariant
table had no exclusivity row, so the spec permitted it. The row now exists in the shared contract
above.

1. **Re-cut the spans** so each of the 176 criteria has at least one span tagged to it alone.
   `full_text` should not need to change for most items — split existing spans at sentence
   boundaries.
2. Where one sentence genuinely earns two criteria, **re-author it into two sentences.** You authored
   this text, so you may. `full_text` changes there; say so.
3. **Re-verify** exact concatenation and full coverage after re-cutting — the earlier invariants must
   still hold.
4. Report before/after in `ap-physics-1/`: criteria with no exclusive span and mean over-strike, both
   before and after, plus the count of items whose `full_text` changed and why.
5. **Then** continue the subject sequence, applying the invariant from the start for subjects 2–8.

`ap-physics-1` has not been QA'd. Re-cut it first so QA reviews the corrected batch rather than
dispositioning one you already know is defective.

## Requirements

Identical in shape to work order B, which you have already run for AP Statistics — **except for the
span-exclusivity invariant in the shared contract above, which B did not carry and which is the
reason B's segmentation was rejected.** Per item: author a full-credit answer earning **every**
stored criterion, segment it into criterion-tagged spans **each of which earns its criterion and no
other wherever possible**, and record a **`derivations[]` entry for every numeric value** in the
answer, naming the inputs it came from. That field is what lets a second model re-derive your
arithmetic instead of trusting it.

**Emit `similarity_report.csv` for every subject** *(added 2026-09-24 — `ap-physics-1` did not, see
G-P1-QA-002)*. Work order F's requirement 1a applies to G unchanged: score every authored span
against its own criterion's `learner_facing_text`, emit the pair-level report, and where a span sits
at or above 0.85 **flag it rather than rewriting it**. Physics 1 had four such spans and all four
were legitimate one-fact criteria — `"Concludes K=E-U=3E/4, so K>U"` against
`"Consequently K=E-U=3E/4, so K>U."` There is no better way to write that and padding it would game
the metric. The defect was that nothing said so, so a reader could not tell a legitimately short
answer from a rubric echo without redoing the measurement. **Make `flags[]` typed objects** rather
than plain strings so `restatement_justified` can actually be expressed.

**Tighten `derivations[]` beyond what B emitted** *(QA finding B-QA-002, restated 2026-09-24 after
it failed to land in `ap-physics-1` — see G-P1-QA-001)*. B's derivations were complete in count but
not mechanically re-derivable, and Physics 1's repeated the pattern: 87% of its `expression` values
carried more than one number, and **all 1,242 of its `inputs` labels were the placeholder
`numeric operand 1..6`**, which names nothing. The test is simple and you should apply it yourself:
**can a second model recompute this one value from this one derivation row, without reading the
answer prose?** If not, the row has failed.

Concretely, for every numeric value in the answer:

- **`expression` is the formula for that one value.** `"a = Δv/Δt = (8.00−0)/5.00"` — not
  `"v=6.00 m/s and Δx=12.0 m from constant-acceleration relations."`, which names two values and no
  formula.
- **`inputs` names each operand meaningfully.** `{"label": "final velocity", "value": "8.00"}` — not
  `{"label": "numeric operand 1", "value": "8.00"}`.
- **`criterion_keys` is populated**, so the value is tied to the point it serves.
- **A value that is read rather than computed is `kind: "looked_up"`**, with its source named. *An
  earlier version of this rule gave only statistical examples (t\*, z, χ²), which is why Physics 1
  reasonably used it zero times — that wording was wrong.* It covers **any value not derived from
  the item's own data**: a physical constant such as `g = 9.80 m/s²` (22 occurrences in Physics 1), a
  molar mass, a table lookup, a given conversion factor.

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

**Gate status, 2026-09-23: OPEN.** D's `qa_report.md` and `qa_findings.csv` exist in
`calcab_chem_topic_labels_2026_09_22/` and its disposition is **ACCEPTED** — the strongest of the
four overnight runs. **H is unblocked.** An earlier run recorded a gate skip for H when that report
did not yet exist; that skip is superseded. Read D's QA report before starting: it tells you which
parts of D's method were verified to work, and the one place D could not be checked.

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

## The closed lists — these are the only permitted values

Verified read-only against Production 2026-09-23. All six are `verified` confidence, school year
2026-2027. **Confirm each count yourself before you use it, and report any disagreement** rather than
working around it — an earlier version of this work order named no versions at all, which left the
single most important input to inference.

| Subject | `taxonomy_source_version` | Topics | Units |
| --- | --- | ---: | ---: |
| ap-calculus-bc | `ab088009-dc9a-4f93-8824-803e1913505b` | 111 | 10 |
| ap-physics-1 | `27111dec-ee07-48f1-86cf-1a5833dd2962` | 43 | 8 |
| ap-precalculus | `16383753-6775-430d-960a-544cd6ee0972` | 58 | 4 |
| ap-physics-c-em | `ef9618c9-de85-4941-8837-4dce4c755e62` | 31 | 6 |
| ap-physics-c-mechanics | `d77d7801-441d-49bb-a2cf-a02f6bff407d` | 41 | 7 |
| ap-physics-2 | `b3e41b93-95d8-40c6-bef5-98cc99111915` | 46 | 7 |

As in D, the registry stores `subject_key` with underscores (`ap_calculus_bc`, `ap_physics_c_em`)
while content uses hyphens. **Normalise when you join, or you will match zero rows.**

**A note on AP Calculus BC.** Its list has 111 topics across 10 units against AB's 81 across 8. The
extra topics are the BC-only ones — `7.5` Euler's Method, `7.9` Logistic Models, `8.13` Arc Length
among them. D's QA found three items published in the **AB** bank that actually assess those three
BC-only topics (`apcalcab-mcq-045`, `-046`, `-050`). **They are not in your scope and you must not
move them** — their disposition is a Product Owner decision. Mentioned only so you recognise the
pattern if a BC item shows the mirror image of it.

**Recover first**, exactly as in D: 149 items already carry an author-time code. Validate each
against the item's content, flag `content_disagrees` rather than overwriting, and derive only the
remaining ~454.

**Emit a per-item verdict on that validation, not just the exceptions** *(QA finding D-QA-003)*. D
reported `content_disagrees=false` on all 241 rows, and QA could not prove the check had actually run
on each of the 106 recovered codes — a blanket zero is the same shape that exposed work order E.
Sampling found D's zero credible, but credible is weaker than evidenced. So for each of your 149
recovered items record an explicit `content_check` value — `agrees` | `disagrees` | `unclear` — and
report the distribution. A zero disagreement rate backed by 149 individual verdicts is a result; a
zero with nothing behind it is an unverifiable claim.

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

**E → E.1 → F → F.1 → G → H → I.**

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
