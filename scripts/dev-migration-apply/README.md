# Dev migration applier — TASK-0017 / publication batch

File-faithful apply of the exact repo migration files to the **Development**
Supabase project (`wmgjsdkphcyhngaffbqf`), avoiding both hand-transcription of
~2,800 lines of security-critical SQL and the `db push` path (blocked by the
migration-history divergence). Uses `psql` on the exact files, then records each
version in `supabase_migrations.schema_migrations`.

## What it applies (in order)

1. `202607090001_curated_public_interface`
2. `202607090002_curated_public_interface_revoke_anon`
3. `202607130001_atomic_content_publication` — **the P0 fail-closed publish RPC**
4. `20260713172806_task0017_h1_h2_subject_harness_persistence`
5. `20260713172817_task0017_h3_h5_validation_and_exceptions`

Deferred (not in this batch): `202607080003/004` (queue backfill + admin
promotion), `202607120001` (HDG — content guard would abort).

## Provide the connection OUT OF BAND (never in chat)

1. Copy the template and fill in the **Development** connection string:
   ```sh
   cp scripts/dev-migration-apply/dev.secrets.env.example \
      scripts/dev-migration-apply/dev.secrets.env
   $EDITOR scripts/dev-migration-apply/dev.secrets.env   # paste the Dev URI
   ```
   `dev.secrets.env` is gitignored (`*.secrets.env`). Get the URI from the
   Supabase dashboard → Cramapple - Development → Settings → Database →
   Connection string.

   *(Alternatively `export CRAMAPPLE_DEV_DB_URL='...'` in the shell that runs the
   script.)*

2. The script **never prints** the connection string, and **refuses to run**
   against any database that lacks the Dev-only `task0016_phase_a_*` markers —
   so it cannot hit Production by accident.

## Run

```sh
bash scripts/dev-migration-apply/apply.sh
psql "$CRAMAPPLE_DEV_DB_URL" -f scripts/dev-migration-apply/verify.sql
```

## Evidence bundle to capture

- `verify.sql` output (P0 functions present + service_role-only; H1/H2/H3–H5
  tables; curated interface; recorded versions).
- **`app`-not-Data-API-exposed proof** (REST probe, not SQL) — expect the `app`
  schema to be unreachable via PostgREST:
  ```sh
  # Using the Dev anon key; expect 404/permission error, NOT a row payload.
  curl -s -o /dev/null -w '%{http_code}\n' \
    "https://wmgjsdkphcyhngaffbqf.supabase.co/rest/v1/content_items?select=id&limit=1" \
    -H "apikey: $DEV_ANON_KEY" -H "Accept-Profile: app"
  ```
- P0 SQL regression suite (Codex's `TASK0017_P0_*` battery) re-run green against
  the Dev-applied schema.

## Note

This applies the batch but does **not** reconcile the broader migration-history
divergence (see the Codex task packet:
`prompts/CODEX_TASK0016_0017_DEV_RECONCILE_AND_APPLY_2026_07_14.md`). Recording
these 5 versions aligns *them* with the repo; the rubric-routing and
`task0016_phase_a_*` divergences remain for the reconciliation task.
