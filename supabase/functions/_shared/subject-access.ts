import type { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

/** Service-only explicit-user check. Unknown/error never means allowed. */
export async function checkStudyPackAccess(
  service: SupabaseClient,
  userId: string,
  versionId: string,
): Promise<{ error: string; status: number } | null> {
  const { data, error } = await service.schema("app").rpc("has_study_pack_access", {
    _user_id: userId,
    _version_id: versionId,
  });
  if (error || typeof data !== "boolean") return { error: "subject_access_lookup_failed", status: 503 };
  return data ? null : { error: "entitlement_required", status: 403 };
}
