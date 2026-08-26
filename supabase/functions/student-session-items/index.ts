// TASK-0021 — student-authorized prompt-visual delivery.
// Task: docs/tasks/TASK-0021-BIOLOGY-PROMPT-VISUAL-STUDENT-DELIVERY.md
//
// Serves render-ready practice items to the student who owns a learning
// session, including short-TTL signed URLs for required prompt visuals.
//
// Two request shapes share the same ownership + visibility gates and the same
// signing/delivery path (`deliverRows`):
//   1. ORDINARY QUEUE (default): POST { learning_session_id, limit? } — serves the
//      session's practice_format selection via select_practice_frqs.
//   2. CONFIRM-TRANSFER (Course Mode, SESSION_ASSEMBLY §7.1): POST
//      { learning_session_id, confirm_transfer: { source_content_item_version_id } }
//      — serves at most ONE different published item tagged to the SAME content
//      cell as the source item (app.select_confirm_transfer_item), so a correct
//      follow-up can confirm transfer before a cell earns full `independent`.
//      Additive and out-of-band: it selects nothing from, and mutates nothing in,
//      the ordinary session-target queue; the ordinary queue cursor lives entirely
//      client-side. Fail-closed: when no valid parallel item exists (no same-cell
//      approved MCQ, a numeric-answer cell that is excluded, an untagged source, or
//      a candidate withheld by the media gate) it returns `item: null` with a
//      reason so the client never makes a false "same skill" claim.
//
// Why this is here instead of a role grant on storage-sign-url: content-assets
// is a private bucket that also holds authoring/reviewer-only material, so
// widening canAccessBucket for `student` would expose far more than the item
// a student is being served. This mirrors review-queue's pattern instead --
// sign with the service role, scoped per request to exactly the assets the
// caller is entitled to right now. This function never accepts a bucket or
// path from the client; every path comes from the database.
//
// Two independent gates, both enforced here and both fail-closed:
//   1. Eligibility -- the caller owns an active session whose exam pack and
//      practice_format actually select this item version. This is the same
//      contract attempt-response enforces at submission
//      (attempt-response/index.ts:286-310), applied earlier, before delivery.
//   2. Student-visibility -- a required visual is only sent to a student when
//      app.content_asset_metadata carries approved accessibility text
//      (approved_at IS NOT NULL). Staff/QA roles may render unapproved assets
//      so the delivery path can be exercised before Learning Quality sign-off;
//      students cannot. See 20260805100000_content_asset_metadata.sql.

import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import {
  type AssetMetadata,
  buildRenderItem,
  indexAssets,
  isStaffQaRole,
  type LearnerFacingCriterion,
  MAX_ITEMS,
  type Omission,
  partitionDeliverable,
  type RenderItem,
  type SelectedRow,
  SIGNED_URL_TTL_SECONDS,
  STIMULUS_IMAGE_BUCKET,
  type VisualRequirement,
} from "../_shared/student-item-delivery.ts";

type ServiceClient = ReturnType<typeof createServiceClient>;

// Dependency seams for tests: production wires the real service client + auth
// via `Deno.serve` at the bottom of the file; a test injects in-memory fakes so
// the confirm-transfer branch, ownership gates, and fail-closed rules are
// exercised without a database. Mirrors capture-pairing's handler DI.
type StudentSessionItemsDeps = {
  service?: ServiceClient;
  requireProfile?: typeof requireProfile;
};

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function asUuid(value: unknown) {
  return typeof value === "string" && UUID_RE.test(value.trim())
    ? value.trim()
    : null;
}

function asPositiveInt(value: unknown, fallback: number) {
  const parsed = Number(value);
  if (!Number.isInteger(parsed) || parsed < 1) return fallback;
  return Math.min(parsed, MAX_ITEMS);
}

// Only these three columns are ever read from frq_criteria. The same table
// carries evidence_requirements, minimum_fix, and accepted_variants, which are
// answer-bearing and must never reach a student. Verified 2026-08-05.
const LEARNER_FACING_CRITERION_COLUMNS =
  "content_item_version_id, criterion_key, learner_facing_text, points_possible";

// Shared signing + delivery for a set of selected rows. Fetches learner-facing
// criteria + asset/visual metadata, applies the student-visibility gate
// (partitionDeliverable), signs only what survives both gates, and builds the
// whitelist render payload. Both request shapes route through this so the
// answer-safety and fail-closed rules live in exactly one place.
type DeliverResult =
  | { ok: true; items: RenderItem[]; omitted: Omission[]; expiresAt: string }
  | { ok: false; error: "item_details_failed" | "stimulus_image_sign_failed" };

async function deliverRows(
  service: ServiceClient,
  rows: SelectedRow[],
  qaMode: boolean,
): Promise<DeliverResult> {
  const versionIds = rows
    .map((r) => r.content_item_version_id)
    .filter((id): id is string => Boolean(id));

  const expiresAt = new Date(
    Date.now() + SIGNED_URL_TTL_SECONDS * 1000,
  ).toISOString();

  if (!versionIds.length) {
    return { ok: true, items: [], omitted: [], expiresAt };
  }

  const [criteriaResult, assetResult, visualResult] = await Promise.all([
    service.schema("app").from("frq_criteria")
      .select(LEARNER_FACING_CRITERION_COLUMNS)
      .in("content_item_version_id", versionIds)
      .order("criterion_key", { ascending: true }),
    service.schema("app").from("content_asset_metadata")
      .select(
        "content_item_version_id, storage_bucket, storage_path, alt_text, long_description, approved_at",
      )
      .in("content_item_version_id", versionIds),
    service.schema("app").from("content_visual_requirements")
      .select("content_item_version_id, image_needed, image_approval")
      .in("content_item_version_id", versionIds),
  ]);

  if (criteriaResult.error || assetResult.error || visualResult.error) {
    return { ok: false, error: "item_details_failed" };
  }

  const criteriaByVersion = new Map<string, LearnerFacingCriterion[]>();
  for (const row of (criteriaResult.data ?? []) as LearnerFacingCriterion[]) {
    const list = criteriaByVersion.get(row.content_item_version_id) ?? [];
    list.push(row);
    criteriaByVersion.set(row.content_item_version_id, list);
  }

  const assetByKey = indexAssets(
    (assetResult.data ?? []) as AssetMetadata[],
  );

  const visualByVersion = new Map<string, VisualRequirement>();
  for (const row of (visualResult.data ?? []) as VisualRequirement[]) {
    visualByVersion.set(row.content_item_version_id, row);
  }

  const { deliverable, omitted } = partitionDeliverable(
    rows,
    assetByKey,
    qaMode,
    visualByVersion,
  );

  const pathsToSign = Array.from(
    new Set(
      deliverable
        .map((d) => d.asset?.storage_path)
        .filter((p): p is string => Boolean(p)),
    ),
  );

  const signedByPath = new Map<string, string>();
  if (pathsToSign.length) {
    const { data: signedUrls, error: signError } = await service.storage
      .from(STIMULUS_IMAGE_BUCKET)
      .createSignedUrls(pathsToSign, SIGNED_URL_TTL_SECONDS);

    if (signError) {
      return { ok: false, error: "stimulus_image_sign_failed" };
    }
    for (const entry of signedUrls ?? []) {
      if (entry?.path && entry.signedUrl && !entry.error) {
        signedByPath.set(entry.path, entry.signedUrl);
      }
    }
  }

  const items: RenderItem[] = [];
  for (const { row, asset } of deliverable) {
    const item = buildRenderItem(
      row,
      asset,
      asset ? signedByPath.get(asset.storage_path) ?? null : null,
      expiresAt,
      criteriaByVersion.get(row.content_item_version_id) ?? [],
    );
    if (!item) {
      // Survived the gates but could not be signed. Still a missing required
      // visual -- omit rather than ship an unanswerable item. This is the
      // selection-time half of the fail-closed rule.
      omitted.push({
        content_key: row.content_key,
        reason: "asset_sign_failed",
      });
      continue;
    }
    items.push(item);
  }

  return { ok: true, items, omitted, expiresAt };
}

export async function handleStudentSessionItems(
  req: Request,
  deps: StudentSessionItemsDeps = {},
): Promise<Response> {
  const authenticate = deps.requireProfile ?? requireProfile;
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }
  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }
  const input = body as Record<string, unknown>;

  const learningSessionId = asUuid(
    input.learning_session_id ?? input.learningSessionId,
  );
  if (!learningSessionId) {
    return respond(
      { error: "missing_required_fields", required: ["learning_session_id"] },
      { status: 400 },
    );
  }
  const limit = asPositiveInt(input.limit, MAX_ITEMS);

  // Confirm-transfer is requested by a nested object so the ordinary contract is
  // byte-for-byte unchanged for callers that never send it.
  const confirmTransfer = input.confirm_transfer ?? input.confirmTransfer;
  const confirmTransferRequested = confirmTransfer != null;
  const sourceContentItemVersionId = confirmTransferRequested
    ? asUuid(
      (confirmTransfer as Record<string, unknown>)?.source_content_item_version_id ??
        (confirmTransfer as Record<string, unknown>)?.sourceContentItemVersionId,
    )
    : null;
  if (confirmTransferRequested && !sourceContentItemVersionId) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["confirm_transfer.source_content_item_version_id"],
      },
      { status: 400 },
    );
  }

  const profileResult = await authenticate(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }
  const { user, profile } = profileResult;

  const service = deps.service ?? createServiceClient();

  try {
    // ── Gate 1: session eligibility ─────────────────────────────────────────
    const { data: session, error: sessionError } = await service
      .schema("app")
      .from("learning_sessions")
      .select("id, user_id, exam_pack_version_id, practice_format, status")
      .eq("id", learningSessionId)
      .maybeSingle();

    if (sessionError || !session) {
      return respond({ error: "session_not_found" }, { status: 404 });
    }
    // Ownership. Admin may inspect another user's session for support/QA;
    // every other role -- including staff -- may only read its own.
    if (session.user_id !== user.id && profile.role !== "admin") {
      return respond({ error: "forbidden" }, { status: 403 });
    }
    if (session.status !== "active") {
      return respond({ error: "session_not_active" }, { status: 409 });
    }

    const qaMode = isStaffQaRole(profile.role);

    // ── Confirm-transfer branch (Course Mode §7.1) ──────────────────────────
    if (confirmTransferRequested) {
      // The source must exist and belong to THIS session's exam pack, or a
      // client could pull a transfer item from an unrelated pack. Same
      // exam-pack scoping the ordinary path and attempt-response enforce.
      const { data: sourceVersion, error: sourceError } = await service
        .schema("app")
        .from("content_item_versions")
        .select("id, content_items!inner(exam_pack_version_id)")
        .eq("id", sourceContentItemVersionId)
        .maybeSingle();
      if (sourceError || !sourceVersion) {
        return respond({ error: "source_item_not_found" }, { status: 404 });
      }
      const sourceItem = Array.isArray(sourceVersion.content_items)
        ? sourceVersion.content_items[0]
        : sourceVersion.content_items;
      if (
        !sourceItem ||
        sourceItem.exam_pack_version_id !== session.exam_pack_version_id
      ) {
        return respond({ error: "session_content_mismatch" }, { status: 409 });
      }

      const { data: selected, error: selectError } = await service
        .schema("app")
        .rpc("select_confirm_transfer_item", {
          _exam_pack_version_id: session.exam_pack_version_id,
          _source_content_item_version_id: sourceContentItemVersionId,
        });
      if (selectError) {
        return respond({ error: "item_selection_failed" }, { status: 500 });
      }

      const rows = (selected ?? []) as SelectedRow[];
      // Fail-closed: no valid parallel item (no same-cell approved MCQ, a
      // numeric-answer cell that is excluded, or an untagged source).
      if (!rows.length) {
        return respond({
          status: "ok",
          function: "student-session-items",
          result: {
            mode: "confirm_transfer",
            source_content_item_version_id: sourceContentItemVersionId,
            item: null,
            reason: "no_parallel_item",
            omitted: [],
          },
        });
      }

      const delivered = await deliverRows(service, rows, qaMode);
      if (!delivered.ok) {
        return respond({ error: delivered.error }, { status: 500 });
      }
      // A candidate withheld by the media gate is also fail-closed: return no
      // item (+ the omission reason) rather than an unanswerable transfer.
      const item = delivered.items[0] ?? null;
      return respond({
        status: "ok",
        function: "student-session-items",
        result: {
          mode: "confirm_transfer",
          source_content_item_version_id: sourceContentItemVersionId,
          item,
          reason: item ? null : "no_parallel_item",
          signed_url_ttl_seconds: SIGNED_URL_TTL_SECONDS,
          omitted: delivered.omitted,
        },
      });
    }

    // ── Ordinary queue path ─────────────────────────────────────────────────
    // select_practice_frqs has no NULL fallback by design. Mirror that here
    // rather than substituting a default -- a session with no format must
    // serve nothing, not quietly serve targeted drills.
    if (!session.practice_format) {
      return respond({
        status: "ok",
        function: "student-session-items",
        result: {
          learning_session_id: learningSessionId,
          items: [],
          omitted: [],
          reason: "session_practice_format_unset",
        },
      });
    }

    const { data: selected, error: selectError } = await service.rpc(
      "select_practice_frqs",
      {
        _exam_pack_version_id: session.exam_pack_version_id,
        _practice_format: session.practice_format,
        _limit: limit,
      },
    );
    if (selectError) {
      return respond({ error: "item_selection_failed" }, { status: 500 });
    }

    const rows = (selected ?? []) as SelectedRow[];
    const delivered = await deliverRows(service, rows, qaMode);
    if (!delivered.ok) {
      return respond({ error: delivered.error }, { status: 500 });
    }

    return respond({
      status: "ok",
      function: "student-session-items",
      result: {
        learning_session_id: learningSessionId,
        practice_format: session.practice_format,
        qa_mode: qaMode,
        signed_url_ttl_seconds: SIGNED_URL_TTL_SECONDS,
        items: delivered.items,
        omitted: delivered.omitted,
      },
    });
  } catch (error) {
    console.error("student-session-items", error);
    return respond({ error: "student_session_items_failed" }, { status: 500 });
  }
}

Deno.serve((req) => handleStudentSessionItems(req));
