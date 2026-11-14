# APPROVAL-0284 — Rubric and prompt repair of 11 held FRQs (new published versions), 2026-11-14

- **Date:** 2026-11-14.
- **Authorization:** David Bloom (Product Owner), in chat: "Run votes and repairs for all", after the triage of the 76 unit-less unlabeled items (`docs/qa/LABEL_UNITLESS_76_TRIAGE_2026_11_14.md`). Labels follow under a later approval.
- **What is written (Production `pcntajvbdfqhbeewmdry`), one transaction per subject (Calculus BC 5, Chemistry 3, Physics 2 2, Precalculus 1):** a new published version of each of 11 items (the old version is retired; difficulty rows carried over; draft, assigned, reviewed_approved, published; same mechanism as APPROVAL-0277/0282). All 11 were held as `rubric_preflight_failure`; the three-model check on their current rubrics failed with consistent flags.
- **The edits (all offline-built in `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage9/build_plan.py`, points kept per item):**
  - Rubric-only (rubric now scores what the prompt already asks): `apcalcbc-frq-016` (no derivation route required), `apcalcbc-frq-030` (evaluations at t=π/4 scored), `apcalcbc-frq-031` (interpretation in (d) scored), `apchem-sfrq-005` (endpoint assumption scored), `apchem-sfrq-007` (crossover temperature scored), `apphy2-frq-002` (derivation and evaluation scored), `apphy2-frq-011` (any feasible design accepted; unasked missing-mass remark removed), `apchem-frq-l-005` (two criteria added and d2 reworded: the rubric totalled 8 against a prompt total of 10, so it now totals 10 and scores the part (c) design and part (d) comparison).
  - One prompt line also changed so the prompt asks what the rubric scores: `apcalcbc-frq-022` (part (d) also asks where the absolute extrema occur), `apcalcbc-frq-033` (stimulus also asks for the absolute/conditional classification of (c) and (d)), `apprecalc-frq-np2-008` (part (c) asks for the coordinates of the local maximum, not only the y-coordinate).
  - Also tightened after a first recheck: `apcalcbc-frq-022` part-c-criterion-1 and `apcalcbc-frq-033` part-a-criterion-1.
- **Checks:** my own recomputation of every number in the repaired items (the polar-curve values, the series bound, the extrema, the titration percent difference, the crossover temperature, the potential at the midpoint, the local maximum); then a three-model rubric check (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol), 11 of 11 items pass 3 of 3 after two criteria were tightened. Measured gateway cost $0.31 for the checks.
- **NOT reviewed:** no human subject specialist has read the repaired wording.
- **NOT changed:** `apcalcbc-frq-002` (already passes, only needs labels), any other item, any validated cell or label, schema, functions, frontends. None of the 11 has a validated serving label (the transaction asserts it).
- **Rollback:** retire the new versions and republish the old ones, delete the new criteria, restore carried difficulty rows if needed.
- **Numbering check:** highest APPROVAL on origin/main, open PRs and remote branches was 0283; this record takes 0284.
- **Rehearsal:** four `REHEARSAL OK` (rolled back, constraints forced immediate).
- **Result:** see the execution record below.

## Execution record (2026-11-14)
- Four transactions COMMITTED; read-back MATCH 5/5 (Calculus BC), 3/3 (Chemistry), 2/2 (Physics 2), 1/1 (Precalculus): new versions published with the planned rubric, stem, stimulus and answer hash; exactly one published version each.
