import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type ReviewerRole = "tutor" | "reader" | "admin";

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asEmail(value: unknown) {
  const email = asString(value);
  if (!email) return null;
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) ? email.toLowerCase() : null;
}

function asReviewerRole(value: unknown): ReviewerRole | null {
  const role = asString(value);
  return role === "tutor" || role === "reader" || role === "admin"
    ? role
    : null;
}

const UUID_RE =
  /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/;

function asExamIds(value: unknown): string[] | null {
  if (value === undefined || value === null) return [];
  if (!Array.isArray(value)) return null;
  const ids = value.filter((v): v is string =>
    typeof v === "string" && UUID_RE.test(v)
  );
  return ids.length === value.length ? ids : null;
}

async function loadAdminProfile(req: Request) {
  const profileResult = await requireProfile(req);
  if (!profileResult) return null;
  if (profileResult.profile.role !== "admin") return null;
  return profileResult;
}

async function findAuthUserByEmail(
  service: ReturnType<typeof createServiceClient>,
  email: string,
) {
  const target = email.toLowerCase();
  const perPage = 100;

  for (let page = 1; page <= 10; page += 1) {
    const { data, error } = await service.auth.admin.listUsers({
      page,
      perPage,
    });

    if (error) {
      throw new Error(`auth_user_lookup_failed:${error.message}`);
    }

    const user = data.users.find((entry) =>
      (entry.email ?? "").toLowerCase() === target
    );
    if (user) return user;

    if (data.users.length < perPage) break;
  }

  return null;
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const profileResult = await loadAdminProfile(req);
  if (!profileResult) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const bodyRecord = body as Record<string, unknown>;
  const email = asEmail(bodyRecord.email);
  const role = asReviewerRole(bodyRecord.role);
  const fullName = asString(bodyRecord.full_name);
  const examIds = asExamIds(bodyRecord.exam_ids);
  const redirectTo = asString(bodyRecord.redirect_to) ??
    "https://cramapple.com/tutor-login";

  if (!email) {
    return respond(
      { error: "missing_required_fields", required: ["email"] },
      { status: 400 },
    );
  }

  if (!role) {
    return respond(
      {
        error: "invalid_role",
        allowed: ["tutor", "reader", "admin"],
      },
      { status: 400 },
    );
  }

  if (examIds === null) {
    return respond(
      { error: "invalid_exam_ids", detail: "exam_ids must be an array of uuids" },
      { status: 400 },
    );
  }

  const service = createServiceClient();

  let authUser = await findAuthUserByEmail(service, email);
  let inviteSent = false;

  if (!authUser) {
    const { data, error } = await service.auth.admin.inviteUserByEmail(email, {
      data: {
        full_name: fullName ?? email.split("@")[0],
        role,
      },
      redirectTo,
    });

    if (error) {
      return respond(
        { error: "invite_failed", detail: error.message },
        { status: 500 },
      );
    }

    authUser = data.user ?? null;
    inviteSent = true;

    if (!authUser) {
      authUser = await findAuthUserByEmail(service, email);
    }
  }

  if (!authUser) {
    return respond({ error: "user_not_found" }, { status: 404 });
  }

  const profileFullName = fullName ?? email.split("@")[0];
  const reviewQueueScope = role === "admin" ? "all_pending" : "my_queue";
  const { error: profileError } = await service.schema("app")
    .from("profiles")
    .upsert({
      user_id: authUser.id,
      full_name: profileFullName,
      role,
      review_queue_scope: reviewQueueScope,
    }, { onConflict: "user_id" });

  if (profileError) {
    return respond(
      { error: "profile_upsert_failed", detail: profileError.message },
      { status: 500 },
    );
  }

  if (examIds.length > 0) {
    const { data: validExamPacks, error: examPackError } = await service
      .schema("app")
      .from("exam_packs")
      .select("id")
      .in("id", examIds);

    if (examPackError) {
      return respond(
        { error: "exam_pack_lookup_failed", detail: examPackError.message },
        { status: 500 },
      );
    }

    const validIds = new Set((validExamPacks ?? []).map((r) => r.id as string));
    const unknownIds = examIds.filter((id) => !validIds.has(id));
    if (unknownIds.length > 0) {
      return respond(
        { error: "unknown_exam_ids", detail: unknownIds },
        { status: 400 },
      );
    }
  }

  // Replace any existing subject qualification for this reviewer with the
  // requested set (idempotent re-invite: last invite wins).
  const { error: qualDeleteError } = await service
    .schema("app")
    .from("validator_qualifications")
    .delete()
    .eq("reviewer_id", authUser.id)
    .eq("qualification_type", "grading");

  if (qualDeleteError) {
    return respond(
      { error: "qualification_update_failed", detail: qualDeleteError.message },
      { status: 500 },
    );
  }

  if (examIds.length > 0) {
    const { error: qualInsertError } = await service
      .schema("app")
      .from("validator_qualifications")
      .insert({
        reviewer_id: authUser.id,
        qualification_type: "grading",
        exam_ids: examIds,
        status: "active",
        granted_by: profileResult.user.id,
        granted_at: new Date().toISOString(),
        effective_at: new Date().toISOString(),
        // No expiration policy is defined yet for tutor subject
        // qualifications; use a far-future sentinel since the column is
        // NOT NULL. Revisit once a real qualification-policy framework
        // (qualification_policy_version_id) exists.
        expires_at: new Date(
          Date.now() + 100 * 365 * 24 * 60 * 60 * 1000,
        ).toISOString(),
        qualification_policy_version_id: crypto.randomUUID(),
      });

    if (qualInsertError) {
      return respond(
        { error: "qualification_update_failed", detail: qualInsertError.message },
        { status: 500 },
      );
    }
  }

  return respond(
    {
      status: "ok",
      function: "reviewer-invite",
      invite_sent: inviteSent,
      user: {
        user_id: authUser.id,
        email: authUser.email,
      },
      profile: {
        user_id: authUser.id,
        role,
        full_name: profileFullName,
        review_queue_scope: reviewQueueScope,
      },
      exam_ids: examIds,
      redirect_to: redirectTo,
      requested_by: profileResult.user.id,
    },
    { status: 200 },
  );
});
