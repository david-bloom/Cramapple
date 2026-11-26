import { requireEnv } from "../_shared/env.ts";

// Deployment configuration for evaluate-attempt. Read once at module load;
// a missing or invalid required value fails the function at boot (TASK-0079 S1:
// moved verbatim from index.ts).

function requirePositiveIntegerEnv(name: string) {
  const raw = requireEnv(name);
  const value = Number(raw);
  if (!Number.isInteger(value) || value <= 0) {
    throw new Error(`Invalid required environment variable: ${name}`);
  }
  return value;
}

function requirePositiveNumberEnv(name: string) {
  const raw = requireEnv(name);
  const value = Number(raw);
  if (!Number.isFinite(value) || value <= 0) {
    throw new Error(`Invalid required environment variable: ${name}`);
  }
  return value;
}

// Fail fast on deployment misconfiguration instead of grading with silent defaults.
export const OPENAI_API_KEY = requireEnv("OPENAI_API_KEY");
export const OPENAI_MODEL = requireEnv("OPENAI_MODEL");
export const OPENAI_MAX_OUTPUT_TOKENS = requirePositiveIntegerEnv(
  "OPENAI_MAX_OUTPUT_TOKENS",
);
export const OPENAI_INPUT_PRICE_PER_1M = requirePositiveNumberEnv(
  "OPENAI_INPUT_PRICE_PER_1M",
);
export const OPENAI_OUTPUT_PRICE_PER_1M = requirePositiveNumberEnv(
  "OPENAI_OUTPUT_PRICE_PER_1M",
);
export const OPENAI_DAILY_CAP_USD = requirePositiveNumberEnv("OPENAI_DAILY_CAP_USD");
export const EVALUATE_ATTEMPT_PROMPT_VERSION = requireEnv(
  "EVALUATE_ATTEMPT_PROMPT_VERSION",
);
// Entitlement gating (TASK-0026, 2026-08-15): set to true in Production.
// `authorize_grading_access` (20260731160200_free_score_check_growth_funnel.sql,
// simplified by 20260815140000_retire_free_score_check.sql) now only checks
// app.subject_entitlements -- the FSC one-FRQ-cap fallback it used to have was
// removed along with the retired Free Score Check offer. Every supported
// access path (beta/paid/7-day trial via app.start_trial) is a
// subject_entitlements row, so any caller without one gets a clean
// `entitlement_required` 403 instead of the old FSC branch logic.
//
// Kept as an env-gated const (not hardcoded true) so a bad rollout can be
// reverted with a secrets change instead of a redeploy -- see the 2026-07-28
// outage note in git history for why this flag exists at all.
export const GRADING_ENTITLEMENTS_ENABLED =
  (Deno.env.get("GRADING_ENTITLEMENTS_ENABLED") ?? "false").toLowerCase() ===
    "true";

// Request architecture for LLM text grading.
//
// "b" (default) is what Production runs today: ONE call grading every criterion
// of an item, measured at 0.58 s + 3.89 s x n_criteria, so ~16 s on a
// 4-criterion Biology FRQ. "a" grades each criterion in its own parallel call,
// which is flat in criterion count and should land near Production's own
// 1-criterion figure of ~4.5 s.
//
// Defaulting to "b" so the new path deploys dark. Arm A changes the request
// shape, the output schema, and the student-facing summary all at once, on a
// grader that had never completed a Production grading until 2026-07-28 --
// flipping it blind is how the entitlement-gate outage happened. Deploy, then
// flip the flag, then measure with the narrow pilot.
export const GRADING_ARM = (Deno.env.get("GRADING_ARM") ?? "b").toLowerCase() === "a"
  ? "a"
  : "b";

// Bumped 2026-07-28: three checker defects fixed (supplied inputs now win over
// the built-in `e`/`pi` constants; CORRECT_VIA_ECF requires a real upstream
// divergence; `erf`/`factorial` parse). Verdicts from this build are not
// comparable to 2026-07-08 ones, so the stamp recorded in
// grading_results.deterministic_verifier_version has to move with it.
// Bumped 2026-08-11 (O1 approved): the corrected APSTATS-SFRQ-008
// statistics key and the audited provenance annotations in
// _shared/statistics-verifier.ts ship with this build, so deterministic
// verdicts from the corrected keys are distinguishable from pre-fix ones in
// grading_results.deterministic_verifier_version. See
// docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md. This stamp covers
// the deterministic layer as a whole (both math-verifier.ts and
// statistics-verifier.ts share one version tag here), not math-verifier.ts
// alone -- the math-verifier itself is unchanged since 2026-07-28.
export const MATH_VERIFIER_VERSION = "stats-verifier-ts-2026-08-11";
// Course Mode F4: the generic data-driven deterministic verifier's schema
// version, stamped into grading_results.shadow-adjacent deterministic_check so a
// grade produced by reading persisted content_item_checks is auditable.
export const DATA_DRIVEN_VERIFIER_VERSION = "data-driven-deterministic-1.0";

// Timeout is configurable so we can tune for high-reasoning models without
// a code change. 90s accommodates reasoning: { effort: "high" } latency
// observed in pilot runs while still bounding requests so a hung connection
// can't tie up the function instance.
export const OPENAI_REQUEST_TIMEOUT_MS = (() => {
  const raw = Deno.env.get("OPENAI_REQUEST_TIMEOUT_MS");
  if (!raw) return 90_000;
  const parsed = Number(raw);
  if (!Number.isInteger(parsed) || parsed <= 0) {
    throw new Error("Invalid environment variable: OPENAI_REQUEST_TIMEOUT_MS");
  }
  return parsed;
})();
