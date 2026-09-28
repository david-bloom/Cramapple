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

  // --- store
  async profileExists(u: string) { return this.profiles.has(u); }
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
  async insertToken(r: Omit<TokenRow, "id" | "created_at" | "state" | "access_path" | "redemption_attempts" | "uploads_bound">) {
    const t: TokenRow = { id: this.id(), created_at: this.ts(), state: "issued", access_path: null, redemption_attempts: 0, uploads_bound: 0, ...r };
    this.tokens.push(t);
    return { ...t };
  }
  async getTokenByHash(h: string) { const t = this.tokens.find((x) => x.handle_sha256 === h); return t ? { ...t } : null; }
  async getTokenById(id: string) { const t = this.tokens.find((x) => x.id === id); return t ? { ...t } : null; }
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
      pixel_width: p.width, pixel_height: p.height, is_current: true, created_at: this.ts(), pairing_token_id: t.id,
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

  // --- storage
  async signUpload(path: string) { return { signedUrl: `https://upload/${path}`, token: "tok" }; }
  async download(path: string) { return this.objects.get(path) ?? null; }
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
  const call = async (body: Record<string, unknown>, opts: { jwt?: string; ip?: string; bearer?: string } = {}) => {
    const headers: Record<string, string> = { "content-type": "application/json", "x-forwarded-for": opts.ip ?? "203.0.113.9" };
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

Deno.test("anonymous start issues an owner key once; presenting it reuses the owner", async () => {
  const { mem, call } = harness();
  const first = await call({ operation: "start" });
  assertEquals(first.status, 200);
  const key = first.json.result.owner_key;
  assert(typeof key === "string" && key.startsWith("byoq_"));
  assertEquals(first.json.result.recognized, false);
  const second = await call({ operation: "start", owner_key: key });
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
  const other = await call({ operation: "start" }, { ip: "198.51.100.1" });
  const otherKey = other.json.result.owner_key;
  const get = await call({ operation: "get_item", owner_key: otherKey, item_id: item.id });
  assertEquals(get.status, 404);
  const list = await call({ operation: "list_items", owner_key: otherKey });
  assertEquals(list.json.result.items, []);
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
  const anon = await call({ operation: "start" }, { jwt: fakeJwt("anon", "") });
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

Deno.test("anonymous owner creation is rate-limited per IP", async () => {
  const { call } = harness();
  for (let i = 0; i < 20; i++) assertEquals((await call({ operation: "start" }, { ip: "192.0.2.7" })).status, 200);
  const limited = await call({ operation: "start" }, { ip: "192.0.2.7" });
  assertEquals(limited.status, 429);
  assertEquals((await call({ operation: "start" }, { ip: "192.0.2.8" })).status, 200);
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
