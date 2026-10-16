# More help — topic probe for untagged questions in units 1–3 (2026-10-16)

**Status:** probe complete, **nothing written to Production**. Owner approved the model budget 2026-10-16 ("any untagged question in units 1–3"); a Production write needs its own approval.

## Scope
Published questions with no topic cell whose serving label places them in each subject's first three units, excluding Physics 2 and Physics C E&M: **9 questions** (BC 1, Physics 1 1, Physics C Mechanics 1, Precalculus 6; the four known gaps are among them). Five carry only `provisional_model` unit labels, so the probe itself decides whether they belong in units 1–3.

**Not in scope, unresolved:** 96 further untagged questions have a `held` label with no unit (BC 39, Chemistry 30, Physics 1 12, Physics C Mechanics 12, Precalculus 3). They may include units 1–3 questions, but nothing says which, so they are not probed. Probing them would also classify some into unit 4+ and need a ruling first. The remaining untagged questions are labelled unit 4+ (validated or provisional) and are excluded.

## Method and ledger
Same `vote.mjs` as the 65-question pass (three families × two samples, frozen input hashes), 9-question snapshot. 63 attempts, 49 usable votes of 54 (DeepSeek truncated on several attempts, as before; a missing response is never counted as agreement), accounted cost **$0.77** against a $2 / 80-call ceiling. Private snapshot, votes and ledger stay in `/private/tmp/more-help-tagging-gap9-*`; `manifest.json` here holds metadata only.

## Dispositions
| Question | Votes | Disposition |
| --- | --- | --- |
| Physics 1 `apphy1-frq-np1-004` | 5/6 → 2.5 | **Accept 2.5** (matches the earlier CED read) |
| Precalculus `apprecalc-frq-016` | 5/6 → 3.13 | **Accept 3.13** |
| Precalculus `apprecalc-frq-u12-002` | 6/6 → 2.12 | **Accept 2.12** |
| Precalculus `apprecalc-mcq-sv-037-v3` | 4/6 → 1.13 | **Accept 1.13** (conditional band + CED 1.13.A). Its validated serving label says unit 2 while 1.13 is a unit 1 topic; the cell would not change the label |
| Physics C Mechanics `apphycm-frq-044` | 4/6 → 7.4, 2/6 → 3.4 | **Hold for owner.** CED text fits both: 3.4.B (conservation of mechanical energy, part a) and 7.4.A.4.ii (amplitude vs total energy, part b). The question never mentions oscillation; the label says unit 3; 7.4 is unit 7, outside the approved scope |
| BC `apcalcbc-frq-017` | 3 vs 2 of 5 | **Hold (multi-topic):** limits, continuity, derivative definition and IVT in one FRQ |
| Precalculus `apprecalc-frq-020` / `-np2-007` / `-np2-010` | 2-2, 3/6, 2/4 | **Hold (multi-topic):** each FRQ spans different topics |

A multi-topic FRQ has no single primary topic, so under the repo's "do not force a tag" rule it stays untagged. More help then refuses it (`reference_unavailable`) rather than grounding on the wrong topic's facts.

## Caveats
- CED adjudication here is by the agent after seeing the votes (not blind, not independent). The 65-question pass used blind independent reviews; request one before a Production write if wanted.
- Effect: the four accepted cells would give Physics 1 +1, Precalculus +3 More help-eligible units 1–3 questions (all FRQ but one MCQ). They are not a prerequisite for the next subject's rollout.
- The earlier guarded load (`../../scripts/content-seed/more-help-topic-tagging-65-2026-10-15/`) is tied to that pass's evidence files; the four-row load needs an adapted, rehearsed (rollback) and recovery-tested version.
