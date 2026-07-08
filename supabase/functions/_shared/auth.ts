import { createAnonClient, createServiceClient } from "./supabase.ts";

export async function requireAuthedUser(req: Request) {
  const client = createAnonClient(req);
  const { data, error } = await client.auth.getUser();
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
