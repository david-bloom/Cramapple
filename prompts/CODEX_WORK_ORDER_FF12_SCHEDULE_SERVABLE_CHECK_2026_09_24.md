# Codex Work Order FF-12 — Schedule `servable_items_check.py`

**Why this is FF-12.** Three silent serving failures were found by hand on 2026-09-24 — one had
been live for six weeks, one was introduced that same morning. `scripts/qa/servable_items_check.py`
now exists and self-verifies its own census against the real serving RPCs before trusting any
number, but it only runs when someone remembers to type the command. FF-12 is making that automatic.

**Scope is intentionally narrow.** This is CI/scheduling work, not content or serving-logic work: one
small grant migration plus one GitHub Actions workflow file. It does not touch what a student is
served.

**One step Codex cannot do.** Adding the GitHub Actions secret is a repo-settings action only David
can perform — it is called out explicitly at the end so this doesn't stall waiting on Codex to find a
way around it.

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
Do not modify the script's logic. This work order is only about running it automatically and
connecting it to Production with the narrowest credential that works.

STEP 1 — GRANT MIGRATION (minimal-privilege CI credential)

The script connects with a bare `psql` connection string (CRAMAPPLE_DB_URL), not through PostgREST,
so it needs an actual Postgres login role -- never the service_role key, and never a superuser.
Production already has Supabase's built-in read-only replica role, supabase_read_only_user
(rolsuper=false, rolcanlogin=true), which currently has schema-usage on `app` but no EXECUTE on
either function the script calls (verified 2026-09-24). Add a migration that does exactly this and
nothing else:

    grant execute on function app.servable_items_census() to supabase_read_only_user;
    grant execute on function app.servable_items_census_selftest() to supabase_read_only_user;

Both functions are SECURITY DEFINER owned by postgres and read-only (no writes anywhere in their
bodies -- confirm this yourself by reading their definitions before proposing the grant, don't take
it on trust). Do not grant anything else, do not touch any other role, and do not widen any existing
grant. If either function turns out not to be read-only, stop and report it instead of proposing the
grant.

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

  - Any grant beyond the two EXECUTE grants above, to any role.
  - A grant on a function that turns out to have a write path once you actually read its body.
  - The workflow connecting with anything other than the secret named SERVABLE_ITEMS_CHECK_DB_URL,
    or embedding a credential directly in the YAML.
  - `--update-baseline` anywhere in the scheduled job.
  - Unpinned (tag-only, not SHA-pinned) actions, inconsistent with minimal-ci.yml's own convention.
  - Modifying servable_items_check.py's logic instead of only scheduling it.

Proposal only. No Production writes, and do not create or touch any GitHub secret yourself (you
don't have access to do so). Claude QAs this, applies the grant migration to Production, and merges
the workflow file. David separately adds the GitHub secret -- that step is his, not yours, and this
work order does not block on it landing first.
```

## What David has to do (not Codex, not Claude)

GitHub Actions secrets can only be set by someone with repo admin access in the GitHub UI/CLI, and
they should point at the least-privileged working credential -- not the service_role key.

1. In the Supabase dashboard for **Cramapple - Production**: Project Settings → Database →
   Connection string, select the **read-only** connection (the one backed by
   `supabase_read_only_user`), and copy the full `postgres://...` URL.
2. In GitHub: repo → Settings → Secrets and variables → Actions → New repository secret, name it
   exactly `SERVABLE_ITEMS_CHECK_DB_URL`, paste that connection string.
3. That's it — the scheduled workflow (once Claude merges it) will pick it up on its next run, or you
   can trigger it immediately from the Actions tab via `workflow_dispatch`.

## Why this is the right shape for Codex

FF-12 is infrastructure, not a decision — unlike FF-3/FF-4/FF-5/FF-9, which are blocked on Product
Owner calls, this one just needs to be built. It's independent of the J.0 → N → N.1 queue and can run
in parallel with it.

## What stays with Claude

- QA of the grant migration (confirm both functions are actually read-only before it lands) and of
  the workflow file (SHA-pinning, correct secret name, no baseline-mutation flag).
- Applying the grant to Production and merging the workflow.
- Updating `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` to close FF-12 once the secret is set and a real
  scheduled or manually-dispatched run has passed.
