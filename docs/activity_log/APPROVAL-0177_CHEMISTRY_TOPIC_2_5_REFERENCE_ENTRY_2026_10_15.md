# APPROVAL-0177 — Production Load of One AP Chemistry Topic 2.5 Reference Entry (Product Owner Override of a Checker Rejection) So More help Can Ground the Eight Lewis-Diagram Questions

> Filed as a standalone file because `APPROVALS_LOG.md` is too large to edit through the GitHub connector. **Please paste this entry into `docs/activity_log/APPROVALS_LOG.md` (newest first) and confirm the number 0177 is still free before merging.**

**Date:** 2026-10-15  
**Approved By:** David Bloom (2026-10-15 Claude session: approved the 2.5 plan, then "Override and publish", then option 2, direct SQL, after `load.py --po-accept` was blocked by the permission classifier).  
**Related:** `scripts/content-seed/ap-chemistry-reference-u2-topic-2-5-2026-10-15/README.md`; `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md` section 4 (escalation rulings) and section 5  
**Decision:** Approved

**Why:** Topic 2.5 had no reference entries, so More help returned `reference_unavailable` for its eight published questions. The CED's only 2.5 essential knowledge (2.5.A.1) does not print the construction principles, so the extractor produced nothing admissible.

**Approved scope:** one `published` row in `app.unit_reference_entries` (AP Chemistry, owner 2.5, `list_sequence`, "Principles for constructing a Lewis diagram"), Development `71bdd801-bd6d-477f-bb46-330a76a2b965` and Production `fc3b546c-b200-4151-bab5-57331728bdf6`. Checker result: Gemini accept, GPT reject twice after two rounds; this is a Product Owner override recorded in the row's `source_note`. No hooks, no function, migration or app change.

**Evidence:** Production published entries 1,083 -> 1,084, Chemistry Unit 2 21 -> 22, all eight 2.5 questions resolve to the entry; Development matches. Not yet checked in the signed-in app.

**Not approved by this entry:** an entry for expanded octets (2.7.A.3 Exclusion Statement), any change to the four expanded-octet questions, other topics.

**Rollback:** set the Production row to `retired` (no hook references it).
