# Course Mode 1.11 x 2.A Re-Derivation Record

STATUS: authoring QA record | DATE: 2026-08-24 | CELL: 1.11 x 2.A | TRACK: B

## Scope

- Template: `FB-U1-11-2A-SAMPLING-01`
- Generator: `scripts/course_mode_stats_generator/slot_frames.py`
- Cell: Topic 1.11 Random Sampling x Skill 2.A
- Serving/grading: MCQ choice-match
- Difficulty: Medium
- Release status: unreleased/generated pending review

This is an authored conceptual slot-frame. Correctness is determined by the AP Statistics Unit 1 sampling-method taxonomy: SRS, stratified random sample, cluster sample, systematic random sample, and non-random convenience / voluntary-response samples.

## Gate 1 Property Harness

Command:

```bash
python3 scripts/course_mode_stats_generator/slot_frames.py
```

Result for this template:

```text
FB-U1-11-2A-SAMPLING-01 | cell 1.11 x 2.A | 120 instances | 1440 checks | 0 failures | correct positions [0, 1, 2, 3] | correct_answer_position_varies=true
```

Meta-tests also passed: all frames OK, correct-answer position varies, misconception catalog self-check clean, scenario catalog self-check clean, and all four new `u1_11__` misconception tags are used by at least one distractor.

## Gate 2 Independent Re-Derivation

I re-derived the key and every new distractor type from the stem logic, not from the stored `correct` flags.

### Instance A

- Seed: `11000`
- Scenario: `u1_11__school_clubs`
- Stem summary: target population is all high-school students; the researcher records responses from students in the cafeteria during one lunch period.

Independent key derivation:

- The plan does not use a random mechanism.
- It reaches students who are physically easy to access in one location/time window.
- Therefore the method is a convenience sample, not a random sample.
- Emitted key matched: "Not a random sample; it is a convenience sample because the units are easy to reach."

Distractor checks:

- `u1_11__convenience_or_voluntary_called_random`: The SRS distractor incorrectly treats possible presence in the cafeteria response group as random selection. That matches the tag: calling convenience/voluntary participation random.
- `u1_11__stratified_cluster_confusion`: The cluster distractor incorrectly treats mention of a possible grouping, grade level, as enough to make a cluster sample. That matches the tag: confusing grouped-population vocabulary with the actual cluster rule.
- `u1_11__stratified_samples_whole_groups`: The stratified distractor says to choose whole grade-level groups and include everyone. That is the cluster-style whole-group error, not stratified sampling, so it matches the tag.

### Instance B

- Seed: `11004`
- Scenario: `u1_11__school_clubs`
- Stem summary: the researcher separates students by grade level, then randomly selects some students from every grade-level group.

Independent key derivation:

- The population is partitioned by a meaningful characteristic: grade level.
- The sample includes randomly selected individuals from every grade-level group.
- Therefore the method is a stratified random sample.
- Emitted key matched: "Stratified random sample, because the population is grouped by grade level and some students are randomly selected from every group."

Distractor checks:

- `u1_11__stratified_samples_whole_groups`: The distractor says stratified sampling should choose whole grade-level groups and include everyone. That reverses the rule; whole selected groups belong to cluster sampling.
- `u1_11__stratified_cluster_confusion`: The cluster distractor calls the plan cluster sampling merely because the population was divided into grade-level groups. The stem samples within every group, so this is the classic stratified/cluster confusion.
- `u1_11__systematic_srs_conflation`: The systematic distractor treats random selection after organizing the population as systematic sampling. The stem has no random start plus fixed interval, so this matches the SRS/systematic conflation tag.

All emitted keys and distractors matched their claimed sampling-method logic.

## Gate 3 CED Conformance & Rights

- CED alignment: Topic 1.11 Random Sampling, Skill 2.A, Practice 2. The frame asks students to identify/describe an appropriate data-collection method.
- Fact-pack anchor: `AP_STATISTICS_2027_CED_FACT_PACK.md` §10 Unit 1 (1.10-1.13), especially the vocabulary distinction among SRS, stratified, cluster, and systematic random samples; convenience and voluntary-response are non-random biased sampling methods.
- Scenario/source rights: contexts are original synthetic school, civic, library, business, and campus settings. No College Board question, released prompt, key, scoring language, or third-party wording was copied.

## Gate 4 Distractor Realism

Each distractor is a plausible named student error inside the scenario:

- calling convenience/voluntary response random;
- confusing stratified and cluster sampling;
- treating systematic sampling as any organized/random selection;
- thinking stratified sampling selects whole groups.

All distractors are catalog-cited in `misconceptions.py` and all scenarios are cell-namespaced in `scenarios.py`.

## Non-Execution Attestation

No loader was run, no SQL was generated or applied, no DB was touched, no release was attempted, no serving switch was flipped, and Production was untouched.
