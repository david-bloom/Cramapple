# Independent More help all-subject review — 2026-10-15

**Proposed verdict: PASS for reviewed backend source and bounded Development reservation runtime; complete release evidence pending.** Reviewer: independent QA agent `/root/grounding_final_qa`. No reviewer model calls, deployments, migrations or live metadata writes.

Scope: backend implementation `0b77c3de` plus terminator repair `ebefafa1`, against `176ff0ba`; current work order [WORK-MORE-HELP-ALL-SUBJECTS-U1-U3](../tasks/WORK-MORE-HELP-ALL-SUBJECTS-U1-U3.md). App and actual new-subject model outputs require separate final checkpoints below.

## Source/security findings

- Independently fetched current Production reservation-function source. The migration changes only its three-subject allowlist to the ten exact registry keys, plus the necessary SQL statement terminator. Ownership, published-content, entitlement, quota, lease, receipt and generation fences are preserved byte-for-byte.
- Backend context uses exact registry key `biology`, not `ap-biology` or reference-key `ap_biology`. Independent Development registry read confirms all ten keys match the allowlist.
- No numeric unit cap is introduced. Physics2 registry units9–11 and Physics C E&M8–10 remain reachable; existing later-unit Calculus/Chemistry behavior remains.
- Existing v13 pre-submit disclosure checks, authored-part/visual grounding, checked-source filtering and server authority are unchanged.
- Independently reran34 local backend tests successfully; `deno check` passes. New tests cover all ten subjects, before/graded/revision phase, missing grounding, foreign version and rejected alias/invented subject identities. These synthetic-context tests do not prove actual new-subject semantic correctness.

## Development execution

The conductor reports the first attempted apply failed atomically because the saved function source lacked its statement terminator; unchanged function MD5 and zero newly supported positive reservations were verified before correcting it. Do not treat the failed apply as deployed evidence.

Corrected Development migration is recorded as `20261015232212` and the file renamed to match. I independently confirmed that ledger row and live reservation-function MD5 `094b5adaec3bcfdee0df14ffe3c96811`. Authenticated/anon EXECUTE are false; service-role EXECUTE is true. The conductor reports Development More helpv14 deployed JWT-verified; retrieved-source provenance is conductor evidence.

The ten-subject transactional runtime checks actual owned synthetic fixtures, one per exact registry subject, actual reservation success/generation1, foreign-session denial and nonpublic grants. Each case uses a subtransaction rollback, and the entire script rolls back. QA revised the assistance assertion to compare baseline before/after reservation; a previously assisted fixture is not inherently an invalid fixture. The conductor executed the materialized ten-subject script without assertion errors. No model calls are made by this test.

## Four topic-gap proposals

Independently read exact Physics1, Physics C Mechanics and Precalculus CED topic pages and the frozen four-item source packet. Proposed topics are substantively supported:

| Version key | Proposed primary | Exact CED basis / distinction | Process status |
| --- | --- | --- | --- |
| `apphy1-frq-np1-004` |2.5 |2.5.A/2.5.A.1–3, Newton's second law; normal/friction forces feed net-force and acceleration demands. Friction2.7 is supporting content. |First topic six-vote probe needed; historical record validates unit only. |
| `apprecalc-frq-016` |3.13 |3.13.A.1–2, signed radial displacement and polar/rectangular conversion;3.14 graph/domain interpretation is secondary. |First topic six-vote probe needed; historical record validates unit only. |
| `apphycm-frq-044` |3.4 |3.4.B/3.4.B.1–3, spring potential/kinetic conversion and conservation under compression scaling; period/frequency is not assessed. |First topic six-vote probe needed; historical record validates unit only. |
| `apprecalc-mcq-sv-037-v3` |1.13 |1.13.A/1.13.A.2/1.13.A.5 explicitly connects constant nonzero nth differences with polynomial model selection. General quadratic extrema1.4 and exponential-model/residual2.6 do not match the actual choice demand. |Existing six-vote3/2/1 split permits documented exact-CED tiebreak. |

Canonical pipeline §2 includes a six-vote topic probe; §3 accepts5/6, conditionally4/6, and otherwise reads the exact CED or leaves no cell. The broad build instruction does not explicitly waive that process. The conductor accepted the recommendation to obtain the first three topic probes before any Production assignment. These semantic proposals alone are not permission to promote them as validated cells. Exact guarded batch/recovery review and actual execution evidence remain required.

## Remaining release checks

1. Final app source/CI and signed-in subject/type/phase/phone verification, including actual font delivery.
2. Actual new-subject generated-output semantic review under the separately bounded expansion ledger; no carryover from exhausted earlier12-call allowance.
3. Human reading/acceptance of a concrete output packet; independent agent review is distinct.
4. Biology image grounding ruling, image/figure help context and complete authored-prompt fidelity for the proposed released slice.
5. Exact Production migration/function/app provenance, guarded recovery and postdeployment smoke. Per-environment MCP ledger timestamps must be recorded accurately.

No FRQ grading/photo provider availability claim is made; those calls are outside this verification allowance. No universal answer-disclosure guarantee is made. This report does not close the broader H01–H15 work order.
