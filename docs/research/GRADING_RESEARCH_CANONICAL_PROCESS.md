# Grading Research Canonical Process

**Status:** Draft canonical process for Product Owner review
**Owner:** Product Owner with Learning Quality Owner
**Scope:** Research, calibration, and pre-launch improvement for grading systems

## Purpose

This is the default way to turn grading experiments into durable grading
improvements before new subjects, question families, or rubric changes go
live.

## Five Rules

1. Use one locked evidence package per run.
2. Compare the same corpus or packet across arms.
3. Separate development, calibration, holdout, challenge, sentinel, and production samples.
4. Adjudicate disagreements before drawing a conclusion.
5. Move stable lessons into a durable doc or task, not into chat. The durable
   home for cross-subject grading lessons is
   [Grading Cross-Subject Takeaways](./grading_cross_subject_takeaways.md).

## Standing Direction (2026-07-08, DECISION-0034)

- **Depth over breadth.** Prioritize one fully-adjudicated gold set for the
  launch subject over additional synthetic breadth corpora. Breadth corpora are
  useful for pipeline exercise, but only adjudicated gold evidence can test the
  governance release thresholds. See
  [grading_cross_subject_takeaways.md](./grading_cross_subject_takeaways.md)
  Lesson 7 and the revised
  [packet backlog](./grading_packet_backlog_2026_07_07.md).
- **Single fast grader is the default arm.** Escalation-on-confidence,
  ensembles, and reference layers are not the default; test them only as
  explicit challengers to that baseline, and use multiple models as boundary
  auditors, not scoring ensembles (Takeaways Lessons 1-2).

## Minimum Artifact Set

Every useful grading-research family should have:

| Type | Purpose | Canonical form |
| --- | --- | --- |
| Protocol | What was tested and why | `*_protocol.md` |
| Corpus or packet | The locked input set | `*.jsonl`, `*.json`, `*.csv`, or packet folder |
| Manifest | What is in the package | `manifest.json`, `manifest.jsonl`, or `benchmark_manifest.json` |
| Report | What happened and what it means | `*_report.md` |
| Takeaways | The durable lesson | `*_takeaways.md` |
| README | How to use the folder | `README.md` |

## Standard Improvement Loop

### 1. Define the decision

Start with one clear decision:

- can this content be used to improve grading before launch;
- should a new subject be allowed to go live;
- should a rubric boundary be tightened;
- should a prompt or verification rule be changed;
- or should the item remain research-only.

If the decision cannot be tested, narrow it.

### 2. Build the evidence package

Create a package that includes:

- a subject and experiment identifier;
- the source content or response set;
- the relevant rubric or boundary contract;
- the model and prompt versions under test;
- the evaluation criteria;
- the holdout or challenge split, if used; and
- a README that explains what the package contains.

Keep related files together in one dated folder when the package is multi-file.

### 3. Lock the labels before scoring

Before any conclusion is drawn:

- development examples may exist, but they are not gold evidence;
- calibration labels must be locked before the model results are reviewed;
- holdout and challenge sets must remain access-isolated from prompt authors
  and tuning workflows;
- author-generated examples may help debugging, but they do not count as
  independent gold unless separately adjudicated.

### 4. Run paired evaluation

Use the same corpus across the relevant arms.

Prefer:

- the same response IDs across arms;
- the same rubric version across arms unless the experiment is testing a
  revision;
- the same sample-selection method within a comparison group;
- a deterministic prefilter when the case is clearly non-substantive; and
- explicit escalation rules for ambiguous or low-confidence cases.

Every grading experiment must report **feedback quality**, not only the
criterion earned/not-earned decision. Alongside criterion agreement, measure:

- feedback grounding — does the cited evidence actually appear in the learner
  response and match the criterion;
- minimum-fix sufficiency — would the stated minimum fix actually earn the next
  point;
- error-classification accuracy.

These map to the release thresholds in
`../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.3. A grader that scores
correctly but gives generic or ungrounded feedback fails the product thesis and
must be detectable in the report. See
[grading_cross_subject_takeaways.md](./grading_cross_subject_takeaways.md)
Lesson 6.

### 5. Adjudicate disagreements

Explain disagreements that affect the conclusion.

Record whether the root cause was:

- rubric ambiguity;
- boundary language missing or too broad;
- over-credit or under-credit;
- answer leakage;
- a model misread;
- a deterministic check failure; or
- stale or inconsistent source data.

If the boundary is unclear, revise the rubric or the question, not the label.

### 6. Extract the lesson

After the run, write the stable lesson:

- what improved quality;
- what reduced latency;
- what lowered cost;
- what introduced risk;
- what only works for one subject;
- and what should become the next canonical rule or experiment.

Put that in a `*_takeaways.md` file or promote it into a task, architecture,
or governance document if it is now durable policy.

### 7. Record the promotion decision

Before anything is treated as live guidance, record one of the following:

- no change;
- keep as research only;
- revise and rerun;
- promote to task scope;
- promote to architecture or governance language;
- or approve for launch review.

If the change affects live grading or launch readiness, record it in the task,
decision, or approval logs too.

## Required Split Strategy

Use separate sets whenever possible:

- development set for iteration;
- calibration set for tuning;
- holdout set for final validation;
- challenge set for hard failures and edge cases;
- sentinel set for regression checks after changes;
- production sample for monitoring after launch.

Do not pool those sets unless the report says why.

### Corpus Tier Labeling (Required)

Every corpus and packet manifest must carry an explicit tier so a later run
cannot silently cite development data as if it were gold. The reporting standard
already gates report *claims* by read tier; this gates the *evidence*.

| Corpus tier | What it is | May support |
| --- | --- | --- |
| `development` | Author-generated or synthetic, for pipeline exercise | Harness/mechanics claims only |
| `calibration` | Locked before scoring, for tuning boundaries | Boundary-tuning decisions |
| `adjudicated_gold` | Dual-blind human scored + lead-adjudicated | Quality/agreement claims and release gates |
| `held_out` | Access-isolated from prompt/model tuning | Final validation |
| `challenge` | Hard/edge failure cases | Targeted robustness claims |
| `sentinel` | Regression checks after change | Post-change monitoring |

A quality or release claim may cite only `adjudicated_gold` or `held_out`
evidence. Truncation-derived or "skewed-to-easy-binary" corpora are
`development` and must be labeled as such in their README and manifest.

## Organization Rules

1. Keep related source, manifest, script, and render files together.
2. Use date suffixes for reproducibility.
3. Keep raw evidence separate from derived summaries.
4. Never delete superseded raw artifacts.
5. Keep one README per experiment family.
6. Keep one top-level research index.
7. Reuse the same naming pattern for new work.

## Recommended Naming Pattern

For new families, prefer:

- folder: `<subject>_<experiment>_<YYYY_MM_DD>/`
- report: `<subject>_<experiment>_<YYYY_MM_DD>_report.md`
- summary: `<subject>_<experiment>_<YYYY_MM_DD>_summary.json`
- packet: `<subject>_<experiment>_<YYYY_MM_DD>_packet.md`
- takeaways: `<subject>_<experiment>_<YYYY_MM_DD>_takeaways.md`

If a run only needs a single stand-alone document, still use the date suffix
and the same subject-first prefix.

## Maintenance Standard

Every new or revised grading experiment should answer:

- what content was used;
- what was locked before scoring;
- what was compared against what;
- what disagreement was found;
- what changed because of it;
- and what evidence now protects future work from repeating the same mistake.

If the answer cannot be reconstructed from the folder contents alone, the
package is not ready.
