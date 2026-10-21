# AP Statistics 1.7 Deep Dive Parse Assessment

STATUS: PILOT ANALYSIS

DATE: 2026-10-05

Purpose: test how easily the current AP Statistics 1.7 topic brief and Learn More
explainer can be parsed into the proposed website boxing structure without a
database, RPC, or production-schema change.

Editable packet:
`docs/product/AP_STATS_1_7_DEEP_DIVE_PARSED_PILOT.json`

Website prototype:
`docs/product/AP_STATS_1_7_DEEP_DIVE_WEBSITE_PILOT.html`

Phase 0 lightweight comparison:
`docs/product/AP_STATS_1_7_DEEP_DIVE_PHASE0_LIGHTWEIGHT.html`

Open Hand rail comparison (boxing content unchanged):
`docs/product/AP_STATS_1_7_DEEP_DIVE_WITH_OPEN_HAND.html`

## Phase 0 Viability

It is viable to use Deep Dive as the single student-facing compilation of the
current reusable 1.7 information before undertaking the full rewrite. The
existing brief and explainer fields are already structured enough to extract
mechanically, and the parsed JSON packet demonstrates the shape.

This should be implemented as a derived view or generated packet, not as a new
independent production copy. The current database rows remain authoritative;
Deep Dive gathers and presents them together. A generated packet can also carry
source field names, extraction time, and duplicate flags, making the later edit
phase easier.

The boundary is strict: reusable unit/topic instructional guidance can appear in
Deep Dive, but item-specific Open Hand answer keys, correct choices, rationales,
worked solutions, rubric evidence, accepted variants, and minimum fixes cannot.
Those are gated item data and participate in the scoring-exclusion contract.

Estimated effort for one pilot topic is low. The main implementation work is
field mapping, provenance labels, a freshness check, and rendering overflow.
The editorial rewrite and new-versus-prior classification can happen later.

## Result

The current content is easy to extract and moderately easy to restructure. The
source rows populate the topic summary, answer move, worked-example prompt,
weak answer, stronger answer, common point loss, and practice bridge directly.
The main difficulty is not parsing SQL; it is assigning one instructional job
to each sentence while removing repetition and preserving source meaning.

This pilot begins out of sequence. In a production run, Topics 1.1 through 1.6
would already provide a cumulative ledger of introduced concepts. That would
make the 1.7 parse easier and more precise: 1.7 would teach only its new content,
briefly cue necessary prior knowledge, and send shared reference material to the
unit surface. The current packet's ownership decisions are therefore
provisional rather than a final statement of what is new in 1.7.

Approximate pilot effort by transformation:

| Transformation | Boxes | Difficulty |
| --- | --- | --- |
| Direct field reuse | Worked-example prompt and responses | Easy |
| Condense within existing meaning | Topic summary, primary answer move, practice bridge | Easy |
| Deduplicate overlapping fields | Core idea | Moderate |
| Split prose into ordered actions | Answer steps | Moderate |
| Split an error and author its correction | Misconceptions | Moderate |
| Select topic-owned material from a larger fact set | Formula reference | Moderate |
| Author a new explanation | Why it works | Moderate |
| Create unit-owned synthesis | Unit reference | Moderate to substantial |

## Mechanical Parsing

The existing rows already have stable named fields. Extracting the 1.7 values
into a local object is mechanical. A production parser could carry these fields
unchanged into a `raw` section for traceability:

- brief: `what_it_is`, `why_it_matters`, `how_points_are_earned`,
  `answer_move`, and `common_point_loss`;
- explainer: `core_idea`, `what_students_need_to_understand`,
  `how_this_becomes_points`, `answer_move`, `mini_example_question`,
  `weak_answer`, `point_attaining_answer`, `common_point_loss`, and
  `practice_bridge`.

SQL text should not become the long-term editing interface. For this pilot, the
JSON packet is intentionally downstream of the migration and has no runtime
authority.

## Editorial Parsing

The source fields overlap. `what_it_is`, `core_idea`, and
`what_students_need_to_understand` all repeat parts of the same idea. Similarly,
`how_points_are_earned` and `how_this_becomes_points` repeat the same answer
behavior. A purely mechanical one-field-to-one-box mapping would reproduce the
crowding seen in the early design.

The pilot therefore uses these rules:

1. Preserve all source text in `raw`.
2. Assign one job to each output box.
3. Record every source field used by each box.
4. Label the transformation and review requirement.
5. Enforce the approved row limit in the output box.
6. Route shared reference content to the unit level.
7. Classify content as `new_here`, `builds_on`, `unit_reference`, or
   `future_topic` using the cumulative unit ledger.

## Editing Test

The packet is designed for safe manual iteration:

- editors change `boxes.*` values;
- source text remains available in `raw` for comparison;
- each box declares source fields, transformation type, difficulty, review
  owner, and row limits;
- the website prototype can be updated from the edited box values without
  altering Supabase.

The current HTML still contains its rendered copy directly. The next useful
technical experiment would be a build-time renderer that reads this packet and
generates the standalone prototype. That is modest work and remains reversible.
It should precede any decision about a production database model.

## Candidate Supplement Triage

The user-supplied Gemini summary is useful editorial input, but it should not be
treated as an authoritative curriculum source. Compared with the approved fact
pack, it adds useful explanatory detail for mean, median, range, IQR, sample
variance, sample standard deviation, outlier fences, and resistance.

It also crosses the topic boundary. The five-number summary and the standard
mean-versus-median relationships for symmetric and skewed distributions are
assigned to Topic 1.8 in the fact pack, not Topic 1.7. Mode is not identified as
a required 1.7 concept there, and the stated quartile procedure requires an SME
decision because calculation conventions can vary.

The candidate summary omits three useful fact-pack elements: the alternate
outlier rule of more than two standard deviations from the mean, the documented
error of averaging two group medians to estimate a combined median, and the
need to connect a reported numerical statistic to its contextual justification.
These decisions are recorded under `candidateContentTriage` in the JSON packet.

## What Is Easy

- extracting and preserving the current fields;
- editing topic-summary and practice-bridge copy;
- reusing the existing worked example;
- applying and checking row limits;
- switching between alternative box arrangements in a prototype.

## What Requires Judgment

- deciding whether a sentence belongs to the topic or unit surface;
- removing repetition without losing instructional meaning;
- turning prose into ordered reasoning or answer steps;
- writing corrections for named misconceptions;
- selecting which formulas belong on the topic page;
- distinguishing Cramapple guidance from an official rubric claim;
- approving rewritten content while the production source remains marked
  pending SME review.

## Recommendation

Continue the 1.7 pilot as a layout and editing test, but treat its topic-scope
decisions as provisional. For production authoring, start at 1.1 and maintain a
cumulative Unit 1 ledger through 1.7. Do not change the database yet. After two
or three sequential topics have been parsed, compare their box shapes and
content deltas. Only then decide whether the recurring structure warrants typed
columns, validated JSON, or normalized content-block records in production.
