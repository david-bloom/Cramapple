import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

type ReviewerRole = "tutor" | "reader";

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
  return role === "tutor" || role === "reader" ? role : null;
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
        allowed: ["tutor", "reader"],
      },
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
  const { error: profileError } = await service.schema("app")
    .from("profiles")
    .upsert({
      user_id: authUser.id,
      full_name: profileFullName,
      role,
    }, { onConflict: "user_id" });

  if (profileError) {
    return respond(
      { error: "profile_upsert_failed", detail: profileError.message },
      { status: 500 },
    );
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
      },
      redirect_to: redirectTo,
      requested_by: profileResult.user.id,
    },
    { status: 200 },
  );
});
