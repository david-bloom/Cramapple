import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type StorageMode = "sign_upload" | "sign_download" | "sign_delete";

const allowedModes = new Set<StorageMode>(["sign_upload", "sign_download", "sign_delete"]);
const allowedBuckets = new Set([
  "content-assets",
  "learner-uploads",
  "validation-artifacts",
]);

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asInteger(value: unknown) {
  const parsed = Number(value);
  return Number.isInteger(parsed) ? parsed : null;
}

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(value));
  return Array.from(new Uint8Array(digest)).map((byte) => byte.toString(16).padStart(2, "0")).join("");
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

function canAccessBucket(role: string, bucket: string, mode: StorageMode) {
  if (bucket === "learner-uploads") {
    return role === "student" || role === "admin";
  }

  if (bucket === "content-assets") {
    return role === "admin" || role === "content_author";
  }

  if (bucket === "validation-artifacts") {
    return role === "admin" || role === "validator";
  }

  return mode === "sign_delete" && role === "admin";
}

function ownsLearnerPath(userId: string, path: string) {
  return path.split("/")[0] === userId;
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

  const mode = asString((body as Record<string, unknown>).mode) as StorageMode | null;
  if (!mode || !allowedModes.has(mode)) {
    return jsonResponse({ error: "invalid_mode" }, { status: 400 });
  }

  const bucket = asString((body as Record<string, unknown>).bucket);
  const path = asString((body as Record<string, unknown>).path);
  const idempotencyKey = asString(
    (body as Record<string, unknown>).idempotency_key ??
      (body as Record<string, unknown>).idempotencyKey ??
      (body as Record<string, unknown>).request_id ??
      (body as Record<string, unknown>).requestId,
  );
  const expiresIn = asInteger((body as Record<string, unknown>).expires_in) ?? 3600;

  if (!bucket || !allowedBuckets.has(bucket) || !path || !isSafeStoragePath(path)) {
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

  if (!canAccessBucket(role, bucket, mode)) {
    return jsonResponse({ error: "forbidden" }, { status: 403 });
  }

  if (bucket === "learner-uploads" && !ownsLearnerPath(userId, path)) {
    return jsonResponse({ error: "forbidden_path" }, { status: 403 });
  }

  const { data: existing, error: existingError } = await service.schema("app")
    .from("audit_events")
    .select("request_id, reason_code, metadata")
    .eq("request_id", idempotencyKey)
    .maybeSingle();

  if (existingError) {
    return jsonResponse({ error: "storage_audit_lookup_failed" }, { status: 500 });
  }

  if (existing && existing.reason_code === mode) {
    const metadata = existing.metadata && typeof existing.metadata === "object"
      ? existing.metadata as Record<string, unknown>
      : null;
    if (!metadata || metadata.request_hash !== requestHash) {
      return jsonResponse({ error: "idempotency_conflict" }, { status: 409 });
    }

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
        object_id: crypto.randomUUID(),
        request_id: idempotencyKey,
        reason_code: mode,
        metadata: {
          request_hash: requestHash,
          result,
        },
        event_sha256: await sha256Hex(JSON.stringify({ mode, requestHash, result })),
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
      const { data, error } = await storage.createSignedUrl(path, Math.max(60, Math.min(expiresIn, 86400)));
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
        event_sha256: await sha256Hex(JSON.stringify({ mode, requestHash, result })),
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
      event_sha256: await sha256Hex(JSON.stringify({ mode, requestHash, result })),
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
    const message = error instanceof Error ? error.message : "storage_sign_url_failed";
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
