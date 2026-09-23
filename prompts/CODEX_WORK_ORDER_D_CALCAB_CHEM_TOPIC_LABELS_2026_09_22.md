# Codex Work Order D — Topic Labels for AP Calculus AB and AP Chemistry

DATE: 2026-09-22 | SUBJECTS: AP Calculus AB (`ap-calculus-ab`), AP Chemistry (`ap-chemistry`)
RUNS: overnight, unattended
MODE: **Proposal only. Read-only against Production. No writes to published content, ever.**

---

## Working location

**`docs/research/calcab_chem_topic_labels_2026_09_22/`** (create it if it does not exist)

| File | Written by | Purpose |
| --- | --- | --- |
| `packet.jsonl` | you (Task 0) | model-neutral inputs — the shared QA baseline |
| `inventory.csv` | you (Task 0) | what already exists vs what is a gap |
| `topic_labels_proposal.csv` | you (Task 1–2) | one row per item |
| `open_questions.csv` | you | anything unresolved, with the reason |
| `SUMMARY.md` | you (§6) | the report-back |
| `qa_findings.csv`, `qa_report.md` | **the QA model, not you** | never create or edit these |

## 0. What you are doing, in one paragraph

Every published item needs **exactly one primary unit:topic pair**, chosen from that subject's
College Board CED closed list. Zero items in any subject currently carry a governed coverage label
(`app.content_taxonomy_labels` with `label_scope='coverage'` and a non-empty `assessed_topics`),
which leaves breadcrumb, habits pair, reference pane, deep dive, progress and study map dark — and
Open Hand requires the shown item to be relevant to the unit:topic.

**Recover before you derive.** A material fraction of these items already carry a valid CED topic
code in `prompt_json.topic`, written at authoring time. Verified read-only 2026-09-22: of the CED
codes present and parseable, **100% of AP Chemistry MCQ and 97.4% of AP Chemistry FRQ match the
closed list exactly**, as do all parseable AP Calculus AB FRQ codes. Migrating an existing valid
code is cheaper and safer than re-deriving one, and it preserves author intent.

## 1. Scope and expected counts — verify before starting

Read-only against **Cramapple – Production** (`pcntajvbdfqhbeewmdry`). Filter: latest `version_num`
per `content_item_id` where `status='published'`. State the `WHERE` behind every count.

| Subject | Type | Items | Already carry a valid CED topic code in `prompt_json.topic` |
| --- | --- | ---: | ---: |
| ap-calculus-ab | frq | 62 | **20** |
| ap-calculus-ab | mcq | 60 | 0 |
| ap-chemistry | frq | 51 | **37** |
| ap-chemistry | mcq | 68 | **49** |
| **Total** | | **241** | **106** |

So roughly 106 items are a **recovery/validation** job and roughly 135 need a topic **derived**.

**The closed lists** — these are the only permitted values:

| Subject | `taxonomy_source_version` | Topics | Units | School year | Confidence |
| --- | --- | ---: | ---: | --- | --- |
| AP Calculus AB | `33b4408b-0ecc-4c7a-b0b1-612db81164a1` | 81 | 8 | 2026-2027 | verified |
| AP Chemistry | `cbe3116f-6ef5-410c-b535-e9fb711c4c2c` | 91 | 9 | 2026-2027 | verified |

Note the registry stores `subject_key` with underscores (`ap_calculus_ab`, `ap_chemistry`) while
content uses hyphens (`ap-calculus-ab`, `ap-chemistry`). **Normalise when you join, or you will
match zero rows.**

If your counts differ from the table above, **stop and report it in `open_questions.csv`** before
proceeding.

## 2. Source material

- **The closed list:** `app.taxonomy_topics` joined to `app.taxonomy_source_versions`, filtered to
  the exact `taxonomy_source_version` above. `topic_code` (e.g. `1.10`) and `topic_title`.
- **The existing author-time code:** `prompt_json.topic`. Values appear both as a bare code
  (`"1.5"`, Chemistry) and as code-plus-title (`"1.10 Exploring Types of Discontinuities"`,
  Calculus). Parse the leading `N.N`.
- **Weaker author signals**, useful as corroboration only, never as ground truth:
  `prompt_json.subtopics`, `prompt_json.modules`, `prompt_json.unit`, `prompt_json.taxonomy_refs`
  (these carry unit-level `node_key`s, not topics).
- **The item itself:** `stem`, `stimulus`, and for FRQ the `frq_criteria` rubric text.
- **Protocol:** `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md`.
- **Precedent:** `docs/research/bio_stats_topic_tagging_2026_09_22/` — the Biology/Statistics run
  from the same night. Same output shape. **Do not edit anything in that directory.**

## 3. Task 0 — inventory first

Before proposing anything, emit `inventory.csv`: one row per published item with `content_key`,
`subject_key`, `item_type`, `existing_prompt_json_topic` (raw), `parsed_code`,
`code_in_closed_list` (bool), `existing_coverage_label` (bool), and `unit_signals` (whatever
`modules`/`unit`/`taxonomy_refs` provide).

Then emit `packet.jsonl` — model-neutral inputs only, one row per item, including the stem,
stimulus, rubric text and every author signal you will use. QA re-derives this from Production and
diffs it against yours.

## 4. Task 1 — recover and validate the 106

For each item whose `prompt_json.topic` parses to a code **in the closed list**:

1. Record it as the proposed primary topic with `basis='recovered_author_code'`.
2. **Then check it against the item's actual content.** A code being *valid* does not make it
   *correct*. Read the stem and rubric; if the content plainly assesses a different topic, record
   `content_disagrees=true`, give your proposed alternative and a one-sentence reason, and set
   `needs_human=true`. Do not silently overwrite the author's code.
3. If the code parses but is **not** in the closed list, treat the item as Task 2 work and record
   the invalid original for the record.

## 5. Task 2 — derive the remaining ~135

For each item with no usable existing code, select **exactly one primary topic** from that
subject's closed list:

1. Choose on the basis of what the item actually assesses — the stem, the stimulus, and for FRQ the
   rubric criteria. The rubric is the strongest signal on an FRQ because it states what earns
   credit.
2. **Selection only.** The proposed topic must be an exact `topic_code` from the closed list. An
   invented code is a hard failure, not a judgement call.
3. Record `confidence` ∈ {`high`, `medium`, `low`} and a one-sentence `rationale` naming the
   evidence you used.
4. Set `needs_human=true` for every `low`, and for every item where two topics are genuinely
   defensible — record the runner-up in `alternative_topic_code`.
5. Where author signals (`subtopics`, `modules`) point somewhere different from your reading of the
   content, record `signal_conflict=true` and say which you followed and why.

**Note on granularity.** The known failure mode in this task is not inventing topics — it is
splitting hairs over which of two adjacent topics owns an item. When two adjacent topics both fit,
prefer the one the **rubric** assesses, flag it, and move on. Do not spend the night on ties.

## 6. Preparing your work for QA

An independent model — a different one from you — will adversarially QA this run without access to
your reasoning.

**6.1 Separate inputs from proposal.** `packet.jsonl` and `inventory.csv` are what you read;
`topic_labels_proposal.csv` is what you propose.

**6.2 Columns required in `topic_labels_proposal.csv`:** `content_key`, `subject_key`,
`item_type`, `proposed_unit`, `proposed_topic_code`, `proposed_topic_title`, `basis`
(`recovered_author_code` | `derived`), `confidence`, `rationale`, `existing_author_code`,
`content_disagrees`, `alternative_topic_code`, `signal_conflict`, `needs_human`,
`taxonomy_source_version`.

**6.3 State the invariants you expect QA to recompute**, in `SUMMARY.md`, with your measured
result for each:

| Invariant | Expected |
| --- | --- |
| Every item has exactly one `proposed_topic_code` | 241 / 241 |
| Every proposed code exists in that subject's closed list at the stated `taxonomy_source_version` | 0 invalid |
| `proposed_unit` matches the unit of `proposed_topic_code` in the registry | 0 mismatches |
| Every `basis='recovered_author_code'` row's code equals the parsed `prompt_json.topic` | 0 failures |
| Recovered rows reconcile to the counts in §1 | 106 |
| No item outside AP Calculus AB / AP Chemistry appears | 0 |
| Packet matches Production on version ids and author signal fields | 0 differences |

**If one fails, report the failure — do not adjust the invariant.** "0 invalid codes" is a hard
property: the closed list makes an invented topic structurally impossible, so any invalid code is a
defect in your pipeline, not a judgement call.

**6.4 Give QA a sampling handle.** 241 items is more than a reviewer checks line by line. Rank
items by confidence, lowest first, and name the ten you are least sure of and why. Report the
recovered-vs-derived split and the `content_disagrees` count prominently — those are where a
reviewer's attention is worth most.

**6.5 Make the run reproducible.** Record UTC start and end time, model identifier, Production
project ref, the `taxonomy_source_version` used per subject, and the maximum `version_num` seen
per item.

**6.6 If you run out of time, stop cleanly.** Finish the item you are on, then report in
`SUMMARY.md` exactly which items are complete and which were not attempted. **Do not degrade
quality to finish the list, and do not report a partial run as complete.** Prefer finishing AP
Chemistry completely over leaving both subjects half-done — Chemistry has the larger recoverable
fraction and therefore the better return per hour.

**6.7 Write `SUMMARY.md` last**, including the invariant table with your results, the confidence
ranking, the recovered/derived split, every `signal_conflict` and `content_disagrees`, everything
in `open_questions.csv`, and an explicit statement that this is a proposal requiring independent
AI cross-model QA and Product Owner approval under DECISION-0055 before any label serves.

**6.8 Do not create `qa_findings.csv` or `qa_report.md`.** Those belong to the QA model.

## 7. Rules of engagement

1. **Read-only against Production.** No `INSERT`, `UPDATE`, `DELETE`, no migrations, no deploys.
   Labels are proposed in CSV, never written to `app.content_taxonomy_labels`.
2. **Selection, not generation.** Topic codes come from the closed list or nowhere.
3. **Fill gaps; do not replace.** An existing author code is prior work — validate it, flag
   disagreement, never silently overwrite.
4. **Do not write into any other work order's directory**, and do not edit
   `docs/research/bio_stats_topic_tagging_2026_09_22/`.
5. **State the `WHERE` behind every count**, and report disagreements rather than working around
   them.

## 8. Definition of done

- `inventory.csv` and `packet.jsonl` cover all 241 published items.
- `topic_labels_proposal.csv` has one row per item with exactly one closed-list topic code, or
  fewer with an honest partial report per 6.6.
- `SUMMARY.md` reports every invariant in 6.3 with your measured result, plus the confidence
  ranking and the recovered/derived split.
- Nothing in Production changed; no other work order's directory was touched.
