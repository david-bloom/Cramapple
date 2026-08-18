# Grading-engine replan — morning package — 2026-08-11

**What this is:** the overnight execution record for Step 1 (in full) and the
Step 2 pre-staging of
`GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md`, plus the decision
sheets (O1–O3) the next actions are gated on.
**Ground rules honored:** no Production writes of any kind; Production reads
were read-only SQL against `pcntajvbdfqhbeewmdry` via the Supabase MCP; no
commits/pushes — everything is uncommitted working-tree change; no raw data
modified; all document corrections are appended, never rewritten.
**Test status: 137 tests, 0 failures**
(`deno test --allow-read --allow-env supabase/functions/_shared/
scripts/grading-model-assessment/ docs/research/exemplar_grading_pilot_2026_08/`
— was 108 before this session; +29 new).

---

## 1. One-page summary

| Replan item | Status | Where |
| --- | --- | --- |
| 1.1 Deterministic-key invariant harness | **Done.** SFRQ-008 confirmed failed (keys from the retired v1 canonical); corrected values derived + applied in-repo (pending O1); 6 standing tests wired into `deno test` | `scripts/grading-model-assessment/verify_deterministic_keys.ts` + `_test.ts`; audit: `DETERMINISTIC_KEY_AUDIT_2026_08_11.md` |
| 1.2 Assessment-harness repairs | **Done, all with unit tests.** Replay-shape parsing + fail-loud in `to_result_cases.mjs`; scoring policy v2 (`--policy partial-v2`); item-level cluster bootstrap reported alongside response-level; `request_body_sha256` in `run_pilot.mjs` | those files + `harness.ts`/`main.ts`; tests in `harness_test.ts`, `to_result_cases_test.ts`, `run_pilot_test.ts` |
| 1.2 verification | Repaired pipeline re-run into scratch (`/private/tmp/...scratchpad/pilot_rerun/`, committed artifacts untouched): reproduces baseline **57.1%**, diff **+1.39pp**, resp-level CI **[−2.5, +6.7]pp**, item-level CI **[−2.3, +8.3]pp** (4 clusters), per-item diffs {001 −0.031, 005 +0.111, 008 0, 009 0} — exactly the second-opinion numbers | §3 below |
| 1.3 Policy simulations | **Done** — retry conversion, modal-of-N curve, blast-radius bound | `exemplar_grading_pilot_2026_08/POLICY_SIMULATIONS_2026_08_11.md`; §4 below |
| 1.4 Record corrections | **Done, append-only** — REPORT.md correction section; ledger row struck+annotated; new activity-log entry + index | those three files |
| 1.5 Handoff-doc update | **Done** — dated section at top of body, already-decided items only | `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` |
| 1.6 Stage-1 false-accept | **Computed read-only** — p = 2/28 (7.1%), upper 95% ≈ 20.8%; reader-vs-reader 13/36 answers | §5 below |
| 2 pre-stage (a) key fix | In-repo with provenance comments; **not deployed** | `supabase/functions/_shared/statistics-verifier.ts` |
| 2 pre-stage (b) migration draft | Drafted, **cannot be applied** (invalid `TBD` version in filename) | `supabase/migrations/20260811TBD_grading_telemetry.sql` |
| 2 pre-stage (c) passive telemetry | Stage timings + cached_tokens + normalized-response hash, best-effort writes that tolerate the missing columns; verifier version bump **in comment only** | `evaluate-attempt/index.ts`, `_shared/grading-telemetry.ts` + `_test.ts` |
| 2 pre-stage (d) deploy checklist | §9 below | — |
| **Unplanned finding** | **Exemplar-pilot Production cleanup appears ALREADY EXECUTED — but unlogged.** 185 pilot `model_usage_ledger` rows remain. See O3 (§8) — needs owner confirmation | §8 |

---

## 2. Deterministic-key audit — verdict table (full table + method: `DETERMINISTIC_KEY_AUDIT_2026_08_11.md`)

| Entry | Verdict |
| --- | --- |
| **APSTATS-SFRQ-008** | **FAILED — corrected to [−1.40, 4.477]** (derived from the payoff table; old [1.8, 4.9] = the retired v1 canonical's values). Pre-fix: flags 4/4 correct gold answers. Post-fix: 4/4 + 4/4. |
| SFRQ-001, 002, 003, 004, 007, 009, 010 | VALIDATED (derivation + published canonical + gold answers; zero false flags; 8 documented lenient-direction false passes across the corpus) |
| SFRQ-011, 012, 013, 014, 016 | VALIDATED, canonical-only (no gold answers exist) |
| APSTAT-MOD6 | VALIDATED by derivation (`canonical_answer_1` null in DB) |
| APSTAT-MOD3-INV | Values derive, but CI bounds use z\*=1.96 where AP expects a t-interval — correct t-bounds still inside the 2% tolerance; flag for O1 |
| MOD7, SFRQ-015, SFRQ-017 | Values derive, but the items' only versions are `reviewed_disapproved` (017 additionally keys a stimulus given — weak key) |
| SFRQ-018 | Values derive; only version `retired` — dead weight |
| MOD5, MOD8, SFRQ-005, SFRQ-006 | NULL entries — abstain verified on all gold answers / by construction |

---

## 3. Corrected exemplar-pilot numbers (defect: replay parsing; details in `REPORT.md` §Correction)

Baseline (off) 52.4% → **57.1%**; candidate 58.3% unchanged. Point estimate
+4.7pp → **+1.39pp**; response-level CI [0, +12.2] → **[−2.5, +6.7]pp**;
item-level (new, correct 4 clusters) **+2.0pp [−2.3, +8.3]pp**. Coverage,
abstentions, exact-case accuracy and FNR **equalize** between arms. Verdict
unchanged: do not ship; exemplar direction closed.

---

## 4. Policy-simulation results (full method: `POLICY_SIMULATIONS_2026_08_11.md`)

1. **Retry-on-integrity-failure:** 23/170 LLM-path trials (13.5%) abstain on
   integrity checks (plus 1 timeout, classed separately) across 10 cells;
   8 cells stochastic, 2 systematic (SFRQ-001#1, both arms, 5/5). One retry
   converts **~33% of abstention events**; per-call abstention 13.5% →
   9.1% (one retry) → 7.5% (two), with a **5.9% systematic floor** that no
   retry reaches (the permanent-abstain-with-scaffold slice).
2. **Single vs modal-of-3 vs modal-of-5** (500 seeded subsample draws,
   scored with the production-contract harness): 56.7%/57.5%/57.1% (`off`),
   56.6%/58.0%/58.3% (`with_exemplar`) — **≤ +1.4pp for 3–5× cost**.
   Blanket voting is not where the error mass is; supports
   disagreement-routed escalation only.
3. **Blast-radius recovery bound (O2 input):** the item-wide zeroing took
   **31 gold-determinable criteria (37% of the whole denominator)**; 17 of
   31 belong to criteria the keyed values don't touch. Per-criterion flag
   scoping recovers 17 × 94–96% ≈ **+19pp** on this capture as it happened,
   ≈ **+8pp residual** once the 008 key fix removes the spurious gatings.

Small-n caveat on all three: 4 items, one subject, 30 responses.

---

## 5. Stage-1 gold-set false-accept (replan 1.6 — computed, read-only)

**Method** (protocol `GOLD_SET_GENERATION_PROTOCOL.md` §5, reader-consensus
definition): Set B AP Statistics stage-1 corpus = the 40 seeded answers
(SFRQ-001..006; `stage1_answers.jsonl` 48 answers minus 8 discards). Pulled
both readers' `gold_set_element_marks` (Jill Schmidlkofer 36 assignments,
Muhammad Saood 40 — 4 of Jill's earliest single-point assignments were
removed per the 2026-08-07 log entry) joined via
`gold_set_verification_assignments` → `gold_set_elements` →
`frq_criteria.criterion_key`, and compared each reader's present/absent
vector to the answer's script (`script.expected`), matching by
`gold_set_answer_id` → (content_key, answer_type).

**Results:**

- Dual-read provisional accepts (the *p* denominator): **28**.
- **Consensus false-accepts: 2** — both readers, marking identically,
  disagree with the script on **SFRQ-003 A6** and **SFRQ-004 A6** (both:
  script says c1 present/d1 absent; both readers say c1 absent/d1 present —
  note both are A6 answers with sig `1110`, the A3/A6 same-element-collision
  shape already on the gold-set program's books).
- **p = 2/28 = 7.1%**; Clopper–Pearson upper 95% bound ≈ **20.8%** — lands
  in the protocol's ">15% reject" band, but at n = 28 the bound is dominated
  by sample size (zero errors in 28 would still bound at ~10.2%). Per the
  replan's own framing: **not certifiable at this n — record as the
  program's first machine-vs-human number, not as a gate outcome.**
- Provisional accepts where the readers disagree with each other (excluded
  from *p*, logged as rubric-ambiguity per §5): **6** (001 A5, 002 A5,
  003 A1, 004 A2, 005 A5, 005 A8).
- Reader-vs-reader disagreement: answer-level **13/36 (36.1%)**;
  element-level **14/144 (9.7%)**.

**Footnotes required by the brief:**

- *Jill's 6 owner-returned re-marks* (2026-08-08 log entry "Reviewer QA
  Sweep Re-Run…", §"Jill Schmidlkofer gold-set corrections"): the original
  marks were DELETED (write-once table; delete is the sanctioned correction
  path), so the 6 affected assignments **cannot be identified in the DB
  post-hoc**. Directional impact is bounded: the re-marks were made with
  owner feedback pointing at missed textual matches, i.e. biased *toward*
  script agreement — that can only shrink *p*'s numerator contributions from
  Jill, and both counted false-accepts are corroborated by Saood's
  never-returned (cold) marks. Worst case, the denominator is effectively
  ≤6 smaller and the reader-vs-reader rate understated.
- The 2 mindfulness-item returns are SFRQ-006 assignments (same log entry);
  same non-identifiability applies.
- 4 provisional accepts are single-read (001 A2/A6, 003 A3, 004 A8 — Jill's
  removed early assignments); consensus is undefined there and they are
  excluded from the denominator.

---

## 6. O1 decision sheet — corrected deterministic keys (blocks Step 2)

**Decision:** approve the corrected `STATISTICS_TARGETS` for deploy.

| Item | Change | Provenance |
| --- | --- | --- |
| APSTATS-SFRQ-008 | [1.8, 4.9] → **[−1.40, 4.477]** | Derived from published payoff table; matches published v3 canonical (hash `975e2fdf…`) and all 8 gold answers; old values = retired v1 canonical. Sign policy: match on \|value\| (no `sign_sensitive`) so "loses $1.40" passes — confirm. |
| All other entries | **No value changes.** Provenance comments added per entry (derivation, canonical hash, gold-audit result, status caveats) | `statistics-verifier.ts` comments + audit doc |

Secondary calls for O1 (non-blocking, can trail):
- MOD3-INV CI bounds keyed on z\* not t\* — re-key to (805.19, 894.81)?
  (No live harm: correct t-answers pass under the 2% tolerance.)
- Weak-key class: SFRQ-009's 0.28 and SFRQ-017's 5.2 equal stimulus givens —
  keep (lenient-direction only) or re-key to non-given values.
- Dead keys (MOD7/015/017 disapproved, 018 retired): keep or prune.
- Deploy stamps: bump `deterministic_verifier_version` to
  `stats-verifier-ts-2026-08-11` (currently comment-only in
  `evaluate-attempt/index.ts`).

**What deploys on approval (the Step 2 bundle, one deploy + one migration):**
`statistics-verifier.ts` (fix), `grading-telemetry.ts` + `evaluate-attempt/index.ts`
(passive telemetry), migration `20260811TBD_grading_telemetry.sql` renamed to a
real timestamp. No prompt changes → no `EVALUATE_ATTEMPT_PROMPT_VERSION` bump.

## 7. O2 decision sheet — per-criterion flag scoping (learner-visible)

- **Evidence:** §4 item 3 — item-wide zeroing destroyed 37% of the pilot
  denominator; scoping bound +19pp on the capture, ~+8pp residual post-key-fix.
- **Recommendation (replan prior confirmed): yes**, but it is a
  learner-visible behavior change (partial feedback instead of a whole-item
  hold) and may ship as a follow-up deploy separate from the O1 bundle.
  Nothing is pre-staged for O2 — deliberately, pending the decision.

## 8. O3 decision sheet — exemplar-pilot Production cleanup

**Finding (read-only verification, 2026-08-11):** the README §5 cleanup
**appears already executed — by someone, with no log entry.** Against the
pilot user id `60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069` (from
`/tmp/cramapple_exemplar_pilot_session.json`):

| Scope item (README §5) | Current count |
| --- | --- |
| `auth.users` (pilot user; also 0 users matching `exemplar-pilot-%`) | **0** |
| `app.profiles` | **0** |
| `app.attempts` (user_id) | **0** |
| `app.response_versions` (created_by) | **0** |
| `app.grading_results` (newest row in table: 2026-07-29 — none from the pilot) | **0** |
| `app.student_memory_events` / `_snapshots` | **0** |
| **Residual NOT in README §5's scope:** `app.model_usage_ledger` | **185 rows** (2026-08-10 21:41–23:31 UTC, `gpt-4.1-mini`, 161 completed + 24 failed, actual cost ≈ $1.21) — keyed by request_id, no user linkage |

**Owner actions needed:**
1. **Confirm who deleted the rows and when.** If you (David) ran the cleanup
   on the evening of 2026-08-10 — likely, since only the owner holds the
   flow — write the `exemplar_grading_pilot_2026_08/EXECUTION_LOG.md` entry
   the README requires and update README §5 / REPORT.md "Cleanup status".
   If **not**, treat as a data-integrity incident: the same-day
   activity-log entry "Reviewer QA Sweep (2026-08-11)" independently reports
   gold-set verification assignments **missing with no audit trail** — two
   unexplained deletion reports in one window should be investigated
   together.
2. **Decide the `model_usage_ledger` residue:** keep (it is a billing/audit
   ledger; the $1.21 spend is real and the rows no longer reference any
   user) or delete the 185 rows for a zero-footprint close. Keeping is the
   conservative default; either way, record the decision in EXECUTION_LOG.md.
3. Zero-residue confirmation query (already run read-only, all zero except
   the ledger):
   ```sql
   select 'auth' src, count(*) from auth.users where id='60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069'
   union all select 'profiles', count(*) from app.profiles where user_id='60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069'
   union all select 'attempts', count(*) from app.attempts where user_id='60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069'
   union all select 'response_versions', count(*) from app.response_versions where created_by='60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069'
   union all select 'memory_events', count(*) from app.student_memory_events where user_id='60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069'
   union all select 'memory_snapshots', count(*) from app.student_memory_snapshots where user_id='60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069';
   ```

---

## 9. Deploy checklist (Step 2 bundle — owner-run, after O1)

1. **Diff against deployed first (handoff trap 2).** Deployed
   `evaluate-attempt` is **v31** (updated 2026-08-10, `ezbr_sha256
   d83e504c…` — the exemplar_mode deploy). Confirm repo HEAD ⊇ v31 before
   deploying so the bundle can't roll back the pilot-era fixes:
   `supabase functions download evaluate-attempt --project-ref pcntajvbdfqhbeewmdry` into a scratch dir and diff, or eyeball v31's source via the dashboard.
2. **Migration via the scratch-workdir procedure** (2026-08-03 hazard note:
   repo CLI is linked to **Dev**; `~/supabase` is a stale Prod-linked
   checkout — never `db push` from either):
   - `mkdir /tmp/prod-migrate-20260811 && cd /tmp/prod-migrate-20260811`
   - copy ONLY the renamed migration:
     `cp <repo>/supabase/migrations/20260811TBD_grading_telemetry.sql supabase/migrations/20260811<HHMMSS>_grading_telemetry.sql`
     (pick a real timestamp; the TBD name is unappliable by design)
   - `supabase link --project-ref pcntajvbdfqhbeewmdry` then
     `supabase db push` from that scratch workdir; verify with
     `select column_name from information_schema.columns where table_schema='app' and table_name='grading_results' and column_name in ('normalized_response_sha256','cached_tokens','stage_timings');`
3. **Deploy:**
   `supabase functions deploy evaluate-attempt --project-ref pcntajvbdfqhbeewmdry --use-api --workdir /Users/davidbloom/Documents/Cramapple.nosync`
   (bump `MATH_VERIFIER_VERSION` stamp per the comment in `index.ts` as part
   of this deploy — `stats-verifier-ts-2026-08-11`.)
4. **Post-deploy smoke:**
   - SFRQ-008 correct answer (e.g. gold A2's text) →
     `checkStatisticsDeterministicEvidence` passes; grading reaches the
     model path (`model_id` ≠ `deterministic-statistics-prefilter`).
   - Canary one response per remaining keyed item (001, 002, 003, 004, 007,
     009, 010, 011, 012, 013, 014, 016, MOD3, MOD6) → no NEW false flags
     (expected: gold A1 texts all pass; the invariant harness is the local
     pre-check: `deno test --allow-read --allow-env scripts/grading-model-assessment/verify_deterministic_keys_test.ts`).
   - Telemetry rows visible:
     `select request_id, stage_timings, cached_tokens, normalized_response_sha256 from app.grading_results order by created_at desc limit 5;`
   - Note: smoke calls create Production rows — use the per-run
     create→run→cleanup protocol (replan 3.0) and log the cleanup.
5. Activity-log entry for the deploy (Gate 2 requirement).

## 10. Owner-run morning steps (commands)

```bash
# 0. Review this package, decide O1/O2/O3.

# 1. Full test suite (should be 137 passing):
deno test --allow-read --allow-env supabase/functions/_shared/ \
  scripts/grading-model-assessment/ docs/research/exemplar_grading_pilot_2026_08/

# 2. Key-audit table regeneration (for the O1 review):
deno run --allow-read scripts/grading-model-assessment/verify_deterministic_keys.ts

# 3. After O1: deploy bundle per §9.

# 4. Step 3 Run A (recovered accuracy) — new isolated pilot identity first
#    (owner-run; handles a password):
node docs/research/exemplar_grading_pilot_2026_08/create_pilot_session.mjs
#    ...confirm email, then:
node docs/research/exemplar_grading_pilot_2026_08/create_pilot_session.mjs --signin
#    then the ~14 previously-gated responses × 5 trials, arm off only:
SUPABASE_PUBLISHABLE_KEY=<key> PILOT_MODE=full PILOT_TRIALS=5 PILOT_ARMS=off \
  PILOT_RUN_LABEL=runA-20260811 PILOT_OUTPUT_FILE=docs/research/exemplar_grading_pilot_2026_08/raw_calls_runA.jsonl \
  node docs/research/exemplar_grading_pilot_2026_08/run_pilot.mjs
#    (captures request_body_sha256 per call now; score with --policy partial-v2
#     alongside the default, per replan 3.1; per-run cleanup after.)
```

## 11. Blocked / needs-owner items

| Item | Why blocked |
| --- | --- |
| Step 2 deploy + migration | O1 approval (hard gate) |
| Per-criterion flag scoping build | O2 decision |
| EXECUTION_LOG.md for the pilot cleanup + `model_usage_ledger` residue | O3 §8 — cleanup already happened but is unlogged; needs owner confirmation of who/when |
| Run A / Run B / Run C (paid) | O3 close + deploy bundle; owner-run identity creation |
| Gold answers for SFRQ-011..018 + MOD items | keyed entries currently canonical-only; needs the gold-set program (cross-referenced, owned there) |
| `NUMERIC_ELEMENT_CRITERIA` mapping review | part of O1 review (hand-read from fixtures) |
| Unexplained-deletion overlap with the 2026-08-11 QA-sweep "missing assignments, no audit trail" finding | owner investigation if O3 answer is "not me" |

Production reads were NOT blocked this session — the Supabase MCP
`execute_sql` worked read-only throughout, so nothing is queued as
"BLOCKED: needs read access."

## 12. Files changed/created this session (git status style)

Pre-existing uncommitted changes from the prior session are retained
untouched (`README.md`, `gold_cases*.json`, `grading_cross_subject_takeaways.md`,
`report.json`, `results_*.json`, `raw_trial_variance.json`,
`GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md`, the second-opinion
prompt file, and parts of `ACTIVITY_LOG.md`/the ledger).

Modified this session:
```
M docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md      (T5: UPDATE 2026-08-11 section at top of body)
M docs/activity_log/ACTIVITY_LOG.md                  (T4c: new 2026-08-11 entry + index line)
M docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md (T4b: exemplar row struck + correction note)
M docs/research/exemplar_grading_pilot_2026_08/REPORT.md        (T4a: "Correction — 2026-08-11" appended)
M docs/research/exemplar_grading_pilot_2026_08/run_pilot.mjs    (T2d: request_body_sha256; import-safe guard)
M docs/research/exemplar_grading_pilot_2026_08/to_result_cases.mjs (T2a: replay shape + fail-loud + PILOT_OUT_DIR)
M scripts/grading-model-assessment/harness.ts        (T2b/c: partial-v2 policy, collapseToItemClusters)
M scripts/grading-model-assessment/harness_test.ts   (new tests)
M scripts/grading-model-assessment/main.ts           (--policy flag; both bootstrap intervals)
M supabase/functions/_shared/statistics-verifier.ts  (T7a: SFRQ-008 fix + per-entry provenance; STATISTICS_TARGETS exported)
M supabase/functions/evaluate-attempt/index.ts       (T7c: passive telemetry; version-bump comment)
```

Created this session:
```
?? docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md
?? docs/research/GRADING_ENGINE_REPLAN_MORNING_PACKAGE_2026_08_11.md (this file)
?? docs/research/exemplar_grading_pilot_2026_08/POLICY_SIMULATIONS_2026_08_11.md
?? docs/research/exemplar_grading_pilot_2026_08/run_pilot_test.ts
?? docs/research/exemplar_grading_pilot_2026_08/to_result_cases_test.ts
?? scripts/grading-model-assessment/verify_deterministic_keys.ts
?? scripts/grading-model-assessment/verify_deterministic_keys_test.ts
?? supabase/functions/_shared/grading-telemetry.ts
?? supabase/functions/_shared/grading-telemetry_test.ts
?? supabase/migrations/20260811TBD_grading_telemetry.sql
```
