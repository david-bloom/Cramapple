# Reference Packs: Production Promotion Plan (8 Batches, 776 Entries, 7 Hooks)

**STATUS:** **APPROVED AND APPLIED, 2026-10-11 (`APPROVAL-0154`).** David approved all eight batches and
chose to promote the duplicate AP Physics 1 hooks as-is, fixing the repetition in serving. Production went
**307 → 1,083 published entries and 6 → 13 published hooks**, equal to Development. §8 below records the
verification run. Everything above §8 is the pre-approval plan, kept as written so the evidence that
justified the apply can be read separately from the result.

**DATE:** 2026-10-11 (America/New_York)

**OWNER:** Claude session. **PRODUCT OWNER:** David Bloom.

**TASKS:** `TASK-0067` (unit reference content), `TASK-0066` (memory hooks).

**GOVERNING PROTOCOL:** `docs/product/MEMORY_HOOKS_AND_UNIT_REFERENCE_PRODUCTION_PROTOCOL.md`.
Precedent: `APPROVAL-0140` (the system), `APPROVAL-0147`/`0148`/`0149` (AP Chemistry).

**APPROVAL ID:** `APPROVAL-0154` (recorded in `docs/activity_log/APPROVALS_LOG.md`).

---

## 1. A correction to the record first

`docs/handoffs/REFERENCE_PACKS_UNITS_1_3_ALL_SUBJECTS_2026_10_10.md` says "Production untouched and
still a Hard Gate." **That is now stale.** AP Chemistry went to Production the same day under
`APPROVAL-0147`/`0148`/`0149`. Production currently holds **307 published reference entries**: all
227 AP Chemistry (units 1–9) and the 80 AP Statistics Unit 1 pilot rows. Development holds **1,083**.

So the gate in front of you is not "the whole run" — it is the **776 entries in eight batches that
Production does not have**, across eight subjects. The Chemistry batches are out of scope because
they are already live.

## 2. Exactly what is being asked for

Eight batches. These are the names a Production approval should cite, per the handoff's own rule that
Development is shared and a row count is not an identifier.

| Batch | Subject | Registry units | Entries | Hooks |
|---|---|---|---:|---:|
| `ap-biology-reference-u1-u3-2026-10-10` | AP Biology | 1, 2, 3 | 95 | 0 |
| `ap-calculus-ab-reference-u1-u3-2026-10-10` | AP Calculus AB | 1, 2, 3 | 51 | 2 |
| `ap-physics-1-reference-u1-u3-2026-10-10` | AP Physics 1 | 1, 2, 3 | 99 | 3 |
| `ap-physics-2-reference-u9-u11-2026-10-10` | AP Physics 2 | 9, 10, 11 | 102 | 0 |
| `ap-physics-c-em-reference-u8-u10-2026-10-10` | AP Physics C: E&M | 8, 9, 10 | 69 | 0 |
| `ap-physics-c-mechanics-reference-u1-u3-2026-10-10` | AP Physics C: Mechanics | 1, 2, 3 | 113 | 0 |
| `ap-precalculus-reference-u1-u3-2026-10-10` | AP Precalculus | 1, 2, 3 | 145 | 2 |
| `ap-statistics-reference-u2-u3-2026-10-10` | AP Statistics | 2, 3 | 102 | 0 |
| **Total** | **8 subjects** | | **776** | **7** |

All 776 rows are `status = 'published'` in Development, with **no** draft, retired or otherwise
non-published rows in these batches — the 7 rejected escalations were never loaded, so there is
nothing to filter out at promotion time.

AP Calculus BC is **not** in this list and needs no rows: `TASK-0070`/`APPROVAL-0152` has it read AP
Calculus AB's units 1–8 through `app.subject_reference_aliases`. Promoting Calculus AB therefore
gives Calculus BC its units 1–3 content as a side effect, with no duplicate rows.

## 3. Why this is lower-risk than it looks

**No schema change. No function change. No deploy.** This is data only. Verified today:
`md5(pg_get_functiondef(...))` for `public.get_topic_point_guides` is **`25b6e08c84e5db9fac69741f93efa054`
in both Development and Production** — byte-identical, already carrying the `figures`, `reference[]`,
`memoryHooks[]` and alias-union behaviour. Nothing about the serving path needs to move.

**The committed loaders reproduce Development exactly.** This was checked, not assumed. All 25
`out/load_*.sql` files were parsed (829 natural keys, 0 conflicting duplicates) and reduced to an
order-independent checksum over `(owner_topic_code, kind, title, body)` per subject, then compared
against the same checksum computed inside Development:

| Subject | Loader n / checksum | Development n / checksum | |
|---|---|---|---|
| ap_biology | 95 / 221343578365 | 95 / 221343578365 | match |
| ap_calculus_ab | 51 / 129509940184 | 51 / 129509940184 | match |
| ap_physics_1 | 99 / 198678324753 | 99 / 198678324753 | match |
| ap_physics_2 | 102 / 214563593290 | 102 / 214563593290 | match |
| ap_physics_c_em | 69 / 150122117642 | 69 / 150122117642 | match |
| ap_physics_c_mechanics | 113 / 225051239473 | 113 / 225051239473 | match |
| ap_precalculus | 145 / 315197583551 | 145 / 315197583551 | match |
| ap_statistics | 102 / 232129179254 | 102 / 232129179254 | match |

**All eight match.** This answers the question that mattered: the 43 escalation corrections were
regenerated into these loader files, not applied as one-off updates to Development, so applying them
to Production cannot ship pre-correction text.

**The loaders are portable and idempotent.** Entries insert by natural key with
`on conflict (subject_key, owner_topic_code, kind, title) do nothing`, and no file contains a
hardcoded UUID. Hooks resolve their parent with
`select reference_entry_id from app.unit_reference_entries where subject_key = … and title = …` and
`on conflict (reference_entry_id, hook_text) do nothing` — which is exactly the §6 rule that
Development and Production hold the same entries under different ids.

## 4. Two files and one batch that must NOT be applied

- **`ap-calculus-ab-reference-u1-u3-2026-10-10/out/load_ap_calculus_bc_u1_u3_rekey.sql`** — the
  superseded "copy AB's rows to BC" approach. `DECISION`-level direction replaced it with aliasing
  (`TASK-0070`). Applying it would create the duplicate rows that task exists to avoid. Excluded.
- **The AP Chemistry batches** — already live. Note also that their committed loader is now **stale
  against Production**: the loader's checksum for `ap-chemistry-reference-u2-u3` is `120224130068`
  while both Development and Production hold `117253531577`, because `APPROVAL-0149` re-extracted
  symbol definitions into 10 rows after the loader was generated. Development and Production agree
  with each other; it is the file on disk that is behind. Do not "repair" Production from it.

## 5. Verification plan (run after apply, before reporting done)

Per `FIGURE_PRODUCTION_PROTOCOL.md` §7 and the reference protocol:

1. **Baseline first.** Capture `get_topic_point_guides` payloads for ~30 probes across all ten
   subjects *before* applying, so "unchanged elsewhere" is a comparison and not an assertion.
2. **Counts per batch tag**, not a total: each of the eight batches lands its exact row count, and
   Production's total goes 307 → 1,083.
3. **As a real authenticated student, never `service_role`.** RLS is the thing under test and
   `service_role` bypasses it. The RPC already refuses an unauthenticated caller
   (`28000 not_authenticated`), which is the behaviour to preserve.
4. **Plant a draft row and confirm the student cannot see it**, then remove it.
5. **Per topic, per unit, per subject**; a topic with no entries must return `[]`, not an error.
6. **Every subject not in this promotion is byte-identical to its baseline** once compared.
7. **Calculus BC inherits**: BC units 1–3 roll-ups should equal AB's topic for topic, through the
   alias and with zero BC rows created.
8. **Idempotency**: apply twice; counts must not move.
9. **Hook duplication, Physics 1 topic 1.5** — see §6.
10. **Checksum Production against Development** per subject, with the same expression used in §3.

**Rollback:** per batch, **retire the hooks first and then the entries** — protocol §5 step 5 notes a guard
that requires that order:

```sql
update app.topic_memory_hooks set status = 'retired'
where reference_entry_id in (select reference_entry_id from app.unit_reference_entries
                             where source_note like '%batch=<name>%');
update app.unit_reference_entries set status = 'retired' where source_note like '%batch=<name>%';
```

The RPC's `reference[]`/`memoryHooks[]` go empty for those subjects and no function or schema change is
reverted.

**Ledger:** not applicable in the end — the loaders are plain `db query` data files, not migrations, so no
`schema_migrations` row was written and there was no `apply_migration` version stamp to correct.

## 6. One thing to decide before approving

**AP Physics 1 topic 1.5 will serve SOH-CAH-TOA three times.** Three hooks carry identical
`hook_text`, `expands_to` and `when_to_use`, attached to three *different* reference entries — the
sine, cosine and tangent formula rows. That is the data model working as designed (a hook belongs to
an entry, so an acronym covering three formulas attaches three times), and the RPC's
`published_hooks` CTE does **not** de-duplicate: it joins each hook to its entry and aggregates. So
unless the client de-duplicates by `hookText`, the student sees the same acronym three times in one
topic view.

Not a content defect, and not a reason to hold the other 775 rows. Three options:

- **(a) Promote as-is** and treat de-duplication as a serving/front-end follow-up. Recommended: the
  content is right, and the fix belongs where the repetition is rendered.
- **(b) Promote 2 of the 3**, keeping the hook on one entry only. Cheapest visually, but it makes the
  hook invisible on the other two entries, which is the single-owner problem the model avoids.
- **(c) Hold the Physics 1 hooks** and promote its 99 entries without them.

The two AP Calculus AB hooks and the two AP Precalculus hooks do not have this issue — each pair sits
on different topics with tailored `when_to_use` text.

## 7. What happens on approval

Apply the eight batches' loader files to Production (excluding the BC re-key file), run §5 in order,
record the result as `APPROVAL-0154` in `APPROVALS_LOG.md` with the batch names, and update
`TASK-0067`, `TASK-0066` and `docs/INDEX.md` row 66, whose "Production is an open Hard Gate" line
this closes for these eight subjects.

**Not in scope:** follow-up **F1** — the anonymous BYOQ path reads the `public.unit_reference_entries`
and `public.topic_memory_hooks` views rather than this RPC, so a signed-out visitor will still see
nothing for aliased Calculus BC. Promotion does not change that either way.

---

## 8. What actually happened (2026-10-11)

**Applied:** 23 loader files, from the eight batches, via
`supabase db query --linked --workdir /Users/davidbloom -f <absolute path>` against Production
(`pcntajvbdfqhbeewmdry`). The home-directory CLI link is the one that points at Production, so the
repository's own link stayed on Development throughout and never had to be repointed.

One thing worth recording for the next person: `-f` resolves **relative to `--workdir`**, not to the shell's
current directory. The first attempt therefore failed 23 times with `failed to read SQL file` and wrote
nothing at all — a harmless failure, but only because it failed before connecting. Pass absolute paths.

**Results:**

| Check | Result |
|---|---|
| Per-batch counts and checksums in Production | equal to Development, batch for batch (95/51/99/102/69/113/145/102) |
| Production totals | 307 → **1,083** published entries; 6 → **13** published hooks |
| 38 authenticated-student probes, before vs after | 29 changed, 9 byte-identical |
| Controls (4 × AP Chemistry, 3 × AP Statistics Unit 1) | identical payload md5, all 7 |
| A topic with no entries (`ap_biology` 1.99) | still an empty `reference[]`, identical md5 |
| AP Calculus BC inheritance | Unit 1 roll-up 0 → 24, topic 1.2 → 3, topic 2.2 → 5, equal to AB; **0 BC rows exist** |
| AP Calculus BC Unit 6 | still 0, correct — AB has nothing there |
| Planted `draft` row | invisible to the student RPC (`draft_leaked = 0`), transaction rolled back, 0 probe rows left |
| Idempotency | two loaders re-applied; 1,083 / 13 unchanged |
| QA script checks 1-8 | all `ok = true` |

Probes ran as an authenticated student via `request.jwt.claims`, never `service_role`. The RPC needs only a
non-null `auth.uid()`, so a synthetic uuid was used and no real account was touched.

**Two pre-existing rows seen in passing:** Production holds 1,085 rows against 1,083 published — two
`retired` AP Chemistry rows (`pKa` 8.3 and `pKw, pH and pOH at 25°C` 8.1) created 2026-10-10, the duplicates
`APPROVAL-0148`'s amendment 2 retired. Not from this work.

**Accepted and open:** AP Physics 1 topic 1.5 returns `memoryHooks` of length 3, all three `hookText` equal
to `SOH-CAH-TOA`. Measured in the live payload, not inferred. De-duplication by `hookText` is a front-end
follow-up by the Product Owner's decision.
