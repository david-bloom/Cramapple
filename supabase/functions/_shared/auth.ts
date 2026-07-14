import { createAnonClient, createServiceClient } from "./supabase.ts";

export function getBearerToken(req: Request) {
  const authorization = req.headers.get("Authorization") ?? "";
  const match = authorization.match(/^Bearer\s+(.+)$/i);
  return match?.[1]?.trim() || null;
}

export async function requireAuthedUser(req: Request) {
  const token = getBearerToken(req);
  if (!token) {
    return null;
  }

  const client = createAnonClient(req);
  const { data, error } = await client.auth.getUser(token);
  if (error || !data.user) {
    return null;
  }
  return data.user;
}

export async function requireProfile(req: Request) {
  const user = await requireAuthedUser(req);
  if (!user) return null;

  const service = createServiceClient();
  const { data, error } = await service
    .schema("app")
    .from("profiles")
    .select(
      "user_id, role, review_queue_scope, full_name, timezone, locale, onboarding_completed_at, created_at, updated_at",
    )
    .eq("user_id", user.id)
    .maybeSingle();

  if (error || !data) {
    return null;
  }

  return { user, profile: data };
}
