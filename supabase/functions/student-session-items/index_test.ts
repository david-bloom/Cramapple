// Handler tests for the student-session-items confirm-transfer branch
// (SESSION_ASSEMBLY §7.1). The security-critical logic — session ownership,
// exam-pack scoping of the source item, and the fail-closed rules (no same-cell
// item, or a same-cell candidate withheld by the media gate) — lives in the
// handler, so these drive `handleStudentSessionItems` directly with a synthetic
// Request and an in-memory fake of the service client. Same-cell / numeric-
// exclusion selection lives in the SQL RPC and is covered by
// supabase/tests/confirm_transfer_item_selector.integration.sql.

import "./_test_setup.ts";
import { assert, assertEquals } from "jsr:@std/assert@1";
import { handleStudentSessionItems } from "./index.ts";

/* -------------------------------------------------------------------------- */
/* Fake service client — models exactly the call chains the handler makes.    */
/* -------------------------------------------------------------------------- */

type Row = Record<string, unknown>;
type Spec = {
  session?: Row | null;
  sourceVersion?: Row | null;
  transferRows?: Row[];
  transferError?: boolean;
  practiceRows?: Row[];
  criteria?: Row[];
  assets?: Row[];
  visuals?: Row[];
  signFail?: boolean;
};

// deno-lint-ignore no-explicit-any
function tableBuilder(single: any, list: any[]): any {
  const b: Record<string, unknown> = {};
  const chain = () => b;
  b.select = chain;
  b.eq = chain;
  b.in = chain;
  b.order = chain;
  b.maybeSingle = () => Promise.resolve({ data: single ?? null, error: null });
  // Awaiting the builder (…select().in().order()) resolves to the list result.
  b.then = (res: (v: unknown) => unknown, rej?: (e: unknown) => unknown) =>
    Promise.resolve({ data: list ?? [], error: null }).then(res, rej);
  return b;
}

function makeService(spec: Spec) {
  const singleByTable: Record<string, Row | null> = {
    learning_sessions: spec.session ?? null,
    content_item_versions: spec.sourceVersion ?? null,
  };
  const listByTable: Record<string, Row[]> = {
    frq_criteria: spec.criteria ?? [],
    content_asset_metadata: spec.assets ?? [],
    content_visual_requirements: spec.visuals ?? [],
  };
  const appSchema = {
    from: (t: string) =>
      tableBuilder(singleByTable[t] ?? null, listByTable[t] ?? []),
    rpc: (fn: string) =>
      Promise.resolve({
        data: fn === "select_confirm_transfer_item"
          ? (spec.transferRows ?? [])
          : [],
        error: spec.transferError ? { message: "boom" } : null,
      }),
  };
  return {
    schema: (_name: string) => appSchema,
    // top-level rpc is the ordinary-path select_practice_frqs
    rpc: (fn: string) =>
      Promise.resolve({
        data: fn === "select_practice_frqs" ? (spec.practiceRows ?? []) : [],
        error: null,
      }),
    storage: {
      from: (_bucket: string) => ({
        // deno-lint-ignore no-explicit-any
        createSignedUrls: (paths: string[], _ttl: number): Promise<any> =>
          Promise.resolve(
            spec.signFail
              ? { data: null, error: { message: "sign_failed" } }
              : {
                data: paths.map((p) => ({
                  path: p,
                  signedUrl: `https://storage/${p}`,
                  error: null,
                })),
                error: null,
              },
          ),
      }),
    },
    // deno-lint-ignore no-explicit-any
  } as any;
}

const STUDENT = { user: { id: "u1" }, profile: { role: "student" } };
const ACTIVE_SESSION = {
  id: "sess1",
  user_id: "u1",
  exam_pack_version_id: "epv1",
  practice_format: "mcq",
  status: "active",
};

function post(body: unknown) {
  return new Request("https://x/functions/v1/student-session-items", {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify(body),
  });
}

// deno-lint-ignore no-explicit-any
async function call(spec: Spec, body: unknown, profile: any = STUDENT) {
  const res = await handleStudentSessionItems(post(body), {
    service: makeService(spec),
    requireProfile: () => Promise.resolve(profile),
  });
  return { status: res.status, json: await res.json() as Record<string, unknown> };
}

const DELIVERABLE_TRANSFER = {
  content_item_version_id: "tv1",
  content_item_id: "ti1",
  content_key: "apstat-u1-2-2a-variables-102000",
  title: null,
  stem: "Which best describes the variable?",
  stimulus: null,
  stimulus_image_path: null,
  frq_form: null,
  practice_format: null,
};

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: happy path                                                */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer returns one same-cell item", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: { id: "srcv", content_items: { exam_pack_version_id: "epv1" } },
      transferRows: [DELIVERABLE_TRANSFER],
    },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.mode, "confirm_transfer");
  assertEquals(result.source_content_item_version_id, "srcv");
  assert(result.item, "expected a transfer item");
  assertEquals(
    (result.item as Record<string, unknown>).content_item_version_id,
    "tv1",
  );
  assertEquals(result.reason, null);
});

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: fail-closed when the selector returns nothing            */
/* (no same-cell approved MCQ, a numeric-answer cell, or an untagged source)  */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer fails closed with no parallel item", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: { id: "srcv", content_items: { exam_pack_version_id: "epv1" } },
      transferRows: [], // selector excluded / found nothing
    },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.item, null);
  assertEquals(result.reason, "no_parallel_item");
});

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: a candidate withheld by the media gate is fail-closed    */
/* (item: null, and reported in `omitted`) — never an unanswerable transfer.  */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer withholds a media-gated candidate", async () => {
  const withImage = {
    ...DELIVERABLE_TRANSFER,
    stimulus_image_path: "u1/img.png",
  };
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: { id: "srcv", content_items: { exam_pack_version_id: "epv1" } },
      transferRows: [withImage],
      // required visual with no student-approved metadata -> partitionDeliverable omits
      visuals: [{
        content_item_version_id: "tv1",
        image_needed: "yes",
        image_approval: null,
      }],
    },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals(result.item, null);
  assertEquals(result.reason, "no_parallel_item");
  assert(
    (result.omitted as unknown[]).length >= 1,
    "expected the withheld candidate to be reported in omitted",
  );
});

/* -------------------------------------------------------------------------- */
/* Confirm-transfer: source must belong to the session's exam pack            */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer rejects a cross-pack source", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      sourceVersion: {
        id: "srcv",
        content_items: { exam_pack_version_id: "OTHER_PACK" },
      },
      transferRows: [DELIVERABLE_TRANSFER],
    },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 409);
  assertEquals(json.error, "session_content_mismatch");
});

Deno.test("confirm-transfer 404s an unknown source item", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION, sourceVersion: null },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 404);
  assertEquals(json.error, "source_item_not_found");
});

Deno.test("confirm-transfer requires a source id", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION },
    { learning_session_id: "sess1", confirm_transfer: {} },
  );
  assertEquals(status, 400);
  assertEquals(json.error, "missing_required_fields");
});

/* -------------------------------------------------------------------------- */
/* Ownership / lifecycle gates apply to the transfer request too              */
/* -------------------------------------------------------------------------- */

Deno.test("confirm-transfer denies a non-owner", async () => {
  const { status, json } = await call(
    { session: { ...ACTIVE_SESSION, user_id: "someone_else" } },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 403);
  assertEquals(json.error, "forbidden");
});

Deno.test("confirm-transfer refuses an inactive session", async () => {
  const { status, json } = await call(
    { session: { ...ACTIVE_SESSION, status: "completed" } },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
  );
  assertEquals(status, 409);
  assertEquals(json.error, "session_not_active");
});

Deno.test("unauthorized caller is rejected", async () => {
  const { status, json } = await call(
    { session: ACTIVE_SESSION },
    {
      learning_session_id: "sess1",
      confirm_transfer: { source_content_item_version_id: "srcv" },
    },
    null,
  );
  assertEquals(status, 401);
  assertEquals(json.error, "unauthorized");
});

/* -------------------------------------------------------------------------- */
/* Ordinary queue path is unchanged by the refactor                            */
/* -------------------------------------------------------------------------- */

Deno.test("ordinary path still serves the practice selection", async () => {
  const { status, json } = await call(
    {
      session: ACTIVE_SESSION,
      practiceRows: [{ ...DELIVERABLE_TRANSFER, content_item_version_id: "ov1" }],
    },
    { learning_session_id: "sess1" },
  );
  assertEquals(status, 200);
  const result = json.result as Record<string, unknown>;
  assertEquals((result.items as unknown[]).length, 1);
  assertEquals(result.practice_format, "mcq");
});
