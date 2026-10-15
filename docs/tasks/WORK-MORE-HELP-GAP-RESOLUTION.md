# More help — resolve the gap catalog and reference coverage

**Status:** In Progress
**Tier:** Hard-Gate
**Owner:** Codex conductor; Product Owner David Bloom
**Created:** 2026-10-15
**Branch / PR:** `codex/work-more-help-gap-catalog`, [#460](https://github.com/david-bloom/Cramapple/pull/460)
**Parent task:** [WORK-MORE-HELP-PRODUCTION](WORK-MORE-HELP-PRODUCTION.md)
**Worklist:** [H01–H15 and reference inventory](../qa/MORE_HELP_GAP_CATALOG_2026_10_15.md)

## Owner direction and approval state

David directed: **“So we need to resolve the 15 issues in pr460 and close the reference content gaps.”** This authorizes remediation of the cataloged feature/reference/linkage gaps and the verification needed to establish resolution. Earlier real-app authorization remains for Calculus AB/BC and Chemistry; existing assistance, recorded-grade, privacy and content-quality boundaries remain.

Proceed with source/local investigation, implementation and meaningful tests, concrete Development fixture preparation and the existing bounded synthetic QA proposal. The prepared QA round remains capped at 12 Gateway calls; count all attempts and do not reuse the exhausted separate grading allowance. Content-production model slates, quality escalations and exact Production batches must satisfy the [reference-production protocol](../product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md); prepare those concrete packets before any additional gate decision. Do not infer permission to purchase credits, create/change keys, change providers or read real student work.

H13 is a scope disposition: retain current-question help for the three approved subjects. Resolving that catalog entry does not require implementing persistent student history, unbounded chat, BYOQ changes or new subjects. H15 is a historical-uncertainty disposition: document what is unknowable and verify current BC behavior; do not invent the lost response or make its recovery a completion requirement.

## Execution slices and acceptance

| Slice | Catalog IDs | Required result |
| --- | --- | --- |
| Grounding and question fidelity | H06, H07, H08 | Trace and repair missing authored FRQ instructions and supported visual grounding without exposing answers, accepting client truth or changing the six approved image objects; demonstrate meaningful regression coverage. |
| Content and retrieval | H12 | Fill AB4–8, applicable BC-only topics and Chemistry2.5 from admissible CED sources; independently validate controls/content, rehearse exact loads, and verify usable reference retrieval. Diagnose the 166 missing selected topic mappings separately; restore only justified mappings with freshness/ownership guards. |
| Final-source and lifecycle QA | H01, H02, H03, H04, H05, H09, H10 | Fresh independent source verdict; controlled subject/type/phase and assistance/grade lifecycle evidence; actual served math/keyboard/phone checks; separate grading/photo verification; human reading packet for generated outputs. Do not claim mocked transport is live evidence or agent review is human acceptance. |
| Release and records | H11, H14 | Reviewed backend/app/content manifests, Development source verification, exact Production publication evidence and recovery plan; update canonical restart/task/index. Existing migrations are already deployed and must not be blindly repeated. |
| Explicit disposition | H13, H15 | Retain approved scope and documented historical uncertainty, with current behavior verification. |

Acceptance: every H-ID has evidence and a concrete disposition (resolved, verified scope boundary, documented historical unknown, or explicitly blocked with next owner); missing-reference and missing-topic counts are rerun after repairs and residuals explained. The final report must distinguish Development, Production, merged source and published app, and identify any required owner/human acceptance still outstanding.

## QA and release constraints

Use the updated QA prompt and original reports through their index links. Preserve both independent failure reports byte-for-byte. Use new QA reports for new findings and fresh contexts for independent review. Never “fix” coverage by dropping difficult questions from the inventory or making unrestricted model answers available.

No real student records, auth/payment/email changes, new provider connections, mutable replacement of approved private images or unrelated reference-figure changes. Preserve the primary checkout's dirty files. Do not deploy backend main over `student-session-items` v40's separately deployed teaching-image branch; reconcile that drift before touching that function.

**Next owner/action:** backend implementation/source agent investigates H06–H08; content preparation agent inventories exact CED-based batches and mapping recovery candidates; conductor establishes QA fixtures, current app/deployment state and gate packets. This is execution authorization, not a final QA PASS or Done decision.
