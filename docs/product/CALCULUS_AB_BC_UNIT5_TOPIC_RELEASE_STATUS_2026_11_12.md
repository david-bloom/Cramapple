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

**Execution state:** Published to both Production packs under `APPROVAL-0259` on 2026-11-12. Each executor preflight found zero old retire keys and zero new existing keys; two load chunks per course, 12/12 draft hashes, successful rolled-back publish rehearsal, 12 published/12 topic cells/12 validated labels, 12/12 post-publish hashes, and new items returned by the student selector. Independent read-only Production verification found AB 13 published topic 5.2 MCQs with 12 valid serving labels (all 12 new), and BC 12 published with 12 valid serving labels (all 12 new).
