// Request-handling tests for the capture-pairing endpoint.
//
// TASK-0016 Phase D Stage D2 QA finding 15: the original suite covered only the
// pure `_shared` helpers, so auth, operation routing, the storage-path guard,
// cross-user denial, and the single-use / quality / consume sequence -- the
// security-critical logic that actually lives in the handler -- had zero
// coverage. These tests drive `handleCapturePairing` directly with a synthetic
// Request and an in-memory fake of the service client and storage, so those
// paths are exercised for real. The fake RPCs mirror the SQL functions in
// 20260819120000_capture_pairing.sql closely enough to reproduce the state
// machine (claim / consume / record / bind / reserve+complete).

import "./_test_setup.ts";
import { assert, assertEquals } from "jsr:@std/assert@1";
import {
  generatePairingHandle,
  hashPairingHandle,
} from "../_shared/capture-pairing.ts";
import type { CaptureQualityOutcome } from "../_shared/capture-quality-check.ts";
import { handleCapturePairing } from "./index.ts";

/* -------------------------------------------------------------------------- */
/* Fixtures                                                                    */
/* -------------------------------------------------------------------------- */

// A real 3x2 PNG padded past the 1024-byte capture floor (same fixture the
// capture-attachment tests use) -- validateCaptureObject accepts it.
const PNG_3X2 = Uint8Array.from(
  atob(
    "iVBORw0KGgoAAAANSUhEUgAAAAMAAAACCAIAAAASFvFNAAAAD0lEQVR4nGNg4BKBIjgLAAakALXcLc54AAAAAElFTkSuQmCC" +
      "A".repeat(1400),
  ),
  (c) => c.charCodeAt(0),
);

function assessed(
  disposition: "ACCEPT" | "RETAKE" | "HUMAN_REVIEW",
): CaptureQualityOutcome {
  const state = disposition === "ACCEPT"
    ? "acceptable"
    : disposition === "RETAKE"
    ? "retake_required"
    : "indeterminate";
  return {
    kind: "assessed",
    disposition,
    captureQualityState: state,
    failingLabels: disposition === "RETAKE" ? ["FOCUS_LEGIBILITY"] : [],
    labels: {
      PAGE_COMPLETE: "PASS",
      GRAPH_REGION_COMPLETE: "PASS",
      FOCUS_LEGIBILITY: disposition === "RETAKE" ? "FAIL" : "PASS",
      GLARE_OCCLUSION: "PASS",
      PERSPECTIVE_READABILITY: "PASS",
      RESOLUTION_READABILITY: "PASS",
      ORIENTATION_USABLE: "PASS",
    },
    incidentalIdentifier: "NONE",
    modelId: "gpt-4o-mini",
    latencyMs: 5,
  };
}
const TECHNICAL: CaptureQualityOutcome = {
  kind: "technical_failure",
  failure: "timeout",
  detail: "capture_quality_timeout",
  modelId: "gpt-4o-mini",
  latencyMs: 5,
};

/* -------------------------------------------------------------------------- */
/* In-memory database + storage fake                                           */
/* -------------------------------------------------------------------------- */

// deno-lint-ignore no-explicit-any
type Row = Record<string, any>;

class FakeDb {
  capture_pairing_tokens: Row[] = [];
  attempts: Row[] = [];
  response_versions: Row[] = [];
  response_attachments: Row[] = [];
  capture_pairing_events: Row[] = [];
  audit_events: Row[] = [];
  ledger: Row[] = [];
  budgets: Row[] = [];
  storage = new Map<string, Uint8Array>();
  uploadShouldFail = false;
  // Simulates a failed response_attachments.capture_quality_state annotation
  // write, to prove keepOpen no longer depends on it (N2).
  updateAttachmentShouldFail = false;
  // Simulates a storage sign-upload failure, to test the technical-failure
  // classification persisting to the token (N6).
  signUploadShouldFail = false;

  table(name: string): Row[] {
    // deno-lint-ignore no-explicit-any
    return (this as any)[name];
  }
}

// deno-lint-ignore no-explicit-any
function matches(row: Row, eqs: Row, inn: Record<string, any[]>, gte: Row) {
  for (const [k, v] of Object.entries(eqs)) if (row[k] !== v) return false;
  for (const [k, vals] of Object.entries(inn)) if (!vals.includes(row[k])) return false;
  for (const [k, v] of Object.entries(gte)) if (!(row[k] >= v)) return false;
  return true;
}

class QueryBuilder {
  eqs: Row = {};
  // deno-lint-ignore no-explicit-any
  inn: Record<string, any[]> = {};
  gtes: Row = {};
  // deno-lint-ignore no-explicit-any
  op: { kind: "select" | "insert" | "update"; rows?: any; vals?: any } = {
    kind: "select",
  };
  countHead = false;
  constructor(private db: FakeDb, private name: string) {}

  // deno-lint-ignore no-explicit-any
  select(_cols?: string, opts?: any) {
    if (opts?.count) this.countHead = true;
    return this;
  }
  // deno-lint-ignore no-explicit-any
  insert(rows: any) {
    this.op = { kind: "insert", rows };
    return this;
  }
  // deno-lint-ignore no-explicit-any
  update(vals: any) {
    this.op = { kind: "update", vals };
    return this;
  }
  eq(k: string, v: unknown) {
    this.eqs[k] = v;
    return this;
  }
  in(k: string, v: unknown[]) {
    this.inn[k] = v;
    return this;
  }
  gte(k: string, v: unknown) {
    this.gtes[k] = v;
    return this;
  }

  private applyDefaults(row: Row): Row {
    if (this.name === "capture_pairing_tokens") {
      return {
        id: crypto.randomUUID(),
        generation: 1,
        state: "issued",
        redemption_attempts: 0,
        access_path: null,
        upload_storage_path: null,
        bound_attachment_id: null,
        capture_quality_state: null,
        failure_class: null,
        created_at: new Date().toISOString(),
        ...row,
      };
    }
    return { ...row };
  }

  private constraintError(row: Row): string | null {
    if (this.name === "audit_events") {
      const dup = this.db.audit_events.find(
        (r) =>
          r.request_id != null && r.reason_code != null &&
          r.request_id === row.request_id && r.reason_code === row.reason_code,
      );
      if (dup) return "duplicate key value violates unique constraint audit_events_request_id_reason_code_unique";
    }
    if (this.name === "capture_pairing_events") {
      const dup = this.db.capture_pairing_events.find(
        (r) => r.pairing_id === row.pairing_id && r.sequence === row.sequence,
      );
      if (dup) return "duplicate key value violates unique constraint capture_pairing_events_sequence_unique";
    }
    return null;
  }

  private run(): { rows: Row[]; error: { message: string } | null } {
    const table = this.db.table(this.name);
    if (this.op.kind === "insert") {
      const inputs = Array.isArray(this.op.rows) ? this.op.rows : [this.op.rows];
      const inserted: Row[] = [];
      for (const raw of inputs) {
        const row = this.applyDefaults(raw);
        const err = this.constraintError(row);
        if (err) return { rows: [], error: { message: err } };
        table.push(row);
        inserted.push(row);
      }
      return { rows: inserted, error: null };
    }
    const matched = table.filter((r) => matches(r, this.eqs, this.inn, this.gtes));
    if (this.op.kind === "update") {
      if (this.name === "response_attachments" && this.db.updateAttachmentShouldFail) {
        return { rows: [], error: { message: "update_failed" } };
      }
      for (const r of matched) Object.assign(r, this.op.vals);
    }
    return { rows: matched, error: null };
  }

  maybeSingle() {
    const { rows, error } = this.run();
    return Promise.resolve({ data: error ? null : (rows[0] ?? null), error });
  }
  single() {
    return this.maybeSingle();
  }
  // Thenable: awaiting the builder without a *Single terminal (count reads and
  // update().select() list reads).
  // deno-lint-ignore no-explicit-any
  then(resolve: (v: any) => void) {
    const { rows, error } = this.run();
    resolve(this.countHead ? { count: rows.length, error } : { data: rows, error });
  }
}

function makeService(
  db: FakeDb,
  hooks: { afterBind?: () => void; beforeBind?: () => void } = {},
) {
  const rpc = (name: string, p: Row) => {
    // Lets a test simulate a concurrent write landing between the edge
    // function's writability check and the bind itself (the N7 race).
    if (
      name === "bind_response_attachment" && p.p_kind === "original" &&
      hooks.beforeBind
    ) {
      hooks.beforeBind();
    }
    const result = runRpc(db, name, p);
    // Lets a test simulate a concurrent write landing right after the bind but
    // before the finalize CAS (e.g. a desktop "Cancel pairing").
    if (
      name === "bind_response_attachment" && p.p_kind === "original" &&
      !result.error && hooks.afterBind
    ) {
      hooks.afterBind();
    }
    return {
      single: () => Promise.resolve(result),
      // deno-lint-ignore no-explicit-any
      then: (resolve: (v: any) => void) => resolve(result),
    };
  };
  const schema = () => ({
    from: (name: string) => new QueryBuilder(db, name),
    rpc,
  });
  const storage = {
    from: (_bucket: string) => ({
      download: (path: string) =>
        Promise.resolve(
          db.storage.has(path)
            ? {
              data: {
                arrayBuffer: () =>
                  Promise.resolve(db.storage.get(path)!.buffer),
              },
              error: null,
            }
            : { data: null, error: { message: "not_found" } },
        ),
      list: (folder: string, opts: { search?: string }) => {
        const path = `${folder}/${opts.search}`;
        const bytes = db.storage.get(path);
        return Promise.resolve({
          data: bytes
            ? [{
              name: opts.search,
              updated_at: "2026-08-20T00:00:00.000Z",
              metadata: { eTag: "etag-1", size: bytes.length },
            }]
            : [],
          error: null,
        });
      },
      createSignedUploadUrl: (path: string) =>
        Promise.resolve(
          db.signUploadShouldFail
            ? { data: null, error: { message: "sign_failed" } }
            : {
              data: {
                signedUrl: `https://storage/${path}`,
                token: "upload-token",
              },
              error: null,
            },
        ),
      createSignedUrl: (path: string) =>
        Promise.resolve({
          data: { signedUrl: `https://storage/${path}` },
          error: null,
        }),
      upload: (path: string, bytes: Uint8Array) => {
        if (db.uploadShouldFail) {
          return Promise.resolve({ error: { message: "upload_failed" } });
        }
        db.storage.set(path, bytes);
        return Promise.resolve({ error: null });
      },
    }),
  };
  // deno-lint-ignore no-explicit-any
  return { schema, storage } as any;
}

function err(reason: string) {
  return { data: null, error: { message: reason } };
}

function runRpc(db: FakeDb, name: string, p: Row) {
  switch (name) {
    case "claim_capture_pairing_upload": {
      const row = db.capture_pairing_tokens.find((t) => t.handle_sha256 === p.p_handle_sha256);
      if (!row) return err("capture_pairing:not_found");
      if (row.state === "consumed") return err("capture_pairing:already_used");
      if (row.state === "cancelled") return err("capture_pairing:cancelled");
      if (row.state === "rejected") return err("capture_pairing:rejected");
      if (row.state === "expired") return err("capture_pairing:expired");
      if (new Date(row.expires_at).getTime() <= Date.now()) {
        row.state = "expired";
        row.closed_at = new Date().toISOString();
        return { data: { ...row }, error: null };
      }
      if (row.redemption_attempts >= p.p_max_attempts) {
        row.state = "rejected";
        row.closed_at = new Date().toISOString();
        return { data: { ...row }, error: null };
      }
      row.redemption_attempts += 1;
      if (row.state === "issued") row.state = "paired";
      row.paired_at = row.paired_at ?? new Date().toISOString();
      row.access_path = row.access_path ?? p.p_access_path;
      return { data: { ...row }, error: null };
    }
    case "consume_capture_pairing":
    case "record_capture_upload": {
      const row = db.capture_pairing_tokens.find((t) =>
        t.id === p.p_pairing_id && ["paired", "uploaded"].includes(t.state)
      );
      if (!row) return err("capture_pairing:not_consumable");
      row.state = name === "consume_capture_pairing" ? "consumed" : "uploaded";
      row.uploaded_at = row.uploaded_at ?? new Date().toISOString();
      if (name === "consume_capture_pairing") row.consumed_at = new Date().toISOString();
      row.bound_attachment_id = p.p_attachment_id;
      row.capture_quality_state = p.p_capture_quality_state;
      row.failure_class = p.p_failure_class;
      row.upload_storage_path = p.p_storage_path;
      return { data: { ...row }, error: null };
    }
    case "bind_response_attachment": {
      // N7: mirror the DB-level writability guard (20260819120100) so the fake
      // can actually exercise it. A submitted response version or a
      // non-editable attempt refuses the bind.
      //
      // KNOWN LIMIT (Round-4 QA B1): this fake has no locking model, so it
      // cannot reproduce lock ORDER and did not catch B1's deadlock. It mirrors
      // the guard's decision logic only. Lock ordering is verified against the
      // real planner via EXPLAIN, not here.
      const rv = db.response_versions.find((r) =>
        r.id === p.p_response_version_id
      );
      const at = rv && db.attempts.find((a) => a.id === rv.attempt_id);
      if (!rv || !at) return err("attach_capture:response_not_found");
      if (rv.is_submitted || !["draft", "failed"].includes(at.status)) {
        return err("attach_capture:response_not_writable");
      }
      if (p.p_kind === "derived") {
        const id = crypto.randomUUID();
        db.response_attachments.push({
          id,
          response_version_id: p.p_response_version_id,
          kind: "derived",
          is_current: true,
          storage_path: p.p_storage_path,
          capture_quality_state: "pending",
        });
        return { data: { id }, error: null };
      }
      const prior = db.response_attachments.find((a) =>
        a.response_version_id === p.p_response_version_id &&
        a.kind === "original" && a.is_current
      );
      if (p.p_replaces_attachment_id) {
        if (!prior) return err("attach_capture:no_current_original_to_replace");
        if (prior.id !== p.p_replaces_attachment_id) {
          return err("attach_capture:stale_retake_target");
        }
        prior.is_current = false;
      } else if (prior) {
        return err("attach_capture:original_already_current");
      }
      const id = crypto.randomUUID();
      db.response_attachments.push({
        id,
        response_version_id: p.p_response_version_id,
        kind: "original",
        is_current: true,
        storage_path: p.p_storage_path,
        capture_quality_state: "pending",
      });
      return { data: { id, capture_quality_state: "pending" }, error: null };
    }
    case "reserve_model_usage": {
      const existing = db.ledger.find((l) => l.request_id === p.p_request_id);
      if (existing) return { data: { ...existing }, error: null };
      const today = "2026-08-20";
      let budget = db.budgets.find((b) => b.usage_date_utc === today);
      if (!budget) {
        budget = { usage_date_utc: today, cap_usd: p.p_cap_usd, reserved_cost_usd: 0, actual_cost_usd: 0 };
        db.budgets.push(budget);
      }
      if (budget.reserved_cost_usd + budget.actual_cost_usd + p.p_reserved_cost_usd > p.p_cap_usd) {
        return err("daily cap exceeded");
      }
      budget.reserved_cost_usd += p.p_reserved_cost_usd;
      const row = {
        request_id: p.p_request_id,
        request_hash: p.p_request_hash,
        usage_date_utc: today,
        reserved_cost_usd: p.p_reserved_cost_usd,
        status: "reserved",
      };
      db.ledger.push(row);
      return { data: { ...row }, error: null };
    }
    case "complete_model_usage": {
      const row = db.ledger.find((l) => l.request_id === p.p_request_id);
      if (!row) return err("usage request not found");
      const budget = db.budgets.find((b) => b.usage_date_utc === row.usage_date_utc);
      if (budget) {
        budget.reserved_cost_usd = Math.max(0, budget.reserved_cost_usd - row.reserved_cost_usd);
        budget.actual_cost_usd += p.p_actual_cost_usd ?? 0;
      }
      row.status = p.p_status;
      return { data: { ...row }, error: null };
    }
    case "append_capture_pairing_event": {
      // Model the REAL row-locked max(sequence)+1 the SQL function uses, not a
      // count(*)+1 (the pre-fix formula F11 replaced). These differ whenever the
      // sequence set has a gap, so a regression to count-based logic is now
      // catchable (see the F11 gap test).
      const seq = db.capture_pairing_events
        .filter((e) => e.pairing_id === p.p_pairing_id)
        .reduce((m, e) => Math.max(m, e.sequence), 0) + 1;
      db.capture_pairing_events.push({
        event_id: p.p_event_id,
        pairing_id: p.p_pairing_id,
        sequence: seq,
        event_type: p.p_event_type,
        actor: p.p_actor,
        occurred_at: p.p_occurred_at,
        // Mirrors the SQL's jsonb_set: the real sequence is patched into the
        // stored record so column and JSON never disagree.
        event: { ...p.p_event, sequence: seq },
      });
      return { data: seq, error: null };
    }
    default:
      return err(`unknown_rpc:${name}`);
  }
}

/* -------------------------------------------------------------------------- */
/* Scenario builders + request helpers                                         */
/* -------------------------------------------------------------------------- */

interface Scenario {
  db: FakeDb;
  userId: string;
  attemptId: string;
  responseVersionId: string;
  contentItemVersionId: string;
  handle: string;
  pairingId: string;
  storagePath: string;
}

async function seedPairedCapability(
  db: FakeDb,
  opts: { attemptUserMismatch?: boolean; slot?: string } = {},
): Promise<Scenario> {
  const slot = opts.slot ?? "slot-1";
  const userId = crypto.randomUUID();
  const attemptId = crypto.randomUUID();
  const responseVersionId = crypto.randomUUID();
  const contentItemVersionId = crypto.randomUUID();
  const pairingId = crypto.randomUUID();
  const handle = generatePairingHandle();
  const handleSha256 = await hashPairingHandle(handle);

  db.attempts.push({
    id: attemptId,
    // A cross-user hazard: the attempt is owned by someone other than the
    // capability's user_id.
    user_id: opts.attemptUserMismatch ? crypto.randomUUID() : userId,
    status: "draft",
    content_item_version_id: contentItemVersionId,
    learning_session_id: null,
  });
  db.response_versions.push({
    id: responseVersionId,
    attempt_id: attemptId,
    is_submitted: false,
  });
  db.capture_pairing_tokens.push({
    id: pairingId,
    handle_sha256: handleSha256,
    upload_purpose: "DRAWN_RESPONSE",
    user_id: userId,
    learning_session_id: null,
    attempt_id: attemptId,
    response_version_id: responseVersionId,
    content_item_version_id: contentItemVersionId,
    submission_slot_id: slot,
    generation: 1,
    state: "paired",
    access_path: "QR",
    expires_at: new Date(Date.now() + 10 * 60 * 1000).toISOString(),
    redemption_attempts: 1,
    upload_storage_path: null,
    bound_attachment_id: null,
    capture_quality_state: null,
    failure_class: null,
    created_at: new Date().toISOString(),
  });
  const storagePath = `${userId}/captures/${pairingId}/original-1.png`;
  db.storage.set(storagePath, PNG_3X2);
  return {
    db,
    userId,
    attemptId,
    responseVersionId,
    contentItemVersionId,
    handle,
    pairingId,
    storagePath,
  };
}

function post(body: unknown) {
  return new Request("https://edge/capture-pairing", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

function fakeAuth(user: { id: string }, role = "student") {
  const result = { user, profile: { user_id: user.id, role } };
  // deno-lint-ignore no-explicit-any
  return (_req: Request) => Promise.resolve(result as any);
}

// Mimics runCaptureQualityCheck's real contract: it takes a reservation via the
// caller's reserveCost() and only "runs" (returns an assessed/technical
// outcome) if the reservation succeeds. That is what lets the reserve+complete
// budget path be exercised for real while the model call itself stays stubbed.
function qualityStub(outcome: CaptureQualityOutcome) {
  let calls = 0;
  // deno-lint-ignore no-explicit-any
  const fn = (async (input: any) => {
    calls += 1;
    const reserved = await input.reserveCost();
    if (!reserved) {
      return { kind: "unavailable", failure: "cost_cap_reached" };
    }
    return outcome;
  }) as typeof import("../_shared/capture-quality-check.ts").runCaptureQualityCheck;
  return { fn, calls: () => calls };
}

// The metering env is configured once at import (see _test_setup.ts) because
// index.ts reads it into module-level consts at load. This wrapper is kept as a
// readable marker at the call sites that depend on a live cap.
async function withCap<T>(fn: () => T | Promise<T>): Promise<T> {
  return await fn();
}

/* -------------------------------------------------------------------------- */
/* Routing + validation                                                        */
/* -------------------------------------------------------------------------- */

Deno.test("rejects non-POST methods", async () => {
  const res = await handleCapturePairing(
    new Request("https://edge/capture-pairing", { method: "GET" }),
    { service: makeService(new FakeDb()) },
  );
  assertEquals(res.status, 405);
});

Deno.test("rejects an unknown operation", async () => {
  const res = await handleCapturePairing(post({ operation: "nope" }), {
    service: makeService(new FakeDb()),
  });
  assertEquals(res.status, 400);
  assertEquals((await res.json()).error, "invalid_operation");
});

Deno.test("token op rejects a malformed pairing handle", async () => {
  const res = await handleCapturePairing(
    post({ operation: "submit_capture", pairing_handle: "not-a-handle" }),
    { service: makeService(new FakeDb()) },
  );
  assertEquals(res.status, 400);
  assertEquals((await res.json()).error, "invalid_pairing_handle");
});

/* -------------------------------------------------------------------------- */
/* Authenticated leg                                                            */
/* -------------------------------------------------------------------------- */

Deno.test("mint_pairing requires authentication", async () => {
  const res = await handleCapturePairing(
    post({ operation: "mint_pairing" }),
    { service: makeService(new FakeDb()), requireProfile: () => Promise.resolve(null) },
  );
  assertEquals(res.status, 401);
});

Deno.test("mint_pairing refuses a role that is neither student nor admin", async () => {
  const res = await handleCapturePairing(
    post({ operation: "mint_pairing" }),
    {
      service: makeService(new FakeDb()),
      requireProfile: fakeAuth({ id: crypto.randomUUID() }, "reviewer"),
    },
  );
  assertEquals(res.status, 403);
});

Deno.test("mint_pairing refuses minting against another student's attempt", async () => {
  const db = new FakeDb();
  const ownerId = crypto.randomUUID();
  const attackerId = crypto.randomUUID();
  const attemptId = crypto.randomUUID();
  db.attempts.push({
    id: attemptId,
    user_id: ownerId,
    status: "draft",
    content_item_version_id: crypto.randomUUID(),
    learning_session_id: null,
  });
  db.response_versions.push({
    id: crypto.randomUUID(),
    attempt_id: attemptId,
    is_submitted: false,
  });
  const rvId = db.response_versions[0].id;
  const res = await handleCapturePairing(
    post({
      operation: "mint_pairing",
      attempt_id: attemptId,
      response_version_id: rvId,
    }),
    { service: makeService(db), requireProfile: fakeAuth({ id: attackerId }) },
  );
  assertEquals(res.status, 403);
});

Deno.test("mint_pairing returns the capability exactly once", async () => {
  const db = new FakeDb();
  const userId = crypto.randomUUID();
  const attemptId = crypto.randomUUID();
  db.attempts.push({
    id: attemptId,
    user_id: userId,
    status: "draft",
    content_item_version_id: crypto.randomUUID(),
    learning_session_id: null,
  });
  db.response_versions.push({
    id: crypto.randomUUID(),
    attempt_id: attemptId,
    is_submitted: false,
  });
  const rvId = db.response_versions[0].id;
  const res = await handleCapturePairing(
    post({
      operation: "mint_pairing",
      attempt_id: attemptId,
      response_version_id: rvId,
    }),
    { service: makeService(db), requireProfile: fakeAuth({ id: userId }) },
  );
  assertEquals(res.status, 200);
  const body = await res.json();
  assert(body.result.pairing_handle.startsWith("cap_"));
  // The stored row keeps only the hash, never the capability.
  assertEquals(db.capture_pairing_tokens.length, 1);
  assert(!("pairing_handle" in db.capture_pairing_tokens[0]));
  assert(db.capture_pairing_tokens[0].handle_sha256.length === 64);
});

/* -------------------------------------------------------------------------- */
/* submit_capture -- storage-path guard + cross-user denial                    */
/* -------------------------------------------------------------------------- */

Deno.test("submit_capture rejects a storage path outside the capability folder", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const evil = `${s.userId}/captures/${crypto.randomUUID()}/original-1.png`;
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: evil,
      explicit_confirmation: true,
    }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 400);
  assertEquals((await res.json()).error, "invalid_storage_path");
});

Deno.test("submit_capture denies a capability whose attempt is owned by another user", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db, { attemptUserMismatch: true });
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 403);
  assertEquals((await res.json()).error, "forbidden");
});

Deno.test("submit_capture refuses an unconfirmed submit", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
    }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 400);
  assertEquals((await res.json()).error, "explicit_confirmation_required");
});

/* -------------------------------------------------------------------------- */
/* Finding 1 -- a blurry-photo retake does NOT dead-end                        */
/* -------------------------------------------------------------------------- */

Deno.test("finding 1: a quality-rejected submit keeps the capability open for retake", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("RETAKE")).fn },
  );
  assertEquals(res.status, 200);
  const body = await res.json();
  assertEquals(body.result.failure_class, "image_quality");
  // The photo is preserved AND the capability is NOT consumed.
  const token = db.capture_pairing_tokens[0];
  assertEquals(token.state, "uploaded");
  assert(token.bound_attachment_id, "attachment was bound");

  // The retake path (a fresh create_capture_upload) must still succeed rather
  // than hit "link already used" -- the exact dead end DECISION-0051 forbids.
  const claim = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(claim.status, 200);
  assertEquals(db.capture_pairing_tokens[0].redemption_attempts, 2);
});

Deno.test("finding 1: an accepted submit consumes the capability (single use)", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  assertEquals(res.status, 200);
  assertEquals((await res.json()).result.failure_class, null);
  assertEquals(db.capture_pairing_tokens[0].state, "consumed");
  // A second create_capture_upload on a consumed capability is refused.
  const claim = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(claim.status, 409);
  assertEquals((await claim.json()).error, "pairing_already_used");
});

/* -------------------------------------------------------------------------- */
/* Finding 3/4 -- budget release + no paid call on a pre-bind failure          */
/* -------------------------------------------------------------------------- */

Deno.test("finding 3: the quality reservation is released (complete_model_usage) after a submit", async () => {
  await withCap(async () => {
    const db = new FakeDb();
    const s = await seedPairedCapability(db);
    const res = await handleCapturePairing(
      post({
        operation: "submit_capture",
        pairing_handle: s.handle,
        storage_path: s.storagePath,
        explicit_confirmation: true,
      }),
      { service: makeService(db), runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
    );
    assertEquals(res.status, 200);
    // A ledger row exists and was completed, and the shared daily budget's
    // reserved balance was returned to zero -- not left leaking.
    assertEquals(db.ledger.length, 1);
    assertEquals(db.ledger[0].status, "completed");
    assertEquals(db.budgets[0].reserved_cost_usd, 0);
  });
});

Deno.test("finding 4: a pre-bind failure fires no paid model call", async () => {
  await withCap(async () => {
    const db = new FakeDb();
    const s = await seedPairedCapability(db);
    // Seed a *different* current original so the auto-resolved supersede target
    // is a real id, then submit naming a bogus replaces_attachment_id: the
    // lineage check throws BEFORE the (now post-bind) quality call.
    const stub = qualityStub(assessed("ACCEPT"));
    const res = await handleCapturePairing(
      post({
        operation: "submit_capture",
        pairing_handle: s.handle,
        storage_path: s.storagePath,
        explicit_confirmation: true,
        replaces_attachment_id: crypto.randomUUID(),
      }),
      { service: makeService(db), runQualityCheck: stub.fn },
    );
    assertEquals(res.status, 409);
    // The paid quality check never ran, and no reservation was taken.
    assertEquals(stub.calls(), 0);
    assertEquals(db.ledger.length, 0);
    // The capability was not consumed by a failed attempt.
    assertEquals(db.capture_pairing_tokens[0].state, "paired");
  });
});

/* -------------------------------------------------------------------------- */
/* Finding 5 -- audit logging cannot be dropped or suppressed                  */
/* -------------------------------------------------------------------------- */

Deno.test("finding 5: a technical failure returns a REAL incident id, not a fabricated one", async () => {
  await withCap(async () => {
    const db = new FakeDb();
    const s = await seedPairedCapability(db);
    const res = await handleCapturePairing(
      post({
        operation: "submit_capture",
        pairing_handle: s.handle,
        storage_path: s.storagePath,
        explicit_confirmation: true,
      }),
      { service: makeService(db), runQualityCheck: qualityStub(TECHNICAL).fn },
    );
    const body = await res.json();
    assertEquals(body.result.failure_class, "technical");
    const incidentId = body.result.incident_id;
    assert(incidentId, "an incident id is returned");
    // It points at a row that actually exists.
    assert(
      db.audit_events.some((r) => r.audit_event_id === incidentId),
      "the incident id references a persisted audit row",
    );
    // ...and the audit row's request_id is server-generated, NOT the caller's
    // idempotency key -- so the unauthenticated phone cannot pin a key to
    // pre-collide and suppress its own error logs.
    const row = db.audit_events.find((r) => r.audit_event_id === incidentId)!;
    assertEquals(row.metadata.correlation_id !== row.request_id, true);
  });
});

Deno.test("finding 5: two technical failures with the same client idempotency key are both logged", async () => {
  await withCap(async () => {
    const db = new FakeDb();
    const a = await seedPairedCapability(db);
    const b = await seedPairedCapability(db);
    const key = "attacker-pinned-key";
    for (const s of [a, b]) {
      await handleCapturePairing(
        post({
          operation: "submit_capture",
          pairing_handle: s.handle,
          storage_path: s.storagePath,
          explicit_confirmation: true,
          idempotency_key: key,
        }),
        { service: makeService(db), runQualityCheck: qualityStub(TECHNICAL).fn },
      );
    }
    // Both technical failures are persisted -- the shared UNIQUE(request_id,
    // reason_code) index no longer silently drops the second one.
    const technical = db.audit_events.filter((r) =>
      r.reason_code === "technical_failure"
    );
    assertEquals(technical.length, 2);
  });
});

/* -------------------------------------------------------------------------- */
/* Finding 8 -- the failure split reaches the primary device                   */
/* -------------------------------------------------------------------------- */

Deno.test("finding 8: pairing_status surfaces failure_class so the desktop can tell technical from image-quality", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  // Drive a technical failure so the token records failure_class 'technical'.
  await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(TECHNICAL).fn },
  );
  const res = await handleCapturePairing(
    post({ operation: "pairing_status", pairing_id: s.pairingId }),
    { service: makeService(db), requireProfile: fakeAuth({ id: s.userId }) },
  );
  assertEquals(res.status, 200);
  const view = (await res.json()).result.pairing;
  assertEquals(view.capture_quality_state, "indeterminate");
  assertEquals(view.failure_class, "technical");
});

/* -------------------------------------------------------------------------- */
/* Finding 14 -- "phone connected" is detected when the phone opens the page   */
/* -------------------------------------------------------------------------- */

Deno.test("finding 14: describe_capture advances issued -> paired so the desktop sees the phone connect", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  // Put it back to the pre-connection state.
  db.capture_pairing_tokens[0].state = "issued";
  const res = await handleCapturePairing(
    post({ operation: "describe_capture", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 200);
  assertEquals((await res.json()).result.pairing.state, "paired");
  assertEquals(db.capture_pairing_tokens[0].state, "paired");
  // The connection is recorded once in provenance.
  const accepted = db.capture_pairing_events.filter((e) =>
    e.event_type === "PAIRING_ACCEPTED"
  );
  assertEquals(accepted.length, 1);
});

Deno.test("finding 14: a phone page reload while already paired does not re-emit or consume", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db); // already 'paired'
  await handleCapturePairing(
    post({ operation: "describe_capture", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(db.capture_pairing_tokens[0].state, "paired");
  assertEquals(db.capture_pairing_tokens[0].redemption_attempts, 1); // unchanged
  assertEquals(
    db.capture_pairing_events.filter((e) => e.event_type === "PAIRING_ACCEPTED")
      .length,
    0,
  );
});

/* -------------------------------------------------------------------------- */
/* Finding 12 -- multi-slot supersede is fail-closed                           */
/* -------------------------------------------------------------------------- */

Deno.test("finding 12: a non-default slot with a prior original refuses to auto-supersede", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db, { slot: "slot-2" });
  // A current original already exists on this response version.
  db.response_attachments.push({
    id: crypto.randomUUID(),
    response_version_id: s.responseVersionId,
    kind: "original",
    is_current: true,
    storage_path: "prior",
    capture_quality_state: "acceptable",
  });
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  assertEquals(res.status, 409);
  assertEquals(
    (await res.json()).error,
    "attach_capture_ambiguous_supersede_target",
  );
});

/* -------------------------------------------------------------------------- */
/* Finding 13 -- a cancel racing the finalize is accurate, not a 500           */
/* -------------------------------------------------------------------------- */

Deno.test("finding 13: a cancel landing between bind and finalize returns the accurate reason", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const service = makeService(db, {
    afterBind: () => {
      // The desktop "Cancel pairing" lands after the bind, before finalize.
      const token = db.capture_pairing_tokens[0];
      token.state = "cancelled";
      token.closed_at = new Date().toISOString();
    },
  });
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service, runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  assertEquals(res.status, 409);
  // Accurate cause, not a blanket "already used" and not an unmapped 500.
  assertEquals((await res.json()).error, "pairing_cancelled");
  // The bound original is left in place (self-healing: superseded next capture,
  // gated by is_submitted), and the race is audited.
  assert(
    db.response_attachments.some((a) =>
      a.kind === "original" && a.is_current === true
    ),
  );
  assert(db.audit_events.some((r) => r.reason_code === "finalize_lost_race"));
});

/* -------------------------------------------------------------------------- */
/* Finding 11 -- provenance sequences are assigned without gaps or collisions  */
/* -------------------------------------------------------------------------- */

Deno.test("finding 11: provenance events get unique, gap-free sequences across a full flow", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  db.capture_pairing_tokens[0].state = "issued";
  await handleCapturePairing(
    post({ operation: "describe_capture", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  const seqs = db.capture_pairing_events
    .filter((e) => e.pairing_id === s.pairingId)
    .map((e) => e.sequence)
    .sort((a, b) => a - b);
  assert(seqs.length >= 2, "several events were recorded");
  // Contiguous 1..N with no duplicates -- the atomic assignment leaves no gaps.
  assertEquals(seqs, seqs.map((_, i) => i + 1));
  // And the sequence stamped into the stored record matches its column.
  for (const e of db.capture_pairing_events) {
    assertEquals(e.event.sequence, e.sequence);
  }
});

/* -------------------------------------------------------------------------- */
/* Rework pass 2 (Round-3 QA): N1, N2, N6, N7, F6 branches, idempotency, F11    */
/* -------------------------------------------------------------------------- */

async function claimUploadPath(db: FakeDb, handle: string): Promise<string> {
  const res = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: handle }),
    { service: makeService(db) },
  );
  if (res.status !== 200) throw new Error(`claim failed: ${res.status}`);
  return (await res.json()).result.storage_path as string;
}

Deno.test("N1: all five retakes upload AND submit; only the sixth claim is refused", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  // Reset to a fresh, phone-connected capability with no attempts spent.
  db.capture_pairing_tokens[0].redemption_attempts = 0;
  for (let n = 1; n <= 5; n++) {
    const path = await claimUploadPath(db, s.handle);
    db.storage.set(path, PNG_3X2);
    assertEquals(db.capture_pairing_tokens[0].redemption_attempts, n);
    const submit = await handleCapturePairing(
      post({
        operation: "submit_capture",
        pairing_handle: s.handle,
        storage_path: path,
        explicit_confirmation: true,
      }),
      { service: makeService(db), runQualityCheck: qualityStub(assessed("RETAKE")).fn },
    );
    // The 5th submit must NOT 409 — that was the off-by-one (N1).
    assertEquals(submit.status, 200, `submit for attempt ${n} should succeed`);
    assertEquals((await submit.json()).result.failure_class, "image_quality");
  }
  // The 6th upload URL is refused at claim time (before any bytes upload).
  const sixth = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(sixth.status, 409);
  assertEquals((await sixth.json()).error, "pairing_attempts_exhausted");
  assertEquals(db.capture_pairing_tokens[0].state, "rejected");
});

Deno.test("F6: create_capture_upload on a just-expired token commits 'expired' and 409s (not raised)", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  db.capture_pairing_tokens[0].expires_at = new Date(Date.now() - 1000).toISOString();
  const res = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "pairing_expired");
  // The terminal transition COMMITTED (F6) rather than rolling back.
  assertEquals(db.capture_pairing_tokens[0].state, "expired");
});

Deno.test("F6: create_capture_upload on an attempts-exhausted token commits 'rejected' and 409s", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  db.capture_pairing_tokens[0].redemption_attempts = 5; // == max
  const res = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "pairing_attempts_exhausted");
  assertEquals(db.capture_pairing_tokens[0].state, "rejected");
});

Deno.test("idempotency: re-submitting the same path returns the recorded result without re-binding", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const first = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("RETAKE")).fn },
  );
  const firstBody = await first.json();
  const attachmentsAfterFirst = db.response_attachments.length;
  // Same path again on the still-open ('uploaded') capability.
  const second = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  assertEquals(second.status, 200);
  const secondBody = await second.json();
  // Returns the recorded outcome (image_quality), NOT a fresh ACCEPT, and binds
  // nothing new — the short-circuit fired.
  assertEquals(secondBody.result.attachment_id, firstBody.result.attachment_id);
  assertEquals(secondBody.result.failure_class, "image_quality");
  assertEquals(db.response_attachments.length, attachmentsAfterFirst);
});

Deno.test("N2: keepOpen survives a failed attachment annotation write (verdict, not the write, decides)", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  db.updateAttachmentShouldFail = true; // the capture_quality_state annotation fails
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service: makeService(db), runQualityCheck: qualityStub(assessed("RETAKE")).fn },
  );
  assertEquals(res.status, 200);
  assertEquals((await res.json()).result.failure_class, "image_quality");
  // The capability stayed OPEN despite the failed annotation write — before N2
  // this silently consumed and reinstated the F1 dead end.
  assertEquals(db.capture_pairing_tokens[0].state, "uploaded");
});

Deno.test("N6: a sign-upload failure persists failure_class 'technical' on the token", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  db.capture_pairing_tokens[0].redemption_attempts = 0;
  db.signUploadShouldFail = true;
  const res = await handleCapturePairing(
    post({ operation: "create_capture_upload", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  assertEquals(res.status, 502);
  assertEquals((await res.json()).failure_class, "technical");
  // The desktop (which only polls pairing_status) can now render the technical
  // screen because the class is on the token, not only in the phone's response.
  assertEquals(db.capture_pairing_tokens[0].failure_class, "technical");
});

Deno.test("N7: a response submitted during the bind window is refused at the bind, not silently written", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const service = makeService(db, {
    beforeBind: () => {
      // The response is submitted after assertAttemptStillWritable passed but
      // before the bind — the check-then-act race N7 closes at the DB level.
      db.response_versions[0].is_submitted = true;
    },
  });
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service, runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "response_already_submitted");
  // Nothing was bound.
  assertEquals(db.response_attachments.length, 0);
});

Deno.test("N7/B1: the guard's ATTEMPT leg also refuses (attempt left an editable status)", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const service = makeService(db, {
    beforeBind: () => {
      // is_submitted is still false; it is the ATTEMPT that moved. After B1 the
      // two are read under separately-acquired locks (attempts first, then
      // response_versions), so this leg must still refuse on its own.
      db.attempts[0].status = "submitted";
    },
  });
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service, runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  assertEquals(res.status, 409);
  assertEquals((await res.json()).error, "response_already_submitted");
  assertEquals(db.response_attachments.length, 0);
});

Deno.test("S1: a response version that vanishes during the bind window maps to 404, not 500", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  const service = makeService(db, {
    beforeBind: () => {
      db.response_versions.length = 0;
    },
  });
  const res = await handleCapturePairing(
    post({
      operation: "submit_capture",
      pairing_handle: s.handle,
      storage_path: s.storagePath,
      explicit_confirmation: true,
    }),
    { service, runQualityCheck: qualityStub(assessed("ACCEPT")).fn },
  );
  // Before S1 both callers' bind-error mappers fell through to a 500
  // "attach_capture_failed" for this code, i.e. reported a legitimate
  // not-found as our bug.
  assertEquals(res.status, 404);
  assertEquals((await res.json()).error, "response_not_found");
  assertEquals(db.response_attachments.length, 0);
});

Deno.test("F11: the sequence is max+1, not count+1 (regression guard for the row-locked assignment)", async () => {
  const db = new FakeDb();
  const s = await seedPairedCapability(db);
  db.capture_pairing_tokens[0].state = "issued";
  // Two existing events with a GAP: count is 2, max is 5.
  db.capture_pairing_events.push(
    { pairing_id: s.pairingId, sequence: 1, event_type: "SESSION_CREATED", actor: "SYSTEM", occurred_at: "t", event: { sequence: 1 } },
    { pairing_id: s.pairingId, sequence: 5, event_type: "PAIRING_ACCEPTED", actor: "SYSTEM", occurred_at: "t", event: { sequence: 5 } },
  );
  await handleCapturePairing(
    post({ operation: "describe_capture", pairing_handle: s.handle }),
    { service: makeService(db) },
  );
  const seqs = db.capture_pairing_events
    .filter((e) => e.pairing_id === s.pairingId)
    .map((e) => e.sequence)
    .sort((a, b) => a - b);
  // max+1 = 6 (count+1 would have been 3 and collided-adjacent).
  assert(seqs.includes(6), `expected a max+1 sequence of 6, got ${seqs.join(",")}`);
  assert(!seqs.includes(3), "count+1 (3) must not be used");
});
