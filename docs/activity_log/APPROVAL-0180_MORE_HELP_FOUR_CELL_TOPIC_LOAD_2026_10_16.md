# APPROVAL-0180 — Write four accepted primary topic cells (More help topic gaps, units 1–3)

**Decision:** Approved and applied; independently verified.
**Date:** 2026-10-16
**Approver:** Product Owner David Bloom
**Tier:** Hard-Gate (live question-topic metadata)

David directed: **"Prepare the four-cell topic load and move to production."** Scope is the four accepted questions in the [topic probe result](../qa/MORE_HELP_TOPIC_GAP9_RESULT_2026_10_16.md): Physics 1 `apphy1-frq-np1-004` → 2.5, Precalculus `apprecalc-frq-016` → 3.13, `apprecalc-frq-u12-002` → 2.12, `apprecalc-mcq-sv-037-v3` → 1.13. The five held questions (Physics C Mechanics `apphycm-frq-044`, BC `apcalcbc-frq-017`, Precalculus `-020`, `-np2-007`, `-np2-010`) were **not** written.

**Method:** the proven 64-cell load (APPROVAL-0178) adapted to four rows by [`build_load.py`](../../scripts/content-seed/more-help-topic-tagging-gap9-2026-10-16/build_load.py): share-mode locks on content/label/registry metadata, exact version-hash and taxonomy-hash guards, latest-version check, serving-label id/version/status pinning, topic-in-exact-registry check, no-existing-cell check, exact row-hash verification, and a source-unchanged assertion. One serving label (`apprecalc-frq-u12-002`) is `provisional_model` with no recorded hash, so its guard pins id, version and status instead of a hash.

**Rehearsals on Production (all rolled back, zero rows persisted):** a stale-source negative control (one source hash tampered) refused with "Stale or changed question source"; the full load verified 4 rows; an insert-then-recover transaction restored the original absence.

**Result:** committed; independent read-back confirms 4 current validated primary cells (decision `18c6c823-3353-5d63-8180-d3a8736f08c4`), no human validator, question text/keys/rubrics byte-unchanged, each topic backed by 5–7 published reference entries. Metadata only; full questions and votes stay private. Recovery: [`recovery.sql`](../../scripts/content-seed/more-help-topic-tagging-gap9-2026-10-16/recovery.sql) (requires a current recovery decision; refuses if the cells or sources changed).

**Caveats on the record:** topic adjudication was by the agent after seeing the votes (not blind or independent); `apprecalc-mcq-sv-037-v3` was accepted in the conditional 4-of-6 band with a CED read, and its validated serving label says unit 2 while topic 1.13 is a unit 1 topic (the label is unchanged). The cells make these questions resolvable for More help in Physics 1 and Precalculus; neither subject is enabled.

**ID check:** main's highest record was 0178, 0179 is on the backend branch (not merged), no remote branch or open PR claimed 0180.
