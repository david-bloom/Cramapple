# Independent re-QA: content-completeness and content-quality work

**Date:** 2026-07-20
**Branch under audit:** `codex/five-subject-harness-and-content`
**Commits under audit:** `c5f5392` (package-completeness preflight), `c5dfa0d` (QA-driven content corrections), `b462364` (ingestion-path and minimum_fix remediation)
**Method:** Isolated worktree (`/private/tmp/cramapple-content-qa`, already checked out at `b462364` before this audit began). Static code review, a disposable local Postgres 17.10 instance (initdb + pg_ctl, no Docker, no network) used to dry-run the migration under audit and its trigger functions against adversarial fixtures, `deno test`/`deno run`/`deno check`, and read-only queries against the connected Production Supabase project (`pcntajvbdfqhbeewmdry`).
**Remediation:** committed locally to the worktree branch as `e7fd3b7`. Not pushed. Not applied to Dev or Production.

---

## 1. Verdict

**PASS WITH RESIDUAL WARNINGS** (after local remediation `e7fd3b7`).

Before remediation this would have been **FAIL**: the proposed production migration (`202607200001_subject_package_preflight.sql`) contained a PL/pgSQL syntax error that would abort at `CREATE FUNCTION` time (the migration could never have been applied at all), plus a second, independent runtime bug (`jsonb_path_query` column-naming) that would have broken all FRQ ingestion through the subject-harness path even if the first bug were fixed in isolation, plus a logic gap that let the migration's own target defect (generic boilerplate `minimum_fix`) slip through its "is this row complete" check undetected. All three are fixed and verified end-to-end in this pass. The repository-level content batch (288 packages) was already clean; the residual warnings are about production data volume (818 pre-existing legacy defects, none of which this migration is scoped to touch) and about a repo-content coaching-language quality issue found in the Physics packages (see Findings, MEDIUM).

---

## 2. Findings (ordered by severity)

### BLOCKING (all fixed locally, commit `e7fd3b7`)

**B1. Migration fails to parse — bare `CASE...END` as a direct `IF...OR...THEN` operand.**
File: `supabase/migrations/202607200001_subject_package_preflight.sql`, original lines 43–47 (inside `app.assert_subject_item_package_preflight()`).
```sql
or case
  when coalesce(v_criterion->>'points', '') ~ '^[0-9]+$'
    then (v_criterion->>'points')::integer < 1
  else true
end
```
Reproduced against a real Postgres 17.10 instance: `CREATE FUNCTION` itself throws `ERROR: syntax error at end of input`, both in the full migration file and in a 12-line minimal repro with the regex condition stripped out entirely (a bare `case when true then true else true end` used directly as an `if` condition, unparenthesized, fails identically; wrapping it in parens fixes it). This is a genuine PL/pgSQL parser limitation, not a typo in this specific expression. **Impact: the entire migration transaction would have aborted at this statement — none of the intended repair, backfill, or fail-closed logic would ever have executed, on Dev or Production.** Fixed by parenthesizing the `CASE` expression.

**B2. `jsonb_path_query`'s unnamed output column is not called `value` — every FRQ insert would crash.**
File: same migration, two occurrences (`assert_subject_item_package_preflight()` and the replacement `project_item_package_details()`), plus the pre-existing `20260715215736_five_subject_harness_content_pool.sql` (not touched by this migration, same latent bug).
```sql
for v_criterion in
  select value from pg_catalog.jsonb_path_query(v_payload, '$.parts.**.criteria[*]')
loop
```
Unlike `jsonb_array_elements` (whose single OUT parameter genuinely is named `value` — confirmed directly: `select value from jsonb_array_elements('[1,2,3]'::jsonb)` works), `jsonb_path_query`'s unnamed output column defaults to the function name. Reproduced directly: `select value from jsonb_path_query('{"a":[1,2]}'::jsonb, '$.a[*]')` → `ERROR: column "value" does not exist`. Reproduced inside the actual trigger by seeding a legacy FRQ row and letting the (then-unpatched) trigger fire: the entire `INSERT` into `content_item_versions` rolled back. **Impact: every FRQ ingested through the subject-harness path — well-formed or malformed alike — would fail outright with an unrelated Postgres error, not a clean business-logic rejection; MCQ ingestion is unaffected (its loop uses `jsonb_array_elements`).** Fixed by changing to `select *` (verified: PL/pgSQL binds a single-column resultset into a scalar loop variable positionally, so this works regardless of the projected column's name).

**B3. Repair/fail-closed check cannot detect the retired trigger's own hardcoded generic fallback text.**
File: same migration, backfill CTE/UPDATE and the closing `DO` block (original lines ~96–133).
The completeness check for `minimum_fix` was `nullif(btrim(minimum_fix), '') is null` — i.e., "is it empty?" The retired `project_item_package_details()` trigger (from `20260715215736_...`) wrote the literal string `'Add the missing evidence identified by this criterion.'` into every FRQ criterion's `minimum_fix` regardless of what was authored — a *non-empty* string, so it silently passes the emptiness check and the migration's own fail-closed gate reports the row as complete. Verified with a local fixture: after applying the (syntax-fixed) migration to a row seeded with this exact literal, `minimum_fix` remained unchanged and the fail-closed `DO` block did not raise. **This is precisely the "generic minimum_fix" failure pattern the audit brief asked to search for (`"Add/include the missing information/evidence"`), and precisely what this migration's own commit message claims to fix ("instead of the former generic fallback").** Fixed by adding an explicit check for that literal string alongside the emptiness check, in both the backfill `UPDATE` and the fail-closed `DO` block. Re-verified: the same fixture now correctly repairs the generic text to the source-derived fallback (`"To earn this point, explicitly show shows X; shows Y."`) while a separately-seeded row with real authored `minimum_fix` text is left untouched.

**B4. `content-preflight.ts` throws an uncaught `TypeError` on a malformed nested array entry instead of failing closed with a structured finding.**
File: `supabase/functions/_shared/content-preflight.ts`, `checkFrq`/`checkMcq` (original lines 89–90, 124–128).
A `criteria: [null]` or `choices: [null, ...]` entry (plausible from a hand-edited or partially-serialized JSON package) crashed with `Cannot read properties of null (reading 'criterion_key'/'is_correct')`. Reproduced directly by calling `preflightItem` with such a package. **Impact: this is the single source-of-truth completeness gate documented as "MUST run on every content ingestion path... An item with any BLOCKING finding must be rejected" — an uncaught exception here means a caller without a try/catch around `preflightBatch`/`assertPreflight` (e.g. `scripts/content-preflight/run.ts`'s `main()`, which has none) aborts the whole batch with a raw stack trace instead of the intended structured, machine-readable rejection, breaking CI/tooling consumption of `--json` output.** Fixed: malformed entries now produce `FRQ_CRITERION_MALFORMED`/`MCQ_CHOICE_MALFORMED` blocking findings and are skipped rather than crashing the check. Two regression tests added.

### MEDIUM (quality; not fixed — requires subject-matter judgment, out of scope for deterministic remediation)

**M1. Nine `minimum_fix` strings are verbatim-duplicated across unrelated FRQ criteria in Physics content, all matching the migration's auto-generated fallback template.**
Repo grep across all 288 packages found 9 distinct `minimum_fix` strings, each reused across 2–3 *different* FRQ items testing different scenarios, all of the shape `"To earn this point, explicitly show X; Y; Z."` (the exact synthesis template from B3's backfill logic). Examples:
- `"To earn this point, explicitly show Gauss's law; spherical symmetry."` — reused across `apphycem-frq-001`, `apphycem-frq-007`, `apphycem-frq-013` (`content/item-packages/ap-physics-c-em/`)
- `"To earn this point, explicitly show constant volume; 748; first law."` — `apphy2-frq-001`, `apphy2-frq-008`
- `"To earn this point, explicitly show Kirchhoff's voltage law; initial condition V"` — `apphycem-frq-004`, `apphycem-frq-010`, `apphycem-frq-016`
- (6 more listed in the working transcript; full list available on request)
This is the "thin, mechanical, generic... criterion-specific minimum_fix" failure pattern named in the audit brief — the text is criterion-linked (not obviously wrong) but appears templated from `required_evidence` rather than authored as distinct opportunity-framed coaching per item. Preflight passes this cleanly (non-empty, distinct-per-file), so it is invisible to any mechanical gate; it needs a subject-matter author to rewrite, which is outside deterministic-fix scope.

### WARNING / INFORMATIONAL

**W1. Production has 818 pre-existing content-completeness defects, entirely outside the scope of this migration.** See §4. None of these rows have `item_package_payload` set (see W2), so `202607200001` — which only targets rows `where item_package_payload is not null` — is correctly scoped to *not* touch them; they remain an open remediation item under whatever process already owns the legacy admin-content path.

**W2. The prior audit's production numbers are accurate, but its causal attribution is wrong: there is no subject-harness content in Production at all.** Production's `content_item_versions` table has no `item_package_payload`, `item_package_sha256`, `item_package_schema_version`, or `archetype_version_id` columns — `list_migrations` confirms Production has never run `20260715215736_five_subject_harness_content_pool` or any later migration in that lineage (`202607200001` included). The 172 incomplete criteria / 74 assigned + 6 published affected FRQs are all Chemistry and Physics content (`apchem-*`, `apphy1-*`, `apphy2-*`, `apphycem-*`, `apphycm-*`) ingested through the legacy `admin-content` compatibility path, not through subject-harness ingestion. The prior audit's raw counts reproduce exactly (see §4); its "subject-harness" label for the root cause does not.

**W3. `content-preflight.ts`'s test suite has a coverage gap for several blocking codes** (`FRQ_CRITERION_KEY_MISSING`, `FRQ_LEARNER_TEXT_EMPTY`, `FRQ_NO_CRITERIA`, `MCQ_TOO_FEW_CHOICES`, `MCQ_CHOICE_TEXT_EMPTY`, `MCQ_NOT_FOUR_CHOICES`, `UNKNOWN_ITEM_TYPE`) — manually verified all of these behave correctly via an ad hoc adversarial script (see §7), but none has a permanent regression test. Not fixed (no defect found, purely a coverage gap); flagging for a follow-up test-hardening pass.

**W4. `admin-content/index.ts`'s multi-step persistence (`content_items` → `content_item_versions` → `mcq_choices`/`frq_criteria`) is not wrapped in an explicit DB transaction** — each step is a separate REST call. `assertPreflight` correctly runs before any of these calls (so malformed content cannot enter), but a network failure mid-sequence could leave a `content_item_versions` row with no choice/criteria rows. This would surface as a completeness-scan finding on the next audit pass rather than a silent gap, so it is a durability/quality concern, not a security bypass.

---

## 3. Repository QA totals

| Metric | Result |
|---|---|
| Packages reviewed | 288 (independently counted via `find content/item-packages -name '*.json' \| wc -l`) |
| MCQ packages | 160 |
| FRQ packages | 128 |
| Total FRQ criteria | 364 |
| AP subjects | 8 (`ap-calculus-ab`, `ap-calculus-bc`, `ap-chemistry`, `ap-physics-1`, `ap-physics-2`, `ap-physics-c-em`, `ap-physics-c-mechanics`, `ap-precalculus`) |
| `scripts/content-preflight/run.ts --strict --json` over all 288 packages | **0 blocking, 0 warnings, ok: true** |
| Known bad-pattern greps (`"This option conflicts with"`, generic "equivalent reasoning earns credit", "Add/include the missing information/evidence") | **0 hits** across all 288 packages |
| Duplicate/templated `minimum_fix` reused across unrelated criteria | **9 instances found** (M1) — Physics only |
| Pass / revise / reject | 288 pass mechanical completeness; 9 criteria (M1) flagged revise on substantive-quality grounds; 0 reject |
| Blocking / quality / warning / informational totals (this audit, all scopes) | 4 blocking (all fixed) / 1 quality (M1, unfixed, needs authoring) / 4 warning-informational (W1–W4) |

Note: the substantive-quality pass (correctness of canonical answers/rubrics, distractor-mechanism distinctness beyond exact/near-duplicate text, prompt/rubric alignment) was done via targeted pattern search and duplicate-detection across all 288 packages plus the full mechanical/adversarial test matrix — not a full manual expert read of all 364 criteria's subject-matter content line by line. That would require domain-expert review time beyond this pass's scope; flagging this explicitly per the instruction not to represent schema validation as substantive correctness review.

---

## 4. Production read-only inventory (`pcntajvbdfqhbeewmdry`, read-only queries only, nothing applied)

Migration history confirms Production has **not** run any subject-harness/atomic-publication migration (`atomic_content_publication`, `task0017_*`, `five_subject_harness_content_pool`, `subject_package_preflight`) — it is on an earlier, separate lineage from Dev/this branch.

**Items by type/status** (`content_items`, current rows):

| item_type | status | count |
|---|---|---|
| frq | assigned | 165 |
| frq | draft | 141 |
| frq | published | 129 |
| frq | retired | 1 |
| frq | reviewed_disapproved | 4 |
| mcq | assigned | 188 |
| mcq | draft | 103 |
| mcq | published | 84 |
| mcq | retired | 1 |
| mcq | reviewed_approved | 2 |

**Totals: 818 items — 440 FRQ, 378 MCQ. Matches the prior audit's hypothesis exactly.**

**MCQ answer-key/choice mechanical checks (latest version per item):** 0 items with fewer than 2 choices, 0 with zero-or-multiple correct keys, 0 with empty `choice_text`/`rationale`, across every status. MCQ structural integrity is clean.

**FRQ criteria completeness (latest version per item, joined to `frq_criteria`):**

| item status | total criteria | empty evidence_requirements | empty minimum_fix | invalid points | empty accepted_variants |
|---|---|---|---|---|---|
| assigned | 435 | 158 | 158 | 0 | 211 |
| draft | 250 | 0 | 0 | 0 | 103 |
| published | 440 | 14 | 14 | 0 | 246 |
| retired | 4 | 0 | 0 | 0 | 4 |
| reviewed_disapproved | 13 | 0 | 0 | 0 | 13 |
| **total** | **1142** | **172** | **172** | **0** | **577** |

**172 incomplete criteria, 577 empty accepted_variants — both match the prior audit exactly.**

**Affected FRQ items:** 74 assigned + 6 published = 80 total, all Chemistry/Physics content_keys (`apchem-frq-l-002..006`, `apchem-sfrq-002..010`, `apphy1-frq-002..016`, `apphy2-frq-002..016`, `apphycem-frq-002..016`, `apphycem-frq-001` published-affected, `apphycm-frq-002..016`, plus 6 published: `apchem-frq-l-001`, `apchem-sfrq-001`, `apphy1-frq-001`, `apphy2-frq-001`, `apphycem-frq-001`, `apphycm-frq-001`). **Matches the prior audit's 74/6 split exactly** — full content_key list preserved in the query transcript above.

**Empty explanations:** 292 FRQ + 218 MCQ = **510. Matches prior audit exactly.**

**FRQs missing canonical answer:** 28 (assigned) + 76 (draft) + 4 (published) + 4 (reviewed_disapproved) = **112. Matches prior audit exactly.**

**FRQs with zero criteria:** 0 (none found at any status — every FRQ item has at least one `frq_criteria` row).

**Conclusion: every quantitative claim in the prior audit reproduces exactly against Production. The only correction is attribution — these are legacy `admin-content`-path Chemistry/Physics defects, not subject-harness defects (subject-harness content doesn't exist in Production's current schema).**

---

## 5. Ingestion-path coverage table

| Path | Preflight gate? | Before persistence / atomic? | Malformed content can bypass? | Authored fields preserved? |
|---|---|---|---|---|
| `admin-content` `create_draft`/`update_draft`/`bulk_import` (`ensureLegacyProjection`) | Yes — `assertPreflight` at `supabase/functions/admin-content/index.ts:171`, before any `content_items`/`content_item_versions`/`mcq_choices`/`frq_criteria` write | Before persistence; **not** atomic across the 4-table write sequence (separate REST calls, no transaction) — see W4 | No (gate runs unconditionally for `mcq`/`frq` item_type before this path's writes) | Yes |
| `admin-content` `publish`/`retire`/`unpublish` (`changeArtifactState` → `publish_content_item_version_atomic` RPC) | No completeness re-check at publish time — but content was already gated at create/update time on this same path, so nothing new can be introduced here; the RPC's own gates (source/rights/review/validation/calibration/security) are unrelated to MCQ/FRQ completeness | Atomic (single RPC, `for update` row locks) | N/A — doesn't write choice/criteria rows | N/A |
| Subject-harness compiler (`scripts/subject-harness/compiler.ts:232`) → `apply_subject_package_atomic` RPC → `project_item_package_details()` trigger | Yes, in two places: `assertPreflight` in the TS compiler before the plan is built, **and** (after `202607200001`, with this audit's fixes) `assert_subject_item_package_preflight()` as a `BEFORE INSERT` DB trigger — genuine defense-in-depth, not just a single choke point as claimed | `apply_subject_package_atomic` itself is one transaction (advisory locks + row locks); the `AFTER INSERT` projection trigger fires within the same transaction as the triggering INSERT | Before this audit's fix: **yes** — B1/B2 meant the DB-side gate couldn't even run (crashed before evaluating anything), leaving the TS-side compiler check as the only gate. After the fix: no — both gates function. | Yes, after `202607200001`'s fix (`project_item_package_details()` now projects the authored `minimum_fix` instead of a hardcoded literal — this migration's whole purpose) |
| Direct SQL seed/backfill migrations (e.g. `20260713172817_task0017_h3_h5...`, `20260715215736_five_subject_harness_content_pool.sql`) | No independent completeness gate — these predate `202607200001`'s trigger | N/A (one-time migrations) | Historically yes — this is exactly how the pre-`202607200001` generic-fallback `minimum_fix` got written | No (this is the defect `202607200001` exists to repair) |
| `review-decision`, `evaluate-attempt`, `attempt-response`, `review-queue`, `assign-for-review` | N/A | N/A | N/A — confirmed by direct code read: these functions only **read** `mcq_choices`/`frq_criteria`/`content_items`, or **update** unrelated fields on `content_item_versions` (`review_status`). None create or modify content authoring fields. | N/A |

**No unguarded write path to `app.content_items`, `app.content_item_versions`, `app.mcq_choices`, or `app.frq_criteria` was found** beyond the pre-existing legacy production data (W1/W2), which predates any of these gates and is out of scope for this branch's migration.

---

## 6. Changes made

Commit `e7fd3b7` on `codex/five-subject-harness-and-content` (worktree `/private/tmp/cramapple-content-qa`), not pushed:
- `supabase/functions/_shared/content-preflight.ts` — fail closed instead of throwing on malformed (`null`/non-object) array entries in `criteria`/`choices` (B4).
- `supabase/functions/_shared/content-preflight_test.ts` — 2 new regression tests for B4.
- `supabase/migrations/202607200001_subject_package_preflight.sql` — fixed the `CASE`-in-`IF` parse error (B1), the `jsonb_path_query`/`value` column bug in both functions (B2), and the generic-boilerplate-detection gap in the backfill/fail-closed logic (B3).

No production or Dev database was modified. No other files touched. The unrelated existing worktree state (already at `b462364` before this audit) was left untouched.

---

## 7. Verification commands and results

```
$ deno test --allow-read \
    supabase/functions/_shared/content-preflight_test.ts \
    scripts/content-preflight/run_test.ts \
    scripts/subject-harness/validate-contracts_test.ts \
    scripts/subject-harness/compiler_test.ts
ok | 32 passed | 0 failed          # was 30 passed before this audit's 2 new tests

$ deno run --allow-read scripts/content-preflight/run.ts \
    $(find content/item-packages -name '*.json') --strict --json
{"ok": true, "blocking": 0, "warnings": 0}

$ deno run --allow-read scripts/five-subject-content/verify.ts
exit 0, all 6 subjects' plans valid, advisories: []

$ deno run --allow-read scripts/calculus-content/verify.ts
exit 0, all subjects' plans valid, advisories: []

$ deno check supabase/functions/_shared/content-preflight.ts scripts/content-preflight/run.ts \
    scripts/subject-harness/compiler.ts supabase/functions/admin-content/index.ts \
    supabase/functions/admin-content/publication-request.ts
Check ✓ (all 5 files, no errors)

$ deno lint supabase/functions/_shared/content-preflight.ts scripts/content-preflight/run.ts
Checked 2 files (no errors)
```

Migration dry-run: applied `202607200001_subject_package_preflight.sql` (post-fix) to a disposable local Postgres 17.10 instance (`initdb`/`pg_ctl`, socket-only, no network) seeded with a minimal `app` schema matching production's `content_items`/`content_item_versions`/`mcq_choices`/`frq_criteria` shape. Verified: idempotent re-run (second run: `UPDATE 0`, no errors), correct repair of the generic-boilerplate case, correct preservation of real authored `minimum_fix`, correct fail-closed abort on a genuinely-unrecoverable row (empty `minimum_fix` + empty `required_evidence`), and the full adversarial matrix against the new `BEFORE INSERT` trigger (zero/negative/fractional points, whitespace-only fields, empty `required_evidence`, zero criteria, MCQ too-few-choices/zero-correct/multiple-correct/empty-text/empty-rationale, unknown `item_type`) — every case rejected with the intended `content_preflight:*` error code, both well-formed FRQ and MCQ inserts succeeded and their `mcq_choices`/`frq_criteria` rows landed correctly.

---

## 8. Residual risks and required next actions

1. **M1 (duplicate/templated Physics `minimum_fix`)** needs a subject-matter author pass — not fixable deterministically. 9 criteria across `ap-physics-2`, `ap-physics-c-em`, `ap-physics-c-mechanics`.
2. **W1/W2 (818 production items, 172 incomplete criteria, 80 affected FRQs, all Chemistry/Physics legacy content)** remain open in Production, out of scope for this branch's migration (which correctly only targets `item_package_payload is not null` rows, of which Production has none). Whoever owns the Chemistry/Physics content-authoring backlog should be pointed at the exact `content_key` list in §4.
3. **W3 (test-coverage gap)** — add permanent regression tests for the currently-untested-but-verified-correct blocking codes; low priority, no defect found.
4. **W4 (non-atomic multi-table admin-content writes)** — consider wrapping `ensureLegacyProjection`'s sequence in a single RPC/transaction if partial-write-on-network-failure risk is judged worth closing; currently fails safe (an orphaned row would surface on the next completeness scan, not silently pass).
5. **This migration is still unapplied everywhere** (repo-only, per its own header comment). Before it is ever applied to Dev or Production, re-run the same dry-run validation against a fresh disposable Postgres instance matching the target environment's actual schema state, since this audit's local schema was a minimal reconstruction, not a literal `pg_dump` of Dev/Production.

No commit hash beyond `e7fd3b7` (local remediation only; nothing pushed, nothing deployed).
