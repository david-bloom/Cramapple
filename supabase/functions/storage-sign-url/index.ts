import { trimmedNonEmptyString as asString, coercedInteger as asInteger } from "../_shared/input.ts";
import { sha256Text as sha256Hex } from "../_shared/encoding.ts";
import { claimReplay, completeReplay, ReplayError } from "../_shared/operation-replay.ts";
import { isSafeStoragePath, ownsLearnerPath } from "../_shared/storage-paths.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import {
  canAccessBucket,
  type StorageMode,
} from "../_shared/storage-access.ts";

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









async function loadProfile(req: Request) {
  return await requireProfile(req);
}



export type StorageSignUrlDeps = {
  requireProfile?: typeof requireProfile;
  service?: ReturnType<typeof createServiceClient>;
};

export async function handleStorageSignUrl(req: Request, deps: StorageSignUrlDeps = {}): Promise<Response> {
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

  const mode = asString((body as Record<string, unknown>).mode) as
    | StorageMode
    | null;
  if (!mode || !allowedModes.has(mode)) {
    return respond({ error: "invalid_mode" }, { status: 400 });
  }

  const bucket = asString((body as Record<string, unknown>).bucket);
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
    return respond({ error: "invalid_bucket_or_path" }, { status: 400 });
  }

  if (!idempotencyKey) {
    return respond({ error: "missing_idempotency_key" }, { status: 400 });
  }

  const profileResult = await (deps.requireProfile ?? loadProfile)(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }

  const role = profileResult.profile.role as string;
  const userId = profileResult.user.id;
  const service = deps.service ?? createServiceClient();
  const requestHash = await sha256Hex(JSON.stringify(body));

  if (!canAccessBucket(role, bucket, mode)) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  // TASK-0038 Phase 4: an admin grading a real student's hand-drawn capture
  // must be able to view a learner-uploads object it does not own -- this
  // check previously had no admin exception at all, so canAccessBucket's own
  // admin clearance for "learner-uploads" was unreachable for cross-user
  // reads. Scoped to sign_download only; upload/delete stay strictly
  // owner/admin-delete as before (sign_delete is already admin-only above).
  if (
    bucket === "learner-uploads" && !ownsLearnerPath(userId, path) &&
    !(mode === "sign_download" && role === "admin")
  ) {
    return respond({ error: "forbidden_path" }, { status: 403 });
  }

  const storage = service.storage.from(bucket);

  try {
    const claim = await claimReplay(service, { actorId: userId, requestId: idempotencyKey, requestHash, operation: mode });
    // Signers are safe to repeat AFTER authorization and hash/actor validation.
    // Delete replays never perform the deletion again.
    if (claim.kind === "replay" && mode === "sign_delete") {
      return respond({ status: "ok", function: "storage-sign-url", mode, result: claim.result });
    }
    if (mode === "sign_delete") {
      if (role !== "admin") {
        return respond({ error: "forbidden" }, { status: 403 });
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

      if (claim.kind === "claimed") await completeReplay(service, claim.claimToken, {
        audit_event_id: crypto.randomUUID(),
        occurred_at: new Date().toISOString(),
        actor_type: "human",
        actor_id: userId,
        action: "storage_sign_url.sign_delete",
        object_type: "storage_object",
        object_id: crypto.randomUUID(),
        request_id: idempotencyKey,
        reason_code: mode,
        metadata: {
          request_hash: requestHash,
          result,
        },
        event_sha256: await sha256Hex(
          JSON.stringify({ mode, requestHash, result }),
        ),
        created_at: new Date().toISOString(),
      });

      return respond(
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

      if (claim.kind === "claimed") await completeReplay(service, claim.claimToken, {
        audit_event_id: crypto.randomUUID(),
        occurred_at: new Date().toISOString(),
        actor_type: "human",
        actor_id: userId,
        action: "storage_sign_url.sign_download",
        object_type: "storage_object",
        object_id: crypto.randomUUID(),
        request_id: idempotencyKey,
        reason_code: mode,
        metadata: {
          request_hash: requestHash,
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

      return respond(
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

    if (claim.kind === "claimed") await completeReplay(service, claim.claimToken, {
      audit_event_id: crypto.randomUUID(),
      occurred_at: new Date().toISOString(),
      actor_type: "human",
      actor_id: userId,
      action: "storage_sign_url.sign_upload",
      object_type: "storage_object",
      object_id: crypto.randomUUID(),
      request_id: idempotencyKey,
      reason_code: mode,
      metadata: {
        request_hash: requestHash,
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

    return respond(
      {
        status: "ok",
        function: "storage-sign-url",
        mode,
        result,
      },
      { status: 200 },
    );
  } catch (error) {
    if (error instanceof ReplayError) return respond({ error: error.code }, { status: error.status });
    const message = error instanceof Error
      ? error.message
      : "storage_sign_url_failed";
    return respond(
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
}

if (import.meta.main) Deno.serve((req) => handleStorageSignUrl(req));
