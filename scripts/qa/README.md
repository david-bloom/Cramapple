# QA scripts

One script per piece of work. Deliberately **not** a single combined suite —
each covers a different system, has a different owner, and fails for different
reasons. Run only the one that matches what you changed.

| Script | Covers | Where to run |
| --- | --- | --- |
| `progress_dashboard_v1_qa.sql` | The `/progress` **backend**: `public.get_student_progress_dashboard` — auth, entitlement, payload shape, de-duplication math, withheld grades, the DECISION-0003 estimate gate | Prod and Dev |
| `progress_display_contract_qa.sh` | The `/progress` **frontend**: the display-only contract in the Lovable repo — single RPC, no client-side math, status-token vocabulary, no failure colour, forbidden sections, null handling. Also runs the unit tests | Local (needs the frontend repo) |
| `taxonomy_topic_seeds_qa.sql` | `app.taxonomy_topics` — per-subject counts, unit alignment, numbering gaps, the AB/BC-only rule, orphaned briefs and explainers | Prod and Dev |
| `dev_prod_drift_qa.sql` | TASK-0027 — ledger-vs-schema honesty, taxonomy-layer presence, object inventory fingerprint for cross-project diffing | Both, then diff |
| `home_loader_schema_contract_qa.sql` | The `/home` loader schema contract — the columns and table names `home.functions.ts` depends on, guarding the two silent-failure defects fixed 2026-08-21 | Prod and Dev |

## Running

SQL scripts are read-only and safe against Production:

```
psql "$PROD_URL" -f scripts/qa/<script>.sql
```

The shell script takes the frontend repo path, or reads `$CRAMAPPLE_FRONTEND`:

```
scripts/qa/progress_display_contract_qa.sh ~/Documents/exam-buddy-wireframe
```

## Conventions

- Every check raises on failure; a clean run prints only PASS notices.
- Checks that cannot assert (cross-environment comparisons, informational
  counts) emit `NOTICE`/`WARNING` and say so, rather than passing silently.
- Known, accepted gaps are encoded as accepted values with a pointer to the
  task that owns them — never as a skipped check.
- Each script states its own coverage limits. Read them: a passing script is
  only evidence for what it actually inspects.
