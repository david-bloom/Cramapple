# Reviewer QA Remediation — 2026-07-25

**Production project:** `pcntajvbdfqhbeewmdry`  
**Execution SQL:** `scripts/content-seed/reviewer-qa-remediation/20260725_remediate_review_findings.sql`

## Purpose

This remediation closes content and workflow defects discovered while assessing:

- SK MD Ferdous — AP Calculus AB
- Muhammad Saood — AP Physics
- Adil Abbasi — AP Biology
- Muhammad Zeeshan Hanif (profile display name: Muhammad Zeeshan) — AP Chemistry

Reviewer decisions and completed assignments were preserved. Defective content was not edited in place after review; corrected packages were inserted as new immutable versions and routed back through `tutor_question` review.

## New corrected versions

| Subject | Content key | Correction |
|---|---|---|
| Calculus AB | `apcalcab-frq-005` | Changed the curve constant from 14 to 16 so `(2,2)` lies on the curve; retained and reverified derivative, slope, and normal line. |
| Calculus AB | `apcalcab-frq-014` | Replaced the out-of-scope integrating-factor task with a separable differential equation; rederived Euler and exact answers. |
| Physics C: E&M | `apphycem-mcq-003` | Removed the second response that became numerically equivalent to zero in a charge-free region. |
| Physics C: E&M | `apphycem-frq-014` | Replaced the false “doubling L halves E” generalization with the correct fixed-position ratio and boundary condition. |
| Physics 1 | `apphy1-frq-013` | Aligned rubric and canonical answer with the prompt’s doubled-weight condition. |
| Physics 1 | `apphy1-frq-025` | Added a nonzero initial applied force so a cart starting from rest can move; recomputed work, speed, elapsed time, and power. |
| Physics 2 | `apphy2-frq-006` | Stated that the coherent sources emit in phase, making the keyed interference conclusion determinate. |
| Physics 2 | `apphy2-mcq-011` | Replaced law-name trivia with a Faraday-law calculation and distinct diagnostic distractors. |
| Physics 2 | `apphy2-mcq-016` | Replaced formula-recognition trivia with a numerical wave-speed application and plausible error paths. |
| Physics 2 | `apphy2-mcq-018` | Replaced qualitative extremes with a factor-change question testing the square-root tension relationship. |
| Biology | `APBIO-MCQ-007` | Removed the backwards claim that high heat of vaporization drives rapid evaporation; aligned the stem and key with energy transfer and cohesion. |
| Biology | `APBIO-MCQ-009` | Added an observed pH/activity time course and low-buffer-capacity condition so the prediction is determinate; corrected rationales. |
| Chemistry | `apchem-frq-l-002` | Supplied complete Lewis structures by replacing the broken SO₂ prompt with an explicit ozone resonance package; corrected formal-charge, geometry, bond-order, and experimental criteria. |
| Chemistry | `apchem-frq-l-005` | Required independent variation of both reactants and distinguished later net rate from the initial forward rate. |
| Chemistry | `apchem-mcq-016` | Corrected the stem to state that inert gas at constant volume does **not** shift equilibrium. |

The scientifically correct controls `APBIO-FRQ-L-034` and `apchem-mcq-050` were not changed to conform to incorrect reviewer suggestions.

## Biology systemic remediation

### Long FRQs

All 42 `APBIO-FRQ-L-*` latest versions now satisfy:

- exactly four criteria;
- exactly nine points;
- visible `Part A` through `Part D` labels;
- non-null stimulus;
- non-null canonical answer; and
- `content_hash = md5(stem)`.

Seven already-forked versions (`L-001`, `L-005`, `L-009`, `L-031`, `L-034`, `L-038`, `L-041`) had lost copied stimulus/canonical fields during the earlier structure correction. Those fields were restored from version 1 only after confirming that no decision existed on version 2. Their existing pending Adil assignments were preserved.

### Short FRQs

All 100 `APBIO-FRQ-S-*` packages had only two parts rather than the current four-part AP Biology short-FRQ structure. They were quarantined:

- 100/100 content items are `retired`;
- every associated version is `retired`;
- five pending assignments were changed to `skipped`;
- zero active assignments remain; and
- 24 submitted assignments and their decisions remain intact.

These items require genuine authoring of two additional, stimulus-grounded parts before replacement versions can enter review. Mechanical splitting or relabeling was rejected because it would satisfy the row count without restoring the missing assessment coverage.

## Reviewer workflow remediation

- Ferdous’s calculus validator qualification was changed from `active` to `suspended`, with the QA reason recorded.
- His profile, 32 submitted assignments, and immutable decisions were preserved.
- Corrected calculus versions were assigned to Carlos Eduardo Hutchings.
- Corrected physics versions were assigned to Muhammad Saood.
- Corrected Biology MCQs were assigned to Amjad Ali.
- Corrected Chemistry versions were assigned to Muhammad Zeeshan Hanif (database profile: Muhammad Zeeshan).
- Each of the 15 corrected versions has exactly one `tutor_question` assignment with matching `review_kind` and `pending` status.

## Prevention

Updated:

- `prompts/Biology Short FRQ Promp.txt`
- `prompts/Biology Long FRQ Prompt.txt`

The prompts now require:

- exact `Part A`–`Part D` labels;
- short FRQs with `1/1/1/1` points;
- long FRQs with `1/3/3/2`, or `1/4/2/2` only for the Part-B graph-construction archetype;
- blocking rejection of incorrect part counts or point totals; and
- independent authorship without viewing, adapting, deriving from, or imitating released or secure College Board questions.

## Final reconciliation

Production queries returned:

- corrected target versions: **15**
- corrected targets at version 2: **15**
- valid `md5(stem)` hashes: **15/15**
- MCQs with four choices, one key, and four nonblank rationales: **7/7**
- FRQs with nonempty criteria, evidence requirements, and minimum fixes: **8/8**
- corrected versions with exactly one pending assignment: **15/15**
- Biology long FRQs structurally complete: **42/42**
- Biology short FRQs quarantined: **100/100**
- active assignments on quarantined short FRQs: **0**
- Ferdous qualification status: **suspended**

The first transaction attempt failed during SQL analysis because PostgreSQL does not implement `max(uuid)`. It made no changes. The UUID selector was replaced with filtered `array_agg`, and the complete transaction then committed successfully.
