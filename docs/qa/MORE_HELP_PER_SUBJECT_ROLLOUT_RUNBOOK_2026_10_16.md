# More help — per-subject rollout runbook and Production release packet (2026-10-16)

STATUS: CURRENT. Nothing in this packet has been applied to Production.

## Rules (owner, 2026-10-15)
1. **One subject at a time**, units 1–3 only. Never enable unit 4+ of any newly enabled subject without asking.
2. Physics 2 (registry units 9–11) and Physics C E&M (8–10) are **not in scope** until the owner says so.
3. Calculus AB/BC and Chemistry are already live for all units; leave as is.
4. Every Production step needs its own explicit owner approval (new APPROVAL-#### row). Model calls need an approved generation count; the expansion cap is 30 generations / $5 across all subjects (Statistics has used 9; see its QA record).
5. Never swap identities or clear receipts to get past the 30-delivered-per-24h quota; wait.

## Current state
| | Development | Production |
| --- | --- | --- |
| Reservation function | policy-table gate, MD5 `582930f3…` | v1, 3-subject list, MD5 `c22f5f60…` |
| `more-help` | v16 (identify/define rule) | v1 (= Dev v10) |
| Enabled | AB, BC, Chemistry (all units), Statistics (1–3) | AB, BC, Chemistry (all units) |
| App | PR ap-prep-blueprint#30 open, unpublished | published build supports AB/BC/Chemistry only |
Backend PR: david-bloom/Cramapple#475 (draft). Production secrets needed (`AI_GATEWAY_API_KEY`, `ALLOWED_ORIGINS`, service/anon keys) are present (names checked).

## Steps for a subject (e.g. the next one)
**A. Pick it** from the census: no shortfall, no images, parts complete, no open topic gaps ([census](MORE_HELP_UNITS_1_3_CENSUS_AND_READINESS_2026_10_16.md)). Statistics is first; Precalculus (2 topic gaps) and Physics 1/C Mechanics (1 each) need their topic probes first; Biology needs the image ruling.

**B. Development proof (agent work, no approval beyond the generation count)**
1. Add the Dev policy row (the `02_enable_subject.sql` insert, run on Development).
2. `scripts/more-help-qa/fixtures.sql` (substitute subject/units/synthetic user) → `fixtures.json`.
3. `node scripts/more-help-qa/run.mjs --fixtures fixtures.json --user <synthetic id> --cap <approved N> --out results.json` (Dev only, stops on first non-200, counts every request).
4. `deno run -A scripts/more-help-qa/replay.ts results.json` (offline validator replay) and `node scripts/more-help-qa/packet.mjs results.json tmp/<name>.md "<title>"` (private packet).
5. Unit-gate SQL test: `supabase/tests/more_help_unit_gate.sql`. Record the ledger and findings in a QA record.
6. **Owner reads the packet and accepts.** Agent review is not acceptance.

**C. App:** add the subject to `MORE_HELP_UNITS` in `src/lib/more-help.ts` (units 1–3), tests, PR, merge. **Do not publish yet.**

**D. Production release (one approval per bullet)**
1. First subject only: `docs/qa/more_help_release/01_apply_gate.sql` — guarded (aborts unless Production is in the recorded v1 state), changes no student behavior, asserts the post-apply function MD5 equals the tested Development function. Dry-run passed in a rolled-back Development transaction on 2026-10-16.
2. First subject only: deploy the edge function (v16 or later) to Production:
   `supabase functions deploy more-help --project-ref pcntajvbdfqhbeewmdry --workdir <repo> --use-api`; confirm JWT-verified and the bundle hash. Always pass the explicit ref (the CLI default in the home directory is Production).
3. `02_enable_subject.sql` with `__SUBJECT__`/`__UNITS__` (units 1–3 only).
4. Publish the Lovable app (project 56cae479) **after** step 3 so the button never appears before the backend accepts the subject.
5. Owner smoke on the owner's own account (one request per type, units 1–3), then `05_smoke_checks.sql`; record in the logs.

**E. Rollback:** `03_rollback_subject.sql` switches one subject off at once (refused before any model call, no data touched). `04_rollback_function.sql` restores the Production v1 function byte-for-byte (verified to reproduce MD5 `c22f5f60…`). The superseded ten-subject Dev migration `20261015232212` must **never** be applied to Production.

## Traps
- Registry keys (`biology`, `ap-statistics`) ≠ reference/taxonomy keys (`ap_biology`, `ap_statistics`).
- The Dev ledger can't be trusted; `supabase db query` leaves no ledger row. Recover state from function MD5s and the policy table.
- Per-user quota 30 delivered/24h and 6 attempts/min apply to the synthetic account.
- Dev has little or no reference content for units 4+, so a live unit-5 probe can't prove the gate; the SQL test does.
- A validator refusal (`invalid_model_sources`, `answer_disclosure`) is a recorded outcome, still counts against the ledger, and is never retried without approval.
