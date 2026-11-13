# Calculus AB and BC Unit 5 topic releases (2026-11-12)

David directed authoring and Production publication of Unit 5 Calculus content one topic at a time, with identical new question text and choices in the AB and BC served packs. This supersedes his earlier preference for separately authored AB and BC questions. After Calculus, proceed to Biology. The original handoff prompt's stop-before-Production step is superseded for this named scope by David's explicit instruction. The one-time exception to the four-checker/planted-control MCQ protocol remains limited to these named Unit 5 batches; the two-model blind solve and two-model tier audit are required.

The shared College Board AP Calculus AB and BC CED has the same topic 5.1–5.12 map in both courses. The Production taxonomies also have the same topic codes and titles, with separate pack and taxonomy IDs. AB: pack `826c8cf1-bc1b-4f2a-bd33-61a758e1487d`, taxonomy `33b4408b-0ecc-4c7a-b0b1-612db81164a1`. BC: pack `3778d753-273a-403d-8f02-55dc64ec6a27`, taxonomy `ab088009-dc9a-4f93-8824-803e1913505b`.

## Topic 5.1 — Using the Mean Value Theorem

Read-only before audit, 2026-11-12: `python3 scripts/difficulty-audit/audit.py --subject 'AP Calculus AB' --units 5 --out /private/tmp/cramapple-unit5-evidence/audit-calcab-u5 --workdir /private/tmp/cramapple-unit5-calculus` (12 published Unit 5 AB items, zero model calls needed from the cached two-model audit). Topic 5.1 had two published AB MCQs, both R2 and neither with a valid serving label. BC topic 5.1 had zero published MCQs. Direct Production pack and taxonomy queries confirmed the topic mapping and denominator.

The authored topic 5.1 draft contains three families and three variants per family (12 items): polynomial MVT matching points, hypothesis checks, and contextual rate guarantees. The same `source_draft.md` is packaged separately for AB and BC. A comparison of the final `items.json` files confirmed identical stems, choices, keyed positions, and rationales for all 12 items. The required Unit 5 label for new topic-only items is `[5]`, based on the taxonomy unit mapping and existing validated Unit 5 labels in both courses; older provisional AB labels with `[2,5]` are not used as the default.

| Pack | Old published | Old valid serving | Old R1/R2/R3 | New seeds/variants | New R1/R2/R3 | Retire | Projected published | Projected valid serving |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| AB | 2 | 0 | 0/2/0 | 3/9 | 0/8/4 | 0 | 14 | 12 |
| BC | 0 | 0 | 0/0/0 | 3/9 | 0/12/0 | 0 | 12 | 12 |

The two preexisting AB items remain published but unserved; they are R2 and are outside the R1 retirement rule. No R1 family is retired or retained in topic 5.1. After the release, the modeled AB total is four R2 seeds (two existing plus two new), six R2 variants, one R3 seed, and three R3 variants. BC has three R2 seeds and nine R2 variants. Tiers are uncalibrated model judgments and differ by course prompt despite identical text.

Checks: format validator passed for both packs; each built two load chunks. DeepSeek and Kimi independently selected the keyed answer on all 12 AB items and all 12 BC items. Both tier models returned a tier for every item: AB 0 R1, 8 R2, 4 R3; BC 0 R1, 12 R2, 0 R3. Neither audit flagged a duplicate or disputed key. The author manually checked the MVT hypotheses and endpoint arithmetic: the cubic matching-slope equations, closed/open interval restrictions, continuity and differentiability counterexamples, and signed average rates. Every distractor rationale was checked against its own premise and key. No subject-expert review is claimed.

**Execution state:** Published to both Production packs under `APPROVAL-0260` on 2026-11-12. Each executor preflight found zero old retire keys and zero new existing keys; two load chunks per course, 12/12 draft hashes, successful rolled-back publish rehearsal, 12 published/12 topic cells/12 validated labels, 12/12 post-publish hashes, and new items returned by the student selector. Independent read-only Production verification found AB 14 published topic 5.1 MCQs with 12 valid serving labels (all 12 new), and BC 12 published with 12 valid serving labels (all 12 new).

## Topic 5.2 — Extreme Value Theorem, extrema, and critical points

The read-only 2026-11-12 Unit 5 audit found one published AB topic 5.2 MCQ, rated R2, without a valid serving label. BC had none. The shared CED lists topic 5.2 as FUN-1.C.1–3. The author wrote three families and three variants per family (12 items) covering EVT hypotheses, the distinction between critical points and local extrema, and comparisons of local and absolute extrema. The AB and BC packages use identical stems, choices, keyed positions, and rationales. Required units are `[5]` from the verified Unit 5 taxonomy mapping and validated labels elsewhere in the unit. Neither package retires an old item.

| Pack | Old published | Old valid serving | Old R1/R2/R3 | New seeds/variants | New R1/R2/R3 | Retire | Projected published | Projected valid serving |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| AB | 1 | 0 | 0/1/0 | 3/9 | 0/10/2 | 0 | 13 | 12 |
| BC | 0 | 0 | 0/0/0 | 3/9 | 0/11/1 | 0 | 12 | 12 |

The AB new family counts are one R2 seed, nine R2 variants, and two R3 seeds; including the old item, two R2 seeds remain published. BC has two R2 seeds, nine R2 variants, and one R3 seed. Tiers are uncalibrated model judgments. A cross-family and retained-old difflib comparison found zero stem pairs above 0.80.

A first AB execution attempt stopped during preflight, before any Production write, because the reused `b8` key prefix was already present for topic 5.1. Both topic 5.2 packages were rebuilt under the Production-verified unused `b9` prefixes and all checks were rerun with the same results. The per-topic prefix must be unique for later releases.

The format validator passed for both packs; each built two load chunks. DeepSeek and Kimi blind checks independently agreed with all 12 keys in each course. Both tier models returned all 12 tiers: AB 0 R1, 10 R2, 2 R3; BC 0 R1, 11 R2, 1 R3, with no duplicate or disputed-key flags. The author checked every example's domain, interval, derivative definition, and monotonic segment against the stated endpoint values. The wrong-choice rationales were checked against their own question premises. No subject-expert review is claimed. The one-time approved quality-gate exception applies.

**Execution state:** Published to both Production packs under `APPROVAL-0267` on 2026-11-12. Each executor preflight found zero old retire keys and zero new existing keys; two load chunks per course, 12/12 draft hashes, successful rolled-back publish rehearsal, 12 published/12 topic cells/12 validated labels, 12/12 post-publish hashes, and new items returned by the student selector. Independent read-only Production verification found AB 13 published topic 5.2 MCQs with 12 valid serving labels (all 12 new), and BC 12 published with 12 valid serving labels (all 12 new).

**Post-release inventory note (2026-11-13):** A separate label-gap release changed the broader Unit 5 inventory after the two topic releases. A fresh read-only count found topic 5.1 AB 14 published/14 valid-serving and BC 13/13; topic 5.2 AB 13/13 and BC 12/12. The original per-release counts above remain the execution-time evidence.

## Topic 5.3 — Increasing and decreasing intervals

Before write, a 2026-11-13 read-only Production query found no published AB topic 5.3 MCQ and one published/servable BC MCQ (`apcalcbc-mcq-029`, rated R2 in the prior Unit 5 audit). No R1 retirement applies. The shared CED identifies FUN-4.A.1 and derivative sign reasoning. Three new seed families with three variants each cover factored derivatives, derivative sign representations, and rational derivatives with domain gaps. The AB and BC package stems, choices, keyed positions, and rationales match 12/12.

| Pack | Existing published / servable | New seeds / variants | New R1 / R2 / R3 | Retire | After published / servable |
|---|---:|---:|---:|---:|---:|
| AB | 0 / 0 | 3 / 9 | 0 / 8 / 4 | 0 | 12 / 12 |
| BC | 1 / 1 | 3 / 9 | 0 / 10 / 2 | 0 | 13 / 13 |

AB new tiers split into one R2 seed, seven R2 variants, two R3 seeds, and two R3 variants. BC new tiers split into two R2 seeds, eight R2 variants, one R3 seed, and one R3 variant; the existing BC R2 seed remains. Tiers are uncalibrated. Cross-family and retained-old stem similarity over 0.80: zero. Both drafts validated and built two load chunks each. DeepSeek and Kimi blind solves agreed 12/12 in each course; both tier models returned a tier for all 12, with zero R1, duplicate, disputed-key, or missing-model flags. The author checked every derivative sign interval, even-multiplicity zero, domain break, and function-value inference, and the rationale for each wrong choice. No subject-expert review is claimed. The one-time QA exception applies.

**Execution state:** Published to both Production packs under `APPROVAL-0268` on 2026-11-13. Each executor preflight found zero existing new keys and zero retire keys, loaded two chunks, matched 12/12 draft hashes, passed a rolled-back publish rehearsal, published 12 items with 12 validated serving labels and 12 topic cells, matched 12/12 post-publish hashes, and returned new items through the student selector. Independent read-only Production verification found AB 12 published/12 valid-serving, BC 13/13, with 12 new items in each pack.

## Topic 5.4 — First Derivative Test

Before write, a 2026-11-13 read-only Production query found AB 3 published/servable topic 5.4 MCQs and BC 2/2. The earlier tier audit rated the AB three R2, BC one R2 and one R3. No R1 retirement applies. Three compactly authored families and three variants each (12 items per pack) cover simple derivative zeros, a sign chart with a stationary non-extremum, and even-multiplicity zeros. AB and BC stems, choices, keys, and rationales match 12/12. Required units `[5]` follow the verified taxonomy and existing validated Unit 5 labels.

| Pack | Existing published / servable | New seeds / variants | New R1 / R2 / R3 | Retire | After published / servable |
|---|---:|---:|---:|---:|---:|
| AB | 3 / 3 | 3 / 9 | 0 / 10 / 2 | 0 | 15 / 15 |
| BC | 2 / 2 | 3 / 9 | 0 / 11 / 1 | 0 | 14 / 14 |

AB new tiers: three R2 seeds, seven R2 variants, two R3 variants. BC new tiers: three R2 seeds, eight R2 variants, one R3 variant. Tiers are uncalibrated. Cross-family/retained-old similarity over 0.80: zero. Both drafts validated and built two load chunks; both tier models returned all 12 ratings with no R1, duplicate, disputed-key, or missing-model flags. Kimi's blind solve agreed 12/12 in AB and BC; DeepSeek agreed 11/12 in AB and 12/12 in BC. For AB variant `apcalcab-mcq-b11-sv-h-5.4-b-v1`, DeepSeek selected B but its written explanation says f' changes from negative to positive at x=-3 (local minimum), stays positive at x=1 (neither), and changes positive to negative at x=4 (local maximum). Those facts establish keyed A, which is text-identical to the BC item both blind solvers keyed correctly. The author checked all derivative sign patterns and rationales by hand; this is a resolved model-letter disagreement, not an unresolved key.

The old AB item `apcalcab-mcq-037` was flagged `key_disputed` in the before audit. Its derivative is x³−3.2x²−1.1x+2.4. Numerical roots are -0.909654, 0.796276, 3.313378, with derivative signs −/+, +/−, −/+ around them. Thus only x=0.796 is a local maximum, matching its published B key. No correction or retirement is needed. No subject-expert review is claimed. The one-time QA exception applies.

**Execution state:** Published to both Production packs under `APPROVAL-0268` on 2026-11-13. Each executor found zero existing new keys and zero retire keys, loaded two chunks, matched 12/12 draft hashes, passed a rolled-back publish rehearsal, published 12 items with 12 validated serving labels and 12 topic cells, matched 12/12 post-publish hashes, and returned all 12 new items through the student selector. Independent read-only Production verification found AB 15 published/15 valid-serving, BC 14/14.

## Topic 5.5 — Candidates Test for Absolute Extrema

Before write, a 2026-11-13 read-only Production count found AB one published/valid-serving topic 5.5 MCQ and BC zero. The read-only two-model audit of the AB item used `python3 -u scripts/difficulty-audit/audit.py --subject 'AP Calculus AB' --topics 5.5 --workers 2 --out /private/tmp/cramapple-calcab-u5-t5_5-before --workdir /private/tmp/cramapple-unit5-calculus`; `apcalcab-mcq-np2-003` rated R2 with no flags. No R1 family is retired. New packages `apcalcab-harder-seeds-u5-t5_5-2026-11-13` and `apcalcbc-harder-seeds-u5-t5_5-2026-11-13` each have three seeds and nine variants, with identical stems, choices, keys, and rationales in both packs. They cover polynomial candidate comparisons with ties, an interior nondifferentiable corner, and an exhaustive candidate-value table. All fit CED FUN-4.A.3 and required units `[5]`.

| Pack | Retained old R2 seeds / variants | New R1 / R2 / R3 | New seeds / variants | Retire | After published / valid-serving |
|---|---:|---:|---:|---:|---:|
| AB | 1 / 0 | 0 / 12 / 0 | 3 / 9 | 0 | 13 / 13 expected |
| BC | 0 / 0 | 0 / 12 / 0 | 3 / 9 | 0 | 12 / 12 expected |

After release, AB will have four R2 seed families and nine R2 variants; BC will have three R2 seed families and nine R2 variants. There are no R1 or R3 items in this batch. The R3 authoring target was not achieved; all new items met the owner's R2-or-R3 replacement floor. Tiers remain uncalibrated. Both draft validators passed and both packages built two load chunks. DeepSeek and Kimi blind solves agreed 12/12 keys in each pack; both tier models rated all 12 in each pack, with no R1, duplicates, disputed keys, or missing answers. The author checked each endpoint/critical-point value, tie, corner premise, choice, and rationale by hand. Cross-family and retained-old stem similarity over 0.80: zero. No subject-expert review is claimed. The one-time QA exception applies.

**Execution state:** Prepared under `APPROVAL-0268`; update after write.
