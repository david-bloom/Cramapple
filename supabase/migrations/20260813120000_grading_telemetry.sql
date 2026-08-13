-- DRAFT -- DO NOT APPLY -- filename version is deliberately "20260811TBD"
-- (not a valid timestamp) so `supabase db push` / `migration up` cannot pick
-- it up accidentally. Rename to a real 14-digit timestamp as part of the
-- Step 2 deploy bundle, after O1 approval, via the scratch-workdir procedure
-- (the repo CLI is linked to Dev and ~/supabase is a stale Prod-linked
-- checkout -- 2026-08-03 migration-hazard note).
--
-- Purpose (replan 2026-08-10 item 2.2 -- all passive, no behavior change):
-- give evaluate-attempt somewhere to log the telemetry the replan's speed
-- and replay decisions are gated on. The paired code (evaluate-attempt +
-- _shared/grading-telemetry.ts) degrades gracefully when these columns are
-- absent, so code and migration do not have to land in the same instant --
-- but the migration must be applied before telemetry accrues.

alter table app.grading_results
  -- SHA-256 of the normalized response text (see
  -- supabase/functions/_shared/grading-telemetry.ts normalizeResponseText:
  -- NFKC, lowercase, whitespace collapsed, trimmed). Replay hit-rate
  -- telemetry: pre-registered decision threshold -- build cross-attempt
  -- replay only if the per-item duplicate rate exceeds ~10% once real
  -- traffic exists (replan 2.2).
  add column if not exists normalized_response_sha256 text,
  -- Provider-reported cached prompt tokens for this grading's model call(s)
  -- (summed across the Arm A fan-out). Null when the provider reports no
  -- usage detail -- an absent field is a different fact than zero.
  add column if not exists cached_tokens integer,
  -- Per-stage wall timings in ms: {"auth": .., "db": .., "deterministic":
  -- .., "model": .., "sanitize": .., "total": ..}. Stages absent on paths
  -- that skip them (e.g. no "model" on deterministic-gate short-circuits).
  -- Attacks the measured ~691 ms p50 non-model floor with data.
  add column if not exists stage_timings jsonb;

comment on column app.grading_results.normalized_response_sha256 is
  'SHA-256 of normalized response text (NFKC, lowercase, collapsed whitespace). Replay-rate telemetry; threshold to build replay: >~10% per-item duplicate rate on real traffic.';
comment on column app.grading_results.cached_tokens is
  'Provider-reported cached input tokens (summed across Arm A fan-out calls); null when not reported.';
comment on column app.grading_results.stage_timings is
  'Passive per-stage wall timings in ms: auth/db/deterministic/model/sanitize/total; stages absent when skipped.';
