import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
        .test(value)
    ? value
    : null;
}

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
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

  // Admin only — tutors and readers cannot assign items.
  const profileResult = await requireProfile(req);
  if (!profileResult || profileResult.profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const b = body as Record<string, unknown>;

  const contentItemVersionId = asUuid(b.content_item_version_id);
  const reviewerAId = asUuid(b.reviewer_a_id);
  const reviewerBId = asUuid(b.reviewer_b_id);
  const reviewKind = asString(b.review_kind);
  const dueAt = asString(b.due_at);

  if (!contentItemVersionId) {
    return respond(
      { error: "missing_required_fields", required: ["content_item_version_id"] },
      { status: 400 },
    );
  }
  if (!reviewerAId || !reviewerBId) {
    return respond(
      { error: "missing_required_fields", required: ["reviewer_a_id", "reviewer_b_id"] },
      { status: 400 },
    );
  }
  if (reviewerAId === reviewerBId) {
    return respond({ error: "reviewers_must_be_distinct" }, { status: 400 });
  }
  if (!reviewKind || !["mcq", "frq"].includes(reviewKind)) {
    return respond(
      { error: "invalid_review_kind", allowed: ["mcq", "frq"] },
      { status: 400 },
    );
  }

  const service = createServiceClient();

  // Verify the content version exists.
  const { data: version, error: versionError } = await service
    .schema("app")
    .from("content_item_versions")
    .select("id, status, review_status")
    .eq("id", contentItemVersionId)
    .maybeSingle();

  if (versionError || !version) {
    return respond({ error: "content_version_not_found" }, { status: 404 });
  }

  // Verify both reviewers exist and have the tutor role.
  const { data: reviewers, error: reviewerError } = await service
    .schema("app")
    .from("profiles")
    .select("user_id, role, full_name")
    .in("user_id", [reviewerAId, reviewerBId]);

  if (reviewerError || !reviewers || reviewers.length !== 2) {
    return respond({ error: "reviewers_not_found" }, { status: 404 });
  }

  const invalidRole = reviewers.find((r) => r.role !== "tutor");
  if (invalidRole) {
    return respond(
      {
        error: "invalid_reviewer_role",
        detail: `${invalidRole.full_name} (${invalidRole.user_id}) has role '${invalidRole.role}', expected 'tutor'`,
      },
      { status: 400 },
    );
  }

  // Generate a shared blind_group_id so the two assignments are correlated
  // but neither reviewer can see the other's decision until both are submitted.
  const blindGroupId = crypto.randomUUID();

  const assignments = [
    {
      content_item_version_id: contentItemVersionId,
      reviewer_id: reviewerAId,
      review_stage: "tutor_question",
      review_kind: reviewKind,
      blind_group_id: blindGroupId,
      status: "pending",
      due_at: dueAt,
      created_by: profileResult.user.id,
    },
    {
      content_item_version_id: contentItemVersionId,
      reviewer_id: reviewerBId,
      review_stage: "tutor_question",
      review_kind: reviewKind,
      blind_group_id: blindGroupId,
      status: "pending",
      due_at: dueAt,
      created_by: profileResult.user.id,
    },
  ];

  const { data: inserted, error: insertError } = await service
    .schema("app")
    .from("content_review_assignments")
    .insert(assignments)
    .select(
      "content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, blind_group_id, status, due_at, created_at",
    );

  if (insertError) {
    // Unique constraint violation means one or both reviewers already have an
    // active assignment for this version and stage.
    if (insertError.code === "23505") {
      return respond({ error: "assignment_already_exists" }, { status: 409 });
    }
    return respond({ error: "assignment_insert_failed", detail: insertError.message }, { status: 500 });
  }

  // Set the content version's review_status to tutor_review_pending so the
  // state machine has a starting point.
  await service
    .schema("app")
    .from("content_item_versions")
    .update({ review_status: "tutor_review_pending" })
    .eq("id", contentItemVersionId)
    .is("review_status", null);

  return respond(
    {
      status: "ok",
      function: "assign-for-review",
      content_item_version_id: contentItemVersionId,
      blind_group_id: blindGroupId,
      review_kind: reviewKind,
      assignments: inserted,
    },
    { status: 201 },
  );
});
