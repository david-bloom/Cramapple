# APPROVAL-0250 — AP Precalculus Unit 1 topics 1.1 to 1.7: 56 items published, 36 retired (granted and executed 2026-11-12)

- **Status:** Granted by David in chat ("Move these to production", after "Re stats unit 1 trim the list so each topic has at least 12 questions", 2026-11-12) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Unit 1 audit across subjects (`docs/product/UNIT1_RELEVELING_STATUS_2026_11_12.md`); re-levels to the owner's difficulty standard (`QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`).

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Precalculus.
- **Loaded and published 56 MCQs** (two new seeds per topic, three variants each); serving labels validated with required units set per topic; topic-only cells; correct answer position balanced across A to D.
- **Retired 36 superseded practice MCQs** (whole families whose seed the difficulty tool rated R1; teaching items excluded).
- Package: `scripts/content-seed/apprecalc-harder-seeds-u1a-2026-11-12/`.

## Verification
- Before each write the retire keys were published and none of the new keys existed (the script stops on any mismatch; it stopped once on Statistics, before any write, which led to the narrower retire list above).
- Authored in session against a strict format and validator; numbers recomputed in Python. Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`; every disputed key re-derived by hand.
- Executed: hash check 56/56, publish and retire rehearsals passed in rolled-back transactions, post-check hash 56/56, the real selector returned new items for every topic.

## Not done
No live student session; no subject-expert read; rationales not model-audited; attempt history on retired items not inspected. Difficulty tiers are uncalibrated model judgements.
