// deno-lint-ignore-file require-await
// Request-handling tests for the byoq function, driven through handleByoq
// with an in-memory store/storage that mirrors the SQL semantics of
// 20260928150000_task0039_byoq_core.sql (claim / bind / one-live-token /
// ownership). The real Supabase store is exercised separately by the Dev
// smoke test.

import "./_test_setup.ts";
import { assert, assertEquals } from "jsr:@std/assert@1";
import { handleByoq } from "./index.ts";
import {
  type AttachmentRow,
  type ByoqStorage,
  type ByoqStore,
  type ItemRow,
  type OwnerRow,
  type ResponseRow,
  StoreRpcError,
  type TokenRow,
  type TopicRow,
} from "./store.ts";

/* -------------------------------------------------------------------------- */
/* Fixtures                                                                    */
/* -------------------------------------------------------------------------- */

const CRC_TABLE = (() => {
  const t = new Uint32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    t[n] = c >>> 0;
  }
  return t;
})();
function crc32(bytes: Uint8Array) {
  let c = 0xffffffff;
  for (const b of bytes) c = CRC_TABLE[(c ^ b) & 0xff] ^ (c >>> 8);
  return (c ^ 0xffffffff) >>> 0;
}
function chunk(type: string, data: Uint8Array) {
  const out = new Uint8Array(12 + data.length);
  const dv = new DataView(out.buffer);
  dv.setUint32(0, data.length);
  const td = new TextEncoder().encode(type);
  out.set(td, 4);
  out.set(data, 8);
  dv.setUint32(8 + data.length, crc32(out.slice(4, 8 + data.length)));
  return out;
}
/** A structurally valid 3x2 PNG carrying a large tEXt (metadata) chunk. */
function pngWithMetadata() {
  const ihdr = new Uint8Array(13);
  const dv = new DataView(ihdr.buffer);
  dv.setUint32(0, 3);
  dv.setUint32(4, 2);
  ihdr.set([8, 2, 0, 0, 0], 8);
  const text = new TextEncoder().encode("GPS\0" + "40.7128,-74.0060 ".repeat(80));
  const idat = Uint8Array.from(atob("eJxjYGBgAGMGBgYGBgYGAAAQAAE="), (c) => c.charCodeAt(0));
  const parts = [
    new Uint8Array([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk("IHDR", ihdr),
    chunk("tEXt", text),
    chunk("IDAT", idat),
    chunk("IEND", new Uint8Array()),
  ];
  const total = parts.reduce((n, p) => n + p.length, 0);
  const out = new Uint8Array(total);
  let o = 0;
  for (const p of parts) {
    out.set(p, o);
    o += p.length;
  }
  return out;
}

const USER_A = "11111111-1111-4111-8111-111111111111";
const USER_B = "22222222-2222-4222-8222-222222222222";

function fakeJwt(role: string, sub: string) {
  const enc = (o: unknown) => btoa(JSON.stringify(o)).replaceAll("=", "").replaceAll("+", "-").replaceAll("/", "_");
  return `${enc({ alg: "HS256" })}.${enc({ role, sub })}.sig`;
}

/* -------------------------------------------------------------------------- */
/* In-memory store                                                             */
/* -------------------------------------------------------------------------- */

class Mem implements ByoqStore, ByoqStorage {
  owners: (OwnerRow & { created_ip_hmac: string | null; created_at: string })[] = [];
  items: ItemRow[] = [];
  responses: ResponseRow[] = [];
  tokens: TokenRow[] = [];
  attachments: (AttachmentRow & { pairing_token_id: string })[] = [];
  objects = new Map<string, Uint8Array>();
  profiles = new Set([USER_A, USER_B]);
  topics: TopicRow[] = [{
    taxonomy_topic_id: "33333333-3333-4333-8333-333333333333",
    subject_key: "ap_statistics",
    unit_number: 2,
    unit_title: "Exploring Two-Variable Data",
    topic_code: "2.5",
    topic_title: "Correlation",
  }];
  id = () => crypto.randomUUID();
  ts = () => new Date().toISOString();

  purgeToken = "p".repeat(40);
  // --- store
  async profileExists(u: string) { return this.profiles.has(u); }
  async verifyPurgeToken(t: string) { return t === this.purgeToken; }
  async countAnonymousOwnersSince(since: string) { return this.owners.filter((o) => !o.user_id && o.created_at >= since).length; }
  async countLiveTokens(o: string) {
    return this.tokens.filter((t) => t.owner_id === o && ["issued", "paired", "uploaded"].includes(t.state)).length;
  }
  async expireLapsedTokens() {
    for (const t of this.tokens) {
      if (["issued", "paired", "uploaded"].includes(t.state) && new Date(t.expires_at) <= new Date()) {
        t.state = t.uploads_bound > 0 ? "consumed" : "expired";
        (t as TokenRow & { closed_at?: string }).closed_at = this.ts();
      }
    }
  }
  async unsweptClosedTokens(before: string, limit: number) {
    return this.tokens.filter((t) =>
      !t.incoming_swept_at && ["consumed", "expired", "cancelled", "rejected"].includes(t.state) &&
      ((t as TokenRow & { closed_at?: string }).closed_at ?? "9999") < before
    ).slice(0, limit);
  }
  async markTokenSwept(id: string, at: string) { const t = this.tokens.find((x) => x.id === id); if (t) t.incoming_swept_at = at; }
  async getOwnerById(id: string) { return this.owners.find((o) => o.id === id) ?? null; }
  async findOwnerByKeyHash(h: string) { return this.owners.find((o) => o.key_sha256 === h) ?? null; }
  async findKeylessOwnerForUser(u: string) { return this.owners.find((o) => o.user_id === u && !o.key_sha256) ?? null; }
  async insertOwner(r: { key_sha256: string | null; user_id: string | null; created_ip_hmac: string | null }) {
    const o = { id: this.id(), last_seen_at: this.ts(), created_at: this.ts(), ...r };
    this.owners.push(o);
    return o;
  }
  async countOwnersFromIpSince(ip: string, since: string) {
    return this.owners.filter((o) => o.created_ip_hmac === ip && o.created_at >= since).length;
  }
  async linkOwnerToUser(ownerId: string, u: string) {
    const o = this.owners.find((x) => x.id === ownerId);
    if (o && !o.user_id) o.user_id = u;
    this.items.filter((i) => i.owner_id === ownerId && !i.user_id).forEach((i) => (i.user_id = u));
  }
  async touchOwner() {}
  async ownerIdsForUser(u: string) { return this.owners.filter((o) => o.user_id === u).map((o) => o.id); }
  async staleAnonymousOwners(before: string, limit: number) {
    return this.owners.filter((o) => !o.user_id && o.last_seen_at < before).slice(0, limit);
  }
  async deleteOwner(id: string) {
    this.owners = this.owners.filter((o) => o.id !== id);
    const gone = new Set(this.items.filter((i) => i.owner_id === id).map((i) => i.id));
    this.items = this.items.filter((i) => !gone.has(i.id));
    this.attachments = this.attachments.filter((a) => !gone.has(a.item_id));
  }
  async insertItem(r: Partial<ItemRow> & { owner_id: string; code: string }) {
    const item: ItemRow = {
      id: this.id(), user_id: null, item_type: null, title: null, stem: null, choices: [], subject_key: null,
      taxonomy_topic_id: null, difficulty: null, source_kind: "typed", source_note: null, status: "draft",
      leak_flags: [], created_at: this.ts(), updated_at: this.ts(), confirmed_at: null, last_practiced_at: null, ...r,
    } as ItemRow;
    this.items.push(item);
    return structuredClone(item);
  }
  async getItem(id: string) { const i = this.items.find((x) => x.id === id); return i ? structuredClone(i) : null; }
  async listItems(ids: string[]) { return this.items.filter((i) => ids.includes(i.owner_id) && i.status !== "archived"); }
  async updateItem(id: string, patch: Partial<ItemRow>) {
    const i = this.items.find((x) => x.id === id)!;
    Object.assign(i, patch);
    // Mirror byoq_items_ready_is_complete.
    if (i.status === "ready") {
      assert(i.item_type && i.stem && i.leak_flags.length === 0, "DB ready check would fail");
    }
    return structuredClone(i);
  }
  async deleteItem(id: string) {
    this.items = this.items.filter((i) => i.id !== id);
    this.attachments = this.attachments.filter((a) => a.item_id !== id);
  }
  async countItemsCreatedSince(o: string, s: string) { return this.items.filter((i) => i.owner_id === o && i.created_at >= s).length; }
  async countLiveItems(ids: string[]) { return this.items.filter((i) => ids.includes(i.owner_id)).length; }
  async listItemIdsForOwner(o: string) { return this.items.filter((i) => i.owner_id === o).map((i) => i.id); }
  async resolveTopic(s: string, u: number | null, c: string) {
    return this.topics.find((t) => t.subject_key === s && t.topic_code === c && (u === null || t.unit_number === u)) ?? null;
  }
  async topicById(id: string) { return this.topics.find((t) => t.taxonomy_topic_id === id) ?? null; }
  async listSubjects() { return ["ap_biology", "ap_statistics"]; }
  async listTopics(s: string) { return this.topics.filter((t) => t.subject_key === s); }
  async topicGuides() {
    return { briefs: [{ topicCode: "2.5", howPointsAreEarned: "Direction, form, strength in context." }], explainers: [] };
  }
  async listResponses(itemId: string) { return this.responses.filter((r) => r.item_id === itemId); }
  async insertResponse(r: Omit<ResponseRow, "id" | "created_at">) {
    const row = { id: this.id(), created_at: this.ts(), ...r };
    this.responses.push(row);
    return row;
  }
  async countMintsSince(o: string, s: string) { return this.tokens.filter((t) => t.owner_id === o && t.created_at >= s).length; }
  async cancelLiveTokens(slot: { item_id: string; capture_role: string; response_id: string | null; part_key: string }) {
    const live = this.tokens.filter((t) =>
      t.item_id === slot.item_id && t.capture_role === slot.capture_role && t.response_id === slot.response_id &&
      t.part_key === slot.part_key && ["issued", "paired", "uploaded"].includes(t.state)
    );
    live.forEach((t) => (t.state = "cancelled"));
    return live.map((t) => t.generation);
  }
  async insertToken(r: Omit<TokenRow, "id" | "created_at" | "state" | "access_path" | "redemption_attempts" | "uploads_bound" | "incoming_swept_at">) {
    const t: TokenRow = { id: this.id(), created_at: this.ts(), state: "issued", access_path: null, redemption_attempts: 0, uploads_bound: 0, incoming_swept_at: null, ...r };
    this.tokens.push(t);
    return { ...t };
  }
  async getTokenByHash(h: string) { const t = this.tokens.find((x) => x.handle_sha256 === h); return t ? { ...t } : null; }
  async getTokenById(id: string) { const t = this.tokens.find((x) => x.id === id); return t ? { ...t } : null; }
  bindShouldFail = false;
  async transitionToken(id: string, from: string[], patch: Record<string, unknown>) {
    const t = this.tokens.find((x) => x.id === id);
    if (!t || !from.includes(t.state)) return null;
    Object.assign(t, patch);
    return { ...t };
  }
  async claimUpload(h: string, max: number, path: string) {
    const t = this.tokens.find((x) => x.handle_sha256 === h);
    if (!t) throw new StoreRpcError("byoq_pairing:not_found");
    if (t.state === "consumed") throw new StoreRpcError("byoq_pairing:already_used");
    if (["cancelled", "rejected", "expired"].includes(t.state)) throw new StoreRpcError(`byoq_pairing:${t.state}`);
    if (new Date(t.expires_at) <= new Date()) { t.state = "expired"; return { ...t }; }
    if (t.redemption_attempts >= max) { t.state = "rejected"; return { ...t }; }
    t.redemption_attempts++;
    if (t.state === "issued") t.state = "paired";
    t.access_path ??= path as TokenRow["access_path"];
    return { ...t };
  }
  async bindAttachment(p: Parameters<ByoqStore["bindAttachment"]>[0]) {
    const t = this.tokens.find((x) => x.id === p.pairingId);
    if (!t) throw new StoreRpcError("byoq_bind:pairing_not_found");
    if (this.bindShouldFail) throw new StoreRpcError("byoq_bind:page_limit_reached");
    if (!["paired", "uploaded"].includes(t.state)) throw new StoreRpcError("byoq_bind:pairing_not_live");
    const slot = this.attachments.filter((a) =>
      a.item_id === t.item_id && a.capture_role === t.capture_role && a.response_id === t.response_id &&
      a.part_key === t.part_key && a.is_current
    );
    let page: number;
    if (p.replacesAttachmentId) {
      const prior = this.attachments.find((a) => a.id === p.replacesAttachmentId);
      if (!prior || prior.item_id !== t.item_id) throw new StoreRpcError("byoq_bind:invalid_retake_target");
      if (!prior.is_current) throw new StoreRpcError("byoq_bind:stale_retake_target");
      prior.is_current = false;
      page = prior.page_sequence;
    } else {
      if (slot.length >= p.maxCurrentPages) throw new StoreRpcError("byoq_bind:page_limit_reached");
      page = slot.reduce((m, a) => Math.max(m, a.page_sequence), 0) + 1;
    }
    const a = {
      id: this.id(), owner_id: t.owner_id, item_id: t.item_id, capture_role: t.capture_role, response_id: t.response_id,
      part_key: t.part_key, page_sequence: page, storage_path: p.storagePath, media_type: p.mediaType, byte_size: p.byteSize,
      pixel_width: p.width, pixel_height: p.height, sha256_digest: p.sha256, is_current: true, created_at: this.ts(), pairing_token_id: t.id,
    };
    this.attachments.push(a);
    t.state = "uploaded";
    t.uploads_bound++;
    return { ...a };
  }
  async listAttachments(itemId: string) { return this.attachments.filter((a) => a.item_id === itemId && a.is_current); }
  async getAttachment(id: string) { const a = this.attachments.find((x) => x.id === id); return a ? { ...a } : null; }
  async deleteAttachment(id: string) { this.attachments = this.attachments.filter((a) => a.id !== id); }
  async attachmentPathsForOwner(o: string) { return this.attachments.filter((a) => a.owner_id === o).map((a) => a.storage_path); }
  // TASK-0068 ledger
  ledger: { requestId: string; status: string; cost: number }[] = [];
  reserveShouldFail = false;
  async reserveModelUsage(p: { requestId: string; reservedCostUsd: number }) {
    if (this.reserveShouldFail) return false;
    if (!this.ledger.some((l) => l.requestId === p.requestId)) this.ledger.push({ requestId: p.requestId, status: "reserved", cost: p.reservedCostUsd });
    return true;
  }
  async completeModelUsage(p: { requestId: string; status: string }) {
    const l = this.ledger.find((x) => x.requestId === p.requestId);
    if (l) l.status = p.status;
  }
  async byoqExtractionSpendToday() { return this.ledger.reduce((s, l) => s + l.cost, 0); }

  // --- storage
  async signUpload(path: string) { return { signedUrl: `https://upload/${path}`, token: "tok" }; }
  async download(path: string) { return this.objects.get(path) ?? null; }
  async size(path: string) { return this.objects.get(path)?.length ?? null; }
  async upload(path: string, bytes: Uint8Array) {
    if (this.objects.has(path)) throw new Error("exists");
    this.objects.set(path, bytes);
  }
  async remove(paths: string[]) { paths.forEach((p) => this.objects.delete(p)); }
  async signRead(path: string) { return this.objects.has(path) ? `https://read/${path}` : null; }
  async list(prefix: string) { return [...this.objects.keys()].filter((k) => k.startsWith(prefix + "/")); }
}

/* -------------------------------------------------------------------------- */
/* Harness                                                                     */
/* -------------------------------------------------------------------------- */

function harness() {
  const mem = new Mem();
  const call = async (
    body: Record<string, unknown>,
    opts: { jwt?: string; ip?: string | null; bearer?: string; headers?: Record<string, string> } = {},
  ) => {
    const headers: Record<string, string> = { "content-type": "application/json", ...(opts.headers ?? {}) };
    if (opts.ip !== null) headers["cf-connecting-ip"] = opts.ip ?? "203.0.113.9";
    if (opts.jwt) headers.authorization = `Bearer ${opts.jwt}`;
    if (opts.bearer) headers.authorization = `Bearer ${opts.bearer}`;
    const res = await handleByoq(new Request("https://fn/byoq", { method: "POST", headers, body: JSON.stringify(body) }), {
      store: mem,
      storage: mem,
      serviceRoleKey: "svc-key",
      ipHmacKey: "hmac-key",
      verifyUser: async (jwt) => {
        const sub = JSON.parse(atob(jwt.split(".")[1].replaceAll("-", "+").replaceAll("_", "/"))).sub;
        return sub === "expired" ? null : sub;
      },
    });
    const text = await res.text();
    return { status: res.status, text, json: JSON.parse(text) };
  };
  return { mem, call };
}

async function anonItem(call: ReturnType<typeof harness>["call"], fields: Record<string, unknown>) {
  const r = await call({ operation: "create_item", ...fields });
  assertEquals(r.status, 200, r.text);
  return { key: r.json.result.owner_key as string, item: r.json.result.item };
}

/* -------------------------------------------------------------------------- */
/* Tests                                                                       */
/* -------------------------------------------------------------------------- */

Deno.test("only create_item mints an anonymous owner key, once; presenting it reuses the owner", async () => {
  const { mem, call } = harness();
  const opened = await call({ operation: "start" });
  assertEquals(opened.status, 200);
  assertEquals(opened.json.result.owner_key, undefined);
  assertEquals(mem.owners.length, 0, "opening the page creates nothing");
  const first = await call({ operation: "create_item", item_type: "frq", stem: "x" });
  const key = first.json.result.owner_key;
  assert(typeof key === "string" && key.startsWith("byoq_"));
  assertEquals(first.json.result.recognized, false);
  const second = await call({ operation: "create_item", owner_key: key, item_type: "frq", stem: "y" });
  assertEquals(second.json.result.owner_key, undefined);
  assertEquals(mem.owners.length, 1);
  // Only the hash is stored.
  assert(!JSON.stringify(mem.owners).includes(key));
});

Deno.test("typed MCQ: pasted answer is detected, masked, blocks confirm, and can be removed", async () => {
  const { call } = harness();
  const { key, item } = await anonItem(call, {
    item_type: "mcq",
    stem: "Which value is the median?\nAnswer: B",
    choices: ["3", "4", "5"],
  });
  assertEquals(item.answer_text_detected, true);
  assertEquals(item.text_masked, true);
  assert(!item.stem.includes("Answer: B"));
  const blocked = await call({ operation: "confirm_item", owner_key: key, item_id: item.id });
  assertEquals(blocked.status, 409);
  assertEquals(blocked.json.readiness_problem, "answer_text_detected");
  const cleaned = await call({ operation: "remove_flagged_text", owner_key: key, item_id: item.id });
  assertEquals(cleaned.json.result.item.stem, "Which value is the median?");
  const ok = await call({ operation: "confirm_item", owner_key: key, item_id: item.id });
  assertEquals(ok.status, 200, ok.text);
  assertEquals(ok.json.result.item.status, "ready");
});

Deno.test("an answer-shaped key on a choice is refused, never silently stored", async () => {
  const { call } = harness();
  const r = await call({
    operation: "create_item",
    item_type: "mcq",
    stem: "Q?",
    choices: [{ choice_text: "x", is_correct: true }, { choice_text: "y" }],
  });
  assertEquals(r.status, 422);
  assertEquals(r.json.error, "invalid_choice_shape");
});

Deno.test("another owner gets 404 for an item and an empty list", async () => {
  const { call } = harness();
  const { item } = await anonItem(call, { item_type: "frq", stem: "Explain." });
  const other = await call({ operation: "create_item", stem: "z" }, { ip: "198.51.100.1" });
  const otherKey = other.json.result.owner_key;
  const get = await call({ operation: "get_item", owner_key: otherKey, item_id: item.id });
  assertEquals(get.status, 404);
  const list = await call({ operation: "list_items", owner_key: otherKey });
  assert(!list.json.result.items.some((i: { id: string }) => i.id === item.id), "other owner's list excludes the item");
  // No key at all: nothing, and no owner is created for a read.
  const bare = await call({ operation: "get_item", item_id: item.id });
  assertEquals(bare.status, 404);
});

Deno.test("signing in recognizes anonymous work; the bare key then requires sign-in", async () => {
  const { mem, call } = harness();
  const { key, item } = await anonItem(call, { item_type: "frq", stem: "Explain." });
  const jwt = fakeJwt("authenticated", USER_A);
  const list = await call({ operation: "list_items", owner_key: key }, { jwt });
  assertEquals(list.json.result.recognized, true);
  assertEquals(list.json.result.items.map((i: { id: string }) => i.id), [item.id]);
  assertEquals(mem.items[0].user_id, USER_A);
  const anonAgain = await call({ operation: "list_items", owner_key: key });
  assertEquals(anonAgain.status, 401);
  // User B signing in with A's old key does not get A's items.
  const b = await call({ operation: "list_items", owner_key: key }, { jwt: fakeJwt("authenticated", USER_B) });
  assertEquals(b.json.result.items, []);
});

Deno.test("an expired user JWT is a 401, not a silent anonymous downgrade; the anon key JWT is anonymous", async () => {
  const { call } = harness();
  const expired = await call({ operation: "start" }, { jwt: fakeJwt("authenticated", "expired") });
  assertEquals(expired.status, 401);
  const anon = await call({ operation: "create_item", stem: "q" }, { jwt: fakeJwt("anon", "") });
  assertEquals(anon.status, 200);
  assertEquals(anon.json.result.recognized, false);
});

Deno.test("practice responses are versioned, never scored, and require a ready item", async () => {
  const { call } = harness();
  const { key, item } = await anonItem(call, { item_type: "mcq", stem: "Pick one.", choices: ["a", "b"] });
  const early = await call({ operation: "save_response", owner_key: key, item_id: item.id, selected_choice_key: "A" });
  assertEquals(early.status, 409);
  await call({ operation: "confirm_item", owner_key: key, item_id: item.id });
  const v1 = await call({ operation: "save_response", owner_key: key, item_id: item.id, selected_choice_key: "A" });
  const v2 = await call({ operation: "save_response", owner_key: key, item_id: item.id, selected_choice_key: "B", is_final: true });
  const v3 = await call({ operation: "save_response", owner_key: key, item_id: item.id, selected_choice_key: "A" });
  assertEquals([v1, v2, v3].map((r) => [r.json.result.response.attempt_number, r.json.result.response.version_number]), [[1, 1], [1, 2], [2, 1]]);
  assertEquals(v2.json.result.response.parent_response_id, v1.json.result.response.id);
  for (const r of [v1, v2, v3]) {
    assertEquals(r.json.result.scoring.scored, false);
    assert(!/is_correct|"correct"|score_points|result_state|verdict/.test(r.text), r.text);
  }
  const bad = await call({ operation: "save_response", owner_key: key, item_id: item.id, selected_choice_key: "D" });
  assertEquals(bad.json.error, "unknown_choice_key");
  const get = await call({ operation: "get_item", owner_key: key, item_id: item.id });
  assert(!/is_correct|score_points|verdict/.test(get.text));
});

Deno.test("topic selection resolves against the taxonomy and serves reference guides", async () => {
  const { call } = harness();
  const bad = await call({ operation: "create_item", item_type: "frq", stem: "x", subject_key: "ap_statistics", topic_code: "9.9" });
  assertEquals(bad.json.error, "unknown_topic");
  const { key, item } = await anonItem(call, { item_type: "frq", stem: "x", subject_key: "ap-statistics", unit_number: 2, topic_code: "2.5" });
  assertEquals(item.topic.topic_title, "Correlation");
  const get = await call({ operation: "get_item", owner_key: key, item_id: item.id });
  assertEquals(get.json.result.reference.missing, false);
  const topics = await call({ operation: "list_topics", subject_key: "ap_statistics" });
  assertEquals(topics.json.result.units[0].topics[0].topic_code, "2.5");
});

Deno.test("phone capture: question photo is stripped, bound as pages, and the capability is scoped", async () => {
  const { mem, call } = harness();
  const { key, item } = await anonItem(call, { source_kind: "photo_single" });
  const mint = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  assertEquals(mint.status, 200, mint.text);
  const handle = mint.json.result.pairing_handle;
  assert(!JSON.stringify(mem.tokens).includes(handle));

  const desc = await call({ operation: "describe_capture", pairing_handle: handle });
  assertEquals(desc.json.result.pairing.state, "paired");
  assert(!desc.text.includes(item.id), "phone learns nothing about the item beyond its code");

  const png = pngWithMetadata();
  for (const expectedPage of [1, 2]) {
    const up = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
    assertEquals(up.status, 200, up.text);
    mem.objects.set(up.json.result.storage_path, png);
    const sub = await call({ operation: "submit_capture", pairing_handle: handle, storage_path: up.json.result.storage_path });
    assertEquals(sub.status, 200, sub.text);
    assertEquals(sub.json.result.attachment.page_sequence, expectedPage);
    assert(!mem.objects.has(up.json.result.storage_path), "raw upload removed");
  }
  const stored = mem.attachments.map((a) => mem.objects.get(a.storage_path)!);
  assertEquals(stored.length, 2);
  for (const bytes of stored) {
    assert(bytes.length < png.length, "metadata stripped");
    assert(!new TextDecoder().decode(bytes).includes("40.7128"), "no GPS text kept");
  }
  assert(mem.attachments.every((a) => a.storage_path.startsWith(`byoq-anon/${mem.owners[0].id}/${item.id}/question/`)));

  // A path outside this capability's own incoming folder is refused.
  const other = await call({
    operation: "submit_capture",
    pairing_handle: handle,
    storage_path: `byoq-anon/${mem.owners[0].id}/${item.id}/question/x.png`,
  });
  assertEquals(other.json.error, "invalid_storage_path");

  const status = await call({ operation: "pairing_status", owner_key: key, pairing_id: mint.json.result.pairing.pairing_id });
  assertEquals(status.json.result.pages.length, 2);

  const fin = await call({ operation: "finish_capture", pairing_handle: handle });
  assertEquals(fin.json.result.pairing.state, "consumed");
  const replay = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
  assertEquals(replay.status, 409);
});

Deno.test("re-minting cancels the previous QR code for the same slot", async () => {
  const { call } = harness();
  const { key, item } = await anonItem(call, {});
  const a = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  const b = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  assertEquals(b.json.result.pairing.generation, 2);
  const stale = await call({ operation: "describe_capture", pairing_handle: a.json.result.pairing_handle });
  assertEquals(stale.json.error, "pairing_cancelled");
});

Deno.test("response-photo capture needs a ready item and a response of that item", async () => {
  const { call } = harness();
  const { key, item } = await anonItem(call, { item_type: "frq", stem: "Sketch it.", confirm: true });
  const noResp = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "response" });
  assertEquals(noResp.json.error, "missing_required_fields");
  const saved = await call({ operation: "save_response", owner_key: key, item_id: item.id, response_text: "see photo" });
  const ok = await call({
    operation: "mint_pairing",
    owner_key: key,
    item_id: item.id,
    capture_role: "response",
    response_id: saved.json.result.response.id,
    part_key: "part_a",
  });
  assertEquals(ok.status, 200, ok.text);
  assertEquals(ok.json.result.pairing.part_key, "part_a");
});

Deno.test("delete_item removes stored photos as well as rows", async () => {
  const { mem, call } = harness();
  const { key, item } = await anonItem(call, {});
  const mint = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  const handle = mint.json.result.pairing_handle;
  const up = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
  mem.objects.set(up.json.result.storage_path, pngWithMetadata());
  await call({ operation: "submit_capture", pairing_handle: handle, storage_path: up.json.result.storage_path });
  assertEquals(mem.objects.size, 1);
  const del = await call({ operation: "delete_item", owner_key: key, item_id: item.id });
  assertEquals(del.status, 200);
  assertEquals(mem.objects.size, 0);
  assertEquals(mem.items.length, 0);
});

Deno.test("anonymous owner creation is rate-limited per IP, fails closed without an IP, and has a global ceiling", async () => {
  const { mem, call } = harness();
  const make = (ip: string | null) => call({ operation: "create_item", stem: "q" }, { ip });
  for (let i = 0; i < 120; i++) assertEquals((await make("192.0.2.7")).status, 200);
  assertEquals((await make("192.0.2.7")).status, 429);
  assertEquals((await make("192.0.2.8")).status, 200);
  assertEquals((await make(null)).status, 429, "no client IP must not mean no limit");
  // A spoofed X-Forwarded-For does not override the edge-set client IP.
  const spoof = await call({ operation: "create_item", stem: "q" }, { ip: "192.0.2.7", headers: { "x-forwarded-for": "1.1.1.1" } });
  assertEquals(spoof.status, 429);
  // Global circuit breaker.
  for (let i = 0; i < 5000; i++) {
    mem.owners.push({ id: crypto.randomUUID(), key_sha256: null, user_id: null, created_ip_hmac: "x", created_at: new Date().toISOString(), last_seen_at: "" });
  }
  assertEquals((await make("192.0.2.99")).status, 429);
});

Deno.test("answer text in the title or source note is detected and masked too (DECISION-0057)", async () => {
  const { call } = harness();
  const { key, item } = await anonItem(call, {
    item_type: "frq",
    stem: "Explain the trend.",
    title: "Q3 Answer: C",
    source_note: "Answer key: B",
  });
  assertEquals(item.answer_text_detected, true);
  assert(!item.title.includes("Answer: C") && !item.source_note.includes("Answer key: B"), JSON.stringify(item));
  const list = await call({ operation: "list_items", owner_key: key });
  assert(!list.text.includes("Answer: C") && !list.text.includes("Answer key: B"));
  const cleaned = await call({ operation: "remove_flagged_text", owner_key: key, item_id: item.id });
  assertEquals(cleaned.json.result.item.answer_text_detected, false);
  assertEquals(cleaned.json.result.item.title, "Q3");
});

Deno.test("part keys are whitelisted and open captures per owner are capped", async () => {
  const { call } = harness();
  const { key, item } = await anonItem(call, {});
  const bad = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question", part_key: "x".repeat(20) });
  assertEquals(bad.json.error, "invalid_part_key");
  const codes: number[] = [];
  for (const part of ["whole", "part_a", "part_b", "part_c", "part_d", "part_e", "part_f"]) {
    codes.push((await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question", part_key: part })).status);
  }
  assertEquals(codes, [200, 200, 200, 200, 200, 200, 429]);
});

Deno.test("a failed bind keeps the raw upload for retry, and the closed-capture sweep then removes it", async () => {
  const { mem, call } = harness();
  const { key, item } = await anonItem(call, {});
  const mint = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  const handle = mint.json.result.pairing_handle;
  const up = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
  mem.objects.set(up.json.result.storage_path, pngWithMetadata());
  mem.bindShouldFail = true;
  const failed = await call({ operation: "submit_capture", pairing_handle: handle, storage_path: up.json.result.storage_path });
  assertEquals(failed.status, 409);
  assert(mem.objects.has(up.json.result.storage_path), "raw upload kept for a retry");
  assertEquals(mem.objects.size, 1, "no stray stripped copy left behind");
  // Abandon it: the capability closes, then the scheduled purge sweeps it.
  await call({ operation: "cancel_pairing", owner_key: key, pairing_id: mint.json.result.pairing.pairing_id });
  const tok = mem.tokens[0] as TokenRow & { closed_at?: string };
  tok.closed_at = "2000-01-01T00:00:00.000Z";
  const purge = await call({ operation: "purge" }, { headers: { "x-byoq-purge-token": mem.purgeToken } });
  assertEquals(purge.json.result.swept_captures, 1);
  assertEquals(mem.objects.size, 0);
  assertEquals(mem.tokens[0].incoming_swept_at !== null, true);
});

Deno.test("a capture minted before sign-in still submits after the owner is recognized", async () => {
  const { mem, call } = harness();
  const { key, item } = await anonItem(call, {});
  const mint = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  const handle = mint.json.result.pairing_handle;
  const up = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
  await call({ operation: "list_items", owner_key: key }, { jwt: fakeJwt("authenticated", USER_A) });
  mem.objects.set(up.json.result.storage_path, pngWithMetadata());
  const sub = await call({ operation: "submit_capture", pairing_handle: handle, storage_path: up.json.result.storage_path });
  assertEquals(sub.status, 200, sub.text);
  const del = await call({ operation: "delete_item", item_id: item.id }, { jwt: fakeJwt("authenticated", USER_A) });
  assertEquals(del.status, 200);
  assertEquals(mem.objects.size, 0, "objects under both the anonymous and recognized prefixes are removed");
});

Deno.test("purge requires the service-role key and removes stale anonymous owners with their photos", async () => {
  const { mem, call } = harness();
  const { key, item } = await anonItem(call, {});
  const mint = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  const up = await call({ operation: "create_capture_upload", pairing_handle: mint.json.result.pairing_handle, media_type: "image/png" });
  mem.objects.set(up.json.result.storage_path, pngWithMetadata());
  await call({ operation: "submit_capture", pairing_handle: mint.json.result.pairing_handle, storage_path: up.json.result.storage_path });

  assertEquals((await call({ operation: "purge" })).status, 403);
  assertEquals((await call({ operation: "purge" }, { bearer: "not-it" })).status, 403);
  assertEquals((await call({ operation: "purge" }, { headers: { "x-byoq-purge-token": "q".repeat(40) } })).status, 403);
  const fresh = await call({ operation: "purge" }, { bearer: "svc-key" });
  assertEquals(fresh.json.result.purged_owners, 0);
  mem.owners[0].last_seen_at = "2000-01-01T00:00:00.000Z";
  const stale = await call({ operation: "purge" }, { bearer: "svc-key" });
  assertEquals(stale.json.result.purged_owners, 1);
  assertEquals(mem.objects.size, 0);
  assertEquals(mem.items.length, 0);
});

Deno.test("unknown operations and malformed capabilities are rejected", async () => {
  const { call } = harness();
  assertEquals((await call({ operation: "grade" })).status, 400);
  assertEquals((await call({ operation: "describe_capture", pairing_handle: "cap_x" })).json.error, "invalid_pairing_handle");
  assertEquals((await call({ operation: "start", owner_key: "nope" })).json.error, "invalid_owner_key");
});

/* -------------------------------------------------------------------------- */
/* TASK-0068: extraction and phone-side review                                 */
/* -------------------------------------------------------------------------- */

import { type ExtractionInput, type ExtractionOutcome, warningsFor } from "../_shared/byoq-extraction.ts";

function proposed(over: Record<string, unknown> = {}): ExtractionOutcome {
  const out: ExtractionOutcome = {
    kind: "proposed",
    proposal: {
      is_question: true,
      item_type: "mcq",
      stem: "Which value of r indicates the strongest linear relationship?",
      choices: ["r = 0.2", "r = −0.9", "r = 0.5", "r = −0.1"],
      topic_code: "2.5",
      alternatives: [],
      captured_work: "Option B is circled.",
      answer_key_present: false,
      possible_personal_information: false,
      unreadable_regions: [],
      visual_only_regions: [],
      looks_like_subject: true,
      ...over,
    },
    warnings: [],
    modelId: "test-model",
    latencyMs: 10,
    usage: { input_tokens: 1, output_tokens: 1 },
  };
  if (out.kind === "proposed") out.warnings = warningsFor(out.proposal, true);
  return out;
}

/** Harness with an injectable model; records every call's input. */
function extractionHarness(outcome: () => ExtractionOutcome, cfg: Record<string, unknown> = {}) {
  const base = harness();
  const calls: ExtractionInput[] = [];
  const call = async (body: Record<string, unknown>, opts: Parameters<typeof base.call>[1] = {}) => {
    const headers: Record<string, string> = { "content-type": "application/json", ...(opts.headers ?? {}) };
    if (opts.ip !== null) headers["cf-connecting-ip"] = opts.ip ?? "203.0.113.9";
    if (opts.jwt) headers.authorization = `Bearer ${opts.jwt}`;
    const res = await handleByoq(new Request("https://fn/byoq", { method: "POST", headers, body: JSON.stringify(body) }), {
      store: base.mem,
      storage: base.mem,
      serviceRoleKey: "svc-key",
      ipHmacKey: "hmac-key",
      verifyUser: async (jwt) => JSON.parse(atob(jwt.split(".")[1].replaceAll("-", "+").replaceAll("_", "/"))).sub,
      extract: async (input) => {
        calls.push(input);
        const o = outcome();
        if (!(await input.reserveCost())) return { kind: "unavailable", failure: "cost_cap_reached" };
        return o;
      },
      extraction: { enabled: true, apiKey: "k", modelId: "test-model", timeoutMs: 1000, reservedCostUsd: 0.03, sharedCapUsd: 10, byoqCapUsd: 100, ...cfg },
    });
    const text = await res.text();
    return { status: res.status, text, json: JSON.parse(text) };
  };
  return { mem: base.mem, call, calls };
}

/** Desktop mints a question pairing, the phone uploads one page and finishes. */
async function photoItem(h: ReturnType<typeof extractionHarness>, fields: Record<string, unknown> = {}) {
  const { call } = h;
  const created = await call({ operation: "create_item", source_kind: "photo_single", ...fields });
  assertEquals(created.status, 200, created.text);
  const key = created.json.result.owner_key as string;
  const item = created.json.result.item;
  const minted = await call({ operation: "mint_pairing", owner_key: key, item_id: item.id, capture_role: "question" });
  assertEquals(minted.status, 200, minted.text);
  const handle = minted.json.result.pairing_handle as string;
  await call({ operation: "describe_capture", pairing_handle: handle });
  const ticket = await call({ operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png" });
  assertEquals(ticket.status, 200, ticket.text);
  await h.mem.upload(ticket.json.result.storage_path, pngWithMetadata());
  const submitted = await call({ operation: "submit_capture", pairing_handle: handle, storage_path: ticket.json.result.storage_path });
  assertEquals(submitted.status, 200, submitted.text);
  return { key, item, handle };
}

Deno.test("finish_capture runs extraction and fills only the empty fields; captured_work never leaves the function", async () => {
  const h = extractionHarness(() => proposed());
  const { key, item, handle } = await photoItem(h, { subject_key: "ap_statistics", unit_number: 2 });
  const finished = await h.call({ operation: "finish_capture", pairing_handle: handle });
  assertEquals(finished.status, 200, finished.text);
  assertEquals(finished.json.result.extraction.status, "proposed");
  assertEquals(finished.json.result.extraction.filled, ["item_type", "stem", "choices", "topic"]);
  assertEquals(h.calls.length, 1);
  // Context, not the photo, supplied the subject and unit; the unit narrowed the topics.
  assertEquals(h.calls[0].subjectName, "AP Statistics");
  assertEquals(h.calls[0].unitLabel, "Unit 2: Exploring Two-Variable Data");
  assertEquals(h.calls[0].topics, [{ code: "2.5", title: "Correlation" }]);
  assertEquals(h.calls[0].pages.length, 1);

  const got = await h.call({ operation: "get_item", owner_key: key, item_id: item.id });
  const it = got.json.result.item;
  assertEquals(it.item_type, "mcq");
  assertEquals(it.stem, "Which value of r indicates the strongest linear relationship?");
  assertEquals(it.choices.map((c: { choice_key: string }) => c.choice_key), ["A", "B", "C", "D"]);
  assertEquals(it.topic.topic_code, "2.5");
  assertEquals(it.context_unit_number, 2);
  assertEquals(it.status, "draft", "a proposal never confirms itself");
  assert(!got.text.includes("circled"), "captured_work must not be returned");
  assertEquals(h.mem.items[0].captured_work, "Option B is circled.");
  assertEquals(h.mem.ledger.length, 1);
  assertEquals(h.mem.ledger[0].status, "completed");
});

Deno.test("a student's edit is never overwritten by a re-run; a repeat with the same photos makes no model call", async () => {
  const h = extractionHarness(() => proposed());
  const { key, item, handle } = await photoItem(h, { subject_key: "ap_statistics", unit_number: 2 });
  await h.call({ operation: "finish_capture", pairing_handle: handle });
  const edited = await h.call({ operation: "update_item", owner_key: key, item_id: item.id, stem: "My own wording", choices: ["one", "two"] });
  assertEquals(edited.status, 200, edited.text);
  const again = await h.call({ operation: "extract_question", owner_key: key, item_id: item.id });
  assertEquals(again.status, 200, again.text);
  assertEquals(h.calls.length, 1, "same digests, same model, same prompt: no second call");
  const forced = await h.call({ operation: "extract_question", owner_key: key, item_id: item.id, force: true });
  assertEquals(forced.status, 200, forced.text);
  assertEquals(h.calls.length, 2);
  assertEquals(forced.json.result.item.stem, "My own wording");
  assertEquals(forced.json.result.item.choices.map((c: { choice_text: string }) => c.choice_text), ["one", "two"]);
  assertEquals(forced.json.result.item.extraction.filled, []);
});

Deno.test("proposed text passes the same leak gate as typed text; a printed answer key is dropped", async () => {
  const h = extractionHarness(() => proposed({ stem: "What is 2 + 2?\nAnswer: 4", answer_key_present: true, captured_work: null }));
  const { key, item, handle } = await photoItem(h, { subject_key: "ap_statistics" });
  const finished = await h.call({ operation: "finish_capture", pairing_handle: handle });
  assert(finished.json.result.extraction.warnings.includes("answer_key_present"));
  const got = await h.call({ operation: "get_item", owner_key: key, item_id: item.id });
  assertEquals(got.json.result.item.answer_text_detected, true);
  assertEquals(got.json.result.item.text_masked, true);
  assert(!got.json.result.item.stem.includes("Answer: 4"));
  assertEquals(h.mem.items[0].captured_work, null);
  const confirm = await h.call({ operation: "confirm_item", owner_key: key, item_id: item.id });
  assertEquals(confirm.status, 409);
  assertEquals(confirm.json.readiness_problem, "answer_text_detected");
});

Deno.test("extraction off, no key, or breaker tripped records `unavailable` and the typed flow still works", async () => {
  const off = extractionHarness(() => proposed(), { enabled: false });
  const a = await photoItem(off, {});
  const fa = await off.call({ operation: "finish_capture", pairing_handle: a.handle });
  assertEquals(fa.status, 200, fa.text);
  assertEquals(fa.json.result.extraction, { ...fa.json.result.extraction, status: "unavailable", failure: "disabled" });
  assertEquals(off.calls.length, 0);
  const typed = await off.call({ operation: "update_item", owner_key: a.key, item_id: a.item.id, item_type: "frq", stem: "typed instead", confirm: true });
  assertEquals(typed.json.result.item.status, "ready");

  const capped = extractionHarness(() => proposed(), { byoqCapUsd: 0.01 });
  const b = await photoItem(capped, {});
  const fb = await capped.call({ operation: "finish_capture", pairing_handle: b.handle });
  assertEquals(fb.json.result.extraction.status, "unavailable");
  assertEquals(fb.json.result.extraction.failure, "cost_cap_reached");
  assertEquals(capped.mem.ledger.length, 0, "no reservation when the BYOQ breaker refuses");

  const broken = extractionHarness(() => ({ kind: "failed", failure: "timeout", detail: "slow", modelId: "m", latencyMs: 1 }));
  const c = await photoItem(broken, {});
  const fc = await broken.call({ operation: "finish_capture", pairing_handle: c.handle });
  assertEquals(fc.status, 200);
  assertEquals(fc.json.result.extraction.status, "failed");
  assertEquals(broken.mem.ledger[0].status, "failed");
  assertEquals(broken.mem.items[0].stem, null);
});

Deno.test("phone review ops act only on the pairing's own item, through the capability, inside the review window", async () => {
  const h = extractionHarness(() => proposed());
  const a = await photoItem(h, { subject_key: "ap_statistics", unit_number: 2 });
  const b = await photoItem(h, { subject_key: "ap_statistics" }); // a second item, another owner
  await h.call({ operation: "finish_capture", pairing_handle: a.handle });

  // The handle alone (no owner key) reads the item, and a foreign item_id is ignored.
  const got = await h.call({ operation: "capture_review_get", pairing_handle: a.handle, item_id: b.item.id });
  assertEquals(got.status, 200, got.text);
  assertEquals(got.json.result.item.id, a.item.id);
  assertEquals(got.json.result.item.stem, "Which value of r indicates the strongest linear relationship?");
  assert(!got.text.includes("owner_key"));

  // Edit and confirm through the capability.
  const upd = await h.call({ operation: "capture_review_update", pairing_handle: a.handle, stem: "Edited on the phone", topic_code: "2.5", confirm: true });
  assertEquals(upd.status, 200, upd.text);
  assertEquals(upd.json.result.item.status, "ready");
  assertEquals(upd.json.result.item.stem, "Edited on the phone");
  assertEquals(h.mem.items.find((i) => i.id === b.item.id)!.stem, null, "the other item is untouched");

  // The other item's handle cannot see item A.
  const cross = await h.call({ operation: "capture_review_get", pairing_handle: b.handle });
  assertEquals(cross.json.result.item.id, b.item.id);

  // A response-role pairing is not reviewable.
  const resp = await h.call({ operation: "save_response", owner_key: a.key, item_id: a.item.id, selected_choice_key: "A", is_final: true });
  assertEquals(resp.status, 200, resp.text);
  const rm = await h.call({ operation: "mint_pairing", owner_key: a.key, item_id: a.item.id, capture_role: "response", response_id: resp.json.result.response.id });
  const rr = await h.call({ operation: "capture_review_get", pairing_handle: rm.json.result.pairing_handle });
  assertEquals(rr.status, 409);
  assertEquals(rr.json.error, "pairing_not_reviewable");

  // Garbage, cancelled, and out-of-window handles are refused.
  assertEquals((await h.call({ operation: "capture_review_get", pairing_handle: "nope" })).status, 400);
  const tok = h.mem.tokens.find((t) => t.item_id === a.item.id && t.capture_role === "question")!;
  (tok as TokenRow & { consumed_at?: string }).consumed_at = new Date(Date.now() - 31 * 60_000).toISOString();
  const late = await h.call({ operation: "capture_review_get", pairing_handle: a.handle });
  assertEquals(late.status, 409);
  assertEquals(late.json.error, "review_window_closed");
  const cancelled = await h.call({ operation: "capture_review_get", pairing_handle: b.handle });
  assertEquals(cancelled.status, 200);
  tok.state = "cancelled";
  const tokB = h.mem.tokens.find((t) => t.item_id === b.item.id)!;
  tokB.state = "cancelled";
  assertEquals((await h.call({ operation: "capture_review_get", pairing_handle: b.handle })).json.error, "pairing_cancelled");
});

Deno.test("remove_flagged_text through the capability clears the backstop flag and lets the student confirm", async () => {
  const h = extractionHarness(() => proposed({ stem: "What is 2 + 2?\nAnswer: 4", item_type: "frq", choices: [] }));
  const a = await photoItem(h, { subject_key: "ap_statistics" });
  await h.call({ operation: "finish_capture", pairing_handle: a.handle });
  const cleaned = await h.call({ operation: "capture_review_remove_flagged_text", pairing_handle: a.handle });
  assertEquals(cleaned.status, 200, cleaned.text);
  assertEquals(cleaned.json.result.item.answer_text_detected, false);
  assertEquals(cleaned.json.result.item.stem, "What is 2 + 2?");
  const ok = await h.call({ operation: "capture_review_update", pairing_handle: a.handle, confirm: true });
  assertEquals(ok.json.result.item.status, "ready");
});

Deno.test("extract_question is rate-limited with the pairing-mint window and refuses an archived item", async () => {
  const h = extractionHarness(() => proposed());
  const a = await photoItem(h, { subject_key: "ap_statistics" });
  await h.call({ operation: "archive_item", owner_key: a.key, item_id: a.item.id });
  const r = await h.call({ operation: "extract_question", owner_key: a.key, item_id: a.item.id, force: true });
  assertEquals(r.status, 409);
  assertEquals(r.json.error, "item_archived");
});
