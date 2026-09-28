// Data access for the `byoq` function. Every database and storage call the
// handler makes goes through this interface, so the handler can be tested
// against an in-memory implementation and this file is the only place that
// knows table names. Uses the service-role client: the handler has already
// resolved and checked ownership before calling anything here.

import type { ChoiceInput, LeakFlag } from "../_shared/byoq.ts";

export interface OwnerRow {
  id: string;
  key_sha256: string | null;
  user_id: string | null;
  last_seen_at: string;
}

export interface ItemRow {
  id: string;
  owner_id: string;
  user_id: string | null;
  code: string;
  item_type: "mcq" | "frq" | null;
  title: string | null;
  stem: string | null;
  choices: ChoiceInput[];
  subject_key: string | null;
  taxonomy_topic_id: string | null;
  difficulty: "easy" | "medium" | "hard" | null;
  source_kind: "typed" | "photo_single" | "worksheet_split";
  source_note: string | null;
  status: "draft" | "ready" | "archived";
  leak_flags: LeakFlag[];
  created_at: string;
  updated_at: string;
  confirmed_at: string | null;
  last_practiced_at: string | null;
}

export interface ResponseRow {
  id: string;
  item_id: string;
  owner_id: string;
  attempt_number: number;
  version_number: number;
  parent_response_id: string | null;
  selected_choice_key: string | null;
  response_text: string | null;
  is_final: boolean;
  created_at: string;
}

export type PairingState =
  | "issued"
  | "paired"
  | "uploaded"
  | "consumed"
  | "expired"
  | "cancelled"
  | "rejected";

export interface TokenRow {
  id: string;
  handle_sha256: string;
  owner_id: string;
  item_id: string;
  capture_role: "question" | "response";
  response_id: string | null;
  part_key: string;
  generation: number;
  state: PairingState;
  access_path: "QR" | "FALLBACK_DIRECT" | null;
  expires_at: string;
  redemption_attempts: number;
  uploads_bound: number;
  storage_prefix: string;
  incoming_swept_at: string | null;
  created_at: string;
}

export interface AttachmentRow {
  id: string;
  owner_id: string;
  item_id: string;
  capture_role: "question" | "response";
  response_id: string | null;
  part_key: string;
  page_sequence: number;
  storage_path: string;
  media_type: string;
  byte_size: number;
  pixel_width: number | null;
  pixel_height: number | null;
  is_current: boolean;
  created_at: string;
}

export interface TopicRow {
  taxonomy_topic_id: string;
  subject_key: string;
  unit_number: number;
  unit_title: string;
  topic_code: string;
  topic_title: string;
}

/** Raised by the RPC wrappers with the SQL function's `prefix:reason` message. */
export class StoreRpcError extends Error {}

export interface ByoqStore {
  profileExists(userId: string): Promise<boolean>;
  verifyPurgeToken(token: string): Promise<boolean>;
  countAnonymousOwnersSince(sinceIso: string): Promise<number>;
  countLiveTokens(ownerId: string): Promise<number>;
  expireLapsedTokens(): Promise<void>;
  unsweptClosedTokens(closedBeforeIso: string, limit: number): Promise<TokenRow[]>;
  markTokenSwept(id: string, atIso: string): Promise<void>;
  getOwnerById(ownerId: string): Promise<OwnerRow | null>;
  findOwnerByKeyHash(keySha256: string): Promise<OwnerRow | null>;
  findKeylessOwnerForUser(userId: string): Promise<OwnerRow | null>;
  insertOwner(row: { key_sha256: string | null; user_id: string | null; created_ip_hmac: string | null }): Promise<OwnerRow>;
  countOwnersFromIpSince(ipHmac: string, sinceIso: string): Promise<number>;
  linkOwnerToUser(ownerId: string, userId: string): Promise<void>;
  touchOwner(ownerId: string): Promise<void>;
  ownerIdsForUser(userId: string): Promise<string[]>;
  staleAnonymousOwners(beforeIso: string, limit: number): Promise<OwnerRow[]>;
  deleteOwner(ownerId: string): Promise<void>;

  insertItem(row: Partial<ItemRow> & { owner_id: string; code: string }): Promise<ItemRow>;
  getItem(itemId: string): Promise<ItemRow | null>;
  listItems(ownerIds: string[]): Promise<ItemRow[]>;
  updateItem(itemId: string, patch: Partial<ItemRow>): Promise<ItemRow>;
  deleteItem(itemId: string): Promise<void>;
  countItemsCreatedSince(ownerId: string, sinceIso: string): Promise<number>;
  countLiveItems(ownerIds: string[]): Promise<number>;
  listItemIdsForOwner(ownerId: string): Promise<string[]>;

  resolveTopic(subjectKey: string, unitNumber: number | null, topicCode: string): Promise<TopicRow | null>;
  topicById(taxonomyTopicId: string): Promise<TopicRow | null>;
  listSubjects(): Promise<string[]>;
  listTopics(subjectKey: string): Promise<TopicRow[]>;
  topicGuides(subjectKey: string, unitNumber: number, topicCode: string): Promise<{ briefs: unknown[]; explainers: unknown[] }>;

  listResponses(itemId: string): Promise<ResponseRow[]>;
  insertResponse(row: Omit<ResponseRow, "id" | "created_at">): Promise<ResponseRow>;

  countMintsSince(ownerId: string, sinceIso: string): Promise<number>;
  cancelLiveTokens(slot: { item_id: string; capture_role: string; response_id: string | null; part_key: string }): Promise<number[]>;
  insertToken(
    row: Omit<TokenRow, "id" | "created_at" | "state" | "access_path" | "redemption_attempts" | "uploads_bound" | "incoming_swept_at">,
  ): Promise<TokenRow>;
  getTokenByHash(handleSha256: string): Promise<TokenRow | null>;
  getTokenById(id: string): Promise<TokenRow | null>;
  /** Compare-and-set: updates only when the current state is one of `fromStates`. */
  transitionToken(id: string, fromStates: PairingState[], patch: Partial<TokenRow> & Record<string, unknown>): Promise<TokenRow | null>;
  claimUpload(handleSha256: string, maxAttempts: number, accessPath: string): Promise<TokenRow>;
  bindAttachment(params: {
    pairingId: string;
    storagePath: string;
    mediaType: string;
    byteSize: number;
    width: number | null;
    height: number | null;
    sha256: string;
    metadataStatus: "STRIPPED" | "NOT_PRESENT" | "UNKNOWN";
    replacesAttachmentId: string | null;
    maxCurrentPages: number;
  }): Promise<AttachmentRow>;

  listAttachments(itemId: string): Promise<AttachmentRow[]>;
  getAttachment(id: string): Promise<AttachmentRow | null>;
  deleteAttachment(id: string): Promise<void>;
  attachmentPathsForOwner(ownerId: string): Promise<string[]>;
}

export interface ByoqStorage {
  signUpload(path: string): Promise<{ signedUrl: string; token: string }>;
  download(path: string): Promise<Uint8Array | null>;
  /** Object size in bytes from storage metadata, or null if it does not exist. */
  size(path: string): Promise<number | null>;
  upload(path: string, bytes: Uint8Array, contentType: string): Promise<void>;
  remove(paths: string[]): Promise<void>;
  signRead(path: string, expiresInSeconds: number): Promise<string | null>;
  list(prefix: string): Promise<string[]>;
}

/* -------------------------------------------------------------------------- */
/* Supabase implementation                                                     */
/* -------------------------------------------------------------------------- */

// deno-lint-ignore no-explicit-any
type Client = any;

const BUCKET = "learner-uploads";

function must<T>(result: { data: T | null; error: { message: string } | null }, what: string): T {
  if (result.error) throw new Error(`${what}: ${result.error.message}`);
  if (result.data === null) throw new Error(`${what}: no data`);
  return result.data;
}

function orNull<T>(result: { data: T | null; error: { message: string } | null }, what: string): T | null {
  if (result.error) throw new Error(`${what}: ${result.error.message}`);
  return result.data;
}

export function createSupabaseStore(client: Client): ByoqStore {
  const app = () => client.schema("app");
  const OWNER_COLS = "id, key_sha256, user_id, last_seen_at";

  return {
    async profileExists(userId) {
      return Boolean(orNull(await app().from("profiles").select("user_id").eq("user_id", userId).maybeSingle(), "profile"));
    },
    async verifyPurgeToken(token) {
      const r = await app().rpc("byoq_verify_purge_token", { p_token: token });
      return !r.error && r.data === true;
    },
    async countAnonymousOwnersSince(since) {
      const r = await app().from("byoq_owners").select("id", { count: "exact", head: true })
        .is("user_id", null).gte("created_at", since);
      if (r.error) throw new Error(`count_anon_owners: ${r.error.message}`);
      return r.count ?? 0;
    },
    async countLiveTokens(ownerId) {
      const r = await app().from("byoq_capture_pairing_tokens").select("id", { count: "exact", head: true })
        .eq("owner_id", ownerId).in("state", ["issued", "paired", "uploaded"]).gt("expires_at", new Date().toISOString());
      if (r.error) throw new Error(`count_live_tokens: ${r.error.message}`);
      return r.count ?? 0;
    },
    async expireLapsedTokens() {
      const r = await app().rpc("expire_byoq_capture_pairing_tokens", { p_limit: 500 });
      if (r.error) throw new Error(`expire_tokens: ${r.error.message}`);
    },
    async unsweptClosedTokens(before, limit) {
      return must(
        await app().from("byoq_capture_pairing_tokens").select("*")
          .is("incoming_swept_at", null).in("state", ["consumed", "expired", "cancelled", "rejected"])
          .lt("closed_at", before).order("closed_at").limit(limit),
        "unswept_tokens",
      );
    },
    async markTokenSwept(id, at) {
      const r = await app().from("byoq_capture_pairing_tokens").update({ incoming_swept_at: at }).eq("id", id);
      if (r.error) throw new Error(`mark_swept: ${r.error.message}`);
    },
    async getOwnerById(id) {
      return orNull(await app().from("byoq_owners").select(OWNER_COLS).eq("id", id).maybeSingle(), "owner_by_id");
    },
    async findOwnerByKeyHash(h) {
      return orNull(await app().from("byoq_owners").select(OWNER_COLS).eq("key_sha256", h).maybeSingle(), "find_owner");
    },
    async findKeylessOwnerForUser(userId) {
      return orNull(
        await app().from("byoq_owners").select(OWNER_COLS).eq("user_id", userId).is("key_sha256", null).maybeSingle(),
        "find_keyless_owner",
      );
    },
    async insertOwner(row) {
      return must(await app().from("byoq_owners").insert(row).select(OWNER_COLS).single(), "insert_owner");
    },
    async countOwnersFromIpSince(ipHmac, since) {
      const r = await app().from("byoq_owners").select("id", { count: "exact", head: true })
        .eq("created_ip_hmac", ipHmac).gte("created_at", since);
      if (r.error) throw new Error(`count_owners_ip: ${r.error.message}`);
      return r.count ?? 0;
    },
    async linkOwnerToUser(ownerId, userId) {
      const a = await app().from("byoq_owners").update({ user_id: userId }).eq("id", ownerId).is("user_id", null);
      if (a.error) throw new Error(`link_owner: ${a.error.message}`);
      const b = await app().from("byoq_items").update({ user_id: userId }).eq("owner_id", ownerId).is("user_id", null);
      if (b.error) throw new Error(`link_items: ${b.error.message}`);
    },
    async touchOwner(ownerId) {
      await app().from("byoq_owners").update({ last_seen_at: new Date().toISOString() }).eq("id", ownerId);
    },
    async ownerIdsForUser(userId) {
      const rows = must(await app().from("byoq_owners").select("id").eq("user_id", userId), "owner_ids") as { id: string }[];
      return rows.map((r) => r.id);
    },
    async staleAnonymousOwners(before, limit) {
      return must(
        await app().from("byoq_owners").select(OWNER_COLS).is("user_id", null).lt("last_seen_at", before)
          .order("last_seen_at").limit(limit),
        "stale_owners",
      );
    },
    async deleteOwner(ownerId) {
      const r = await app().from("byoq_owners").delete().eq("id", ownerId);
      if (r.error) throw new Error(`delete_owner: ${r.error.message}`);
    },

    async insertItem(row) {
      return must(await app().from("byoq_items").insert(row).select("*").single(), "insert_item");
    },
    async getItem(id) {
      return orNull(await app().from("byoq_items").select("*").eq("id", id).maybeSingle(), "get_item");
    },
    async listItems(ownerIds) {
      if (!ownerIds.length) return [];
      return must(
        await app().from("byoq_items").select("*").in("owner_id", ownerIds).neq("status", "archived")
          .order("created_at", { ascending: false }).limit(200),
        "list_items",
      );
    },
    async updateItem(id, patch) {
      return must(await app().from("byoq_items").update(patch).eq("id", id).select("*").single(), "update_item");
    },
    async deleteItem(id) {
      const r = await app().from("byoq_items").delete().eq("id", id);
      if (r.error) throw new Error(`delete_item: ${r.error.message}`);
    },
    async countItemsCreatedSince(ownerId, since) {
      const r = await app().from("byoq_items").select("id", { count: "exact", head: true })
        .eq("owner_id", ownerId).gte("created_at", since);
      if (r.error) throw new Error(`count_items: ${r.error.message}`);
      return r.count ?? 0;
    },
    async countLiveItems(ownerIds) {
      if (!ownerIds.length) return 0;
      const r = await app().from("byoq_items").select("id", { count: "exact", head: true }).in("owner_id", ownerIds);
      if (r.error) throw new Error(`count_live_items: ${r.error.message}`);
      return r.count ?? 0;
    },
    async listItemIdsForOwner(ownerId) {
      const rows = must(await app().from("byoq_items").select("id").eq("owner_id", ownerId), "item_ids") as { id: string }[];
      return rows.map((r) => r.id);
    },

    async resolveTopic(subjectKey, unitNumber, topicCode) {
      const versions = must(
        await app().from("taxonomy_source_versions").select("taxonomy_source_version").eq("subject_key", subjectKey),
        "taxonomy_versions",
      ) as { taxonomy_source_version: string }[];
      if (!versions.length) return null;
      let q = app().from("taxonomy_topics")
        .select("taxonomy_topic_id, unit_number, unit_title, topic_code, topic_title")
        .in("taxonomy_source_version", versions.map((v) => v.taxonomy_source_version))
        .eq("topic_code", topicCode);
      if (unitNumber !== null) q = q.eq("unit_number", unitNumber);
      const rows = must(await q.limit(1), "resolve_topic") as Omit<TopicRow, "subject_key">[];
      return rows[0] ? { ...rows[0], subject_key: subjectKey } : null;
    },
    async topicById(id) {
      const row = orNull(
        await app().from("taxonomy_topics")
          .select("taxonomy_topic_id, unit_number, unit_title, topic_code, topic_title, taxonomy_source_version")
          .eq("taxonomy_topic_id", id).maybeSingle(),
        "topic_by_id",
      ) as (Omit<TopicRow, "subject_key"> & { taxonomy_source_version: string }) | null;
      if (!row) return null;
      const v = orNull(
        await app().from("taxonomy_source_versions").select("subject_key")
          .eq("taxonomy_source_version", row.taxonomy_source_version).maybeSingle(),
        "topic_subject",
      ) as { subject_key: string } | null;
      if (!v) return null;
      const { taxonomy_source_version: _ignored, ...rest } = row;
      return { ...rest, subject_key: v.subject_key };
    },
    async listSubjects() {
      const rows = must(await app().from("taxonomy_source_versions").select("subject_key"), "list_subjects") as {
        subject_key: string;
      }[];
      return [...new Set(rows.map((r) => r.subject_key))].sort();
    },
    async listTopics(subjectKey) {
      const versions = must(
        await app().from("taxonomy_source_versions").select("taxonomy_source_version").eq("subject_key", subjectKey),
        "taxonomy_versions",
      ) as { taxonomy_source_version: string }[];
      if (!versions.length) return [];
      const rows = must(
        await app().from("taxonomy_topics")
          .select("taxonomy_topic_id, unit_number, unit_title, topic_code, topic_title")
          .in("taxonomy_source_version", versions.map((v) => v.taxonomy_source_version)),
        "list_topics",
      ) as Omit<TopicRow, "subject_key">[];
      const major = (c: string) => Number(c.split(".")[0]);
      const minor = (c: string) => Number(c.split(".")[1]);
      return rows
        .map((r) => ({ ...r, subject_key: subjectKey }))
        .sort((a, b) => a.unit_number - b.unit_number || major(a.topic_code) - major(b.topic_code) || minor(a.topic_code) - minor(b.topic_code));
    },
    async topicGuides(subjectKey, unitNumber, topicCode) {
      // Same published-only filter and camelCase payload as
      // public.get_topic_point_guides, which cannot be used here because it
      // requires auth.uid() and BYOQ serves anonymous visitors (DECISION-0077).
      const briefs = must(
        await app().from("topic_point_briefs").select("*").eq("subject_key", subjectKey)
          .eq("unit_number", unitNumber).eq("topic_code", topicCode).eq("status", "published"),
        "briefs",
      ) as Record<string, unknown>[];
      const explainers = must(
        await app().from("topic_explainers").select("*").eq("subject_key", subjectKey)
          .eq("unit_number", unitNumber).eq("topic_code", topicCode).eq("status", "published"),
        "explainers",
      ) as Record<string, unknown>[];
      return {
        briefs: briefs.map((b) => ({
          subjectKey: b.subject_key,
          unitNumber: b.unit_number,
          topicId: b.topic_code,
          topicCode: b.topic_code,
          title: b.title,
          classImportance: b.class_importance,
          examImportance: b.exam_importance,
          whatItIs: b.what_it_is,
          whyItMatters: b.why_it_matters,
          howPointsAreEarned: b.how_points_are_earned,
          answerMove: b.answer_move,
          commonPointLoss: b.common_point_loss,
          learnMorePath: b.learn_more_path,
        })),
        explainers: explainers.map((e) => ({
          subjectKey: e.subject_key,
          unitNumber: e.unit_number,
          topicId: e.topic_code,
          topicCode: e.topic_code,
          title: e.title,
          coreIdea: e.core_idea,
          whatStudentsNeedToUnderstand: e.what_students_need_to_understand,
          howThisBecomesPoints: e.how_this_becomes_points,
          answerMove: e.answer_move,
          miniExample: {
            question: e.mini_example_question,
            weakAnswer: e.weak_answer,
            pointAttainingAnswer: e.point_attaining_answer,
          },
          commonPointLoss: e.common_point_loss,
          practiceBridge: e.practice_bridge,
        })),
      };
    },

    async listResponses(itemId) {
      return must(
        await app().from("byoq_responses").select("*").eq("item_id", itemId)
          .order("attempt_number").order("version_number"),
        "list_responses",
      );
    },
    async insertResponse(row) {
      return must(await app().from("byoq_responses").insert(row).select("*").single(), "insert_response");
    },

    async countMintsSince(ownerId, since) {
      const r = await app().from("byoq_capture_pairing_tokens").select("id", { count: "exact", head: true })
        .eq("owner_id", ownerId).gte("created_at", since);
      if (r.error) throw new Error(`count_mints: ${r.error.message}`);
      return r.count ?? 0;
    },
    async cancelLiveTokens(slot) {
      let q = app().from("byoq_capture_pairing_tokens")
        .update({ state: "cancelled", closed_at: new Date().toISOString() })
        .eq("item_id", slot.item_id).eq("capture_role", slot.capture_role).eq("part_key", slot.part_key)
        .in("state", ["issued", "paired", "uploaded"]);
      q = slot.response_id ? q.eq("response_id", slot.response_id) : q.is("response_id", null);
      const rows = must(await q.select("generation"), "cancel_live_tokens") as { generation: number }[];
      return rows.map((r) => r.generation);
    },
    async insertToken(row) {
      return must(await app().from("byoq_capture_pairing_tokens").insert(row).select("*").single(), "insert_token");
    },
    async getTokenByHash(h) {
      return orNull(await app().from("byoq_capture_pairing_tokens").select("*").eq("handle_sha256", h).maybeSingle(), "token_by_hash");
    },
    async getTokenById(id) {
      return orNull(await app().from("byoq_capture_pairing_tokens").select("*").eq("id", id).maybeSingle(), "token_by_id");
    },
    async transitionToken(id, fromStates, patch) {
      return orNull(
        await app().from("byoq_capture_pairing_tokens").update(patch).eq("id", id).in("state", fromStates)
          .select("*").maybeSingle(),
        "transition_token",
      );
    },
    async claimUpload(h, max, accessPath) {
      const r = await app().rpc("claim_byoq_capture_upload", {
        p_handle_sha256: h,
        p_max_attempts: max,
        p_access_path: accessPath,
      }).single();
      if (r.error) throw new StoreRpcError(r.error.message);
      return r.data as TokenRow;
    },
    async bindAttachment(p) {
      const r = await app().rpc("bind_byoq_attachment", {
        p_pairing_id: p.pairingId,
        p_storage_path: p.storagePath,
        p_media_type: p.mediaType,
        p_byte_size: p.byteSize,
        p_pixel_width: p.width,
        p_pixel_height: p.height,
        p_sha256_digest: p.sha256,
        p_metadata_status: p.metadataStatus,
        p_replaces_attachment_id: p.replacesAttachmentId,
        p_max_current_pages: p.maxCurrentPages,
      }).single();
      if (r.error) throw new StoreRpcError(r.error.message);
      return r.data as AttachmentRow;
    },

    async listAttachments(itemId) {
      return must(
        await app().from("byoq_attachments").select("*").eq("item_id", itemId).eq("is_current", true)
          .order("capture_role").order("part_key").order("page_sequence"),
        "list_attachments",
      );
    },
    async getAttachment(id) {
      return orNull(await app().from("byoq_attachments").select("*").eq("id", id).maybeSingle(), "get_attachment");
    },
    async deleteAttachment(id) {
      const r = await app().from("byoq_attachments").delete().eq("id", id);
      if (r.error) throw new Error(`delete_attachment: ${r.error.message}`);
    },
    async attachmentPathsForOwner(ownerId) {
      const rows = must(await app().from("byoq_attachments").select("storage_path").eq("owner_id", ownerId), "owner_paths") as {
        storage_path: string;
      }[];
      return rows.map((r) => r.storage_path);
    },
  };
}

export function createSupabaseStorage(client: Client): ByoqStorage {
  const bucket = () => client.storage.from(BUCKET);
  return {
    async signUpload(path) {
      const r = await bucket().createSignedUploadUrl(path);
      if (r.error || !r.data?.signedUrl || !r.data?.token) throw new Error(`sign_upload: ${r.error?.message ?? "no url"}`);
      return { signedUrl: r.data.signedUrl, token: r.data.token };
    },
    async download(path) {
      const r = await bucket().download(path);
      if (r.error || !r.data) return null;
      return new Uint8Array(await r.data.arrayBuffer());
    },
    async size(path) {
      const slash = path.lastIndexOf("/");
      const folder = path.slice(0, slash);
      const name = path.slice(slash + 1);
      const r = await bucket().list(folder, { limit: 100, search: name });
      if (r.error) return null;
      const hit = (r.data ?? []).find((o: { name: string }) => o.name === name) as
        | { metadata?: { size?: number } }
        | undefined;
      return hit ? Number(hit.metadata?.size ?? 0) : null;
    },
    async upload(path, bytes, contentType) {
      const r = await bucket().upload(path, bytes, { contentType, upsert: false });
      if (r.error) throw new Error(`upload: ${r.error.message}`);
    },
    async remove(paths) {
      for (let i = 0; i < paths.length; i += 100) {
        const r = await bucket().remove(paths.slice(i, i + 100));
        if (r.error) throw new Error(`remove: ${r.error.message}`);
      }
    },
    async signRead(path, seconds) {
      const r = await bucket().createSignedUrl(path, seconds);
      return r.error ? null : r.data?.signedUrl ?? null;
    },
    async list(prefix) {
      const r = await bucket().list(prefix, { limit: 1000 });
      if (r.error) throw new Error(`list: ${r.error.message}`);
      return (r.data ?? []).filter((o: { id: string | null }) => o.id).map((o: { name: string }) => `${prefix}/${o.name}`);
    },
  };
}
