import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type StorageMode = "sign_upload" | "sign_download" | "sign_delete";
type StorageBucket =
  | "content-assets"
  | "learner-uploads"
  | "validation-artifacts";

const allowedModes = new Set<StorageMode>([
  "sign_upload",
  "sign_download",
  "sign_delete",
]);
const allowedBuckets = new Set([
  "content-assets",
  "learner-uploads",
  "validation-artifacts",
]);
const activeReviewStatuses = new Set(["assigned", "opened"]);

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
        .test(value)
    ? value
    : null;
}

function asInteger(value: unknown) {
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest)).map((byte) =>
    byte.toString(16).padStart(2, "0")
  ).join("");
}

function uuidFromHashHex(hash: string) {
  const chars = hash.slice(0, 32).split("");
  chars[12] = "5";
  chars[16] = ((parseInt(chars[16], 16) & 0x3) | 0x8).toString(16);
  return [
    chars.slice(0, 8).join(""),
    chars.slice(8, 12).join(""),
    chars.slice(12, 16).join(""),
    chars.slice(16, 20).join(""),
    chars.slice(20, 32).join(""),
  ].join("-");
}

async function syntheticStorageObjectId(bucket: StorageBucket, path: string) {
  return uuidFromHashHex(await sha256Hex(`${bucket}|${path}`));
}

function isSafeStoragePath(path: string) {
  return path.length > 0 &&
    !path.startsWith("/") &&
    !path.includes("..") &&
    !path.includes("\\") &&
    !path.includes("//") &&
    !path.includes("\0");
}

async function loadProfile(req: Request) {
  return await requireProfile(req);
}

function parseLearnerUploadPath(path: string) {
  const [userId, sessionId, attemptId, ...filenameParts] = path.split("/");
  if (
    !asUuid(userId) || !asUuid(sessionId) || !asUuid(attemptId) ||
    filenameParts.length === 0
  ) {
    return null;
  }

  return { userId, sessionId, attemptId };
}

function parseContentAssetPath(path: string) {
  const [prefix, examCode, contentItemId, versionId, ...filenameParts] = path
    .split("/");
  if (
    prefix !== "content" || !examCode || !asUuid(contentItemId) ||
    !asUuid(versionId) ||
    filenameParts.length === 0
  ) {
    return null;
  }

  return { examCode, contentItemId, versionId };
}

function parseValidationArtifactPath(path: string) {
  const [prefix, artifactType, scopeId, ...filenameParts] = path.split("/");
  if (
    prefix !== "validation" || !artifactType || !asUuid(scopeId) ||
    filenameParts.length === 0
  ) {
    return null;
  }

  return { artifactType, scopeId };
}

async function loadStorageObjectId(
  service: ReturnType<typeof createServiceClient>,
  bucket: StorageBucket,
  path: string,
) {
  const lastSlash = path.lastIndexOf("/");
  const prefix = lastSlash === -1 ? "" : path.slice(0, lastSlash);
  const filename = lastSlash === -1 ? path : path.slice(lastSlash + 1);
  const { data, error } = await service.storage.from(bucket).list(prefix, {
    search: filename,
    limit: 100,
  });

  if (error) {
    throw new Error("storage_object_lookup_failed");
  }

  const match = data?.find((object) => object.name === filename);
  return typeof match?.id === "string" ? match.id : null;
}

async function requireExistingObjectForReadOrDelete(
  service: ReturnType<typeof createServiceClient>,
  bucket: StorageBucket,
  path: string,
  mode: StorageMode,
) {
  if (mode === "sign_upload") {
    return null;
  }

  const objectId = await loadStorageObjectId(service, bucket, path);
  if (!objectId) {
    throw new Error("storage_object_not_found");
  }

  return objectId;
}

async function authorizeLearnerUpload(input: {
  service: ReturnType<typeof createServiceClient>;
  role: string;
  userId: string;
  path: string;
  mode: StorageMode;
}) {
  const parsed = parseLearnerUploadPath(input.path);
  if (!parsed) {
    return { ok: false as const, error: "invalid_learner_upload_path" };
  }

  const objectId = await requireExistingObjectForReadOrDelete(
    input.service,
    "learner-uploads",
    input.path,
    input.mode,
  );

  if (input.role === "admin") {
    return {
      ok: true as const,
      objectId,
      subject: {
        path_user_id: parsed.userId,
        learning_session_id: parsed.sessionId,
        attempt_id: parsed.attemptId,
      },
    };
  }

  if (parsed.userId !== input.userId || input.mode === "sign_delete") {
    return { ok: false as const, error: "forbidden_path" };
  }

  const { data: attempt, error } = await input.service.schema("app")
    .from("attempts")
    .select("id, user_id, learning_session_id")
    .eq("id", parsed.attemptId)
    .maybeSingle();

  if (error) {
    throw new Error("learner_upload_attempt_lookup_failed");
  }

  if (
    !attempt ||
    attempt.user_id !== input.userId ||
    attempt.learning_session_id !== parsed.sessionId
  ) {
    return { ok: false as const, error: "forbidden_path" };
  }

  return {
    ok: true as const,
    objectId,
    subject: {
      path_user_id: parsed.userId,
      learning_session_id: parsed.sessionId,
      attempt_id: parsed.attemptId,
    },
  };
}

async function authorizeContentAsset(input: {
  service: ReturnType<typeof createServiceClient>;
  role: string;
  userId: string;
  path: string;
  mode: StorageMode;
  body: Record<string, unknown>;
}) {
  const parsed = parseContentAssetPath(input.path);
  if (!parsed) {
    return { ok: false as const, error: "invalid_content_asset_path" };
  }

  if (input.mode === "sign_delete" && input.role !== "admin") {
    return { ok: false as const, error: "forbidden" };
  }

  const bodyContentItemId = asUuid(
    input.body.content_item_id ?? input.body.contentItemId,
  );
  const bodyVersionId = asUuid(
    input.body.content_item_version_id ?? input.body.contentItemVersionId ??
      input.body.version_id,
  );
  if (
    (bodyContentItemId && bodyContentItemId !== parsed.contentItemId) ||
    (bodyVersionId && bodyVersionId !== parsed.versionId)
  ) {
    return { ok: false as const, error: "content_asset_reference_mismatch" };
  }

  const objectId = await requireExistingObjectForReadOrDelete(
    input.service,
    "content-assets",
    input.path,
    input.mode,
  );

  // Asset uploads attach to an existing draft created by admin-content.create_draft.
  const [
    { data: item, error: itemError },
    { data: version, error: versionError },
  ] = await Promise.all([
    input.service.schema("app")
      .from("content_items")
      .select("id, exam_pack_version_id, status, created_by")
      .eq("id", parsed.contentItemId)
      .maybeSingle(),
    input.service.schema("app")
      .from("content_item_versions")
      .select("id, content_item_id, status, created_by")
      .eq("id", parsed.versionId)
      .maybeSingle(),
  ]);

  if (itemError || versionError) {
    throw new Error("content_asset_lookup_failed");
  }

  if (!item || !version || version.content_item_id !== item.id) {
    return { ok: false as const, error: "content_asset_not_found" };
  }

  const { data: examPackVersion, error: examPackVersionError } = await input
    .service.schema("app")
    .from("exam_pack_versions")
    .select("id, status")
    .eq("id", item.exam_pack_version_id)
    .maybeSingle();

  if (examPackVersionError) {
    throw new Error("content_asset_exam_pack_lookup_failed");
  }

  const isPublished = item.status === "published" &&
    version.status === "published" &&
    examPackVersion?.status === "published";
  const isContentOwner = item.created_by === input.userId ||
    version.created_by === input.userId;
  const isStaff = input.role === "admin" || input.role === "content_author";

  if (
    input.mode === "sign_download" && !isPublished &&
    !(input.role === "admin" || isContentOwner)
  ) {
    return { ok: false as const, error: "content_asset_not_published" };
  }

  if (
    input.mode === "sign_upload" &&
    !(input.role === "admin" ||
      (input.role === "content_author" && isContentOwner))
  ) {
    return { ok: false as const, error: "forbidden" };
  }

  if (!isPublished && !isStaff) {
    return { ok: false as const, error: "forbidden" };
  }

  return {
    ok: true as const,
    objectId,
    subject: {
      content_item_id: item.id,
      content_item_version_id: version.id,
      exam_pack_version_id: item.exam_pack_version_id,
      published: isPublished,
    },
  };
}

async function loadArtifactType(
  service: ReturnType<typeof createServiceClient>,
  artifactVersionId: string,
) {
  const { data, error } = await service.schema("app")
    .from("artifact_versions")
    .select("artifact_version_id, artifact_type")
    .eq("artifact_version_id", artifactVersionId)
    .maybeSingle();

  if (error) {
    throw new Error("validation_artifact_lookup_failed");
  }

  return typeof data?.artifact_type === "string" ? data.artifact_type : null;
}

async function authorizeValidationArtifact(input: {
  service: ReturnType<typeof createServiceClient>;
  role: string;
  userId: string;
  path: string;
  mode: StorageMode;
  body: Record<string, unknown>;
}) {
  const parsed = parseValidationArtifactPath(input.path);
  if (!parsed) {
    return { ok: false as const, error: "invalid_validation_artifact_path" };
  }

  const objectId = await requireExistingObjectForReadOrDelete(
    input.service,
    "validation-artifacts",
    input.path,
    input.mode,
  );

  if (input.role === "admin") {
    return {
      ok: true as const,
      objectId,
      subject: {
        artifact_type: parsed.artifactType,
        scope_id: parsed.scopeId,
      },
    };
  }

  if (input.role !== "validator" || input.mode === "sign_delete") {
    return { ok: false as const, error: "forbidden" };
  }

  // Validator uploads/downloads are scoped to an assigned/opened review.
  const assignmentId = asUuid(
    input.body.assignment_id ?? input.body.assignmentId,
  );
  const requestedArtifactVersionId = asUuid(
    input.body.artifact_version_id ?? input.body.artifactVersionId,
  );

  let assignment: Record<string, unknown> | null = null;
  if (assignmentId) {
    const { data, error } = await input.service.schema("app")
      .from("review_assignments")
      .select(
        "assignment_id, artifact_version_id, assigned_reviewer_id, status",
      )
      .eq("assignment_id", assignmentId)
      .maybeSingle();

    if (error) {
      throw new Error("validation_artifact_assignment_lookup_failed");
    }
    assignment = data;
  } else if (requestedArtifactVersionId) {
    const { data, error } = await input.service.schema("app")
      .from("review_assignments")
      .select(
        "assignment_id, artifact_version_id, assigned_reviewer_id, status",
      )
      .eq("artifact_version_id", requestedArtifactVersionId)
      .eq("assigned_reviewer_id", input.userId)
      .in("status", Array.from(activeReviewStatuses))
      .limit(1)
      .maybeSingle();

    if (error) {
      throw new Error("validation_artifact_assignment_lookup_failed");
    }
    assignment = data;
  }

  if (
    !assignment ||
    assignment.assigned_reviewer_id !== input.userId ||
    !activeReviewStatuses.has(String(assignment.status))
  ) {
    return { ok: false as const, error: "validation_assignment_required" };
  }

  const artifactVersionId = asUuid(assignment.artifact_version_id);
  if (!artifactVersionId) {
    return { ok: false as const, error: "validation_assignment_required" };
  }

  const artifactType = await loadArtifactType(input.service, artifactVersionId);
  if (!artifactType || artifactType !== parsed.artifactType) {
    return {
      ok: false as const,
      error: "validation_artifact_reference_mismatch",
    };
  }

  return {
    ok: true as const,
    objectId,
    subject: {
      assignment_id: assignment.assignment_id,
      artifact_version_id: artifactVersionId,
      artifact_type: artifactType,
      scope_id: parsed.scopeId,
    },
  };
}

async function authorizeStorageRequest(input: {
  service: ReturnType<typeof createServiceClient>;
  role: string;
  userId: string;
  bucket: StorageBucket;
  path: string;
  mode: StorageMode;
  body: Record<string, unknown>;
}) {
  if (input.bucket === "learner-uploads") {
    return await authorizeLearnerUpload(input);
  }

  if (input.bucket === "content-assets") {
    return await authorizeContentAsset(input);
  }

  return await authorizeValidationArtifact(input);
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return jsonResponse({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return jsonResponse({ error: "invalid_json" }, { status: 400 });
  }

  const mode = asString((body as Record<string, unknown>).mode) as
    | StorageMode
    | null;
  if (!mode || !allowedModes.has(mode)) {
    return jsonResponse({ error: "invalid_mode" }, { status: 400 });
  }

  const bodyRecord = body as Record<string, unknown>;
  const bucket = asString(bodyRecord.bucket) as StorageBucket | null;
  const path = asString((body as Record<string, unknown>).path);
  const idempotencyKey = asString(
    (body as Record<string, unknown>).idempotency_key ??
      (body as Record<string, unknown>).idempotencyKey ??
      (body as Record<string, unknown>).request_id ??
      (body as Record<string, unknown>).requestId,
  );
  const expiresIn = asInteger((body as Record<string, unknown>).expires_in) ??
    3600;

  if (
    !bucket || !allowedBuckets.has(bucket) || !path || !isSafeStoragePath(path)
  ) {
    return jsonResponse({ error: "invalid_bucket_or_path" }, { status: 400 });
  }

  if (!idempotencyKey) {
    return jsonResponse({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await loadProfile(req);
  if (!profileResult) {
    return jsonResponse({ error: "unauthorized" }, { status: 401 });
  }

  const role = profileResult.profile.role as string;
  const userId = profileResult.user.id;
  const service = createServiceClient();
  const requestHash = await sha256Hex(JSON.stringify(body));

  let authorization: Awaited<ReturnType<typeof authorizeStorageRequest>>;
  try {
    authorization = await authorizeStorageRequest({
      service,
      role,
      userId,
      bucket,
      path,
      mode,
      body: bodyRecord,
    });
  } catch (error) {
    const message = error instanceof Error
      ? error.message
      : "storage_authorization_failed";
    return jsonResponse(
      {
        status: "failed",
        function: "storage-sign-url",
        mode,
        error: message === "storage_object_lookup_failed" ||
            message === "storage_object_not_found" ||
            message === "learner_upload_attempt_lookup_failed" ||
            message === "content_asset_lookup_failed" ||
            message === "content_asset_exam_pack_lookup_failed" ||
            message === "validation_artifact_lookup_failed" ||
            message === "validation_artifact_assignment_lookup_failed"
          ? message
          : "storage_authorization_failed",
      },
      { status: message === "storage_object_not_found" ? 404 : 500 },
    );
  }

  if (!authorization.ok) {
    return jsonResponse({ error: authorization.error }, { status: 403 });
  }

  const { data: existing, error: existingError } = await service.schema("app")
    .from("audit_events")
    .select("request_id, reason_code, metadata")
    .eq("request_id", idempotencyKey)
    .eq("reason_code", mode)
    .maybeSingle();

  if (existingError) {
    return jsonResponse({ error: "storage_audit_lookup_failed" }, {
      status: 500,
    });
  }

  if (existing) {
    const metadata = existing.metadata && typeof existing.metadata === "object"
      ? existing.metadata as Record<string, unknown>
      : null;
    if (!metadata || metadata.request_hash !== requestHash) {
      return jsonResponse({ error: "idempotency_conflict" }, { status: 409 });
    }

    // Replays return the originally minted URL and its original expiry.
    return jsonResponse(
      {
        status: "ok",
        function: "storage-sign-url",
        mode,
        result: metadata.result ?? null,
      },
      { status: 200 },
    );
  }

  const storage = service.storage.from(bucket);

  try {
    if (mode === "sign_delete") {
      if (role !== "admin") {
        return jsonResponse({ error: "forbidden" }, { status: 403 });
      }

      const { error: deleteError } = await storage.remove([path]);
      if (deleteError) {
        throw new Error("storage_delete_failed");
      }

      const result = {
        bucket,
        path,
        deleted: true,
      };

      await service.schema("app").from("audit_events").insert({
        audit_event_id: crypto.randomUUID(),
        occurred_at: new Date().toISOString(),
        actor_type: "human",
        actor_id: userId,
        action: "storage_sign_url.sign_delete",
        object_type: "storage_object",
        object_id: authorization.objectId ??
          await syntheticStorageObjectId(bucket, path),
        request_id: idempotencyKey,
        reason_code: mode,
        metadata: {
          request_hash: requestHash,
          authorization: authorization.subject,
          result,
        },
        event_sha256: await sha256Hex(
          JSON.stringify({ mode, requestHash, result }),
        ),
        created_at: new Date().toISOString(),
      });

      return jsonResponse(
        {
          status: "ok",
          function: "storage-sign-url",
          mode,
          result,
        },
        { status: 200 },
      );
    }

    if (mode === "sign_download") {
      const { data, error } = await storage.createSignedUrl(
        path,
        Math.max(60, Math.min(expiresIn, 86400)),
      );
      if (error || !data?.signedUrl) {
        throw new Error("storage_sign_download_failed");
      }

      const result = {
        bucket,
        path,
        signed_url: data.signedUrl,
        expires_in: Math.max(60, Math.min(expiresIn, 86400)),
      };

      await service.schema("app").from("audit_events").insert({
        audit_event_id: crypto.randomUUID(),
        occurred_at: new Date().toISOString(),
        actor_type: "human",
        actor_id: userId,
        action: "storage_sign_url.sign_download",
        object_type: "storage_object",
        object_id: authorization.objectId ??
          await syntheticStorageObjectId(bucket, path),
        request_id: idempotencyKey,
        reason_code: mode,
        metadata: {
          request_hash: requestHash,
          authorization: authorization.subject,
          result: {
            bucket,
            path,
            expires_in: result.expires_in,
          },
        },
        event_sha256: await sha256Hex(
          JSON.stringify({ mode, requestHash, result }),
        ),
        created_at: new Date().toISOString(),
      });

      return jsonResponse(
        {
          status: "ok",
          function: "storage-sign-url",
          mode,
          result,
        },
        { status: 200 },
      );
    }

    const { data, error } = await storage.createSignedUploadUrl(path);
    if (error || !data?.signedUrl || !data?.token) {
      throw new Error("storage_sign_upload_failed");
    }

    const result = {
      bucket,
      path,
      signed_url: data.signedUrl,
      token: data.token,
      expires_in: expiresIn,
    };

    await service.schema("app").from("audit_events").insert({
      audit_event_id: crypto.randomUUID(),
      occurred_at: new Date().toISOString(),
      actor_type: "human",
      actor_id: userId,
      action: "storage_sign_url.sign_upload",
      object_type: "storage_object",
      object_id: authorization.objectId ??
        await syntheticStorageObjectId(bucket, path),
      request_id: idempotencyKey,
      reason_code: mode,
      metadata: {
        request_hash: requestHash,
        authorization: authorization.subject,
        result: {
          bucket,
          path,
          expires_in: result.expires_in,
        },
      },
      event_sha256: await sha256Hex(
        JSON.stringify({ mode, requestHash, result }),
      ),
      created_at: new Date().toISOString(),
    });

    return jsonResponse(
      {
        status: "ok",
        function: "storage-sign-url",
        mode,
        result,
      },
      { status: 200 },
    );
  } catch (error) {
    const message = error instanceof Error
      ? error.message
      : "storage_sign_url_failed";
    return jsonResponse(
      {
        status: "failed",
        function: "storage-sign-url",
        mode,
        error: message === "storage_delete_failed" ||
            message === "storage_sign_download_failed" ||
            message === "storage_sign_upload_failed"
          ? message
          : "storage_sign_url_failed",
      },
      { status: 500 },
    );
  }
});
