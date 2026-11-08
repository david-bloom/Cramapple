// sample-try: the anonymous first MCQ of the paywall sample
// (docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md §3, §10.1).
//
// Public (anon key, verify_jwt=false). Every database effect is a
// service-role SQL function (app.sample_try_start / _answer / _status), so
// this layer only: checks the edge flag, rate-limits per IP-HMAC, validates
// input, hashes the browser token, and shapes typed responses. The answer key
// (mcq_choices.is_correct / rationale) only ever leaves the database inside
// the feedback the SQL returns after an answer is recorded.
//
// SAMPLE_ACCESS_ENABLED defaults off: every operation returns 503
// sample_disabled until both this env flag and app.config
// sample_access_enabled are true.

import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { trimmedNonEmptyString as asString } from "../_shared/input.ts";
import { clientIp } from "../_shared/request-metadata.ts";
import {
  checkPublicRateLimit,
  PUBLIC_ENDPOINT_LIMITS,
  rateLimitDeps,
  rateLimitedBody,
  type RateLimitResult,
} from "../_shared/public-rate-limit.ts";
import { sanitizeAdAttribution } from "../_shared/trial-contract.ts";

export const SAMPLE_TRY_OPERATIONS = ["list_units", "start", "answer", "status"] as const;
export type SampleTryOperation = typeof SAMPLE_TRY_OPERATIONS[number];

const TOKEN_PATTERN = /^[A-Za-z0-9_-]{32,128}$/;
const SUBJECT_KEY_PATTERN = /^[a-z0-9_-]{2,64}$/;
const CHOICE_KEY_PATTERN = /^[A-Za-z0-9]{1,8}$/;

export type SampleTryRpc = (
  fn: string,
  args: Record<string, unknown>,
) => PromiseLike<{ data: unknown; error: { message?: string; details?: string } | null }>;

export type SampleTryDeps = {
  enabled?: boolean;
  rpc?: SampleTryRpc;
  rateLimit?: (req: Request) => Promise<RateLimitResult>;
  hmacKey?: string;
  newToken?: () => string;
};

function envEnabled() {
  return (Deno.env.get("SAMPLE_ACCESS_ENABLED") ?? "false").toLowerCase() === "true";
}

export async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return Array.from(new Uint8Array(digest)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

async function hmacHex(key: string, value: string) {
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(key),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = await crypto.subtle.sign("HMAC", cryptoKey, new TextEncoder().encode(value));
  return Array.from(new Uint8Array(sig)).map((b) => b.toString(16).padStart(2, "0")).join("");
}

export function randomToken() {
  const bytes = new Uint8Array(32);
  crypto.getRandomValues(bytes);
  return btoa(String.fromCharCode(...bytes)).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

/** Maps the SQL layer's `sample_try:<code>` to a typed HTTP response. */
export function mapSqlError(error: { message?: string; details?: string } | null | undefined) {
  const code = error?.message?.match(/sample_try:([a-z_]+)/)?.[1] ?? null;
  const detail = (() => {
    if (!error?.details) return null;
    try {
      return JSON.parse(error.details);
    } catch {
      return null;
    }
  })();
  switch (code) {
    case "disabled":
      return { status: 503, body: { error: "sample_disabled" } };
    case "unknown_subject":
      return { status: 404, body: { error: "unknown_subject" } };
    case "unit_unavailable":
      return { status: 409, body: { error: "sample_unit_unavailable", units: detail ?? [] } };
    case "switch_limit_reached":
      return { status: 409, body: { error: "switch_limit_reached" } };
    case "not_found":
      return { status: 404, body: { error: "try_not_found" } };
    case "expired":
      return { status: 410, body: { error: "try_expired" } };
    case "already_answered":
      return { status: 409, body: { error: "already_answered", try: detail } };
    case "invalid_choice":
      return { status: 400, body: { error: "invalid_choice" } };
    case "invalid_token":
      return { status: 400, body: { error: "invalid_try_token" } };
    default:
      return { status: 500, body: { error: "sample_try_failed" } };
  }
}

export async function handleSampleTry(req: Request, deps: SampleTryDeps = {}): Promise<Response> {
  const respond = (body: unknown, init: ResponseInit = {}) => jsonResponse(body, init, req);
  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") return respond({ error: "method_not_allowed" }, { status: 405 });

  const enabled = deps.enabled ?? envEnabled();
  if (!enabled) return respond({ error: "sample_disabled" }, { status: 503 });

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const b = body as Record<string, unknown>;
  const operation = asString(b.operation) as SampleTryOperation | null;
  if (!operation || !SAMPLE_TRY_OPERATIONS.includes(operation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  // Lazily built so handler tests never touch the real client.
  let service: ReturnType<typeof createServiceClient> | null = null;
  const getService = () => (service ??= createServiceClient());
  const rpc: SampleTryRpc = deps.rpc ??
    ((fn, args) => getService().schema("app").rpc(fn, args));
  const limiter = deps.rateLimit ??
    ((r: Request) => checkPublicRateLimit(r, PUBLIC_ENDPOINT_LIMITS.sampleTry, rateLimitDeps(getService())));
  const hmacKey = deps.hmacKey ??
    (Deno.env.get("PUBLIC_RATE_LIMIT_HMAC_KEY") ?? Deno.env.get("BYOQ_IP_HMAC_KEY") ??
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SERVICE_ROLE_KEY") ?? "");

  if (operation !== "list_units") {
    const limit = await limiter(req);
    if (!limit.allowed) {
      const limited = rateLimitedBody(limit.retryAfterSeconds);
      return respond(limited.body, limited.init);
    }
  }

  const tryToken = asString(b.try_token);
  if (tryToken !== null && !TOKEN_PATTERN.test(tryToken)) {
    return respond({ error: "invalid_try_token" }, { status: 400 });
  }

  try {
    if (operation === "list_units") {
      const subjectKey = asString(b.subject_key);
      if (!subjectKey || !SUBJECT_KEY_PATTERN.test(subjectKey)) {
        return respond({ error: "missing_required_fields", required: ["subject_key"] }, { status: 400 });
      }
      const { data, error } = await rpc("sample_unit_availability", { p_subject_key: subjectKey });
      if (error) {
        const mapped = mapSqlError(error);
        return respond(mapped.body, { status: mapped.status });
      }
      return respond({
        status: "ok",
        operation,
        result: { subject_key: subjectKey, units: Array.isArray(data) ? data : [] },
      });
    }

    if (operation === "start") {
      const subjectKey = asString(b.subject_key);
      const unitNumber = Number(b.unit_number);
      if (!subjectKey || !SUBJECT_KEY_PATTERN.test(subjectKey) || !Number.isInteger(unitNumber) || unitNumber < 1) {
        return respond(
          { error: "missing_required_fields", required: ["subject_key", "unit_number"] },
          { status: 400 },
        );
      }
      const candidate = (deps.newToken ?? randomToken)();
      const ip = clientIp(req) ?? "no-ip";
      const { data, error } = await rpc("sample_try_start", {
        p_subject_key: subjectKey,
        p_unit_number: unitNumber,
        p_existing_token_hash: tryToken ? await sha256Hex(tryToken) : null,
        p_new_token_hash: await sha256Hex(candidate),
        p_ip_hmac: hmacKey ? await hmacHex(hmacKey, `sample-try:${ip}`) : null,
        p_attribution: sanitizeAdAttribution(b.ad_attribution) ?? {},
      });
      if (error) {
        const mapped = mapSqlError(error);
        return respond(mapped.body, { status: mapped.status });
      }
      const result = (data ?? {}) as Record<string, unknown>;
      const outcome = typeof result.outcome === "string" ? result.outcome : "unknown";
      if (outcome === "register_required") {
        return respond({ error: "register_required", try: result.try ?? null }, { status: 409 });
      }
      if (outcome === "claimed") {
        return respond({ error: "already_claimed", try: result.try ?? null }, { status: 409 });
      }
      return respond({
        status: "ok",
        operation,
        result: {
          outcome,
          // The plaintext token is issued exactly once, with the try it opens.
          try_token: result.issued_new_token === true ? candidate : null,
          try: result.try ?? null,
        },
      });
    }

    if (!tryToken) {
      return respond({ error: "missing_required_fields", required: ["try_token"] }, { status: 400 });
    }
    const tokenHash = await sha256Hex(tryToken);

    if (operation === "answer") {
      const choiceKey = asString(b.choice_key);
      if (!choiceKey || !CHOICE_KEY_PATTERN.test(choiceKey)) {
        return respond({ error: "missing_required_fields", required: ["choice_key"] }, { status: 400 });
      }
      const { data, error } = await rpc("sample_try_answer", { p_token_hash: tokenHash, p_choice_key: choiceKey });
      if (error) {
        const mapped = mapSqlError(error);
        return respond(mapped.body, { status: mapped.status });
      }
      const result = (data ?? {}) as Record<string, unknown>;
      return respond({
        status: "ok",
        operation,
        result: { outcome: result.outcome ?? "answered", try: result.try ?? null, register_to_save: true },
      });
    }

    // status
    const { data, error } = await rpc("sample_try_status", { p_token_hash: tokenHash });
    if (error) {
      const mapped = mapSqlError(error);
      return respond(mapped.body, { status: mapped.status });
    }
    return respond({ status: "ok", operation, result: { try: data ?? { status: "not_found" } } });
  } catch (error) {
    console.error("sample_try_failed", operation, error instanceof Error ? error.message : String(error));
    return respond({ error: "sample_try_failed" }, { status: 500 });
  }
}

if (import.meta.main) {
  Deno.serve((req) => handleSampleTry(req));
}
