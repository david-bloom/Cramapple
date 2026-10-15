# More help priority topic tagging — result, 2026-10-15

**Status:**64 supported assignments applied in Production;1 owner-dependent scope exception remains.
**Authorization:** [APPROVAL-0178](../activity_log/APPROVAL-0178_MORE_HELP_PRIORITY_TOPIC_TAGGING_2026_10_15.md)
**Work:** [65-question work order](../tasks/WORK-MORE-HELP-TOPIC-TAGGING-65.md)

David requested merging PR464 and app29 and tagging the65 potentially practice-eligible untagged questions. Both PRs are confirmed merged: backend `3b72e1340c331ca3e99f882c52dac4c963a19c3c` and app `aa8398a6e6955a3edbc90000b78a09f436dafe91`. This records source merges, not app publication or new Production function deployment.

## Actual changes

Production committed20 Calculus BC and44 Chemistry primary topic-only cells at2026-10-15T22:59:09.325092Z. Each is validated against exact registry/source evidence, with model-run provenance and batch decision UUID `68ccbdae-0349-5ba8-bbdd-27ecee4a27bc`. No existing cell was overwritten; all64 versions previously had zero cells.

Immediate and independent post-commit verification confirmed64 planned /64 exact inserted projections /64 unchanged source fingerprints. Questions, choices, keys, rubrics, unit serving labels and learner records were not changed. Development was not populated with missing Production bank items; no bank-parity claim is made.

The [manifest](../../scripts/content-seed/more-help-topic-tagging-65-2026-10-15/manifest.json), [execution evidence](../../scripts/content-seed/more-help-topic-tagging-65-2026-10-15/execution.json), [verification SQL](../../scripts/content-seed/more-help-topic-tagging-65-2026-10-15/verify.sql) and [independent QA](QA_MORE_HELP_TOPIC_TAGGING_64_2026_10_15.md) preserve exact metadata and evidence boundaries. Full authored questions, answer/rubric evidence and raw votes remain private.

## Classification and QA

The existing three-family/two-sample method produced388 usable votes of390 from396 bounded attempts. Conservative accounted cost was$3.42, within the conductor's420-attempt/$20 internal ceiling. Eight truncated DeepSeek attempts include retries; two logical votes remained missing, never counted as agreement.

Both subjects received independent blind CED review before votes were shown. Final64 decisions comprise52 consensus-plus-independent-review assignments and12 explicit CED adjudications. Important boundaries include conjugate pairs at Chemistry4.8 rather than the misleadingly broad8.1 title, and Q/K direction at7.7 rather than the nearby introduction/expression topics. BC6.14 is supported by the CED's mixed-antidifferentiation selection direction; it has no standalone LO/EK, and none was fabricated.

The load passed a deliberate stale-source negative control, a64-row insertion/ROLLBACK rehearsal and an insert/inverse/ROLLBACK recovery rehearsal. The exact committed body differs from rehearsal only in final transaction action. Short metadata locks and guards prevent concurrent source/label/registry/subject drift; exact cell projection hashes and source invariance are asserted inside the transaction. Prepared recovery refuses changed sources, additional cells or a subsequent human validator. Independent read-only post-commit QA passes for these assignments, not the broader More help release.

## Updated gaps

| Subject | No selected topic before | After | Potentially practice eligible and still untagged | Mapped versions still missing reference entries |
| --- | ---: | ---: | ---: | ---: |
| Calculus AB |1|1|0|80|
| Calculus BC |84|64|0|22|
| Chemistry |81|37|1|0|
| Total |166|102|1|102|

The102 still-untagged versions comprise101 without active validated serving labels plus the one scope exception. The separate102 **mapped but missing reference content** comprise AB80 andBC22. These numerically equal totals describe different sets.

A read-only actual `get_topic_point_guides` probe with an ephemeral synthetic auth claim confirms usable published reference entries for45 newly tagged questions (44 Chemistry,1 BC). The other19 newly tagged BC questions still need later-unit reference content. Their mapping makes that content gap measurable; tagging alone does not fill it. No provider help call was made, and no actual student/session identity or entitlement flow is certified by this SQL probe. All64 newly tagged questions have no attached question image in the checked metadata.

The reproducible prior inventory queries are [reference coverage](MORE_HELP_REFERENCE_COVERAGE_2026_10_15.sql) and [practice content eligibility](MORE_HELP_TOPIC_TAGGING_PRIORITY_2026_10_15.sql); the [guide probe](../../scripts/content-seed/more-help-topic-tagging-65-2026-10-15/verify_guides.sql) is saved separately.

## Remaining owner-dependent item

`apchem-mcq-043` (version `99b2b547-b2a8-49a9-bf16-c692589ec7c6`) asks decomposition classification. Four votes suggested4.7, two returnedNONE; independent exact CED review found no matching assessed EK for this demand. CED4.7's named classification objective covers acid–base, redox and precipitation. It remains unchanged and untagged pending the presented owner choice: queue a rewrite, or explicitly accept a4.7 scope exception. Do not force a validated alignment merely to reach65.

No ruling on the separate four already-tagged expanded-octet questions in TASK-0076 was inferred. The reference-production slate/budget and6.14 reference handling remain pending. Full More help release QA, actual image/figure output and FRQ/photo checks remain separate from these metadata results.
