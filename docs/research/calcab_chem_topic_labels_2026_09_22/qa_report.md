# QA Report — Work Order D (AP Calculus AB and AP Chemistry Topic Labels)

**Disposition: ACCEPTED.** All 241 labels stand. **D is the strongest of the four overnight runs** —
every stated invariant recomputes true, its confidence is honestly calibrated, and its rationales
survive adversarial checking.

**This unlocks work order H**, which was gate-skipped pending D's disposition.

The one high-severity finding is not against D: three published AP Calculus AB items assess BC-only
content, so no AB topic code can be correct for them. D detected the problem as well as the schema
allowed and flagged all three.

This line is the DECISION-0055 independent cross-model QA gate for work order D. It ratifies nothing.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-23
- **Producer:** Codex, overnight run of 2026-09-22/23
- **Production:** `pcntajvbdfqhbeewmdry`, read-only throughout. No writes to Production or to
  `app.content_taxonomy_labels`. The prior Biology/Statistics record in
  `bio_stats_topic_tagging_2026_09_22/` was not modified.

## What was verified

Every count recomputed from Production or the artifacts before `SUMMARY.md` was read.

| Invariant | Independent result | Verdict |
| --- | --- | --- |
| 241 published items, 62/60/51/68 by subject and type | 241, exact split | Confirmed |
| Packet matches Production | 6 of 6 field aggregates identical across all 241 | Confirmed |
| Closed lists at the stated versions | Calculus AB 81 topics / 8 units, Chemistry 91 / 9, both `verified`, 2026-2027 | Confirmed |
| Every proposed code in that subject's closed list | **0 invalid** | Confirmed |
| `proposed_unit` matches the registry | **0 mismatches** | Confirmed |
| `proposed_topic_title` matches the registry | **0 mismatches** | Confirmed |
| Every `alternative_topic_code` is also valid | **0 invalid** across 22 distinct alternatives | Confirmed |
| `taxonomy_source_version` correct for each subject | 0 wrong | Confirmed |
| Recovered code equals the parsed author topic | 106 of 106, **0 failures** | Confirmed |
| Recovered rows reconcile to 106 | 106 recovered, 135 derived | Confirmed |
| Every `low` confidence row has `needs_human=true` | 8 of 8 | Confirmed |
| Every `signal_conflict` row has `needs_human=true` | 8 of 8 | Confirmed |

## Independent corroboration, using signals D did not rely on

- **Author unit signals:** 20 items carry an explicit `author_signals.unit`. **All 20 agree** with the
  proposed unit.
- **Chemistry module hints:** 119 items carry a `unit-N` module tag. **118 agree.** The single
  exception is `apchem-sfrq-007`, tagged `unit-6-thermochemistry` but proposed `9.3 Gibbs Free Energy
  and Thermodynamic Favorability`. D is right and the module tag is the weaker signal: the item is
  entirely about the ΔG = ΔH − TΔS favorability crossover. D flagged it `signal_conflict`,
  `needs_human`, `medium`, with `9.1` as runner-up — exactly the required handling.
- **Rationale integrity, adversarially checked:** 44 rows claim "the exact *N.N* hint in
  modules/taxonomy_refs". I checked every one against the packet's `author_signals`. **All 44 codes
  are genuinely present. Zero fabricated.**
- **Concentration:** 4.9% maximum on any Calculus code (54 distinct codes across 122 items) and 3.4%
  for Chemistry (60 distinct across 119). No template collapse — against the 45%-on-two-codes failure
  that sank the original AP Statistics run.
- **Direct sampling:** I read 18 items against their labels — 8 recovered and 10 derived, across both
  subjects and both item types. **All 18 are correct.**

## The finding: three AB items testing BC content

`apcalcab-mcq-045`, `-046` and `-050` are published in the **AP Calculus AB** bank and assess topics
that exist only in **BC**:

| Item | What it asks | Author tag | CED topic | In the AB registry? |
| --- | --- | --- | --- | --- |
| `apcalcab-mcq-045` | "Use Euler's method with step size 0.5…" | `topic-7.5` | 7.5 Euler's Method | **No — BC only** |
| `apcalcab-mcq-046` | logistic `dP/dt = 0.18P(1−P/900)` | `topic-7.9` | 7.9 Logistic Models | **No — BC only** |
| `apcalcab-mcq-050` | "length of y = x² from x = 0 to x = 1.4" | `topic-8.13` | 8.13 Arc Length | **No — BC only** |

The registry is right, not deficient: its Unit 7 runs 7.1–7.4 and 7.6–7.8, and its Unit 8 runs
8.1–8.12, which is exactly the CED's AB scope. The authors cited correct CED codes — for the wrong
course.

**There is no correct AB label for these items**, so D could only assign the nearest valid topic
(`7.4`, `7.8`, `8.3`). It did that, marked all three **low confidence with `needs_human=true`**,
recorded runner-ups, and raised them in `open_questions.csv`. That is the right behaviour under the
constraint it was given.

The items themselves are internally sound — Euler's method gives 2.5, logistic maximum growth is at
K/2 = 450, and the arc length is ≈ 2.520, each matching its keyed choice. The defect is scope, not
correctness: **a student practising AP Calculus AB would be studying material that is not on the AB
exam.** This needs a Product Owner decision — retire them from AB or move them to BC — and it cannot
be fixed by relabelling.

Separately, `apchem-sfrq-029` carries the author topic `7.13`, which does not exist in AP Chemistry
(Unit 7 ends at 7.12). D correctly treated it as derivation work, proposed `7.12`, preserved the
invalid original, and flagged it.

## Two low-severity notes

- **D-QA-003** — `content_disagrees` is false on all 241 rows. A blanket zero is the shape that
  exposed work order E, and QA cannot prove the recovered-code content check ran on all 106. My
  8-item sample was 8 for 8 correct, and D's other honesty signals are specific and costly to fake —
  8 low, 28 `needs_human`, 8 `signal_conflict`, 13 open questions, the invalid `7.13` catch, the
  three BC-scope flags. On the evidence the zero is credible. For the next order, have the check emit
  a per-item verdict so a zero is evidenced rather than asserted.
- **D-QA-004** — `packet.jsonl` carries `parsed_code`, `code_in_closed_list` and
  `existing_coverage_label`, which are derived rather than raw inputs. The raw values are intact in
  `author_signals`, so QA could still re-derive them independently and did. Duplication, not
  contamination.

## A note on the work order itself

Section 2 describes `modules` and `taxonomy_refs` as carrying "unit-level `node_key`s, not topics."
In fact many `modules` arrays carry an explicit `topic-N.N` tag — a topic-level signal the work order
did not expect. D used these as corroboration rather than as recovery, which is the correct
treatment under the rules as written, and said so in its judgment calls.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order D, and **unlocks
work order H**.

**Does not:** ratify any label, or authorise a write to Production or to
`app.content_taxonomy_labels`. The 28 `needs_human` rows still want Product Owner eyes, and the three
BC-scope items need a scope decision before any label they carry is meaningful.
