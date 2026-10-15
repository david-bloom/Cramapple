# More help — reassessment after today's activity-log updates

**STATUS: CURRENT**
**Date:** 2026-10-15
**Task:** [gap resolution](../tasks/WORK-MORE-HELP-GAP-RESOLUTION.md)
**Canonical checkpoint read:** `main` `db6ce1add29ad6706fbad490613d844d20583146`.

David asked to read today's activity-log developments before continuing. The log index and all October 15 entries were read, followed by their current [help-coverage closeout](../handoffs/HELP_COVERAGE_AUDIT_SESSION_CLOSE_2026_10_15.md), [reference-pack closeout](../handoffs/REFERENCE_PACK_SESSION_CLOSE_2026_10_15.md), standalone [APPROVAL-0177](../activity_log/APPROVAL-0177_CHEMISTRY_TOPIC_2_5_REFERENCE_ENTRY_2026_10_15.md), and [TASK-0076](../tasks/TASK-0076-CHEMISTRY-TOPIC-2-5-TAGGING-INVESTIGATION.md). Older entries retained in those closeouts are historical checkpoints; later specific records govern.

## Owner-approved parallel execution

David approved the prioritization and asked to run backend/app QA and deployment alongside the topic-tagging audit. Independent agents are reviewing the final backend and auditing current selector eligibility/TASK-0076 in parallel. Production release still depends on completed live QA; no paid reference-production approval is inferred.

Development grounding migration `20261015175446` now succeeds after correcting a missing SQL terminator caught by the first atomic apply (no change from that failed attempt). Six real MCQ/FRQ RPC payload assertions pass under rollback; independent review is [recorded here](QA_MORE_HELP_GROUNDING_2026_10_15.md). More help Development v11 is ACTIVE with JWT verification; all ten files equal the upload graph, bundle `2a16d1e68eaba1ebd8eeafc10d4ca3a8ed5d77eb7e42b8b004e9b0cda04cbe45`.

Synthetic authentication and active-subject selection now work. Actual browser flow reaches `get_question_experience`200 but `student-session-items`500. Development lacks these three packs’ `home_release_manifest` rows; a rollback-only rehearsal with exact Production unit ranges then identified missing `app.taxonomy_relevant_hash(uuid)`. No manifest rows were committed. The exact canonical helper was restored conditionally under Development migration `20261015175807`; existing helpers in other environments are preserved. Three temporary QA manifest rows were then added with exact subject unit ranges and quick-start/criterion-starter disabled. Actual browser question loading now succeeds (both serving and experience RPC return200), exposing More help. No broad deployment of the separately changed serving function. Temporary synthetic QA entitlements/profile are currently enabled for this round and must be restored at close. First real signed-in AB MCQ request returned200 and rendered. Independent review confirmed a P1 pre-submit headline disclosure; preserve the private1/12 output as failed evidence. A targeted continuity-statement boundary/regression repair passes32 backend tests and is under independent review before redeployment. Production remains unchanged.

## Corrections to the active worklist

1. **PR #460 is merged**, at `906f416fbd6210b07fb374a08878f4343c3cca54`, 15:45:06 UTC. The catalog is now the baseline on main, not an open PR to finish. Further implementation belongs on a new feature branch.
2. **Chemistry 2.5's missing-reference gate is resolved in the database.** APPROVAL-0177 published one owner-overridden entry in both environments; Production entry `fc3b546c-b200-4151-bab5-57331728bdf6` is freshly confirmed published. No duplicate extraction/load is needed. Signed-in explanation verification is still open.
3. **Four Chemistry questions need a content/tagging ruling.** TASK-0076 names `apchem-mcq-026` and its three `sv-026` variants. The new entry deliberately does not cover their expanded-octet content. A row matching the topic does not establish that these four questions have pedagogically suitable grounding. Do not re-tag, retire, rewrite or extend the entry automatically; prepare the task's CED-based findings/proposed table first.
4. **The remaining measured missing-reference count is 83, not 91:** fresh Production metadata finds AB 80, BC 3, Chemistry 0. **166 additional versions still lack selected topic mappings:** AB 1, BC 84, Chemistry 81. These are different repair mechanisms.
5. **Later-unit Calculus work remains open.** The coverage closeout audited Units 1–3; it did not complete AB Units 4–8 or BC additions. The prepared reference run must exclude already-published Chemistry 2.5. Its model slate/$60 proposal was not approved by the reassessment request; no content-provider call has run.
6. **Reference figures and question images are different paths.** Lane A figures are published; the deployed More help image gate still needs remediation/verification. The reference-pack closeout records Production ahead of Development by three batch-4 figures, so a generic assertion of figure parity would be wrong. Do not reload or alter the separately owned batch as part of this sync.
7. **Log rotation is already complete.** Live logs now start October 1; earlier entries remain in the named archives. APPROVAL-0177 remains the standalone owner-directed record; do not reuse its number or paste it elsewhere solely because its old header requests that.

## Work from this execution that must be retained

| Work | State and evidence boundary |
| --- | --- |
| Three Development MCQ fixtures | Committed and verified: unchanged source question/choices, one primary topic per fixture, task-owned sessions. Solves the missing-fixture prerequisite, not MCQ generation QA. Details in the [execution record](MORE_HELP_RESOLUTION_EXECUTION_2026_10_15.md). |
| Assistance runtime SQL | Twelve real `service_role` assertions passed with ROLLBACK after isolating a fresh transaction-owned session. Does not certify browser/two-tab/grading behavior. |
| Backend parts/visual/figure repair | Preserved at local commit `02e6978e759a5d328853c62ab596e8040a0d9a8d`; 31 Deno tests and index typecheck pass. Migration is authored, not applied; function is not redeployed. Complete independent backend/migration review remains pending. |
| App repair | Pushed `ap-prep-blueprint:codex/work-more-help-gap-resolution`, `c9c8d8bd8d625ac3d6fa541c9b3ad2b81e5d73bd`; 1,190 tests/typecheck/build pass. Independent local review caught null-wire figure rejection and nested-Escape dismissal, both repaired and retested. No app publication. |
| Controlled live QA | Synthetic authentication and Development origin checks succeeded. No new More help/model/grading/photo calls were made. The attempted local browser probe did not reach a certified authenticated question flow; it is not passing live evidence. Temporary QA entitlement/profile changes were restored, and the owned local server is no longer running. |
| Content preparation | Guarded pipeline/controls/source manifests prepared, no paid execution or reference load. Remove Chemistry 2.5 from executable scopes. The 6.14 LO/EK cross-reference interpretation and exact model/budget approval remain unresolved. |

## Revised order of work

1. Finish independent review of the preserved backend/app grounding changes, then verify them in Development using the prepared fixtures. Include one Chemistry 2.5 question in the actual-output/human-reading packet.
2. Prepare TASK-0076's read-only question-by-question findings before proposing any change to the four expanded-octet questions.
3. Pursue the 166 missing-topic assignments through the canonical labeling process; unit-only labels and legacy hints are not validated topic decisions.
4. Run only the revised Calculus reference batches once their concrete slate/budget and 6.14 handling are settled. Use exact-batch Production approvals after content/control gates.
5. Close H01–H15 by evidence-based disposition: retain H13's approved scope and H15's historical unknown; do not invent persistent history/unbounded chat or a cause for the lost BC output.

**Next owner/action:** conductor and fresh independent reviewer, grounding code/migration review first. David owns TASK-0076 content rulings, the exact pending content-run approval and human review of actual generated help. No new production mutation, provider call, migration application or publication was authorized or performed by this reassessment.
