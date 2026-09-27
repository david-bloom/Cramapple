# Codex Work Order FF-12 — Schedule `servable_items_check.py`

**Why this is FF-12.** Three silent serving failures were found by hand on 2026-09-24 — one had
been live for six weeks, one was introduced that same morning. `scripts/qa/servable_items_check.py`
now exists and self-verifies its own census against the real serving RPCs before trusting any
number, but it only runs when someone remembers to type the command. FF-12 is making that automatic.

**Scope is intentionally narrow.** This is CI/scheduling work, not content or serving-logic work. It
does not touch what a student is served.

**Update 2026-09-24, after this was first written.** The plan below originally called for granting
`supabase_read_only_user`. That role turned out to be Supabase-reserved — not even a superuser
session can `ALTER ROLE` it. Claude created a dedicated role instead, **`ci_servable_items_reader`**
(`NOLOGIN` is false — it can log in — `NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT`, connection
limit 3), and has **already applied** `GRANT USAGE ON SCHEMA app` and the two `EXECUTE` grants below
directly to Production. **Step 1 is done — skip it.** The GitHub secret is also already set, using a
session-pooler connection string for this new role. Codex's job is now only Step 2.

**One step Codex cannot do.** Adding/updating the GitHub Actions secret is a repo-settings action
only David can perform — already done for this round, noted here so a future re-run of this order
doesn't assume otherwise.

Paste the block below into Codex.

```text
Work order FF-12 — put scripts/qa/servable_items_check.py on an unattended schedule.

Merge main first:

    git fetch origin
    git switch codex/work-order-ff12-schedule-servable-check
    # If that branch does not exist instead run:
    # git switch -c codex/work-order-ff12-schedule-servable-check origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/work-order-ff12-schedule-servable-check as you go. Do not open a PR and do not merge to main.

READ FIRST: scripts/qa/servable_items_check.py. It already:
  - runs app.servable_items_census_selftest() and fails on any drift between its mirrored
    predicates and the real serving RPCs,
  - runs app.servable_items_census() and compares it to docs/research/servable_items_baseline.json,
  - fails (exit 1) on any DECREASE in unit_gated/drill/full_exam servable counts, exit 2 if it
    cannot run at all, exit 0 on pass.
Do not modify the script's logic. This work order is only about running it automatically.

STEP 1 — GRANT MIGRATION: ALREADY DONE, DO NOT REPEAT

The minimal-privilege CI role (`ci_servable_items_reader`) exists on Production and already has
`USAGE` on schema `app` and `EXECUTE` on both `app.servable_items_census()` and
`app.servable_items_census_selftest()`, applied directly by Claude on 2026-09-24 (see the note at
the top of this file for why `supabase_read_only_user` wasn't usable). **Do not write a grant
migration.** If you want a record of the grants in the migration history for consistency with how
the rest of this repo tracks schema/permission changes, you may propose a no-op-safe migration file
that documents what's already live (`grant ... if not exists`-equivalent, i.e. plain `grant`
statements are idempotent in Postgres and safe to replay) -- but this is optional housekeeping, not
a blocker, and Claude will verify the grants against Production either way before applying anything
you propose.

STEP 2 — GITHUB ACTIONS WORKFLOW

Add .github/workflows/servable-items-check.yml, modeled on the existing
.github/workflows/minimal-ci.yml (pin actions to a commit SHA the same way, same style comment
conventions). Requirements:

  - Triggers: `schedule` with a daily cron (pick a specific UTC time, e.g. early morning Eastern,
    and say in a comment why you picked it -- there's no wrong answer here, just don't leave it
    unstated) AND `workflow_dispatch` so a human can trigger it on demand without waiting for the
    schedule.
  - `permissions: contents: read` (this job only reads).
  - Steps: checkout, setup Python 3.12 (matches minimal-ci.yml), install a `psql` client (the
    script shells out to `psql` and will exit 2 without it -- add whatever apt step gets
    `postgresql-client` onto the ubuntu-latest runner), then run:
      CRAMAPPLE_DB_URL="${{ secrets.SERVABLE_ITEMS_CHECK_DB_URL }}" python3 scripts/qa/servable_items_check.py
  - Do not add `--update-baseline` to the scheduled run. That flag is a human decision (the script's
    own comment says increases "require a baseline update") -- a scheduled job must never rewrite
    the baseline it's checking against.
  - Let the job fail naturally on the script's non-zero exit; do not swallow or soft-fail it.
  - This targets Production only (that's what the committed baseline was measured against). Do not
    add a second job for Development in this work order -- out of scope, flag it as a follow-up
    instead if you think it's worth doing.

Name the secret exactly SERVABLE_ITEMS_CHECK_DB_URL so the workflow file and the instructions David
has to follow (below) match without translation.

WHAT WOULD MAKE THIS REJECTED AT QA

  - Proposing a grant to `supabase_read_only_user` (reserved, unmodifiable) or widening
    `ci_servable_items_reader`'s privileges beyond what's already live.
  - The workflow connecting with anything other than the secret named SERVABLE_ITEMS_CHECK_DB_URL,
    or embedding a credential directly in the YAML.
  - `--update-baseline` anywhere in the scheduled job.
  - Unpinned (tag-only, not SHA-pinned) actions, inconsistent with minimal-ci.yml's own convention.
  - Modifying servable_items_check.py's logic instead of only scheduling it.

Proposal only. No Production writes, and do not create or touch any GitHub secret yourself (you
don't have access to do so, and it's already set). Claude QAs this and merges the workflow file.
```

## What David already did (this section is now historical)

GitHub Actions secrets can only be set by someone with repo admin access in the GitHub UI/CLI. This
was completed 2026-09-24: `SERVABLE_ITEMS_CHECK_DB_URL` is set in the repo's Actions secrets, using a
session-pooler connection string for `ci_servable_items_reader` (verified working via a manual
`psql` connection before saving it). Nothing further needed here unless the credential needs
rotating later.

## Why this is the right shape for Codex

FF-12 is infrastructure, not a decision — unlike FF-3/FF-4/FF-5/FF-9, which are blocked on Product
Owner calls, this one just needs to be built. It's independent of the J.0 → N → N.1 queue and can run
in parallel with it.

## What stays with Claude

- QA of the workflow file (SHA-pinning, correct secret name, no baseline-mutation flag) and of any
  optional documentation-only grant migration Codex proposes.
- Merging the workflow.
- Triggering an initial `workflow_dispatch` run once merged to confirm it actually connects and
  passes, rather than waiting on the first scheduled run to find out.
- Updating `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` to close FF-12 once that run is verified.
