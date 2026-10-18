# APPROVAL-0195 — Publish 88 Precalculus Units 1–3 MCQs with validated skills (2026-10-17)

**Status: EXECUTED 2026-10-17; all 88 items published and verified.** Approver: David Bloom, explicit chat instruction: “publish the 88 items with validated skills.” This records the existing authorization; no further approval is pending.

Scope: 22 seeds and 66 variants, eight items per topic: 1.1, 1.3, 1.11, 2.1, 2.2, 2.8, 2.9, 2.14, 3.4, 3.8, 3.15. All 88 skills are validated, including the three resolved families. Keys `apprecalc-mcq-051` through `apprecalc-mcq-072`, each with `apprecalc-mcq-sv-NNN-v1..v3`. Production `pcntajvbdfqhbeewmdry`, pack `5522b532-5e50-41f2-99a2-10144bd4e8db`, taxonomy `16383753-6775-430d-960a-544cd6ee0972`. Source tag `precalculus-u13-gap-fill-2026-10-17`.

## Exact checked packet

Private plans and evidence: originating checkout `tmp/precalculus-gap-fill-2026-10-16/batch/publication_2026-10-17/`. The full plan maps every checked payload hash, key, topic, skill and difficulty; all 88 match canonical accepted candidates. SHA-256:

- `plan.json`: `3bc0e55e51a7d4f086821afd9431a064a8e10643add95405d1147a7062d49fff`
- `pilot.plan.json`: `3b1d6d41fd150eec39533c072cb1906a6ab07d270498a1373c4e0ef5cea501f0`
- `remainder.plan.json`: `b9f3aefaf2a1571af0317551e583ace5f3485c30d168f20129db777276641fca`

Immutable private QA archive: `/Users/davidbloom/Documents/Codex/2026-10-16/sta/outputs/precalculus-gap-fill/PRE_PUBLICATION_QA.private.zip`, SHA-256 `24460e62372097fe81ef23f33a3917a90bb009d1dd5ed2d1e693c714b104cc23`. Contains original and follow-up QA evidence, raw votes and source manifests. [QA record](../qa/PRECALCULUS_U1_U3_MCQ_GAP_FILL_2026_10_16.md). All four non-author solver/audit families, own-family veto, topic consensus, deterministic answer checks, similarity/family gates and skill-validation requirements passed. Total accounted checking cost upper bound $13.684131102/$30; publication requires no model calls.

## Publication and verification

Canonical `scripts/content-seed/publish_mcq_batch.py` only: plan → preflight → rollback rehearsal → recorded approval → publish → verify. Production preflight passed: correct pack, taxonomy, owner and all 88 keys absent. All three full-plan rollback transactions passed (40/40/8 published and validated skill cells), and an independent absence check passed before the first commit. The script inserts owner review assignment/approve decisions per DECISION-0102 and traverses structural QA, reviewed_approved, fresh serving labels, validated primary topic and skill cells, difficulty and published states in guarded transactions.

Publish the first eight as the scored-batch pilot; verify through the real paged student selector and exact payload/labels, then publish the remaining 80 under this same approval. Run full canonical verification plus independent exact key/skill/topic/difficulty/hash and selector checks, and recensus all 44 topics. Baseline: 181 practice MCQs, 11 zero topics. Expected: 269, zero empty topics. Availability remains subject to the student's unit position, unanswered and unrevealed eligibility.

Recovery: failed chunks roll back atomically; if a committed item requires withdrawal, retire only these new published versions through a separately recorded scoped recovery. Existing items, student records, app, schema, Edge Functions and policies are outside this release.

## Execution receipts

Completed at 2026-10-17T22:02:15.431020+00:00. Canonical loader published pilot 8, then 40+40, with a passing rollback rehearsal before every committed transaction. Full canonical verification: 88/88 found, text-matched, published, serving labels, topic cells, skill cells and difficulty. Independent read-back: 88 exact expected skills/topics/difficulties, 352 choices, correct keys and canonical answers, 88 current fresh serving labels, 88 approval decisions and no duplicate published versions. Actual paged student selector under service_role returns batch 24/64/88 at unit gates 1/2/3; no student state changed. Live census: 269 practice MCQs, all 11 target topics now eight each, zero empty topics. Server-side availability verified; no signed-in browser session performed. No additional model spend or app/schema/function changes. Full plans, publication receipts, read-back SQL/results and census are retained privately in the verified output archive. [Full QA/publication record](../qa/PRECALCULUS_U1_U3_MCQ_GAP_FILL_2026_10_16.md).

## Concurrent approval-ID collision discovered on closeout

Fresh main integration on 2026-10-18 revealed another session used APPROVAL-0195 for Physics 1 after this session checked the namespace and pushed this Precalculus approval. This record and immutable Precalculus plan/source tag identify the actual 88-item execution; the live historical approval reference is preserved. Always cite this full filename for Precalculus; `APPROVAL-0195_PHYSICS1_TOPIC_1_3_MCQ_GAP_FILL_LOAD_2026_10_17.md` governs only its separate Physics release. No content or approval database rows were changed to resolve this documentation collision.
