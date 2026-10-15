# Calculus AB and Chemistry Units 1–3: complete source audit

**Final status: PASS for required-visual completeness.** See [the bounded certificate](CALC_CHEM_U13_VISUAL_COMPLETENESS_CERTIFICATE_2026_10_15.md) and [final independentQA](CALC_CHEM_U13_IMAGE_FINAL_QA_2026_10_15.md). The remaining text preserves the earlier source-audit/review packet; its pending-release statements are historical.

The 2026-10-15 07:39 UTC Production snapshot includes **all 726 published versions** in both subjects: 448 Calculus AB and 278 Chemistry. Every stem, stimulus, choice and authored FRQ part was semantically reviewed, including the keyword-negative rows and every later-unit/held/provisional item. Auditing this superset prevents uncertain unit labels from hiding an image defect. No question is certified merely because a regex found no visual keyword. Prior 91 reviews were reused only after exact comparison of the complete learner-facing source; all 91 matched.

The frozen inventory, per-question reasons/version/source hashes, query and summary are in `scripts/image_readiness/calc-chem-u13-certification/`. Answers, rubric text, learner work and tokens are excluded. Complete tables, equations, text-defined structures, answer descriptions and student-constructed diagrams are distinct from missing prompt visuals. The classifications are source judgments by the implementation agent; no independent semantic census is claimed.

The review found four already repaired visual constructs and two additional constructs whose numerical data are complete but whose graph/particle-model skill is better represented visually:

| Question | Disposition |
| --- | --- |
| `apcalcab-frq-u13-002` | Prior live graph; signed bytes and signed-in desktop view verified |
| `apcalcab-frq-u13g-1-3` | Prior live graph; signed bytes and signed-in desktop view verified |
| `apcalcab-oht-1.3` | Prior live teaching graph; student-role lookup plus signed-in desktop view verified |
| `apchem-oht-3.8` | Prior live teaching particles; student-role lookup plus signed-in desktop view verified |
| `apcalcab-mcq-060` | Additional graph built, four build checks pass; not attached |
| `apchem-frq-u13g-3-8` | Additional equal-volume ion models built, four build checks pass; not attached |

The two follow-up builds are at `scripts/question-visuals-certification/`. They preserve all source text, choices, scoring and taxonomy. The Chemistry source already contains a complete counts table; the picture repairs representation fidelity rather than missing numerical data. Accessible descriptions repeat givens without adding the calculated answer or requested water orientation.

## Ten unit uncertainties resolved

All ten original uncertain candidates have a documented content-based audit resolution: **one entirely within Units 1–3, nine requiring later units**, zero unresolved. See `ten-unit-resolutions.json` for exact versions, reasons and preserved existing serving-label evidence.

| Question | Audit units | Strict Units 1–3 |
| --- | --- | --- |
| `apcalcab-frq-u13-006` | 2 | Include |
| `apcalcab-frq-u13-003` | 2, 4 | Exclude conservatively: derivative meaning in context |
| `apcalcab-frq-np2-006` | 6, 8 | Exclude |
| `apcalcab-mcq-np2-005` | 6 | Exclude |
| `apcalcab-mcq-np2-009` | 5 | Exclude |
| `apchem-frq-l-016` | 1, 3, 4 | Exclude |
| `apchem-frq-l-022` | 7 | Exclude |
| `apchem-frq-l-024` | 7, 8 | Exclude |
| `apchem-frq-l-025` | 4, 7, 8 | Exclude |
| `apchem-frq-l-028` | 9 | Exclude |

These are audit membership judgments, not a six-vote serving-label validation. No held/provisional record was promoted and no database taxonomy changed. All ten were image-reviewed regardless of scope; the conservative Unit 4 decision therefore creates no audit blind spot.

## Reference access and limits

The live Chemistry reference pane lacked a periodic table. David subsequently directed: “Don’t worry about the periodic table. Kids have access to many. We can add a link to an online source.” The 17 reference-dependent rows are therefore owner-accepted reference access, not missing question images. A minimal Chemistry-only link to the official full College Board periodic-table PDF has been prepared in the student app. It retains the current reference assistance gate, opens a new tab and does not highlight a correct element. No copied table asset or periodic-table deployment is required for certification.

Certification is limited to required question visuals, not mathematical/key/rubric correctness. Separate source-drift leads remain: `apcalcab-frq-005` has obsolete legacy RHS14 versus current RHS16; `apcalcab-mcq-012`/`013` have legacy embedded choices differing from live choice rows; `apchem-mcq-030` wording/alternatives need a separate correctness review. The confirmed subject-switch stale-worked-question defect in the prior browser report also remains open and must be distinguished from missing image linkage.

The existing four were browser-checked with the owner's admin profile in student-facing views; actual student-role teaching lookups were checked separately. Phone delivery, fresh independent review, the two new live images, expired/decode-error scoring behavior and a controlled submitted answer have not been verified. Do not report those as passing.

## Review and release packet

Independent reviewer: read the per-question source ledger, all ten resolutions, six source/visual pairs, no-answer-leak descriptions and negative controls. Recheck the conservative `u13-003` scope decision and the two additional construct judgments. Review prepared transaction/recovery guards without executing them. Return a fresh-context Pass/Fail with blockers and limits.

After that review, the authorized implementation owner can attach the two exact approved visuals through the existing private contract, verify byte hashes/public denial/signed delivery, test actual desktop/phone paths, and issue the bounded certification. Keep certification open until those checks finish. No additional content rewrites, label validations, new renderer families, schema or Edge Function deployment are included.
