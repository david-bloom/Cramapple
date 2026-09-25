# QA Report — Canonical Answers, Calc AB Through Physics 1 (2026-09-25)

**Scope:** Independent answer/rubric QA for the seven-subject corpus named in `docs/content/CODEX_QA_TASK_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md`, plus structural verification of the 195 canonical-answer writes made on 2026-09-25.

**Production:** `pcntajvbdfqhbeewmdry`

**Base:** `main` at `b02130daa56ae035e598f985f89ab1a5583c997c`

**No Production writes were made.** This report does not remediate any finding.

## Verdict

**FAIL — content remediation required.**

The morning canonical-write mechanics are clean: all 195 intended newly-authored items have spans on published versions, span concatenation equals `canonical_answer_1`, and span criterion-key sets exactly match their own version's `frq_criteria`. No other subject received a canonical/version update in the audited write window.

The broader legacy corpus is not clean. Independent review found **21 P0 item-level correctness/completeness defects** spanning canonical answers, rubrics, and two student-facing stems. Several are pre-existing canonicals that cannot earn all points their own rubrics require.

## Scope correction: 372 published FRQ items is not 372 current published versions

The task's “372 FRQs” count is the count of `content_items.status='published'` across the seven subjects. Only **349** of those items currently have a `content_item_versions.status='published'` version. The other **23** have no published version and therefore are not part of the current version-level answer QA.

This report preserves all 372 item rows in the appendix, but semantic answer/rubric QA is anchored to the 349 versions that are actually published.

| Subject | Published FRQ items | With a published version | Current canonicals | Current items with spans | New spans today | P0 findings |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Calculus AB | 62 | 62 | 62 | 33 | 33 | 1 |
| AP Chemistry | 53 | 51 | 51 | 1 | 1 | 7 |
| AP Physics 1 | 61 | 54 | 54 | 39 | 39 | 3 |
| AP Physics 2 | 37 | 28 | 28 | 19 | 19 | 4 |
| AP Physics C: Mechanics | 42 | 36 | 36 | 29 | 29 | 2 |
| AP Physics C: E&M | 55 | 49 | 49 | 39 | 39 | 2 |
| AP Statistics (old/general pack) | 84 | 69 | 69 | 35 | 35 | 2 |
| **Total** | **394** | **349** | **349** | **195** | **195** | **21** |

## P0 findings

| Item | Area | Finding |
| --- | --- | --- |
| `apcalcab-frq-005` | RUBRIC | Rubric says the source equation equals 14; stimulus says 16. Differentiated result happens to be unchanged. |
| `apchem-frq-l-002` | CANONICAL | Canonical never assigns the requested ozone formal charges. |
| `apchem-frq-l-003` | CANONICAL | Canonical omits the explicit ideal-gas assumptions and the requested Z-based experimental test. |
| `apchem-frq-l-004` | CANONICAL | Canonical omits the explicit 1:1 stoichiometric justification and complete-precipitation assumption in part (b). |
| `apchem-frq-l-005` | RUBRIC | Rubric includes mechanism criteria in parts (b)/(d) that the stem does not ask for, creating a grading/stem mismatch. |
| `apchem-frq-l-006` | CANONICAL | Canonical answers only part (a); parts (b)-(d) are absent. |
| `apchem-sfrq-008` | CANONICAL | Canonical omits the required pure-water/no-common-ion assumption in part (b). |
| `apchem-sfrq-009` | CANONICAL | Canonical omits the explicit Ka=x^2/(C-x) setup and <5% assumption requested in part (b). |
| `apphy1-frq-019` | CANONICAL | Canonical omits the required velocity-vector diagram and the explicit crossing-rate explanation. |
| `apphy1-frq-022` | CANONICAL | Canonical under-specifies the requested experimental procedure, measured quantities, and uncertainty reduction. |
| `apphy1-frq-029` | CANONICAL | Canonical omits the explicit stage-by-stage statement: momentum for impact, mechanical energy for rise. |
| `apphy2-frq-019` | CANONICAL | Canonical omits the requested P-V cycle sketch/arrows. |
| `apphy2-frq-023` | CANONICAL | Canonical gives correct circuit numbers but omits the requested junction/loop-rule explanation. |
| `apphy2-frq-028` | CANONICAL | Canonical omits the required ray diagram / two valid principal rays. |
| `apphy2-frq-032` | CANONICAL | Canonical omits the requested energy-level diagram. |
| `apphycm-frq-019` | CANONICAL | Canonical omits the requested free-body diagram / explicit force representation. |
| `apphycm-frq-026` | CANONICAL | Canonical omits the requested momentum-vector diagram, component equations, and explicit energy equation. |
| `apphycem-frq-017` | CANONICAL | Canonical omits the charge-element relation required by its rubric for the integral setup. |
| `apphycem-frq-np1-002` | STEM | Spherical-shell item incorrectly asks for justification using cylindrical symmetry; canonical/rubric correctly use spherical symmetry. |
| `APSTAT-MOD4-H001-INV` | CANONICAL/STEM | For Ha: treatment < control, t=-2.5607 gives one-sided p≈0.0069, not 0.014. The stated 0.014 is the two-sided p-value. |
| `apstats-frq-u12-020` | STEM/CANONICAL | Given n=40, mean=12.4, sample SD=3.1 and max=40 are mathematically incompatible; the item cannot describe a real dataset as written. |

### Two quantitative findings worth making explicit

**AP Statistics `APSTAT-MOD4-H001-INV`.** The canonical sets (H_a: \mu_T<\mu_C) and correctly computes (t=-2.5607). With Welch df ≈46.49, the corresponding **one-sided** p-value is ≈0.00688. The item's p≈0.014 is the two-sided p-value. The reject/not-reject conclusion at α=.05 is unchanged, but the stated hypothesis and p-value do not match.

**AP Statistics `apstats-frq-u12-020`.** The stem says (n=40), mean=12.4, sample SD=3.1, and maximum=40. The total sum of squared deviations implied by the SD is ((n-1)s^2=39(3.1^2)=374.79). The single 40-pound observation alone contributes ((40-12.4)^2=761.76), already more than the stated total. The summary statistics are impossible before any correction analysis is attempted.

## A. Independent correctness review

Every current published-version item was reviewed against its stem and rubric rather than by merely matching `learner_facing_text`. Quantitative/high-risk items were independently recomputed. The appendix records PASS versus the P0 exceptions above.

The 195 newly-authored items were treated as highest priority. No algebra/physics/chemistry error surfaced in the new Calc AB 33, Chemistry 1, Physics 2 19, Physics C: Mechanics 29, or Physics 1 39 canonical sets. The new Statistics set contains the two P0 issues described above. Physics C: E&M's new canonical for `apphycem-frq-np1-002` is itself correct, but the underlying stem says “cylindrical symmetry” for concentric spherical shells and must be repaired.

## B. Span and version integrity

For the **195 newly-authored canonical answers**:

- 195/195 spans are attached to a `status='published'` content-item version.
- 195/195 span concatenations equal `canonical_answer_1` byte-for-byte.
- 195/195 span criterion-key sets exactly equal the `frq_criteria.criterion_key` set on that same version.
- no criterion key appears in two content spans for the same answer.
- `assembly_literal` spans carry no criterion keys.
- no newly-created span is attached to a retired, draft, or changes-requested version.

The known Physics 1 version-identity correction is clean:
- `apphy1-frq-033`: spans are on published version 3 (`beacb3d2-fd4c-404d-95b9-e734637d17d8`), not v1/v2.
- `apphy1-frq-035`: spans are on published version 2 (`9f159e00-a8d9-4690-945b-c255632a5429`), not retired v1.

### Pre-existing segmentation debt

Among the 349 current published-version FRQs, **154 have no `canonical_answer_spans` rows**. These are pre-existing canonicals, not collateral damage from the morning writes.

| Subject | Current published FRQs | With spans | Without spans |
| --- | ---: | ---: | ---: |
| AP Calculus AB | 62 | 33 | 29 |
| AP Chemistry | 51 | 1 | 50 |
| AP Physics 1 | 54 | 39 | 15 |
| AP Physics 2 | 28 | 19 | 9 |
| AP Physics C: Mechanics | 36 | 29 | 7 |
| AP Physics C: E&M | 49 | 39 | 10 |
| AP Statistics | 69 | 35 | 34 |
| **Total** | **349** | **195** | **154** |

This should remain separate from criterion 4 itself: a canonical text may exist without Open-Hand segmentation.

## C. Calc AB duplicated-rubric re-verification

The four repaired items are:

- `apcalcab-frq-np2-008`
- `apcalcab-frq-u13-002`
- `apcalcab-frq-u13-006`
- `apcalcab-frq-u13-018`

A fresh scan across **all versions** of published FRQ content items in all seven Answer-QA subjects found **zero duplicate (content_item_version_id, criterion_key) groups**.

Limitation: the Calc AB repair was a DELETE and `app.frq_criteria` does not expose deletion-audit timestamps, so the no-collateral timestamp window cannot independently prove “no unrelated criteria row was deleted.” Current-state duplicate scanning verifies the stated defect is gone and did not reveal the same pattern elsewhere.

## D. Grader-gate reachability

Exactly one `app.qa_grade_frq` call was made for a canonical-bearing FRQ in each subject, per the revised task. All seven returned the same expected error:

`HTTP 409 {"error":"qa_path_ap_biology_only"}`

Subjects tested: Calc AB, Chemistry, Physics 1, Physics 2, Physics C: Mechanics, Physics C: E&M, Statistics.

No repeated calls were made after the closed gate was established. This is a product/QA-path blocker, not evidence against the answer content itself.

## E. No-collateral window

Audit window: **2026-09-25 01:00 UTC → QA run**.

`content_item_versions.updated_at` changes in the window occur in exactly the intended seven subjects and exactly the expected content-key counts:

| Subject | Changed content keys |
| --- | ---: |
| AP Calculus AB | 33 |
| AP Chemistry | 1 |
| AP Physics 1 | 39 |
| AP Physics 2 | 19 |
| AP Physics C: Mechanics | 29 |
| AP Physics C: E&M | 39 |
| AP Statistics | 35 |
| **Total** | **195** |

New `canonical_answer_spans.created_at` rows also occur on exactly those 195 content keys and no other subject. No newly-created `frq_criteria` rows appear in the window.

**Result:** no collateral canonical/version/span writes were found outside the intended 195-item set.

## Recommended remediation order

1. Repair the P0 canonicals/rubrics/stems in the findings table before treating the seven-subject corpus as full-point-answer clean.
2. Prioritize the items whose canonicals omit entire requested subparts or required representations; these can directly mislead grading and exemplars.
3. Repair the two Statistics numerical/source-data defects with independently recomputed source numbers, not by editing only the prose answer.
4. Decide whether the 154-item span backlog belongs in the current launch slice; do not conflate that decision with canonical-text presence.
5. After remediation, rerun this QA against the repaired version IDs and retain the same independent-derivation standard.

## Appendix — item-level coverage

“PASS” in the structural column means existing spans concatenate exactly and carry the exact rubric-key set. “No spans” identifies pre-existing segmentation debt, not an assertion that the canonical text is wrong.

### AP Calculus AB

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `apcalcab-frq-001` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-002` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-003` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-004` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-005` | 3 | yes | 0 | No spans (pre-existing debt) | **P0 RUBRIC** |
| `apcalcab-frq-006` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-007` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-008` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-009` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-010` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-011` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-012` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-015` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-016` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-017` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-018` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-019` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-020` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-022` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-023` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-024` | 2 | yes | 17 | PASS | PASS |
| `apcalcab-frq-025` | 2 | yes | 17 | PASS | PASS |
| `apcalcab-frq-026` | 2 | yes | 19 | PASS | PASS |
| `apcalcab-frq-027` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-028` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-030` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-031` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-032` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-033` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-034` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-035` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-036` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apcalcab-frq-np2-001` | 1 | yes | 5 | PASS | PASS |
| `apcalcab-frq-np2-002` | 1 | yes | 9 | PASS | PASS |
| `apcalcab-frq-np2-003` | 1 | yes | 9 | PASS | PASS |
| `apcalcab-frq-np2-004` | 1 | yes | 7 | PASS | PASS |
| `apcalcab-frq-np2-005` | 1 | yes | 11 | PASS | PASS |
| `apcalcab-frq-np2-006` | 1 | yes | 5 | PASS | PASS |
| `apcalcab-frq-np2-007` | 1 | yes | 5 | PASS | PASS |
| `apcalcab-frq-np2-008` | 2 | yes | 7 | PASS | PASS |
| `apcalcab-frq-np2-009` | 1 | yes | 7 | PASS | PASS |
| `apcalcab-frq-np2-010` | 1 | yes | 7 | PASS | PASS |
| `apcalcab-frq-u13-001` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-002` | 2 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-003` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-004` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-005` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-006` | 2 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-007` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-008` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-009` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-010` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-011` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-012` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-013` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-014` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-015` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-016` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-017` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-018` | 2 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-019` | 1 | yes | 17 | PASS | PASS |
| `apcalcab-frq-u13-020` | 1 | yes | 17 | PASS | PASS |

### AP Chemistry

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `apchem-frq-l-001` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apchem-frq-l-002` | 2 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apchem-frq-l-003` | 5 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apchem-frq-l-004` | 3 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apchem-frq-l-005` | 4 | yes | 0 | No spans (pre-existing debt) | **P0 RUBRIC** |
| `apchem-frq-l-006` | 2 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apchem-frq-l-010` | 5 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-011` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-012` | 2 | yes | 9 | PASS | PASS |
| `apchem-frq-l-013` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-014` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-016` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-017` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-020` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-021` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-022` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-023` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-024` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-025` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-026` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-027` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-frq-l-028` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-001` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apchem-sfrq-002` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-003` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-004` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-005` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-007` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-008` | 3 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apchem-sfrq-009` | 3 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apchem-sfrq-010` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-014` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-015` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-016` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-018` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-019` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-021` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-022` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-023` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-024` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-026` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-027` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-028` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-029` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-030` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-031` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-032` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-033` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-034` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-035` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-036` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-037` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apchem-sfrq-038` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |

### AP Physics 1

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `apphy1-frq-001` | 2 | yes | 3 | PASS | PASS |
| `apphy1-frq-002` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-003` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-004` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-009` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-012` | 2 | yes | 3 | PASS | PASS |
| `apphy1-frq-013` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-014` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-015` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-017` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-018` | 2 | yes | 3 | PASS | PASS |
| `apphy1-frq-019` | 2 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy1-frq-020` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-021` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-022` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy1-frq-023` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-024` | 2 | yes | 5 | PASS | PASS |
| `apphy1-frq-025` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-026` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-027` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-028` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-029` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy1-frq-030` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-031` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-032` | 2 | yes | 11 | PASS | PASS |
| `apphy1-frq-033` | 3 | yes | 5 | PASS | PASS |
| `apphy1-frq-034` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy1-frq-035` | 2 | yes | 19 | PASS | PASS |
| `apphy1-frq-037` | 2 | yes | 19 | PASS | PASS |
| `apphy1-frq-038` | 2 | yes | 15 | PASS | PASS |
| `apphy1-frq-039` | 2 | yes | 5 | PASS | PASS |
| `apphy1-frq-040` | 2 | yes | 9 | PASS | PASS |
| `apphy1-frq-041` | 2 | yes | 5 | PASS | PASS |
| `apphy1-frq-042` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-043` | 2 | yes | 5 | PASS | PASS |
| `apphy1-frq-044` | 1 | yes | 5 | PASS | PASS |
| `apphy1-frq-045` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-046` | 2 | yes | 3 | PASS | PASS |
| `apphy1-frq-047` | 2 | yes | 5 | PASS | PASS |
| `apphy1-frq-048` | 2 | yes | 3 | PASS | PASS |
| `apphy1-frq-049` | 2 | yes | 11 | PASS | PASS |
| `apphy1-frq-050` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-051` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy1-frq-052` | 2 | yes | 15 | PASS | PASS |
| `apphy1-frq-053` | 2 | yes | 9 | PASS | PASS |
| `apphy1-frq-054` | 2 | yes | 11 | PASS | PASS |
| `apphy1-frq-055` | 1 | yes | 7 | PASS | PASS |
| `apphy1-frq-056` | 2 | yes | 11 | PASS | PASS |
| `apphy1-frq-057` | 2 | yes | 15 | PASS | PASS |
| `apphy1-frq-058` | 2 | yes | 13 | PASS | PASS |
| `apphy1-frq-np1-001` | 1 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-002` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-003` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-004` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-005` | 1 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-006` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-007` | 1 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-008` | 1 | yes | 9 | PASS | PASS |
| `apphy1-frq-np1-009` | 2 | yes | 7 | PASS | PASS |
| `apphy1-frq-np1-010` | 1 | yes | 5 | PASS | PASS |
| `apphy1-frq-np2-007` | 1 | yes | 7 | PASS | PASS |

### AP Physics 2

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `apphy2-frq-001` | 2 | yes | 3 | PASS | PASS |
| `apphy2-frq-002` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy2-frq-003` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy2-frq-004` | 2 | yes | 3 | PASS | PASS |
| `apphy2-frq-005` | 3 | yes | 3 | PASS | PASS |
| `apphy2-frq-006` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-007` | 3 | yes | 3 | PASS | PASS |
| `apphy2-frq-008` | 2 | yes | 3 | PASS | PASS |
| `apphy2-frq-009` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-010` | 3 | yes | 3 | PASS | PASS |
| `apphy2-frq-011` | 2 | yes | 3 | PASS | PASS |
| `apphy2-frq-012` | 3 | yes | 3 | PASS | PASS |
| `apphy2-frq-013` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy2-frq-014` | 2 | yes | 3 | PASS | PASS |
| `apphy2-frq-015` | 2 | yes | 3 | PASS | PASS |
| `apphy2-frq-016` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-017` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy2-frq-018` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-019` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy2-frq-020` | 2 | yes | 11 | PASS | PASS |
| `apphy2-frq-021` | 2 | yes | 7 | PASS | PASS |
| `apphy2-frq-022` | 2 | yes | 13 | PASS | PASS |
| `apphy2-frq-023` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy2-frq-024` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-025` | 3 | yes | 13 | PASS | PASS |
| `apphy2-frq-026` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-027` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-028` | 4 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy2-frq-029` | 2 | yes | 5 | PASS | PASS |
| `apphy2-frq-030` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-031` | 2 | yes | 5 | PASS | PASS |
| `apphy2-frq-032` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphy2-frq-033` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphy2-frq-034` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphy2-frq-035` | 2 | yes | 19 | PASS | PASS |
| `apphy2-frq-036` | 2 | yes | 23 | PASS | PASS |
| `apphy2-frq-037` | 2 | yes | 19 | PASS | PASS |

### AP Physics C: Mechanics

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `apphycm-frq-001` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-002` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycm-frq-003` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycm-frq-004` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-005` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-006` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycm-frq-007` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-008` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycm-frq-009` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-010` | 3 | yes | 3 | PASS | PASS |
| `apphycm-frq-011` | 3 | yes | 3 | PASS | PASS |
| `apphycm-frq-012` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-013` | 3 | yes | 3 | PASS | PASS |
| `apphycm-frq-014` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycm-frq-015` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-016` | 2 | yes | 3 | PASS | PASS |
| `apphycm-frq-017` | 2 | yes | 13 | PASS | PASS |
| `apphycm-frq-018` | 3 | yes | 11 | PASS | PASS |
| `apphycm-frq-019` | 3 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphycm-frq-020` | 2 | yes | 7 | PASS | PASS |
| `apphycm-frq-021` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycm-frq-022` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycm-frq-023` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycm-frq-024` | 2 | yes | 13 | PASS | PASS |
| `apphycm-frq-025` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycm-frq-026` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphycm-frq-027` | 2 | yes | 7 | PASS | PASS |
| `apphycm-frq-028` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycm-frq-029` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycm-frq-030` | 2 | yes | 15 | PASS | PASS |
| `apphycm-frq-031` | 2 | yes | 7 | PASS | PASS |
| `apphycm-frq-032` | 2 | yes | 7 | PASS | PASS |
| `apphycm-frq-033` | 3 | yes | 13 | PASS | PASS |
| `apphycm-frq-034` | 2 | yes | 7 | PASS | PASS |
| `apphycm-frq-035` | 2 | yes | 19 | PASS | PASS |
| `apphycm-frq-036` | 2 | yes | 23 | PASS | PASS |
| `apphycm-frq-037` | 2 | yes | 19 | PASS | PASS |
| `apphycm-frq-044` | 2 | yes | 5 | PASS | PASS |
| `apphycm-frq-047` | 1 | yes | 7 | PASS | PASS |
| `apphycm-frq-049` | 1 | yes | 9 | PASS | PASS |
| `apphycm-frq-050` | 1 | yes | 9 | PASS | PASS |
| `apphycm-frq-051` | 1 | yes | 7 | PASS | PASS |

### AP Physics C: E&M

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `apphycem-frq-001` | 2 | yes | 3 | PASS | PASS |
| `apphycem-frq-002` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycem-frq-003` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycem-frq-004` | 2 | yes | 3 | PASS | PASS |
| `apphycem-frq-005` | 3 | yes | 3 | PASS | PASS |
| `apphycem-frq-006` | 3 | yes | 3 | PASS | PASS |
| `apphycem-frq-007` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycem-frq-008` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-009` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-010` | 3 | yes | 3 | PASS | PASS |
| `apphycem-frq-011` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-012` | 3 | yes | 3 | PASS | PASS |
| `apphycem-frq-013` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-014` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-015` | 2 | yes | 3 | PASS | PASS |
| `apphycem-frq-016` | 2 | yes | 3 | PASS | PASS |
| `apphycem-frq-017` | 1 | yes | 0 | No spans (pre-existing debt) | **P0 CANONICAL** |
| `apphycem-frq-018` | 2 | yes | 5 | PASS | PASS |
| `apphycem-frq-019` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycem-frq-020` | 2 | yes | 11 | PASS | PASS |
| `apphycem-frq-021` | 2 | yes | 15 | PASS | PASS |
| `apphycem-frq-022` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-023` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-024` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycem-frq-025` | 2 | yes | 15 | PASS | PASS |
| `apphycem-frq-026` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-027` | 2 | yes | 13 | PASS | PASS |
| `apphycem-frq-028` | 3 | yes | 9 | PASS | PASS |
| `apphycem-frq-029` | 4 | yes | 0 | No spans (pre-existing debt) | PASS |
| `apphycem-frq-030` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `apphycem-frq-031` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-032` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-033` | 2 | yes | 11 | PASS | PASS |
| `apphycem-frq-034` | 3 | yes | 7 | PASS | PASS |
| `apphycem-frq-035` | 2 | yes | 19 | PASS | PASS |
| `apphycem-frq-036` | 2 | yes | 23 | PASS | PASS |
| `apphycem-frq-037` | 2 | yes | 19 | PASS | PASS |
| `apphycem-frq-038` | 2 | yes | 15 | PASS | PASS |
| `apphycem-frq-040` | 1 | yes | 3 | PASS | PASS |
| `apphycem-frq-042` | 1 | yes | 5 | PASS | PASS |
| `apphycem-frq-048` | 1 | yes | 5 | PASS | PASS |
| `apphycem-frq-049` | 1 | yes | 9 | PASS | PASS |
| `apphycem-frq-050` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-051` | 1 | yes | 9 | PASS | PASS |
| `apphycem-frq-053` | 1 | yes | 9 | PASS | PASS |
| `apphycem-frq-056` | 1 | yes | 13 | PASS | PASS |
| `apphycem-frq-np1-001` | 2 | yes | 11 | PASS | PASS |
| `apphycem-frq-np1-002` | 2 | yes | 11 | PASS | **P0 STEM** |
| `apphycem-frq-np1-003` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-np1-004` | 2 | yes | 11 | PASS | PASS |
| `apphycem-frq-np1-005` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-np1-006` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-np1-007` | 2 | yes | 9 | PASS | PASS |
| `apphycem-frq-np1-009` | 2 | yes | 11 | PASS | PASS |
| `apphycem-frq-np1-010` | 2 | yes | 11 | PASS | PASS |

### AP Statistics (old/general pack)

| content_key | published version | canonical | spans | structural | content QA |
| --- | ---: | --- | ---: | --- | --- |
| `APSTAT-MOD3-E002` | 1 | yes | 1 | PASS | PASS |
| `APSTAT-MOD3-H001-INV` | 2 | yes | 9 | PASS | PASS |
| `APSTAT-MOD4-H001-INV` | 2 | yes | 7 | PASS | **P0 CANONICAL/STEM** |
| `APSTAT-MOD4-M001` | 2 | yes | 5 | PASS | PASS |
| `APSTAT-MOD5-H001-INV` | 1 | yes | 7 | PASS | PASS |
| `APSTAT-MOD5-M001` | 1 | yes | 1 | PASS | PASS |
| `APSTAT-MOD6-H001` | 1 | yes | 5 | PASS | PASS |
| `APSTAT-MOD6-H002-INV` | 1 | yes | 7 | PASS | PASS |
| `APSTAT-MOD6-M001` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTAT-MOD6-M002` | 1 | yes | 1 | PASS | PASS |
| `APSTAT-MOD7-H002-INV` | 1 | yes | 7 | PASS | PASS |
| `apstats-frq-u12-001` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-002` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-003` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-004` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-005` | 3 | yes | 7 | PASS | PASS |
| `apstats-frq-u12-006` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-007` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-008` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-009` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-010` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-011` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-012` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-013` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-014` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-015` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-016` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-017` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-018` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-019` | 1 | yes | 19 | PASS | PASS |
| `apstats-frq-u12-020` | 2 | yes | 19 | PASS | **P0 STEM/CANONICAL** |
| `APSTATS-HDG-2026-GRAPH-001` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-002` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-003` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-004` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-005` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-007` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-008` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-010` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-011` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-013` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-014` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-015` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-016` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-017` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-018` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-019` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-020` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-021` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-022` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-023` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-024` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-025` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-026` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-027` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-028` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-029` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-030` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-031` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-032` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-033` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-HDG-2026-GRAPH-034` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-035` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-HDG-2026-GRAPH-036` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-SFRQ-001` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-002` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-003` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-004` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-005` | 1 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-006` | — | no | 0 | No published version | Out of current published-version scope (latest=retired) |
| `APSTATS-SFRQ-007` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-008` | 3 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-009` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-010` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-011` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-012` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-013` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-014` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `APSTATS-SFRQ-016` | 2 | yes | 0 | No spans (pre-existing debt) | PASS |
| `STATS-MOD1-E002` | 2 | yes | 1 | PASS | PASS |
| `STATS-MOD1-E003` | 2 | yes | 1 | PASS | PASS |
| `STATS-MOD1-M001` | 1 | yes | 1 | PASS | PASS |
| `STATS-MOD3-M007` | 2 | yes | 1 | PASS | PASS |
| `STATS-MOD4-E005` | 1 | yes | 1 | PASS | PASS |

