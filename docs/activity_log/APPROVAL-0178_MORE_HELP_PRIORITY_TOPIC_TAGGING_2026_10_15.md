# APPROVAL-0178 — Tag the 65 priority More help questions

**Decision:** Approved;64 supported topic assignments applied and independently verified. One scope ruling remains.
**Date:** 2026-10-15
**Approver:** Product Owner David Bloom
**Tier:** Hard-Gate (live question-topic metadata)

David directed: **“Merge 464 and 29”** and **“65 untangled should be tagged.”** The latter refers to the preceding 65-question priority inventory:20 Calculus BC and45 Chemistry published versions with no selected topic and potentially eligible under current practice content predicates.

PR464 merged as `3b72e1340c331ca3e99f882c52dac4c963a19c3c`; app PR29 merged as `aa8398a6e6955a3edbc90000b78a09f436dafe91`. These merges do not establish app publication or a new Production function deployment.

Execution uses the existing six-vote topic process (three documented families, two independent samples each), independent CED reading, explicit adjudication of disagreements, exact source/version freshness guards, transaction rollback rehearsal and post-write verification. Store topic-only primary cells in `app.content_item_cells`; do not infer topic decisions from existing unit serving labels or content keys. Do not manufacture a CED alignment for an unsupported demand. Scope exceptions remain owner rulings.

The frozen65-version snapshot SHA-256 is `e739a0335c6b0c50036b96a4e8ebd43a04a2b2105fd620a60177c71cc871a6de`. The verified registry snapshot SHA-256 is `46cf0d4ee7b347238550ea3173f50f112c69040695f8c9c6258c592681dc008d`. Full questions, answer/rubric evidence, raw votes and credentials remain private. Public artifacts contain metadata, provenance, decisions and source hashes only.

The existing Gateway classification slate is verified available on today's live catalog: `google/gemini-3.8-flash`, `deepseek/deepseek-v4-pro`, `openai/gpt-6.1-sol`. The conductor imposes an internal run limit of420 attempts and$20, reserving worst-case input/output cost before every attempt and retaining uncertain charges. This is a new tagging run, independent of the exhausted12-request More help QA allowance. No credit purchase, new key, provider connection, paid reference-production run or content rewrite is included.

Do not change item text, choices, keys, rubrics, publication state, unit serving labels or existing learner records under this tagging batch. Existing reference gaps and out-of-scope questions remain separately visible. Add a defensible topic only after evidence/QA; report exceptions precisely.

**ID check:** main at `3b72e134` and its live approval index plus tracked standalone records (highest0177), no open Cramapple PRs at check. No archived-log scan needed.

**Result:** Production commit at2026-10-15T22:59:09.325092Z:20 BC +44 Chemistry primary cells, all64 exact row projections verified, all64 question/key/rubric source hashes unchanged. Stale-source negative control and insert/inverse rollback rehearsals passed. Independent post-commit readback passes. `apchem-mcq-043` remains untagged pending its CED scope ruling. Detailed [result](../qa/MORE_HELP_TOPIC_TAGGING_RESULT_2026_10_15.md) and [work order](../tasks/WORK-MORE-HELP-TOPIC-TAGGING-65.md).
