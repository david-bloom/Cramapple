// byoq -- bring-your-own-question backend (TASK-0039).
//
// One function for the whole BYOQ surface: intake (typed and photo-first),
// the answer-leak gate, practice responses, QR/phone capture of the question
// photo and of hand-drawn response pages, and retention cleanup.
//
// GOVERNING RULES
// ---------------
// * DECISION-0057: nothing here ever produces a verdict, a correct choice, a
//   score, or an answer key. No operation accepts or returns one; the tables
//   cannot hold one. BYOQ items are never Open Hand.
// * DECISION-0068 (Option A): no import from, call into, or row in the graded
//   pipeline (attempts / response_versions / evaluate-attempt /
//   capture-pairing). The only shared code is pure validation
//   (_shared/capture-attachment.ts, _shared/image-metadata.ts).
// * DECISION-0077: identity-agnostic. A caller is either
//     - recognized: a valid Supabase user JWT (recognition only, never a gate), or
//     - anonymous: an owner key this function issued (`byoq_...`), sent in the body.
//   Both get identical behaviour.
//
// AUTHENTICATION MODEL
// --------------------
// Deployed with gateway JWT verification OFF, because anonymous marketing
// visitors must reach it. Authentication is done here instead:
//   owner operations      -> verified user JWT and/or owner key
//   phone operations      -> a capture capability (`bqcap_...`), hash-looked-up
//   purge                 -> the service-role key as bearer
// Only SHA-256 hashes of owner keys and capabilities are stored.

import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { getBearerToken } from "../_shared/auth.ts";
import { sha256HexOfBytes, validateCaptureObject } from "../_shared/capture-attachment.ts";
import { stripImageMetadata } from "../_shared/image-metadata.ts";
import {
  ACCEPTED_MEDIA_TYPES,
  BYOQ_LIMITS,
  BYOQ_PAIRING_TTL_SECONDS,
  type ByoqMediaType,
  type ChoiceInput,
  clientIp,
  detectAnswerLeaks,
  finalPath,
  generateCaptureHandle,
  generateItemCode,
  generateOwnerKey,
  hmacSha256Hex,
  incomingPrefix,
  isSafeByoqPath,
  isWellFormedCaptureHandle,
  isWellFormedOwnerKey,
  type ItemFields,
  maskedView,
  NOT_SCORED_MESSAGE,
  ownerStoragePrefix,
  readinessProblem,
  removeFlaggedText,
  sha256Hex,
  uploadPath,
  validateItemFields,
  validateResponseInput,
} from "../_shared/byoq.ts";
import {
  type AttachmentRow,
  type ByoqStorage,
  type ByoqStore,
  createSupabaseStorage,
  createSupabaseStore,
  type ItemRow,
  type OwnerRow,
  StoreRpcError,
  type TokenRow,
} from "./store.ts";

type Json = Record<string, unknown>;

const OWNER_OPERATIONS = new Set([
  "start",
  "create_item",
  "update_item",
  "remove_flagged_text",
  "confirm_item",
  "get_item",
  "list_items",
  "archive_item",
  "delete_item",
  "save_response",
  "mint_pairing",
  "pairing_status",
  "cancel_pairing",
  "remove_attachment",
]);
const PUBLIC_OPERATIONS = new Set(["list_subjects", "list_topics"]);
const CAPTURE_OPERATIONS = new Set([
  "describe_capture",
  "create_capture_upload",
  "submit_capture",
  "finish_capture",
]);
const CREATES_OWNER = new Set(["start", "create_item"]);
const LIVE_STATES = ["issued", "paired", "uploaded"] as const;
const SIGNED_READ_SECONDS = 10 * 60;

export interface ByoqDeps {
  store?: ByoqStore;
  storage?: ByoqStorage;
  /** Verifies a user JWT; returns the user id or null. */
  verifyUser?: (jwt: string) => Promise<string | null>;
  serviceRoleKey?: string;
  ipHmacKey?: string;
  now?: () => Date;
}

class HttpError extends Error {
  constructor(public status: number, public code: string, public extra: Json = {}) {
    super(code);
  }
}

function asUuid(v: unknown): string | null {
  return typeof v === "string" && /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(v) ? v : null;
}

function decodeJwtRole(jwt: string): string | null {
  const part = jwt.split(".")[1];
  if (!part) return null;
  try {
    const json = JSON.parse(atob(part.replaceAll("-", "+").replaceAll("_", "/")));
    return typeof json?.role === "string" ? json.role : null;
  } catch {
    return null;
  }
}

/* -------------------------------------------------------------------------- */
/* Views: the only shapes that ever leave this function                        */
/* -------------------------------------------------------------------------- */

function itemView(item: ItemRow, opts: { reveal?: boolean; topic?: unknown } = {}) {
  const flagged = item.leak_flags.length > 0;
  const masked = flagged && !opts.reveal;
  const text = masked
    ? maskedView(item.stem, item.choices, item.leak_flags)
    : { stem: item.stem, choices: item.choices };
  return {
    id: item.id,
    code: item.code,
    source: "student",
    item_type: item.item_type,
    title: item.title,
    stem: text.stem,
    choices: text.choices,
    subject_key: item.subject_key,
    topic: opts.topic ?? null,
    difficulty: item.difficulty,
    source_kind: item.source_kind,
    source_note: item.source_note,
    status: item.status,
    answer_text_detected: flagged,
    text_masked: masked,
    readiness_problem: item.status === "ready" ? null : readinessProblem(item),
    recognized: item.user_id !== null,
    created_at: item.created_at,
    updated_at: item.updated_at,
    confirmed_at: item.confirmed_at,
    last_practiced_at: item.last_practiced_at,
    scoring: { scored: false, message: NOT_SCORED_MESSAGE },
  };
}

function tokenView(t: TokenRow) {
  return {
    pairing_id: t.id,
    state: t.state,
    capture_role: t.capture_role,
    response_id: t.response_id,
    part_key: t.part_key,
    generation: t.generation,
    expires_at: t.expires_at,
    uploads_bound: t.uploads_bound,
    attempts_remaining: Math.max(0, BYOQ_LIMITS.pairingMaxRedemptions - t.redemption_attempts),
  };
}

async function attachmentViews(storage: ByoqStorage, rows: AttachmentRow[]) {
  return await Promise.all(rows.map(async (a) => ({
    id: a.id,
    capture_role: a.capture_role,
    response_id: a.response_id,
    part_key: a.part_key,
    page_sequence: a.page_sequence,
    media_type: a.media_type,
    pixel_width: a.pixel_width,
    pixel_height: a.pixel_height,
    url: await storage.signRead(a.storage_path, SIGNED_READ_SECONDS),
    created_at: a.created_at,
  })));
}

/* -------------------------------------------------------------------------- */
/* Handler                                                                     */
/* -------------------------------------------------------------------------- */

export async function handleByoq(req: Request, deps: ByoqDeps = {}): Promise<Response> {
  const respond = (body: unknown, init: ResponseInit = {}) => jsonResponse(body, init, req);
  if (req.method === "OPTIONS") return respond({ ok: true });
  if (req.method !== "POST") return respond({ error: "method_not_allowed" }, { status: 405 });

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const b = body as Json;
  const operation = typeof b.operation === "string" ? b.operation : "";

  const client = deps.store && deps.storage ? null : createServiceClient();
  const store = deps.store ?? createSupabaseStore(client);
  const storage = deps.storage ?? createSupabaseStorage(client);
  const now = deps.now ?? (() => new Date());
  const serviceRoleKey = deps.serviceRoleKey ?? Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
    Deno.env.get("SERVICE_ROLE_KEY") ?? "";
  const ipHmacKey = deps.ipHmacKey ?? Deno.env.get("BYOQ_IP_HMAC_KEY") ?? serviceRoleKey;
  const verifyUser = deps.verifyUser ?? (async (jwt: string) => {
    const { data, error } = await (client ?? createServiceClient()).auth.getUser(jwt);
    return error || !data?.user ? null : data.user.id;
  });

  const ctx: Ctx = { req, b, store, storage, now, ipHmacKey };

  try {
    if (operation === "purge") {
      if (!serviceRoleKey || getBearerToken(req) !== serviceRoleKey) {
        return respond({ error: "forbidden" }, { status: 403 });
      }
      const purged = await purgeStaleAnonymousOwners(ctx, 50);
      return respond({ status: "ok", operation, result: { purged_owners: purged } });
    }
    if (PUBLIC_OPERATIONS.has(operation)) {
      return respond({ status: "ok", operation, result: await publicOperation(ctx, operation) });
    }
    if (CAPTURE_OPERATIONS.has(operation)) {
      return respond({ status: "ok", operation, result: await captureOperation(ctx, operation) });
    }
    if (!OWNER_OPERATIONS.has(operation)) {
      return respond({ error: "invalid_operation" }, { status: 400 });
    }

    const caller = await resolveCaller(ctx, verifyUser, CREATES_OWNER.has(operation));
    const result = await ownerOperation(ctx, caller, operation);
    if (caller.issuedOwnerKey) (result as Json).owner_key = caller.issuedOwnerKey;
    (result as Json).recognized = caller.userId !== null;
    if (operation === "start") scheduleOpportunisticPurge(ctx);
    return respond({ status: "ok", operation, result });
  } catch (error) {
    if (error instanceof HttpError) {
      return respond({ error: error.code, ...error.extra }, { status: error.status });
    }
    console.error("byoq_failed", operation, error instanceof Error ? error.message : String(error));
    return respond({ error: "byoq_failed" }, { status: 500 });
  }
}

interface Ctx {
  req: Request;
  b: Json;
  store: ByoqStore;
  storage: ByoqStorage;
  now: () => Date;
  ipHmacKey: string;
}

interface Caller {
  userId: string | null;
  /** Owner that new items are created under. */
  primary: OwnerRow | null;
  /** Every owner whose items this caller may access. */
  ownerIds: string[];
  issuedOwnerKey: string | null;
}

/* -------------------------------------------------------------------------- */
/* Caller resolution (DECISION-0077)                                          */
/* -------------------------------------------------------------------------- */

async function resolveCaller(
  ctx: Ctx,
  verifyUser: (jwt: string) => Promise<string | null>,
  mayCreate: boolean,
): Promise<Caller> {
  const { store, b } = ctx;
  let userId: string | null = null;
  const bearer = getBearerToken(ctx.req);
  // The anon/publishable key is not a user; only a token claiming the
  // `authenticated` role is worth verifying. A claimed-but-invalid user token
  // is a 401 (so the client refreshes) rather than a silent downgrade to an
  // anonymous identity.
  if (bearer && decodeJwtRole(bearer) === "authenticated") {
    userId = await verifyUser(bearer);
    if (!userId) throw new HttpError(401, "session_expired");
    if (!(await store.profileExists(userId))) userId = null;
  }

  let keyOwner: OwnerRow | null = null;
  if (b.owner_key !== undefined && b.owner_key !== null) {
    if (!isWellFormedOwnerKey(b.owner_key)) throw new HttpError(400, "invalid_owner_key");
    keyOwner = await store.findOwnerByKeyHash(await sha256Hex(b.owner_key));
  }

  if (userId) {
    // Recognition: an anonymous owner this browser already holds becomes the
    // student's, so work started before signing in follows them. An owner
    // already recognized as someone else is simply ignored.
    if (keyOwner && keyOwner.user_id === null) {
      await store.linkOwnerToUser(keyOwner.id, userId);
    }
    let primary = await store.findKeylessOwnerForUser(userId);
    if (!primary && mayCreate) {
      primary = await store.insertOwner({ key_sha256: null, user_id: userId, created_ip_hmac: null });
    }
    if (primary) await store.touchOwner(primary.id);
    return { userId, primary, ownerIds: await store.ownerIdsForUser(userId), issuedOwnerKey: null };
  }

  if (keyOwner) {
    if (keyOwner.user_id !== null) {
      // This key's work now belongs to a signed-in student; an anonymous
      // holder of the same key no longer gets in without signing in.
      throw new HttpError(401, "sign_in_required");
    }
    await store.touchOwner(keyOwner.id);
    return { userId: null, primary: keyOwner, ownerIds: [keyOwner.id], issuedOwnerKey: null };
  }

  if (!mayCreate) {
    return { userId: null, primary: null, ownerIds: [], issuedOwnerKey: null };
  }

  const ip = clientIp(ctx.req);
  const ipHmac = ip ? await hmacSha256Hex(ctx.ipHmacKey, `byoq-ip:${ip}`) : null;
  if (ipHmac) {
    const since = new Date(ctx.now().getTime() - 3600_000).toISOString();
    if (await store.countOwnersFromIpSince(ipHmac, since) >= BYOQ_LIMITS.ownersPerIpPerHour) {
      throw new HttpError(429, "rate_limited", { retry_after_seconds: 3600 });
    }
  }
  const ownerKey = generateOwnerKey();
  const owner = await store.insertOwner({
    key_sha256: await sha256Hex(ownerKey),
    user_id: null,
    created_ip_hmac: ipHmac,
  });
  return { userId: null, primary: owner, ownerIds: [owner.id], issuedOwnerKey: ownerKey };
}

async function ownedItem(ctx: Ctx, caller: Caller, raw: unknown): Promise<ItemRow> {
  const id = asUuid(raw);
  if (!id) throw new HttpError(400, "missing_required_fields", { required: ["item_id"] });
  const item = await ctx.store.getItem(id);
  // Same 404 for "missing" and "not yours": no existence oracle.
  if (!item || !caller.ownerIds.includes(item.owner_id)) throw new HttpError(404, "item_not_found");
  return item;
}

async function topicFor(ctx: Ctx, item: ItemRow) {
  if (!item.taxonomy_topic_id) return null;
  const t = await ctx.store.topicById(item.taxonomy_topic_id);
  return t
    ? {
      subject_key: t.subject_key,
      unit_number: t.unit_number,
      unit_title: t.unit_title,
      topic_code: t.topic_code,
      topic_title: t.topic_title,
    }
    : null;
}

/** Applies validated fields to an item patch, resolving the topic and re-running the leak heuristic. */
async function buildPatch(ctx: Ctx, current: ItemRow | null, fields: ItemFields) {
  const patch: Partial<ItemRow> = {};
  for (const k of ["item_type", "title", "stem", "choices", "difficulty", "source_kind", "source_note"] as const) {
    if (fields[k] !== undefined) (patch as Json)[k] = fields[k];
  }
  const itemType = patch.item_type !== undefined ? patch.item_type : current?.item_type ?? null;
  if (itemType === "frq" && fields.choices === undefined && (current?.choices.length ?? 0) > 0) {
    patch.choices = [];
  }
  if (itemType === "frq" && (patch.choices?.length ?? 0) > 0) {
    throw new HttpError(422, "frq_has_choices");
  }

  if (fields.subject_key !== undefined || fields.topic_code !== undefined) {
    const subject = fields.subject_key !== undefined ? fields.subject_key : current?.subject_key ?? null;
    patch.subject_key = subject;
    if (fields.topic_code) {
      if (!subject) throw new HttpError(422, "subject_required_for_topic");
      const topic = await ctx.store.resolveTopic(subject, fields.unit_number ?? null, fields.topic_code);
      if (!topic) throw new HttpError(422, "unknown_topic");
      patch.taxonomy_topic_id = topic.taxonomy_topic_id;
    } else if (fields.topic_code === null || fields.subject_key !== undefined) {
      patch.taxonomy_topic_id = null;
    }
    if (subject && !(await ctx.store.listSubjects()).includes(subject)) {
      throw new HttpError(422, "unknown_subject");
    }
  }

  const stem = patch.stem !== undefined ? patch.stem : current?.stem ?? null;
  const choices: ChoiceInput[] = patch.choices !== undefined ? patch.choices : current?.choices ?? [];
  patch.leak_flags = detectAnswerLeaks(stem, choices);
  return patch;
}

/* -------------------------------------------------------------------------- */
/* Public (no identity) operations                                             */
/* -------------------------------------------------------------------------- */

async function publicOperation(ctx: Ctx, operation: string): Promise<Json> {
  if (operation === "list_subjects") {
    return { subjects: await ctx.store.listSubjects() };
  }
  const subject = typeof ctx.b.subject_key === "string" ? ctx.b.subject_key.replaceAll("-", "_") : "";
  if (!/^[a-z0-9_]{2,64}$/.test(subject)) throw new HttpError(400, "invalid_subject_key");
  const topics = await ctx.store.listTopics(subject);
  if (!topics.length) throw new HttpError(404, "unknown_subject");
  const units = new Map<number, { unit_number: number; unit_title: string; topics: Json[] }>();
  for (const t of topics) {
    if (!units.has(t.unit_number)) units.set(t.unit_number, { unit_number: t.unit_number, unit_title: t.unit_title, topics: [] });
    units.get(t.unit_number)!.topics.push({ topic_code: t.topic_code, topic_title: t.topic_title });
  }
  return { subject_key: subject, units: [...units.values()] };
}

/* -------------------------------------------------------------------------- */
/* Owner operations                                                            */
/* -------------------------------------------------------------------------- */

async function ownerOperation(ctx: Ctx, caller: Caller, operation: string): Promise<Json> {
  const { store, storage, b } = ctx;

  switch (operation) {
    case "start":
      return { owner_ready: caller.primary !== null };

    case "list_items": {
      const items = await store.listItems(caller.ownerIds);
      return {
        items: items.map((i) => {
          const v = itemView(i);
          return { ...v, stem: v.stem && v.stem.length > 200 ? `${v.stem.slice(0, 200)}…` : v.stem };
        }),
      };
    }

    case "create_item": {
      if (!caller.primary) throw new HttpError(500, "owner_unavailable");
      const fields = validateItemFields(b);
      if (!fields.ok) throw new HttpError(422, fields.error);
      const dayAgo = new Date(ctx.now().getTime() - 86400_000).toISOString();
      if (await store.countItemsCreatedSince(caller.primary.id, dayAgo) >= BYOQ_LIMITS.itemsPerOwnerPerDay) {
        throw new HttpError(429, "daily_item_limit_reached");
      }
      if (await store.countLiveItems(caller.ownerIds) >= BYOQ_LIMITS.itemsPerOwnerTotal) {
        throw new HttpError(429, "item_limit_reached");
      }
      const patch = await buildPatch(ctx, null, fields.value);
      let item: ItemRow | null = null;
      for (let i = 0; i < 4 && !item; i++) {
        try {
          item = await store.insertItem({
            ...patch,
            owner_id: caller.primary.id,
            user_id: caller.userId,
            code: generateItemCode(),
          });
        } catch (e) {
          if (!(e instanceof Error) || !e.message.includes("byoq_items_code_unique_per_owner") || i === 3) throw e;
        }
      }
      if (b.confirm === true) item = await confirm(ctx, item!);
      return { item: itemView(item!, { topic: await topicFor(ctx, item!) }) };
    }

    case "update_item": {
      const item = await ownedItem(ctx, caller, b.item_id);
      if (item.status === "archived") throw new HttpError(409, "item_archived");
      const fields = validateItemFields(b);
      if (!fields.ok) throw new HttpError(422, fields.error);
      const patch = await buildPatch(ctx, item, fields.value);
      const merged = { ...item, ...patch } as ItemRow;
      // An edit can make a practiced item invalid again (e.g. pasting an
      // answer back in); it drops to draft rather than failing the DB check.
      if (item.status === "ready" && readinessProblem(merged)) patch.status = "draft";
      let updated = await store.updateItem(item.id, patch);
      if (b.confirm === true) updated = await confirm(ctx, updated);
      return { item: itemView(updated, { topic: await topicFor(ctx, updated) }) };
    }

    case "remove_flagged_text": {
      const item = await ownedItem(ctx, caller, b.item_id);
      const cleaned = removeFlaggedText(item.stem, item.choices, item.leak_flags);
      const choices = cleaned.choices.filter((c) => c.choice_text.length > 0)
        .map((c, i) => ({ choice_key: String.fromCharCode(65 + i), choice_text: c.choice_text }));
      const patch: Partial<ItemRow> = {
        stem: cleaned.stem,
        choices,
        leak_flags: detectAnswerLeaks(cleaned.stem, choices),
      };
      if (item.status === "ready" && readinessProblem({ ...item, ...patch } as ItemRow)) patch.status = "draft";
      const updated = await store.updateItem(item.id, patch);
      return { item: itemView(updated, { topic: await topicFor(ctx, updated) }) };
    }

    case "confirm_item": {
      const item = await ownedItem(ctx, caller, b.item_id);
      const updated = await confirm(ctx, item);
      return { item: itemView(updated, { topic: await topicFor(ctx, updated) }) };
    }

    case "get_item": {
      const item = await ownedItem(ctx, caller, b.item_id);
      const topic = await topicFor(ctx, item);
      const guides = topic
        ? await store.topicGuides(topic.subject_key, topic.unit_number, topic.topic_code)
        : null;
      const attachments = await attachmentViews(storage, await store.listAttachments(item.id));
      const responses = await store.listResponses(item.id);
      return {
        item: itemView(item, { reveal: b.reveal === true, topic }),
        // Reference material is CramApple-authored library content, permitted
        // under DECISION-0057. Null topic means the student has not picked
        // one yet -- the UI says so rather than rendering nothing.
        reference: topic ? { guides, missing: !guides || (!guides.briefs.length && !guides.explainers.length) } : null,
        attachments,
        responses,
      };
    }

    case "archive_item": {
      const item = await ownedItem(ctx, caller, b.item_id);
      const updated = await store.updateItem(item.id, { status: "archived" });
      return { item: itemView(updated) };
    }

    case "delete_item": {
      const item = await ownedItem(ctx, caller, b.item_id);
      const owner = await store.getOwnerById(item.owner_id);
      await removeItemObjects(ctx, owner!, item.id);
      await store.deleteItem(item.id);
      return { deleted: true };
    }

    case "save_response": {
      const item = await ownedItem(ctx, caller, b.item_id);
      if (item.status !== "ready") throw new HttpError(409, "item_not_ready", { readiness_problem: readinessProblem(item) });
      const input = validateResponseInput(b, item.item_type!, item.choices.length);
      if (!input.ok) throw new HttpError(422, input.error);
      const prior = await store.listResponses(item.id);
      if (prior.length >= BYOQ_LIMITS.responsesPerItem) throw new HttpError(429, "response_limit_reached");
      const lastAttempt = prior.reduce((m, r) => Math.max(m, r.attempt_number), 0);
      const inLast = prior.filter((r) => r.attempt_number === lastAttempt);
      const lastRow = inLast[inLast.length - 1] ?? null;
      const newAttempt = b.new_attempt === true || !lastRow || lastRow.is_final;
      const attempt = newAttempt ? lastAttempt + 1 : lastAttempt;
      const version = newAttempt ? 1 : lastRow!.version_number + 1;
      const response = await store.insertResponse({
        item_id: item.id,
        owner_id: item.owner_id,
        attempt_number: attempt,
        version_number: version,
        parent_response_id: newAttempt ? null : lastRow!.id,
        ...input.value,
      });
      await store.updateItem(item.id, { last_practiced_at: ctx.now().toISOString() });
      // No verdict, no correct choice, no score: DECISION-0057.
      return { response, scoring: { scored: false, message: NOT_SCORED_MESSAGE } };
    }

    case "mint_pairing":
      return await mintPairing(ctx, caller);

    case "pairing_status":
    case "cancel_pairing": {
      const id = asUuid(b.pairing_id);
      if (!id) throw new HttpError(400, "missing_required_fields", { required: ["pairing_id"] });
      let token = await store.getTokenById(id);
      if (!token || !caller.ownerIds.includes(token.owner_id)) throw new HttpError(404, "pairing_not_found");
      if (operation === "cancel_pairing") {
        token = await store.transitionToken(token.id, [...LIVE_STATES], {
          state: "cancelled",
          closed_at: ctx.now().toISOString(),
        }) ?? token;
        return { pairing: tokenView(token) };
      }
      token = await expireIfLapsed(ctx, token);
      const pages = (await store.listAttachments(token.item_id)).filter((a) =>
        a.capture_role === token!.capture_role && a.response_id === token!.response_id && a.part_key === token!.part_key
      );
      return { pairing: tokenView(token), pages: await attachmentViews(storage, pages) };
    }

    case "remove_attachment": {
      const id = asUuid(b.attachment_id);
      if (!id) throw new HttpError(400, "missing_required_fields", { required: ["attachment_id"] });
      const att = await store.getAttachment(id);
      if (!att || !caller.ownerIds.includes(att.owner_id)) throw new HttpError(404, "attachment_not_found");
      await storage.remove([att.storage_path]);
      await store.deleteAttachment(att.id);
      return { removed: true };
    }
  }
  throw new HttpError(400, "invalid_operation");
}

async function confirm(ctx: Ctx, item: ItemRow): Promise<ItemRow> {
  if (item.status === "archived") throw new HttpError(409, "item_archived");
  const problem = readinessProblem(item);
  if (problem) throw new HttpError(409, "item_not_ready", { readiness_problem: problem, item: itemView(item) });
  if (item.status === "ready") return item;
  return await ctx.store.updateItem(item.id, { status: "ready", confirmed_at: ctx.now().toISOString() });
}

async function mintPairing(ctx: Ctx, caller: Caller): Promise<Json> {
  const { store, b } = ctx;
  const item = await ownedItem(ctx, caller, b.item_id);
  if (item.status === "archived") throw new HttpError(409, "item_archived");
  const role = b.capture_role;
  if (role !== "question" && role !== "response") throw new HttpError(400, "invalid_capture_role");
  let responseId: string | null = null;
  if (role === "response") {
    if (item.status !== "ready") throw new HttpError(409, "item_not_ready");
    responseId = asUuid(b.response_id);
    if (!responseId) throw new HttpError(400, "missing_required_fields", { required: ["response_id"] });
    if (!(await store.listResponses(item.id)).some((r) => r.id === responseId)) {
      throw new HttpError(404, "response_not_found");
    }
  }
  const partKey = b.part_key === undefined || b.part_key === null ? "whole" : b.part_key;
  if (typeof partKey !== "string" || !/^[a-z0-9_]{1,32}$/.test(partKey)) throw new HttpError(400, "invalid_part_key");

  const windowStart = new Date(ctx.now().getTime() - BYOQ_LIMITS.pairingMintWindowSeconds * 1000).toISOString();
  if (await store.countMintsSince(item.owner_id, windowStart) >= BYOQ_LIMITS.pairingMintMaxPerWindow) {
    throw new HttpError(429, "pairing_rate_limited", { retry_after_seconds: BYOQ_LIMITS.pairingMintWindowSeconds });
  }

  // Re-minting invalidates the previous code for this slot; otherwise the
  // old QR stays a live write channel.
  const superseded = await store.cancelLiveTokens({
    item_id: item.id,
    capture_role: role,
    response_id: responseId,
    part_key: partKey,
  });
  const handle = generateCaptureHandle();
  const token = await store.insertToken({
    handle_sha256: await sha256Hex(handle),
    owner_id: item.owner_id,
    item_id: item.id,
    capture_role: role,
    response_id: responseId,
    part_key: partKey,
    generation: superseded.reduce((m, g) => Math.max(m, g), 0) + 1,
    expires_at: new Date(ctx.now().getTime() + BYOQ_PAIRING_TTL_SECONDS * 1000).toISOString(),
  });
  return {
    // The one and only time the capability is returned.
    pairing_handle: handle,
    ttl_seconds: BYOQ_PAIRING_TTL_SECONDS,
    pairing: tokenView(token),
  };
}

async function expireIfLapsed(ctx: Ctx, token: TokenRow): Promise<TokenRow> {
  if ((LIVE_STATES as readonly string[]).includes(token.state) && new Date(token.expires_at) <= ctx.now()) {
    const done = token.uploads_bound > 0;
    return await ctx.store.transitionToken(token.id, [...LIVE_STATES], {
      state: done ? "consumed" : "expired",
      closed_at: ctx.now().toISOString(),
    }) ?? token;
  }
  return token;
}

/* -------------------------------------------------------------------------- */
/* Phone (capability-authenticated) operations                                 */
/* -------------------------------------------------------------------------- */

const CAPTURE_ERRORS: Record<string, [number, string]> = {
  not_found: [404, "pairing_not_found"],
  already_used: [409, "pairing_already_used"],
  cancelled: [409, "pairing_cancelled"],
  rejected: [409, "pairing_attempts_exhausted"],
  expired: [409, "pairing_expired"],
  pairing_not_found: [404, "pairing_not_found"],
  pairing_not_live: [409, "pairing_not_live"],
  pairing_expired: [409, "pairing_expired"],
  invalid_retake_target: [409, "invalid_retake_target"],
  stale_retake_target: [409, "stale_retake_target"],
  page_limit_reached: [409, "page_limit_reached"],
};

function mapRpcError(e: unknown): HttpError {
  if (e instanceof StoreRpcError) {
    const reason = e.message.split(":").pop() ?? "";
    const mapped = CAPTURE_ERRORS[reason];
    if (mapped) return new HttpError(mapped[0], mapped[1]);
  }
  throw e;
}

async function liveTokenForHandle(ctx: Ctx): Promise<TokenRow> {
  const handle = ctx.b.pairing_handle;
  if (!isWellFormedCaptureHandle(handle)) throw new HttpError(400, "invalid_pairing_handle");
  const token = await ctx.store.getTokenByHash(await sha256Hex(handle));
  if (!token) throw new HttpError(404, "pairing_not_found");
  const current = await expireIfLapsed(ctx, token);
  const terminal: Record<string, string> = {
    consumed: "pairing_already_used",
    expired: "pairing_expired",
    cancelled: "pairing_cancelled",
    rejected: "pairing_attempts_exhausted",
  };
  if (terminal[current.state]) throw new HttpError(409, terminal[current.state]);
  return current;
}

async function captureOperation(ctx: Ctx, operation: string): Promise<Json> {
  const { store, storage, b } = ctx;

  if (operation === "describe_capture") {
    let token = await liveTokenForHandle(ctx);
    if (token.state === "issued") {
      token = await store.transitionToken(token.id, ["issued"], {
        state: "paired",
        paired_at: ctx.now().toISOString(),
        access_path: b.access_path === "FALLBACK_DIRECT" ? "FALLBACK_DIRECT" : "QR",
      }) ?? token;
    }
    const item = await store.getItem(token.item_id);
    return {
      pairing: tokenView(token),
      item_code: item?.code ?? null,
      accepted_media_types: ACCEPTED_MEDIA_TYPES,
      guidance: {
        steps: token.capture_role === "question"
          ? [
            "Photograph just the question you want to practice.",
            "Lay the page flat, with even light and no glare.",
            "Fit the whole question in the frame. Add another photo if it runs onto a second page.",
          ]
          : [
            "Photograph your own work for this question.",
            "Lay the page flat, with even light and no glare.",
            "Add one photo per page, in order.",
          ],
        privacy: "Don't include your name, your school, or anyone else's work or personal details in the photo. Location data is removed from your photo when it's saved.",
      },
    };
  }

  if (operation === "create_capture_upload") {
    const mediaType = (typeof b.media_type === "string" ? b.media_type : "image/jpeg") as ByoqMediaType;
    if (!(ACCEPTED_MEDIA_TYPES as readonly string[]).includes(mediaType)) {
      throw new HttpError(415, "unsupported_media_type");
    }
    const handle = b.pairing_handle;
    if (!isWellFormedCaptureHandle(handle)) throw new HttpError(400, "invalid_pairing_handle");
    let token: TokenRow;
    try {
      token = await store.claimUpload(
        await sha256Hex(handle),
        BYOQ_LIMITS.pairingMaxRedemptions,
        b.access_path === "FALLBACK_DIRECT" ? "FALLBACK_DIRECT" : "QR",
      );
    } catch (e) {
      throw mapRpcError(e);
    }
    if (token.state === "expired") throw new HttpError(409, "pairing_expired");
    if (token.state === "rejected") throw new HttpError(409, "pairing_attempts_exhausted");
    const owner = await store.getOwnerById(token.owner_id);
    if (!owner) throw new HttpError(404, "pairing_not_found");
    const path = uploadPath({ owner, itemId: token.item_id, pairingId: token.id, attempt: token.redemption_attempts, mediaType });
    if (!isSafeByoqPath(path)) throw new HttpError(500, "invalid_storage_path");
    const signed = await storage.signUpload(path);
    return { storage_path: path, signed_url: signed.signedUrl, upload_token: signed.token, pairing: tokenView(token) };
  }

  if (operation === "submit_capture") {
    const token = await liveTokenForHandle(ctx);
    const owner = await store.getOwnerById(token.owner_id);
    if (!owner) throw new HttpError(404, "pairing_not_found");
    const path = typeof b.storage_path === "string" ? b.storage_path : "";
    // A capability may only submit an object inside its own incoming folder,
    // whose name is its own id -- which a different capability cannot produce.
    if (!isSafeByoqPath(path) || !path.startsWith(incomingPrefix(owner, token.item_id, token.id))) {
      throw new HttpError(400, "invalid_storage_path");
    }
    const replaces = b.replaces_attachment_id === undefined || b.replaces_attachment_id === null
      ? null
      : asUuid(b.replaces_attachment_id);
    if (b.replaces_attachment_id && !replaces) throw new HttpError(400, "invalid_replaces_attachment_id");

    const raw = await storage.download(path);
    if (!raw) throw new HttpError(404, "capture_object_not_found");
    const validation = await validateCaptureObject({ bytes: raw });
    if (!validation.ok) {
      await storage.remove([path]).catch(() => {});
      throw new HttpError(422, validation.reason, { failure_class: "blocked" });
    }
    // Only the metadata-stripped copy is kept: a phone photo carries GPS and
    // device identifiers, and nothing downstream of BYOQ needs them. If the
    // container cannot be fully parsed we cannot prove it is clean, so fail
    // closed and ask for a retake rather than keep an unstripped photo.
    const stripped = stripImageMetadata(raw, validation.mediaType);
    if (!stripped.complete) {
      await storage.remove([path]).catch(() => {});
      throw new HttpError(422, "capture_unreadable", { failure_class: "image_quality" });
    }
    const finalBytes = stripped.bytes;
    const digest = await sha256HexOfBytes(finalBytes);
    const destination = finalPath({
      owner,
      itemId: token.item_id,
      role: token.capture_role,
      fileId: crypto.randomUUID(),
      mediaType: validation.mediaType,
    });
    await storage.upload(destination, finalBytes, validation.mediaType);
    await storage.remove([path]).catch(() => {});

    let attachment: AttachmentRow;
    try {
      attachment = await store.bindAttachment({
        pairingId: token.id,
        storagePath: destination,
        mediaType: validation.mediaType,
        byteSize: finalBytes.length,
        width: validation.width,
        height: validation.height,
        sha256: digest,
        metadataStatus: stripped.changed ? "STRIPPED" : "NOT_PRESENT",
        replacesAttachmentId: replaces,
        maxCurrentPages: BYOQ_LIMITS.maxCurrentPages,
      });
    } catch (e) {
      await storage.remove([destination]).catch(() => {});
      throw mapRpcError(e);
    }
    if (replaces) {
      const old = await store.getAttachment(replaces);
      if (old && !old.is_current) {
        await storage.remove([old.storage_path]).catch(() => {});
        await store.deleteAttachment(old.id);
      }
    }
    // A question photo means this item is photo-sourced.
    if (token.capture_role === "question") {
      const item = await store.getItem(token.item_id);
      if (item && item.source_kind === "typed" && !item.stem) {
        await store.updateItem(item.id, { source_kind: "photo_single" });
      }
    }
    const refreshed = await store.getTokenById(token.id);
    return {
      attachment: { id: attachment.id, page_sequence: attachment.page_sequence },
      pairing: tokenView(refreshed ?? token),
    };
  }

  // finish_capture
  const token = await liveTokenForHandle(ctx);
  const done = await store.transitionToken(token.id, [...LIVE_STATES], {
    state: token.uploads_bound > 0 ? "consumed" : "cancelled",
    consumed_at: token.uploads_bound > 0 ? ctx.now().toISOString() : null,
    closed_at: ctx.now().toISOString(),
  });
  return { pairing: tokenView(done ?? token) };
}

/* -------------------------------------------------------------------------- */
/* Retention                                                                   */
/* -------------------------------------------------------------------------- */

async function removeItemObjects(ctx: Ctx, owner: OwnerRow, itemId: string) {
  const attachments = (await ctx.store.listAttachments(itemId)).map((a) => a.storage_path);
  const base = `${ownerStoragePrefix(owner)}/${itemId}`;
  const leftovers = [
    ...await ctx.storage.list(`${base}/incoming`),
    ...await ctx.storage.list(`${base}/question`),
    ...await ctx.storage.list(`${base}/response`),
  ];
  const all = [...new Set([...attachments, ...leftovers])];
  if (all.length) await ctx.storage.remove(all);
}

/**
 * Anonymous owners inactive for BYOQ_LIMITS.anonymousRetentionDays are
 * deleted with their items and photos. Recognized owners are kept until the
 * student deletes their items. Storage first, then rows, so a failure
 * leaves rows that the next sweep retries rather than orphaned objects.
 */
async function purgeStaleAnonymousOwners(ctx: Ctx, limit: number): Promise<number> {
  const before = new Date(ctx.now().getTime() - BYOQ_LIMITS.anonymousRetentionDays * 86400_000).toISOString();
  const owners = await ctx.store.staleAnonymousOwners(before, limit);
  let purged = 0;
  for (const owner of owners) {
    for (const itemId of await ctx.store.listItemIdsForOwner(owner.id)) {
      await removeItemObjects(ctx, owner, itemId);
    }
    await ctx.store.deleteOwner(owner.id);
    purged++;
  }
  return purged;
}

let lastOpportunisticPurge = 0;

function scheduleOpportunisticPurge(ctx: Ctx) {
  const nowMs = ctx.now().getTime();
  if (nowMs - lastOpportunisticPurge < 10 * 60_000) return;
  lastOpportunisticPurge = nowMs;
  const job = purgeStaleAnonymousOwners(ctx, 5).catch((e) =>
    console.error("byoq_purge_failed", e instanceof Error ? e.message : String(e))
  );
  // deno-lint-ignore no-explicit-any
  (globalThis as any).EdgeRuntime?.waitUntil?.(job);
}

Deno.serve((req) => handleByoq(req));
