# More help gap resolution — execution record

**STATUS: IN PROGRESS**
**Task:** [owner-authorized work order](../tasks/WORK-MORE-HELP-GAP-RESOLUTION.md)
**Worklist:** [H01–H15](MORE_HELP_GAP_CATALOG_2026_10_15.md)

## Development QA fixtures

The owner directed resolving the catalog and reference gaps. Three unchanged approved Production MCQs were compared against their prepared private export: item fields, version fields and all four choice/rationale rows still match for every source. Source export SHA-256 `6e100f5b8398bcf678d0c95b9cccf9e649da69a3a67efa15d8e33c49898a3140`.

After successful full insertion/source-comparison rehearsal with ROLLBACK, the identical guarded transaction was committed to Development. No existing item was overwritten, no Auth identity created and no Production row changed. Inserts followed the existing draft/assigned/reviewed_approved/published lifecycle with source-copy provenance.

| Subject | Source Production version | Development version | Task-QA session |
| --- | --- | --- | --- |
| Calculus AB | `a007e995-d5a9-480d-b863-2946387f76a1` | `bb8e2813-f5bb-4551-83b7-5fdaac632111` | `a125dee2-7809-414b-ad2e-68e72c78340a` |
| Calculus BC | `50921ffc-23eb-4c4d-ba0b-060753fa1ce9` | `cc2685e7-8c99-48cf-b9c9-54a5459c4e1e` | `40c71339-cea4-42da-b5fd-6451a9db1222` |
| Chemistry | `d22a425d-8702-43f4-bc38-554f355e04ae` | `044e3730-e57a-4b96-8b0f-54840d8b8846` | `2b91cb72-fe28-4a50-afb6-b28d0b045bbe` |

Post-commit read confirms three published versions, twelve unchanged choices and exactly one primary topic cell each. The additional source secondary skill cells were not copied: Development lacks those taxonomy cells and the QA proposal needs only the primary topic. No schema was created to simulate bank parity.

**Validation-metadata difference:** Production source cells say validated with a decision/time but no validator, while Development's existing CHECK requires validator/time/decision together. The QA-only deterministic topic copies therefore use the existing `authored` provenance status with an explicit unchanged-source note and NULL validation fields. This does not invent a human validation or alter any Production assignment. Their topic values are copied exactly; they are not new topic classification results. This fixture treatment must not be applied to the 166 unmapped live versions.

Private source/transaction files remain outside the public repository. Source digests recorded by a fresh Production read: AB `e62ee5437465aa5dc32eb4501316311a`, BC `59092be3d1e876f335235a815a13f1bc`, Chemistry `094c57f1a8a6109d092911494032ca0b`. Full question/key/rationale exports and credentials are not included here.

## Repeatable runtime SQL verification

`supabase/tests/more_help_runtime.sql` initially reported premature assistance when pointed at the old QA seed session. That session already had earlier delivered help, so this was a contaminated test precondition. The setup now validates the supplied seed identity/session/version, then creates a fresh transaction-owned session containing the same version. It leaves old durable receipts intact, and every new row rolls back.

Development execution under `service_role` passed all twelve returned assertions: private grants, reserve/commit/fail/retry, stale-worker fencing, current/future draft assistance, submitted-attempt preservation, fresh-session independence, foreign/entitlement denial, failed calls not consuming delivered allowance, delivered allowance, attempt-cost limit and burst limit. The transaction ended in ROLLBACK. This is real database mechanism evidence, not a browser/two-tab/model-output certificate.

## Implementation and content preparation

- Backend source confirms the question RPC omits separately authored FRQ prompts. Safe allowlisted parts and approved visual/figure grounding are under implementation; no deployment is claimed here.
- App source similarly omitted those parts on both the ordinary question screen and help screen. An isolated app repair and meaningful component regressions are being prepared; no publication is claimed here.
- [Prepared reference batch](../../scripts/content-seed/more-help-reference-gap-2026-10-15/README.md): 49 AB topics, 30 additional BC topics and Chemistry 2.5. Slate/$60 cap ratification is pending. No content-generation calls or reference-content load has occurred.
- None of the 166 unmapped versions has a recoverable validated topic cell, topic-resolution row, historical assessed-topic array or exact validated text twin in the checks performed. Legacy hints and unit-only serving labels are leads for classification, not permission to promote a topic blindly.

**Provider-call accounting:** zero new More help or content-generation calls at this checkpoint. The bounded help allowance is at most twelve requests; the separate content slate/budget question remains pending. Exact batch Production approval and human reading of generated help remain later concrete gates. H13 remains the approved three-subject/current-question scope; H15's lost historic response remains unknown, with current BC behavior still to verify.

**Next owner/action:** conductor completes authenticated Development QA once the new backend/app source is ready; independent reviewer challenges that exact checkpoint. Content pipeline preparation continues without paid calls while slate ratification is pending. Preserve original independent reports, provider secrets, real students, six approved question images, separately deployed student-session-items v40 and unrelated primary-checkout work.
